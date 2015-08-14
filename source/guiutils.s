.globl display_number


/*
  Renders number onto image buffer
  Params:
    r0: number to be displayed
    r1: bottom middle x
    r2: bottom middle y
    s0: ratio
    r4: spacing (in pixel)
    r5: address of the set of digits images used
  PRE: 0<=num<=2^16-1 
*/
display_number:
  push {r0-r10, lr}
  vpush {s0-s2}
  num .req r0
  bmx .req r1
  bmy .req r2 
  ratio .req s0
  spacing .req r4
  dm_addr .req r3

  mov dm_addr, r5
  quotient .req r6
  quotient_f .req s1
  remainder .req r7
  ten .req r8
  tmp_1 .req r9
  tmp_2 .req r10
  ten_f .req s2

  mov ten, #10
  vmov ten_f, ten
  vcvt.f32.u32 ten_f, ten_f
  mov quotient, num
  mov tmp_1, quotient
  vmov quotient_f, quotient
  vcvt.f32.u32 quotient_f, quotient_f
  vdiv.f32 quotient_f, quotient_f, ten_f
  vcvt.u32.f32 quotient_f, quotient_f
  vmov quotient, quotient_f

  mov tmp_2, quotient
  mul tmp_2, ten
  sub remainder, tmp_1, tmp_2

  next_digit$:
    ldr r0, [dm_addr, remainder, lsl #2]
    ldrh spacing, [r0]
    sub bmx, spacing
    bl drawImage

    mov tmp_1, quotient
    vmov quotient_f, quotient
    vcvt.f32.u32 quotient_f, quotient_f
    vdiv.f32 quotient_f, quotient_f, ten_f
    vcvt.u32.f32 quotient_f, quotient_f
    vmov quotient, quotient_f

    mov tmp_2, quotient
    mul tmp_2, ten
    sub remainder, tmp_1, tmp_2
    
    cmp quotient, #0
    cmple remainder, #0
    
    bgt next_digit$


  end_digit$:
  .unreq num
  .unreq bmx
  .unreq bmy
  .unreq ratio
  .unreq spacing
  .unreq dm_addr
  .unreq quotient
  .unreq quotient_f
  .unreq ten
  .unreq tmp_1
  .unreq tmp_2
  .unreq ten_f
  vpop {s0-s2}
  pop {r0-r10, pc}
