.globl displayStatusBar
.globl shoot_time_stamp

.align 4
statusbar_info:
  .int 90    /* #0 ammo   x */
  .int 177   /* #4 health x */
  .int 438   /* #8 armor  x */
  .int 410   /* #12 health, ammo, armor y */

  .int 295   /* #16 avatar x */
  .int 410   /* #20 avatar y */

  .int 225   /* #24 armsn1 x */
  .int 245   /* #28 armsn2 x */
  .int 265   /* #32 armsn3 x */
  .int 410   /* #36 arms1n y */
  .int 435   /* #40 arms2n y */

  .int 565   /* #44 bull, shell, rckt, cell x    */
  .int 620   /* #48 max bull, shell, rckt, cell x*/
  .int 415   /* #52 bull y  */
  .int 430   /* #56 shell y */
  .int 445   /* #60 rckt y  */
  .int 460   /* #64 cell y  */


shoot_time_stamp:
  .int 0

.align 4
/* 
  Params:
    none
  Returns:
    none
  Clobbers:
    none
*/
displayStatusBar:
  push {r0-r5, lr}
  vpush {s0,s1}
  statusbar_addr .req r3
  x .req r1
  y .req r2


  image_addr .req r0
  ldr statusbar_addr, =statusbar_info

  /* draw blank status bar */
  /* TODO: most of this should only be rendered once */
  ldr image_addr, =StatusBarAddress 
  mov x, #0
  ldr y, =402
  bl drawImage

  /* go back from shooting to idle */
  ldr r1, =shoot_time_stamp
  ldr r1, [r1]
  add r2, r1, #8
  ldr r1, =enemy_timer
  ldr r1, [r1]
  cmp r1, r2
  ldrge r0, =hero_avatar_idle
  ldrge r1, =player_avatar
  strge r0, [r1]

  @TODO: detect if the character sees an enemy?
  /* draw character avatar */
  twenty_f .req s0
  health_f .req s1
  sequence_length .req r5  

  mov r1, #20
  vmov twenty_f, r1
  vcvt.f32.s32 twenty_f, twenty_f

  ldr image_addr, =player_avatar
  ldr image_addr, [image_addr]  

  ldr r4, =player_health
  ldr r4, [r4]
  ldr sequence_length, [image_addr]   @r5 = sequence length
  add image_addr, #4

  cmp r4, #100
  movge r4, #99
  vmov health_f, r4 
  vcvt.f32.s32 health_f, health_f
  vdiv.f32 health_f, health_f, twenty_f
  vcvt.s32.f32 health_f, health_f
  vmov r4, health_f
  mul r4, sequence_length
  add image_addr, r4, lsl #2    @move to correct health
  
  timer .req r4
  ldr timer, =enemy_timer
  ldr timer, [timer]
  and timer, #0b1100       @1 second per entire frame TODO: need a better animation system
  
  ldr image_addr, [image_addr, timer]
  ldr x, [statusbar_addr, #16]
  ldr y, [statusbar_addr, #20]
  bl drawImage

  attribute .req image_addr
  .unreq image_addr
  attr_font .req sequence_length
  .unreq sequence_length

  /* display health */
  ldr attribute, =player_health
  ldr attribute, [attribute]
  ldr x, [statusbar_addr, #4]
  ldr y, [statusbar_addr, #12]
  ldr attr_font, =digits_image_r 
  bl display_number
  
  ldr r0, =exc_mark_r
  bl drawImage

  /* display ammo TODO: ammo not implemented */
  ldr attribute, = player_ammo
  ldr attribute, [attribute]
  ldr x, [statusbar_addr, #0]
  bl display_number

  /* display armor TODO: armor not implemented */
  ldr attribute, = player_armor
  ldr attribute, [attribute]
  ldr x, [statusbar_addr, #8]
  bl display_number

  ldr r0, =exc_mark_r
  bl drawImage

  @/* display arms TODO: arms, digits_img_gry not implemented */
  @ldr attr_font, =digits_image_r
  @mov attribute, #0

  @ldr x, [statusbar_addr, #24]
  @ldr y, [statusbar_addr, #36]
  @bl display_number

  @ldr x, [statusbar_addr, #28]
  @bl display_number

  @ldr x, [statusbar_addr, #32]
  @bl display_number

  @ldr y, [statusbar_addr, #40]
  @bl display_number

  @ldr x, [statusbar_addr, #28]
  @bl display_number

  @ldr x, [statusbar_addr, #24]
  @bl display_number

  @/* display bull,shell,rckt,cell. TODO: none implemented, digits_image_y not implemented */
  @ldr attr_font, =digits_image_r
  @mov attribute, #0

  @ldr x, [statusbar_addr, #44]
  @ldr y, [statusbar_addr, #52]
  @bl display_number

  @ldr y, [statusbar_addr, #56]
  @bl display_number

  @ldr y, [statusbar_addr, #60]
  @bl display_number
  @
  @ldr y, [statusbar_addr, #64]
  @bl display_number
  @
  @ldr x, [statusbar_addr, #48]
  @bl display_number

  @ldr y, [statusbar_addr, #60]
  @bl display_number

  @ldr y, [statusbar_addr, #56]
  @bl display_number

  @ldr y, [statusbar_addr, #52]
  @bl display_number

  vpop {s0,s1}
  pop {r0-r5, pc}
