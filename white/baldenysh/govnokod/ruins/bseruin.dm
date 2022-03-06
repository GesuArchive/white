/datum/map_template/ruin/space/bseruin
	id = "bseruin"
	suffix = "bseruin.dmm"
	name = "BSE Ruin"
	always_place = TRUE
	allow_duplicates = FALSE
	description = "Аааааааааааааааа. А."


/area/ruin/space/has_grav/bseruin
	name = "BSE"
	icon_state = "yellow"
	area_flags = UNIQUE_AREA | HIDDEN_AREA

/area/ruin/space/has_grav/bseruin/asteroid
	name = "BSE: Астероид"
	icon_state = "yellow"

/area/ruin/space/has_grav/bseruin/foam
	name = "BSE: Пена"
	icon_state = "bluenew"

/area/ruin/space/has_grav/bseruin/ntnet
	name = "BSE: Постройка 1"
	icon_state = "tcomsatcham"

/area/ruin/space/has_grav/bseruin/shop
	name = "BSE: Постройка 2"
	icon_state = "storage"

/area/ruin/space/has_grav/bseruin/backyard
	name = "BSE: Задний двор постройки 2"
	icon_state = "red"


/obj/effect/mapping_helpers/dead_body_placer_custom
	name = "Dead Body placer"
	late = TRUE
	icon_state = "deadbodyplacer"
	var/bodycount = 2 //number of bodies to spawn
	var/species = /datum/species/human

/obj/effect/mapping_helpers/dead_body_placer_custom/LateInitialize()
	var/area/a = get_area(src)
	var/list/trays = list()
	for (var/i in a.contents)
		if (istype(i, /obj/structure/bodycontainer/morgue))
			trays += i
	if(!trays.len)
		log_mapping("[src] at [x],[y] could not find any morgues.")
		return
	for (var/i = 1 to bodycount)
		var/obj/structure/bodycontainer/morgue/j = pick(trays)
		var/mob/living/carbon/human/h = new /mob/living/carbon/human(j, 1)
		h.set_species(species)
		h.death()
		for (var/part in h.internal_organs) //randomly remove organs from each body, set those we keep to be in stasis
			if (prob(40))
				qdel(part)
			else
				var/obj/item/organ/O = part
				O.organ_flags |= ORGAN_FROZEN
		j.update_icon()
	qdel(src)


/obj/item/modular_computer/laptop/preset/bse
	desc = "Старый ноутбук. Возможно в нём что-то осталось полезное."


/obj/item/modular_computer/laptop/preset/bse/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/data/bse_note())

/datum/computer_file/data/bse_note
	filename = "Заметка"
	filetype = "TXT"
	stored_data = "Как запустить артиллерию. Инструкция для самых маленьких:<br> - Нужно достать жидкое электричество. Тела в морге и капельницы в обратном режиме помогут.<br> - Смешать его с <i>жидким</i> серебром, получатся кристаллы.<br> - Заправить этими кристаллами генераторы и настроить артиллерию.<br> - ВАЖНО! При использовании артиллерии желательно выбирать место, где точно не будет разгерметизации."

/obj/item/paper/fluff/instruction_ecrys_bse
	name = "подсказка"
	info = "В ноутбуке я оставила инструкцию. Прочитай его пожалуйста, дорогой.<br><br>С любовью, тв---~"
