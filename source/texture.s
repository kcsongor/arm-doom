.globl vertical_line_texture
.globl texture

.section .text
/*
  Renders a column of texture
  params:
    r0: x
    r1: y1
    r2: y2
    s0: u
    s1: v1
    s4: v2
    r5: texture address
    s6: z
  returns:
    none
  clobbers:
    none
*/
vertical_line_texture:
  /* TODO: clamping and checking positions*/
  /* TODO: more registers are pushed than actually used */
  x .req r0
  y1 .req r1
  y2 .req r2
  cmp y1, y2
  beq 1f

  frame_buffer .req r3
  texture_addr .req r5
  tmp .req r6

  push {r0-r10}
  vpush {s0-s7}

  tmp_f     .req s7
  y_start_f .req s5
  v_end     .req s4
  y_end_f   .req s3
  dv        .req s2
  v_start   .req s1

  vmov y_start_f, y1
  vcvt.f32.s32 y_start_f, y_start_f

  vmov y_end_f, y2
  vcvt.f32.s32 y_end_f, y_end_f 

  vsub.f32 dv, y_end_f, y_start_f 
  vsub.f32 v_end, s1

  vdiv.f32 dv, v_end, dv  @ dv =  (v_end - v_start)/(y_end - y_start) 

  vcvt.s32.f32 s0, s0

  /* Clamp */
  ldr tmp, =ytops
  ldr tmp, [tmp, x, lsl #2]
  cmp y1, tmp
  bge top_clamped 
  push {y2}

  tmp_2 .req y2
  sub tmp_2, tmp, y1
  mov y1, tmp
  vmov tmp_f, tmp_2
  vcvt.f32.s32 tmp_f, tmp_f
  vmul.f32 tmp_f, dv
  vadd.f32 v_start, tmp_f
  .unreq tmp_2

  pop {y2}
  .unreq tmp_f

  top_clamped:
  ldr tmp, =ybottoms
  ldr tmp, [tmp, x, lsl #2]
  cmp y2, tmp
  movhs y2, tmp


  /* Load framebuffer location into r3 */
  ldr frame_buffer, =back_buffer

  mov tmp, y1
  add tmp, tmp, tmp, lsl #2  @tmp = tmp * 5
  lsl tmp, #8
  add tmp, x, lsl #1
  add frame_buffer, tmp

  rounded_v .req tmp
  .unreq tmp 
  rounded_u .req r4

  vmov rounded_u, s0
  and rounded_u, #0x7f

  .unreq y_start_f 
  .unreq y_end_f   

  curr_y .req x
  .unreq x 

  .unreq v_end
  curr_v .req v_start
  .unreq v_start

  mov curr_y, y1       @curr_y = y1
  loop:
    /* TODO: I don't think this is needed, clamping is already done before */
    cmp curr_y, #0
    blt continue1$

    cmp curr_y, #480
    bge continue1$

    vmov s4, curr_v 
    vcvt.s32.f32 s4, s4
    vmov rounded_v, s4

    and rounded_v, #0x7f

    lsl rounded_v, #8      @TODO: hardcoded: image width = 128 px = 256 bytes
    add rounded_v, rounded_u, lsl #1
    /* the first 4 bytes of an image file store image info */
    add rounded_v, #4

    pixel .req r10
    ldrh pixel, [texture_addr, rounded_v]
    strh pixel, [frame_buffer]
    .unreq pixel 

    /* TODO: this should not be used, once textures are fixed */
    continue1$:
    add frame_buffer, #1280

    vadd.f32 curr_v, dv
    add curr_y, #1
    cmp curr_y, y2
  ble loop

1:
  .unreq curr_v 
  .unreq dv   
  .unreq rounded_u 
  .unreq texture_addr 
  .unreq rounded_v 
  .unreq curr_y 
  .unreq frame_buffer 
  .unreq y1 
  .unreq y2 
  vpop {s0-s7}
  pop {r0-r10}
mov pc, lr

/*
  Renders a wall with textures
  NB: u1, u2, v1, v2 hardcoded
  Coordinates of the four vertices of the wall (from bottom left clockwise)
    (i1,j1)
    (i1,j2)
    (i2,j3)
    (i2,j4)
  params:
    r0 : textureAddr
    r1 : i1
    r2 : i2
    r3 : j1
    r4 : j2
    r5 : j3
    r6 : j4
    s1 : z1  depth for left side of the wall (clipped)
    s2 : z2  depth for right side of the wall (clipped)
    TODO: fix these
    s6 : start_u (u1)
    s7 : end_u	 (u2)
  returns:
    
*/
texture:
  push {r0-r9, lr}
  vpush {s0-s15}
  start_rz .req s3
  end_rz .req s4
  one .req s5
  mov r7, #1
  vmov one, r7
  vcvt.f32.s32 one, one
  vdiv.f32 s3, one, s1  @start_rz = 1/z1
  vdiv.f32 s4, one, s2  @end_rz = 1/z2
  
  start_ru .req s6
  end_ru .req s7
  
  @mov r7, #8
  @mov r8, #135  @ TODO: length of the wall in the texture dimension (u range)
  @vmov start_ru, r7
  @vmov end_ru, r8
  @
  @vcvt.f32.s32 start_ru, start_ru
  @vcvt.f32.s32 end_ru, end_ru

  vmul.f32 start_ru, start_rz  @start_ru = u1/z1
  vmul.f32 end_ru, end_rz      @end_ru   = u2/z2

  dru .req s8
  drz .req s9

  vsub.f32 dru, end_ru, start_ru
  vsub.f32 drz, end_rz, start_rz

  rwidth .req s10
  sub r7, r2, r1
  vmov rwidth, r7

  vcvt.f32.s32 rwidth, rwidth
  vdiv.f32 rwidth, one, rwidth

  vmul.f32 dru, rwidth     @dru= (end_ru-start_ru)/(i2-i1)
  vmul.f32 drz, rwidth     @drz= (end_rz-start_rz)/(i2-i1)

  stepU .req s11
  stepD .req s12

  sub r7, r5, r4
  vmov stepU, r7
  vcvt.f32.s32 stepU, stepU
  vmul.f32 stepU, rwidth   @stepU = (j3-j2)/(i2-i1)

  sub r7, r6, r3
  vmov stepD, r7
  vcvt.f32.s32 stepD, stepD
  vmul.f32 stepD, rwidth   @stepD = (j4-j1)/(i2-i1)

  end_x .req r9


  /* rearrange the registers in order to use vertical_line_texture */
  x_end .req r6
  y_start .req s13
  y_end .req s14
  y_start_int .req r1
  y_end_int .req r2
  i .req r0
  textureaddr .req r5
  u .req s0
  vst .req s1
  ved .req s4

  mov x_end, r2
  mov textureaddr, r0
  mov i, r1

  vmov y_start, r4
  vmov y_end, r3     @r3,r4,s1,s2 are now free to use
  vcvt.f32.s32 y_start, y_start
  vcvt.f32.s32 y_end, y_end
  
  mov r3, #0	@TODO: hardcoded v range
  mov r4, #127

  vmov vst, r3	
  vmov ved, r4

  vcvt.f32.s32 vst, vst
  vcvt.f32.s32 ved, ved
 
  .unreq start_rz
  .unreq start_ru

  rz .req s3        @ rz = start_rz
  ru .req s6	    @ ru = start_ru

  /* Calculate the proper horizontal offset */
  vpush {s16}
  push {r1, r3, r5, r8}
    beginx_tmp .req r3
    sector_queue_tail_addr .req r8
    ldr sector_queue_tail_addr, =sector_queue_tail_ptr
    ldr r5, [sector_queue_tail_addr]
    sub r5, #12
    ldm r5!, {r1, beginx_tmp, end_x}
    .unreq sector_queue_tail_addr
    tmp .req r8
    tmp_f .req s16

    cmp i, beginx_tmp
    bgt offset_calculated
    sub tmp, beginx_tmp, i
    vmov tmp_f, tmp
    vcvt.f32.u32 tmp_f, tmp_f

    vmla.f32 y_start, tmp_f, stepU
    vmla.f32 y_end, tmp_f, stepD
    vmla.f32 rz, tmp_f, drz
    vmla.f32 ru, tmp_f, dru
    mov i, beginx_tmp

    .unreq beginx_tmp
    .unreq tmp
    .unreq tmp_f
    offset_calculated:
  pop {r1, r3, r5, r8}
  vpop {s16}

  drawColTex$:

    cmp i, x_end
    bge endCol
     
    vadd.f32 y_start, stepU
    vadd.f32 y_end, stepD
    
    vadd.f32 rz, drz
    vadd.f32 ru, dru
    
    converter .req s15
    vmov converter, y_start
    vcvtr.s32.f32 converter, converter
    vmov y_start_int, converter
    @bl bsod

    vmov converter, y_end
    vcvtr.s32.f32 converter, converter
    vmov y_end_int, converter

    vdiv.f32 u, ru, rz

    
    cmp i, #0
    blt continue2$
    cmp i, end_x
    bgt continue2$

    /* Render ceiling: everything above this sector's ceiling height. */
    /* vertical_line(x, ytop[x], cya-1, 0xffffff ,0x00ff00,0xff00ff); */
   
 @|   push {r1,r2,r5}
 @|     color .req r5
 @|     ldr color, =0b0001000010000010
 @|     mov r2, y_start_int
 @|     @sub r2, #1
 @|     ldr r1, =ytops
 @|     ldr r1, [r1, i, lsl #2]
 @|     bl vertical_line
 @|   pop {r1,r2,r5}

   /* Render floor: everything below this sector's floor height. */
   /* vertical_line(x, cyb+1, ybottom[x], 0xff0000,0x5a5a5a5a,0x000000); */

    push {r1,r2,r5}
      color .req r5
      ldr color, =floor_colour
      ldr color, [color]
      cmp color, #-1
      beq floor_drawn

      mov r1, y_end_int 
      ldr r2, =ybottoms
      ldr r2, [r2, i, lsl #2]
      sub r2, #1

      bl vertical_line
    floor_drawn:
    pop {r1,r2,r5}

    vpush {s6}
      vmov s6, rz
      bl vertical_line_texture
    vpop {s6}
    continue2$:
    add i, #1
    b drawColTex$
  endCol:
  .unreq converter
  vpop {s0-s15}
  pop {r0-r9, pc}
