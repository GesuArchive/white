/obj/projectile/bullet/mm65
	name = "6.5mm XJ импульсная флешетта"
	icon = 'white/valtos/icons/projectiles.dmi'
	icon_state = "pulsebullet"
	damage = 18 //Applied Twice, once BRUTE, once BURN
	speed = 0.7
	wound_bonus = 25
	embedding = list(embed_chance=30, fall_chance=3, jostle_chance=4, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=6, rip_time=10)
	armour_penetration = 40
	damage_type = BRUTE //Additionally Deals BURN in on_hit

/obj/projectile/bullet/mm65/on_hit(atom/target, blocked = FALSE, pierce_hit)
	. = ..()
	//We don't want the burn damage to go through if the bullet itself is stopped
	if (blocked == 100)
		return .

	//Strictly only to things that are living
	if(isliving(target))
		var/mob/living/victim = target
		victim.apply_damage(damage, BURN, def_zone, blocked, wound_bonus = wound_bonus, bare_wound_bonus = bare_wound_bonus, sharpness = sharpness)
		victim.apply_damage(damage, STAMINA, def_zone, blocked)


/obj/item/ammo_casing/mm65
	name = "6.5mm биоразлагающаяся флешетта"
	desc = "Биоразлагаемый 6,5-миллиметровый импульсный флешет, кажется, заключен в какую-то инертную батарею."
	icon = 'white/valtos/icons/ammo.dmi'
	icon_state = "si-casing"
	caliber = "6.5mm"
	projectile_type = /obj/projectile/bullet/mm65


/obj/projectile/bullet/mm72
	name = "7.2mm XJ сверхзвуковая импульсная флешетта"
	icon = 'white/valtos/icons/projectiles.dmi'
	icon_state = "pulsebullet_mg"
	damage = 11 //Applied Twice, once BRUTE, once BURN
	speed = 0.8
	wound_bonus = 60
	embedding = list(embed_chance=80, fall_chance=1, jostle_chance=20, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=0.8, rip_time=20)
	armour_penetration = 60
	damage_type = BRUTE //Additionally Deals BURN in on_hit

/obj/projectile/bullet/mm72/on_hit(atom/target, blocked = FALSE, pierce_hit)
	. = ..()
	//We don't want the burn damage to go through if the bullet itself is stopped
	if (blocked == 100)
		return .

	//Strictly only to things that are living
	if(isliving(target))
		var/mob/living/victim = target
		victim.apply_damage(damage, BURN, def_zone, blocked, wound_bonus = wound_bonus, bare_wound_bonus = bare_wound_bonus, sharpness = sharpness)
		victim.apply_damage(damage, STAMINA, def_zone, blocked)


/obj/item/ammo_casing/mm72
	name = "7.2mm биоразлагающаяся флешетта"
	desc = "Биоразлагаемый 7,2-миллиметровый импульсный флешет, кажется, заключен в какую-то инертную батарею с тяжелым основанием."
	icon = 'white/valtos/icons/ammo.dmi'
	icon_state = "si-casing"
	caliber = "7.2mm"
	projectile_type = /obj/projectile/bullet/mm72


/obj/projectile/bullet/mm12/saphe
	name = "12.7x35mm сабо пуля AP-HE"
	icon = 'white/valtos/icons/projectiles.dmi'
	icon_state = "pulsebullet"
	damage = 65
	speed = 1.25  //Heavy ass round
	wound_bonus = 90
	embedding = list(embed_chance=10, fall_chance=1, jostle_chance=6, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=5, rip_time=80)
	armour_penetration = 40
	damage_type = BRUTE

/obj/item/ammo_casing/mm12
	name = "12.7x35mm биоразлагаемый сабо"
	desc = "Биоразлагаемая импульсная пуля .50, кажется, заключена в какую-то инертную батарею."
	icon = 'white/valtos/icons/ammo.dmi'
	icon_state = "si-casing"
	caliber = "12mm SAP-HE"
	projectile_type = /obj/projectile/bullet/mm12/saphe
