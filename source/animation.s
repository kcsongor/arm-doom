.globl hero_avatar_idle
.globl hero_avatar_shoot
.globl shotgun_reload_animation


.section .data
.align 4
hero_avatar_idle:
.int 4 /* sequence length */

.int hero_avatar_h20_idle_m
.int hero_avatar_h20_idle_l
.int hero_avatar_h20_idle_m
.int hero_avatar_h20_idle_r

.int hero_avatar_h40_idle_m
.int hero_avatar_h40_idle_l
.int hero_avatar_h40_idle_m
.int hero_avatar_h40_idle_r

.int hero_avatar_h60_idle_m
.int hero_avatar_h60_idle_l
.int hero_avatar_h60_idle_m
.int hero_avatar_h60_idle_r


.int hero_avatar_h80_idle_m
.int hero_avatar_h80_idle_l
.int hero_avatar_h80_idle_m
.int hero_avatar_h80_idle_r

.int hero_avatar_h100_idle_m
.int hero_avatar_h100_idle_l
.int hero_avatar_h100_idle_m
.int hero_avatar_h100_idle_r

hero_avatar_shoot:
.int 4 /* sequence length */

.int hero_avatar_h20_shoot_l
.int hero_avatar_h20_shoot_r
.int hero_avatar_h20_shoot_l
.int hero_avatar_h20_shoot_r

.int hero_avatar_h40_shoot_l
.int hero_avatar_h40_shoot_r
.int hero_avatar_h40_shoot_l
.int hero_avatar_h40_shoot_r

.int hero_avatar_h60_shoot_l
.int hero_avatar_h60_shoot_l
.int hero_avatar_h60_shoot_r
.int hero_avatar_h60_shoot_r

.int hero_avatar_h80_shoot_l
.int hero_avatar_h80_shoot_r
.int hero_avatar_h80_shoot_l
.int hero_avatar_h80_shoot_r

.int hero_avatar_h100_shoot_l
.int hero_avatar_h100_shoot_r
.int hero_avatar_h100_shoot_l
.int hero_avatar_h100_shoot_r

shotgun_reload_animation:
.int 7
.int shotgun_reload_0
.int shotgun_reload_1
.int shotgun_reload_2
.int shotgun_reload_3
.int shotgun_reload_4
.int shotgun_reload_2
.int shotgun_reload_0
