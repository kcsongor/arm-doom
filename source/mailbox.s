.globl GetMailboxBase
.globl MailboxWrite
.globl MailboxRead

/*
  params:
    none
  return:
    r0 : the base address of the mailbox
*/
GetMailboxBase:
  ldr r0, =0x2000B880
  mov pc,lr

/*
  params:
    r0 : message
    r1 : channel to write to
  return:
    none
*/
MailboxWrite:
  tst r0, #0b1111         
  movne pc, lr            
  cmp r1, #15
  movhi pc, lr
  
  channel .req r1
  value .req r2
  mov value, r0
  push {lr}
  bl GetMailboxBase
  mailbox .req r0
  
  wait1$:
    status .req r3
    ldr status, [mailbox, #0x18]
    tst status, #0x80000000
    .unreq status
  bne wait1$
  
  add value, channel
  .unreq channel
  
  str value, [mailbox, #0x20]
  .unreq value
  .unreq mailbox
  pop {pc}


/*
  params:
    r0 : channel to read from
  return:
    r0 : message from the mailbox
*/
MailboxRead:
  cmp r0, #15
  movhi pc, lr

  channel .req r1
  mov channel, r0
  push {lr}
  bl GetMailboxBase
  mailbox .req r0
  
  rightmail$:
    wait2$:
      status .req r2
      ldr status, [mailbox, #18]
      tst status, #0x40000000
      .unreq status
    bne wait2$
    
    mail .req r2
    ldr mail, [mailbox]
    inchan .req r3
    and inchan, mail,#0b1111
    teq inchan, channel
    .unreq inchan
  bne rightmail$

  .unreq mailbox
  .unreq channel
  
  and r0, mail, #0xfffffff0
  .unreq mail
  
  pop {pc}
