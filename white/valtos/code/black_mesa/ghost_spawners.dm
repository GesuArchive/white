/obj/effect/mob_spawn/human/black_mesa
	name = "Учёный Чёрной Мезы"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	density = TRUE
	roundstart = FALSE
	death = FALSE
	outfit = /datum/outfit/science_team
	short_desc = "Ты учёный на сверхсекретном правительственном объекте."
	flavour_text = "Ты учёный на сверхсекретном правительственном объекте. После долгого сна ты пришёл в себя и не понимаешь что происходит."

/obj/effect/mob_spawn/human/black_mesa/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.grant_language(/datum/language/uncommon, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.remove_language(/datum/language/common)

/datum/outfit/science_team
	name = JOB_SCIENTIST
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/radio, /obj/item/reagent_containers/glass/beaker)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/science_team

/datum/outfit/science_team/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_BLACKMESA

/datum/id_trim/science_team
	assignment = "Учёный Чёрной Мезы"
	trim_state = "trim_scientist"
	access = list(ACCESS_RND)

/obj/effect/mob_spawn/human/black_mesa/guard
	name = "Охранник Чёрной Мезы"
	outfit = /datum/outfit/security_guard
	short_desc = "Вы охранник на сверхсекретном правительственном объекте. После долгого сна ты пришёл в себя не понимая что происходит. Не стоит в одиночку исследовать комплекс. Охраняй учёных."

/obj/effect/mob_spawn/human/black_mesa/guard/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.grant_language(/datum/language/uncommon, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.remove_language(/datum/language/common)

/obj/item/clothing/under/rank/security
	name = "униформа охраны"
	desc = "Напоминает о том что ты должен пиво."

/datum/outfit/security_guard
	name = "Охранник Чёрной Мезы"
	uniform = /obj/item/clothing/under/rank/security
	head = /obj/item/clothing/head/helmet/blueshirt
	gloves = /obj/item/clothing/gloves/color/black
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/radio, /obj/item/gun/ballistic/automatic/pistol)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/security_guard

/datum/outfit/security_guard/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_BLACKMESA

/datum/id_trim/security_guard
	assignment = "Охранник Чёрной Мезы"
	trim_state = "trim_securityofficer"
	access = list(ACCESS_BRIG, ACCESS_SECURITY, ACCESS_AWAY_SEC)

/obj/effect/mob_spawn/human/black_mesa/hecu
	name = "Солдат HECU"
	outfit = /datum/outfit/hecu
	short_desc = "Ты - боец элитного тактического отряда, развернутый в исследовательском центре для сдерживания заражения."
	flavour_text = "Ты и еще четверо удачливых солдат были выбраны для несения караульной службы возле одного из входов в Черную Мезу. В северо-западном лагере были слышны выстрелы, после чего они перестали выходить на связь. Вдобавок ко всему, ваш спасательный вертолет был сбит в полете, помощь задерживается; пулемётчик был убит в голову неизвестно откуда и неизвестно как. Скорее всего, ты сам по себе, по крайней мере сейчас."

/obj/effect/mob_spawn/human/black_mesa/hecu/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.remove_language(/datum/language/common)
	spawned_human.grant_language(/datum/language/uncommon, TRUE, TRUE, LANGUAGE_MIND)

/obj/item/clothing/under/rank/security/officer/hecu
	name = "городской тактический камуфляж"
	desc = "Мешковатая военная камуфляжная форма с нашивкой ERDL. Ассортимент белых и серых оттенков полезен в городских условиях."
	icon = 'white/valtos/icons/black_mesa/uniforms.dmi'
	worn_icon = 'white/valtos/icons/black_mesa/uniform.dmi'
	icon_state = "hecu_uniform"
	inhand_icon_state = "r_suit"
	unique_reskin = null

/obj/item/storage/backpack/ert/odst/hecu
	name = "военный рюкзак"
	icon = 'white/valtos/icons/black_mesa/hecucloth.dmi'
	worn_icon = 'white/valtos/icons/black_mesa/hecumob.dmi'
	icon_state = "hecu_pack"
	worn_icon_state = "hecu_pack"
	unique_reskin = list(
		"Olive" = "hecu_pack",
		"Black" = "hecu_pack_black",
	)

/obj/item/storage/belt/military/assault/hecu
	name = "пояс военных HECU"
	icon = 'white/valtos/icons/black_mesa/hecucloth.dmi'
	worn_icon = 'white/valtos/icons/black_mesa/hecumob.dmi'
	icon_state = "hecu_belt"
	worn_icon_state = "hecu_belt"
	unique_reskin = list(
		"Olive" = "hecu_belt",
		"Black" = "hecu_belt_black",
	)

/datum/outfit/hecu
	name = "Солдат HECU"
	uniform = /obj/item/clothing/under/rank/security/officer/hecu
	mask = /obj/item/clothing/mask/gas/heavy/m40
	gloves = /obj/item/clothing/gloves/combat
	belt = /obj/item/storage/belt/military/assault/hecu
	ears = /obj/item/radio/headset/headset_faction
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/reagent_containers/food/drinks/flask
	r_pocket = /obj/item/flashlight/flare
	back = /obj/item/storage/backpack/ert/odst/hecu
	backpack_contents = list(
		/obj/item/storage/box/survival/radio,
		/obj/item/storage/firstaid/emergency,
		/obj/item/storage/box/hecu_rations,
		/obj/item/kitchen/knife/combat,
		/obj/item/armament_points_card/hecu
	)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/hecu

/datum/outfit/hecu/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_HECU

/datum/id_trim/hecu
	assignment = "Морпех HECU"
	trim_state = "trim_securityofficer"
	access = list(ACCESS_BRIG, ACCESS_SECURITY, ACCESS_AWAY_SEC)

/obj/effect/mob_spawn/human/black_mesa/hecu/leader
	name = "Лидер отряда HECU"
	outfit = /datum/outfit/hecu/leader
	short_desc = "Ты - лидер элитного тактического отряда, направленного в исследовательский центр для сдерживания заражения."
	flavour_text = "Ты и еще четверо удачливых солдат были выбраны для несения караульной службы возле одного из входов в Черную Мезу. Из-за отсутствия какого-либо реального инструктажа и смерти вашего инструктора во время посадки, ты не знаешь о том, какова ваша задача, так что твой быстро собраный отряд решил разбить лагерь здесь. В северо-западном лагере были слышны выстрелы, после чего они перестали выходить на связь. Вдобавок ко всему, ваш спасательный вертолет был сбит в полете, помощь задерживается; пулемётчик был убит в голову неизвестно откуда и неизвестно как. Скорее всего, ты сам по себе, по крайней мере сейчас."

/obj/effect/mob_spawn/human/black_mesa/hecu/leader/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.grant_language(/datum/language/uncommon, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.grant_language(/datum/language/arab, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.grant_language(/datum/language/xoxol, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.remove_language(/datum/language/common)

/datum/outfit/hecu/leader
	name = "Капитан HECU"
	uniform = /obj/item/clothing/under/rank/security/officer/hecu
	head = /obj/item/clothing/head/beret/sec
	mask = /obj/item/clothing/mask/gas/heavy/m40
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	belt = /obj/item/storage/belt/military/assault/hecu
	ears = /obj/item/radio/headset/headset_faction/bowman/captain
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/grenade/smokebomb
	r_pocket = /obj/item/binoculars
	back = /obj/item/storage/backpack/ert/odst/hecu
	backpack_contents = list(
		/obj/item/storage/box/survival/radio,
		/obj/item/storage/firstaid/emergency,
		/obj/item/storage/box/hecu_rations,
		/obj/item/kitchen/knife/combat,
		/obj/item/book/granter/martial/cqc,
		/obj/item/armament_points_card/hecu
	)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/hecu_leader

/datum/outfit/hecu/leader/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_HECU

/datum/id_trim/hecu_leader
	assignment = "Капитан HECU"
	trim_state = "trim_securityofficer"
	access = list(ACCESS_BRIG, ACCESS_SECURITY, ACCESS_AWAY_SEC)
