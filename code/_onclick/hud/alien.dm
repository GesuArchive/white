/atom/movable/screen/alien
	icon = 'icons/hud/screen_alien.dmi'

/atom/movable/screen/alien/leap
	name = "toggle leap"
	icon_state = "leap_off"

/atom/movable/screen/alien/leap/Click()
	if(isalienhunter(usr))
		var/mob/living/carbon/alien/humanoid/hunter/AH = usr
		AH.toggle_leap()

/atom/movable/screen/alien/plasma_display
	name = "plasma stored"
	icon_state = "power_display"
	screen_loc = UI_ALIENPLASMADISPLAY

/atom/movable/screen/alien/alien_queen_finder
	name = "queen sense"
	desc = "Allows you to sense the general direction of your Queen."
	icon_state = "queen_finder"
	screen_loc = UI_ALIEN_QUEEN_FINDER

/datum/hud/alien
	ui_style = 'icons/hud/screen_alien.dmi'

/datum/hud/alien/New(mob/living/carbon/alien/humanoid/owner)
	..()

	var/atom/movable/screen/using

//equippable shit

//hands
	build_hand_slots(TRUE)

//begin buttons

	using = new /atom/movable/screen/swap_hand()
	using.icon = ui_style
	using.icon_state = "swap_1"
	using.screen_loc = ui_swaphand_position(owner, 1, TRUE)
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/swap_hand()
	using.icon = ui_style
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(owner, 2, TRUE)
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/act_intent/alien()
	using.screen_loc = retro_hud ? UI_ACTI_RETRO : UI_ACTI
	using.icon_state = mymob.a_intent
	using.hud = src
	static_inventory += using
	action_intent = using

	if(isalienhunter(mymob))
		var/mob/living/carbon/alien/humanoid/hunter/H = mymob
		H.leap_icon = new /atom/movable/screen/alien/leap()
		H.leap_icon.screen_loc = retro_hud ? UI_ALIEN_STORAGE_R_RETRO: UI_ALIEN_STORAGE_R
		static_inventory += H.leap_icon

	using = new/atom/movable/screen/language_menu
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_ALIEN_LANGUAGE_MENU_RETRO : UI_ALIEN_LANGUAGE_MENU
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/navigate
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_ALIEN_NAVIGATE_RETRO : UI_ALIEN_NAVIGATE
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/drop()
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_DROP_RETRO : UI_DROP_ALIEN
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/resist()
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_RESIST_RETRO : UI_RESIST_ALIEN
	using.hud = src
	hotkeybuttons += using

	throw_icon = new /atom/movable/screen/throw_catch()
	throw_icon.icon = retro_hud ? ui_style : using.icon
	throw_icon.screen_loc = retro_hud ? UI_THROW_RETRO : UI_THROW_ALIEN
	throw_icon.hud = src
	hotkeybuttons += throw_icon

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = retro_hud ? ui_style : using.icon
	pull_icon.update_icon()
	pull_icon.screen_loc = retro_hud ? UI_PULL_RETRO : UI_PULL_ALIEN
	pull_icon.hud = src
	static_inventory += pull_icon

	if(!retro_hud)
		rest_icon = new /atom/movable/screen/rest()
		rest_icon.screen_loc = UI_REST_ALIEN
		rest_icon.hud = src
		static_inventory += rest_icon

//begin indicators

	healths = new /atom/movable/screen/healths/alien()
	healths.hud = src
	infodisplay += healths

	alien_plasma_display = new /atom/movable/screen/alien/plasma_display()
	alien_plasma_display.hud = src
	infodisplay += alien_plasma_display

	if(!isalienqueen(mymob))
		alien_queen_finder = new /atom/movable/screen/alien/alien_queen_finder
		alien_queen_finder.hud = src
		infodisplay += alien_queen_finder

	zone_select = new /atom/movable/screen/zone_sel/alien()
	zone_select.retro_hud = retro_hud
	zone_select.icon = retro_hud ? 'icons/hud/screen_alien.dmi' : zone_select.icon
	zone_select.overlay_icon = retro_hud ? 'icons/hud/screen_alien.dmi' : zone_select.icon
	zone_select.screen_loc = retro_hud ? UI_ZONESEL_RETRO : UI_ZONESEL
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_icon()

/datum/hud/alien/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/carbon/alien/humanoid/H = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I), TRUE)
			H.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			H.client.screen -= I
