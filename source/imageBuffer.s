.globl ImageBuffer
.globl flushImageBuffer
.globl drawImage
.globl readBuffer
.globl render_image_buffer

.section .text
/*
  Draw image onto image buffer.
  params:
  NB: Assume bmp pixel array format: little endian, bottom->up, left->right
   TODO: offset
   r0 : image address
   r1 : x px (top left)
   r2 : y px (top left)
  returns:
    none
  clobbers:
    none
*/
drawImage:
  x .req r1
  y .req r2
  width .req r3
  height .req r4
  /* TODO:Check input validity */
  push {r1-r12, lr}
  
  imageaddr .req r0
  ldrh width, [imageaddr]
  ldrh height, [imageaddr, #2]
  add imageaddr, #4

  /* Get frame buffer address */
  back_buffer_pos .req r10
  startpos .req r6
  ldr back_buffer_pos, =back_buffer

  /* Calculate starting position on framebuffer */
  add startpos, y, y, lsl #2    @| startpos = 5*y
  lsl startpos, #8              @| startpos = startpos * 256 = y * 1280
  add startpos, x, lsl #1       @| startpos = 1280*y + x

  add back_buffer_pos, startpos

  colour .req r11
  invisible_colour .req r12
  ldr invisible_colour, =0x821

  mov x, #0
  mov y, #0

  loopRow$:
    cmp y, height
    beq endloop$
     
    push {back_buffer_pos}
    loopPix$:
      cmp x, width
      beq nextRow$
      
      /* Load pixel from image to framebuffer */
      ldrh colour, [imageaddr]
      cmp colour, invisible_colour
      strneh colour, [back_buffer_pos]
      
      add imageaddr, #2
      add back_buffer_pos, #2
      add x, #1
      b loopPix$ 
    nextRow$:
      pop {back_buffer_pos}

      add back_buffer_pos, #1280 

      add y, #1
      mov x, #0
      
      b loopRow$
  endloop$:

  .unreq x
  .unreq y
  .unreq width
  .unreq height
  .unreq colour
  .unreq imageaddr
  .unreq back_buffer_pos
  
  pop {r1-r12, pc}
.end
