GLOBAL_LIST_EMPTY(ghost_images_default) //this is a list of the default (non-accessorized, non-dir) images of the ghosts themselves
GLOBAL_LIST_EMPTY(ghost_images_simple) //this is a list of all ghost images as the simple white ghost

GLOBAL_VAR_INIT(observer_default_invisibility, INVISIBILITY_OBSERVER)

/mob/dead/observer
	name = "ghost"
	desc = "Призрак. Бу!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	stat = DEAD
	density = FALSE
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	invisibility = INVISIBILITY_OBSERVER
	hud_type = /datum/hud/ghost
	movement_type = GROUND | FLYING
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 2
	light_on = FALSE
	shift_to_open_context_menu = FALSE
	plane = GHOST_PLANE
	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghost - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/atom/movable/following = null
	var/fun_verbs = 0
	var/image/ghostimage_default = null //this mobs ghost image without accessories and dirs
	var/image/ghostimage_simple = null //this mob with the simple white ghost sprite
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/mob/observetarget = null	//The target mob that the ghost is observing. Used as a reference in logout()
	var/ghost_hud_enabled = 1 //did this ghost disable the on-screen HUD?
	var/data_huds_on = 0 //Are data HUDs currently enabled?
	var/health_scan = FALSE //Are health scans currently enabled?
	var/chem_scan = FALSE //Are chem scans currently enabled?
	var/gas_scan = FALSE //Are gas scans currently enabled?
	var/list/datahuds = list(DATA_HUD_SECURITY_ADVANCED, DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED) //list of data HUDs shown to ghosts.
	var/ghost_orbit = GHOST_ORBIT_CIRCLE

	//These variables store hair data if the ghost originates from a species with head and/or facial hair.
	var/hairstyle
	var/hair_color
	var/mutable_appearance/hair_overlay
	var/facial_hairstyle
	var/facial_hair_color
	var/mutable_appearance/facial_hair_overlay

	var/updatedir = 1						//Do we have to update our dir as the ghost moves around?
	var/lastsetting = null	//Stores the last setting that ghost_others was set to, for a little more efficiency when we update ghost images. Null means no update is necessary

	//We store copies of the ghost display preferences locally so they can be referred to even if no client is connected.
	//If there's a bug with changing your ghost settings, it's probably related to this.
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	// Used for displaying in ghost chat, without changing the actual name
	// of the mob
	var/deadchat_name
	var/datum/spawners_menu/spawners_menu
	var/datum/minigames_menu/minigames_menu

/mob/dead/observer/Initialize(mapload)
	set_invisibility(GLOB.observer_default_invisibility)

	add_verb(src, list(
		/mob/dead/observer/proc/dead_tele,
		/mob/dead/observer/proc/open_spawners_menu,
		/mob/dead/observer/proc/tray_view,
		/mob/dead/observer/proc/open_minigames_menu,
		/mob/dead/observer/proc/pick_ghost_customization,
		/mob/dead/observer/proc/toggle_ghost_hud_pref,
		/mob/dead/observer/proc/toggle_inquisition))

	if(icon_state in GLOB.ghost_forms_with_directions_list)
		ghostimage_default = image(src.icon,src,src.icon_state + "_nodir")
	else
		ghostimage_default = image(src.icon,src,src.icon_state)
	ghostimage_default.override = TRUE
	GLOB.ghost_images_default |= ghostimage_default

	ghostimage_simple = image(src.icon,src,"ghost_nodir")
	ghostimage_simple.override = TRUE
	GLOB.ghost_images_simple |= ghostimage_simple

	updateallghostimages()

	var/turf/T
	var/mob/body = loc
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?

		gender = body.gender
		if(body.mind && body.mind.name)
			if(body.mind.ghostname)
				name = body.mind.ghostname
			else
				name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				name = random_unique_name(gender)

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

		set_suicide(body.suiciding) // Transfer whether they committed suicide.

		if(ishuman(body))
			var/mob/living/carbon/human/body_human = body
			if(HAIR in body_human.dna.species.species_traits)
				hairstyle = body_human.hairstyle
				hair_color = brighten_color(body_human.hair_color)
			if(FACEHAIR in body_human.dna.species.species_traits)
				facial_hairstyle = body_human.facial_hairstyle
				facial_hair_color = brighten_color(body_human.facial_hair_color)

	update_appearance()

	if(!T)
		var/list/turfs = get_area_turfs(/area/shuttle/arrival)
		if(turfs.len)
			T = pick(turfs)
		else
			T = SSmapping.get_station_center()

	abstract_move(T)

	if(!name)							//To prevent nameless ghosts
		name = random_unique_name(gender)
	real_name = name

	if(!fun_verbs)
		remove_verb(src, /mob/dead/observer/verb/boo)
		remove_verb(src, /mob/dead/observer/verb/possess)

	animate(src, pixel_y = 2, time = 10, loop = -1)

	add_to_dead_mob_list()

	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)

	. = ..()

	grant_all_languages()
	show_data_huds()
	data_huds_on = 1

	spawn(10)
		if(fexists("data/custom_ghosts/[ckey].dmi"))
			swap_icons()

	SSpoints_of_interest.make_point_of_interest(src)

/mob/dead/observer/get_photo_description(obj/item/camera/camera)
	if(!invisibility || camera.see_ghosts)
		return "Также тут виден призрак!"

/mob/dead/observer/narsie_act()
	var/old_color = color
	color = "#960000"
	animate(src, color = old_color, time = 10, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 10)

/mob/dead/observer/Destroy()
	if(data_huds_on)
		remove_data_huds()

	// Update our old body's medhud since we're abandoning it
	if(mind?.current)
		mind.current.med_hud_set_status()

	GLOB.ghost_images_default -= ghostimage_default
	QDEL_NULL(ghostimage_default)

	GLOB.ghost_images_simple -= ghostimage_simple
	QDEL_NULL(ghostimage_simple)

	updateallghostimages()

	QDEL_NULL(spawners_menu)
	QDEL_NULL(minigames_menu)
	return ..()

/*
 * This proc will update the icon of the ghost itself, with hair overlays, as well as the ghost image.
 * Please call update_icon(updates, icon_state) from now on when you want to update the icon_state of the ghost,
 * or you might end up with hair on a sprite that's not supposed to get it.
 * Hair will always update its dir, so if your sprite has no dirs the haircut will go all over the place.
 * |- Ricotez
 */
/mob/dead/observer/update_icon(updates=ALL, new_form)
	. = ..()

	if(client) //We update our preferences in case they changed right before update_icon was called.
		ghost_accs = client.prefs.ghost_accs
		ghost_others = client.prefs.ghost_others

	if(update_custom_icon())
		hair_overlay = null
		facial_hair_overlay = null
		return TRUE

	if(hair_overlay)
		cut_overlay(hair_overlay)
		hair_overlay = null

	if(facial_hair_overlay)
		cut_overlay(facial_hair_overlay)
		facial_hair_overlay = null

	if(new_form)
		icon_state = new_form
		if(icon_state in GLOB.ghost_forms_with_directions_list)
			ghostimage_default.icon_state = new_form + "_nodir" //if this icon has dirs, the default ghostimage must use its nodir version or clients with the preference set to default sprites only will see the dirs
		else
			ghostimage_default.icon_state = new_form

	if(ghost_accs >= GHOST_ACCS_DIR && (icon_state in GLOB.ghost_forms_with_directions_list)) //if this icon has dirs AND the client wants to show them, we make sure we update the dir on movement
		updatedir = 1
	else
		updatedir = 0	//stop updating the dir in case we want to show accessories with dirs on a ghost sprite without dirs
		setDir(2)		//reset the dir to its default so the sprites all properly align up

	if(ghost_accs == GHOST_ACCS_FULL && (icon_state in GLOB.ghost_forms_with_accessories_list)) //check if this form supports accessories and if the client wants to show them
		var/datum/sprite_accessory/S
		if(facial_hairstyle)
			S = GLOB.facial_hairstyles_list[facial_hairstyle]
			if(S)
				facial_hair_overlay = mutable_appearance(S.icon, "[S.icon_state]", -HAIR_LAYER)
				if(facial_hair_color)
					facial_hair_overlay.color = "#" + facial_hair_color
				facial_hair_overlay.alpha = 200
				add_overlay(facial_hair_overlay)
		if(hairstyle)
			S = GLOB.hairstyles_list[hairstyle]
			if(S)
				hair_overlay = mutable_appearance(S.icon, "[S.icon_state]", -HAIR_LAYER)
				if(hair_color)
					hair_overlay.color = "#" + hair_color
				hair_overlay.alpha = 200
				add_overlay(hair_overlay)

/mob/dead/observer/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	. = ..()
	update_icon() // crutch

/*
 * Increase the brightness of a color by calculating the average distance between the R, G and B values,
 * and maximum brightness, then adding 30% of that average to R, G and B.
 *
 * I'll make this proc global and move it to its own file in a future update. |- Ricotez
 */
/mob/proc/brighten_color(input_color)
	var/r_val
	var/b_val
	var/g_val
	var/color_format = length(input_color)
	if(color_format != length_char(input_color))
		return 0
	if(color_format == 3)
		r_val = hex2num(copytext(input_color, 1, 2)) * 16
		g_val = hex2num(copytext(input_color, 2, 3)) * 16
		b_val = hex2num(copytext(input_color, 3, 4)) * 16
	else if(color_format == 6)
		r_val = hex2num(copytext(input_color, 1, 3))
		g_val = hex2num(copytext(input_color, 3, 5))
		b_val = hex2num(copytext(input_color, 5, 7))
	else
		return 0 //If the color format is not 3 or 6, you're using an unexpected way to represent a color.

	r_val += (255 - r_val) * 0.4
	if(r_val > 255)
		r_val = 255
	g_val += (255 - g_val) * 0.4
	if(g_val > 255)
		g_val = 255
	b_val += (255 - b_val) * 0.4
	if(b_val > 255)
		b_val = 255

	return copytext(rgb(r_val, g_val, b_val), 2)

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/proc/ghostize(can_reenter_corpse = TRUE)
	if(key)
		if(key[1] != "@") // Skip aghosts.
			if(HAS_TRAIT(src, TRAIT_CORPSELOCKED) && can_reenter_corpse) //If you can re-enter the corpse you can't leave when corpselocked
				return
			stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
			var/mob/dead/observer/ghost = new(src)	// Transfer safety to observer spawning proc.
			SStgui.on_transfer(src, ghost) // Transfer NanoUIs.
			ghost.can_reenter_corpse = can_reenter_corpse
			ghost.key = key
			ghost.client?.init_verbs()
			if(!can_reenter_corpse)// Disassociates observer mind from the body mind
				ghost.mind = null
			return ghost

/mob/living/ghostize(can_reenter_corpse = TRUE)
	. = ..()
	if(. && can_reenter_corpse)
		var/mob/dead/observer/ghost = .
		ghost.mind.current?.med_hud_set_status()

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "❗ Покинуть тело"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat != DEAD)
		if(incapacitated() && succumb())
			inc_metabalance(src, METACOIN_GHOSTIZE_REWARD, reason="Откуп за душу стоил много.")
			ghostize(FALSE)
			return

	if(stat == DEAD)
		ghostize(TRUE)
	return

/mob/camera/verb/ghost()
	set category = "OOC"
	set name = "❗ Покинуть тело"
	set desc = "Relinquish your life and enter the land of the dead."

	var/response = tgui_alert(usr, "Are you -sure- you want to ghost?\n(You are alive. If you ghost whilst still alive you may not play again this round! You can't change your mind so choose wisely!!)","Are you sure you want to ghost?",list("Ghost","Stay in body"))
	if(response != "Ghost")
		return
	ghostize(FALSE)

/mob/dead/observer/Move(NewLoc, direct, glide_size_override = 32)
	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own

	if(glide_size_override)
		set_glide_size(glide_size_override)
	if(NewLoc)
		abstract_move(NewLoc)
		update_parallax_contents()
	else
		forceMove(get_turf(src))  //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--

		abstract_move(NewLoc)//Get out of closets and such as a ghost

/mob/dead/observer/forceMove(atom/destination)
	abstract_move(destination) // move like the wind
	return TRUE

/mob/dead/observer/get_status_tab_items()
	. = ..()
	. += ""
	//Add coords to status panel
	. += "X:[src.x] Y:[src.y] Z:[src.z]"

/mob/dead/observer/verb/reenter_corpse()
	set category = "Призрак"
	set name = "Вернуться в тело"
	if(!client)
		return
	if(!mind || QDELETED(mind.current))
		to_chat(src, span_warning("А тела то и нет. Червь!"))
		return
	if(!can_reenter_corpse)
		to_chat(src, span_warning("Не могу вернуться в тело."))
		return
	if(mind.current.key && mind.current.key[1] != "@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, span_warning("Кто-то уже копается в моём теле... Оно отвергает меня."))
		return
	client.view_size.setDefault(client.getScreenSize())//Let's reset so people can't become allseeing gods
	SStgui.on_transfer(src, mind.current) // Transfer NanoUIs.
	if(mind.current.stat == DEAD && SSlag_switch.measures[DISABLE_DEAD_KEYLOOP])
		to_chat(src, span_warning("Чтобы покинуть тело используй кнопку Призрак."))
	mind.current.key = key
	mind.current.client.init_verbs()
	return TRUE

/mob/dead/observer/verb/stay_dead()
	set category = "Призрак"
	set name = "Не хочу воскресать"
	if(!client)
		return
	if(!can_reenter_corpse)
		to_chat(usr, span_warning("Да я как бы уже!"))
		return FALSE

	var/response = tgui_alert(usr, "Отменяем возможность возраждаться? Это нельзя отменить и лишает тебя права голоса на этот раунда.","Умираем?",list("НХВ","Я передумал"))
	if(response != "НХВ")
		return

	can_reenter_corpse = FALSE
	// Update med huds
	var/mob/living/carbon/current = mind.current
	current.med_hud_set_status()
	// Disassociates observer mind from the body mind
	mind = null

	inc_metabalance(src, METACOIN_DNR_REWARD, reason="Соединение с телом прервано. Приятного времяпрепровождения.")
	return TRUE

/mob/dead/observer/proc/toggle_ghost_hud_pref()
	set name = "🔄 HUD призрака"
	set category = "Призрак"
	if(!client)
		return
	client.prefs.ghost_hud = !client.prefs.ghost_hud
	to_chat(src, "Призрачный HUD теперь [client.prefs.ghost_hud ? "виден" : "не виден"].")
	client.prefs.save_preferences()
	hud_used.show_hud()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost HUD", "[client.prefs.ghost_hud ? "Enabled" : "Disabled"]"))

/mob/dead/observer/proc/toggle_inquisition() // warning: unexpected inquisition
	set name = "🔄 Изучение при клике"
	set category = "Призрак"
	if(!client)
		return
	client.prefs.inquisitive_ghost = !client.prefs.inquisitive_ghost
	client.prefs.save_preferences()
	if(client.prefs.inquisitive_ghost)
		to_chat(src, span_notice("Буду изучать все, на что нажимаю."))
	else
		to_chat(src, span_notice("Больше не будешь изучать то, на что нажимаю."))
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Inquisitiveness", "[client.prefs.inquisitive_ghost ? "Enabled" : "Disabled"]"))

GLOBAL_LIST_INIT(ghost_forms, sort_list(list(
	"ghost",
	"ghostking",
	"ghostian2",
	"skeleghost",
	"ghost_red",
	"ghost_black",
	"ghost_blue",
	"ghost_yellow",
	"ghost_green",
	"ghost_pink",
	"ghost_cyan",
	"ghost_dblue",
	"ghost_dred",
	"ghost_dgreen",
	"ghost_dcyan",
	"ghost_grey",
	"ghost_dyellow",
	"ghost_dpink",
	"ghost_purpleswirl",
	"ghost_funkypurp",
	"ghost_pinksherbert",
	"ghost_blazeit",
	"ghost_mellow",
	"ghost_rainbow",
	"ghost_camo",
	"ghost_fire",
	"catghost"
)))

/mob/dead/observer/proc/pick_form()
	var/new_form = tgui_input_list(src, "Choose your ghostly form:", "Thanks for supporting BYOND", GLOB.ghost_forms)
	if(new_form)
		client.prefs.ghost_form = new_form
		client.prefs.save_preferences()
		update_icon(new_form)

GLOBAL_LIST_INIT(ghost_orbits, list(GHOST_ORBIT_CIRCLE,GHOST_ORBIT_TRIANGLE,GHOST_ORBIT_SQUARE,GHOST_ORBIT_HEXAGON,GHOST_ORBIT_PENTAGON))

/mob/dead/observer/proc/pick_ghost_orbit()
	var/new_orbit = tgui_input_list(src, "Choose your ghostly orbit:", "Thanks for supporting BYOND", GLOB.ghost_orbits)
	if(new_orbit)
		client.prefs.ghost_orbit = new_orbit
		client.prefs.save_preferences()
		ghost_orbit = new_orbit

/mob/dead/observer/proc/pick_ghost_accs()
	var/new_ghost_accs = tgui_alert(usr,"Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,list("full accessories", "only directional sprites", "default sprites"))
	if(new_ghost_accs)
		switch(new_ghost_accs)
			if("full accessories")
				client.prefs.ghost_accs = GHOST_ACCS_FULL
			if("only directional sprites")
				client.prefs.ghost_accs = GHOST_ACCS_DIR
			if("default sprites")
				client.prefs.ghost_accs = GHOST_ACCS_NONE
		client.prefs.save_preferences()
		update_icon()

/mob/dead/observer/proc/pick_ghost_customization()
	set name = "Настройка призрака"
	set category = "Призрак"
	if(!client)
		return
	switch(tgui_alert("Что хотим сменить?",,list("Форма","Тип орбиты","Побрякушки")))
		if("Форма")
			pick_form()
		if("Тип орбиты")
			pick_ghost_orbit()
		if("Побрякушки")
			pick_ghost_accs()

/mob/dead/observer/proc/pick_ghost_others()
	set name = "Вид других призраков"
	set category = "Призрак"
	if(!client)
		return
	var/new_ghost_others = tgui_alert(usr, "Хочешь изменить других призраков или же просто убрать их побрякушки?",,list("Их настройки", "Стандартные спрайты", "Белые призраки"))
	if(new_ghost_others)
		switch(new_ghost_others)
			if("Их настройки")
				client.prefs.ghost_others = GHOST_OTHERS_THEIR_SETTING
			if("Стандартные спрайты")
				client.prefs.ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
			if("Белые призраки")
				client.prefs.ghost_others = GHOST_OTHERS_SIMPLE
		client.prefs.save_preferences()
		update_sight()

/mob/dead/observer/proc/notify_cloning(message, sound, atom/source, flashwindow = TRUE)
	if(flashwindow)
		window_flash(client)
	if(message)
		to_chat(src, span_ghostalert("[message]"))
		if(source)
			var/atom/movable/screen/alert/A = throw_alert("[REF(source)]_notify_cloning", /atom/movable/screen/alert/notify_cloning)
			if(A)
				if(client && client.prefs && client.prefs.UI_style)
					A.icon = ui_style2icon(client.prefs.UI_style)
				A.desc = message
				var/old_layer = source.layer
				var/old_plane = source.plane
				source.layer = FLOAT_LAYER
				source.plane = FLOAT_PLANE
				A.add_overlay(source)
				source.layer = old_layer
				source.plane = old_plane
	to_chat(src, span_ghostalert("<a href=?src=[REF(src)];reenter=1>(Нажми для входа)</a>"))
	if(sound)
		SEND_SOUND(src, sound(sound))

/mob/dead/observer/proc/dead_tele()
	set category = null
	set name = "Телепортироваться в..."
	if(!isobserver(usr))
		to_chat(usr, span_warning("Not when you're not dead!"))
		return
	var/list/filtered = list()
	for(var/area/A as anything in get_sorted_areas())
		if(!(A.area_flags & HIDDEN_AREA))
			filtered += A
	var/area/thearea  = tgui_input_list(usr, "Куда прыгаем?", "БУ!", filtered)

	if(!thearea)
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		to_chat(usr, span_warning("No area available."))
		return

	usr.abstract_move(pick(L))
	update_parallax_contents()

/mob/dead/observer/verb/follow()
	set category = null
	set name = "Кружить около..." // "Haunt"
	set desc = "Follow and orbit a mob."

	GLOB.orbit_menu.show(src)

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(atom/movable/target)
	if (!istype(target))
		return

	var/icon/I = icon(target.icon,target.icon_state,target.dir)

	var/orbitsize = (I.Width()+I.Height())*0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)

	var/rot_seg

	switch(ghost_orbit)
		if(GHOST_ORBIT_TRIANGLE)
			rot_seg = 3
		if(GHOST_ORBIT_SQUARE)
			rot_seg = 4
		if(GHOST_ORBIT_PENTAGON)
			rot_seg = 5
		if(GHOST_ORBIT_HEXAGON)
			rot_seg = 6
		else //Circular
			rot_seg = 36 //360/10 bby, smooth enough aproximation of a circle

	orbit(target,orbitsize, FALSE, 20, rot_seg)

/mob/dead/observer/orbit()
	setDir(2)//reset dir so the right directional sprites show up
	return ..()

/mob/dead/observer/stop_orbit(datum/component/orbiter/orbits)
	. = ..()
	//restart our floating animation after orbit is done.
	pixel_y = base_pixel_y
	animate(src, pixel_y = base_pixel_y + 2, time = 1 SECONDS, loop = -1)

/mob/dead/observer/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = null
	set name = "Переместиться к..."

	if(!isobserver(usr)) //Make sure they're an observer!
		return

	var/list/possible_destinations = SSpoints_of_interest.get_mob_pois()
	var/target = null

	target = tgui_input_list(usr, "Please, select a player!", "Jump to Mob", possible_destinations)

	if (!target || !isobserver(usr))
		return

	var/mob/destination_mob = possible_destinations[target] //Destination mob

	// During the break between opening the input menu and selecting our target, has this become an invalid option?
	if(!SSpoints_of_interest.is_valid_poi(destination_mob))
		return

	var/mob/source_mob = src  //Source mob
	var/turf/destination_turf = get_turf(destination_mob) //Turf of the destination mob

	if(isturf(destination_turf))
		source_mob.abstract_move(destination_turf)
		source_mob.update_parallax_contents()
	else
		to_chat(source_mob, span_danger("This mob is not located in the game world."))

/mob/dead/observer/verb/change_view_range()
	set category = "Призрак"
	set name = "Радиус обзора"
	set desc = "Change your view range."

	if(SSlag_switch.measures[DISABLE_GHOST_ZOOM_TRAY] && !client?.holder)
		to_chat(usr, span_notice("Запрещено."))
		return

	var/max_view = client.prefs.unlock_content ? GHOST_MAX_VIEW_RANGE_MEMBER : GHOST_MAX_VIEW_RANGE_DEFAULT
	if(client.view_size.getView() == client.view_size.default)
		var/list/views = list()
		for(var/i in 7 to max_view)
			views |= i
		var/new_view = tgui_input_list(usr, "Choose your new view", "Modify view range", views, 0)
		if(new_view)
			client.view_size.setTo(clamp(new_view, 7, max_view) - 7)
	else
		client.view_size.resetToDefault()

/mob/dead/observer/verb/add_view_range(input as num)
	set name = "Add View Range"
	set hidden = TRUE

	if(SSlag_switch.measures[DISABLE_GHOST_ZOOM_TRAY] && !client?.holder)
		to_chat(usr, span_notice("Запрещено."))
		return

	var/max_view = client.prefs.unlock_content ? GHOST_MAX_VIEW_RANGE_MEMBER : GHOST_MAX_VIEW_RANGE_DEFAULT
	if(input)
		client.rescale_view(input, 0, ((max_view*2)+1) - 15)

/mob/dead/observer/verb/boo()
	set category = "Призрак"
	set name = "Boo!"
	set desc= "Scare your crew members because of boredom!"

	if(bootime > world.time)
		return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return


/mob/dead/observer/memory()
	set hidden = TRUE
	to_chat(src, span_danger("You are dead! You have no mind to store memory!"))

/mob/dead/observer/add_memory()
	set hidden = TRUE
	to_chat(src, span_danger("You are dead! You have no mind to store memory!"))

/mob/dead/observer/verb/toggle_ghostsee()
	set name = " 🔄 Видеть других"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Призрак"
	ghostvision = !(ghostvision)
	update_sight()
	to_chat(usr, span_boldnotice("You [(ghostvision?"now":"no longer")] have ghost vision."))

/mob/dead/observer/verb/toggle_darkness()
	set name = " 🔄 Видеть тьму"
	set category = "Призрак"
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	update_sight()

/mob/dead/observer/update_sight()
	if(client)
		ghost_others = client.prefs?.ghost_others //A quick update just in case this setting was changed right before calling the proc

	if (!ghostvision)
		set_invis_see(SEE_INVISIBLE_LIVING)
	else
		set_invis_see(SEE_INVISIBLE_OBSERVER)


	updateghostimages()
	..()

/proc/updateallghostimages()
	list_clear_nulls(GLOB.ghost_images_default)
	list_clear_nulls(GLOB.ghost_images_simple)

	for (var/mob/dead/observer/O in GLOB.player_list)
		O.updateghostimages()

/mob/dead/observer/proc/updateghostimages()
	if (!client)
		return

	if(lastsetting)
		switch(lastsetting) //checks the setting we last came from, for a little efficiency so we don't try to delete images from the client that it doesn't have anyway
			if(GHOST_OTHERS_DEFAULT_SPRITE)
				client.images -= GLOB.ghost_images_default
			if(GHOST_OTHERS_SIMPLE)
				client.images -= GLOB.ghost_images_simple
	lastsetting = client.prefs.ghost_others
	if(!ghostvision)
		return
	if(client.prefs.ghost_others != GHOST_OTHERS_THEIR_SETTING)
		switch(client.prefs.ghost_others)
			if(GHOST_OTHERS_DEFAULT_SPRITE)
				client.images |= (GLOB.ghost_images_default-ghostimage_default)
			if(GHOST_OTHERS_SIMPLE)
				client.images |= (GLOB.ghost_images_simple-ghostimage_simple)

/mob/dead/observer/verb/possess()
	set category = "Призрак"
	set name = "Possess!"
	set desc= "Take over the body of a mindless creature!"

	var/list/possessible = list()
	for(var/mob/living/L in GLOB.alive_mob_list)
		if(istype(L,/mob/living/carbon/human/dummy) || !get_turf(L)) //Haha no.
			continue
		if(!(L in GLOB.player_list) && !L.mind)
			possessible += L

	var/mob/living/target = tgui_input_list(usr, "Your new life begins today!", "Possess Mob", sort_names(possessible))

	if(!target)
		return FALSE

	if(ismegafauna(target))
		to_chat(src, span_warning("This creature is too powerful for you to possess!"))
		return FALSE

	if(can_reenter_corpse && mind?.current)
		if(tgui_alert(usr, "Your soul is still tied to your former life as [mind.current.name], if you go forward there is no going back to that life. Are you sure you wish to continue?", "Move On", list("Yes", "No")) == "No")
			return FALSE
	if(target.key)
		to_chat(src, span_warning("Someone has taken this body while you were choosing!"))
		return FALSE

	target.key = key
	target.faction = list("neutral")
	return TRUE

//this is a mob verb instead of atom for performance reasons
//see /mob/verb/examinate() in mob.dm for more info
//overridden here and in /mob/living for different point span classes and sanity checks
/mob/dead/observer/pointed(atom/A as mob|obj|turf in view(client.view, src))
	if(!..())
		return FALSE
	usr.visible_message(span_deadsay("<b>[capitalize(src)]</b> показывает на [skloname(A.name, VINITELNI, A.gender)]."))
	return TRUE

/mob/dead/observer/verb/view_manifest()
	set name = " 📝 Показать персонал"
	set category = "Призрак"

	if(!client)
		return
	if(world.time < client.crew_manifest_delay)
		return
	client.crew_manifest_delay = world.time + (1 SECONDS)

	if(!GLOB.crew_manifest_tgui)
		GLOB.crew_manifest_tgui = new /datum/crew_manifest(src)

	GLOB.crew_manifest_tgui.ui_interact(src)

//this is called when a ghost is drag clicked to something.
/mob/dead/observer/MouseDrop(atom/over)
	if(!usr || !over)
		return
	if (isobserver(usr) && usr.client.holder && (isliving(over) || iscameramob(over)) )
		if (usr.client.holder.cmd_ghost_drag(src,over))
			return

	return ..()

/mob/dead/observer/Topic(href, href_list)
	..()
	if(usr == src)
		if(href_list["follow"])
			var/atom/movable/target = locate(href_list["follow"])
			if(istype(target) && (target != src))
				ManualFollow(target)
				return
		if(href_list["x"] && href_list["y"] && href_list["z"])
			var/tx = text2num(href_list["x"])
			var/ty = text2num(href_list["y"])
			var/tz = text2num(href_list["z"])
			var/turf/target = locate(tx, ty, tz)
			if(istype(target))
				abstract_move(target)
				return
		if(href_list["reenter"])
			reenter_corpse()
			return

//We don't want to update the current var
//But we will still carry a mind.
/mob/dead/observer/mind_initialize()
	return

/mob/dead/observer/proc/show_data_huds()
	for(var/hudtype in datahuds)
		var/datum/atom_hud/H = GLOB.huds[hudtype]
		H.show_to(src)

/mob/dead/observer/proc/remove_data_huds()
	for(var/hudtype in datahuds)
		var/datum/atom_hud/H = GLOB.huds[hudtype]
		H.hide_from(src)

/mob/dead/observer/verb/toggle_data_huds()
	set name = " 🔄 Sec/Med/Diag HUD"
	set desc = "Toggles whether you see medical/security/diagnostic HUDs"
	set category = "Призрак"

	if(data_huds_on) //remove old huds
		remove_data_huds()
		to_chat(src, span_notice("Data HUDs disabled."))
		data_huds_on = 0
	else
		show_data_huds()
		to_chat(src, span_notice("Data HUDs enabled."))
		data_huds_on = 1

/mob/dead/observer/verb/toggle_health_scan()
	set name = " 🔄 Сканирование здоровья"
	set desc = "Toggles whether you health-scan living beings on click"
	set category = "Призрак"

	if(health_scan) //remove old huds
		to_chat(src, span_notice("Health scan disabled."))
		health_scan = FALSE
	else
		to_chat(src, span_notice("Health scan enabled."))
		health_scan = TRUE

/mob/dead/observer/verb/toggle_chem_scan()
	set name = " 🔄 Сканирование химикатов"
	set desc = "Toggles whether you scan living beings for chemicals and addictions on click"
	set category = "Призрак"

	if(chem_scan) //remove old huds
		to_chat(src, span_notice("Chem scan disabled."))
		chem_scan = FALSE
	else
		to_chat(src, span_notice("Chem scan enabled."))
		chem_scan = TRUE

/mob/dead/observer/verb/toggle_gas_scan()
	set name = " 🔄 Сканирование газов"
	set desc = "Toggles whether you analyze gas contents on click"
	set category = "Призрак"

	if(gas_scan)
		to_chat(src, span_notice("Gas scan disabled."))
		gas_scan = FALSE
	else
		to_chat(src, span_notice("Gas scan enabled."))
		gas_scan = TRUE

/mob/dead/observer/verb/restore_ghost_appearance()
	set name = "❌ Сбросить внешность призрака"
	set desc = "Sets your deadchat name and ghost appearance to your \
		roundstart character."
	set category = "Призрак"

	set_ghost_appearance()
	if(client?.prefs)
		deadchat_name = client.prefs.real_name
		if(mind)
			mind.ghostname = client.prefs.real_name
		name = client.prefs.real_name

/mob/dead/observer/proc/set_ghost_appearance()
	if((!client) || (!client.prefs))
		return

	if(client.prefs.randomise[RANDOM_NAME])
		client.prefs.real_name = random_unique_name(gender)
	if(client.prefs.randomise[RANDOM_BODY])
		client.prefs.random_character(gender)

	if(HAIR in client.prefs.pref_species.species_traits)
		hairstyle = client.prefs.hairstyle
		hair_color = brighten_color(client.prefs.hair_color)
	if(FACEHAIR in client.prefs.pref_species.species_traits)
		facial_hairstyle = client.prefs.facial_hairstyle
		facial_hair_color = brighten_color(client.prefs.facial_hair_color)

	update_appearance()

/mob/dead/observer/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE, need_hands = FALSE, floor_okay=FALSE)
	return isAdminGhostAI(usr)

/mob/dead/observer/is_literate()
	return TRUE

/mob/dead/observer/can_read(atom/viewed_atom, reading_check_flags, silent)
	return TRUE // we want to bypass all the checks

/mob/dead/observer/vv_edit_var(var_name, var_value)
	. = ..()
	switch(var_name)
		if(NAMEOF(src, icon))
			ghostimage_default.icon = icon
			ghostimage_simple.icon = icon
		if(NAMEOF(src, icon_state))
			ghostimage_default.icon_state = icon_state
			ghostimage_simple.icon_state = icon_state
		if(NAMEOF(src, fun_verbs))
			if(fun_verbs)
				add_verb(src, /mob/dead/observer/verb/boo)
				add_verb(src, /mob/dead/observer/verb/possess)
			else
				remove_verb(src, /mob/dead/observer/verb/boo)
				remove_verb(src, /mob/dead/observer/verb/possess)

/mob/dead/observer/reset_perspective(atom/A)
	if(client)
		if(ismob(client.eye) && (client.eye != src))
			var/mob/target = client.eye
			observetarget = null
			hide_other_mob_action_buttons(target)
			if(target.observers)
				target.observers -= src
				UNSETEMPTY(target.observers)
	if(..())
		if(hud_used)
			client.clear_screen()
			hud_used.show_hud(hud_used.hud_version)

/mob/dead/observer/verb/observe()
	set name = "Следить за..."
	set category = "OOC"

	if(!isobserver(usr)) //Make sure they're an observer!
		return

	reset_perspective(null)

	var/list/possible_destinations = SSpoints_of_interest.get_mob_pois()
	var/target = null

	target = tgui_input_list(usr, "Please, select a player!", "Jump to Mob", possible_destinations)

	if (!target || !isobserver(usr))
		return

	var/mob/chosen_target = possible_destinations[target]

	// During the break between opening the input menu and selecting our target, has this become an invalid option?
	if(!SSpoints_of_interest.is_valid_poi(chosen_target))
		return

	do_observe(chosen_target)

/mob/dead/observer/proc/do_observe(mob/mob_eye)
	if(isnewplayer(mob_eye))
		stack_trace("/mob/dead/new_player: \[[mob_eye]\] is being observed by [key_name(src)]. This should never happen and has been blocked.")
		message_admins("[ADMIN_LOOKUPFLW(src)] attempted to observe someone in the lobby: [ADMIN_LOOKUPFLW(mob_eye)]. This should not be possible and has been blocked.")
		return

	//Istype so we filter out points of interest that are not mobs
	if(client && mob_eye && istype(mob_eye) && src != mob_eye)
		client.set_eye(mob_eye)
		if(mob_eye.hud_used)
			client.clear_screen()
			LAZYOR(mob_eye.observers, src)
			mob_eye.hud_used.show_hud(mob_eye.hud_used.hud_version, src)
			observetarget = mob_eye

/mob/dead/observer/verb/register_pai_candidate()
	set category = null
	set name = "pAI Setup"
	set desc = "Upload a fragment of your personality to the global pAI databanks"

	register_pai()

/mob/dead/observer/proc/register_pai()
	if(isobserver(src))
		SSpai.recruit_window(src)
	else
		to_chat(usr, span_warning("Can't become a pAI candidate while not dead!"))

/mob/dead/observer/verb/mafia_game_signup()
	set category = null
	set name = "Записаться в Мафию"

	mafia_signup()

/mob/dead/observer/proc/mafia_signup()
	if(!client)
		return
	if(!isobserver(src))
		to_chat(usr, span_warning("Надо быть призраком!"))
		return
	var/datum/mafia_controller/game = GLOB.mafia_game //this needs to change if you want multiple mafia games up at once.
	if(!game)
		game = create_mafia_game("mafia")
	game.ui_interact(usr)

/mob/dead/observer/CtrlShiftClick(mob/user)
	if(isobserver(user) && check_rights(R_SPAWN))
		change_mob_type( /mob/living/carbon/human , null, null, TRUE) //always delmob, ghosts shouldn't be left lingering

/mob/dead/observer/examine(mob/user)
	. = ..()
	if(!invisibility)
		. += "<hr>Выглядит достаточно реалистично."

/mob/dead/observer/examine_more(mob/user)
	if(!isAdminObserver(user))
		return ..()
	. = list("<span class='notice'><i>Изучаю <b>[src.name]</b> ближе и замечаю следующее...</i></span>\n")
	. += list(span_admin("[ADMIN_FULLMONTY(src)]"))


/mob/dead/observer/proc/set_invisibility(value)
	invisibility = value
	set_light_on(!value ? TRUE : FALSE)


// Ghosts have no momentum, being massless ectoplasm
/mob/dead/observer/Process_Spacemove(movement_dir, continuous_move = FALSE)
	return TRUE

/mob/dead/observer/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == NAMEOF(src, invisibility))
		set_invisibility(invisibility) // updates light

/proc/set_observer_default_invisibility(amount, message=null)
	for(var/mob/dead/observer/G in GLOB.player_list)
		G.set_invisibility(amount)
		if(message)
			to_chat(G, message)
	GLOB.observer_default_invisibility = amount

/mob/dead/observer/proc/open_spawners_menu()
	set name = "Меню перерождений"
	set category = null
	if(!spawners_menu)
		spawners_menu = new(src)

	spawners_menu.ui_interact(src)

/mob/dead/observer/proc/open_minigames_menu()
	set name = "Мини-игры"
	set desc = "See all currently available minigames"
	set category = "Призрак"
	if(!client)
		return
	if(!isobserver(src))
		to_chat(usr, span_warning("Нужно быть призраком для этого!"))
		return
	if(!minigames_menu)
		minigames_menu = new(src)

	minigames_menu.ui_interact(src)

/mob/dead/observer/proc/tray_view()
	set category = "Призрак"
	set name = " 🔄 T-ray зрение"
	set desc = "Toggles a view of sub-floor objects"

	var/static/t_ray_view = FALSE

	if(SSlag_switch.measures[DISABLE_GHOST_ZOOM_TRAY] && !client?.holder && !t_ray_view)
		to_chat(usr, span_notice("Запрещено."))
		return

	t_ray_view = !t_ray_view

	var/list/t_ray_images = list()
	var/static/list/stored_t_ray_images = list()
	for(var/obj/O in orange(client.view, src) )
		if(HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
			var/image/I = new(loc = get_turf(O))
			var/mutable_appearance/MA = new(O)
			MA.alpha = 128
			MA.dir = O.dir
			I.appearance = MA
			t_ray_images += I
	stored_t_ray_images += t_ray_images
	if(t_ray_images.len)
		if(t_ray_view)
			client.images += t_ray_images
		else
			client.images -= stored_t_ray_images
