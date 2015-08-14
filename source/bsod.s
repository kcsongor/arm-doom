.global bsod

.align 4
ErrorMessage:
  .asciz "
  A problem has been detected and Windows has been shut down to prevent damage
  to your computer.

  Technical information:

  r0:   0x%x  | r1:   0x%x  | r2:   0x%x  | r3:   0x%x
  r4:   0x%x  | r5:   0x%x  | r6:   0x%x  | r7:   0x%x
  r8:   0x%x  | r9:   0x%x  | r10:  0x%x  | r11:  0x%x
  r12:  0x%x  | SP:   0x%x  | LR:   0x%x  | PC:   0x%x
  ----------------------------------------------------------------------------
  s0:   0x%x  | s1:   0x%x  | s2:   0x%x  | s3:   0x%x
  s4:   0x%x  | s5:   0x%x  | s6:   0x%x  | s7:   0x%x
  s8:   0x%x  | s9:   0x%x  | s10:  0x%x  | s11:  0x%x
  s12:  0x%x  | s13:  0x%x  | s14:  0x%x  | s15:  0x%x
  s16:  0x%x  | s17:  0x%x  | s18:  0x%x  | s19:  0x%x
  s20:  0x%x  | s21:  0x%x  | s22:  0x%x  | s23:  0x%x
  s24:  0x%x  | s25:  0x%x  | s26:  0x%x  | s27:  0x%x
  s28:  0x%x  | s29:  0x%x  | s30:  0x%x  | s31:  0x%x

  *********************************** STOP ***********************************
  "
.align 4

/*
  Prints the content of the registers 
  and stops the machine
*/
bsod:
  vpush {s0-s31}
  push {r0-r15}
  bl flushTextBuffer
  ldr r1, =ErrorMessage
  bl printf

  /* Initialise framebuffer.
     BSOD needs its own, as something might go wrong there
  */
  bl InitialiseFrameBuffer

  fbInfoAddr .req r4
  mov fbInfoAddr, r0

  colour .req r0
  ldr colour, =0xF
  textColour .req r10
  ldr textColour, =0xFFFFFF

  fbAddr .req r3
  ldr fbAddr, [fbInfoAddr, #32]


  textBuffer .req r5
  textLayerWord .req r12
  ldr textBuffer, =TextBuffer
  ldr textLayerWord, [textBuffer]
  textCounter .req r7
  mov textCounter, #0
  
  y .req r1
  mov y, #480
  drawRow$:
    x .req r2
    mov x, #640
    drawPixel$:
      cmp textCounter, #32 
      bne dontloadnewtextword
      mov textCounter, #0 
      add textBuffer, #4
      ldr textLayerWord, [textBuffer]

      dontloadnewtextword:
      add textCounter, #1
      ror textLayerWord, #1
      tst textLayerWord, #0x80000000

      beq drawpix

      strh textColour, [fbAddr]
      b enddrawpix

      drawpix:
      strh colour, [fbAddr]

      enddrawpix:

      add fbAddr, #2
      sub x, #1
      teq x, #0

      bne drawPixel$
    sub y, #1

    teq y, #0
    bne drawRow$
   
  /* TODO: */
  ldr fbAddr, [fbInfoAddr, #32]

  /*
  mov r0, #320
  mov r1, #0
  mov r2, #240
  mov r6, #0xff00
  bl vline
  */

  
  mov r0, #16
  mov r1, #1
  bl set_gpio_function
  mov r0, #16
  mov r1, #0
  bl set_gpio

bsod_end:
b bsod_end

