.globl init_keyboard
.globl get_keys

.section .data
.align 4
KeyboardAddress:
.int -1

.align 4
previous_shoot:
.int 0
previous_pause:
.int 0
previous_change_weapon:
.int 0

.section .text
/*
  Loads USB driver. When keyboard(s) are connected, sets KeyboardAddress to the
  address of the first keyboard found.
  params:
    none
  returns:
    none
  clobbers:
    none
*/
init_keyboard:
push {lr}
push {r0-r1}
  /* Initialize USB driver (~1 sec) and check if it was succesful */
  bl UsbInitialise
  cmp r0, #0
  blne bsod  /* Loading driver went really wrong */
  bl KeyboardCount
  cmp r0, #0
  beq 1f
  /* Use the last keyboard found */
  sub r0, #1
  bl KeyboardGetAddress
  /* r0 = address of keyboard */
  ldr r1, =KeyboardAddress
  str r0, [r1]
1:
  bl setup_input_keys
pop {r0-r1}
pop {pc}

/*
  Checks the number of keys pressed and performs actions based on each of them.
  params:
    none
  returns:
    none
  clobbers:
    none
*/
get_keys:
push {lr}
push {r0-r7}
  game_state .req r5
  ldr game_state, =game_state
  ldr game_state, [game_state]

  mov r4, #0
  ldr r0, =KeyboardAddress
  ldr r0, [r0]                    @ arg for KeyboardPoll 
  cmp r0, #-1
  beq no_keyboard

  bl KeyboardPoll
  ldr r0, =KeyboardAddress
  ldr r0, [r0]                    @ arg for KeyboardGetKeyDownCount
  bl KeyboardGetKeyDownCount
  mov r2, r0                      @ r2 = number of keys down
  
  mov r1, #0                      @ r1 = counter for for_each_key loop
  for_each_key:
    cmp r1, r2
    bge end_for_each_key          @ while (r1 < r2)
    ldr r0, =KeyboardAddress 
    ldr r0, [r0]                  @ (re)set arg1 for KeyboardGetKeyDown

    push {r1}
      bl KeyboardGetKeyDown         @ r0 = arg for perform_action
      cmp r0, #44
      moveq r4, #1
      bl perform_action
    pop {r1}

    add r1, #1                    @ r1++
    b for_each_key
  end_for_each_key: 
  b input_handled

  no_keyboard:
    ldr r6, =0x20200034  @| TODO: function for getting GPLEV0
    ldr r7, [r6]

    /* Up button */
    @|14
    tst r7, #0b100000000000000
    beq 14f
      cmp game_state, #0
      bne 14f

      bl move_forward
    14:

    /* Back button */
    @|4
    tst r7, #0b10000
    beq 4f
      cmp game_state, #0
      bne 4f

      bl move_backwards
    4:

    /* Shoot red button */
    @|17
    tst r7, #0b100000000000000000
    beq 17f
      cmp game_state, #0
      bne 17f

      mov r4, #1
      ldr r2, =previous_shoot
      ldr r2, [r2]
      cmp r2, #1
      blne shoot
    17:

    /* Switch weapon button (grey) */
    @|27
    tst r7, #0b1000000000000000000000000000
    beq switch_weapon_not_pressed
      ldr r0, =previous_change_weapon
      ldr r1, [r0]
      cmp r1, #1
      beq 27f

      mov r1, #1
      str r1, [r0]

      cmp game_state, #0
      bne 27f
      
      bl select_next_weapon

      b 27f
      switch_weapon_not_pressed:
      ldr r0, =previous_change_weapon
      mov r1, #0
      str r1, [r0]
    27:

    /* Left white button */
    @|22
    tst r7, #0b10000000000000000000000
    beq 22f
      cmp game_state, #0
      bne 22f
      bl rotate_left

    22:

    /* Right white button */
    @|10
    tst r7, #0b10000000000
    beq 10f
      cmp game_state, #0
      bne 10f
      bl rotate_right 

    10:

    /* Open door button (grey) */
    @|9
    tst r7, #0b1000000000
    beq 9f
      cmp game_state, #0
      bne 9f

    9:

    /* Black button - pause */
    @|11
    tst r7, #0b100000000000
    beq pause_not_pressed
      ldr r0, =previous_pause
      ldr r1, [r0]
      cmp r1, #1
      beq 11f
      
      /* Store current key position */
      mov r1, #1
      str r1, [r0]

      ldr r0, =game_state
      cmp game_state, #0
      moveq r1, #1
      movne r1, #0
      str r1, [r0]
      b 11f
    pause_not_pressed:
      ldr r0, =previous_pause
      mov r1, #0
      str r1, [r0]
    11:

  input_handled:

  ldr r0, =previous_shoot
  str r4, [r0]
pop {r0-r7}
pop {pc}

/*
  Performs action based on the key
  IFF USB is used
  params:
    r0 : scan code of key
  returns:
    none
  clobbers:
    none
*/
perform_action:
push {lr}
push {r1}
  /*
  [w]      : 26 : move_forward
  [s]      : 22 : move_backwards
  [a]      :  4 : rotate_left
  [d]      :  7 : rotate_right
  [space]  : 44 : enter 
  [ScrLck] : 71 : bsod
  */
  
  cmp r0, #26
  bleq move_forward
  beq end_perform_action

  cmp r0, #22
  bleq move_backwards
  beq end_perform_action
  
  cmp r0, #4
  bleq rotate_left
  beq end_perform_action

  cmp r0, #7
  bleq rotate_right
  beq end_perform_action

  cmp r0, #44
  bne no_space
  ldr r2, =previous_shoot
  ldr r2, [r2]
  cmp r2, #1
  blne shoot
  beq end_perform_action
  no_space:
  end_perform_action:
  

pop {r1}
pop {pc}
