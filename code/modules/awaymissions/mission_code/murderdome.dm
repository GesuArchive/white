
/obj/structure/window/reinforced/fulltile/indestructable
	name = "robust window"
	flags_1 = PREVENT_CLICK_UNDER_1 | NODECONSTRUCT_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/grille/indestructable
	flags_1 = CONDUCT_1 | NODECONSTRUCT_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF


/obj/structure/grille/indestructable/shocking
	var/obj/item/stock_parts/cell/infinite/power_source


/obj/structure/grille/indestructable/shocking/Initialize(mapload)
	. = ..()
	power_source = new

/obj/structure/grille/indestructable/shocking/Destroy()
	qdel(power_source)
	. = ..()

/obj/structure/grille/indestructable/shocking/shock(mob/user, prb)
	if(!prob(prb))
		return FALSE
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE

	if(electrocute_mob(user, power_source, src, 1, TRUE))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		return TRUE
	return FALSE

/obj/effect/spawner/structure/window/reinforced/indestructable
	spawn_list = list(/obj/structure/grille/indestructable, /obj/structure/window/reinforced/fulltile/indestructable)

/obj/structure/barricade/security/murderdome
	name = "respawnable barrier"
	desc = "A barrier. Provides cover in firefights."
	deploy_time = 0
	deploy_message = 0

/obj/structure/barricade/security/murderdome/make_debris()
	new /obj/effect/murderdome/dead_barricade(get_turf(src))

/obj/effect/murderdome/dead_barricade
	name = "dead barrier"
	desc = "It provided cover in fire fights. And now it's gone."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrier0"
	alpha = 100

/obj/effect/murderdome/dead_barricade/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(respawn)), 3 MINUTES)

/obj/effect/murderdome/dead_barricade/proc/respawn()
	if(!QDELETED(src))
		new /obj/structure/barricade/security/murderdome(get_turf(src))
		qdel(src)
