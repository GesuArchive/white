
/obj/item/disk/tech_disk
	name = "диск для записи исследований"
	desc = "Диск для хранения технологических данных для дальнейших исследований."
	icon_state = "datadisk0"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)
	var/datum/techweb/stored_research

/obj/item/disk/tech_disk/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_RESEARCH_SCANNER))
		. += span_purple("\nТехнологии:")
		for(var/id in stored_research.researched_nodes)
			var/datum/techweb_node/tn = SSresearch.techweb_node_by_id(id)
			. += "\n\t[tn?.display_name]"

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)
	stored_research = new /datum/techweb

/obj/item/disk/tech_disk/debug
	name = "дебаг диск с исследованиями"
	desc = "Содержит все исследования включая БЕПИС и Нелегал. При загрузке дико лагает, это нормально."
	custom_materials = null

/obj/item/disk/tech_disk/debug/Initialize(mapload)
	. = ..()
	stored_research = new /datum/techweb/admin

/obj/item/disk/tech_disk/major
	name = "переформатированный диск для записи исследований"
	desc = "Диск, содержащий новую, завершенную технологию из B.E.P.I.S. Загрузите диск в консоль РнД, чтобы активировать технологию."
	icon_state = "rndmajordisk"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)

/obj/item/disk/tech_disk/major/Initialize(mapload)
	. = ..()
	stored_research = new /datum/techweb/bepis

/obj/item/disk/tech_disk/spaceloot
	name = "старый диск с данными исследований"
	desc = "Диск, содержащий какую-то давно забытую технологию из прошлой эпохи. Вы надеетесь, что это все еще работает после всех этих лет. Загрузите диск в консоль РнД, чтобы активировать технологию."
	icon_state = "rndmajordisk"
	custom_materials = list(/datum/material/iron=300, /datum/material/glass=100)

/obj/item/disk/tech_disk/spaceloot/Initialize(mapload)
	. = ..()
	stored_research = new /datum/techweb/bepis(remove_tech = FALSE)
