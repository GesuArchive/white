//telepadovo

/area/ruin/space/has_grav/powered/telepadovo
	name = "Телепадово"

/datum/map_template/ruin/space/telepadovo
	id = "telepadovo"
	suffix = "wruin1.dmm"
	name = "Telepadovo"
	allow_duplicates = FALSE
	description = "Синдикат в последнее время плохо финансируется, в следствии чего начал заведовать переправкой космобеженцев через телепады."

//austation

/obj/effect/mob_spawn/human/austation
	name = "интересная капсула"
	desc = "Промёрзшая изнутри капсула. Если присмотреться, то внутри находится спящий человек."
	mob_name = "ассистуха"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	short_desc = "Я бывший сотрудник корпорации NanoTrasen"
	flavour_text = "Все эти ублюдки с основной станции настолько нам надоели, что мы решили отпилить кусок станции, что сделали почти успешно, однако назад пути теперь НЕТ. Пусть хоть какой-то паразит попробует сюда сунуться - сразу разберём на биомассу и следов не останется!"
	important_info = "За наши головы готовы неплохо так заплатить, так что эта станция - единственное безопасное место для нас, пока мы не попадёмся кому-то на глаза. Ах, да! Скоро закончится свет."
	uniform = /datum/outfit/job/assistant
	shoes = null
	assignedrole = "Autism Crew"

/obj/effect/mob_spawn/human/austation/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/area/ruin/space/has_grav/austation
	name = "Аутизм"

/area/ruin/space/has_grav/austation/med
	name = "Аутизм: Медбей"

/area/ruin/space/has_grav/austation/vault
	name = "Аутизм: Хранилище"

/area/ruin/space/has_grav/austation/rnd
	name = "Аутизм: Исследования"

/area/ruin/space/has_grav/austation/xeno
	name = "Аутизм: Ксено"

/area/ruin/space/has_grav/austation/station
	name = "Аутизм: Станция"

/area/ruin/space/has_grav/austation/eng
	name = "Аутизм: Инженерный"

/area/ruin/space/has_grav/austation/maint
	name = "Аутизм: Техи"
	ambience_index = AMBIENCE_MAINT

/datum/map_template/ruin/space/austation
	id = "austation"
	suffix = "wruin2.dmm"
	name = "Autism Station"
	allow_duplicates = FALSE
	description = "Практически автономная министация посреди космоса. Уцелела благодаря идиотам среди экипажа и полным отсутствием тактической ценности для синдиката."

/area/shuttle/explorer_mini
	requires_power = TRUE
	name = "Авто-Исследователь Мини"

/datum/map_template/shuttle/ruin/explorer_mini
	suffix = "explorer_mini"
	name = "Auto-Explorer Mini"

/obj/item/circuitboard/computer/explorer_mini
	build_path = /obj/machinery/computer/shuttle_flight/explorer_mini

/obj/machinery/computer/shuttle_flight/explorer_mini
	name = "консоль Авто-Исследователя Мини"
	desc = "Для самых отбитых. Гарантированно ведёт в никуда."
	circuit = /obj/item/circuitboard/computer/explorer_mini
	shuttleId = "explorer_mini"
	possible_destinations = "explorer_mini_custom;landing_zone_dock;explorer_mini_station"

/obj/item/paper/crumpled/ruins/autism
	info = "<i>Ты пидор.</i>"

//telepadovo

/area/ruin/space/has_grav/powered/partywhite
	name = "Пативайт"

/*
/area/ruin/space/has_grav/powered/partywhite/Initialize(mapload)
	. = ..()
	if(mapload)
		for (var/obj/machinery/jukebox/disco/indestructible/D in src)
			D.activate_music()
*/

/datum/map_template/ruin/space/partywhite
	id = "partywhite"
	suffix = "wruin3.dmm"
	name = "Partywhite"
	allow_duplicates = FALSE
	description = "Синдикат решил устроить тусу посреди космоса и никто им не должен помешать. Никто."

//terrorship

/area/ruin/space/has_grav/terrorship
	name = "Терроршип"
	requires_power = FALSE
	area_flags = NOTELEPORT | HIDDEN_AREA //ага ебать

/obj/structure/fluff/artillery
	name = "артиллерия"
	desc = "Долбит нормально."
	icon = 'white/valtos/icons/artillery.dmi'
	icon_state = "artillery"
	density = TRUE

/datum/map_template/ruin/space/terrorship
	id = "terrorship"
	suffix = "wruin4.dmm"
	name = "Terrorship"
	allow_duplicates = FALSE
	description = "При попытке пристыковать артиллерию к основной части корабля Mothership при помощи блюспейс технологий эта часть корабля попала в наш сектор. Блюпупа получил <b>за лупу</b>."

/datum/map_template/ruin/space/assteroid
	id = "assteroid"
	suffix = "wruin5.dmm"
	name = "Assteroid"
	allow_duplicates = FALSE
	description = "Астероид имени Ассистента. Да."

/datum/map_template/ruin/space/eighteensvault
	id = "eighteensvault"
	suffix = "wruin6.dmm"
	name = "Eighteens Vault"
	allow_duplicates = FALSE
	description = "Эх, вот раньше на эти деньги можно было бы купить сто тыщ звездолётов..."
