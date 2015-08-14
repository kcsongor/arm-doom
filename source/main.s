.section .init
.globl _start
.globl panic
.globl test_image
.globl game_state
_start:

b main 

.align 4
/*
  State of game
  0 : normal
  1 : paused
*/
game_state:
  .int 0

.section .text
main:
  /* Setup stack */
  mov sp, #0x8000
  bl setup_vfp
  bl setup_cache

  bl init_keyboard 
  bl InitialiseFrameBuffer
  bl init_game_timers


  game_loop:
    bl tick_game_timers
   
    /* Clear target */
    ldr r0, =player_target
    mov r1, #0
    str r1, [r0]
    
    bl render_screen

    /* Reset shooting state */
    ldr r0, =player_shooting
    mov r1, #0
    str r1, [r0]

    /* Reset screen has been filled bool */
    ldr r0, =has_filled
    mov r1, #0
    str r1, [r0]

    bl get_keys

    bl displayWeapon
    bl displayStatusBar

    bl swap_back_buffer

    ldr r0, =player_health
    ldr r0, [r0]
    cmp r0, #0
    ble game_over

    ldr r0, =game_state
    ldr r0, [r0]
    cmp r0, #1
    bleq game_paused
    b game_loop

game_over:
  game_over_loop:
  ldr r0, =enemy_timer
  ldr r0, [r0]
  and r0, #1
  cmp r0, #0
  ldreq r0, =game_over_0
  ldrne r0, =game_over_1
  mov r1, #0
  mov r2, #0
  bl drawImage
  bl swap_back_buffer
  b game_over_loop

game_paused:
  push {lr}
1:
  ldr r0, =game_over_0
  mov r1, #0
  mov r2, #0
  bl drawImage
  bl swap_back_buffer

  bl get_keys
  ldr r0, =game_state
  ldr r0, [r0]
  cmp r0, #1
  beq 1b
  pop {pc}
  
setup_vfp:
  mrc       p15, #0, r0, c1, c0, #2
  orr       r0, r0, #0xF00000
  mcr       p15, #0, r0, c1, c0, #2
  mov       r0, #0x40000000
  fmxr      fpexc, r0
  mov       pc, lr

setup_cache:
  mov       r0, #0
  mcr       p15, 0, r0, c7, c7, 0
  mcr       p15, 0, r0, c8, c7, 0
  mrc       p15, 0, r0, c1, c0, 0
  ldr       r1, =0x1004
  orr       r0, r0, r1
  mcr       p15, 0, r0, c1, c0, 0
  mov       pc, lr
