.global printf

.align 4
FontAddress:
.incbin "font.bin"
.align 4
FormatBuffer:
  .skip 80


/*
  Prints a formmated string.
  params:
    r1 : char* to the string to be printed
  return:
    none
*/
printf:
    bp .req r12
    push {bp}
    mov bp, sp
    add bp, #4

    push {r3-r10}

    overlayAddr .req r2

    /* Calculate position to print to */
    col .req r9
    row .req r10
    ldr overlayAddr, =TextBuffer
    ldr r0, =RowCursor
    ldr row, [r0]

    /* Multiply by row by 1280 and store in r0
       1280 = 5 * 256
    */
    add r0, row, row, lsl #2      @ r0 = row + (row << 2) = 5 * row
    lsl r0, #8                    @ r0 = r0 * 256

    add overlayAddr, r0
    ldr r0, =ColumnCursor
    ldr col, [r0]
    add overlayAddr, col
    /* End of position calculaton */

    asciiCode .req r0
    charAddr .req r1
    fontAddr .req r3     
    ldr fontAddr, =FontAddress

    loop:
        pixelsA .req r4
        pixelsB .req r5
        pixelsC .req r6
        pixelsD .req r7

        ldrb asciiCode, [charAddr]

        /* Jump to next character */
        add charAddr, #1

        /* String terminator */
        cmp asciiCode, #0
        beq end

        cmp asciiCode, #'\n'
        beq linebreak

        cmp asciiCode, #'%'
        bne noformatting
          /* Get the format character */
          ldrb asciiCode, [charAddr]
          /* Skip the format char in the outer loop */
          add charAddr, #1          

          push {r0-r1, r3, lr}
          /* Store row and column positions in memory */
          ldr r1, =RowCursor
          str row, [r1]
          ldr r1, =ColumnCursor
          str col, [r1]

          /* Call the formatting */
          push {r2, lr}
          ldr r1, [bp]
          add bp, #4

          /* Check if format character is b */
          cmp asciiCode, #'b'
          bne notbinary
          bl printf_b
          notbinary:

          /* Check if format character is x */
          cmp asciiCode, #'x'
          bne nothex
          bleq printf_x
          nothex:

          /* Check if format character is d */
          cmp asciiCode, #'d'
          bne notdecimal
          bleq printf_d
          notdecimal:

          pop {r2, lr}
          /* Done with formatting */

          /* Printf the format buffer */
          mov r1, r0
          bl printf
          /* r2 stores the overlay buffer position, so we don't
             restore that, as we wan't to continue where the recursive 
             call finished */
          pop {r0-r1, r3, lr}

          /* Get new row and column values */
          ldr row, =RowCursor
          ldr row, [row]
          ldr col, =ColumnCursor
          ldr col, [col]

          b loop

        noformatting:

        fontPosition .req asciiCode
        .unreq asciiCode 

        /* 
           Shift by 4 bits to the left and add fontAddr to get
           the position of the first byte of the character to be printed
        */
        lsl fontPosition, #4
        add fontPosition, fontAddr

        ldrd pixelsA, pixelsB, [fontPosition]
        ldrd pixelsC, pixelsD, [fontPosition, #8]

        .unreq fontPosition /* r0 now free */ 
        counter .req r0
        mov counter, #0

        charloop:
            strb pixelsA, [overlayAddr]
            add overlayAddr, #320
            strb pixelsB, [overlayAddr]
            add overlayAddr, #320
            strb pixelsC, [overlayAddr]
            add overlayAddr, #320
            strb pixelsD, [overlayAddr]
            sub overlayAddr, #880

            lsr pixelsA, #8
            lsr pixelsB, #8
            lsr pixelsC, #8
            lsr pixelsD, #8
            add counter, #1
        cmp counter, #4
        bne charloop
        .unreq counter  /* r0 is now free */

        sub overlayAddr, #320
        add overlayAddr, #1

        add col, #1
        cmp col, #80
        bne nolinebreak

        linebreak:
        sub overlayAddr, col
        add overlayAddr, #1280

        mov col, #0
        add row, #1

        nolinebreak:

    b loop
    end:

    /* Store row and column positions in memory */
    ldr r0, =RowCursor
    str row, [r0]
    ldr r0, =ColumnCursor
    str col, [r0]

    pop {r3-r10}
    pop {bp}

    .unreq col
    mov pc, lr

/*
  Writes r1's binary value to a string
  params:
    r1 : number to be printed
  return:
    r0 : char* to the string of r1
*/
printf_b:
  input .req r1
  formatBuffer .req r0
  ldr formatBuffer, =FormatBuffer 
  add formatBuffer, #78

  strb r2, [formatBuffer]
  loop_b:

    mov r3, input
    and r3, #1
    add r3, #'0'
    strb r3, [formatBuffer]
    lsr input, #1
    sub formatBuffer, #1
    
    cmp input, #0
    beq end_b

    b loop_b 
  end_b:
    add formatBuffer, #1
  mov pc, lr

/*
  Writes r1's hexadecimal value to a string
  params:
    r1 : number to be printed
  return:
    r0 : char* to the string of r1
*/
printf_x:
  input .req r1
  formatBuffer .req r0
  ldr formatBuffer, =FormatBuffer 
  add formatBuffer, #78

  loop_x:

    mov r3, input
    and r3, #0xF

    cmp r3, #10
    addlt r3, #'0'
    subhs r3, #10
    addhs r3, #'A'

    strb r3, [formatBuffer]
    lsr input, #4
    sub formatBuffer, #1
    
    cmp input, #0
    beq setup_pad_x  /* pad the rest of the string with 0s */
    .unreq input

    b loop_x 
  setup_pad_x:
    target_pos .req r1
    mov r3, #'0'
    ldr target_pos, =FormatBuffer
    add target_pos, #71
  pad_x:
    strb r3, [formatBuffer]
    cmp formatBuffer, target_pos
    sub formatBuffer, #1
    bgt pad_x 

    mov formatBuffer, target_pos
  mov pc, lr

/*
  Converts r1 to BCD and prints the decimal value to a string
  params:
    r1 : number to be printed
  return:
    r0 : char* to the string of r1
*/
printf_d:
  push {r3-r4}

  i      .req r0
  binary .req r1
  bcd    .req r2
  j      .req r3
  col    .req r4

  /* Convert binary input to BCD */

  mov bcd, #0
  mov i, #0

  for1:
    mov j, #0

    loopcolumns:
      and col, bcd, #0x0000000F
      cmp col, #5
      addhs bcd, #3
      ror bcd, #4

      add j, #1
      cmp j, #8
      blt loopcolumns
    endloopcolumns:

    lsl bcd, #1
    lsls binary, #1
    addcs bcd, #1

    add i, #1
    cmp i, #32
    blt for1
  endfor1:

  .unreq binary
  .unreq i
  .unreq j
  .unreq col

  /* Print BCD to a string */

  formatBuffer .req r0
  digit        .req r3

  ldr formatBuffer, =FormatBuffer
  add formatBuffer, #79

  loop_d:
    sub formatBuffer, #1
    mov digit, bcd

    and digit, #0xF
    add digit, #'0'
    strb digit, [formatBuffer]

    lsr bcd, #4
    cmp bcd, #0
    bne loop_d
  end_d:
  
  pop {r3-r4}
  mov pc, lr

