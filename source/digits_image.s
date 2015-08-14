.globl digits_image_r
@.globl digits_image_y
.globl exc_mark_r

digits_image_r:
  .int zero_r  /* #0 zero image address */
  .int one_r   /* #4 one  image address */
  .int two_r   /* #8 two  image address */
  .int three_r /* #12 three image address */
  .int four_r  /* #16 four image address */
  .int five_r  /* #20 five image address */
  .int six_r   /* #24 six  image address */
  .int seven_r /* #28 seven image address */
  .int eight_r /* #32 eight image address */
  .int nine_r  /* #36 nine image address */


@digits_image_y:
@  .int zero_y  /* #0 zero image address */
@  .int one_y   /* #4 one  image address */
@  .int two_y   /* #8 two  image address */
@  .int three_y /* #12 three image address */
@  .int four_y  /* #16 four image address */
@  .int five_y  /* #20 five image address */
@  .int six_y   /* #24 six  image address */
@  .int seven_y /* #28 seven image address */
@  .int eight_y /* #32 eight image address */
@  .int nine_y  /* #36 nine image address */
  

zero_r:
  .incbin "images/font/zero_r.bmap"

one_r:
  .incbin "images/font/one_r.bmap"

two_r:
  .incbin "images/font/two_r.bmap"

three_r:
  .incbin "images/font/three_r.bmap"

four_r:
  .incbin "images/font/four_r.bmap"

five_r:
  .incbin "images/font/five_r.bmap"

six_r:
  .incbin "images/font/six_r.bmap"

seven_r:
  .incbin "images/font/seven_r.bmap"

eight_r:
  .incbin "images/font/eight_r.bmap"

nine_r:
  .incbin "images/font/nine_r.bmap"

exc_mark_r:
  .incbin "images/font/exc_mark_r.bmap"

@zero_y:
@  .incbin "zero_y.bmap"
@
@one_y:
@  .incbin "one_y.bmap"
@
@two_y:
@  .incbin "two_y.bmap"
@
@three_y:
@  .incbin "three_y.bmap"
@
@four_y:
@  .incbin "four_y.bmap"
@
@five_y:
@  .incbin "five_y.bmap"
@
@six_y:
@  .incbin "six_y.bmap"
@
@seven_y:
@  .incbin "seven_y.bmap"
@
@eight_y:
@  .incbin "eight_y.bmap"
@
@nine_y
@  .incbin "nine_y.bmap"
@
