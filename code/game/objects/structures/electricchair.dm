
/obj/structure/chair/e_chair
	name = "электрический стул"
	desc = "Выглядит абсолютно ШОКИРУЮЩИМ!"
	icon = 'icons/obj/chairs.dmi'
	icon_state = "echair0"
	var/last_time = 1
	item_chair = null

/obj/structure/chair/e_chair/Initialize(mapload)
	. = ..()
	var/obj/item/assembly/shock_kit/stored_kit = new(contents)
	var/image/export_to_component = image('icons/obj/chairs.dmi', loc, "echair_over")
	AddComponent(/datum/component/electrified_buckle, (SHOCK_REQUIREMENT_ITEM | SHOCK_REQUIREMENT_LIVE_CABLE | SHOCK_REQUIREMENT_SIGNAL_RECEIVED_TOGGLE), stored_kit, list(export_to_component))

/obj/structure/chair/e_chair/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH)
		var/obj/structure/chair/C = new /obj/structure/chair(loc)
		W.play_tool_sound(src)
		C.setDir(dir)
		qdel(src)
		return
	. = ..()
