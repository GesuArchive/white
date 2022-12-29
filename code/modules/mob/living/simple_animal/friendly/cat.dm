//Cat
/mob/living/simple_animal/pet/cat
	name = "Кот"
	desc = "Кiшка!!"
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	speak = list("Мяу!", "Шшш!", "Мурр!", "ХШШШШ")
	speak_emote = list("мурчит", "мяукает")
	emote_hear = list("мяукает.", "мявкает.")
	emote_see = list("мотает головой.", "дрожит.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 0.5
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(/obj/item/food/meat/slab = 1, /obj/item/organ/ears/cat = 1, /obj/item/organ/tail/cat = 1, /obj/item/stack/sheet/animalhide/cat = 1)
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "отталкивает"
	response_disarm_simple = "отталкивает"
	response_harm_continuous = "пинает"
	response_harm_simple = "пинает"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	var/mob/living/simple_animal/mouse/movement_target
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "cat"
	can_be_held = TRUE
	held_state = "cat2"
	pet_bonus = TRUE
	pet_bonus_emote = "мурчит!"
	///In the case 'melee_damage_upper' is somehow raised above 0
	attack_verb_continuous = "цапает"
	attack_verb_simple = "цапает"
	attack_sound = 'sound/weapons/slash.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW

	footstep_type = FOOTSTEP_MOB_CLAW
	deathsound = 'white/valtos/sounds/cat/death.ogg'
	var/list/meowlist =list('white/valtos/sounds/cat/meow1.ogg',
							'white/valtos/sounds/cat/meow2.ogg',
							'white/valtos/sounds/cat/meow3.ogg',
							'white/valtos/sounds/cat/meow4.ogg',
							'white/valtos/sounds/cat/meow5.ogg',
							'white/valtos/sounds/cat/meow6.ogg',
							'white/valtos/sounds/cat/meow7.ogg',
							'white/valtos/sounds/cat/meow8.ogg')

/mob/living/simple_animal/pet/cat/male
/mob/living/simple_animal/pet/cat/male/Initialize(_gender=null)
	.=..(MALE)
/mob/living/simple_animal/pet/cat/female
/mob/living/simple_animal/pet/cat/female/Initialize(_gender=null)
	.=..(FEMALE)

/mob/living/simple_animal/pet/cat/Initialize(_gender=null)
	. = ..()
	add_verb(src, /mob/living/proc/toggle_resting)
	add_cell_sample()
	if(_gender in list(FEMALE, MALE, PLURAL))
		gender = _gender
	else
		gender = pick(MALE, FEMALE)
	name = gender == FEMALE ? "Кошка":"Кот"
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/pet/cat/add_cell_sample()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CAT, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)


/mob/living/simple_animal/pet/cat/space
	name = "Космокот"
	desc = "Кот... в космосе!"
	icon_state = "spacecat"
	icon_living = "spacecat"
	icon_dead = "spacecat_dead"
	unsuitable_atmos_damage = 0
	minbodytemp = TCMB
	maxbodytemp = T0C + 40
	held_state = "spacecat"

/mob/living/simple_animal/pet/cat/breadcat
	name = "Хлеб"
	desc = "Кот... не хлеб!"
	icon_state = "breadcat"
	icon_living = "breadcat"
	icon_dead = "breadcat_dead"
	collar_type = null
	held_state = "breadcat"
	butcher_results = list(/obj/item/food/meat/slab = 2, /obj/item/organ/ears/cat = 1, /obj/item/organ/tail/cat = 1, /obj/item/food/breadslice/plain = 1)

/mob/living/simple_animal/pet/cat/breadcat/add_cell_sample()
	return

/mob/living/simple_animal/pet/cat/original
	name = "Бэтси"
	desc = "Продукт смеси ДНК пришельца и кота."
	gender = FEMALE
	icon_state = "original"
	icon_living = "original"
	icon_dead = "original_dead"
	collar_type = null
	unique_pet = TRUE
	held_state = "original"

/mob/living/simple_animal/pet/cat/original/add_cell_sample()
	return
/mob/living/simple_animal/pet/cat/kitten
	name = "Киса"
	desc = "D'aaawwww."
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL
	collar_type = "kitten"

/mob/living/simple_animal/pet/cat/kitten/Initialize(_gender=null)
	. = ..(null)
	addtimer(CALLBACK(src, PROC_REF(grow)), 2.5 MINUTES)
	name = gender == FEMALE ? "Киса":"Котик"

/mob/living/simple_animal/pet/cat/kitten/proc/grow()
	if(stat == DEAD)
		return
	var/mob/living/M = new animal_species(loc)
	M.gender = gender
	M.name = M.gender == FEMALE ? "Кошка":"Кот"
	qdel(src)

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/runtime
	name = "Рантайм"
	desc = "GCAT"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/list/family = list()//var restored from savefile, has count of each child type
	var/list/children = list()//Actual mob instances of children
	var/cats_deployed = 0
	var/memory_saved = FALSE
	held_state = "cat"

/mob/living/simple_animal/pet/cat/runtime/Initialize(_gender=null)
	if(prob(5))
		icon_state = "original"
		icon_living = "original"
		icon_dead = "original_dead"
	Read_Memory()
	. = ..()

/mob/living/simple_animal/pet/cat/runtime/Life(delta_time = SSMOBS_DT, times_fired)
	if(!cats_deployed && SSticker.current_state >= GAME_STATE_SETTING_UP)
		Deploy_The_Cats()
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory()
		memory_saved = TRUE
	..()

/mob/living/simple_animal/pet/cat/runtime/make_babies()
	var/mob/baby = ..()
	if(baby)
		children += baby
		return baby

/mob/living/simple_animal/pet/cat/runtime/death()
	if(!memory_saved)
		Write_Memory(TRUE)
	..()

/mob/living/simple_animal/pet/cat/runtime/proc/Read_Memory()
	if(fexists("data/npc_saves/Runtime.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
		S["family"] >> family
		fdel("data/npc_saves/Runtime.sav")
	else
		var/json_file = file("data/npc_saves/Runtime.json")
		if(!fexists(json_file))
			return
		var/list/json = r_json_decode(file2text(json_file))
		family = json["family"]
	if(isnull(family))
		family = list()

/mob/living/simple_animal/pet/cat/runtime/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Runtime.json")
	var/list/file_data = list()
	family = list()
	if(!dead)
		for(var/mob/living/simple_animal/pet/cat/kitten/C in children)
			if(istype(C,type) || C.stat || !C.z || (C.flags_1 & HOLOGRAM_1))
				continue
			if(C.type in family)
				family[C.type] += 1
			else
				family[C.type] = 1
	file_data["family"] = family
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/pet/cat/runtime/proc/Deploy_The_Cats()
	cats_deployed = 1
	for(var/cat_type in family)
		if(family[cat_type] > 0)
			for(var/i in 1 to min(family[cat_type],100)) //Limits to about 500 cats, you wouldn't think this would be needed (BUT IT IS)
				new cat_type(loc)

/mob/living/simple_animal/pet/cat/_proc
	name = "Прок"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE


/mob/living/simple_animal/pet/cat/update_resting()
	. = ..()
	if(stat == DEAD)
		return
	if (resting)
		icon_state = "[icon_living]_rest"
		collar_type = "[initial(collar_type)]_rest"
	else
		icon_state = "[icon_living]"
		collar_type = "[initial(collar_type)]"
	regenerate_icons()


/mob/living/simple_animal/pet/cat/Life(delta_time = SSMOBS_DT, times_fired)
	if(!stat && !buckled && !client)
		if(DT_PROB(0.5, delta_time))
			manual_emote(pick("вытягивается и показывает свой животик.", "виляет хвостиком.", "ложится."))
			set_resting(TRUE)
			playsound(src, pick(meowlist), 50, TRUE)
		else if(DT_PROB(0.5, delta_time))
			manual_emote(pick("присаживается.", "присаживается на задние лапы.", "загадочно присаживается."))
			set_resting(TRUE)
			icon_state = "[icon_living]_sit"
			collar_type = "[initial(collar_type)]_sit"
			playsound(src, pick(meowlist), 25, TRUE)
		else if(DT_PROB(0.5, delta_time))
			if (resting)
				manual_emote(pick("встаёт и мяукает.", "ходит по кругу.", "встаёт."))
				set_resting(FALSE)
				playsound(src, pick(meowlist), 25, TRUE)
			else
				manual_emote(pick("прилизывается.", "дергает усами.", "отряхивается."))
				playsound(src, pick(meowlist), 40, TRUE)

	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in view(1,src))
				if(istype(M, /mob/living/simple_animal/mouse/brown/tom) && inept_hunter)
					if(COOLDOWN_FINISHED(src, emote_cooldown))
						visible_message(span_warning("[capitalize(src.name)] бежит за [M] безуспешно, теряя последнюю надежду!"))
						step(M, pick(GLOB.cardinals))
						COOLDOWN_START(src, emote_cooldown, 1 MINUTES)
					break
				if(!M.stat && Adjacent(M))
					manual_emote("давит [M]!")
					M.splat()
					movement_target = null
					stop_automated_movement = 0
					break
			for(var/obj/item/toy/cattoy/T in view(1,src))
				if (T.cooldown < (world.time - 400))
					manual_emote("шлёпает [T] своей лапой!")
					T.cooldown = world.time

	..()

	make_babies()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			SSmove_manager.stop_looping(src)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				SSmove_manager.move_to(src, movement_target, 0, 3)

/mob/living/simple_animal/pet/cat/jerry //Holy shit we left jerry on donut ~ Arcane ~Fikou
	name = "Джерри"
	desc = "Том очень ОЧЕНЬ изумлён."
	inept_hunter = TRUE
	gender = MALE

/mob/living/simple_animal/pet/cat/cak //I told you I'd do it, Remie
	name = "Keeki"
	desc = "Кот, который торт."
	icon_state = "cak"
	icon_living = "cak"
	icon_dead = "cak_dead"
	health = 50
	maxHealth = 50
	gender = FEMALE
	harm_intent_damage = 10
	butcher_results = list(/obj/item/organ/brain = 1, /obj/item/organ/heart = 1, /obj/item/food/cakeslice/birthday = 3,  \
	/obj/item/food/meat/slab = 2)
	response_harm_continuous = "откусывает кусочек"
	response_harm_simple = "откусывает кусочек"
	attacked_sound = 'sound/items/eatfood.ogg'
	death_message = "разваливается!"
	deathsound = "bodyfall"
	held_state = "cak"

/mob/living/simple_animal/pet/cat/cak/add_cell_sample()
	return

/mob/living/simple_animal/pet/cat/cak/CheckParts(list/parts)
	..()
	var/obj/item/organ/brain/B = locate(/obj/item/organ/brain) in contents
	if(!B || !B.brainmob || !B.brainmob.mind)
		return
	B.brainmob.mind.transfer_to(src)
	to_chat(src, "<span class='big bold'>You are a cak!</span><b> You're a harmless cat/cake hybrid that everyone loves. People can take bites out of you if they're hungry, but you regenerate health \
	so quickly that it generally doesn't matter. You're remarkably resilient to any damage besides this and it's hard for you to really die at all. You should go around and bring happiness and \
	free cake to the station!</b>")
	var/new_name = stripped_input(src, "Enter your name, or press \"Cancel\" to stick with Keeki.", "Name Change")
	if(new_name)
		to_chat(src, span_notice("Your name is now <b>\"new_name\"</b>!"))
		name = new_name

/mob/living/simple_animal/pet/cat/cak/Life(delta_time = SSMOBS_DT, times_fired)
	..()
	if(stat)
		return
	if(health < maxHealth)
		adjustBruteLoss(-4 * delta_time) //Fast life regen
	for(var/obj/item/food/donut/D in range(1, src)) //Frosts nearby donuts!
		if(!D.is_decorated)
			D.decorate_donut()

/mob/living/simple_animal/pet/cat/cak/attack_hand(mob/living/L)
	..()
	if(L.a_intent == INTENT_HARM && L.reagents && !stat)
		L.reagents.add_reagent(/datum/reagent/consumable/nutriment, 0.4)
		L.reagents.add_reagent(/datum/reagent/consumable/nutriment/vitamin, 0.4)
