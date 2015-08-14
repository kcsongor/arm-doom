.globl TextBuffer
.globl flushTextBuffer
.globl RowCursor
.globl ColumnCursor
.globl drawTextLayer

.align 4
TextBuffer:
  .skip 38400 /* 640 x 480 pixels, each represented as 1 bit */

.align 4
RowCursor:
  .word 0x0
ColumnCursor:
  .word 0x0

flushTextBuffer:
  push {r0-r3}
  buf .req r1 
  zero .req r2
  mov zero, #0 

  /* Set row and column cursors to 0 */
  ldr r1, =RowCursor
  str zero, [r1]
  ldr r1, =ColumnCursor
  str zero, [r1]

  ldr buf, =TextBuffer

  i .req r0
  ldr i, =38396
  while$:
    str zero, [buf, i]
    sub i, #4
    cmp i, #0
    bne while$
  .unreq i
  .unreq buf
  .unreq zero

  pop {r0-r3}
  mov pc, lr
  buf .req r1 

.end

