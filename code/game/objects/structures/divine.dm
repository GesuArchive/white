/obj/structure/sacrificealtar
	name = "жертвенный алтарь"
	desc = "Алтарь, предназначенный для совершения кровавого жертвоприношения божеству. Щелкните его, удерживая Alt, чтобы принести в жертву пригнанное на заклание существо."
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "sacrificealtar"
	anchored = TRUE
	density = FALSE
	can_buckle = 1

/obj/structure/sacrificealtar/AltClick(mob/living/user)
	..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	if(!has_buckled_mobs())
		return
	var/mob/living/L = locate() in buckled_mobs
	if(!L)
		return
	to_chat(user, span_notice("Призывая священный ритуал, вы жертвуете [L]."))
	L.gib()
	message_admins("[ADMIN_LOOKUPFLW(user)] has sacrificed [key_name_admin(L)] on the sacrificial altar at [AREACOORD(src)].")

/obj/structure/healingfountain
	name = "исцеляющий фонтан"
	desc = "Фонтан с живой водой"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "fountain"
	anchored = TRUE
	density = TRUE
	var/time_between_uses = 1800
	var/last_process = 0

/obj/structure/healingfountain/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(last_process + time_between_uses > world.time)
		to_chat(user, span_notice("Фонтан кажется пуст."))
		return
	last_process = world.time
	to_chat(user, span_notice("Поток теплой и успокаивающей воды струится между вашими пальцами. Вскоре после этого фонтан иссыхает."))
	user.reagents.add_reagent(/datum/reagent/medicine/omnizine/godblood,20)
	update_icon()
	addtimer(CALLBACK(src, /atom/.proc/update_icon), time_between_uses)


/obj/structure/healingfountain/update_icon_state()
	if(last_process + time_between_uses > world.time)
		icon_state = "fountain"
	else
		icon_state = "fountain-red"
