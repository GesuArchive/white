/obj/projectile/neurotoxin
	name = "нейротоксиновый плевок"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX
	nodamage = FALSE
	knockdown = 100
	stamina = 60
	flag = BIO
	impact_effect_type = /obj/effect/temp_visual/impact_effect/neurotoxin

/obj/projectile/neurotoxin/on_hit(atom/target, blocked = FALSE)
	if(isalien(target))
		knockdown = 0
		stamina = 0
		nodamage = TRUE
	return ..()
