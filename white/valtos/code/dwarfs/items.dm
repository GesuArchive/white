/obj/structure/dwarf_altar
	name = "Алтарь"
	desc = "Руны оо мм ммм."
	icon = 'white/valtos/icons/dwarfs/altar.dmi'
	icon_state = "altar_inactive"
	density = TRUE
	anchored = TRUE
	layer = FLY_LAYER
	var/active
	var/resources = 0
	var/resources_max = 350
	var/list/allowed_resources = list(/obj/item/blacksmith/ingot/gold)
	var/list/resource_values = list(/obj/item/blacksmith/ingot/gold=50)

/obj/structure/dwarf_altar/Initialize()
	. = ..()
	set_light(1)

/obj/structure/dwarf_altar/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Уровень ресурсов: <b>[resources]/[resources_max]</b>.</span>"

/obj/structure/dwarf_altar/proc/activate()
	notify_ghosts("Новый дворф готов.", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Спавн дворфа доступен.")
	active = TRUE
	icon_state = "altar_active"
	update_icon()

/obj/structure/dwarf_altar/attack_ghost(mob/user)
	. = ..()
	summon_dwarf(user)

/obj/structure/dwarf_altar/proc/summon_dwarf(mob/user)
	if(!active)
		return FALSE
	var/dwarf_ask = alert("Стать дворфом?", "КОПАТЬ?", "Да", "Нет")
	if(dwarf_ask == "No" || !src || QDELETED(src) || QDELETED(user))
		return FALSE
	if(!active)
		to_chat(user, "<span class='warning'>Уже занято!</span>")
		return FALSE
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(loc)
	H.set_species(/datum/species/dwarf)
	H.equipOutfit(/datum/outfit/dwarf)
	H.key = user.key
	deactivate()

/obj/structure/dwarf_altar/proc/deactivate()
	active = FALSE
	resources = 0
	icon_state = "altar_inactive"
	update_icon()

/obj/structure/dwarf_altar/attackby(obj/item/I, mob/living/user, params)
	if((I.type in allowed_resources) && (resources < resources_max))
		to_chat(user, "<span class='notice'>Жертвую [I.name]</span>")
		resources+=resource_values[I.type]
		qdel(I)
		if(resources>=resources_max)
			resources=resources_max
			activate()
			visible_message("<span class='notice'>Руны на алтаре начинают мигать!</span>")
	else if((I.type in allowed_resources) && (resources == resources_max))
		to_chat(user, "<span class='notice'>В алтарь больше не влазит!</span>")
	else
		..()
