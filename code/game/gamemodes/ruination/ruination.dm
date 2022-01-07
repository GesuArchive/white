#define HEIGHT_OPTIMAL 	480000
#define HEIGHT_DANGER 	400000
#define HEIGHT_CRITICAL 300000
#define HEIGHT_DEADEND 	200000
#define HEIGHT_CRASH 	100000

GLOBAL_LIST_EMPTY(pulse_engines)
GLOBAL_VAR_INIT(station_orbit_height, HEIGHT_OPTIMAL)

/datum/game_mode/ruination
	name = "ruination"
	config_tag = "ruination"
	report_type = "ruination"
	false_report_weight = 1
	required_players = 0

	announce_span = "danger"
	announce_text = "Синдикат решил уронить станцию прямиком на ПЛАНЕТУ!"

	var/win_time = 15 MINUTES
	var/result = 0
	var/started_at = 0
	var/finale = FALSE

/datum/game_mode/ruination/process()
	if(!started_at && GLOB.pulse_engines.len)
		for(var/obj/structure/pulse_engine/PE in GLOB.pulse_engines)
			if(PE.engine_active)
				started_at = world.time
				sound_to_playing_players('white/valtos/sounds/rp0.ogg', 25, FALSE, channel = CHANNEL_RUINATION_OST)
				priority_announce("На вашей станции был обнаружен запуск одного или нескольких импульсных двигателей. Вам необходимо найти и постараться помешать их работе любым доступным способом. Как сообщают наши инженеры: \"Хоть эта хуёвина и крепкая, однако, внутри этой поеботины блевотина равно болтается, что создаёт проблемы при работе данного агрегата\". Вероятнее всего это дело рук агентов Синдиката, постарайтесь продержаться 15 минут до прилёта гравитационного тягача.", null, 'sound/misc/announce_dig.ogg', "Priority")
				for(var/m in GLOB.player_list)
					if(ismob(m) && !isnewplayer(m))
						var/mob/M = m
						if(M.hud_used)
							var/datum/hud/H = M.hud_used
							var/atom/movable/screen/station_height/sh = new /atom/movable/screen/station_height()
							var/atom/movable/screen/station_height_bg/shbg = new /atom/movable/screen/station_height_bg()
							H.station_height = sh
							H.station_height_bg = shbg
							sh.hud = H
							shbg.hud = H
							H.infodisplay += sh
							H.infodisplay += shbg
							H.mymob.client.screen += sh
							H.mymob.client.screen += shbg
				break
	if((started_at + (win_time - 3 MINUTES)) > world.time && !finale)
		finale = TRUE
		sound_to_playing_players('white/valtos/sounds/rf.ogg', 75, FALSE, channel = CHANNEL_RUINATION_OST)
		priority_announce("Осталось 3 минуты до прибытия тягача.", null, 'sound/misc/announce_dig.ogg', "Priority")
	if(started_at)
		var/total_speed = 0
		for(var/obj/structure/pulse_engine/PE in GLOB.pulse_engines)
			total_speed += PE.engine_power
		GLOB.station_orbit_height -= total_speed
		for(var/i in GLOB.player_list)
			var/mob/M = i
			if(!M.hud_used?.station_height)
				continue
			var/datum/hud/H = M.hud_used
			H.station_height.update_height()

/datum/game_mode/ruination/check_finished()
	if(!started_at)
		return ..()
	if(GLOB.station_orbit_height < HEIGHT_CRASH)
		result = 1
	else if ((started_at + win_time) > world.time)
		result = 2
	if(result)
		return TRUE
	else
		return ..()

/datum/game_mode/ruination/special_report()
	if(result == 1)
		return "<div class='panel redborder'><span class='redtext big'>СТАНЦИЯ БЫЛА СБРОШЕНА НА ПЛАНЕТУ! ВЫЖИВШИХ ОБНАРУЖЕНО НЕ БЫЛО...</span></div>"
	else if(result == 2)
		return "<div class='panel redborder'><span class='redtext big'>Экипаж станции смог продержаться до прибытия гравитационного тягача!</span></div>"

/datum/game_mode/ruination/set_round_result()
	..()
	if(result == 1)
		SSticker.mode_result = "станция уничтожена"
	else if(result == 2)
		SSticker.mode_result = "станция стабилизирована"

/datum/game_mode/ruination/generate_report()
	return "Синдикат недавно выкрал несколько импульсных двигателей, которые предназначены для выведения объектов с орбит. \
	Система защиты данных устройств невероятно крутая, что можно говорить и об их удивительно высокой цене производства! \
	Обязательно сообщите нам, если случайно найдёте парочку таких."

/atom/movable/screen/station_height
	icon = 'white/valtos/icons/line.png'
	screen_loc = ui_station_height
	pixel_x = 48
	pixel_y = 420
	maptext_y = -4
	maptext_width = 96
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/station_height/Initialize()
	. = ..()
	flicker_animation()
	overlays += icon('white/valtos/icons/station.png')
	maptext = "<span style='color: #A35D5B; font-size: 8px;'>[GLOB.station_orbit_height]KM</span>"

/atom/movable/screen/station_height/proc/update_height()
	pixel_y = round((GLOB.station_orbit_height * 0.001), 1) - 60
	maptext = "<span style='color: #A35D5B; font-size: 8px;'>[GLOB.station_orbit_height]KM</span>"

/atom/movable/screen/station_height_bg
	icon = 'white/valtos/icons/graph.png'
	screen_loc = ui_station_height
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/proc/flicker_animation(anim_len = 50)
	var/haste = 0.1
	alpha = 0
	animate(src, alpha = 0, time = 1, easing = JUMP_EASING)
	for(var/i in 1 to anim_len)
		animate(alpha = 255, time = 1 - haste, easing = JUMP_EASING)
		animate(alpha = 0,   time = 1 - haste, easing = JUMP_EASING)
		haste += 0.1
		if(prob(25))
			haste -= 0.2
	animate(alpha = 255, time = 1, easing = JUMP_EASING)

#undef HEIGHT_OPTIMAL
#undef HEIGHT_DANGER
#undef HEIGHT_CRITICAL
#undef HEIGHT_DEADEND
#undef HEIGHT_CRASH
