//Used for normal mobs that have hands.
/datum/hud/dextrous/New(mob/living/owner)
	..()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/drop()
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = UI_DRONE_DROP
	using.hud = src
	static_inventory += using

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = retro_hud ? ui_style : using.icon
	pull_icon.update_icon()
	pull_icon.screen_loc = UI_DRONE_PULL
	pull_icon.hud = src
	static_inventory += pull_icon

	build_hand_slots(TRUE)

	using = new /atom/movable/screen/swap_hand()
	using.icon = ui_style
	using.icon_state = "swap_1_m"
	using.screen_loc = ui_swaphand_position(owner, 1, TRUE)
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/swap_hand()
	using.icon = ui_style
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(owner, 2, TRUE)
	using.hud = src
	static_inventory += using

	if(mymob.possible_a_intents)
		if(mymob.possible_a_intents.len == 4)
			// All possible intents - full intent selector
			action_intent = new /atom/movable/screen/act_intent/segmented
		else
			action_intent = new /atom/movable/screen/act_intent
			action_intent.icon = ui_style
		action_intent.icon = retro_hud ? 'icons/hud/screen_gen.dmi' : action_intent.icon
		action_intent.screen_loc = retro_hud ? UI_ACTI_RETRO : UI_ACTI
		action_intent.icon_state = mymob.a_intent
		action_intent.hud = src
		static_inventory += action_intent


	zone_select = new /atom/movable/screen/zone_sel()
	zone_select.retro_hud = retro_hud
	zone_select.icon = retro_hud ? ui_style : zone_select.icon
	zone_select.overlay_icon = retro_hud ? 'icons/hud/screen_gen.dmi' : zone_select.icon
	zone_select.screen_loc = retro_hud ? UI_ZONESEL_RETRO : UI_ZONESEL
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select

	using = new /atom/movable/screen/area_creator
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_BOXAREA_RETRO : UI_BOXAREA
	using.hud = src
	static_inventory += using

	mymob.client.clear_screen()

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_icon()

/datum/hud/dextrous/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/D = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in D.held_items)
			I.screen_loc = ui_hand_position(D.get_held_index_of_item(I), TRUE)
			D.client.screen += I
	else
		for(var/obj/item/I in D.held_items)
			I.screen_loc = null
			D.client.screen -= I


//Dextrous simple mobs can use hands!
/mob/living/simple_animal/create_mob_hud()
	if(dextrous)
		hud_type = dextrous_hud_type
	return ..()
