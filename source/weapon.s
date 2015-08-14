.globl displayWeapon
.globl weapon_info
.globl shotgun_type
.globl pistol_type

.align 4
weapon_info:
  .int 256             /*#0 x */
  .int 280             /*#4 y */
  .int pistol_type     /*#8 weapon type */
  .int 0               /*#12 weapon state. idle = 0, shoot = 1, reload = 2 */
  .int 0	             /*#16 y offset. */
  .int 0	             /*#20 y offset counter */
  .int 0               /*#24 current image state, for reloading animation */
  .int 0               /*#28 last update tick, for animation timing */

pistol_type:
  .int pistol_idle                /*#0  Idle image */
  .int pistol_shoot               /*#4  Shooting image */
  .int 0                          /*#8  Address of reload animation */
  .int 15                         /*#12 Damage */
  .int 0                          /*#16 Target type. 0: single, 1: multiple */

shotgun_type:
  .int shotgun_idle               /*#0  Idle image */
  .int shotgun_shoot              /*#4  Shooting image */
  .int shotgun_reload_animation   /*#8  Address of reload animation */
  .int 60                         /*#12 Damage */
  .int 1                          /*#16 Target type. 0: single, 1: multiple */

/*
  Params:
    none
  Returns:
    none
  Clobbers:
    none
*/
displayWeapon:
  push {r0-r6, lr}

  weapon_addr .req r3
  x .req r1
  y .req r2
  img_addr .req r0
  state .req r4
  offset .req r5
  anim_offset .req r6

  ldr weapon_addr, =weapon_info
  ldr x, [weapon_addr, #0]
  ldr y, [weapon_addr, #4]
  ldr state, [weapon_addr, #12]
  ldr offset, [weapon_addr, #16]
  ldr anim_offset, [weapon_addr, #24]
  
  ldr img_addr, [weapon_addr, #8]
  ldr img_addr, [img_addr, state, lsl #2]
  cmp state, #2
  bne 1f
  cmp img_addr, #0
  beq 2f

  ldr img_addr, [img_addr, anim_offset, lsl #2]
1:
  add y, offset
  cmp state, #2
  moveq y, #200
  bl drawImage
  cmp state, #1
  moveq y, #280
  streq y, [weapon_addr, #4]

  .unreq weapon_addr 
  .unreq x 
  .unreq y 
  .unreq img_addr 
  .unreq state 
  .unreq offset 
  .unreq anim_offset 

  /* Set new state for weapon */
2:
  bl weapon_state

  pop {r0-r6, pc}

weapon_state:
push {r0-r5}
  anim_steps .req r1
  anim_offset .req r2
  weapon_addr .req r3
  state .req r4
  
  ldr weapon_addr, =weapon_info
  ldr state, [weapon_addr, #12]

  cmp state, #1
  bne 1f
  mov state, #2
  str state, [weapon_addr, #12]
  b state_set
1:
  cmp state, #2
  bne 3f

  last_update .req r0
  anim_tick_timer .req r5
  ldr anim_tick_timer, =weapon_timer
  ldr anim_tick_timer, [anim_tick_timer]
  ldr last_update, [weapon_addr, #28]
  cmp last_update, anim_tick_timer
  beq state_set

  str anim_tick_timer, [weapon_addr, #28] @| store last update as now
  ldr anim_steps, [weapon_addr, #8]
  ldr anim_steps, [anim_steps, #8]
  cmp anim_steps, #0
  beq 2f
  ldr anim_steps, [anim_steps] @| number of animation steps

  ldr anim_offset, [weapon_addr, #24]
  cmp anim_offset, anim_steps
  addne anim_offset, #1
2:
  moveq anim_offset, #0
  moveq state, #0
  streq state, [weapon_addr, #12]
  str anim_offset, [weapon_addr, #24]

  .unreq last_update 
  .unreq anim_tick_timer 
  b state_set
3:

state_set:
  .unreq anim_steps 
  .unreq anim_offset 
  .unreq weapon_addr 
  .unreq state 
pop {r0-r5}
mov pc, lr
