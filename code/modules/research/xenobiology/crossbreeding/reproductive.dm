/*
Reproductive extracts:
	When fed three monkey cubes, produces between
	1 and 4 normal slime extracts of the same colour.
*/
/obj/item/slimecross/reproductive
	name = "reproductive extract"
	desc = "It pulses with a strange hunger."
	icon_state = "reproductive"
	effect = "reproductive"
	effect_desc = "When fed monkey cubes it produces a baby slime. Bio bag compatible as well."
	var/extract_type = /obj/item/slime_extract/
	var/cooldown = 60 SECONDS
	var/feedAmount = 3
	var/last_produce = 0
	var/datum/component/storage/concrete/extract_inventory/slimeStorage

/obj/item/slimecross/reproductive/examine()
	. = ..()
	. += span_danger("Уже скушал [length(contents)] кубов.")

/obj/item/slimecross/reproductive/Initialize()
	. = ..()
	slimeStorage = AddComponent(/datum/component/storage/concrete/extract_inventory)

/obj/item/slimecross/reproductive/attackby(obj/item/O, mob/user)
	if((last_produce + cooldown) > world.time)
		to_chat(user, span_warning("[capitalize(src.name)] is still digesting!"))
		return
	if(length(contents) >= feedAmount) //if for some reason the contents are full, but it didnt digest, attempt to digest again
		to_chat(user, span_warning("[src] appears to be full but is not digesting! Maybe poking it stimulated it to digest."))
		slimeStorage.processCubes(src, user)
		return
	if(istype(O, /obj/item/storage/bag/bio))
		var/list/inserted = list()
		SEND_SIGNAL(O, COMSIG_TRY_STORAGE_TAKE_TYPE, /obj/item/food/monkeycube, src, feedAmount - length(contents), TRUE, FALSE, user, inserted)
		if(inserted.len)
			to_chat(user, span_notice("You feed [length(inserted)] Monkey Cube[p_s()] to [src], and it pulses gently."))
			playsound(src, 'sound/items/eatfood.ogg', 20, TRUE)
			slimeStorage.processCubes(src, user)
		else
			to_chat(user, span_warning("There are no monkey cubes in the bio bag!"))
	return

/obj/item/slimecross/reproductive/Destroy()
	slimeStorage = null
	return ..()

/obj/item/slimecross/reproductive/grey
	colour = "grey"

/obj/item/slimecross/reproductive/orange
	colour = "orange"

/obj/item/slimecross/reproductive/purple
	colour = "purple"

/obj/item/slimecross/reproductive/blue
	colour = "blue"

/obj/item/slimecross/reproductive/metal
	colour = "metal"

/obj/item/slimecross/reproductive/yellow
	colour = "yellow"

/obj/item/slimecross/reproductive/darkpurple
	colour = "dark purple"

/obj/item/slimecross/reproductive/darkblue
	colour = "dark blue"

/obj/item/slimecross/reproductive/silver
	colour = "silver"

/obj/item/slimecross/reproductive/bluespace
	colour = "bluespace"

/obj/item/slimecross/reproductive/sepia
	colour = "sepia"

/obj/item/slimecross/reproductive/cerulean
	colour = "cerulean"

/obj/item/slimecross/reproductive/pyrite
	colour = "pyrite"

/obj/item/slimecross/reproductive/red
	colour = "red"

/obj/item/slimecross/reproductive/green
	colour = "green"

/obj/item/slimecross/reproductive/pink
	colour = "pink"

/obj/item/slimecross/reproductive/gold
	colour = "gold"

/obj/item/slimecross/reproductive/oil
	colour = "oil"

/obj/item/slimecross/reproductive/black
	colour = "black"

/obj/item/slimecross/reproductive/lightpink
	colour = "light pink"

/obj/item/slimecross/reproductive/adamantine
	colour = "adamantine"

/obj/item/slimecross/reproductive/rainbow
	colour = "rainbow"
