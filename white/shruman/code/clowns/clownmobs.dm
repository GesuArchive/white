/mob/living/simple_animal/hostile/clown
	name = "Клоун"
	desc = "Житель измерения клоунов."
	icon = 'icons/mob/clown_mobs.dmi'
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	health_doll_icon = "clown" //if >32x32, it will use this generic. for all the huge clown mobs that subtype from this
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	turns_per_move = 5
	response_disarm_continuous = "аккуратно отталкивает"
	response_disarm_simple = "аккуратно отталкивает"
	response_harm_continuous = "robusts"
	response_harm_simple = "robust"
	speak = list("ХОНК", "Хонк!")
	emote_see = list("хонкает", "пищит")
	speak_chance = 1
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 20
	maxHealth = 50
	health = 50
	speed = 2
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_sound = 'sound/items/bikehorn.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	del_on_death = 1
	faction = list("clown")
	damage_coeff = list(BRUTE = 1, BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 0)
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam)
	footstep_type = FOOTSTEP_MOB_SHOE
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	var/banana_time = 0 // If there's no time set it won't spawn.
	var/banana_type = /obj/item/grown/bananapeel
	var/attack_reagent
	var/heal_time = 0



// Прок заселения госта во всех клоунов, кроме мамки
/mob/living/simple_animal/hostile/clown/proc/humanize_clown(mob/user)
	var/pod_ask = tgui_alert(usr, "Стать клоуном?", "Хонк?", list("Да", "Нет"))
	if(pod_ask != "Да" || !src || QDELETED(src))
		return
	if(key)
		to_chat(user, span_warning("Кто-то уже занял этого клоуна!"))
		return
	key = user.key
	log_game("[key_name(src)] took control of [name].")

// Прок заселения госта в матку
/mob/living/simple_animal/hostile/clown/proc/humanize_glutton(mob/user)
	var/pod_ask = tgui_alert(usr, "Стать Апостолом клоунов?", "Хонк?", list("Да", "Нет"))
	if(pod_ask != "Да" || !src || QDELETED(src))
		return
	if(key)
		to_chat(user, span_warning("Кто-то уже занял этого клоуна!"))
		return
	key = user.key
	to_chat(src, "<B><font size=3 color=pink>Ты - Апостол Хонкоматери.</font></B>")
	to_chat(src, "<B><font size=2 color=blue>Ты можешь пожирать трупы и перемалывать их в плоть внутри себя.</font></B>")
	to_chat(src, "<B><font size=2 color=green>Плоть ты можешь использовать чтобы выращивать ее на полу или порождать клоунов.</font></B>")
	to_chat(src, "<B><font size=2 color=red>Также ты можешь высасывать энергию из лампочек, залечивая свои раны.</font></B>")
	log_game("[key_name(src)] took control of [name].")



//Тык госта по клоуну активирует прок заселения
/mob/living/simple_animal/hostile/clown/attack_ghost(mob/user)
	. = ..()
	if(.)
		return
	if(key)
		return
	if (istype(src, /mob/living/simple_animal/hostile/clown/mutant/glutton))
		humanize_glutton(user)
	else
		humanize_clown(user)



/mob/living/simple_animal/hostile/clown/handle_temperature_damage()
	if(bodytemperature < minbodytemp)
		adjustBruteLoss(10)
		throw_alert("temp", /atom/movable/screen/alert/cold, 2)
	else if(bodytemperature > maxbodytemp)
		adjustBruteLoss(15)
		throw_alert("temp", /atom/movable/screen/alert/hot, 3)
	else
		clear_alert("temp")

/mob/living/simple_animal/hostile/clown/AttackingTarget()
	if(istype(src.loc,/turf/closed/wall/clown/))
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/clown/attack_hand(mob/living/carbon/human/M)
	..()
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, TRUE)


/mob/living/simple_animal/hostile/clown/Life(delta_time = SSMOBS_DT, times_fired)
	. = ..()
	if (!istype(loc,/turf/closed/wall/clown/))
		src.invisibility = 0
	if(banana_time && banana_time < world.time)
		new banana_type(pick(src.loc))
		banana_time = world.time + rand(30,60)
	if ((locate(/obj/structure/fleshbuilding/clownweeds) in src.loc))
		if(heal_time < world.time)
			if (src.health < src.maxHealth)
				adjustHealth(-1)
			heal_time = world.time + 10
			if ((istype(src, /mob/living/simple_animal/hostile/clown/mutant/glutton))||(istype(src, /mob/living/simple_animal/hostile/clown/fleshclown)))
				var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = src
				glutton.biomass += 2


/mob/living/simple_animal/hostile/clown/AttackingTarget()
	. = ..()
	if(attack_reagent && . && isliving(target))
		var/mob/living/L = target
		if(L.reagents)
			L.reagents.add_reagent(attack_reagent, rand(1,5))

/mob/living/simple_animal/hostile/clown/lube
	name = "Склизкий клоун"
	desc = "Желеподобное создание, посланное сюда Хонкоматерью."
	icon_state = "lube"
	icon_living = "lube"
	turns_per_move = 1
	response_help_continuous = "dips a finger into"
	response_help_simple = "dip a finger into"
	response_disarm_continuous = "gently scoops and pours aside"
	response_disarm_simple = "gently scoop and pour aside"
	emote_see = list("булькает", "пузырится")
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam)

/mob/living/simple_animal/hostile/clown/lube/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/snailcrawl)

/mob/living/simple_animal/hostile/clown/banana
	name = "Бананка"
	desc = "Страшное слияние худших черт банана и клоуна."
	icon_state = "banana tree"
	icon_living = "banana tree"
	response_disarm_continuous = "peels"
	response_disarm_simple = "peel"
	response_harm_continuous = "peels"
	response_harm_simple = "peel"
	turns_per_move = 1
	emote_see = list("хонкает", "вгрызается в банан", "берет банан с головы", "фотосинтезирует")
	maxHealth = 90
	health = 90
	speed = 1
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam, /obj/item/soap, /obj/item/seeds/banana)
	banana_time = 20

/mob/living/simple_animal/hostile/clown/honkling
	name = "Хонклинг"
	desc = "Существо, посланное Хонкоматерью чтобы разносить веселье. Оно не опасно, но как-то напрягает..."
	icon_state = "honkling"
	icon_living = "honkling"
	turns_per_move = 1
	speed = -1
	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_verb_continuous = "cheers"
	attack_verb_simple = "cheers"
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam, /obj/item/soap, /obj/item/seeds/banana/bluespace)
	banana_type = /obj/item/grown/bananapeel
	attack_reagent = /datum/reagent/consumable/laughter

/mob/living/simple_animal/hostile/clown/fleshclown
	name = "Кожистый клоун"
	desc = "На этом клоуне очень много кожи."
	icon_state = "fleshclown"
	icon_living = "fleshclown"
	response_help_continuous = "reluctantly pokes"
	response_help_simple = "reluctantly poke"
	response_disarm_continuous = "sinks his hands into the spongy flesh of"
	response_disarm_simple = "sink your hands into the spongy flesh of"
	response_harm_continuous = "cleanses the world of"
	response_harm_simple = "cleanse the world of"
	emote_see = list("honks", "sweats", "jiggles", "contemplates its existence")
	speak_chance = 5
	maxHealth = 90
	health = 90
	speed = 2
	melee_damage_upper = 5
	attack_verb_continuous = "limply slaps"
	attack_verb_simple = "limply slap"
	obj_damage = 5
	var/biomass = 25
	loot = list(/obj/item/clothing/suit/hooded/bloated_human, /obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam, /obj/item/soap)

/mob/living/simple_animal/hostile/clown/fleshclown/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/hostile/clown/fleshclown/get_status_tab_items()
	. = ..()
	. += "Плоть: [biomass]"

/mob/living/simple_animal/hostile/clown/longface
	name = "Longface"
	desc = "Often found walking into the bar."
	icon_state = "long face"
	icon_living = "long face"
	turns_per_move = 10
	response_help_continuous = "tries to awkwardly hug"
	response_help_simple = "try to awkwardly hug"
	response_disarm_continuous = "pushes the unwieldy frame of"
	response_disarm_simple = "push the unwieldy frame of"
	response_harm_continuous = "tries to shut up"
	response_harm_simple = "try to shut up"
	emote_see = list("honks", "squeaks")
	speak_chance = 60
	maxHealth = 75
	health = 75
	pixel_x = -16
	base_pixel_x = -16
	speed = 1
	harm_intent_damage = 8
	melee_damage_lower = 10
	attack_verb_continuous = "YA-HONKs"
	attack_verb_simple = "YA-HONK"
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam, /obj/item/soap)

/mob/living/simple_animal/hostile/clown/clownhulk
	name = "Honk Hulk"
	desc = "A cruel and fearsome clown. Don't make him angry."
	icon_state = "honkhulk"
	icon_living = "honkhulk"
	response_help_continuous = "tries desperately to appease"
	response_help_simple = "try desperately to appease"
	response_disarm_continuous = "foolishly pushes"
	response_disarm_simple = "foolishly push"
	response_harm_continuous = "angers"
	response_harm_simple = "anger"
	speak = list("HONK", "Honk!", "HAUAUANK!!!", "GUUURRRRAAAHHH!!!")
	emote_see = list("honks", "sweats", "grunts")
	speak_chance = 5
	maxHealth = 400
	health = 400
	pixel_x = -16
	base_pixel_x = -16
	speed = 3
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "pummels"
	attack_verb_simple = "pummel"
	obj_damage = 30
	environment_smash = ENVIRONMENT_SMASH_WALLS
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam, /obj/item/soap)

/mob/living/simple_animal/hostile/clown/clownhulk/chlown
	name = "Chlown"
	desc = "A real lunkhead who somehow gets all the girls."
	icon_state = "chlown"
	icon_living = "chlown"
	response_help_continuous = "submits to"
	response_help_simple = "submit to"
	response_disarm_continuous = "tries to assert dominance over"
	response_disarm_simple = "try to assert dominance over"
	response_harm_continuous = "makes a weak beta attack at"
	response_harm_simple = "make a weak beta attack at"
	speak = list("HONK", "Honk!", "Bruh", "cheeaaaahhh?")
	emote_see = list("asserts his dominance", "emasculates everyone implicitly")
	maxHealth = 200
	health = 200
	speed = 1
	harm_intent_damage = 15
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_verb_continuous = "steals the girlfriend of"
	attack_verb_simple = "steal the girlfriend of"
	attack_sound = 'sound/items/airhorn2.ogg'
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam, /obj/effect/particle_effect/fluid/foam, /obj/item/soap)

/mob/living/simple_animal/hostile/clown/clownhulk/honcmunculus
	name = "Honkmunculus"
	desc = "A slender wiry figure of alchemical origin."
	icon_state = "honkmunculus"
	icon_living = "honkmunculus"
	response_help_continuous = "skeptically pokes"
	response_help_simple = "skeptically poke"
	response_disarm_continuous = "pushes the unwieldy frame of"
	response_disarm_simple = "push the unwieldy frame of"
	speak = list("honk")
	emote_see = list("squirms", "writhes")
	speak_chance = 1
	maxHealth = 200
	health = 200
	speed = 2
	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_verb_continuous = "ferociously mauls"
	attack_verb_simple = "ferociously maul"
	environment_smash = ENVIRONMENT_SMASH_NONE
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam, /obj/item/soap)
	attack_reagent = /datum/reagent/peaceborg/confuse

/mob/living/simple_animal/hostile/clown/clownhulk/destroyer
	name = "The Destroyer"
	desc = "An ancient being born of arcane honking."
	icon_state = "destroyer"
	icon_living = "destroyer"
	response_disarm_continuous = "bounces off of"
	response_harm_continuous = "bounces off of"
	speak = list("HONK!!!", "The Honkmother is merciful, so I must act out her wrath.", "parce mihi ad beatus honkmother placet mihi ut peccata committere,", "DIE!!!")
	maxHealth = 400
	health = 400
	speed = 5
	harm_intent_damage = 30
	melee_damage_lower = 20
	melee_damage_upper = 40
	armour_penetration = 30
	stat_attack = HARD_CRIT
	attack_verb_continuous = "acts out divine vengeance on"
	attack_verb_simple = "act out divine vengeance on"
	obj_damage = 50
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam, /obj/item/soap)

/mob/living/simple_animal/hostile/clown/mutant
	name = "Переполненный клоун"
	desc = "Внутри него все движется и пульсирует!"
	icon_state = "mutant"
	icon_living = "mutant"
	turns_per_move = 10
	response_help_continuous = "reluctantly sinks a finger into"
	response_help_simple = "reluctantly sink a finger into"
	response_disarm_continuous = "squishes into"
	response_disarm_simple = "squish into"
	response_harm_continuous = "squishes into"
	response_harm_simple = "squish into"
	speak = list("aaaaaahhhhuuhhhuhhhaaaaa", "AAAaaauuuaaAAAaauuhhh", "huuuuuh... hhhhuuuooooonnnnkk", "HuaUAAAnKKKK")
	emote_see = list("squirms", "writhes", "pulsates", "froths", "oozes")
	speak_chance = 10
	maxHealth = 75
	health = 75
	pixel_x = -16
	base_pixel_x = -16
	speed = 2
	harm_intent_damage = 8
	melee_damage_lower = 8
	melee_damage_upper = 8
	attack_verb_continuous = "awkwardly flails at"
	attack_verb_simple = "awkwardly flail at"
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /mob/living/simple_animal/hostile/clown/worm, /mob/living/simple_animal/hostile/clown/worm, /obj/effect/particle_effect/fluid/foam)

// Основной производящий юнит армии клоунов, матка
/mob/living/simple_animal/hostile/clown/mutant/glutton
	name = "Апостол Хонкоматери"
	desc = "Одно из бесчисленных воплощений воли Хонкоматери"
	icon_state = "glutton"
	icon_living = "glutton"
	speak = list("hey, buddy", "HONK!!!", "H-h-h-H-HOOOOONK!!!!", "HONKHONKHONK!!!", "HEY, BUCKO, GET BACK HERE!!!", "HOOOOOOOONK!!!")
	emote_see = list("jiggles", "wobbles")
	maxHealth = 1800
	health = 1200
	mob_size = MOB_SIZE_LARGE
	speed = 5
	melee_damage_lower = 20
	melee_damage_upper = 25
	force_threshold = 10 //lots of fat to cushion blows.
	damage_coeff = list(BRUTE = 1, BURN = 2, TOX = 1, CLONE = 2, STAMINA = 0, OXY = 0)
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"
	loot = list(/obj/effect/gibspawner/xeno/bodypartless, /obj/effect/gibspawner/generic, /obj/effect/gibspawner/generic/animal, /obj/effect/gibspawner/human/bodypartless)
	deathsound = 'sound/misc/sadtrombone.ogg'
	var/biomass = 70

/mob/living/simple_animal/hostile/clown/mutant/glutton/get_status_tab_items()
	. = ..()
	. += "Плоть: [biomass]"

/mob/living/simple_animal/hostile/clown/infestor
	name = "Разносчик радости"
	desc = "Не подпускай его к трупам своих друзей!."
	icon_state = "clown_spider"
	icon_living = "clown_spider"
	icon_dead = "clown_spider_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	speak_emote = list("трепещет")
	emote_hear = list("трепещет")
	speak_chance = 5
	speed = 0
	turns_per_move = 5
	see_in_dark = 4
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "аккуратно отталкивает"
	response_disarm_simple = "аккуратно отталкивает"
	maxHealth = 250
	health = 250
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 1, OXY = 1)
	melee_damage_lower = 25
	melee_damage_upper = 25
	pass_flags = PASSTABLE
	move_to_delay = 6
	attack_verb_continuous = "кусает"
	attack_verb_simple = "кусает"
	footstep_type = FOOTSTEP_MOB_CLAW
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/fluid/foam)

/mob/living/simple_animal/hostile/clown/infestor/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/hostile/clown/worm
	name = "Хонкочервь"
	desc = "Смешной червячок. Обычно ползает рядом с внутренностями."
	icon_state = "clown_worm"
	icon_living = "clown_worm"
	speak_emote = list("шипит")
	health = 20
	maxHealth = 20
	speed = 1
	attack_verb_continuous = "кусает"
	attack_verb_simple = "кусает"
	melee_damage_lower = 5
	melee_damage_upper = 6
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "прогоняет"
	response_disarm_simple = "прогоняет"
	response_harm_continuous = "steps on"
	response_harm_simple = "step on"
	loot = list(/obj/item/clothing/mask/gas/clown_hat)
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	environment_smash = ENVIRONMENT_SMASH_NONE


/mob/living/simple_animal/hostile/clown/mutant/glutton/Initialize(mapload)
	. = ..()

	var/datum/action/cooldown/spell/aoe/lighteater/LE = new(src)
	LE.Grant(src)

	var/datum/action/innate/glutton/plantSkin/PS = new(src)
	PS.Grant(src)

	var/datum/action/innate/glutton/build/MB = new(src)
	MB.Grant(src)

	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

	priority_announce("На станции [station_name()] обнаружен Апостол Хонкоматери. Заблокируйте любой внешний доступ, включая воздуховоды и вентиляцию.", "Боевая Тревога", ANNOUNCER_COMMANDREPORT)


/mob/living/simple_animal/hostile/clown/fleshclown/Initialize(mapload)
	. = ..()
	var/datum/action/innate/glutton/plantSkin/PS = new(src)
	PS.Grant(src)

	var/datum/action/innate/glutton/build/MB = new(src)
	MB.Grant(src)

//Пожирание трупов матерью
/mob/living/simple_animal/hostile/clown/mutant/glutton/proc/eat(atom/movable/A)
	if(A && A.loc != src)
		playsound(src, 'sound/items/eatfood.ogg', 100, TRUE)
		visible_message(span_warning("[capitalize(src.name)] пожирает [A]!"))
		biomass += 75
		qdel(A)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/clown/mutant/glutton/AttackingTarget(atom/attacked_target)
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			to_chat(src, span_warning("Начинаю проглатывать [L]..."))
			if(do_after_mob(src, L, 2 SECONDS))
				eat(L)
			return
		else
			. = ..()
	else
		. = ..()

//Превращение трупа в червивого пидора пауком
/mob/living/simple_animal/hostile/clown/infestor/proc/eat(atom/movable/A)
	if(A && A.loc != src)
		playsound(src, 'sound/effects/splat.ogg', 100, TRUE)
		new /obj/structure/spawner/clown/clowncorpse(get_turf(A.loc))
		new /obj/effect/particle_effect/fluid/foam(get_turf(A.loc))
		visible_message(span_warning("[capitalize(src.name)] заражает тело [A] хонкочервями!"))
		qdel(A)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/clown/infestor/AttackingTarget(atom/attacked_target)
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			to_chat(src, span_warning("Начинаю заражать труп [L]..."))
			if(do_after_mob(src, L, 6 SECONDS))
				eat(L)
			return
		else
			. = ..()
	else
		. = ..()



//Жрет свет и лечит себя
/datum/action/cooldown/spell/aoe/lighteater
	name = "Поглотить свет"
	desc = "Поглощает свет из ближайших лампочек."
	background_icon_state = "bg_changeling"
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "regurgitate"

	cooldown_time = 15 SECONDS
	spell_requirements = NONE

	invocation_type = INVOCATION_NONE
	antimagic_flags = NONE
	aoe_radius = 14

/datum/action/cooldown/spell/aoe/lighteater/cast(atom/cast_on)
	flick("glutton_tongue",usr)
	for(var/obj/machinery/light/L in view(6, cast_on))
		L.on = 1
		L.break_light_tube()
	for(var/mob/living/carbon/human/M in get_hearers_in_view(10, cast_on))
		SEND_SOUND(M, sound('sound/effects/screech.ogg'))
		M.add_confusion(25)
		M.Jitter(50)
	to_chat(cast_on, span_notice("Издаю ужасающий визг, высасывая энергию из лампочек вокруг!"))
	return ..()



//Направление клоунов в точку матерью

/mob/living/simple_animal/hostile/clown/mutant/glutton/MiddleClickOn(atom/A)
	. = ..()
	var/turf/T = get_turf(A)
	if(T)
		rally_clowns(T)

/mob/living/simple_animal/hostile/clown/mutant/glutton/verb/rally_clowns_power()
	set category = JOB_CLOWN
	set name = "Rally Clowns"
	set desc = "Rally your clowns to move to a target location."
	var/turf/T = get_turf(src)
	rally_clowns(T)

/mob/living/simple_animal/hostile/clown/mutant/glutton/proc/rally_clowns(turf/T)
	to_chat(src, "Приказываю клоунам идти.")
	var/list/surrounding_turfs = block(locate(T.x - 1, T.y - 1, T.z), locate(T.x + 1, T.y + 1, T.z))
	if(!surrounding_turfs.len)
		return
	for(var/mob/living/simple_animal/hostile/clown/BS in range(15, T))
		if(!BS.key)
			if(isturf(BS.loc) && get_dist(BS, T) <= 35 && !BS.key)
				BS.LoseTarget()
				BS.Goto(pick(surrounding_turfs), BS.move_to_delay)



// посадка кожи
/datum/action/innate/glutton/plantSkin
	name = "Вырастить кожу(25)"
	desc = "Выращивает на полу рассадник кожи."
	button_icon = 'icons/mob/actions/actions_clown.dmi'
	button_icon_state = "alien_plant"
	background_icon_state = "bg_changeling"

/datum/action/innate/fleshclown/plantSkin
	name = "Вырастить кожу(25)"
	desc = "Выращивает на полу рассадник кожи."
	button_icon = 'icons/mob/actions/actions_clown.dmi'
	button_icon_state = "alien_plant"
	background_icon_state = "bg_changeling"

/datum/action/innate/glutton/plantSkin/Activate()
	var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = owner

	if(!isturf(glutton.loc))
		return
	var/turf/glutton_turf = get_turf(glutton)

	if (glutton.biomass < 25)
		to_chat(glutton, span_warning("Недостаточно плоти!"))
		return FALSE
	if(locate(/obj/structure/fleshbuilding/clownweeds/node/) in glutton_turf)
		to_chat(glutton, span_warning("Здесь уже есть рассадник кожи!"))
		return FALSE
	glutton.visible_message(span_alertalien("[glutton] выращивает на полу рассадник кожи!"))
	new/obj/structure/fleshbuilding/clownweeds/node/(glutton.loc)
	glutton.biomass = glutton.biomass - 25
	return TRUE

/datum/action/innate/fleshclown/plantSkin/Activate()
	var/mob/living/simple_animal/hostile/clown/fleshclown/glutton = owner

	if(!isturf(glutton.loc))
		return
	var/turf/glutton_turf = get_turf(glutton)

	if (glutton.biomass < 25)
		to_chat(glutton, span_warning("Недостаточно плоти!"))
		return FALSE
	if(locate(/obj/structure/fleshbuilding/clownweeds/node/) in glutton_turf)
		to_chat(glutton, span_warning("Здесь уже есть рассадник кожи!"))
		return FALSE
	glutton.visible_message(span_alertalien("[glutton] выращивает на полу рассадник кожи!"))
	new/obj/structure/fleshbuilding/clownweeds/node/(glutton.loc)
	glutton.biomass = glutton.biomass - 25
	return TRUE


/mob/living/simple_animal/hostile/clown/Bump(atom/AM)
	. = ..()

	if(istype(AM, /turf/closed/wall/clown/))
		if(!istype(loc, /turf/closed/wall/clown/))
			if(do_after(src, 2 SECONDS, AM))
				forceMove(AM)
				src.invisibility = INVISIBILITY_ABSTRACT
				playsound(src.loc, 'sound/effects/gib_step.ogg', 50, TRUE)
				return

		else
			forceMove(AM)
			playsound(src.loc, 'sound/effects/gib_step.ogg', 50, TRUE)
			return


/mob/living/simple_animal/hostile/clown/Move(atom/newloc, dir , step_x , step_y)
	if(!(istype(newloc,/turf/closed/wall/clown/))&&(istype(loc,/turf/closed/wall/clown/)))
		var/turf/closed/wall/clown/oldturf = get_turf(src)
		oldturf.add_filter("stasis_status_ripple", 2, list("type" = "ripple", "flags" = WAVE_BOUNDED, "radius" = 0, "size" = 2))
		var/filter = oldturf.get_filter("stasis_status_ripple")
		audible_message(span_warning("Кожистая стена начинает чавкать..."))
		animate(filter, radius = 0, time = 0.2 SECONDS, size = 2, easing = JUMP_EASING, loop = -1, flags = ANIMATION_PARALLEL)
		animate(radius = 32, time = 1.5 SECONDS, size = 0)
		if(do_after(src, 2 SECONDS, newloc))
			src.invisibility = 0
			forceMove(newloc)
			oldturf.remove_filter("stasis_status_ripple")
		else
			return FALSE
	. = ..()


/datum/action/innate/glutton/build
	name = "Лепка плоти"
	desc = "Слепить из накопленной плоти органическое здание."
	var/list/structures = list(
		"Маленькие клоуны (100)" = /obj/structure/spawner/clown/clownsmall,
		"Клоуны-строители (200)" = /obj/structure/spawner/clown/clownbuilder,
		"Банановые клоуны (250)" = /obj/structure/spawner/clown/clownana,
		"Клоуны-пауки (300)" = /obj/structure/spawner/clown/clownspider,
		"Элитные клоуны (400)" = /obj/structure/spawner/clown/clownbig)

	button_icon = 'icons/mob/actions/actions_clown.dmi'
	button_icon_state = "alien_resin"
	background_icon_state = "bg_changeling"


/datum/action/innate/glutton/lesser/build
	name = "Лепка плоти"
	desc = "Слепить из накопленной плоти органическое здание."
	var/list/lesserStructures = list(
		"Преобразователь атмосферы (120)" = /obj/structure/fleshbuilding/clownatmos,
		"Клоунская стена (50)" = /turf/closed/wall/clown)

	button_icon = 'icons/mob/actions/actions_clown.dmi'
	button_icon_state = "alien_resin"
	background_icon_state = "bg_changeling"

/datum/action/innate/glutton/build/Activate()
	var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = owner
	var/choice = tgui_input_list(glutton, "Что будем строить.","Лепка плоти", structures)
	if(!choice)
		return FALSE
	choice =  structures[choice]
	var/obj/structure/spawner/clown/spawner =  new choice
	var/ccost = spawner.cost
	if(ccost > glutton.biomass)
		to_chat(glutton, span_notice("Недостаточно плоти."))
		return FALSE
	else
		new choice(glutton.loc)
		to_chat(glutton, span_notice("Леплю из плоти [spawner.name]."))
		glutton.visible_message(span_notice("[glutton] формирует неестественное строение из накопленной плоти."))
		glutton.biomass -= ccost
		return TRUE

/datum/action/innate/glutton/lesser/build/Activate()
	var/ccost = 0
	var/mob/living/simple_animal/hostile/clown/fleshclown/glutton = owner
	var/choice = tgui_input_list(glutton, "Что будем строить.","Лепка плоти", lesserStructures)
	if(!choice)
		return FALSE
	choice =  lesserStructures[choice]
	if (istype(choice, /obj/structure/fleshbuilding/ ))
		var/obj/structure/fleshbuilding/building =  new choice
		ccost = building.cost
		if(ccost > glutton.biomass)
			to_chat(glutton, span_notice("Недостаточно плоти."))
			return FALSE
		else
			new choice(glutton.loc)
			to_chat(glutton, span_notice("Леплю из плоти [building.name]."))
			glutton.visible_message(span_notice("[glutton] формирует неестественное строение из накопленной плоти."))
			glutton.biomass -= ccost
			return TRUE
	if (istype(choice, /turf/closed/wall/clown/ ))
		var/turf/closed/wall/clown/building =  new choice
		ccost = building.cost
		if(ccost > glutton.biomass)
			to_chat(glutton, span_notice("Недостаточно плоти."))
			return FALSE
		else
			new choice(glutton.loc)
			to_chat(glutton, span_notice("Леплю из плоти [building.name]."))
			glutton.visible_message(span_notice("[glutton] создает стену из кожи и плоти."))
			glutton.biomass -= ccost
			return TRUE








