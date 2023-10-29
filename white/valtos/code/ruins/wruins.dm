//telepadovo

/area/ruin/space/has_grav/powered/telepadovo
	name = "Телепадово"

//austation

/obj/effect/mob_spawn/human/austation
	name = "древняя криокапсула"
	desc = "Там кто-то точно есть."
	mob_name = "мятежник"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	short_desc = "Бывший сотрудник корпорации NanoTrasen"
	flavour_text = "Мы решили послать всех нахуй и теперь обитаем здесь."
	important_info = "Скоро закончится свет, однако на складе мы точно оставили всё необходимое для автономной работы нашего поселения."
	uniform = /datum/outfit/job/assistant
	shoes = null
	assignedrole = "Мятежник"

/obj/effect/mob_spawn/human/austation/special(mob/living/new_spawn)
	new_spawn.AddComponent(/datum/component/stationstuck, PUNISHMENT_TELEPORT, "Что-то происходит...")

/obj/effect/mob_spawn/human/austation/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/area/ruin/space/has_grav/austation
	name = "Аванпост"

/area/ruin/space/has_grav/austation/med
	name = "Аванпост: Медбей"

/area/ruin/space/has_grav/austation/vault
	name = "Аванпост: Хранилище"

/area/ruin/space/has_grav/austation/rnd
	name = "Аванпост: Исследования"

/area/ruin/space/has_grav/austation/xeno
	name = "Аванпост: Ксено"

/area/ruin/space/has_grav/austation/station
	name = "Аванпост: Станция"

/area/ruin/space/has_grav/austation/eng
	name = "Аванпост: Инженерный"

/area/ruin/space/has_grav/austation/maint
	name = "Аванпост: Техи"
	ambience_index = AMBIENCE_MAINT

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
