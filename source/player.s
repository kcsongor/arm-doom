.globl player
.globl player_angle
.globl player_velocity
.globl player_pos
.globl player_sector
.globl player_attack
.globl player_health
.globl player_ammo
.globl player_armor
.globl player_score
.globl player_avatar
.globl player_weapons
.globl player_current_weapon
.globl select_next_weapon
@.globl player_init
.global fov
.global move_forward
.global move_backwards
.global rotate_left
.global rotate_right
.globl shoot
.globl player_target
.globl player_shooting

.section .data
.align 4
fov:
  .float 350.4         @ 0.73 * 480  /* Horizontal */
  .float 96            @ 0.2 * 480   /* Vertical   */

player_height:
.float 6
player:
/* Position x, y, z */
player_pos:
.float 2
.float 2
.float 12    /* TODO: player_sector + player_height */

/* Velocity x, y, z */
player_velocity:
.float 0
.float 0
.float 0

/* Angle, sin(Angle), cos(Angle) */
player_angle:
.float 1.2
.float 0.932
.float 0.362

player_sector:
.int sector0

player_health:
.int 100

player_attack:
.int 20

player_score:
.int 0

player_ammo:
.int 100 

player_armor:
.int 0  

player_avatar:
.int hero_avatar_idle    /* default state: idle */

/* player shooting state. 1 if shooting, 0 if not */
.align 4
player_shooting:
.int 0

player_target:
.int 0

/* TODO: hardcode possible weapons */
player_weapons:
.int pistol_type
.int shotgun_type

/* Pointer to the weapon */
player_current_weapon:
.int player_weapons

.section .text

/* 
  Switches to the next player's weapon, or to the first one if already at end.
  params:
    none
  returns:
    none
  clobbers:
    none
*/
select_next_weapon:
  push {r0-r1}
  ldr r0, =player_current_weapon
  ldr r1, [r0]
  add r1, #4
  cmp r1, r0  @| Only to make sure array accesses are legal
  ldreq r1, =player_weapons
  str r1, [r0]

  ldr r0, =weapon_info
  ldr r1, [r1]
  str r1, [r0, #8]
  pop {r0-r1}
mov pc, lr

/*
  Shoot
  params:
    none
  returns:
    none
  clobbers:
*/
shoot:
push {lr}
push {r0-r2}
  ldr r1, =weapon_info
  ldr r0, [r1, #12]
  cmp r0, #0
  bne end_shoot$
  ldr r1, =player_ammo
  ldr r0, [r1]
  cmp r0, #0
  beq end_shoot$
    push {r0, r1}
    ldr r2, =player_avatar
    ldr r1, =hero_avatar_shoot
    str r1, [r2]
    
    ldr r1, =enemy_timer
    ldr r1, [r1]
    ldr r2, =shoot_time_stamp
    str r1, [r2]

    /* Set weapon state to shoot */
    ldr r1, =weapon_info
    mov r2, #1
    str r2, [r1, #12]
    mov r2, #1
    str r2, [r1, #16]
    mov r2, #220
    str r2, [r1, #4]
    pop {r0, r1}

    ldr r0, =weapon_info
    ldr r0, [r0, #8]  @| weapon
    ldr r0, [r0, #16] @| weapon.target_type
    cmp r0, #1

    /* TODO: per weapon ammo: currently multiple target weapons use 10, single target uses 1 */
    ldr r2, [r1]
    subeq r2, #7
    subne r2, #1
    cmp r2, #0
    movlt r2, #0
    str r2, [r1] @| store new ammo

    /* If weapon is multiple target, we don't care about player's target */
    cmp r0, #1
    beq 1f

    ldr r0, =player_target
    ldr r0, [r0]
    cmp r0, #0
    beq end_shoot$
1:
    ldr r0, =player_shooting
    mov r1, #1
    str r1, [r0]

    /* Check if the thing is an enemy */
    ldr r0, =player_target
    ldr r0, [r0]
    ldr r1, [r0]
    cmp r1, #0
    bne end_shoot$
    /* Enemy take damage */
    /* Load weapon damage */
    ldr r1, =weapon_info
    ldr r1, [r1, #8]
    ldr r1, [r1, #12]

    bl enemy_lose_health
  end_shoot$:
pop {r0-r2}
pop {pc}

/** Routines for moving and rotating player **/

/*
  Move player position forward with d = 0.5 unit
  params:
    none 
  returns:
    none
  clobbers:
    none
*/
move_forward:
push {r0-r3,lr}
vpush {s0-s4}

  /* update the weapon sprite position*/
  const_f .req s0
  const_i .req r2
    
  weapon_addr .req r0
  y_offset_counter .req r1
  ldreq weapon_addr, =weapon_info
  ldreq y_offset_counter, [weapon_addr, #20]
  
  y_offset_f .req s6
  vmov y_offset_f, y_offset_counter
  vcvt.f32.s32 y_offset_f, y_offset_f
  
  add y_offset_counter, #1
  and y_offset_counter, #0b1111
  str y_offset_counter, [weapon_addr, #20]

  ldr const_i, =0x3e378138
  vmov const_f, const_i
  vmul.f32 const_f, y_offset_f

  vmov s1, const_f
  bl sin
  vmov y_offset_f, s0
  
  mov const_i, #32
  vmov s1, const_i
  vcvt.f32.u32 s1, s1
  vmul.f32 y_offset_f, s1
  vcvt.s32.f32 y_offset_f, y_offset_f

  y_offset .req y_offset_counter
  .unreq y_offset_counter

  vmov y_offset, y_offset_f

  str y_offset, [weapon_addr, #16]
    

  /* Decrement x with sin(angle)*d, y with cos(angle)*d */
  dx .req s20
  dy .req s21

  ldr r0, =player_angle
  vldr.f32 dy, [r0, #4]         @ dy = sin(angle)
  vldr.f32 dx, [r0, #8]         @ dx = cos(angle) 
  ldr r0, =0x3f800000
  vmov.f32 s2, r0               @ s2 = d = 0.5
  vmul.f32 dy, s2               @ dy = sin(angle)*d
  vmul.f32 dx, s2               @ dx = cos(angle)*d 

  bl move_player

  .unreq dx 
  .unreq dy 

vpop {s0-s4}
pop {r0-r3, pc}

/*
  Move player position backwards with d = 0.5 units
  params:
    none 
  returns:
    none
  clobbers:
    none
*/
move_backwards:
push {r0-r3, lr}
vpush {s0-s4}
  /* update the weapon sprite position*/
  const_f .req s0
  const_i .req r2
    
  weapon_addr .req r0
  y_offset_counter .req r1
  ldreq weapon_addr, = weapon_info
  ldreq y_offset_counter, [weapon_addr, #20]
  
  y_offset_f .req s6
  vmov y_offset_f, y_offset_counter
  vcvt.f32.s32 y_offset_f, y_offset_f
  
  sub y_offset_counter, #1
  and y_offset_counter, #0b1111
  str y_offset_counter, [weapon_addr, #20]

  ldr const_i, =0x3e378138
  vmov const_f, const_i
  vmul.f32 const_f, y_offset_f

  vmov s1, const_f
  bl sin
  vmov y_offset_f, s0
  
  mov const_i, #32
  vmov s1, const_i
  vcvt.f32.u32 s1, s1
  vmul.f32 y_offset_f, s1
  vcvt.s32.f32 y_offset_f, y_offset_f

  y_offset .req y_offset_counter
  .unreq y_offset_counter

  vmov y_offset, y_offset_f

  str y_offset, [weapon_addr, #16]
  /* Increment x with sin(angle)*d, y with cos(angle)*d */
  dx .req s20
  dy .req s21

  ldr r0, =player_angle
  vldr.f32 dy, [r0, #4]         @ s0 = sin(angle)
  vldr.f32 dx, [r0, #8]         @ s1 = cos(angle) 
  ldr r0, =0x3f000000
  vmov.f32 s2, r0               @ s2 = d = 0.5
  vnmul.f32 dy, dy, s2               @ dy = -sin(angle)*d
  vnmul.f32 dx, dx, s2               @ dx = -cos(angle)*d 

  bl move_player

  .unreq dx 
  .unreq dy 

vpop {s0-s4}
pop {r0-r3, pc}

/* 
  Move player position with dx on the x-axis and dy on the y-axis
  params:
    s20 : dx
    s21 : dy
  returns:
    none
  clobbers:
    TODO 
*/
move_player:
push {lr}
push {r0-r6}
vpush {s0-s7}

  dx .req s20
  dy .req s21

  vx1 .req s4
  vy1 .req s5
  vx2 .req s6
  vy2 .req s7

  tmp .req r0
  counter .req r1
  previous_sect .req r6
  mov counter, #0
  mov previous_sect, #0
  
  start:

  px .req s22
  py .req s23
  ldr tmp, =player_pos
  vldr.f32 px, [tmp]
  vldr.f32 py, [tmp, #4]

  sect_ptr .req r2
  ldr sect_ptr, =player_sector
  ldr sect_ptr, [sect_ptr]

  vertex_array .req r3
  mov vertex_array, sect_ptr
  add vertex_array, #32                         /* sector->vertexes (ptr) */

  neighbour_ptr .req r4
  ldr neighbour_ptr, [sect_ptr, #8]


  /* for(unsigned s = 0; s < sect->sidec; ++s) */
  for_sector_edges_counter .req r5
  ldr for_sector_edges_counter, [sect_ptr, #28]  /* sector->sidec */
  for_sector_edges:

    ldr tmp, [neighbour_ptr]
    cmp previous_sect, tmp
    beq next_for_sector_edges

    /* Load vertices */
    ldr tmp, [vertex_array]
    vldr.f32 vx1, [tmp]
    vldr.f32 vy1, [tmp, #4]

    ldr tmp, [vertex_array, #4]
    vldr.f32 vx2, [tmp]
    vldr.f32 vy2, [tmp, #4]
    /* ------------- */
    vmov s2, px
    vmov s3, py
    bl point_side_f
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR
    beq intersects
    vmov s2, px
    vadd.f32 s2, dx
    vmov s3, py
    vadd.f32 s3, dy
    bl point_side_f
    blt less_than
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR
    bgt next_for_sector_edges
    b intersects
    less_than:
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR
    blt next_for_sector_edges
    intersects:

    vmov s4, px
    vmov s5, py
    vmov s6, px
    vadd.f32 s6, dx
    vmov s7, py
    vadd.f32 s7, dy

    ldr tmp, [vertex_array]
    vldr.f32 s2, [tmp]
    vldr.f32 s3, [tmp, #4]
    bl point_side_f
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR
    beq intersects2
    ldr tmp, [vertex_array, #4]
    vldr.f32 s2, [tmp]
    vldr.f32 s3, [tmp, #4]
    bl point_side_f
    blt less_than2
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR
    bgt next_for_sector_edges
    b intersects
    less_than2:
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR
    blt next_for_sector_edges
    intersects2:


    cmp counter, #1
    moveq counter, #2

    /* If there is no neighbour behind this wall, we can't go through it */
    ldr tmp, [neighbour_ptr]
    cmp tmp, #-1
    bne doorway
    cmp counter, #1
    bgt end_movement
    beq next_for_sector_edges

    ldr tmp, [vertex_array]
    vldr.f32 s1, [tmp]
    vldr.f32 s2, [tmp, #4]
    ldr tmp, [vertex_array, #4]
    vldr.f32 s3, [tmp]
    vldr.f32 s4, [tmp, #4]
    vsub.f32 s1, s3, s1
    vsub.f32 s2, s4, s2
    vmov s3, dx
    vmov s4, dy
    bl resolve_f
    vmov dx, s3
    vmov dy, s4
    mov counter, #1

    b start

    doorway:
    ldr previous_sect, =player_sector
    ldr previous_sect, [previous_sect]

    /* Set current player sector to the new sector we just entered to */
    ldr tmp, =player_sector 
    ldr r3, [neighbour_ptr]
    str r3, [tmp]

    /* Set new eye_level of player */
    eye_height .req s0
    vldr eye_height, [r3]          @| r3 = neighbour floor height
    ldr tmp, =player_height
    vldr s1, [tmp]
    vadd.f32 eye_height, s1        @| floor height + player height
    ldr tmp, =player_pos
    vstr.f32 eye_height, [tmp, #8]
    .unreq eye_height
    
    b start
      
  next_for_sector_edges:
  add vertex_array, #4                           @| s++
  add neighbour_ptr, #4
  sub for_sector_edges_counter, #1
  cmp for_sector_edges_counter, #0
  bgt for_sector_edges

  end_for_sector_edges:

  /* Actually move player */

  ldr tmp, =player_pos
  vadd.f32 px, dx
  vadd.f32 py, dy

  vstr.f32 px, [tmp]
  vstr.f32 py, [tmp, #4]

  end_movement:
  
  .unreq counter
  .unreq previous_sect
  .unreq dx 
  .unreq dy 

vpop {s0-s7}
pop {r0-r6}
pop {pc}

/*
  Rotate player anti-clockwise with 0.1 radians 
  params:
    none 
  returns:
    none
  clobbers:
    none
*/
rotate_left:
push {lr}
push {r0-r1}
vpush {s0-s1}
  /* Decrement angle value with 0.1 radians and store sin and cos in memory */
  ldr r0, =player_angle         @ r0 : pointer to player_angle
  vldr.f32 s1, [r0]             @ s1 = angle
  ldr r1, =0x3da1cac1
  vmov.f32 s0, r1               @ s0 = 0.1
  vsub.f32 s1, s0               @ angle -= 0.1
  vstr.f32 s1, [r0]             @ store angle
  bl sin                        @ get sin(angle)
  vstr.f32 s0, [r0, #4]         @ store sin 
  bl cos                        @ get cos(angle)
  vstr.f32 s0, [r0, #8]         @ store cos
vpop {s0-s1}
pop {r0-r1}
pop {pc}

/*
  Rotate player clockwise with 0.1 radians 
  params:
    none 
  returns:
    none
  clobbers:
    none
*/
rotate_right:
push {lr}
push {r0-r1}
vpush {s0-s1}
  /* Increment angle value with 0.1 radians and store sin and cos in memory */
  ldr r0, =player_angle         @ r0 : pointer to player_angle
  vldr.f32 s1, [r0]             @ s1 = angle
  ldr r1, =0x3da1cac1
  vmov.f32 s0, r1               @ s0 = 0.1
  vadd.f32 s1, s0               @ angle += 0.1
  vstr.f32 s1, [r0]             @ store angle
  bl sin                        @ get sin(angle)
  vstr.f32 s0, [r0, #4]         @ store sin 
  bl cos                        @ get cos(angle)
  vstr.f32 s0, [r0, #8]         @ store cos
vpop {s0-s1}
pop {r0-r1}
pop {pc}

