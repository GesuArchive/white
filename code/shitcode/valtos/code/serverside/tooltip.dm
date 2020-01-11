/client/MouseEntered(object, location)
    ..()
    if(istype(object, /atom) && !istype(object, /turf/closed/indestructible/splashscreen) && L.client.prefs.toggles & TOOLTIP_USER_UP)
        var/atom/A = object
        if(mob.hud_used.tooltip)
            var/obj_name = A.name
            if(mob.hud_used.tooltip.last_word == obj_name)
                return
            mob.hud_used.tooltip.maptext = "<span style='font-family: Arial; font-size: 12px; text-align: center;text-shadow: 1px 1px 2px black;background: #00000099;'>[r_uppertext(obj_name)]</span>"

/obj/screen/tooltip
	name = ""
	screen_loc = "NORTH,CENTER-3"
	maptext_width = 228
	maptext_y = 16

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, toggle_tooltip_up)()
	set name = " 🔄 Название предметов сверху"
	set category = "Preferences"
	set desc = "Это штука, которая пишет название текущего предмета под курсором."
	usr.client.prefs.toggles ^= TOOLTIP_USER_UP
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & TOOLTIP_USER_UP)
		to_chat(usr, "Я не буду видеть названия предметов.")
	else
		to_chat(usr, "Я буду видеть названия предметов.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Tooltip Up", "[usr.client.prefs.toggles & TOOLTIP_USER_UP ? "Вкл" : "Выкл"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/toggle_tooltip_up/Get_checked(client/C)
	return C.prefs.toggles & TOOLTIP_USER_UP
