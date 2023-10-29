/obj/spacepod
	var/icon_dir_num = 1

////////////////////////////////////////////////////////////////////////////////////test

/obj/spacepod/prebuilt/multidir_test
	name = "мехокарась"
	desc = "амонг"
	icon = 'white/baldenysh/icons/mob/karasik.dmi'
	icon_state = "karasik"
	overlay_file = 'white/baldenysh/icons/mob/karasik.dmi'
	bound_x = 64
	bound_y = 32
	movement_type = PHASING
	icon_dir_num = 8

	armor_type = /obj/item/pod_parts/armor/multidir_test
	cell_type = /obj/item/stock_parts/cell/infinite
	equipment_types = list(/obj/item/spacepod_equipment/weaponry/laser,
		/obj/item/spacepod_equipment/cargo/chair,
		/obj/item/spacepod_equipment/cargo/chair)

/obj/item/pod_parts/armor/multidir_test
	name = "мехокарась"
	icon_state = "pod_armor_mil"
	desc = "Ого..."
	pod_icon = 'white/baldenysh/icons/mob/karasik.dmi'
	pod_icon_state = "karasik"
	pod_desc = "Хых..."
	pod_integrity = 650

////////////////////////////////////////////////////////////////////////////////////actual praikol

/obj/item/pod_parts/armor/susplating
	name = "sussy armor"
	icon_state = "pod_armor_mil"
	desc = "I have a reason to believe there is a pretender in the midst of our ranks."
	pod_icon = 'white/baldenysh/icons/obj/spesspods/snuscopteru.dmi'
	pod_icon_state = "snuscopter"
	pod_desc = "Изобретение хохлов будущего #009."
	pod_integrity = 3000

#define FUNNICOPTER_DESC_LINK "https://hub.station13.ru/library/58"

/obj/spacepod/prebuilt/funnicopter/proc/load_funny_text()
	var/docstring = get_html_doc_string("[FUNNICOPTER_DESC_LINK]")
	if(!docstring)
		desc += "\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
		return
	var/text = get_list_of_strings_enclosed(docstring, "<span style=\"color:'blue';font-family:'Verdana';\"><p>", "</p>")[1]
	if(!text)
		desc += "\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
		return
	desc += "\nНа обшивке можно разглядеть короткую надпись, сделанную розовым мелком:"
	desc += "\n<font color=\"pink\">[text]</font>"

/obj/spacepod/prebuilt/funnicopter
	name = "mk.II rev.5 Type-83 \"AMODEUS\" Blackmatter-phasing Antigravity Snuscopter"
	icon_state = "snuscopter"
	overlay_file ='white/baldenysh/icons/obj/spesspods/snuscopteru.dmi'
	//320x192
	bound_x = 32 * 3
	bound_y = 32 * 3
	base_pixel_x = -112
	base_pixel_y = -48

	movement_type = PHASING
	icon_dir_num = 8

	armor_type = /obj/item/pod_parts/armor/susplating
	cell_type = /obj/item/stock_parts/cell/infinite
	equipment_types = list(/obj/item/spacepod_equipment/weaponry/missile_rack,
		/obj/item/spacepod_equipment/cargo/chair,
		/obj/item/spacepod_equipment/cargo/chair)

/obj/spacepod/prebuilt/funnicopter/Initialize(mapload)
	. = ..()
	var/datum/component/soundplayer/SP = AddComponent(/datum/component/soundplayer)
	SP.prefs_toggle_flag = null
	SP.set_sound(sound('white/baldenysh/sounds/dd_phonk_loop.ogg'))
	SP.set_channel(open_sound_channel_for_boombox())
	SP.playing_volume = 100
	SP.active = TRUE

	INVOKE_ASYNC(src, PROC_REF(load_funny_text))

/obj/item/spacepod_equipment/weaponry/missile_rack
	name = "\improper SRM-8 spacepod missile rack"
	desc = "grifenk inbound"
	icon_state = "weapon_burst_taser"
	projectile_type = /obj/projectile/bullet/a84mm_he
	shot_cost = 1200
	shots_per = 3
	fire_sound = 'sound/weapons/gun/general/rocket_launch.ogg'
	fire_delay = 5
	overlay_icon = 'white/valtos/icons/spacepods/2x2.dmi'
	overlay_icon_state = "aaaaaaaaaaaaaaaaaa"
