.globl game_over_0
.globl game_over_1
.globl ImageAddress
.globl SmileAddress
.globl TextureAddress
.globl TextureAddress_2
.globl TextureAddress_3
.globl StatusBarAddress

.globl hero_avatar_h100_idle_l
.globl hero_avatar_h100_idle_m
.globl hero_avatar_h100_idle_r
.globl hero_avatar_h80_idle_l
.globl hero_avatar_h80_idle_m
.globl hero_avatar_h80_idle_r
.globl hero_avatar_h60_idle_l
.globl hero_avatar_h60_idle_m
.globl hero_avatar_h60_idle_r
.globl hero_avatar_h40_idle_l
.globl hero_avatar_h40_idle_m
.globl hero_avatar_h40_idle_r
.globl hero_avatar_h20_idle_l
.globl hero_avatar_h20_idle_m
.globl hero_avatar_h20_idle_r

.globl hero_avatar_h100_shoot_l
.globl hero_avatar_h100_shoot_r
.globl hero_avatar_h80_shoot_l
.globl hero_avatar_h80_shoot_r
.globl hero_avatar_h60_shoot_l
.globl hero_avatar_h60_shoot_r
.globl hero_avatar_h40_shoot_l
.globl hero_avatar_h40_shoot_r
.globl hero_avatar_h20_shoot_l
.globl hero_avatar_h20_shoot_r

.globl pistol_idle
.globl pistol_shoot

.globl shotgun_idle
.globl shotgun_shoot
.globl shotgun_reload_0
.globl shotgun_reload_1
.globl shotgun_reload_2
.globl shotgun_reload_3
.globl shotgun_reload_4

.globl health_img
.globl ammo_img
.globl armor_img

.globl type_0_idle
.globl type_0_dead
.globl type_0_moving_0
.globl type_0_moving_1
.globl type_0_moving_2
.globl type_0_moving_3
.globl type_0_attack_0
.globl type_0_attack_1
.globl type_1_idle
.globl type_1_dead
.globl type_1_moving_0
.globl type_1_moving_1
.globl type_1_moving_2
.globl type_1_moving_3
.globl type_1_attack_0
.globl type_1_attack_1
.globl type_2_idle
.globl type_2_dead
.globl type_2_moving_0
.globl type_2_moving_1
.globl type_2_moving_2
.globl type_2_moving_3
.globl type_2_attack_0
.globl type_2_attack_1

.section .data
.align 4
game_over_0:
.incbin "images/gameover/game_over_0.bmap"

.align 4
game_over_1:
.incbin "images/gameover/game_over_1.bmap"

.align 4
ImageAddress:
.incbin "images/status_bar/status_bar.bmap"

.align 4
SmileAddress:
.incbin "images/doom.bmap"

.align 4
TextureAddress:
.incbin "images/wall_2.bmap"

.align 4
TextureAddress_2:
.incbin "images/wall_1.bmap"

.align 4
TextureAddress_3:
.incbin "images/wall_4.bmap"

StatusBarAddress:
.incbin "images/blank_status_bar.bmap"

/* ****** HERO AVATAR ****** */

/* **   idle   * **/	
hero_avatar_h100_idle_l:
.incbin "/images/avatar/h100_idle_l.bmap"

hero_avatar_h100_idle_m:
.incbin "/images/avatar/h100_idle_m.bmap"

hero_avatar_h100_idle_r:
.incbin "/images/avatar/h100_idle_r.bmap"

hero_avatar_h80_idle_l:
.incbin "/images/avatar/h80_idle_l.bmap"

hero_avatar_h80_idle_m:
.incbin "/images/avatar/h80_idle_m.bmap"

hero_avatar_h80_idle_r:
.incbin "/images/avatar/h80_idle_r.bmap"

hero_avatar_h60_idle_l:
.incbin "/images/avatar/h60_idle_l.bmap"

hero_avatar_h60_idle_m:
.incbin "/images/avatar/h60_idle_m.bmap"

hero_avatar_h60_idle_r:
.incbin "/images/avatar/h60_idle_r.bmap"

hero_avatar_h40_idle_l:
.incbin "/images/avatar/h40_idle_l.bmap"

hero_avatar_h40_idle_m:
.incbin "/images/avatar/h40_idle_m.bmap"

hero_avatar_h40_idle_r:
.incbin "/images/avatar/h40_idle_r.bmap"

hero_avatar_h20_idle_l:
.incbin "/images/avatar/h20_idle_l.bmap"

hero_avatar_h20_idle_m:
.incbin "/images/avatar/h20_idle_m.bmap"

hero_avatar_h20_idle_r:
.incbin "/images/avatar/h20_idle_r.bmap"

/* **   shoot   * **/	
hero_avatar_h100_shoot_l:
.incbin "/images/avatar/h100_shoot_l.bmap"

hero_avatar_h100_shoot_r:
.incbin "/images/avatar/h100_shoot_r.bmap"

hero_avatar_h80_shoot_l:
.incbin "/images/avatar/h80_shoot_l.bmap"

hero_avatar_h80_shoot_r:
.incbin "/images/avatar/h80_shoot_r.bmap"

hero_avatar_h60_shoot_l:
.incbin "/images/avatar/h60_shoot_l.bmap"

hero_avatar_h60_shoot_r:
.incbin "/images/avatar/h60_shoot_r.bmap"

hero_avatar_h40_shoot_l:
.incbin "/images/avatar/h40_shoot_l.bmap"

hero_avatar_h40_shoot_r:
.incbin "/images/avatar/h40_shoot_r.bmap"

hero_avatar_h20_shoot_l:
.incbin "/images/avatar/h20_shoot_l.bmap"

hero_avatar_h20_shoot_r:
.incbin "/images/avatar/h20_shoot_r.bmap"



/* ****** WEAPONS ****** */

/* Pistol */
pistol_idle:
.incbin "/images/weapons/pistol_idle.bmap"

pistol_shoot:
.incbin "/images/weapons/pistol_shoot.bmap"

/* Shotgun */
shotgun_idle:
.incbin "/images/weapons/shotgun_idle.bmap"

shotgun_shoot:
.incbin "/images/weapons/shotgun_shoot.bmap"

shotgun_reload_0:
.incbin "/images/weapons/shotgun_reload_0.bmap"

shotgun_reload_1:
.incbin "/images/weapons/shotgun_reload_1.bmap"

shotgun_reload_2:
.incbin "/images/weapons/shotgun_reload_2.bmap"

shotgun_reload_3:
.incbin "/images/weapons/shotgun_reload_3.bmap"

shotgun_reload_4:
.incbin "/images/weapons/shotgun_reload_4.bmap"

/* ***** POWER-UPS ***** */
.align 4
health_img:
.incbin "/images/items/health_pack.bmap"

.align 4
ammo_img:
.incbin "/images/items/ammo_pack.bmap"

.align 4
armor_img:
.incbin "/images/items/armour.bmap"

/* ****** ENEMIES ****** */

/* Type 0 */
.align 4
type_0_idle:
.incbin "/images/enemy_t0/idle.bmap"

.align 4
type_0_dead:
.incbin "/images/enemy_t0/dead.bmap"

.align 4
type_0_moving_0:
.incbin "/images/enemy_t0/moving_0.bmap"

.align 4
type_0_moving_1:
.incbin "/images/enemy_t0/moving_1.bmap"

.align 4
type_0_moving_2:
.incbin "/images/enemy_t0/moving_2.bmap"

.align 4
type_0_moving_3:
.incbin "/images/enemy_t0/moving_3.bmap"

.align 4
type_0_attack_0:
.incbin "/images/enemy_t0/attack_0.bmap"

.align 4
type_0_attack_1:
.incbin "/images/enemy_t0/attack_1.bmap"

.align 4
type_1_idle:
.incbin "/images/enemy_t1/idle.bmap"

.align 4
type_1_dead:
.incbin "/images/enemy_t1/dead.bmap"

.align 4
type_1_moving_0:
.incbin "/images/enemy_t1/moving_0.bmap"

.align 4
type_1_moving_1:
.incbin "/images/enemy_t1/moving_1.bmap"

.align 4
type_1_moving_2:
.incbin "/images/enemy_t1/moving_2.bmap"

.align 4
type_1_moving_3:
.incbin "/images/enemy_t1/moving_3.bmap"

.align 4
type_1_attack_0:
.incbin "/images/enemy_t1/attack_0.bmap"

.align 4
type_1_attack_1:
.incbin "/images/enemy_t1/attack_1.bmap"

.align 4
type_2_idle:
.incbin "/images/enemy_t2/idle.bmap"

.align 4
type_2_dead:
.incbin "/images/enemy_t2/dead.bmap"

.align 4
type_2_moving_0:
.incbin "/images/enemy_t2/moving_0.bmap"

.align 4
type_2_moving_1:
.incbin "/images/enemy_t2/moving_1.bmap"

.align 4
type_2_moving_2:
.incbin "/images/enemy_t2/moving_2.bmap"

.align 4
type_2_moving_3:
.incbin "/images/enemy_t2/moving_3.bmap"

.align 4
type_2_attack_0:
.incbin "/images/enemy_t2/attack_0.bmap"

.align 4
type_2_attack_1:
.incbin "/images/enemy_t2/attack_1.bmap"
