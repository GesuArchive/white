/obj/item/crowbar/freeman
	name = "монтировка"
	desc = "Ржавый лом."
	icon = 'white/valtos/icons/black_mesa/freeman.dmi'
	icon_state = "crowbar"
	force = 35
	throwforce = 45
	toolspeed = 0.1
	wound_bonus = 10
	hitsound = 'white/valtos/sounds/black_mesa/crowbar2.ogg'
	mob_throw_hit_sound = 'white/valtos/sounds/black_mesa/crowbar2.ogg'
	force_opens = TRUE

/obj/item/crowbar/freeman/ultimate
	name = "монтировка Гордона Фримена"
	desc = "Оружие, которым владел один известный физик, кровь сотен людей просачивается сквозь этот стержень из железа и злобы."
	force = 45

/obj/item/crowbar/freeman/ultimate/Initialize(mapload)
	. = ..()
	add_filter("rad_glow", 2, list("type" = "outline", "color" = "#fbff1479", "size" = 2))

/obj/item/ballistic_broken
	name = "сломанный баллистический щит"
	desc = "Неразрушимая мешанина из стали и кевлара. Точно неразрушимая?"
	icon_state = "ballistic_broken"
	icon = 'white/valtos/icons/black_mesa/ballistic.dmi'
	w_class = WEIGHT_CLASS_BULKY
