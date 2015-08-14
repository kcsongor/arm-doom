.globl get_system_timer_base
.globl wait_func
.globl get_time_stamp
.globl enemy_timer
.globl weapon_timer
.globl init_game_timers
.globl tick_game_timers

.section .data
.align 4
enemy_timer:
.int 0           /* #0 return value: 0, 1, 2, 3, 4.. */
.int 0           /* #4 timestamp from system timer */

weapon_timer:
.int 0           /* #0 return value: 0, 1, 2, 3, 4.. */
.int 0           /* #4 timestamp from system timer */

.section .text
/*
  params:
    none
  returns:
    r0 : timer control/status register
*/
get_system_timer_base:
  ldr r0, =0x20003000
  mov pc, lr

/*
  params:
    none 
  returns:
    r0, r1 : the time stamp continously
*/
get_time_stamp:
  push {lr}
  bl get_system_timer_base
  ldrd r0, r1, [r0, #4]
  pop {pc}

/*
  Stops execution of instructions for r0 microseconds
  params:
    r0 : delay in microseconds 
  returns:
    none 
  clobbers:
    r1, r2, r3
*/
wait_func:
  push {lr}
  delay .req r2
  mov delay, r0
  bl get_time_stamp
  start .req r3
  mov start, r0
  
  wait_loop:
  bl get_time_stamp
  elapsed .req r1
  sub elapsed, r0, start
  cmp elapsed, delay
  .unreq elapsed
  bls wait_loop

  .unreq delay
  .unreq start

  pop {pc}

/*
  Initialize timer at =enemy_timer with non-negative integer states
  enemy_timer #0 : 0
  enemy_timer #4 : 32 most significant bits from timestamp for comparision
  params:
    none
  returns:
    none
*/
init_game_timers:
  push {lr}
  push {r0-r1}
  bl get_time_stamp                       @| r0 : timestamp
  ldr r1, =enemy_timer
  str r0, [r1, #4]
  mov r0, #0
  str r0, [r1]

  ldr r1, =weapon_timer
  str r0, [r1, #4]
  mov r0, #0
  str r0, [r1]

  pop {r0-r1}
  pop {pc}

/*
  TODO: proper commenting, and possibly unify the two timers
  Tick game timers if elsaped time since last tick is at least 250 microseconds
  Every 250 microsecs:
    Sets =enemy_timer #4 (prev timestamp) to new timestamp 
    Sets =enemy_timer #0 (timer state) to next value (starts at 0)
  params:
    none
  returns:
    none
*/
tick_game_timers:
  push {lr}
  push {r0-r3}
  bl get_time_stamp                          @| r0 : current timestamp
  ldr r1, =enemy_timer                       @| r1 : enemy timer addr
  ldr r2, [r1, #4]                           @| r2 : previous timestamp
  sub r3, r0, r2                             @| r3 = r0 - r2
  mov r2, #1
  lsl r2, #18
  cmp r3, r2                                 @| if r3 >= r2 tick timer
  blt 1f
    ldr r3, [r1]                             @| r3 = enemy_timer state 
    add r3, #1
    str r3, [r1]                             @| store new timer state
    str r0, [r1, #4]                         @| store new current timestamp
1:

  ldr r1, =weapon_timer                       @| r1 : weapon timer addr
  ldr r2, [r1, #4]                           @| r2 : previous timestamp
  sub r3, r0, r2                             @| r3 = r0 - r2
  mov r2, #1
  lsl r2, #17
  cmp r3, r2                                 @| if r3 >= r2 tick timer
  blt 1f
    ldr r3, [r1]                             @| r3 = weapon_timer state 
    add r3, #1
    str r3, [r1]                             @| store new timer state
    str r0, [r1, #4]                         @| store new current timestamp
1:
  pop {r0-r3}
  pop {pc}
