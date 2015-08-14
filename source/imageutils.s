.globl image_scale


/*
  Scales image at address with ratio and loads it to the frame buffer, with
  bottom middle pixel at position (x, y)
  Uses the nearest neighbour algorithm
  For NULL input doesn't draw anything.
  params:
    r0 : address of image
    r1 : bmx  
    r2 : bmy
    s0 : ratio
    r7 : clip_bottom (y screen coordinate of bottom clip) 
  returns:
    none
  clobbers:
    none
*/
image_scale: 
  push {lr}
  push {r0-r12} 
  vpush {s1}
  imgaddr .req r0
  bmx .req r1
  bmy .req r2
  clip_bottom .req r7
  ratio .req s0
  
  cmp imgaddr, #0
  beq end_rows

  frame_buffer .req r3
  ldr frame_buffer, =back_buffer

  height1 .req r4
  width1  .req r5
  ldrh height1, [imgaddr, #2]
  ldrh width1, [imgaddr]
  add imgaddr, #4            @ imgaddr now points to the first pixel

  /* hoffset = bmy - height2 */
  /* height2 = (int) height1 * ratio */
  hoffset .req r6

  vmov s1, height1           @| s1 = (float) height1
  vcvt.f32.u32 s1, s1
  vmul.f32 s1, ratio         @| s1 = s1 * ratio
  vcvt.u32.f32 s1, s1        @| s1 = (uint32) s1
  vmov hoffset, s1           @| hoffset = s1 
  mov height1, hoffset       @| height2 = hoffset
  rsb hoffset, bmy           @| hoffset = bmy - hoffset
  sub clip_bottom, hoffset
  cmp height1, clip_bottom
  movgt height1, clip_bottom
   
  height2 .req height1
  .unreq height1

  /* woffset = bmx - width2 */
  /* width2 = (int) width1 * ratio */
  width2 .req r7
  woffset .req r8
  vmov s1, width1            @| s1 = (float) width1
  vcvt.f32.u32 s1, s1
  vmul.f32 s1, ratio         @| s1 = s1 * ratio
  vcvt.u32.f32 s1, s1        @| s1 = (uint32) s1
  vmov width2, s1            @| width2 = s1 
  mov woffset, width2        @| woffset = width2
  lsr woffset, #1            @| woffset = woffset / 2
  rsb woffset, bmx           @| woffset = bmx - woffset

  /* y -> hoffset */
  /* x -> woffset */

  startpos .req r10

  /* startpos = hoffset * 1280 */
  add startpos, hoffset, hoffset, lsl #2
  lsl startpos, #8
  add startpos, woffset, lsl #1

  add frame_buffer, startpos

  /* TODO Clip image if out of screen */
  tmp_1 .req bmx
  .unreq bmx

  cmp woffset, #0
  @|blt end_rows
  rsb tmp_1, woffset, #640
  cmp width2, tmp_1
  movgt width2, tmp_1

  cmp hoffset, #0
  @|blt end_rows
  @|rsb tmp_1, hoffset, #480
  @|cmp height2, tmp_1
  @|movgt height2, tmp_1

  /* Scale image, store to frame_buffer */
  i       .req tmp_1
  j       .req bmy
  .unreq tmp_1
  .unreq bmy

  cmp hoffset, #0
  neglt hoffset, hoffset
  movgt hoffset, #0
  push {hoffset}
  add hoffset, hoffset, lsl #2
  lsl hoffset, #8
  add frame_buffer, hoffset
  pop {hoffset}

  cmp woffset, #0
  neglt woffset, woffset
  addlt frame_buffer, woffset, lsl #1
  movgt woffset, #0

  mov i, hoffset
  for_rows:
    mov j, woffset
    cmp i, height2 
    bge end_rows

    push {hoffset, woffset, frame_buffer}

    tmp .req hoffset
    old_pix .req woffset

    for_cols:
      /* old_pix = (int) ((i / ratio) * width1 + (j / ratio)) */
      vmov s1, i
      vcvt.f32.u32 s1, s1
      vdiv.f32 s1, s1, ratio
      vcvt.u32.f32 s1, s1
      vmov old_pix, s1
      mul old_pix, width1

      vmov s1, j
      vcvt.f32.u32 s1, s1
      vdiv.f32 s1, s1, ratio
      vcvt.u32.f32 s1, s1          @| s1 = (int) s1 
      vmov tmp, s1                 @| old_pix = s1
      add old_pix, tmp
      
      /* Load pixel from image to framebuffer */
      pixel .req tmp
      lsl old_pix, #1
      ldrh pixel, [imgaddr, old_pix] 
      invisible_colour .req old_pix
      .unreq old_pix

      /* 
        If the colour is not the specified invisible colour, draw pixel
      */
      ldr invisible_colour, =0x821
      cmp pixel, invisible_colour
      beq pixel_processed

      strh pixel, [frame_buffer] 
      .unreq pixel
      .unreq invisible_colour


      pixel_processed:

      add frame_buffer, #2
      add j, #1
      cmp j, width2
      blt for_cols 
    end_cols:
      pop {hoffset, woffset, frame_buffer}

      add frame_buffer, #1280 

      add i, #1

    b for_rows 
  end_rows:
  vpop {s1}
  pop {r0-r12}
  pop {pc}
