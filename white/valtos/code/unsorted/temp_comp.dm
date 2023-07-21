PROCESSING_SUBSYSTEM_DEF(realtemp)
	name = "Real Temperature"
	priority = 10
	flags = SS_NO_INIT
	wait = 20

/area
	var/env_temp_relative = 20

/area/awaymission/rainy
	name = "Дождливое место"
	env_temp_relative = 3

/area/awaymission/rainy/Entered(atom/movable/AM, oldloc)
	. = ..()
	if(!ismob(AM))
		return

	var/mob/M = AM

	if(M?.hud_used)
		var/datum/hud/mobhud = M.hud_used
		if(!mobhud.weather)
			mobhud.weather = new /atom/movable/screen()
			mobhud.weather.screen_loc = "CENTER"
			mobhud.weather.hud = mobhud
			mobhud.always_visible_inventory += mobhud.weather
			mobhud.weather.particles = new /particles/rain/sideways

	if(!ishuman(M))
		return

	if(!M.GetComponent(/datum/component/realtemp))
		M.AddComponent(/datum/component/realtemp)

/area/awaymission/rainy/Exited(atom/movable/AM, direction)
	. = ..()
	if(!ismob(AM))
		return

	var/mob/M = AM

	if(M?.hud_used)
		M.hud_used.weather.particles = null

/datum/component/realtemp
	var/mob/living/carbon/human/owner
	var/body_temp_alt = 50
	var/atom/movable/screen/relative_temp/screen_obj
	var/atom/movable/screen/free_bg
	var/list/text_temp_sources = list()

/datum/component/realtemp/Initialize(mapload)
	if(ishuman(parent))
		owner = parent

		screen_obj = new /atom/movable/screen/relative_temp()
		screen_obj.screen_loc = owner.hud_used.retro_hud ? UI_RELATIVE_TEMP_RETRO : UI_RELATIVE_TEMP
		screen_obj.hud = src
		owner.hud_used.infodisplay += screen_obj

		free_bg = new /atom/movable/screen/side_button_bg()
		free_bg.screen_loc = owner.hud_used.retro_hud ? UI_RELATIVE_TEMP_RETRO : UI_RELATIVE_TEMP
		free_bg.hud = src
		owner.hud_used.infodisplay += free_bg

		var/datum/hud/hud = owner.hud_used
		hud.show_hud(hud.hud_version)

		START_PROCESSING(SSrealtemp, src)

		RegisterSignal(screen_obj, COMSIG_CLICK, PROC_REF(hud_click))

/datum/component/realtemp/Destroy()

	var/datum/hud/hud = owner.hud_used
	if(hud?.infodisplay)
		hud.infodisplay -= screen_obj
	QDEL_NULL(screen_obj)
	QDEL_NULL(free_bg)

	STOP_PROCESSING(SSrealtemp, src)
	owner = null
	return ..()

/datum/component/realtemp/proc/adjust_temp(amt)
	body_temp_alt += amt
	body_temp_alt = max(min(body_temp_alt, 50), 0)
	update_temp_icon(amt)

/datum/component/realtemp/proc/update_temp_icon(amt)
	if(!(owner.client || owner.hud_used))
		return

	screen_obj.cut_overlays()

	switch(amt)
		if(-INFINITY to -2)
			screen_obj.add_overlay("temp_ov_1")
		if(-1)
			screen_obj.add_overlay("temp_ov_2")
		if(0)
			screen_obj.add_overlay("temp_ov_3")
		if(1)
			screen_obj.add_overlay("temp_ov_4")
		if(2 to INFINITY)
			screen_obj.add_overlay("temp_ov_5")

	switch(body_temp_alt)
		if(-INFINITY to 0)
			screen_obj.icon_state = "temp_0"
		if(1 to 10)
			screen_obj.icon_state = "temp_1"
		if(11 to 20)
			screen_obj.icon_state = "temp_2"
		if(21 to 30)
			screen_obj.icon_state = "temp_3"
		if(31 to 40)
			screen_obj.icon_state = "temp_4"
		if(41 to INFINITY)
			screen_obj.icon_state = "temp_5"

/datum/component/realtemp/process()

	if(owner.stat == DEAD)
		STOP_PROCESSING(SSrealtemp, src)
		return

	var/area/AR = get_area(owner)
	var/list/temp_sources = list()
	var/temp_to_adjust = 0

	switch(body_temp_alt)
		if(-INFINITY to 0)
			if(prob(10))
				owner.emote("shiver")
			owner.adjustStaminaLoss(rand(1, 5))
			owner.adjust_bodytemperature(-rand(25, 50), use_insulation=TRUE, use_steps=TRUE)
			if(prob(10))
				owner.adjust_bodytemperature(-rand(100, 200))
				to_chat(owner, pick(span_warning("Замерзаю..."), span_warning("Холодно..."), span_warning("Нужно срочно согреться...")))
		if(1 to 20)
			if(prob(20))
				owner.emote("shiver")
			owner.adjust_bodytemperature(-rand(25, 50), use_insulation=TRUE, use_steps=TRUE)
		if(21 to 40)
			if(prob(30))
				owner.emote("shiver")
			owner.adjust_bodytemperature(-rand(25, 50), use_insulation=TRUE, use_steps=TRUE)

	switch(AR.env_temp_relative)
		if(-INFINITY to -91)
			temp_to_adjust += -5
		if(-90 to -36)
			temp_to_adjust += -4
		if(-35 to -22)
			temp_to_adjust += -3
		if(-21 to -15)
			temp_to_adjust += -2
		if(-14 to 4)
			temp_to_adjust += -1
		if(15 to INFINITY)
			temp_sources += "Здесь тепло!"
			temp_to_adjust += 1

	switch(owner.get_cold_protection(AR.env_temp_relative))
		if(0.10 to 0.20)
			temp_sources += "Подходящая одежда уберегает меня от холода."
			temp_to_adjust += 2
		if(0.21 to 0.50)
			temp_sources += "Эта одежда не даст мне замёрзнуть."
			temp_to_adjust += 3
		if(0.51 to 0.75)
			temp_sources += "Эта одежда способна не дать мне замёрзнуть точно."
			temp_to_adjust += 4
		if(0.76 to 1)
			temp_sources += "В этой одежде мне не страшен холод."
			temp_to_adjust += 5

	for(var/obj/structure/heat_source in view(3, owner))
		if(istype(heat_source, /obj/structure/bonfire))
			var/obj/structure/bonfire/B = heat_source
			if(B.burning)
				temp_sources += "Костёр согревает меня."
				temp_to_adjust += 3
		if(istype(heat_source, /obj/structure/fireplace))
			var/obj/structure/fireplace/F = heat_source
			if(F.lit)
				temp_sources += "Камин согревает меня."
				temp_to_adjust += 3

	adjust_temp(temp_to_adjust)
	text_temp_sources = temp_sources

/atom/movable/screen/relative_temp
	name = "температура тела"
	icon = 'white/valtos/icons/temp_hud.dmi'
	icon_state = "temp_5"
	screen_loc = UI_RELATIVE_TEMP
	blend_mode = BLEND_ADD

/datum/component/realtemp/proc/hud_click(datum/source, location, control, params, mob/user)
	SIGNAL_HANDLER

	if(user != parent)
		return
	print_temp(user)

/datum/component/realtemp/proc/print_temp(mob/user)
	var/msg = "<span class='info'>Мои ощущения температуры:</span><hr>"
	for(var/i in text_temp_sources)
		msg += "<span class='notice'>[i]</span>\n"
	to_chat(user, "<div class='examine_block'>[msg]</div>")
