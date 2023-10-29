/obj/item/ammo_casing/shotgun/bombslug
	name = "12 Калибр: FRAG-80"
	desc = "Смерть до горизонта."
	icon = 'white/hule/icons/obj/weapons.dmi'
	icon_state = "bombslug"
	projectile_type = /obj/projectile/bullet/shotgun_bombslug

/obj/projectile/bullet/shotgun_bombslug
	name ="СМЕРТЬ"
	icon_state = "missile"
	damage = 25
	knockdown = 50

/obj/projectile/bullet/shotgun_bombslug/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, devastation_range = 5, heavy_impact_range = 10, light_impact_range = 15)
	return TRUE
