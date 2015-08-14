.section .data
.globl back_buffer
.globl InitialiseFrameBuffer
.globl FrameBufferInfo
.globl swap_back_buffer
.globl fill_back_buffer

.align 12
FrameBufferInfo:
  .int 640 /* #0  Physical Width */  
  .int 480  /* #4  Physical Height */   
  .int 640 /* #8  Virtual Width */   
  .int 480  /* #12 Virtual Height */  
  
  .int 0    /* #16 GPU - Pitch */
  .int 16   /* #20 Bit Depth   */
    
  .int 0    /* #24 X */
  .int 0    /* #28 Y */
  .int 0    /* #32 GPU - Pointer */
  .int 0    /* #36 GPU - Size    */

.align 4
back_buffer:
  .skip 640*480*2

.section .text

/*
  Initialise frame buffer
  params:
    r0 : width
    r1 : height
    r2 : bit depth
  return:
    r0 : 0 if invalid input, =FrameBufferInfo otherwise
  clobbers:
    ?  
*/
InitialiseFrameBuffer:
  fbInfoAddr .req r4
  result .req r0
  push {lr}
  ldr fbInfoAddr, =FrameBufferInfo
  
  mov r0, fbInfoAddr
  
  /* BY adding 0x40000000, we are telling GPU not to use its cache for these 
  writes so we can see the change (If without adding this value GPU will write 
  its response but will flush its cache so we can't see the change) */
  add r0, #0x40000000                    @ Mailbox message
  mov r1, #1                             @ Mailbox channel to write from
  bl MailboxWrite
  
  mov r0, #1                             @ Mailbox channel to read from
  bl MailboxRead
  
  teq result, #0
  movne result, #0
  popne {pc}
  mov result, fbInfoAddr
  .unreq result
  .unreq fbInfoAddr
pop {pc}

/* 
  Floor and ceiling buffering
*/
fill_back_buffer:
push {r0-r3, lr}
vpush {s0-s31}
  frame_buffer_addr .req r0
  back_buffer_addr  .req r1
  buffer_end        .req r2
  ldr r3, =0b00010000100000100001000010000010
  vmov s0, r3
  vmov s1, r3
  vmov s2, r3
  vmov s3, r3
  vmov s4, r3
  vmov s5, r3
  vmov s6, r3
  vmov s7, r3
  vmov s8, r3
  vmov s9, r3
  vmov s10, r3
  vmov s11, r3
  vmov s12, r3
  vmov s13, r3
  vmov s14, r3
  vmov s15, r3
  vmov s16, r3
  vmov s17, r3
  vmov s18, r3
  vmov s19, r3
  vmov s20, r3
  vmov s21, r3
  vmov s22, r3
  vmov s23, r3
  vmov s24, r3
  vmov s25, r3
  vmov s26, r3
  vmov s27, r3
  vmov s28, r3
  vmov s29, r3
  vmov s30, r3
  vmov s31, r3

  ldr frame_buffer_addr, =FrameBufferInfo 
  ldr frame_buffer_addr, [frame_buffer_addr, #0x20]

  ldr back_buffer_addr, =back_buffer
  ldr buffer_end, =640*480
  add buffer_end, back_buffer_addr

1:
  pld [back_buffer_addr, #128]
  cmp back_buffer_addr, buffer_end
  bhs 2f

  vstmia back_buffer_addr!,  {s0-s31}
  b 1b
  
2:
  ldr r3, =0b00011000100000000001100010000000
  vmov s0, r3
  vmov s1, r3
  vmov s2, r3
  vmov s3, r3
  vmov s4, r3
  vmov s5, r3
  vmov s6, r3
  vmov s7, r3
  vmov s8, r3
  vmov s9, r3
  vmov s10, r3
  vmov s11, r3
  vmov s12, r3
  vmov s13, r3
  vmov s14, r3
  vmov s15, r3
  vmov s16, r3
  vmov s17, r3
  vmov s18, r3
  vmov s19, r3
  vmov s20, r3
  vmov s21, r3
  vmov s22, r3
  vmov s23, r3
  vmov s24, r3
  vmov s25, r3
  vmov s26, r3
  vmov s27, r3
  vmov s28, r3
  vmov s29, r3
  vmov s30, r3
  vmov s31, r3

  push {back_buffer_addr}
  ldr back_buffer_addr, =back_buffer
  ldr buffer_end, =640*402*2
  add buffer_end, back_buffer_addr
  pop {back_buffer_addr}
3:
  pld [back_buffer_addr, #128]
  cmp back_buffer_addr, buffer_end
  bhs 4f

  vstmia back_buffer_addr!,  {s0-s31}
  b 3b
4:
  .unreq buffer_end 
  .unreq back_buffer_addr
  .unreq frame_buffer_addr
vpop {s0-s31}
pop {r0-r3, pc}


/* 
  Double buffering
*/
swap_back_buffer:
push {r0-r2, lr}
vpush {s0-s31}
  frame_buffer_addr .req r0
  back_buffer_addr  .req r1
  buffer_end        .req r2

  ldr frame_buffer_addr, =FrameBufferInfo 
  ldr frame_buffer_addr, [frame_buffer_addr, #0x20]

  ldr back_buffer_addr, =back_buffer
  ldr buffer_end, =640*480*2
  sub buffer_end, #800
  add buffer_end, back_buffer_addr

1:
  pld [back_buffer_addr, #128]
  cmp back_buffer_addr, buffer_end
  bhs 2f

  vldmia back_buffer_addr!,  {s0-s31}
  vstmia frame_buffer_addr!, {s0-s31}
  b 1b
  
2:
  .unreq buffer_end 
  .unreq back_buffer_addr
  .unreq frame_buffer_addr
vpop {s0-s31}
pop {r0-r2, pc}
