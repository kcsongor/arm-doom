@TODO: need to add more enemies
.globl enemy_0
.globl enemy_1
.globl enemy_2
.globl enemy_3
.globl enemy_4
.globl enemy_5
.globl enemy_6
.globl enemy_7
.globl enemy_8
.globl enemy_9
.globl enemy_10
.globl enemy_11
.globl enemy_12
.globl enemy_13
.globl enemy_14
.globl enemy_15
.globl enemy_16
.globl enemy_17
.globl enemy_18
.globl enemy_19
.globl enemy_20
.globl enemy_21
.globl enemy_22
.globl enemy_23
.globl enemy_24
.globl enemy_25
.globl enemy_26
.globl enemy_27
.globl enemy_28
.globl enemy_29
.globl enemy_30
.globl enemy_31
.globl enemy_32
.globl enemy_33
.globl enemy_34
.globl enemy_35
.globl enemy_36
.globl enemy_37
.globl enemy_38
.globl enemy_39
.globl enemy_40
.globl enemy_41
.globl enemy_42
.globl enemy_43
.globl enemy_44
.globl enemy_45
.globl enemy_46
.globl enemy_47
.globl enemy_48
.globl enemy_49
.globl enemy_50
.globl enemy_51
.globl enemy_type_0
.globl enemy_move_towards_player
.globl enemy_attack
.globl enemy_get_image
.globl enemy_set_state
.globl enemy_lose_health
.globl enemy_perform_action
.globl enemy_is_dead
.globl enemy_distance_from_player
.globl thing_get_image
.globl thing_set_state
.globl current_thing_sector

.section .data
.align 4
current_thing_sector:
 .int 0

.align 4
enemy_type_0:
  .float 0.75                   /* #0  : speed (unit on each axis per frame) */
  .int 1                       /* #4  : attack */
  .int 5                       /* #8  : shot range */
  .int type_0_idle             /* #12 : enemy idle */
  .int type_0_dead             /* #16 : enemy dead */
  .int type_0_moving_0         /* #20 : enemy moving 0 */
  .int type_0_moving_1         /* #24 : enemy moving 1 */
  .int type_0_moving_2         /* #28 : enemy moving 2 */
  .int type_0_moving_3         /* #32 : enemy moving 3 */
  .int type_0_attack_0         /* #36 : enemy attacking 1 */
  .int type_0_attack_1         /* #40 : enemy attacking 2 */

.align 4
enemy_type_1:
  .float 0.25                   /* #0  : speed (unit on each axis per frame) */
  .int 3                       /* #4  : attack */
  .int 5                       /* #8  : shot range */
  .int type_1_idle             /* #12 : enemy idle */
  .int type_1_dead             /* #16 : enemy dead */
  .int type_1_moving_0         /* #20 : enemy moving 0 */
  .int type_1_moving_1         /* #24 : enemy moving 1 */
  .int type_1_moving_2         /* #28 : enemy moving 2 */
  .int type_1_moving_3         /* #32 : enemy moving 3 */
  .int type_1_attack_0         /* #36 : enemy attacking 1 */
  .int type_1_attack_1         /* #40 : enemy attacking 2 */

.align 4
enemy_type_2:
  .float 0.5                   /* #0  : speed (unit on each axis per frame) */
  .int 1                       /* #4  : attack */
  .int 5                       /* #8  : shot range */
  .int type_2_idle             /* #12 : enemy idle */
  .int type_2_dead             /* #16 : enemy dead */
  .int type_2_moving_0         /* #20 : enemy moving 0 */
  .int type_2_moving_1         /* #24 : enemy moving 1 */
  .int type_2_moving_2         /* #28 : enemy moving 2 */
  .int type_2_moving_3         /* #32 : enemy moving 3 */
  .int type_2_attack_0         /* #36 : enemy attacking 1 */
  .int type_2_attack_1         /* #40 : enemy attacking 2 */

.align 4
enemy_0: /* Spawns in Sector 4 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 4                    /* #4  : x position */
  .float 30                   /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_1: /* Spawns in Sector 4 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 6                    /* #4  : x position */
  .float 28                   /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_2: /* Spawns in Sector 4 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 10                    /* #4  : x position */
  .float 32                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_3: /* Spawns in Sector 4 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 14                    /* #4  : x position */
  .float 31                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_4: /* Spawns in Sector 15 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 24                    /* #4  : x position */
  .float 5                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_5: /* Spawns in Sector 15 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 26                    /* #4  : x position */
  .float 10                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_6: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 16                    /* #4  : x position */
  .float 46                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_7: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 22                    /* #4  : x position */
  .float 44                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_8: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 24                    /* #4  : x position */
  .float 50                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_9: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 28                    /* #4  : x position */
  .float 41                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_10: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 32                    /* #4  : x position */
  .float 44                   /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_11: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34                    /* #4  : x position */
  .float 46                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_12: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 38                    /* #4  : x position */
  .float 42                    /* #8  : y position */

  /* health */
  .int 40                    /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_13: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 40                    /* #4  : x position */
  .float 46                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_14: /* Spawns in Sector 24 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 42                    /* #4  : x position */
  .float 42                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_15: /* Spawns in Sector 38 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 52                    /* #4  : x position */
  .float 46                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_16: /* Spawns in Sector 38 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 56                    /* #4  : x position */
  .float 48                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_17: /* Spawns in Sector 38 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 60                    /* #4  : x position */
  .float 44                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_18: /* Spawns in Sector 38 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 64                    /* #4  : x position */
  .float 50                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_19: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 24                    /* #4  : x position */
  .float 50                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_20: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 28                    /* #4  : x position */
  .float 41                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_21: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 32                    /* #4  : x position */
  .float 44                   /* #8  : y position */

  /* health */
  .int 200                     /* #12  : health */

  /* type */
  .int enemy_type_1            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_22: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 34                    /* #4  : x position */
  .float 46                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_23: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 38                    /* #4  : x position */
  .float 42                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_24: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 40                    /* #4  : x position */
  .float 46                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_25: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 42                    /* #4  : x position */
  .float 42                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_26: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 52                    /* #4  : x position */
  .float 46                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_27: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 56                    /* #4  : x position */
  .float 48                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_28: /* Spawns in Sector 6 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 60                    /* #4  : x position */
  .float 44                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */

.align 4
enemy_29: /* Spawns in Sector 39 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 60                    /* #4  : x position */
  .float 62                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_30: /* Spawns in Sector 39 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 62                    /* #4  : x position */
  .float 70                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_31: /* Spawns in Sector 39 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 64                    /* #4  : x position */
  .float 74                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_32: /* Spawns in Sector 39 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 60                    /* #4  : x position */
  .float 76                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_33: /* Spawns in Sector 37 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 60                    /* #4  : x position */
  .float 62                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_34: /* Spawns in Sector 36 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 64                    /* #4  : x position */
  .float 74                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_35: /* Spawns in Sector 36 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 60                    /* #4  : x position */
  .float 76                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_36:
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 2                    /* #4  : x position */
  .float 5                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_37: /* Spawns in Sector 40 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 50                    /* #4  : x position */
  .float 80                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_1            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_38: /* Spawns in Sector 40 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 50                    /* #4  : x position */
  .float 76                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_39: /* Spawns in Sector 40 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 52                    /* #4  : x position */
  .float 74                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_40: /* Spawns in Sector 30 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 18                    /* #4  : x position */
  .float 80                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_41: /* Spawns in Sector 29 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 14                    /* #4  : x position */
  .float 80                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_42: /* Spawns in Sector 39 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 14                    /* #4  : x position */
  .float 76                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_43: /* Spawns in Sector 10 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 48                    /* #4  : x position */
  .float 6                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_44: /* Spawns in Sector 10 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 50                    /* #4  : x position */
  .float 2                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_45: /* Spawns in Sector 10 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 52                    /* #4  : x position */
  .float 4                   /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_46: /* Spawns in Sector 10 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 58                    /* #4  : x position */
  .float 3                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */


.align 4
enemy_47: /* Spawns in Sector 10 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 58                    /* #4  : x position */
  .float 8                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */

.align 4
enemy_48: /* Spawns in Sector 10 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 60                    /* #4  : x position */
  .float 5                    /* #8  : y position */

  /* health */
  .int 40                     /* #12  : health */

  /* type */
  .int enemy_type_0            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */

.align 4
enemy_49: /* Spawns in Sector 7 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 54                    /* #4  : x position */
  .float 26                    /* #8  : y position */

  /* health */
  .int 200                     /* #12  : health */

  /* type */
  .int enemy_type_1            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */

.align 4
enemy_50: /* Spawns in Sector 7 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 56                    /* #4  : x position */
  .float 30                    /* #8  : y position */

  /* health */
  .int 60                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */

.align 4
enemy_51: /* Spawns in Sector 7 */
  /* type: 0: enemy, 1: ammo, 2: HP, 3: armor, 4: other thing */
  .int 0                       /* #0  : thing type (0-4) */

  /* position: x, y */
  .float 56                    /* #4  : x position */
  .float 34                    /* #8  : y position */

  /* health */
  .int 100                     /* #12  : health */

  /* type */
  .int enemy_type_2            /* #16 : pointer to an enemy_type */
  
  /* state (0 : idle, 1 : dead, 2 : moving, 3 : attack)  */
  .int 2                       /* #20 : state of the enemy */

  /* timestamp of last shot */
  .int 0                       /* #24 : timestamp of last shot */

.section .text

/*
  Returns image of thing.
  params:
    r0 : address of thing
  returns:
    r0 : pointer to image
  clobbers:
    none
*/
thing_get_image:
  push {lr}
  push {r1}
  ldr r1, [r0]
  cmp r1, #0
  bleq enemy_get_image
  blne powerup_get_image
  pop {r1}
  pop {pc}


/*
  Sets state of thing
  params:
    r0 : address of thing
  returns:
    none
  clobbers:
    none
*/
thing_set_state:
  push {lr}
  push {r1}
  ldr r1, [r0]
  cmp r1, #0
  bleq enemy_set_state
  blne powerup_set_state
  pop {r1}
  pop {pc}

/*
  Determines the enemy's state based on the environment. Stores it in the enemy
  data structure.
  params:
    r0 : address of enemy
  returns:
    none
  clobbers:
    none
*/
enemy_set_state:
  push {lr}
  push {r1}
  vpush {s0-s1}

  ldr r1, [r0, #12]                         @ r1 = enemy health
  cmp r1, #0
  bls set_dead_state$

  bl enemy_distance_from_player             @ s0 : enemy-player distance
  ldr r1, =0x41a00000
  vmov.f32 s1, r1                           @ s1 = 20.0
  vcmp.f32 s1, s0
  vmrs APSR_nzcv, FPSCR                     @ transfer floating point flags
  bhs set_melee_state$
  b set_move_state$

    set_melee_state$:
      mov r1, #3       
      str r1, [r0, #20]
      b end_set_state$ 

    set_shoot_state$:
      /* TODO Implement this at some point in the future */
      b set_idle_state$

    set_move_state$:
      mov r1, #2
      str r1, [r0, #20]
      b end_set_state$

    set_dead_state$:
      mov r1, #1
      str r1, [r0, #20]
      b end_set_state$

    set_idle_state$:
      mov r1, #0
      str r1, [r0, #20]
      b end_set_state$

  end_set_state$:
  bl enemy_perform_action
  vpop {s0-s1}
  pop {r1}
  pop {pc}

/*
  Make enemy perform actions based on its state.
  params:
    r0 : enemy address
  returns:
    none
  clobbers:
*/
enemy_perform_action:
push {lr}
push {r0-r2}
  ldr r1, [r0, #20]         @ r1 = enemy state 
  cmp r1, #0
  beq idle_action$
  cmp r1, #1
  beq dead_action$
  cmp r1, #2
  beq moving_action$
  cmp r1, #3
  beq attack_action$
  
  idle_action$:
    b end_perform_action$

  dead_action$:
    b end_perform_action$

  moving_action$:
    bl enemy_move_towards_player
    b end_perform_action$

  attack_action$:
    bl enemy_attack
    b end_perform_action$

  end_perform_action$:
pop {r0-r2}
pop {pc}

/*
  Get the sum of the distances of the enemy (e_x, e_y) and target coordinates 
  (t_x, t_y) on each axis.
  params:
    r0 : address of enemy
    s0 : t_x
    s1 : t_y
  returns:
    s0 : abs(e_x - t_x) + abs(e_y - t_y)
  clobbers:
*/
enemy_distance_from_target:
  push {lr}
  vpush {s1, s2}
  vldr.f32 s2, [r0, #4]         @ s2 = enemy's x
  vsub.f32 s0, s2               @ s0 = t_x - e_x
  vabs.f32 s0, s0               @ s0 = abs(s0)
  vldr.f32 s2, [r0, #8]         @ s1 = enemy's y
  vsub.f32 s1, s2               @ s1 = t_y - e_y
  vabs.f32 s1, s1               @ s1 = abs(s1)
  vadd.f32 s0, s1               @ s0 = s0 + s1
  vpop {s1, s2}
  pop {pc}

/*
  Get the distance of the enemy (e_x, e_y) and player coordinates 
  (p_x, p_y). If address is 0 it returns 0.
  params:
    r0 : address of enemy
  returns:
    s0 : sqrt((e_x - p_x)^2 + abs(e_y - p_y)^2)
  clobbers:
    none
*/
enemy_distance_from_player:
  push {lr}
  push {r0}
  vpush {s1-s3}
  cmp r0, #0
  bne nullp$
    @TODO: 
    vmov s0, r0
    b end_dist_f_pl$
  nullp$:
  vldr.f32 s0, [r0, #4]         @ s0 = enemy's x
  vldr.f32 s1, [r0, #8]         @ s1 = enemy's y 
  ldr r0, =player_pos
  vldr.f32 s2, [r0]             @ s2 = player's x
  vldr.f32 s3, [r0, #4]         @ s3 = player's y
  vsub.f32 s0, s2
  vsub.f32 s1, s3
  vmul.f32 s0, s0
  vmul.f32 s1, s1
  vadd.f32 s0, s1
  vsqrt.f32 s0, s0

  end_dist_f_pl$:
  vpop {s1-s3}
  pop {r0}
  pop {pc}

/* 
  Move enemy at enemy address toward player by 0.5 units on each axis if it's
  at most 2 units close on each axis respectively.
  params:
    r0 : address of enemy
  returns:
    none
  clobbers:
    none
*/
enemy_move_towards_player:
  push {lr}
  push {r0-r6}
  vpush {s0-s14}

  sect_ptr .req r2
  ldr sect_ptr, =current_thing_sector
  ldr sect_ptr, [sect_ptr]
  enemy_ptr .req r6
  mov enemy_ptr, r0

  vx1 .req s4
  vy1 .req s5
  vx2 .req s6
  vy2 .req s7

  /* Calculate dx and dy for thing */
  bl enemy_distance_from_player
  ldr r1, =0x40000000
  vmov s1, r1
  vcmp.f32 s1, s0
  vmrs APSR_nzcv, FPSCR                    @ transfer floating point flags
  bge end_movement

  x .req s11
  y .req s12 
  px .req s8
  py .req s9
  vldr.f32 x, [enemy_ptr, #4]
  vldr.f32 y, [enemy_ptr, #8]
  ldr r1, [enemy_ptr, #16]             @ r1 = enemy's type ptr
  vldr.f32 s2, [r1]                    @ s2 = enemy's speed
  
  dx .req s13
  dy .req s14

  tmp .req r0
  ldr tmp, =player_pos
  vldr px, [tmp]
  vldr py, [tmp, #4]
  vsub.f32 px, x, px
  vdiv.f32 px, px, s0
  vsub.f32 py, y, py
  vdiv.f32 py, py, s0
  vnmul.f32 dx, py, s2
  vnmul.f32 dy, px, s2

  vertex_array .req r3
  mov vertex_array, sect_ptr
  add vertex_array, #32                         /* sector->vertexes (ptr) */

  neighbour_ptr .req r4
  ldr neighbour_ptr, [sect_ptr, #8]

  for_sector_edges_counter .req r5
  ldr for_sector_edges_counter, [sect_ptr, #28]  /* sector->sidec */
  for_sector_edges:
    /* Load vertices */
    ldr tmp, [vertex_array]
    vldr.f32 vx1, [tmp]
    vldr.f32 vy1, [tmp, #4]

    ldr tmp, [vertex_array, #4]
    vldr.f32 vx2, [tmp]
    vldr.f32 vy2, [tmp, #4]

    /* ------------- */
    vmov s2, x
    vmov s3, y
    bl point_side_f
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR
    beq intersects
    vadd.f32 s2, x, dx
    vadd.f32 s3, y, dy
    bl point_side_f
    blt less_than
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR
    bgt next_for_sector_edges
    b intersects
    less_than:
    vcmp.f32 s0, #0
    vmrs APSR_nzcv, FPSCR

    intersects:

    ldr tmp, [neighbour_ptr]
    cmp tmp, #-1
    beq end_movement


    /* Set current thing sector to the new sector it just entered to */
    push {r3, r4, r5}
      ldr r5, [neighbour_ptr]
      ldr r5, [r5, #12]
      mov r4, #0
      loop_sector_things_1:
        ldr r3, [r5, r4, lsl #2]
        cmp r3, #0
        moveq r3, #0
        streq enemy_ptr, [r5, r4, lsl #2]
        beq end_loop_sector_things_1
        add r4, #1
        cmp r4, #10
        bne loop_sector_things_1
        end_loop_sector_things_1:
    pop {r3, r4, r5}
    push {r3, r4, r5}
      ldr r5, [sect_ptr, #12]
      mov r4, #0
      loop_sector_things:
        ldr r3, [r5, r4, lsl #2]
        cmp r3, enemy_ptr
        moveq r3, #0
        streq r3, [r5, r4, lsl #2]
        beq end_loop_sector_things
        add r4, #1
        cmp r4, #10
        bne loop_sector_things
      end_loop_sector_things:
    pop {r3, r4, r5}

    b end_for_sector_edges
      
  next_for_sector_edges:
  add vertex_array, #4                           @| s++
  add neighbour_ptr, #4
  sub for_sector_edges_counter, #1
  cmp for_sector_edges_counter, #0
  bgt for_sector_edges

  end_for_sector_edges:

  /* Actually move thing */

  vadd.f32 x, dy
  vadd.f32 y, dx
  vstr.f32 x, [enemy_ptr, #4]
  vstr.f32 y, [enemy_ptr, #8]

  end_movement:

  vpop {s0-s14}
  pop {r0-r6}
  pop {pc}

/*
  Decrement player's health by enemy's attack.
  params:
    r0 : enemy address
  returns:
    none
  clobbers:
    none
*/
enemy_attack:
  push {lr}
  push {r0-r3}
  ldr r1, =enemy_timer
  ldr r1, [r1]
  ldr r2, [r0, #24]               @ enemy timestamp
  sub r3, r1, r2
  cmp r3, #3
  blt end_enemy_attack$
    str r1, [r0, #24]             @ str new timestamp
    ldr r0, [r0, #16]             @ r0 = ptr to enemy type
    ldr r0, [r0, #4]              @ r0 = enemy attack
    ldr r1, =player_health
    ldr r2, [r1]                  @ r1 = player health
    sub r2, r0
    cmp r2, #0
    /* Statusbar not handling negatives well TODO fix that */
    movlt r2, #0
    str r2, [r1]
  end_enemy_attack$:
  pop {r0-r3}
  pop {pc}

/*
  Returns enemy's image based on the enemy_timer state and enemy state
  NB: enemy states : (0 : idle, 1 : dead, 2 : moving, 3 : attack)
      timer states : 0, 1, 2, 3, 4, 5..
  params:
    r0 : enemy address
  returns:
    r0 : pointer to current image of enemy
*/
enemy_get_image:
  push {lr}
  push {r1}
  
  ldr r1, [r0, #20]         @ r1 = enemy state 
  ldr r0, [r0, #16]         @ r0 = ptr to enemy_type
  cmp r1, #0
  beq idle_image$
  cmp r1, #1
  beq dead_image$
  cmp r1, #2
  beq moving_image$
  cmp r1, #3
  beq attack_image$

  idle_image$:
    add r0, #12
    ldr r0, [r0]
    b end_get_image$

  dead_image$:
    add r0, #16
    ldr r0, [r0]
    b end_get_image$

  moving_image$:
    add r0, #20               @ r0 = ptr to first 'moving' sprite
    ldr r1, =enemy_timer
    ldr r1, [r1]              @ r1 = current timer state
    and r1, #0b11             @ r1 = last 2 bits of timer state
    ldr r0, [r0, r1, lsl #2]  @ r0 = pointer to current image
    b end_get_image$

  attack_image$:
    add r0, #36               @ r0 = ptr to first 'attack' sprite
    ldr r1, =enemy_timer
    ldr r1, [r1]              @ r1 = current timer state
    and r1, #1                @ r1 = last bit of timer state
    ldr r0, [r0, r1, lsl #2]  @ r0 = pointer to current image
    b end_get_image$

  end_get_image$:
  pop {r1}
  pop {pc}


/*
  Enemy at address loses r1 HPs if it had positive HP before shooting.
  Enemy health might end up negative.
  params:
    r0 : enemy address
    r1 : damage
  returns:
    none
  clobbers:
    none 
*/
enemy_lose_health:
  push {lr}
  push {r2}
  ldr r2, [r0, #12]               @ r2 = enemy's health
  cmp r2, r1
  subgt r2, r1
  movle r2, #0
  str r2, [r0, #12]
  pop {r2}
  pop {pc}

/*
  Returns 1 if the enemy's state is dead, 0 otherwise
  params:
    r0 : address of enemy
  returns:
    r0 : 1 if enemy's dead, 0 if not
*/
enemy_is_dead:
  ldr r0, [r0, #20]     @ r0 = enemy's state
  cmp r0, #1
  movne r0, #0
  mov pc, lr
