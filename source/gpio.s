.globl get_gpio_address
.globl set_gpio_function
.globl set_gpio
.globl setup_input_keys


get_gpio_address:    
  ldr r0, =0x20200000
  mov pc,lr


/*
  Sets the GPIO pin's function
  r0 : pin number
  r1 : function code
    0 for input
    1 for output
    -- there are 7 altogether, the rest I don't care about now
  clobbers:
    none
*/
set_gpio_function:
push {r0, r1, r2, lr}
  cmp   r0, #53
  cmpls r1, #7
  movhi pc, lr

  mov r2, r0
  bl get_gpio_address              

1:
  cmp r2, #9
  subhi r2, #10
  addhi r0, #4
  bhi 1b

  add r2, r2, lsl #1
  lsl r1, r2  @| shift r1 to left by 3 times the (pin number mod 10)
  str r1, [r0]
pop {r0, r1, r2, pc}


set_gpio:
push {lr}
  pinNum .req r0
  pinVal .req r1

  cmp pinNum, #53
  movhi pc, lr
  mov r2, pinNum
  .unreq pinNum
  pinNum .req r2
  bl get_gpio_address
  gpioAddr .req r0

  pinBank .req r3
  lsr pinBank, pinNum, #5
  lsl pinBank, #2
  add gpioAddr, pinBank
  .unreq pinBank

  and pinNum, #31
  setBit .req r3
  mov setBit, #1
  lsl setBit, pinNum
  .unreq pinNum

  teq pinVal, #0
  .unreq pinVal
  streq setBit, [gpioAddr, #40]
  strne setBit, [gpioAddr, #28]
  .unreq setBit
  .unreq gpioAddr
pop {pc}
  
/* Set pins as inputs */
setup_input_keys:
push {lr}
  mov r0, #14
  mov r1, #0
  bl set_gpio_function

  mov r0, #4
  mov r1, #0
  bl set_gpio_function

  mov r0, #17
  mov r1, #0
  bl set_gpio_function

  mov r0, #27
  mov r1, #0
  bl set_gpio_function

  mov r0, #22
  mov r1, #0
  bl set_gpio_function

  mov r0, #10
  mov r1, #0
  bl set_gpio_function

  mov r0, #9
  mov r1, #0
  bl set_gpio_function

  mov r0, #11
  mov r1, #0
  bl set_gpio_function

pop {pc}
