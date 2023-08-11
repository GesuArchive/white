/obj/item/gun/energy/lovegun
	name = "love gun"
	icon_state = "dildo"
	inhand_icon_state = "dildo"
	icon = 'white/valtos/icons/melee.dmi'
	desc = "Сила магии дружбы проникает в меня, пока ты смотришь на это."
	fire_sound = 'white/valtos/sounds/love/shot1.ogg'
	var/list/random_sound = list('white/valtos/sounds/love/shot1.ogg',
							'white/valtos/sounds/love/shot2.ogg',
							'white/valtos/sounds/love/shot3.ogg',
							'white/valtos/sounds/love/shot4.ogg',
							'white/valtos/sounds/love/shot5.ogg',
							'white/valtos/sounds/love/shot6.ogg',
							'white/valtos/sounds/love/shot7.ogg',
							'white/valtos/sounds/love/shot8.ogg',
							'white/valtos/sounds/love/shot9.ogg')
	ammo_type = list(/obj/item/ammo_casing/energy/lovegun)
	selfcharge = 1
	burst_size = 1
	clumsy_check = 0
	item_flags = NONE

/obj/item/gun/energy/lovegun/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE, atom/shooter = null)
	. = ..()
	fire_sound = pick(random_sound)

/obj/item/ammo_casing/energy/lovegun
	projectile_type = /obj/projectile/beam/lovegun
	select_name = "lovegun"
	harmful = FALSE

/obj/projectile/beam/lovegun
	name = "heart"
	icon_state = "heart"
	icon = 'white/valtos/icons/projectiles.dmi'
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 0
	speed = 3
	light_range = 2
	eyeblur = 0
	damage_type = STAMINA
	light_color = LIGHT_COLOR_PINK

/obj/projectile/beam/lovegun/on_hit(atom/target, blocked = FALSE)
	. = ..()
	playsound(target, pick(GLOB.gachisounds), 25, FALSE)
	new /obj/effect/temp_visual/love_heart(get_turf(target.loc))
	new /obj/effect/temp_visual/love_heart(get_turf(target.loc))
	new /obj/effect/temp_visual/love_heart(get_turf(target.loc))
