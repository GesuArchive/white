/atom/movable/screen/human
	icon = 'icons/hud/screen_midnight.dmi'

/atom/movable/screen/human/toggle
	name = "переключить"
	icon_state = "toggle"

/atom/movable/screen/human/toggle/Click()

	var/mob/targetmob = usr

	if(isobserver(usr))
		if(ishuman(usr.client.eye) && (usr.client.eye != usr))
			var/mob/M = usr.client.eye
			targetmob = M

	if(usr.hud_used.inventory_shown && targetmob.hud_used)
		usr.hud_used.inventory_shown = FALSE
		usr.client.screen -= targetmob.hud_used.toggleable_inventory
	else
		usr.hud_used.inventory_shown = TRUE
		usr.client.screen += targetmob.hud_used.toggleable_inventory

	targetmob.hud_used.hidden_inventory_update(usr)

/atom/movable/screen/human/equip
	name = "экипировать"
	base_icon_state = "nextmove"
	icon_state = "act_equip"
	var/last_user_move = 0
	var/target_time = 0

/atom/movable/screen/human/equip/Click()
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return TRUE
	var/mob/living/carbon/human/H = usr
	H.quick_equip()

/atom/movable/screen/human/equip/process(delta_time)
	update_icon_state(UPDATE_ICON_STATE)
	if(world.time >= target_time)
		icon_state = "act_equip"
		return PROCESS_KILL

/atom/movable/screen/human/equip/update_icon_state()
	. = ..()
	var/completion = clamp(FLOOR(20 - (((target_time - world.time) / (target_time - last_user_move)) * 20), 1), 1, 20)
	icon_state = "[base_icon_state]_[completion]"

/atom/movable/screen/ling
	icon = 'icons/hud/screen_changeling.dmi'
	invisibility = INVISIBILITY_ABSTRACT

/atom/movable/screen/ling/sting
	name = "жало"
	screen_loc = UI_LINGSTINGDISPLAY

/atom/movable/screen/ling/sting/Click()
	if(isobserver(usr))
		return
	var/mob/living/carbon/U = usr
	U.unset_sting()

/atom/movable/screen/ling/chems
	name = "химикаты"
	icon_state = "power_display"
	screen_loc = UI_LINGCHEMDISPLAY

/atom/movable/screen/bloodsucker
	icon = 'icons/mob/actions/actions_bloodsucker.dmi'
	invisibility = INVISIBILITY_ABSTRACT

/atom/movable/screen/bloodsucker/proc/clear()
	invisibility = INVISIBILITY_ABSTRACT

/atom/movable/screen/bloodsucker/proc/update_counter()
	invisibility = 0

/atom/movable/screen/bloodsucker/blood_counter
	name = "Blood Consumed"
	icon_state = "blood_display"
	screen_loc = UI_BLOOD_DISPLAY

/atom/movable/screen/bloodsucker/rank_counter
	name = "Bloodsucker Rank"
	icon_state = "rank"
	screen_loc = UI_VAMPRANK_DISPLAY

/atom/movable/screen/bloodsucker/sunlight_counter
	name = "Solar Flare Timer"
	icon_state = "sunlight_night"
	screen_loc = UI_SUNLIGHT_DISPLAY

/datum/hud/human/New(mob/living/carbon/human/owner)
	..()

	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	using = new/atom/movable/screen/language_menu
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_BOXLANG_RETRO : UI_BOXLANG
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/skills
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_SKILLS_RETRO : UI_SKILLS
	static_inventory += using

	using = new /atom/movable/screen/navigate
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_NAVIGATE_RETRO : UI_NAVIGATE
	static_inventory += using

	using = new /atom/movable/screen/area_creator
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_BOXAREA_RETRO : UI_BOXAREA
	using.hud = src
	static_inventory += using

	action_intent = new /atom/movable/screen/act_intent/segmented
	action_intent.icon = retro_hud ? 'icons/hud/screen_gen.dmi' : action_intent.icon
	action_intent.screen_loc = retro_hud ? UI_ACTI_RETRO : UI_ACTI
	action_intent.icon_state = mymob.a_intent
	action_intent.hud = src
	static_inventory += action_intent

	using = new /atom/movable/screen/mov_intent
	using.icon = retro_hud ? ui_style : using.icon
	using.icon_state = (mymob.m_intent == MOVE_INTENT_RUN ? "running" : "walking")
	using.screen_loc = retro_hud ? UI_MOVI_RETRO : UI_MOVI
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/drop()
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_DROP_RETRO : UI_DROP
	using.hud = src
	static_inventory += using

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "униформа"
	inv_box.icon = ui_style
	inv_box.slot_id = ITEM_SLOT_ICLOTHING
	inv_box.icon_state = "uniform"
	inv_box.screen_loc = retro_hud ? UI_ICLOTHING_RETRO : UI_ICLOTHING
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "костюм"
	inv_box.icon = ui_style
	inv_box.slot_id = ITEM_SLOT_OCLOTHING
	inv_box.icon_state = "suit"
	inv_box.screen_loc = retro_hud ? UI_OCLOTHING_RETRO : UI_OCLOTHING
	inv_box.hud = src
	toggleable_inventory += inv_box

	build_hand_slots(retro_hud)

	using = new /atom/movable/screen/swap_hand()
	using.icon = ui_style
	using.icon_state = "swap_1"
	using.screen_loc = ui_swaphand_position(owner, 1, retro_hud)
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/swap_hand()
	using.icon = ui_style
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(owner, 2, retro_hud)
	using.hud = src
	static_inventory += using

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "ID"
	inv_box.icon = ui_style
	inv_box.icon_state = "id"
	inv_box.screen_loc = retro_hud ? UI_ID_RETRO : UI_ID
	inv_box.slot_id = ITEM_SLOT_ID
	inv_box.hud = src
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "маска"
	inv_box.icon = ui_style
	inv_box.icon_state = "mask"
	inv_box.screen_loc = retro_hud ? UI_MASK_RETRO : UI_MASK
	inv_box.slot_id = ITEM_SLOT_MASK
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "шея"
	inv_box.icon = ui_style
	inv_box.icon_state = "neck"
	inv_box.screen_loc = retro_hud ? UI_NECK_RETRO : UI_NECK
	inv_box.slot_id = ITEM_SLOT_NECK
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "спина"
	inv_box.icon = ui_style
	inv_box.icon_state = "back"
	inv_box.screen_loc = retro_hud ? UI_BACK_RETRO : UI_BACK
	inv_box.slot_id = ITEM_SLOT_BACK
	inv_box.hud = src
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "левый карман"
	inv_box.icon = ui_style
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = retro_hud ? UI_STORAGE1_RETRO : UI_STORAGE1
	inv_box.slot_id = ITEM_SLOT_LPOCKET
	inv_box.hud = src
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "правый карман"
	inv_box.icon = ui_style
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = retro_hud ? UI_STORAGE2_RETRO : UI_STORAGE2
	inv_box.slot_id = ITEM_SLOT_RPOCKET
	inv_box.hud = src
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "хранилище костюма"
	inv_box.icon = ui_style
	inv_box.icon_state = "suit_storage"
	inv_box.screen_loc = retro_hud ? UI_SSTORE1_RETRO : UI_SSTORE1
	inv_box.slot_id = ITEM_SLOT_SUITSTORE
	inv_box.hud = src
	static_inventory += inv_box

	using = new /atom/movable/screen/resist()
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_RESIST_RETRO : UI_RESIST
	using.hud = src
	hotkeybuttons += using

	if(retro_hud)
		using = new /atom/movable/screen/human/toggle()
		using.icon = ui_style
		using.screen_loc = UI_INVENTORY_RETRO
		using.hud = src
		static_inventory += using

	equip_hud = new /atom/movable/screen/human/equip()
	equip_hud.icon = ui_style
	equip_hud.screen_loc = ui_equip_position(mymob, retro_hud)
	equip_hud.hud = src
	static_inventory += equip_hud

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "перчатки"
	inv_box.icon = ui_style
	inv_box.icon_state = "gloves"
	inv_box.screen_loc = retro_hud ? UI_GLOVES_RETRO : UI_GLOVES
	inv_box.slot_id = ITEM_SLOT_GLOVES
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "глаза"
	inv_box.icon = ui_style
	inv_box.icon_state = "glasses"
	inv_box.screen_loc = retro_hud ? UI_GLASSES_RETRO : UI_GLASSES
	inv_box.slot_id = ITEM_SLOT_EYES
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "уши"
	inv_box.icon = ui_style
	inv_box.icon_state = "ears"
	inv_box.screen_loc = retro_hud ? UI_EARS_RETRO : UI_EARS
	inv_box.slot_id = ITEM_SLOT_EARS
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "голова"
	inv_box.icon = ui_style
	inv_box.icon_state = "head"
	inv_box.screen_loc = retro_hud ? UI_HEAD_RETRO : UI_HEAD
	inv_box.slot_id = ITEM_SLOT_HEAD
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "обувь"
	inv_box.icon = ui_style
	inv_box.icon_state = "shoes"
	inv_box.screen_loc = retro_hud ? UI_SHOES_RETRO : UI_SHOES
	inv_box.slot_id = ITEM_SLOT_FEET
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "пояс"
	inv_box.icon = ui_style
	inv_box.icon_state = "belt"
//	inv_box.icon_full = "template_small"
	inv_box.screen_loc = retro_hud ? UI_BELT_RETRO : UI_BELT
	inv_box.slot_id = ITEM_SLOT_BELT
	inv_box.hud = src
	static_inventory += inv_box

	throw_icon = new /atom/movable/screen/throw_catch()
	throw_icon.icon = retro_hud ? ui_style : throw_icon.icon
	throw_icon.screen_loc = retro_hud ? UI_THROW_RETRO : UI_THROW
	throw_icon.hud = src
	hotkeybuttons += throw_icon

	rest_icon = new /atom/movable/screen/rest()
	rest_icon.icon = retro_hud ? ui_style : rest_icon.icon
	rest_icon.screen_loc = retro_hud ? UI_REST_RETRO : UI_REST
	rest_icon.hud = src
	rest_icon.update_appearance()
	static_inventory += rest_icon

	spacesuit = new /atom/movable/screen/spacesuit()
	spacesuit.icon = retro_hud ? ui_style : spacesuit.icon
	spacesuit.screen_loc = retro_hud ? UI_SPACESUIT_RETRO : UI_SPACESUIT
	spacesuit.hud = src
	infodisplay += spacesuit

	healths = new /atom/movable/screen/healths()
	healths.icon = retro_hud ? 'icons/hud/screen_gen.dmi' : healths.icon
	healths.screen_loc = retro_hud ? UI_HEALTH_RETRO : UI_HEALTH
	healths.hud = src
	infodisplay += healths

	healthdoll = new /atom/movable/screen/healthdoll()
	healthdoll.screen_loc = retro_hud ? UI_HEALTHDOLL_RETRO : UI_HEALTHDOLL
	healthdoll.hud = src
	infodisplay += healthdoll

	stamina = new /atom/movable/screen/stamina()
	stamina.icon = retro_hud ? 'icons/hud/screen_gen.dmi' : stamina.icon
	stamina.screen_loc = retro_hud ? UI_STAMINA_RETRO : UI_STAMINA
	stamina.hud = src
	infodisplay += stamina

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = retro_hud ? ui_style : pull_icon.icon
	pull_icon.screen_loc = retro_hud ? UI_PULL_RETRO : UI_PULL
	pull_icon.hud = src
	pull_icon.update_appearance()
	static_inventory += pull_icon

	lingchemdisplay = new /atom/movable/screen/ling/chems()
	lingchemdisplay.hud = src
	infodisplay += lingchemdisplay

	lingstingdisplay = new /atom/movable/screen/ling/sting()
	lingstingdisplay.hud = src
	infodisplay += lingstingdisplay

	//bloodsuckers
	blood_display = new /atom/movable/screen/bloodsucker/blood_counter
	infodisplay += blood_display
	vamprank_display = new /atom/movable/screen/bloodsucker/rank_counter
	infodisplay += vamprank_display
	sunlight_display = new /atom/movable/screen/bloodsucker/sunlight_counter
	infodisplay += sunlight_display

	zone_select =  new /atom/movable/screen/zone_sel()
	zone_select.retro_hud = retro_hud
	zone_select.icon = retro_hud ? ui_style : zone_select.icon
	zone_select.overlay_icon = retro_hud ? 'icons/hud/screen_gen.dmi' : zone_select.icon
	zone_select.screen_loc = retro_hud ? UI_ZONESEL_RETRO : UI_ZONESEL
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select

	combo_display = new /atom/movable/screen/combo()
	combo_display.icon = retro_hud ? combo_display.icon : ui_style
	combo_display.icon_state = retro_hud ? "" : "combo_bg"
	combo_display.screen_loc = retro_hud ? UI_COMBO_RETRO : UI_COMBO
	combo_display.retro_hud = retro_hud
	infodisplay += combo_display

	ammo_counter = new /atom/movable/screen/ammo_counter()
	ammo_counter.screen_loc = retro_hud ? UI_AMMOCOUNTER_RETRO : UI_AMMOCOUNTER
	ammo_counter.hud = src
	infodisplay += ammo_counter

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_icon()

	if(!retro_hud)

		var/atom/movable/screen/button_bg
		var/atom/movable/screen/button_bg_health
		var/atom/movable/screen/button_bg_big

		button_bg = new /atom/movable/screen/side_button_bg()
		button_bg.hud = src
		infodisplay += button_bg

		button_bg_health = new /atom/movable/screen/side_button_bg()
		button_bg_health.screen_loc = retro_hud ? UI_HEALTHDOLL_RETRO : UI_HEALTHDOLL
		button_bg_health.hud = src
		infodisplay += button_bg_health

		button_bg_big = new /atom/movable/screen/side_button_bg/high()
		button_bg_big.hud = src
		infodisplay += button_bg_big

	if(owner)
		add_emote_panel(owner)

	typer = new /atom/movable/screen/typer()
	typer.hud = src
	infodisplay += typer

	update_locked_slots()

/datum/hud/human/update_locked_slots()
	if(!mymob)
		return
	var/mob/living/carbon/human/H = mymob
	if(!istype(H) || !H.dna.species)
		return
	var/datum/species/S = H.dna.species
	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			if(inv.slot_id in S.no_equip)
				inv.alpha = 128
			else
				inv.alpha = initial(inv.alpha)

/datum/hud/human/hidden_inventory_update(mob/viewer)
	if(!mymob)
		return
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used.inventory_shown && screenmob.hud_used.hud_shown)
		if(H.shoes)
			H.shoes.screen_loc = retro_hud ? UI_SHOES_RETRO : UI_SHOES
			screenmob.client.screen += H.shoes
		if(H.gloves)
			H.gloves.screen_loc = retro_hud ? UI_GLOVES_RETRO : UI_GLOVES
			screenmob.client.screen += H.gloves
		if(H.ears)
			H.ears.screen_loc = retro_hud ? UI_EARS_RETRO : UI_EARS
			screenmob.client.screen += H.ears
		if(H.glasses)
			H.glasses.screen_loc = retro_hud ? UI_GLASSES_RETRO : UI_GLASSES
			screenmob.client.screen += H.glasses
		if(H.w_uniform)
			H.w_uniform.screen_loc = retro_hud ? UI_ICLOTHING_RETRO : UI_ICLOTHING
			screenmob.client.screen += H.w_uniform
		if(H.wear_suit)
			H.wear_suit.screen_loc = retro_hud ? UI_OCLOTHING_RETRO : UI_OCLOTHING
			screenmob.client.screen += H.wear_suit
		if(H.wear_mask)
			H.wear_mask.screen_loc = retro_hud ? UI_MASK_RETRO : UI_MASK
			screenmob.client.screen += H.wear_mask
		if(H.wear_neck)
			H.wear_neck.screen_loc = retro_hud ? UI_NECK_RETRO : UI_NECK
			screenmob.client.screen += H.wear_neck
		if(H.head)
			H.head.screen_loc = retro_hud ? UI_HEAD_RETRO : UI_HEAD
			screenmob.client.screen += H.head
	else
		if(H.shoes)		screenmob.client.screen -= H.shoes
		if(H.gloves)	screenmob.client.screen -= H.gloves
		if(H.ears)		screenmob.client.screen -= H.ears
		if(H.glasses)	screenmob.client.screen -= H.glasses
		if(H.w_uniform)	screenmob.client.screen -= H.w_uniform
		if(H.wear_suit)	screenmob.client.screen -= H.wear_suit
		if(H.wear_mask)	screenmob.client.screen -= H.wear_mask
		if(H.wear_neck)	screenmob.client.screen -= H.wear_neck
		if(H.head)		screenmob.client.screen -= H.head



/datum/hud/human/persistent_inventory_update(mob/viewer)
	if(!mymob)
		return
	..()
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used)
		if(screenmob.hud_used.hud_shown)
			if(H.s_store)
				H.s_store.screen_loc = retro_hud ? UI_SSTORE1_RETRO : UI_SSTORE1
				screenmob.client.screen += H.s_store
			if(H.wear_id)
				H.wear_id.screen_loc = retro_hud ? UI_ID_RETRO : UI_ID
				screenmob.client.screen += H.wear_id
			if(H.belt)
				H.belt.screen_loc = retro_hud ? UI_BELT_RETRO : UI_BELT
				screenmob.client.screen += H.belt
			if(H.back)
				H.back.screen_loc = retro_hud ? UI_BACK_RETRO : UI_BACK
				screenmob.client.screen += H.back
			if(H.l_store)
				H.l_store.screen_loc = retro_hud ? UI_STORAGE1_RETRO : UI_STORAGE1
				screenmob.client.screen += H.l_store
			if(H.r_store)
				H.r_store.screen_loc = retro_hud ? UI_STORAGE2_RETRO : UI_STORAGE2
				screenmob.client.screen += H.r_store
		else
			if(H.s_store)
				screenmob.client.screen -= H.s_store
			if(H.wear_id)
				screenmob.client.screen -= H.wear_id
			if(H.belt)
				screenmob.client.screen -= H.belt
			if(H.back)
				screenmob.client.screen -= H.back
			if(H.l_store)
				screenmob.client.screen -= H.l_store
			if(H.r_store)
				screenmob.client.screen -= H.r_store

	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I), retro_hud)
			screenmob.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			screenmob.client.screen -= I


/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = null
	set name = " 🔄 Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = FALSE
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = TRUE
