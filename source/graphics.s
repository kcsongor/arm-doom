.globl vertical_line
.globl render_screen
.globl ytops
.globl ybottoms
.globl sector_queue_tail_ptr
.globl has_filled
.globl floor_colour

.section .data
.align 4
current_neighbour_ptr:
  .int 0
.align 4
ytops:
  .skip 640 * 4
ybottoms:
  .skip 640 * 4 
floor_colour:
  .int -1
/* ------------------------------------------------------- */
.align 4
/* 
  32: size of queue,
  3 * 4: size of structs on queue (each member is 4 bytes)
    - sector address
    - left  x (screen coord - clipping)
    - right x (screen coord - clipping)
*/
sector_queue:
  .skip 32 * 3 * 4
/* The first address that doesn't belong to the render queue */
sector_queue_overflow: 
/* Pointers to the render queue */
sector_queue_head_ptr:
  .int sector_queue
sector_queue_tail_ptr:
  .int sector_queue
/* ------------------------------------------------------- */
.align 4
/* 
  128: size of stack,
  7 * 4: size of structs on stack (each member is 4 bytes)
    - thing sector
    - thing address
    - middle bottom x (screen coord - position)
    - middle bottom y (screen coord - position)
    - top    y (screen coord - clipping)
    - bottom y (screen coord - clipping)
    - scale    (float -- IEEE)
*/
thing_stack:
  .skip 128 * 7 * 4
thing_stack_overflow:
thing_stack_ptr:
  .int thing_stack

has_filled:
  .int 0
/* ------------------------------------------------------- */


.section .text
/*
  Draw a vertical line on screen
  NOTE: screen width is hardcoded
  r0 : x
  r1 : y1
  r2 : y2
  r5 : colour
*/
vertical_line:
  push {r0-r9}
  x .req r0
  y1 .req r1
  y2 .req r2
  colour .req r5

  cmp y1, y2
  bge 2f
  /* clamp r1 */
  cmp y1, #0
  movlt y1, #0
  cmp y1, #480
  movgt y1, #480
  subgt y1, #1

  /* clamp r2 */
  cmp y2, #0
  movlt y2, #0
  cmp y2, #480
  movgt y2, #480
  subgt y2, #1

  /* Load framebuffer location into r3 */
  frame_buffer .req r3
  ldr frame_buffer, =back_buffer
  original_y1 .req r6 
  mov original_y1, y1

  /* Calculate screen position */
  mov y1, original_y1
  add y1, y1, y1, lsl #2  @|y1 = y1 * 5
  lsl y1, #8
  add y1, x, lsl #1
  .unreq x 

  pixel_counter .req r0
  sub pixel_counter, y2, original_y1          @|pixel_counter = y2 - y1
  top .req original_y1
  .unreq original_y1
  mov top, pixel_counter
  zero .req y2
  .unreq y2
  mov zero, #0

1:
    cmp pixel_counter, #1
    cmp pixel_counter, top
    strneh r5, [frame_buffer, y1]
    streqh zero, [frame_buffer, y1]

    add y1, #1280
    sub pixel_counter, #1
    cmp pixel_counter, #0
  bge 1b
2:

  .unreq zero 
  .unreq top
  .unreq pixel_counter 
  .unreq y1 
  .unreq colour 
  .unreq frame_buffer 

  pop {r0-r9}
mov pc, lr

/*
  Initialise arrays, stacks and queues for the rendering
*/
render_init:
//TODO
mov pc, lr

/*
  Renders screen
  params:
    none
  returns:
    none
  clobbers:
    ALL!
*/
render_screen:
   push {lr}

   bl render_init
   y_reset_position .req r0
   y_reset_pointer .req r1
   default_value .req r2

     //TODO: BDT would speed this up
     //also, tops and bottoms could be reset at once
     //also, move to separate function
     ldr y_reset_pointer, =ytops
     mov y_reset_position, #640
     lsl y_reset_position, #2

     mov default_value, #0

     reset_tops:
       sub y_reset_position, #4
       str default_value, [y_reset_pointer, y_reset_position]
       cmp y_reset_position, #0
       bhi reset_tops

     ldr y_reset_pointer, =ybottoms
     mov y_reset_position, #640
     lsl y_reset_position, #2

     mov default_value, #400
     add default_value, #2

     reset_bottoms:
       sub y_reset_position, #4
       str default_value, [y_reset_pointer, y_reset_position]
       cmp y_reset_position, #0
       bhi reset_bottoms

   .unreq y_reset_position
   .unreq y_reset_pointer
   .unreq default_value
   /* All registers free */

   /* Set thing stack pointer to the bottom of the stack */
   ldr r2, =thing_stack_ptr
   ldr r3, =thing_stack
   str r3, [r2]

   /* int* sector_queue_tail = sector_queue */
   sector_queue .req r2
   sector_queue_tail_ptr .req r1

   ldr sector_queue_tail_ptr, =sector_queue_tail_ptr
   ldr sector_queue, =sector_queue
   str sector_queue, [sector_queue_tail_ptr]

   sector_queue_head_ptr .req sector_queue_tail_ptr
   .unreq sector_queue_tail_ptr

   ldr sector_queue_head_ptr, =sector_queue_head_ptr
   str sector_queue, [sector_queue_head_ptr]
   /* Get address the head pointer points to */
   ldr sector_queue_head_ptr, [sector_queue_head_ptr] 
   .unreq sector_queue

   /* Put the player's current sector in the queue as the head (first) */
   sector_address .req r2
   sector_start_x .req r3
   sector_end_x .req r4

   /* The queue pointer points to the position we're writing to: the head */
   queue_ptr .req r0
   mov queue_ptr, sector_queue_head_ptr

   ldr sector_address, =player_sector
   ldr sector_address, [sector_address]

   /* The current sector occupies the whole screen */
   mov sector_start_x, #0
   mov sector_end_x, #640
   sub sector_end_x, #1

   stmia queue_ptr!, {sector_address, sector_start_x, sector_end_x}
   sector_queue_head_addr .req sector_queue_head_ptr
   .unreq sector_queue_head_ptr

   /* Store the new queue position as the new head of the queue */
   ldr sector_queue_head_addr, =sector_queue_head_ptr
   str queue_ptr, [sector_queue_head_addr]

   .unreq queue_ptr 

   /* End of variable setup */

   /* Render sectors */
   render_sector:
   tmp .req r1
   tmp2 .req r0
   tmp_f .req s9
   player_ptr .req r4
   ldr player_ptr, =player

   /* Get next sector from queue */
   sect_ptr .req r2
   push {r3, r4, r9}

     sector_queue_tail_ptr .req r9
     ldr sector_queue_tail_ptr, =sector_queue_tail_ptr
     ldr sector_queue_tail_ptr, [sector_queue_tail_ptr]
     mov tmp, sector_queue_tail_ptr
     /*
       Get the current sector.
       For now, we don't care about the other two parameters
       TODO: this is not nice
       ldr sect_ptr, [tmp] ?
       add tmp, #12 ?
       str tmp, [sector_queue_tail_addr]
     */
     ldm tmp!, {sect_ptr, r3, r4}   /* r3 and r4 are 'not cares' */
     sector_queue_tail_addr .req sector_queue_tail_ptr
     .unreq sector_queue_tail_ptr
     ldr sector_queue_tail_addr, =sector_queue_tail_ptr
     str tmp, [sector_queue_tail_addr]
     .unreq sector_queue_tail_addr

     ldr tmp, =floor_colour
     ldr r4, [sect_ptr, #20]
     str r4, [tmp]

   pop {r3, r4, r9}
   /* ------------------------------------------------------------------ */
   /* Put things and enemies on their render stack */

   /*
      tmp is r1
      sect_ptr is r2
      player_ptr is r4
   */
   pcos .req s17
   psin .req s18

   vldr.f32 psin, [player_ptr, #28]               
   vldr.f32 pcos, [player_ptr, #32]
    
   thing_vx .req s10
   thing_vy .req s13
   /* Init vars done */

   @| r5
   for_sector_thing_counter .req r5

   @| r6
   thing_ptr .req r6
   ldr thing_ptr, [sect_ptr, #12]


    /* Sort things by distance - nearest to farthest */
    push {r0-r4}
    vpush {s0-s1}
      
      j .req r3
      i .req r1
      key .req r2

      mov j, #1
      for_j$:
        cmp j, #10
        beq end_for_j$
        add key, thing_ptr, j, lsl #2
        ldr key, [key]
        mov i, j
        sub i, #1
        for_i$:
          cmp i, #0
          blt end_for_i$
          add r0, thing_ptr, i, lsl #2
          ldr r0, [r0]
          bl enemy_distance_from_player
          vmov s1, s0                        @ s1 = distance(e[i])
          mov r0, key 
          bl enemy_distance_from_player      @ s0 = distance(tmp)
          vcmp.f32 s1, s0
          vmrs APSR_nzcv, FPSCR         @ transfer floating point flags
          blt end_for_i$
            add r0, thing_ptr, i, lsl #2
            mov r4, r0
            add r4, #4
            ldr r0, [r0]
            str r0, [r4]
          sub i, #1
          b for_i$
        end_for_i$:
        add r4, thing_ptr, i, lsl #2
        add r4, #4
        str key, [r4]
        add j, #1
        b for_j$
      end_for_j$:
      
      .unreq i
      .unreq j
      .unreq key
    vpop {s0-s1}
    pop {r0-r4}

   mov for_sector_thing_counter, #10

   for_sector_things:

   @| r3
   thing .req r3
   ldr thing, [thing_ptr]
   cmp thing, #0
   beq next_thing

   ldr tmp, [thing, #4]               @| thing.x
   vmov thing_vx, tmp
   vldr.f32 tmp_f, [player_ptr]
   vsub.f32 thing_vx, tmp_f

   ldr tmp, [thing, #8]           @| thing.y
   vmov thing_vy, tmp
   vldr.f32 tmp_f, [player_ptr, #4]
   vsub.f32 thing_vy, tmp_f

   thing_tx .req thing_vx
   .unreq thing_vx 
   thing_tz .req s12

   vmov thing_tz, thing_tx   @| tz = tx

   /* tx = vx * psin - vy * pcos */
   vmul.f32 thing_tx, psin
   vmov tmp_f, thing_vy
   vmul.f32 tmp_f, pcos
   vsub.f32 thing_tx, tmp_f

   /* tz = vx * pcos + vy * psin */
   vmul.f32 thing_tz, pcos
   vmov.f32 tmp_f, thing_vy
   vmul.f32 tmp_f, psin
   vadd.f32 thing_tz, tmp_f
   /* check if translated z coordinate is behind player */
   vcmp.f32 thing_tz, #0
   vmrs apsr_nzcv, fpscr
   blt next_thing

   xscale .req thing_vy
   yscale .req s14

   ldr tmp, =fov
   vldr.f32 xscale, [tmp]
   vdiv.f32 xscale, xscale, thing_tz
   vldr.f32 yscale, [tmp, #4]
   vdiv.f32 yscale, yscale, thing_tz

   thing_x .req r7
   vmul.f32 tmp_f, xscale, thing_tx
   vcvt.s32.f32 tmp_f, tmp_f 
   vmov.f32 thing_x, tmp_f
   rsb thing_x, #320

   cmp thing_x, #0
   blt next_thing
   /* only render if it's visible */

   yfloor .req s26
   vldr.f32 yfloor, [sect_ptr]
   vldr.f32 tmp_f, [player_ptr, #8]
   vsub.f32 yfloor, tmp_f

   thing_y .req r8
   vmul.f32 tmp_f, yscale, yfloor
   vcvt.s32.f32 tmp_f, tmp_f
   vmov.f32 thing_y, tmp_f
   rsb thing_y, #240

   /* Push thing on the render stack */
   vpush {s0}
   push {r0-r12}
    ldr tmp, =sector_queue_tail_ptr
    ldr tmp, [tmp]
    sub tmp, #12
    ldm tmp, {sect_ptr, r11, r12}
    cmp thing_x, r11
    blt thing_pushed 
    cmp thing_x, r12
    bgt thing_pushed

    /* Scaling, using magic */
    ldr r0, =0x41800000
    vmov s0, r0
    vdiv.f32 s0, s0, thing_tz
    vmov r12, s0 

    /* Get clipping value */
    ldr tmp, =ybottoms
    ldr tmp, [tmp, thing_x, lsl #2]
    mov r11, tmp
    mov r10, #0

    @| r2  - sect_ptr
    @| r3  - thing
    @| r7  - thing_x (screen)
    @| r8  - thing_y (screen)
    @| r10 - top_x  TODO: this is #0 now
    @| r11 - bottom_x
    @| r12 - scale

    ldr tmp, =thing_stack_ptr
    ldr r9, [tmp]

    /* Check overflow */
    ldr r0, =thing_stack_overflow
    cmp r9, r0
    beq bsod
    blo no_thing_stack_overflow
      pop {r0-r2, r10, r11, r12}
      vpop {s0}
      /*TODO: wrong pops*/
      b next_sector

    no_thing_stack_overflow:
    /* Push stuff up the stack and save new stack pointer */
    stmia r9!, {r2, r3, r7, r8, r10, r11, r12}
    str  r9, [tmp]
    thing_pushed:

   pop {r0-r12}
   vpop {s0}

   next_thing:
   add thing_ptr, #4                                             @| next thing

   sub for_sector_thing_counter, #1
   cmp for_sector_thing_counter, #0
   bgt for_sector_things

   vertex_array .req r3
   mov vertex_array, sect_ptr
   add vertex_array, #32                         /* sector->vertexes (ptr) */

   /* Store first neighbour's address */
   mov tmp2, sect_ptr
   ldr tmp2, [tmp2, #8]
   ldr tmp, =current_neighbour_ptr
   str tmp2, [tmp]

   /* Draw walls */

   /* for(unsigned s = 0; s < sect->sidec; ++s) */
   for_sector_edges_counter .req r5
   ldr for_sector_edges_counter, [sect_ptr, #28]  /* sector->sidec */

   for_sector_edges:
     /* Acquire the x,y coordinates of the two endpoints (vertices) of this
        edge of the sector */
     vx1 .req s10
     vy1 .req s11
     vx2 .req s12
     vy2 .req s13

     ldr tmp, [vertex_array]                        @| sector->vertexes[s+0]
     vldr.f32 vx1, [tmp]                            @| sector->vertexes[s+0].x
     vldr.f32 vy1, [tmp, #4]                        @| sector->vertexes[s+0].y

     ldr tmp, [vertex_array, #4]                    @| sector->vertexes[s+1]
     vldr.f32 vx2, [tmp]                            @| sector->vertexes[s+1].x
     vldr.f32 vy2, [tmp, #4]                        @| sector->vertexes[s+1].y

     vldr.f32 tmp_f, [player_ptr]                   @| player->pos_x
     vsub.f32 vx1, tmp_f                            @| vx1 - player->pos_x
     vsub.f32 vx2, tmp_f                            @| vx2 - player->pos_x 

     vldr.f32 tmp_f, [player_ptr, #4]               @| player->pos_y
     vsub.f32 vy1, tmp_f                            @| vy1 - player->pos_y
     vsub.f32 vy2, tmp_f                            @| vy2 - player->pos_y 

     add vertex_array, #4                           @| s++
     /* ------------------------------------------------------------------ */
     /* Rotate coords around the player's view */
     tx1 .req vx1
     tz1 .req s15
     tx2 .req vx2
     tz2 .req s16

     .unreq vx1
     .unreq vx2
     tx1_orig .req s28
     tz1_orig .req s29
     tx2_orig .req s30
     tz2_orig .req s31

     pcos .req s17
     psin .req s18

     vldr.f32 psin, [player_ptr, #28]               
     vldr.f32 pcos, [player_ptr, #32]

     vmov.f32 tz1, tx1                              @| tz1 = vx1
     vmov.f32 tz2, tx2                              @| tz2 = vx2

     /* tx1 = vx1 * psin - vy1 * pcos */
     vmul.f32 tx1, psin
     vmov.f32 tmp_f, vy1
     vmul.f32 tmp_f, pcos
     vsub.f32 tx1, tmp_f

     /* tz1 = vx1 * pcos + vy1 * psin */
     vmul.f32 tz1, pcos
     vmov.f32 tmp_f, vy1
     vmul.f32 tmp_f, psin
     vadd.f32 tz1, tmp_f

     /* tx2 = vx2 * psin - vy2 * pcos */
     vmul.f32 tx2, psin
     vmov.f32 tmp_f, vy2
     vmul.f32 tmp_f, pcos
     vsub.f32 tx2, tmp_f
     
     /* tz2 = vx2 * pcos + vy2 * psin */
     vmul.f32 tz2, pcos
     vmov.f32 tmp_f, vy2
     vmul.f32 tmp_f, psin
     vadd.f32 tz2, tmp_f

     /* Save original transformed coord values for the textures later */
     vmov tx1_orig, tx1
     vmov tz1_orig, tz1
     vmov tx2_orig, tx2
     vmov tz2_orig, tz2

     /* If both z coordinates are behind the player, skip */
     vcmp.f32   tz1, #0
     vmrs APSR_nzcv, FPSCR
     vcmple.f32 tz2, #0
     vmrs APSR_nzcv, FPSCR
     ble next_for_sector_edges 

     /* If it's partially behind the player, clip it against player's view frustum */
     /* if(tz1 <= 0 || tz2 <= 0) */
     vcmp.f32 tz1, #0
     vmrs APSR_nzcv, FPSCR
     vcmpgt.f32 tz2, #0
     vmrs APSR_nzcv, FPSCR
     bgt end_partially_behind

         /*
            Find an intersection between the wall and the approximate edges of
            player's view
         */
         nearside .req s5
         nearz    .req s6
         farside  .req s7
         farz     .req s8


         ldr tmp, =0x38d1b717
         vmov nearz,    tmp             @| float nearz    = 1e-4;

         ldr tmp, =0x40a00000
         vmov farz,     tmp             @| float farz     = 5

         ldr tmp, =0x3727c5ac
         vmov nearside, tmp             @| float nearside = 1e-5;

         ldr tmp, =0x41a00000
         vmov farside,  tmp             @| float farside  = 20;

         i1_x .req vy1
         i2_x .req vy2
         i1_y .req psin
         i2_y .req pcos
     
         .unreq vy1
         .unreq vy2
         .unreq psin
         .unreq pcos

         /*
           Intersect(tx1,tz1,tx2,tz2,nearside,nearz,farside,farz);
         */
         vmov.f32 s1, tx1
         vmov.f32 s2, tz1
         vmov.f32 s3, tx2
         vmov.f32 s4, tz2
         bl intersection_f

         vmov.f32 i2_x, s0
         vmov.f32 i2_y, s1

         /*
           Intersect(tx1,tz1,tx2,tz2,-nearside,nearz,-farside,farz);
         */
         vmov.f32 s1, tx1                                @| s1 was clobbered
         vneg.f32 nearside, nearside                              @| -nearside
         vneg.f32 farside, farside                                @| -farside
         bl intersection_f
         
         vmov.f32 i1_x, s0
         vmov.f32 i1_y, s1

         /* don't reuse */
         .unreq farz     
         .unreq nearside 
         .unreq farside  

         /*TODO: I'm 99% sure the graphics glitches happen here */
         /* if(tz1 < nearz) */
         vcmp.f32 tz1, nearz
         vmrs APSR_nzcv, FPSCR
         bge end_tz1_nearz_if
           /* if(i1.y > 0) */
             vcmp.f32 i1_y, #0
             vmrs APSR_nzcv, FPSCR
             ble else_tz1_i1y_if

             vmov.f32 tx1, i1_x                                 @| tx1 = i1.x;
             vmov.f32 tz1, i1_y                                 @| tz1 = i1.y;

             b end_tz1_nearz_if
           /* else */
             else_tz1_i1y_if:
             vmov.f32 tx1, i2_x                                 @| tx1 = i2.x;
             vmov.f32 tz1, i2_y                                 @| tz1 = i2.y;
         end_tz1_nearz_if:

         /* if(tz2 < nearz) */
         vcmp.f32 tz2, nearz
         vmrs APSR_nzcv, FPSCR
         bge end_tz2_nearz_if
           /* if(i1.y > 0) */
             vcmp.f32 i1_y, #0
             vmrs APSR_nzcv, FPSCR
             ble else_tz2_i1y_if

             vmov.f32 tx2, i1_x                                 @| tx2 = i1.x;
             vmov.f32 tz2, i1_y                                 @| tz2 = i1.y;

             b end_tz2_nearz_if
           /* else */
             else_tz2_i1y_if:
             vmov.f32 tx2, i2_x                                 @| tx2 = i2.x;
             vmov.f32 tz2, i2_y                                 @| tz2 = i2.y;
         end_tz2_nearz_if:

         /* don't reuse */
         .unreq nearz    

     end_partially_behind:
     @bl bsod
     /* ------------------------------------------------------------------ */

     xscale1 .req i1_x
     yscale1 .req i2_x
     xscale2 .req i1_y
     yscale2 .req i2_y
     .unreq i1_x
     .unreq i2_x
     .unreq i1_y
     .unreq i2_y

     /* Do perspective transformation */
     ldr tmp, =fov
     vldr.f32 xscale1, [tmp]                                 @| xscale1 = hfov
     vmov.f32 xscale2, xscale1                               @| xscale2 = hfov
     vldr.f32 yscale1, [tmp, #4]                             @| yscale1 = vfov
     vmov.f32 yscale2, yscale1                               @| yscale2 = vfov

     /* float xscale1 = hfov / tz1; */
     vdiv.f32 xscale1, xscale1, tz1

     /* float yscale1 = vfov / tz1; */
     vdiv.f32 yscale1, yscale1, tz1

     /* float xscale2 = hfov / tz2; */
     vdiv.f32 xscale2, xscale2, tz2

     /* float yscale2 = vfov / tz2; */
     vdiv.f32 yscale2, yscale2, tz2

     /* int x1 = W/2 - (int)(tx1 * xscale1); */
     x1 .req r6
     mov x1, #320                                      @| W/2
     vmul.f32 xscale1, tx1
     vcvt.s32.f32 tmp_f, xscale1                       @| (int)(tx1 * xscale1)
     vmov.f32 tmp, tmp_f
     sub x1, tmp

     /* int x2 = W/2 - (int)(tx2 * xscale2); */
     x2 .req r7
     mov x2, #320                                      @| W/2
     vmul.f32 xscale2, tx2
     vcvt.s32.f32 tmp_f, xscale2                       @| (int)(tx2 * xscale2)
     vmov.f32 tmp, tmp_f
     sub x2, tmp

     /* Only render if it's visible */
     cmp x1, x2
     bge next_for_sector_edges
     cmp x2, #0
     blt next_for_sector_edges
     mov tmp, #640
     cmp x1, tmp
     bge next_for_sector_edges

     /* Acquire the floor and ceiling heights, relative to where the player's
        view is */

     yceil .req s27
     /* float yceil  = sect->ceil  - player.where.z; */
     vldr.f32 yceil, [sect_ptr, #4]                          @| sect->ceil
     vldr.f32 tmp_f, [player_ptr, #8]                        @| player->pos_z

     vsub.f32 yceil, tmp_f
     
     /* float yfloor = sect->floor - player.where.z; */
     vldr.f32 yfloor, [sect_ptr]                             @| sect->floor
     vsub.f32 yfloor, tmp_f

     /*
       current_neighbour_ptr points to the address of 
       the neighbouring sector, i.e. is a double pointer
       => we need to dereference it twice
     */
     ldr tmp, =current_neighbour_ptr 
     ldr tmp, [tmp]                      @| tmp = current_neighbour_addr
     ldr tmp, [tmp]
     /* if(neighbor >= 0) Is another sector showing through this portal? */
     cmp tmp, #-1
     beq end_if_has_neighbour1
       nyceil .req s19
       nyfloor .req s20

       /* nyceil  = sectors[neighbor].ceil  - player.where.z; */
       vldr.f32 nyceil, [tmp, #4]
       vsub.f32 nyceil, tmp_f
       /* nyfloor = sectors[neighbor].floor - player.where.z; */
       vldr.f32 nyfloor, [tmp]
       vsub.f32 nyfloor, tmp_f

     end_if_has_neighbour1:

     /* Project ceiling & floor heights into screen coordinates (Y coordinate) */
     y1a .req r8
     y1b .req r9
     y2a .req r10
     y2b .req r11
     /* int y1a  = H/2 - (int)(yceil * yscale1); */
     mov y1a, #240                                                       @ H/2
     vmul.f32 tmp_f, yceil, yscale1
     vcvt.s32.f32 tmp_f, tmp_f
     vmov.f32 tmp, tmp_f
     sub y1a, tmp

     /* int y1b = H/2 - (int)(yfloor * yscale1); */
     mov y1b, #240                                                       @ H/2
     vmul.f32 tmp_f, yfloor, yscale1
     vcvt.s32.f32 tmp_f, tmp_f
     vmov.f32 tmp, tmp_f
     sub y1b, tmp

     /* int y2a  = H/2 - (int)(yceil * yscale2); */
     mov y2a, #240                                                       @ H/2
     vmul.f32 tmp_f, yceil, yscale2
     vcvt.s32.f32 tmp_f, tmp_f
     vmov.f32 tmp, tmp_f
     sub y2a, tmp

     /* int y2b = H/2 - (int)(yfloor * yscale2); */
     mov y2b, #240                                                       @ H/2
     vmul.f32 tmp_f, yfloor, yscale2
     vcvt.s32.f32 tmp_f, tmp_f
     vmov.f32 tmp, tmp_f
     sub y2b, tmp

     ny1a .req s21 
     ny1b .req s22
     ny2a .req s23
     ny2b .req s24

     ldr tmp, =0x43700000  @| tmp = 240
     vmov tmp_f, tmp

     vmul.f32 ny1a, nyceil, yscale1
     vsub.f32 ny1a, tmp_f, ny1a

     vmul.f32 ny1b, nyfloor, yscale1
     vsub.f32 ny1b, tmp_f, ny1b

     vmul.f32 ny2a, nyceil, yscale2
     vsub.f32 ny2a, tmp_f, ny2a

     vmul.f32 ny2b, nyfloor, yscale2
     vsub.f32 ny2b, tmp_f, ny2b

     tmp_f2 .req xscale1
     .unreq xscale1

     .unreq xscale2

     /* render wall */
     beginx .req tmp2
     .unreq tmp2

     endx .req r12

     /* 
       Load the sector's beginx and endx values  
       At this point, the sector has already been read from
       the queue, and thus the queue pointer points to the next
       address. 
       This code is not necessarily reached (as the loop might 
       skip at a previous branch), so this decision had to be made.
       For this reason, we load the the previous sector.
       (The size of the structs on the queue are 12 bytes.)
     */
     push {r5, r7} /*TODO comment */
       /*
         A temporary register has to be used for beginx, as it's
         register is r0, but order has to be maintained for 
         block data transfer loads
       */
       beginx_tmp .req r5
       sector_queue_tail_addr .req r7
       ldr sector_queue_tail_addr, =sector_queue_tail_ptr
       ldr tmp, [sector_queue_tail_addr]
       sub tmp, #12
       ldm tmp!, {sect_ptr, beginx_tmp, endx}
       mov beginx, beginx_tmp
       .unreq beginx_tmp
       .unreq sector_queue_tail_addr
     pop {r5, r7}

     /* Only bother with the wall if at least a segment of it is visible */
     cmp x2, beginx
     ble next_for_sector_edges

     cmp x1, endx
     bge next_for_sector_edges

     /* TODO: UGLY HACK */
     push {r0,r1}
     ldr r0, =has_filled
     ldr r1, [r0]
     cmp r1, #0
     bleq fill_back_buffer
     mov r1, #1
     str r1, [r0]
     pop {r0,r1}
     /* TODO: UGLY HACK */

     cmp beginx, x1
     movlt beginx, x1

     cmp endx, x2
     movgt endx, x2

    x .req beginx
    .unreq beginx

    push {r1-r5} // NEED MOAR REGISTERS
    /* These are as follows: 
       tmp
       sect_ptr
       vertex_array
       player_ptr
       for_sector_edges_counter 
       y2b
       DON'T USE THESE INSIDE THE LOOP! (I mean the aliases)
    */

    /* Put the neighbour on the render stack, if there is any */
    ldr r2, =current_neighbour_ptr
    ldr r2, [r2]
    ldr r2, [r2]
    cmp r2, #0
    blt for_x_in_wall

    ldr r4, =sector_queue_head_ptr
    ldr r1, [r4]
    ldr r5, =sector_queue_overflow
    cmp r1, r5
    bhs for_x_in_wall

    mov r3, x
    @add r3, #1
    sub endx, #1

    stmia r1!, {r2, r3, endx}
    str r1, [r4]

    add endx, #1 @| restore endx

    for_x_in_wall:
    /* Acquire the Y coordinates for our ceiling & floor for this X coordinate.
     * Clamp them. */
      cya .req r1
      cyb .req r2
      ya .req r3
      yb .req r4
      for_x_tmp .req r5

      sub ya, x, x1                             @| ya = x - x1
      mov yb, ya                                @| yb = x - x1 (used below)
      sub for_x_tmp, y2a, y1a                   @| y2a - y1a
      mul ya, ya, for_x_tmp                     @| (x-x1)*(y2a-y1a)
      sub for_x_tmp, x2, x1                     @| x2 - x1
      /* ----- no integer division... ----- */
      vmov tmp_f, ya
      vmov tmp_f2, for_x_tmp
      vcvt.f32.s32 tmp_f, tmp_f
      vcvt.f32.s32 tmp_f2, tmp_f2
      vdiv.f32 tmp_f, tmp_f, tmp_f2
      vcvt.s32.f32 tmp_f, tmp_f
      vmov ya, tmp_f
      /* ----- no integer division... ----- */
      add ya, y1a
      mov cya, ya

      sub for_x_tmp, y2b, y1b
      mul yb, yb, for_x_tmp
      sub for_x_tmp, x2, x1                     @| x2 - x1
      /* ----- no integer division... ----- */
      vmov tmp_f, yb
      vmov tmp_f2, for_x_tmp
      vcvt.f32.s32 tmp_f, tmp_f
      vcvt.f32.s32 tmp_f2, tmp_f2
      vdiv.f32 tmp_f, tmp_f, tmp_f2
      vcvt.s32.f32 tmp_f, tmp_f
      vmov yb, tmp_f
      /* ----- no integer division... ----- */
      add yb, y1b
      mov cyb, yb

      for_x_tmp2 .req ya
      .unreq ya
      .unreq yb

      ldr for_x_tmp, =ytops
      ldr for_x_tmp, [for_x_tmp, x, lsl #2] @| ytops[x]
      ldr for_x_tmp2, =ybottoms
      ldr for_x_tmp2, [for_x_tmp2, x, lsl #2] @| ybottoms[x]

      cmp cya, for_x_tmp
      movlt cya, for_x_tmp
      cmp cya, for_x_tmp2
      movgt cya, for_x_tmp2

      cmp cyb, for_x_tmp
      movlt cyb, for_x_tmp
      cmp cyb, for_x_tmp2
      movgt cyb, for_x_tmp2


      color .req for_x_tmp
      .unreq for_x_tmp

       /* Render top black line */
       ldr color, =0b0001000010000010
       push {r1-r2}
         mov r1, cya
         mov r2, cya
         add r2, #1
         bl vertical_line
       pop {r1-r2}

       /* Render floor */
       ldr color, =floor_colour
       ldr color, [color]
       cmp color, #-1
       beq transparent_floor 

       push {r1-r2}
         mov r1, cyb 
         mov r2, cyb
         ldr r2, =ybottoms
         ldr r2, [r2, x, lsl #2]
         sub r2, #1

         bl vertical_line
       pop {r1-r2}

       b floor_drawn
       transparent_floor:
       push {r1-r2}
         ldr color, =0b0001000010000010
         mov r1, cyb 
         mov r2, cyb
         add r2, #1

         bl vertical_line
       pop {r1-r2}
       floor_drawn:


      ldr for_x_tmp2, =current_neighbour_ptr
      ldr for_x_tmp2, [for_x_tmp2]      @| for_x_tmp2 = current_neighbour_addr
      ldr for_x_tmp2, [for_x_tmp2]

      cmp for_x_tmp2, #-1
      beq no_neighbour 
        
        /* Draw neighbour top and bottom */
        push {r1-r5, r8-r12}
           nya .req r3
           nyb .req r4
           neighbour_colour .req r5
           neighbour_tmp .req r8
           original_cyb .req r9
           original_cya .req r10
           new_ytop .req r11
           new_ybottom .req r12
           mov original_cyb, cyb @| save cyb (r2)
           mov original_cya, cya @| save cya (r1)

           /* TODO: comment */
           sub neighbour_tmp, x, x1
           vmov tmp_f2, neighbour_tmp
           vcvt.f32.s32 tmp_f2, tmp_f2
           vsub.f32 tmp_f, ny2a, ny1a
           vmul.f32 tmp_f, tmp_f2
           sub neighbour_tmp, x2, x1
           vmov tmp_f2, neighbour_tmp
           vcvt.f32.s32 tmp_f2, tmp_f2
           vdiv.f32 tmp_f, tmp_f, tmp_f2
           vadd.f32 tmp_f, ny1a

           vcvt.s32.f32 tmp_f, tmp_f
           vmov nya, tmp_f

           ldr neighbour_tmp, =ytops
           ldr neighbour_tmp, [neighbour_tmp, x, lsl #2] @| ytops[x]
           mov new_ytop, neighbour_tmp

           cmp nya, neighbour_tmp
           movlt nya, neighbour_tmp

           cmp nyb, neighbour_tmp
           movlt nyb, neighbour_tmp

           ldr neighbour_tmp, =ybottoms
           ldr neighbour_tmp, [neighbour_tmp, x, lsl #2] @| ybottoms[x]
           mov new_ybottom, neighbour_tmp

           cmp nya, neighbour_tmp
           movgt nya, neighbour_tmp

           cmp nyb, neighbour_tmp
           movgt nyb, neighbour_tmp

           /* Draw top separator */
           cmp nya, original_cya
           ble endif_top_separator
             ldr neighbour_colour, =0b0001100011000011
             mov r2, nya
             bl vertical_line
           endif_top_separator:

           /* TODO: comment */
           sub neighbour_tmp, x, x1
           vmov tmp_f2, neighbour_tmp
           vcvt.f32.s32 tmp_f2, tmp_f2
           vsub.f32 tmp_f, ny2b, ny1b
           vmul.f32 tmp_f, tmp_f2
           sub neighbour_tmp, x2, x1
           vmov tmp_f2, neighbour_tmp
           vcvt.f32.s32 tmp_f2, tmp_f2
           vdiv.f32 tmp_f, tmp_f, tmp_f2
           vadd.f32 tmp_f, ny1b

           vcvt.s32.f32 tmp_f, tmp_f
           vmov nyb, tmp_f

           /* Draw bottom separator */
           cmp nyb, original_cyb
           bge endif_bottom_separator
             ldr neighbour_colour, =0b0001000010000010
             mov r1, nyb
             mov r2, original_cyb
             bl vertical_line
           endif_bottom_separator:

           /* Set up new ytops[x] */
           cmp new_ytop, nya
           movlt new_ytop, nya
           cmp new_ytop, original_cya
           movlt new_ytop, original_cya
           cmp new_ytop, #480
           movgt new_ytop, #480
           subgt new_ytop, #1

           ldr neighbour_tmp, =ytops
           str new_ytop, [neighbour_tmp, x, lsl #2] @| ybottoms[x]

           /* Set up new ybottoms[x] */
           cmp new_ybottom, nyb
           movgt new_ybottom, nyb
           cmp new_ybottom, original_cyb
           movgt new_ybottom, original_cyb
           cmp new_ybottom, #0
           movlt new_ybottom, #0

           ldr neighbour_tmp, =ybottoms
           str new_ybottom, [neighbour_tmp, x, lsl #2] @| ybottoms[x]

           .unreq nya
           .unreq nyb
           .unreq neighbour_tmp
           .unreq neighbour_colour
           .unreq new_ytop
           .unreq new_ybottom
        pop {r1-r5, r8-r12}

      b line_drawn
      no_neighbour:

      /* There's no neighbour. Render wall from top to bottom. */
      ldr color, =0b1111111111111111

      cmp x, x1
      moveq color, #0
      bleq vertical_line
      
      mov x, x2
      line_drawn:
      add x, #1
      cmp x, endx
    ble for_x_in_wall
    draw_wall:

    /* Is there a neighbouring sector behind this wall? */
    ldr for_x_tmp2, =current_neighbour_ptr
    ldr for_x_tmp2, [for_x_tmp2]      @| for_x_tmp2 = current_neighbour_addr
    ldr for_x_tmp2, [for_x_tmp2]

    cmp for_x_tmp2, #-1
    bne wall_drawn 

    /* Draw wall */
    /* TODO: glitches occasionally (when first initialised). Could be when facing the wall
	    at 90(exact) degree
    */
    push {r0-r8}
    vpush {s1-s12}
    
    ldr for_x_tmp2, =sector_queue_tail_ptr
    ldr for_x_tmp2, [for_x_tmp2]
    ldr r2, [for_x_tmp2, #-12]

    ldr r0, [sect_ptr, #16]   @| load texture's address
    mov r1, x1
    mov r2, x2
    mov r3, y1b
    mov r4, y1a
    mov r5, y2a
    mov r6, y2b
    vmov s1, tz1
    vmov s2, tz2

    u_start_clipped .req s9
    u_end_clipped .req s10
    
    ratio .req s11
    vsub.f32 ratio, tz2_orig, tz1_orig   @ratio = z1-z0
    
    u_range .req s12
    dx .req s3
    dz .req s4

    vsub.f32 dx, tx2_orig, tx1_orig
    vsub.f32 dz, tz2_orig, tz1_orig

    vmul.f32 dx, dx
    vmul.f32 dz, dz

    length .req s3
    .unreq dx
    vadd.f32 length, dz
    .unreq dz
    vsqrt.f32 length, length
    
    @ hardcoded ratio: 1 unit = 22 px in the image file
    tex_ratio .req s4
    tmp_i .req r7
    mov tmp_i, #22
    vmov tex_ratio, tmp_i
    vcvt.f32.u32 tex_ratio, tex_ratio
    vmul.f32 u_range, length, tex_ratio
    
    @mov tmp_i, #128
    @vmov u_range, tmp_i
    @vcvt.f32.u32 u_range, u_range
    
    
    vsub.f32 u_start_clipped, tz1, tz1_orig
    vsub.f32 u_end_clipped, tz2, tz1_orig
    .unreq tmp_i
    .unreq tex_ratio
    /* if z coords are the same, use x coords and vice versa*/

    vcmp.f32 ratio, #0
    vmrs apsr_nzcv, fpscr
    bne zcoord$

    vsub.f32 ratio, tx2_orig, tx1_orig  @ratio = x1-x0
    vsub.f32 u_start_clipped, tx1, tx1_orig
    vsub.f32 u_end_clipped, tx2, tx2_orig

    zcoord$:
    vdiv.f32 ratio, u_range, ratio   @|ratio = (u1-u0)/(z1-z0)

    vmul.f32 u_start_clipped, ratio  @|u_start_clipped = (u1-u0)*(tz1-z0)/(z1-z0)

    vmul.f32 u_end_clipped, ratio  @|u_end_clipped = (u1-u0)*(tz2-z0)/(z1-z0)
    
    vmov s6, u_start_clipped
    vmov s7, u_end_clipped

    .unreq u_start_clipped
    .unreq u_end_clipped
    .unreq u_range
    .unreq ratio 

    bl texture
    vpop {s1-s12}
    pop {r0-r8}
    wall_drawn:

    pop {r1-r5}
    .unreq yceil

   next_for_sector_edges:
   
   /* Go to next neighbour's address */
   ldr r0, =current_neighbour_ptr
   ldr r1, [r0]
   add r1, #4
   str r1, [r0]

   sub for_sector_edges_counter, #1
   cmp for_sector_edges_counter, #0
   bgt for_sector_edges


   next_sector:
   /* ------------------------------------------------------------------ */

   /*
     If the tail and the head of the queue are different,
     render next sector
   */  
   ldr r0, =sector_queue_head_ptr
   ldr r0, [r0]
   ldr r1, =sector_queue_tail_ptr
   ldr r1, [r1]
   cmp r1, r0
   bne render_sector
   .unreq tmp

   /* ------------------------------------------------------------------ */
   /* Render things from the thing stack */
   /* All registers are available */
   tmp .req r1
   thing_stack_ptr .req r5
   ldr thing_stack_ptr, =thing_stack_ptr
   ldr thing_stack_ptr, [thing_stack_ptr]

   render_thing:
   ldr tmp, =thing_stack
   cmp thing_stack_ptr, tmp
   beq things_rendered
   ldmdb thing_stack_ptr!, {r2, r3, r7, r8, r10, r11, r12}

   /* Store current thing's sector */
   ldr tmp, =current_thing_sector
   str r2, [tmp]

   /* Store stack pointer, although this is not needed TODO */
   ldr tmp, =thing_stack_ptr
   str thing_stack_ptr, [tmp]

   /* get current image of the thing */
   mov r0, r3
   @| TODO: thing_set_state should happen earlier
   bl thing_set_state
   bl thing_get_image

   vmov s0, r12
   /* 
     Handle targeting.
     If weapon is single target type, then set the target.
     Otherwise check if player is shooting. If he is, damage surrounding 
     enemies
   */
   vpush {s1}
   push {r0-r2}

    /* Check type of thing. Only target enemies and 'other' things */
    push {r0}
      ldr r0, [r3]
      /* 
        0: enemy,
        1: ammo,
        2: HP,
        3: armor,
        4: other thing
      */
      cmp r0, #0
      cmpne r0, #4
    pop {r0}
    bne 1f
    
    /* Don't target dead enemies */
    push {r0}
      mov r0, r3
      bl enemy_is_dead
      cmp r0, #1
    pop {r0}
    beq 1f

    mov r1, r7        @| thing_x
    ldrh r0, [r0]     @| image.width
    lsr r0, #1

    vpush {s2}
    mov r2, #0x40000000 @| 2
    vmov s2, r2

    ldr r2, =weapon_info
    ldr r2, [r2, #8]      @| r2 = weapon
    ldr r2, [r2, #16]     @| r2 = weapon.target_type

    vmov s1, r0
    vcvt.f32.u32 s1, s1
    vmul.f32 s1, s0
    /* If target type is multiple, increase the 'hit box' */
    cmp r2, #1
    vmuleq.f32 s1, s2

    vcvt.u32.f32 s1, s1
    vmov r0, s1
    vpop {s2}

    cmp r1, #320
    subgt r1, #320
    rsble r1, #320

    cmp r1, r0
    bgt 1f

    ldr r1, =weapon_info
    ldr r1, [r1, #8]      @| r1 = weapon
    ldr r2, [r1, #16]     @| r2 = weapon.target_type
    ldr r1, [r1, #12]     @| r1 = weapon.damage

    cmp r2, #0
    beq single_target

    multiple_target:
    ldr r2, =player_shooting
    ldr r2, [r2]
    cmp r2, #1
    bne 1f

    mov r0, r3
    bl enemy_lose_health
    b 1f

    single_target: 
    ldr r2, =player_target
    str r3, [r2]  @| store enemy's address in player_target

1:
   pop {r0-r2}
   vpop {s1}
 
   mov r1, r7
   mov r2, r8
   mov r7, r11
   bl image_scale

   b render_thing
   things_rendered:
   

pop {pc}

