.globl sector0
.globl sector1
.globl sector2
.globl sector3
.globl sector4
.globl sector5
.globl sector6
.globl sector7
.globl sector8
.globl sector9
.globl map_init

.section .data
.align 4
sector0:
  .float 4    /* floor    */
  .float 24   /* ceiling  */
  .int n0     /* address of neighbours */
  .int t0     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   5     /* number of sides */
  
  .int vertex0
  .int vertex6
  .int vertex7
  .int vertex8
  .int vertex1
  .int vertex0

  n0:
  .int -1
  .int sector17
  .int -1
  .int sector1 @ <----------------------------
  .int -1

  t0:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0  

.align 4
sector1:
  .float 2    /* floor    */
  .float 22   /* ceiling  */
  .int n1     /* address of neighbours */
  .int t1     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */
  .int   4     /* number of sides */

  .int vertex1
  .int vertex8
  .int vertex9
  .int vertex2
  .int vertex1

  n1:
  .int sector0
  .int -1
  .int sector2
  .int -1

  t1:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 


.align 4
sector2:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n2     /* address of neighbours */
  .int t2     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex2
  .int vertex9
  .int vertex10
  .int vertex3
  .int vertex2

  n2:
  .int sector1
  .int -1
  .int sector3
  .int -1

  t2:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 


.align 4
sector3:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n3     /* address of neighbours */
  .int t3     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex3
  .int vertex10
  .int vertex11
  .int vertex4
  .int vertex3

  n3:
  .int sector2
  .int -1
  .int sector4
  .int -1

  t3:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 


.align 4
sector4:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n4     /* address of neighbours */
  .int t4     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   7     /* number of sides */

  .int vertex4
  .int vertex11
  .int vertex35
  .int vertex37
  .int vertex12
  .int vertex94
  .int vertex5
  .int vertex4

  n4:
  .int sector3
  .int -1
  .int -1
  .int sector5
  .int -1
  .int sector41
  .int -1

  t4:
  .int health_pack_0
  .int enemy_0
  .int enemy_1
  .int enemy_2
  .int enemy_3
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 


.align 4
sector5:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n5     /* address of neighbours */
  .int t5     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex12
  .int vertex37
  .int vertex38
  .int vertex13
  .int vertex12

  n5:
  .int sector4
  .int -1
  .int sector6
  .int -1

  t5:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 


.align 4
sector6:
  .float -2    /* floor    */
  .float 20   /* ceiling  */
  .int n6     /* address of neighbours */
  .int t6     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1   /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   8     /* number of sides */

  .int vertex13
  .int vertex38
  .int vertex74
  .int vertex81
  .int vertex87
  .int vertex88
  .int vertex82
  .int vertex14
  .int vertex13

  n6:
  .int sector5
  .int -1
  .int sector7
  .int -1
  .int -1
  .int sector37
  .int -1
  .int -1

  t6:
  .int enemy_19
  .int enemy_20
  .int enemy_21
  .int enemy_22
  .int enemy_23
  .int enemy_24
  .int enemy_25
  .int enemy_26
  .int 0
  .int 0 


.align 4
sector7:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n7     /* address of neighbours */
  .int t7     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   5     /* number of sides */

  .int vertex73
  .int vertex76
  .int vertex80
  .int vertex81
  .int vertex74
  .int vertex73

  n7:
  .int -1
  .int sector9
  .int -1
  .int sector6
  .int -1

  t7:
  .int enemy_49
  .int enemy_50
  .int enemy_51
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 

.align 4
sector9:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n9     /* address of neighbours */
  .int t9     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   5     /* number of sides */

  .int vertex75
  .int vertex85
  .int vertex86
  .int vertex80
  .int vertex76
  .int vertex75

  n9:
  .int sector10
  .int -1
  .int -1
  .int sector7
  .int -1

  t9:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 

.align 4
sector10:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n10     /* address of neighbours */
  .int t10     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   5     /* number of sides */

  .int vertex63
  .int vertex84
  .int vertex85
  .int vertex75
  .int vertex64
  .int vertex63

  n10:
  .int -1
  .int -1
  .int sector9
  .int -1
  .int sector11

  t10:
  .int health_pack_1
  .int enemy_43
  .int enemy_44
  .int enemy_45
  .int enemy_46
  .int enemy_47
  .int enemy_48
  .int 0
  .int 0
  .int 0 

.align 4
sector11:
  .float 2    /* floor    */
  .float 22   /* ceiling  */
  .int n11     /* address of neighbours */
  .int t11     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex61
  .int vertex63
  .int vertex64
  .int vertex62
  .int vertex61

  n11:
  .int -1
  .int sector10
  .int -1
  .int sector12

  t11:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 

.align 4
sector12:
  .float 4    /* floor    */
  .float 24   /* ceiling  */
  .int n12     /* address of neighbours */
  .int t12     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex57
  .int vertex61
  .int vertex62
  .int vertex58
  .int vertex57

  n12:
  .int -1
  .int sector11
  .int -1
  .int sector13

  t12:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector13:
  .float 6    /* floor    */
  .float 26   /* ceiling  */
  .int n13     /* address of neighbours */
  .int t13     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex53
  .int vertex57
  .int vertex58
  .int vertex54
  .int vertex53

  n13:
  .int -1
  .int sector12
  .int -1
  .int sector14

  t13:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector14:
  .float 8    /* floor    */
  .float 28   /* ceiling  */
  .int n14     /* address of neighbours */
  .int t14     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex44
  .int vertex53
  .int vertex54
  .int vertex45
  .int vertex44

  n14:
  .int -1
  .int sector13
  .int -1
  .int sector15

  t14:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector15:
  .float 10    /* floor    */
  .float 30   /* ceiling  */
  .int n15     /* address of neighbours */
  .int t15     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   6     /* number of sides */

  .int vertex30
  .int vertex44
  .int vertex45
  .int vertex46
  .int vertex32
  .int vertex31
  .int vertex30

  n15:
  .int -1
  .int sector14
  .int -1
  .int sector18
  .int -1
  .int sector16

  t15:
  .int enemy_4
  .int enemy_5
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector16:
  .float 8    /* floor    */
  .float 28   /* ceiling  */
  .int n16     /* address of neighbours */
  .int t16     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex21
  .int vertex30
  .int vertex31
  .int vertex22
  .int vertex21

  n16:
  .int -1
  .int sector15
  .int -1
  .int sector17

  t16:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector17:
  .float 6    /* floor    */
  .float 26   /* ceiling  */
  .int n17     /* address of neighbours */
  .int t17     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex6
  .int vertex21
  .int vertex22
  .int vertex7
  .int vertex6

  n17:
  .int -1
  .int sector16
  .int -1
  .int sector0

  t17:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector18:
  .float 12    /* floor    */
  .float 32   /* ceiling  */
  .int n18     /* address of neighbours */
  .int t18     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1   /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex32
  .int vertex46
  .int vertex47
  .int vertex33
  .int vertex32

  n18:
  .int sector15
  .int -1
  .int sector19
  .int -1

  t18:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector19:
  .float 14    /* floor    */
  .float 34   /* ceiling  */
  .int n19     /* address of neighbours */
  .int t19     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex33
  .int vertex47
  .int vertex48
  .int vertex34
  .int vertex33

  n19:
  .int sector18
  .int -1
  .int sector20
  .int -1

  t19:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector20:
  .float 16    /* floor    */
  .float 36   /* ceiling  */
  .int n20     /* address of neighbours */
  .int t20     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex34
  .int vertex48
  .int vertex49
  .int vertex35
  .int vertex34

  n20:
  .int sector19
  .int -1
  .int sector21
  .int -1

  t20:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector21:
  .float 18    /* floor    */
  .float 38   /* ceiling  */
  .int n21     /* address of neighbours */
  .int t21     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex35
  .int vertex49
  .int vertex50
  .int vertex36
  .int vertex35

  n21:
  .int sector20
  .int -1
  .int sector22
  .int -1

  t21:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector22:
  .float 20    /* floor    */
  .float 40   /* ceiling  */
  .int n22     /* address of neighbours */
  .int t22     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex36
  .int vertex50
  .int vertex51
  .int vertex37
  .int vertex36

  n22:
  .int sector21
  .int -1
  .int sector23
  .int -1

  t22:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector23:
  .float 22    /* floor    */
  .float 42   /* ceiling  */
  .int n23     /* address of neighbours */
  .int t23     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex37
  .int vertex51
  .int vertex52
  .int vertex38
  .int vertex37

  n23:
  .int sector22
  .int -1
  .int sector24
  .int -1

  t23:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector24:
  .float 22    /* floor    */
  .float 42   /* ceiling  */
  .int n24     /* address of neighbours */
  .int t24     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   7     /* number of sides */

  .int vertex13
  .int vertex38
  .int vertex52
  .int vertex67
  .int vertex68
  .int vertex23
  .int vertex14
  .int vertex13

  n24:
  .int -1
  .int sector23
  .int -1
  .int sector38
  .int -1
  .int sector25
  .int -1

  t24:
  .int ammo_0
  .int enemy_6
  .int enemy_7
  .int enemy_8
  .int enemy_9
  .int enemy_10
  .int enemy_11
  .int enemy_12
  .int enemy_13
  .int enemy_14

.align 4
sector25:
  .float 20    /* floor    */
  .float 40   /* ceiling  */
  .int n25     /* address of neighbours */
  .int t25     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex14
  .int vertex23
  .int vertex24
  .int vertex15
  .int vertex14

  n25:
  .int sector24
  .int -1
  .int sector26
  .int -1

  t25:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector26:
  .float 18    /* floor    */
  .float 38   /* ceiling  */
  .int n26     /* address of neighbours */
  .int t26     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex15
  .int vertex24
  .int vertex25
  .int vertex16
  .int vertex15

  n26:
  .int sector25
  .int -1
  .int sector27
  .int -1

  t26:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector27:
  .float 16    /* floor    */
  .float 36   /* ceiling  */
  .int n27     /* address of neighbours */
  .int t27     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex16
  .int vertex25
  .int vertex26
  .int vertex17
  .int vertex16

  n27:
  .int sector26
  .int -1
  .int sector28
  .int -1

  t27:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector28:
  .float 14    /* floor    */
  .float 34   /* ceiling  */
  .int n28     /* address of neighbours */
  .int t28     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex17
  .int vertex26
  .int vertex27
  .int vertex18
  .int vertex17

  n28:
  .int sector27
  .int -1
  .int sector29
  .int -1

  t28:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector29:
  .float 12    /* floor    */
  .float 32   /* ceiling  */
  .int n29     /* address of neighbours */
  .int t29     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   5     /* number of sides */

  .int vertex18
  .int vertex27
  .int vertex28
  .int vertex29
  .int vertex20
  .int vertex18

  n29:
  .int sector28
  .int -1
  .int sector30
  .int -1
  .int -1

  t29:
  .int enemy_41
  .int enemy_42
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector30:
  .float 10    /* floor    */
  .float 30   /* ceiling  */
  .int n30     /* address of neighbours */
  .int t30     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex28
  .int vertex40
  .int vertex41
  .int vertex29
  .int vertex28

  n30:
  .int -1
  .int sector31
  .int -1
  .int sector29

  t30:
  .int enemy_40
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector31:
  .float 8    /* floor    */
  .float 28   /* ceiling  */
  .int n31     /* address of neighbours */
  .int t31     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex40
  .int vertex42
  .int vertex43
  .int vertex41
  .int vertex40

  n31:
  .int -1
  .int sector32
  .int -1
  .int sector30

  t31:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector32:
  .float 6    /* floor    */
  .float 26   /* ceiling  */
  .int n32     /* address of neighbours */
  .int t32     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex42
  .int vertex55
  .int vertex56
  .int vertex43
  .int vertex42

  n32:
  .int -1
  .int sector33
  .int -1
  .int sector31

  t32:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector33:
  .float 4    /* floor    */
  .float 24   /* ceiling  */
  .int n33     /* address of neighbours */
  .int t33     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex55
  .int vertex59
  .int vertex60
  .int vertex56
  .int vertex55

  n33:
  .int -1
  .int sector34
  .int -1
  .int sector32

  t33:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector34:
  .float 2    /* floor    */
  .float 22   /* ceiling  */
  .int n34     /* address of neighbours */
  .int t34     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex59
  .int vertex65
  .int vertex66
  .int vertex60
  .int vertex59

  n34:
  .int -1
  .int sector35
  .int -1
  .int sector33

  t34:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector35:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n35     /* address of neighbours */
  .int t35     /* address of things */
  .int TextureAddress_2   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex65
  .int vertex71
  .int vertex72
  .int vertex66
  .int vertex65

  n35:
  .int -1
  .int sector36
  .int -1
  .int sector34

  t35:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector36:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n36     /* address of neighbours */
  .int t36     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   5     /* number of sides */

  .int vertex71
  .int vertex83
  .int vertex91
  .int vertex92
  .int vertex72
  .int vertex71

  n36:
  .int -1
  .int sector37
  .int -1
  .int -1
  .int sector35

  t36:
  .int enemy_34
  .int enemy_35
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector37:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n37     /* address of neighbours */
  .int t37     /* address of things */
  .int TextureAddress_3   /* Texture address for sector */
  .int 0x2104    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex82
  .int vertex88
  .int vertex91
  .int vertex83
  .int vertex82

  n37:
  .int sector6
  .int -1
  .int sector36
  .int -1

  t37:
  .int 0 @enemy_33
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector38:
  .float 22    /* floor    */
  .float 42   /* ceiling  */
  .int n38     /* address of neighbours */
  .int t38     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   6     /* number of sides */

  .int vertex67
  .int vertex87
  .int vertex89
  .int vertex90
  .int vertex77
  .int vertex68
  .int vertex67

  n38:
  .int -1
  .int -1
  .int -1
  .int sector39
  .int -1 
  .int sector24 

  t38:
  .int enemy_15
  .int enemy_16
  .int enemy_17
  .int enemy_18
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector39:
  .float 22    /* floor    */
  .float 42   /* ceiling  */
  .int n39     /* address of neighbours */
  .int t39     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   5     /* number of sides */

  .int vertex77
  .int vertex90
  .int vertex92
  .int vertex79
  .int vertex78
  .int vertex77

  n39:
  .int sector38
  .int -1
  .int -1
  .int sector40
  .int -1  

  t39:
  .int enemy_29
  .int enemy_30
  .int enemy_31
  .int enemy_32
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector40:
  .float 22    /* floor    */
  .float 42   /* ceiling  */
  .int n40     /* address of neighbours */
  .int t40     /* address of things */
  .int TextureAddress_3   /* Texture address for sector */
  .int 0x2104    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex69
  .int vertex78
  .int vertex79
  .int vertex70
  .int vertex69

  n40:
  .int -1
  .int sector39
  .int -1
  .int -1

  t40:
  .int health_pack_2
  .int enemy_37
  .int enemy_38
  .int enemy_39
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0

.align 4
sector41:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n41     /* address of neighbours */
  .int t41     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex5
  .int vertex94
  .int vertex95
  .int vertex93
  .int vertex5

  n41:
  .int sector4
  .int -1
  .int sector42
  .int -1

  t41:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0  

.align 4
sector42:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n42     /* address of neighbours */
  .int t42     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   6     /* number of sides */

  .int vertex93
  .int vertex95
  .int vertex13
  .int vertex38
  .int vertex97
  .int vertex96
  .int vertex93

  n42:
  .int sector41
  .int -1
  .int sector43
  .int -1
  .int -1
  .int -1

  t42:
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 

.align 4
sector43:
  .float 0    /* floor    */
  .float 20   /* ceiling  */
  .int n43     /* address of neighbours */
  .int t43     /* address of things */
  .int TextureAddress   /* Texture address for sector */
  .int -1    /* Floor colour, -1 if default */
  .int -1    /* Ceiling colour, -1 if default */

  .int   4     /* number of sides */

  .int vertex98
  .int vertex99
  .int vertex38
  .int vertex13
  .int vertex98

  n43:
  .int sector5
  .int -1
  .int sector42
  .int -1

  t43:
  .int health_pack_3
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0
  .int 0 

@TODO: initialise t0 for each map
map_init:
