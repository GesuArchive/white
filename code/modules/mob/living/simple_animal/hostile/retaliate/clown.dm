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
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "robusts"
	response_harm_simple = "robust"
	speak = list("ХОНК", "Хонк!")
	emote_see = list("хонкает", "пищит")
	speak_chance = 1
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
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
	loot = list(/obj/effect/mob_spawn/human/clown/corpse)
	footstep_type = FOOTSTEP_MOB_SHOE
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	var/banana_time = 0 // If there's no time set it won't spawn.
	var/banana_type = /obj/item/grown/bananapeel
	var/attack_reagent
	var/heal_time = 0



// Прок заселения госта во всех клоунов, кроме мамки
/mob/living/simple_animal/hostile/clown/proc/humanize_clown(mob/user)
	var/pod_ask = alert("Стать клоуном?", "Хонк?", "Да", "Нет")
	if(pod_ask == "Нет" || !src || QDELETED(src))
		return
	if(key)
		to_chat(user, "<span class='warning'>Кто-то уже занял этого клоуна!</span>")
		return
	key = user.key
	log_game("[key_name(src)] took control of [name].")

// Прок заселения госта в матку
/mob/living/simple_animal/hostile/clown/proc/humanize_glutton(mob/user)
	var/pod_ask = alert("Стать Апостолом клоунов?", "Хонк?", "Да", "Нет")
	if(pod_ask == "Нет" || !src || QDELETED(src))
		return
	if(key)
		to_chat(user, "<span class='warning'>Кто-то уже занял этого клоуна!</span>")
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

/mob/living/simple_animal/hostile/clown/attack_hand(mob/living/carbon/human/M)
	..()
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clown/Life(delta_time = SSMOBS_DT, times_fired)
	. = ..()
	if(banana_time && banana_time < world.time)
		var/turf/T = get_turf(src)
		var/list/adjacent =  T.GetAtmosAdjacentTurfs(1)
		new banana_type(pick(adjacent))
		banana_time = world.time + rand(30,60)
	if ((locate(/obj/structure/clownweeds) in src.loc))
		if(heal_time < world.time)
			if (src.health < src.maxHealth)
				adjustHealth(-1)
			heal_time = world.time + 10
			if (istype(src, /mob/living/simple_animal/hostile/clown/mutant/glutton))
				var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = src
				glutton.biomass += 1


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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam)

/mob/living/simple_animal/hostile/clown/lube/Initialize()
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
	speak = list("ХОНК", "Хонк!")
	emote_see = list("хонкает", "вгрызается в банан", "берет банан с головы", "фотосинтезирует")
	maxHealth = 120
	health = 120
	speed = 1
	loot = list(/obj/effect/mob_spawn/human/clown/corpse,/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam, /obj/item/soap, /obj/item/seeds/banana)
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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam, /obj/item/soap, /obj/item/seeds/banana/bluespace)
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
	speak = list("HONK", "Honk!", "I didn't ask for this", "I feel constant and horrible pain", "YA-HONK!!!", "this body is a merciless and unforgiving prison", "I was born out of mirthful pranking but I live in suffering")
	emote_see = list("honks", "sweats", "jiggles", "contemplates its existence")
	speak_chance = 5
	dextrous = TRUE
	ventcrawler = VENTCRAWLER_ALWAYS
	maxHealth = 150
	health = 150
	speed = 2
	melee_damage_upper = 5
	attack_verb_continuous = "limply slaps"
	attack_verb_simple = "limply slap"
	obj_damage = 5
	loot = list(/obj/effect/mob_spawn/human/clown/corpse, /obj/item/clothing/suit/hooded/bloated_human, /obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam, /obj/item/soap)

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
	speak = list("YA-HONK!!!")
	emote_see = list("honks", "squeaks")
	speak_chance = 60
	maxHealth = 100
	health = 100
	pixel_x = -16
	base_pixel_x = -16
	speed = 1
	harm_intent_damage = 8
	melee_damage_lower = 10
	attack_verb_continuous = "YA-HONKs"
	attack_verb_simple = "YA-HONK"
	loot = list(/obj/effect/mob_spawn/human/clown/corpse, /obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam, /obj/item/soap)

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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam, /obj/item/soap)

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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam, /obj/effect/particle_effect/foam, /obj/item/soap)

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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam, /obj/item/soap)
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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam, /obj/item/soap)

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
	maxHealth = 100
	health = 100
	pixel_x = -16
	base_pixel_x = -16
	speed = 2
	harm_intent_damage = 8
	melee_damage_lower = 8
	melee_damage_upper = 8
	attack_verb_continuous = "awkwardly flails at"
	attack_verb_simple = "awkwardly flail at"
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /mob/living/simple_animal/hostile/clown/worm, /mob/living/simple_animal/hostile/clown/worm, /obj/effect/particle_effect/foam)

// Основной производящий юнит армии клоунов, матка
/mob/living/simple_animal/hostile/clown/mutant/glutton
	name = "Апостол Хонкоматери"
	desc = "Одно из бесчисленных воплощений воли Хонкоматери"
	icon_state = "glutton"
	icon_living = "glutton"
	speak = list("hey, buddy", "HONK!!!", "H-h-h-H-HOOOOONK!!!!", "HONKHONKHONK!!!", "HEY, BUCKO, GET BACK HERE!!!", "HOOOOOOOONK!!!")
	emote_see = list("jiggles", "wobbles")
	maxHealth = 1800
	health = 1800
	mob_size = MOB_SIZE_LARGE
	speed = 5
	melee_damage_lower = 20
	melee_damage_upper = 25
	force_threshold = 10 //lots of fat to cushion blows.
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 2, STAMINA = 0, OXY = 1)
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"
	loot = list(/obj/effect/gibspawner/xeno/bodypartless, /obj/effect/gibspawner/generic, /obj/effect/gibspawner/generic/animal, /obj/effect/gibspawner/human/bodypartless)
	deathsound = 'sound/misc/sadtrombone.ogg'
	food_type = list(/obj/item/food/cheesiehonkers, /obj/item/food/cornchips)
	var/obj/effect/proc_holder/spell/aoe_turf/Lighteater/my_regurgitate
	var/biomass = 70
	var/datum/action/innate/glutton/open_portal/open_portal
	var/datum/action/innate/glutton/clown1/clown1
	var/datum/action/innate/glutton/clown2/clown2
	var/datum/action/innate/glutton/clown3/clown3
	var/datum/action/innate/glutton/plantSkin/plantSkin
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
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	speed = 0
	turns_per_move = 5
	see_in_dark = 4
	ventcrawler = VENTCRAWLER_ALWAYS
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam)

/mob/living/simple_animal/hostile/clown/worm
	name = "Хонкочервь"
	desc = "Смешной червячок. Обычно ползает рядом с внутренностями."
	icon_state = "clown_worm"
	icon_living = "clown_worm"
	speak_emote = list("hisses")
	health = 20
	maxHealth = 20
	speed = 1
	attack_verb_continuous = "кусает"
	attack_verb_simple = "кусает"
	melee_damage_lower = 5
	melee_damage_upper = 6
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "steps on"
	response_harm_simple = "step on"
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam)
	ventcrawler = VENTCRAWLER_ALWAYS
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST|MOB_REPTILE
	environment_smash = ENVIRONMENT_SMASH_NONE


// Добавляем абилки матери
/mob/living/simple_animal/hostile/clown/mutant/glutton/Initialize()
	. = ..()
	AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/lighteater)
	open_portal = new
	open_portal.Grant(src)
	plantSkin = new
	plantSkin.Grant(src)
	clown1 = new
	clown1.Grant(src)
	clown2 = new
	clown2.Grant(src)
	clown3 = new
	clown3.Grant(src)



//Пожирание трупов матерью
/mob/living/simple_animal/hostile/clown/mutant/glutton/proc/eat(atom/movable/A)
	if(A && A.loc != src)
		playsound(src, 'sound/items/eatfood.ogg', 100, TRUE)
		visible_message("<span class='warning'>[capitalize(src.name)] пожирает [A]!</span>")
		biomass += 50
		qdel(A)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/clown/mutant/glutton/AttackingTarget(atom/attacked_target)
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			to_chat(src, "<span class='warning'>Начинаю проглатывать [L]...</span>")
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
		new /mob/living/simple_animal/hostile/clown/mutant(A.loc)
		new /obj/effect/particle_effect/foam(get_turf(A.loc))
		visible_message("<span class='warning'>[capitalize(src.name)] заражает тело [A] хонкочервями!</span>")
		qdel(A)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/clown/infestor/AttackingTarget(atom/attacked_target)
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			to_chat(src, "<span class='warning'>Начинаю заражать труп [L]...</span>")
			if(do_after_mob(src, L, 6 SECONDS))
				eat(L)
			return
		else
			. = ..()
	else
		. = ..()



//Жрет свет и лечит себя + атмосфэра
/obj/effect/proc_holder/spell/aoe_turf/lighteater
	name = "Поглотить свет"
	desc = "Поглощает свет из ближайших лампочек."
	action_background_icon_state = "bg_changeling"
	action_icon = 'icons/mob/actions/actions_animal.dmi'
	action_icon_state = "regurgitate"
	charge_max = 300
	clothes_req = 0
	range = 14


/obj/effect/proc_holder/spell/aoe_turf/lighteater/cast(list/targets, mob/living/simple_animal/hostile/clown/mutant/glutton/user = usr)
	flick("glutton_tongue",usr)
	for(var/obj/machinery/light/L in view(6, user))
		if (L.icon_state != "tube-broken")
			user.adjustHealth(-50)
		L.on = 1
		L.break_light_tube()
	for(var/mob/living/carbon/human/M in get_hearers_in_view(4, user))
		SEND_SOUND(M, sound('sound/effects/screech.ogg'))
		M.add_confusion(25)
		M.Jitter(50)
	to_chat(user, "<span class='notice'>Издаю ужасающий визг, высасывая энергию из лампочек вокруг!</span>")
	return


// Создание спавнера
/datum/action/innate/glutton/open_portal
	name = "Открыть разлом(300)"
	desc = "Открыть разлом в измерение клоунов."
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/obj/device.dmi'
	button_icon_state = "clownbeacon"
	background_icon_state = "bg_changeling"

//Создание обычного клоуна
/datum/action/innate/glutton/clown1
	name = "Слепить клоуна(50)"
	desc = "Слепить обычного клоуна из плоти."
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_clown.dmi'
	button_icon_state = "clown1"
	background_icon_state = "bg_changeling"

//Создание среднего клоуна
/datum/action/innate/glutton/clown2
	name = "Слепить необычного клоуна(75)"
	desc = "Взять немного больше плоти и сделать необычного клоуна."
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_clown.dmi'
	button_icon_state = "clown2"
	background_icon_state = "bg_changeling"

//Создание большого клоуна
/datum/action/innate/glutton/clown3
	name = "Слепить клоуна-чудовище(200)"
	desc = "Взять плоть, набранную из многих тел и создать монстра."
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_clown.dmi'
	button_icon_state = "clown3"
	background_icon_state = "bg_changeling"


/datum/action/innate/glutton/open_portal/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/clown/mutant/glutton))
		return
	var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = owner

	if(!isturf(glutton.loc))
		return
	var/turf/glutton_turf = get_turf(glutton)

	var/obj/structure/spawner/clown/spawner = locate() in glutton_turf
	if(spawner)
		to_chat(glutton, "<span class='warning'>Здесь уже есть портал!</span>")
		return

	if (glutton.biomass < 300)
		to_chat(glutton, "<span class ='notice'>Недостаточно плоти!</span>")
		return FALSE
	else
		playsound(src, 'sound/effects/splat.ogg', 100, TRUE)
		to_chat(glutton, "<span class='notice'>Леплю из собранной плоти смешную голову клоуна!</span>")
		new /obj/structure/spawner/clown(glutton_turf)
		glutton.biomass -= 300

/datum/action/innate/glutton/clown1/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/clown/mutant/glutton))
		return
	var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = owner

	if(!isturf(glutton.loc))
		return
	var/turf/glutton_turf = get_turf(glutton)

	if (glutton.biomass < 50)
		to_chat(glutton, "<span class ='notice'>Недостаточно плоти!</span>")
		return FALSE
	else
		playsound(glutton, 'sound/effects/splat.ogg', 100, TRUE)
		to_chat(glutton, "<span class='notice'>Создаю из собранной плоти нового клоуна!</span>")
		new /mob/living/simple_animal/hostile/clown(glutton_turf)
		glutton.biomass -= 50

/datum/action/innate/glutton/clown2/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/clown/mutant/glutton))
		return
	var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = owner

	if(!isturf(glutton.loc))
		return
	var/turf/glutton_turf = get_turf(glutton)

	if (glutton.biomass < 75)
		to_chat(glutton, "<span class ='notice'>Недостаточно плоти!</span>")
		return FALSE
	else
		playsound(glutton, 'sound/effects/splat.ogg', 100, TRUE)
		to_chat(glutton, "<span class='notice'>Создаю из собранной плоти необычного клоуна!</span>")
		var/moblist = list(/mob/living/simple_animal/hostile/clown/banana, /mob/living/simple_animal/hostile/clown/mutant, /mob/living/simple_animal/hostile/clown/fleshclown, /mob/living/simple_animal/hostile/clown/longface, /mob/living/simple_animal/hostile/clown/honkling, /mob/living/simple_animal/hostile/clown/lube)
		var/spawnedmob = pick(moblist)
		new spawnedmob(glutton_turf)
		glutton.biomass -= 75

/datum/action/innate/glutton/clown3/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/clown/mutant/glutton))
		return
	var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = owner

	if(!isturf(glutton.loc))
		return
	var/turf/glutton_turf = get_turf(glutton)

	if (glutton.biomass < 200)
		to_chat(glutton, "<span class ='notice'>Недостаточно плоти!</span>")
		return FALSE
	else
		playsound(glutton, 'sound/effects/splat.ogg', 100, TRUE)
		to_chat(glutton, "<span class='notice'>Создаю из собранной плоти сильного клоуна!</span>")
		var/moblist = list(/mob/living/simple_animal/hostile/clown/clownhulk,  /mob/living/simple_animal/hostile/clown/infestor,  /mob/living/simple_animal/hostile/clown/clownhulk/chlown, /mob/living/simple_animal/hostile/clown/clownhulk/honcmunculus)
		var/spawnedmob = pick(moblist)
		new spawnedmob(glutton_turf)
		glutton.biomass -= 200

//Направление клоунов в точку матерью

/mob/living/simple_animal/hostile/clown/mutant/glutton/MiddleClickOn(atom/A)
	. = ..()
	var/turf/T = get_turf(A)
	if(T)
		rally_clowns(T)

/mob/living/simple_animal/hostile/clown/mutant/glutton/verb/rally_clowns_power()
	set category = "Blob"
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


// Кожистый пол
#define NODERANGE 6
/obj/structure/clownweeds
	gender = PLURAL
	name = "кожистый пол"
	desc = "Толстый слой кожи и мяса, покрывающий пол."
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	icon = 'icons/obj/smooth_structures/alien/weeds1.dmi'
	icon_state = "weeds1-0"
	base_icon_state = "weeds1"
	max_integrity = 15
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WEEDS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WEEDS, SMOOTH_GROUP_WALLS)
	var/last_expand = 0 //last world.time this weed expanded
	var/growth_cooldown_low = 150
	var/growth_cooldown_high = 200
	var/static/list/blacklisted_turfs

/obj/structure/clownweeds/Initialize()
	pixel_x = -4
	pixel_y = -4 //so the sprites line up right in the map editor

	. = ..()

	if(!blacklisted_turfs)
		blacklisted_turfs = typecacheof(list(
			/turf/open/space,
			/turf/open/chasm,
			/turf/open/lava,
			/turf/open/openspace))

	set_base_icon()

	last_expand = world.time + rand(growth_cooldown_low, growth_cooldown_high)


///Randomizes the weeds' starting icon, gets redefined by children for them not to share the behavior.
/obj/structure/clownweeds/proc/set_base_icon()
	. = base_icon_state
	icon = 'icons/obj/smooth_structures/alien/clownweeds1.dmi'
	base_icon_state = "weeds1"
	set_smoothed_icon_state(smoothing_junction)


/obj/structure/clownweeds/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/atmos_sensitive)

/obj/structure/clownweeds/proc/expand()
	var/turf/U = get_turf(src)
	if(is_type_in_typecache(U, blacklisted_turfs))
		qdel(src)
		return FALSE
	for(var/turf/T in U.GetAtmosAdjacentTurfs())
		if(locate(/obj/structure/clownweeds/) in T)
			continue

		if(is_type_in_typecache(T, blacklisted_turfs))
			continue

		new /obj/structure/clownweeds/(T)
		for (var/turf/V in range(1,T))
			if(istype(V, /turf/closed/wall))
				V.ChangeTurf(/turf/closed/wall/clown)

	return TRUE

/obj/structure/clownweeds/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 300

/obj/structure/clownweeds/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(5, BURN, 0, 0)

//Weed nodes
/obj/structure/clownweeds/node
	name = "рассадник кожи"
	desc = "На этом участке кожи много странных розовых прыщей."
	icon = 'icons/obj/smooth_structures/alien/clownnode.dmi'
	icon_state = "weednode-0"
	base_icon_state = "weednode"
	var/lon_range = 4
	var/node_range = NODERANGE


/obj/structure/clownweeds/node/Initialize()
	. = ..()
	var/obj/structure/clownweeds/W = locate(/obj/structure/clownweeds/) in loc
	if(W && W != src)
		qdel(W)
	START_PROCESSING(SSobj, src)


/obj/structure/clownweeds/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/structure/clownweeds/node/process()
	for(var/obj/structure/clownweeds/W in range(node_range, src))
		if(W.last_expand <= world.time)
			if(W.expand())
				W.last_expand = world.time + rand(growth_cooldown_low, growth_cooldown_high)


/obj/structure/clownweeds/node/set_base_icon()
	return //No icon randomization at init. The node's icon is already well defined.

// посадка кожи
/datum/action/innate/glutton/plantSkin
	name = "Вырастить кожу(25)"
	desc = "Выращивает на полу рассадник кожи."
	icon_icon = 'icons/mob/actions/actions_clown.dmi'
	button_icon_state = "alien_plant"
	background_icon_state = "bg_changeling"


/datum/action/innate/glutton/plantSkin/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/clown/mutant/glutton))
		return
	var/mob/living/simple_animal/hostile/clown/mutant/glutton/glutton = owner

	if(!isturf(glutton.loc))
		return
	var/turf/glutton_turf = get_turf(glutton)

	if (glutton.biomass < 25)
		to_chat(glutton, "<span class='warning'>Недостаточно плоти!</span>")
		return FALSE
	if(locate(/obj/structure/clownweeds/node/) in glutton_turf)
		to_chat(glutton, "<span class='warning'>Здесь уже есть рассадник кожи!</span>")
		return FALSE
	glutton.visible_message("<span class='alertalien'>[glutton] выращивает на полу рассадник кожи!</span>")
	new/obj/structure/clownweeds/node/(glutton.loc)
	glutton.biomass = glutton.biomass - 25
	return TRUE



/turf/closed/wall/clown
	name = "Кожистая стена"
	desc = "Эта стена покрыта кожей."
	icon = 'icons/obj/smooth_structures/alien/clownwall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WALLS)


/mob/living/simple_animal/hostile/clown/Bump(atom/AM)
	. = ..()
	if(istype(AM, /turf/closed/wall/clown/) && AM != loc) //we can go through cult walls
		var/atom/movable/stored_pulling = pulling
		if(stored_pulling)
			stored_pulling.setDir(get_dir(stored_pulling.loc, loc))
			stored_pulling.forceMove(loc)
		forceMove(AM)
		playsound(src.loc, 'sound/effects/gib_step.ogg', 50, TRUE)
		if(stored_pulling)
			start_pulling(stored_pulling, supress_message = TRUE) //drag anything we're pulling through the wall with us by magic
