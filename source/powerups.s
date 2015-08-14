.globl powerup_get_image
.globl powerup_set_state
.globl health_pack_0
.globl health_pack_1
.globl health_pack_2
.globl health_pack_3
.globl ammo_0
.globl ammo_1
.globl ammo_2
.globl ammo_3
.globl armor_0
.globl armor_1
.globl armor_2
.globl armor_3

.section .data

.align 4
health_pack_0:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 2                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 8.0                   /* #4  : x-position */
  .float 30.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
health_pack_1:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 2                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 50.0                   /* #4  : x-position */
  .float 5                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
health_pack_2:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 2                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 52.0                  /* #4  : x-position */
  .float 70.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
health_pack_3:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 1                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 16.0                   /* #4  : x-position */
  .float 37.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
ammo_0:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 1                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34.0                  /* #4  : x-position */
  .float 46.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
ammo_1:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 1                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34.0                  /* #4  : x-position */
  .float 46.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

  .align 4
ammo_2:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 1                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34.0                  /* #4  : x-position */
  .float 46.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
ammo_3:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 1                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34.0                  /* #4  : x-position */
  .float 46.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.section .text

.align 4
armor_0:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 3                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34.0                  /* #4  : x-position */
  .float 46.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
armor_1:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 3                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34.0                  /* #4  : x-position */
  .float 46.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
armor_2:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 3                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34.0                  /* #4  : x-position */
  .float 46.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */

.align 4
armor_3:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 3                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34.0                  /* #4  : x-position */
  .float 46.0                   /* #8  : y-position */

  .int 0                       /* #12 : State 0 if not picked up. State 1 if picked up */




.section .text


/*
  TODO Possibly different values for different powerups
  params:
    r0 : powerup address
  returns:
  ` none
*/
powerup_set_state:
  push {lr}
  push {r0-r1}
  vpush {s0-s1}
  @TODO: Change name of enemy_distance_from_player
  bl enemy_distance_from_player
  ldr r1, =0x40000000
  vmov s1, r1
  vcmp.f32 s0, s1
  vmrs APSR_nzcv, FPSCR                     @ transfer floating point flags  
  bgt end_perform_powerup_effect$
  ldr r1, [r0, #12]
  cmp r1, #0
  bne end_perform_powerup_effect$
  mov r1, #1
  str r1, [r0, #12]
  ldr r0, [r0]
  cmp r0, #1
  beq ammo_effect$
  cmp r0, #2
  beq health_effect$
  cmp r0, #3
  beq armor_effect$
  
    ammo_effect$:
      ldr r0, =player_ammo
      ldr r1, [r0]
      add r1, #40
      str r1, [r0]
      b end_perform_powerup_effect$

    health_effect$:
      ldr r0, =player_health
      ldr r1, [r0]
      add r1, #40
      str r1, [r0]
      b end_perform_powerup_effect$

    armor_effect$:
      ldr r0, =player_armor
      ldr r1, [r0]
      add r1, #20
      str r1, [r0]
      b end_perform_powerup_effect$

  end_perform_powerup_effect$:
  vpop {s0-s1}
  pop {r0-r1}
  pop {pc}

/*
  Returns address for appropriate image for the thing
  params:
    r0 : address of the powerup/thing
  returns:
    r0 : address of image to display
*/
powerup_get_image:
  push {lr}
  ldr r1, [r0, #12]
  cmp r1, #1
  moveq r0, #0
  beq end_powerup_get_image$
  ldr r0, [r0]
  cmp r0, #1
  beq ammo_image$
  cmp r0, #2
  beq health_image$
  cmp r0, #3
  beq armor_image$
    ammo_image$:
      ldr r0, =ammo_img
      b end_powerup_get_image$

    health_image$:
      ldr r0, =health_img
      b end_powerup_get_image$

    armor_image$:
      ldr r0, =armor_img
      b end_powerup_get_image$

  end_powerup_get_image$:
  pop {pc}
