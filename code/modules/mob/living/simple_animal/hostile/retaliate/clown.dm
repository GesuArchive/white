/mob/living/simple_animal/hostile/clown
	name = "Clown"
	desc = "A denizen of clown planet."
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
	speak = list("HONK", "Honk!", "Welcome to clown planet!")
	emote_see = list("honks", "squeaks")
	speak_chance = 1
	a_intent = INTENT_HARM
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
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270
	maxbodytemp = 370
	unsuitable_atmos_damage = 10
	footstep_type = FOOTSTEP_MOB_SHOE
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	var/banana_time = 0 // If there's no time set it won't spawn.
	var/banana_type = /obj/item/grown/bananapeel
	var/attack_reagent

/mob/living/simple_animal/hostile/clown/Initialize()
	. = ..()
	AddSpell(new /obj/effect/proc_holder/spell/targeted/night_vision)

/mob/living/simple_animal/hostile/clown/proc/humanize_clown(mob/user)
	var/pod_ask = alert("Become a clown?", "Honk?", "Yes", "No")
	if(pod_ask == "No" || !src || QDELETED(src))
		return
	if(key)
		to_chat(user, "<span class='warning'>Someone else already took this clown!</span>")
		return
	key = user.key
	log_game("[key_name(src)] took control of [name].")

/mob/living/simple_animal/hostile/clown/attack_ghost(mob/user)
	. = ..()
	if(.)
		return
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

/mob/living/simple_animal/hostile/clown/Life()
	. = ..()
	if(banana_time && banana_time < world.time)
		var/turf/T = get_turf(src)
		var/list/adjacent =  T.GetAtmosAdjacentTurfs(1)
		new banana_type(pick(adjacent))
		banana_time = world.time + rand(30,60)

/mob/living/simple_animal/hostile/clown/AttackingTarget()
	. = ..()
	if(attack_reagent && . && isliving(target))
		var/mob/living/L = target
		if(L.reagents)
			L.reagents.add_reagent(attack_reagent, rand(1,5))

/mob/living/simple_animal/hostile/clown/lube
	name = "Living Lube"
	desc = "A puddle of lube brought to life by the honkmother."
	icon_state = "lube"
	icon_living = "lube"
	turns_per_move = 1
	response_help_continuous = "dips a finger into"
	response_help_simple = "dip a finger into"
	response_disarm_continuous = "gently scoops and pours aside"
	response_disarm_simple = "gently scoop and pour aside"
	emote_see = list("bubbles", "oozes")
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/particle_effect/foam)

/mob/living/simple_animal/hostile/clown/lube/Initialize()
	. = ..()
	AddElement(/datum/element/snailcrawl)

/mob/living/simple_animal/hostile/clown/banana
	name = "Clownana"
	desc = "A fusion of clown and banana DNA birthed from a botany experiment gone wrong."
	icon_state = "banana tree"
	icon_living = "banana tree"
	response_disarm_continuous = "peels"
	response_disarm_simple = "peel"
	response_harm_continuous = "peels"
	response_harm_simple = "peel"
	turns_per_move = 1
	speak = list("HONK", "Honk!", "YA-HONK!!!")
	emote_see = list("honks", "bites into the banana", "plucks a banana off its head", "photosynthesizes")
	maxHealth = 120
	health = 120
	speed = -1
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/human, /obj/item/soap, /obj/item/seeds/banana)
	banana_time = 20

/mob/living/simple_animal/hostile/clown/honkling
	name = "Honkling"
	desc = "A divine being sent by the Honkmother to spread joy. It's not dangerous, but it's a bit of a nuisance."
	icon_state = "honkling"
	icon_living = "honkling"
	turns_per_move = 1
	speed = -1
	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_verb_continuous = "cheers up"
	attack_verb_simple = "cheer up"
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/human, /obj/item/soap, /obj/item/seeds/banana/bluespace)
	banana_type = /obj/item/grown/bananapeel
	attack_reagent = /datum/reagent/consumable/laughter

/mob/living/simple_animal/hostile/clown/fleshclown
	name = "Fleshclown"
	desc = "A being forged out of the pure essence of pranking, cursed into existence by a cruel maker."
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
	maxHealth = 140
	health = 140
	speed = 2
	melee_damage_upper = 8
	attack_verb_continuous = "limply slaps"
	attack_verb_simple = "limply slap"
	obj_damage = 5
	loot = list(/obj/item/clothing/suit/hooded/bloated_human, /obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/human, /obj/item/soap)

/mob/living/simple_animal/hostile/clown/longface
	name = "Longface"
	desc = "Often found walking into the bar."
	icon_state = "long face"
	icon_living = "long face"
	move_resist = INFINITY
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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/human, /obj/item/soap)

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
	harm_intent_damage = 15
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_verb_continuous = "pummels"
	attack_verb_simple = "pummel"
	obj_damage = 30
	environment_smash = ENVIRONMENT_SMASH_WALLS
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/human, /obj/item/soap)

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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/human, /obj/effect/particle_effect/foam, /obj/item/soap)

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
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_verb_continuous = "ferociously mauls"
	attack_verb_simple = "ferociously maul"
	environment_smash = ENVIRONMENT_SMASH_NONE
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/xeno/bodypartless, /obj/effect/particle_effect/foam, /obj/item/soap)
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
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/human, /obj/effect/particle_effect/foam, /obj/item/soap)

/mob/living/simple_animal/hostile/clown/mutant
	name = "Unknown"
	desc = "Kill it for its own sake."
	icon_state = "mutant"
	icon_living = "mutant"
	move_resist = INFINITY
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
	maxHealth = 50
	health = 50
	pixel_x = -16
	base_pixel_x = -16
	speed = 1
	harm_intent_damage = 10
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "awkwardly flails at"
	attack_verb_simple = "awkwardly flail at"
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/effect/gibspawner/xeno/bodypartless, /obj/item/soap, /obj/effect/gibspawner/generic, /obj/effect/gibspawner/generic/animal, /obj/effect/gibspawner/human/bodypartless, /obj/effect/gibspawner/human)

/mob/living/simple_animal/hostile/clown/mutant/slow
	speed = 20
	move_to_delay = 60

/mob/living/simple_animal/hostile/clown/mutant/glutton
	name = "Апостол Хонкоматери"
	desc = "Одно из бесчисленных воплощений воли Хонкоматери"
	icon_state = "glutton"
	icon_living = "glutton"
	speak = list("hey, buddy", "HONK!!!", "H-h-h-H-HOOOOONK!!!!", "HONKHONKHONK!!!", "HEY, BUCKO, GET BACK HERE!!!", "HOOOOOOOONK!!!")
	emote_see = list("jiggles", "wobbles")
	maxHealth = 1000
	health = 1000
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
	var/clownlight = 0
	var/maxClownlight = 200
	var/datum/action/innate/glutton/open_portal/open_portal
/mob/living/simple_animal/hostile/clown/mutant/glutton/get_status_tab_items()
	. = ..()
	. += "Здоровье: [round((health / maxHealth) * 100)]%"
	. += "Энергия: [clownlight]/[maxClownlight]"




/mob/living/simple_animal/hostile/clown/mutant/glutton/Initialize()
	. = ..()
	AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/lighteater)
	open_portal = new
	open_portal.Grant(src)



//Жрет трупы и срет клоунами взамен
/mob/living/simple_animal/hostile/clown/mutant/glutton/proc/eat(atom/movable/A)
	if(A && A.loc != src)
		playsound(src, 'sound/magic/demon_attack1.ogg', 100, TRUE)
		visible_message("<span class='warning'>[capitalize(src.name)] пожирает [A] и превращает его тело в нечто более прекрасное!</span>")
		A.forceMove(src)
		return TRUE
	return FALSE
/mob/living/simple_animal/hostile/clown/mutant/glutton/AttackingTarget(atom/attacked_target)
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			to_chat(src, "<span class='warning'>Начинаю проглатывать [L]...</span>")
			if(do_after(src, 30, target = L))
				if(eat(L))
					new /mob/living/simple_animal/hostile/clown(usr.loc)
					notify_ghosts("Тело клоуна доступно в [get_area(src)].", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Honk!")
			return
		else
			. = ..()
	else
		. = ..()



/obj/effect/proc_holder/spell/targeted/night_vision
	name = "Toggle Nightvision \[ON\]"
	desc = "Toggle your nightvision mode."
	charge_max = 10
	clothes_req = 0
	action_background_icon_state = "bg_changeling"
	message = "<span class='notice'>You toggle your night vision!</span>"
	range = -1
	include_user = 1


//Клоуны - ночные животные, поэтому должны видеть в темноте
/obj/effect/proc_holder/spell/targeted/night_vision/cast(list/targets, mob/user = usr)
	for(var/mob/living/target in targets)
		switch(target.lighting_alpha)
			if (LIGHTING_PLANE_ALPHA_VISIBLE)
				target.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
				name = "Toggle Nightvision \[More]"
			if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
				target.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
				name = "Toggle Nightvision \[Full]"
			if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
				target.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
				name = "Toggle Nightvision \[OFF]"
			else
				target.lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
				name = "Toggle Nightvision \[ON]"
		target.update_sight()


//Жрет свет и лечит себя ++ атмосфэра
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
	for(var/obj/machinery/light/L in view(4, user))
		L.on = 1
		L.break_light_tube()
		user.adjustHealth(-50)
		user.clownlight+=10
	for(var/mob/living/M in get_hearers_in_view(4, user))
		SEND_SOUND(M, sound('sound/effects/screech.ogg'))
	to_chat(user, "<span class='notice'>Издаю ужасающий визг, высасывая энергию из лампочек вокруг!</span>")
	return



/datum/action/innate/glutton/open_portal
	name = "Открыть разлом"
	desc = "Открыть разлом в измерение клоунов."
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_space_dragon.dmi'
	button_icon_state = "carp_rift"
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

	if (glutton.clownlight < 200)
		to_chat(glutton, "<span class ='notice'>Недостаточно энергии!</span>")
		return FALSE
	else
		to_chat(glutton, "<span class='notice'>Использовав поглощенную энергию, я прорываю ткань реальности и создаю портал напрямую в измерение клоунов!</span>")
		new /obj/structure/spawner/clown(glutton_turf)
		glutton.clownlight -= 200

