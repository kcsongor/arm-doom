.globl intersection_f
.globl vcross_f 
.globl intersect_box_f
.globl point_side_f
.globl cos
.globl sin
.globl intersect_box_f
.globl resolve_f

/*
  Point of intersection between two lines
  params:
    s1 : x1 (float) 
    s2 : y1 (float)

    s3 : x2 (float)
    s4 : y2 (float)

    s5 : x3 (float) 
    s6 : y3 (float)

    s7 : x4 (float)
    s8 : y4 (float)
  return:
    s0 : x (float)
    s1 : y (float)
  clobbers:
    none
*/
intersection_f:
  push {lr}
  vpush {s2-s31} 
  x1minusx2 .req s31
  vsub.f32 x1minusx2, s1, s3

  y1minusy2 .req s30
  vsub.f32 y1minusy2, s2, s4

  x3minusx4 .req s29
  vsub.f32 x3minusx4, s5, s7

  y3minusy4 .req s28
  vsub.f32 y3minusy4, s6, s8

  bl vcross_f 
  vmov.f32 s10, s0    @ s10 = vcross_f(x1, y1, x1, y2)

  vmov.f32 s1, s5
  vmov.f32 s2, s6
  vmov.f32 s3, s7
  vmov.f32 s4, s8

  bl vcross_f         
  vmov.f32 s11, s0    @ s11 = vcross_f(x3, y3, x4, y4)

  vmov.f32 s1, x1minusx2
  vmov.f32 s2, y1minusy2
  vmov.f32 s3, x3minusx4
  vmov.f32 s4, y3minusy4

  bl vcross_f
  vmov.f32 s13, s0

  vmov.f32 s1, s10
  vmov.f32 s3, s11

  bl vcross_f
  vmov.f32 s14, s0

  vmov.f32 s2, x1minusx2
  vmov.f32 s4, x3minusx4

  bl vcross_f
  
  vdiv.f32 s0, s0, s13
  vdiv.f32 s1, s14, s13
  
  vpop {s2-s31} 
  pop {pc}


/*
  Vector cross product (sign * magnitude)
  params:
    s1 : x1 (float) 
    s2 : y1 (float)
    s3 : x2 (float)
    s4 : y2 (float)
  return:
    s0 : cross product (float)
*/
vcross_f:
  vpush {s1}
  vmul.f32 s0, s1, s4     @ s0 = x1 * y2
  vmul.f32 s1, s3, s2     @ s1 = x2 * y1
  vsub.f32 s0, s1         @ s0 = x1 * y2 - x2 * y1
  vpop {s1}
mov pc, lr


/*
  Vector dot product 
  params:
    s1 : x1 (float) 
    s2 : y1 (float)
    s3 : x2 (float)
    s4 : y2 (float)
  return:
    s0 : dot product (float)
*/
vdot_f:
  vmul.f32 s0, s1, s3     @ s0 = x1 * x2
  vmla.f32 s0, s2, s4     @ s0 += y1 * y2
mov pc, lr

/*
  Normalise vector 
  PRE: x1 != 0, y1 != 0
  params:
    s1 : x1 (float) 
    s2 : y1 (float)
  return:
    s1 : Normalised x1 (float)
    s2 : Normalised y1 (float)
*/
vnormalise_f:
vpush {s0}
  vmul.f32 s0, s1, s1     @ s0 = x1 * x1
  vmla.f32 s0, s2, s2     @ s0 += y1 * y1
  vsqrt.f32 s0, s0        @ s0 = sqrt(s0)
  vdiv.f32 s1, s1, s0     @ s1 = s1/s0
  vdiv.f32 s2, s2, s0     @ s2 = s2/s0
vpop {s0}
mov pc, lr

/*
  Resolve vector along another
  params:
    s1 : nx (float) 
    s2 : ny (float)
    s3 : vx (float)
    s4 : vy (float)
  return:
    s3 : vx resolved along n (float)
    s4 : vy resolved along n (float)
*/
resolve_f:
push {lr}
vpush {s0,s1,s2}
  bl vnormalise_f
  bl vdot_f
  vmul.f32 s3, s1, s0
  vmul.f32 s4, s2, s0
vpop {s0,s1, s2}
pop {pc}

/*
  Determine which side of a line the point is on.
  params:
    s2 : px (float) 
    s3 : py (float)
    s4 : x1 (float)
    s5 : y1 (float)
    s6 : x2 (float)
    s7 : y2 (float)
  return:
    s0 : (float)
    Return value: <0, =0 or >0.
*/
point_side_f:
push {lr}
vpush {s1-s11}
  px .req s2
  py .req s3
  x1 .req s4
  y1 .req s5
  x2 .req s6
  y2 .req s7

  vsub.f32 s8, x2, x1
  vsub.f32 s9, y2, y1
  vsub.f32 s10, px, x1
  vsub.f32 s11, py, y1

  vmov.f32 s1, s8 
  vmov.f32 s2, s9 
  vmov.f32 s3, s10
  vmov.f32 s4, s11

  .unreq px 
  .unreq py 
  .unreq x1 
  .unreq y1 
  .unreq x2 
  .unreq y2 

  bl vcross_f
vpop {s1-s11}
pop {pc}

/*
  intersectbox: determine whether two 2d-boxes intersect.
  params:
    s0 : x0
    s1 : y0
    s2 : x1
    s3 : y1
    s4 : x2
    s5 : y2
    s6 : x3
    s7 : y3 
  returns:
    r0 : 1 if (overlap(x0,x1,x2,x3) && overlap(y0,y1,y2,y3))
         0 otherwise
*/
intersect_box_f:
push {lr}
 
  x0 .req s0 
  y0 .req s1 
  x1 .req s2 
  y1 .req s3 
  x2 .req s4 
  y2 .req s5 
  x3 .req s6 
  y3 .req s7  
 
  vcmp.f32 x0, x1         @ x0 will store min(x0,x1), x1 will store max
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags so later conds work
  vpushge.f32 {x0}
  vmovge.f32 x0, x1
  vpopge.f32 {x1} 
  
  vcmp.f32 x2, x3         @ s2 will store min(x2,x3), x3 will store max
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  vpushge.f32 {x2}  
  vmovge.f32 x2, x3 
  vpopge.f32 {x3}

  vcmp.f32 x0, x3         @ if (min(x0,x1) <= max(x0,x1))
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  vcmple.f32 x2, x1       @     && (min(x0,x1) <= max(x0,x1))
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags

  bgt endfalse

  vcmp.f32 y0, y1         @ y0 will store min(y0,y1), y1 will store may
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  vpushge.f32 {y0}
  vmovge.f32 y0, y1
  vpopge.f32 {y1} 
  
  vcmp.f32 y2, y3         @ s2 will store min(y2,y3), y3 will store may
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  vpushge.f32 {y2}  
  vmovge.f32 y2, y3 
  vpopge.f32 {y3}

  vcmp.f32 y0, y3         @ if (min(y0,y1) <= may(y0,y1))
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  vcmple.f32 y2, y1       @     && (min(y0,y1) <= may(y0,y1))
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags

  bgt endfalse

  endtrue:
  mov r0, #1
  pop {pc} 

  endfalse:
  mov r0, #0
  pop {pc}

 .unreq x0
 .unreq y0
 .unreq x1
 .unreq y1
 .unreq x2
 .unreq y2
 .unreq x3
 .unreq y3

/*
  overlap: determine whether the two number ranges overlap.
  params:
    s0 : a0
    s1 : a1
    s2 : b0
    s3 : b1
  returns:
    r0: 1 iff (min(a0,a1) <= max(b0,b1) && min(b0,b1) <= max(a0,a1))
*/
overlap:
@ TODO: Could be faster with longer fugly code
@ TODO: If many unused registers, s31 etc. could be used for register swaps 
push {lr}
  vcmp.f32 s0, s1         @ s0 will store min(s0,s1), s1 will store max
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  vpushge.f32 {s0}
  vmovge.f32 s0, s1
  vpopge.f32 {s1} 
  
  vcmp.f32 s2, s3         @ s2 will store min(s2,s3), s3 will store max
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  vpushge.f32 {s2}  
  vmovge.f32 s2, s3 
  vpopge.f32 {s3}

  vcmp.f32 s0, s3         @ if (min(a0,a1) <= max(b0,b1))
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  vcmple.f32 s2, s1       @     && (min(b0,b1) <= max(a0,a1))
  vmrs APSR_nzcv, FPSCR   @ transfer floating point flags
  movle r0, #1            @ s0 = 1 (return true)
  movgt r0, #0            @ s0 = 0 (return false) 
pop {pc} 

/*
  returns an approximation for cos(x) using sin(x-pi/2)
  params:
    s1: angle (radians) 
  returns:
    s0: cos(x) (float)
  clobbers:
    none
*/
cos:
push {lr}
push {r0}
vpush {s1}
  ldr r0, =0x3fc90fda   @ r0 = pi/2
  vmov.f32 s0, r0
  vsub.f32 s1, s0, s1   @ s1 = pi/2 - x
  bl sin 
vpop {s1}
pop {r0}
pop {pc}

/*
  Returns an approximation for sin(x) using third order approximation 
    accurate at x=pi/2; 1.1% average error
  params:
    s1: x - angle in radians 
  returns:
    s0: sin(x) (float)
  clobbers:
    none 
*/
sin:
push {lr}
push {r0, r1}
vpush {s1, s2, s3}
  
  mov r1, #0                @ r1 = 0

  /* Check if angle is negative */
  ldr r0, =0x00000000
  vmov.f32 s0, r0           @ s0 = 0
  vcmp.f32 s1, s0           @ if angle < 0 then angle = -angle; r1 = 1
  vmrs APSR_nzcv, FPSCR     @ transfer floating point flags
  vneglt.f32 s1, s1         @      angle = -angle
  movlt r1, #1              @      r1 = 1

  /* Check if abs(angle) >= pi/2 */
  ldr r0, =0x3fc90fda  
  vmov.f32 s0, r0           @ s0 = pi/2
   
  vabs.f32 s2, s1           @ s2 = a' = abs(angle) 
  vcmp.f32 s2, s0           @ if a' > pi/2 reduce angle 
  vmrs APSR_nzcv, FPSCR     @ transfer floating point flags
  ble end_reduce
 
  /* Initialize constants for loop_while */ 
  ldr r0, =0x4096cbe4
  vmov.f32 s0, r0           @ s0 = 3*pi/2
  ldr r0, =0x40c90fdb
  vmov.f32 s3, r0           @ s3 = 2 * pi

  loop_while:
  vcmp.f32 s1, s0           @ while (angle > 3*pi/2)
  vmrs APSR_nzcv, FPSCR     @ transfer floating point flags
  ble end_loop_while
  vsub.f32 s1,s3            @ angle -= 2*pi 
  b loop_while 
  end_loop_while:
 
  ldr r0, =0x3fc90fda  
  vmov.f32 s0, r0           @ s0 = pi/2
  
  vabs.f32 s2, s1           @ s2 = a' = abs(angle) 
  vcmp.f32 s2, s0           @ if a' > pi/2
  vmrs APSR_nzcv, FPSCR     @ transfer floating point flags
  ble end_reduce
  ldr r0, =0x40490fdb
  vmov.f32 s0, r0           @ s0 = pi
  vsub.f32 s1, s0           @ angle -= pi 
  rsb r1, #1                @ r1 = 1 - r1

  end_reduce:
  ldr r0, =0x3f747645
  vmov.f32 s0, r0         @ s0 = 3/pi
  ldr r0, =0x3e041a2f
  vmov.f32 s2, r0         @ s2 = 4/pi^3
  vmul.f32 s2, s1         @ s2 = x * 4/pi^3
  vmul.f32 s2, s1         @ s2 = x^2 * 4/pi^3
  vsub.f32 s0, s2         @ s0 = 3/pi - x^2 * 4/pi^3
  vmul.f32 s0, s1         @ s0 = x * 3/l pi - x^3 * 4/pi^3

  /* If r1 != 0 then negate s0 */
  cmp r1, #0
  vnegne.f32 s0, s0

vpop {s1, s2, s3}
pop {r0, r1}
pop {pc}

