//Dogs.

/mob/living/simple_animal/pet/dog
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "отталкивает"
	response_disarm_simple = "отталкивает"
	response_harm_continuous = "пинает"
	response_harm_simple = "пинает"
	speak = list("ТЯФ", "Вуф!", "Гав!", "АУУУУУУ!!!")
	speak_emote = list("гавкает", "вуфает")
	emote_hear = list("гавкает!", "вуфает!", "тявкает.","ластится.")
	emote_see = list("качает головой.", "гоняется за своим хвостом.","дрожит.")
	faction = list("neutral")
	see_in_dark = 5
	speak_chance = 1
	turns_per_move = 10
	can_be_held = TRUE
	pet_bonus = TRUE
	pet_bonus_emote = "woofs happily!"
	ai_controller = /datum/ai_controller/dog
	stop_automated_movement = TRUE
	///In the case 'melee_damage_upper' is somehow raised above 0
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/pet/dog/Initialize(mapload)
	. = ..()
	add_cell_sample()

//Corgis and pugs are now under one dog subtype

/mob/living/simple_animal/pet/dog/corgi
	name = "Корги"
	real_name = "Корги"
	desc = "Да это же корги."
	icon_state = "corgi"
	icon_living = "corgi"
	icon_dead = "corgi_dead"
	held_state = "corgi"
	butcher_results = list(/obj/item/food/meat/slab/corgi = 3, /obj/item/stack/sheet/animalhide/corgi = 1)
	childtype = list(/mob/living/simple_animal/pet/dog/corgi/puppy = 95, /mob/living/simple_animal/pet/dog/corgi/puppy/void = 5)
	animal_species = /mob/living/simple_animal/pet/dog
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "corgi"
	var/obj/item/inventory_head
	var/obj/item/inventory_back
	var/shaved = FALSE
	var/nofur = FALSE 		//Corgis that have risen past the material plane of existence.

/mob/living/simple_animal/pet/dog/corgi/add_cell_sample()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CORGI, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)

/mob/living/simple_animal/pet/dog/corgi/Destroy()
	QDEL_NULL(inventory_head)
	QDEL_NULL(inventory_back)
	return ..()

/mob/living/simple_animal/pet/dog/corgi/handle_atom_del(atom/A)
	if(A == inventory_head)
		inventory_head = null
		update_corgi_fluff()
		regenerate_icons()
	if(A == inventory_back)
		inventory_back = null
		update_corgi_fluff()
		regenerate_icons()
	return ..()


/mob/living/simple_animal/pet/dog/pug
	name = "Мопс"
	real_name = "Мопс"
	desc = "А это мопс."
	icon = 'icons/mob/pets.dmi'
	icon_state = "pug"
	icon_living = "pug"
	icon_dead = "pug_dead"
	butcher_results = list(/obj/item/food/meat/slab/pug = 3)
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "pug"
	held_state = "pug"

/mob/living/simple_animal/pet/dog/pug/add_cell_sample()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_PUG, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)

/mob/living/simple_animal/pet/dog/pug/mcgriff
	name = "МакГрифф"
	desc = "Эта собака может сказать, что здесь чем-то пахнет, и это что-то является ПРЕСТУПЛЕНИЕМ!"

/mob/living/simple_animal/pet/dog/dhund
	name = "Такса"
	real_name = "Такса"
	desc = "Это такса."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "dachshund"
	icon_living = "dachshund"
	icon_dead = "dachshund_dead"
	butcher_results = list(/obj/item/food/meat/slab/dach = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/shepherd
	name = "Овчарка"
	real_name = "Овчарка"
	desc = "Это овчарка."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "shepherd"
	icon_living = "shepherd"
	icon_dead = "shepherd_dead"
	butcher_results = list(/obj/item/food/meat/slab/shepherd = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/jack
	name = "Джек"
	real_name = "Джек рассел терьер"
	desc = "Это джек рассел терьер."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "jack"
	icon_living = "jack"
	icon_dead = "jack_dead"
	butcher_results = list(/obj/item/food/meat/slab/jack = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/pug/chi
	name = "Товарищ Чи"
	real_name = "Чихуахуа"
	desc = "Это чихуахуа"
	icon = 'white/pieceofcrap.dmi'
	icon_state = "chi"
	icon_living = "chi"
	icon_dead = "chi_dead"
	butcher_results = list(/obj/item/food/meat/slab/chi = 1)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/bullterrier
	name = "бультерьер"
	real_name = "бультерьер"
	desc = "Это бультерьер."
	icon = 'icons/mob/pets.dmi'
	icon_state = "bullterrier"
	icon_living = "bullterrier"
	icon_dead = "bullterrier_dead"
	butcher_results = list(/obj/item/food/meat/slab/corgi = 3) // Would feel redundant to add more new dog meats.
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "bullterrier"
	held_state = "bullterrier"

/mob/living/simple_animal/pet/dog/corgi/exoticcorgi
	name = "Экзотический корги"
	desc = "Как мило, так и красочно!"
	icon = 'icons/mob/pets.dmi'
	icon_state = "corgigrey"
	icon_living = "corgigrey"
	icon_dead = "corgigrey_dead"
	animal_species = /mob/living/simple_animal/pet/dog/corgi/exoticcorgi
	nofur = TRUE

/mob/living/simple_animal/pet/dog/Initialize(mapload)
	. = ..()
	var/dog_area = get_area(src)
	for(var/obj/structure/bed/dogbed/D in dog_area)
		if(D.update_owner(src)) //No muscling in on my turf you fucking parrot
			break

/mob/living/simple_animal/pet/dog/corgi/Initialize(mapload)
	. = ..()
	regenerate_icons()
	AddElement(/datum/element/strippable, GLOB.strippable_corgi_items)

/mob/living/simple_animal/pet/dog/corgi/exoticcorgi/Initialize(mapload)
		. = ..()
		var/newcolor = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
		add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)

/mob/living/simple_animal/pet/dog/corgi/death(gibbed)
	..(gibbed)
	regenerate_icons()

GLOBAL_LIST_INIT(strippable_corgi_items, create_strippable_list(list(
	/datum/strippable_item/corgi_head,
	/datum/strippable_item/corgi_back,
	/datum/strippable_item/corgi_collar,
	/datum/strippable_item/corgi_id,
)))

/datum/strippable_item/corgi_head
	key = STRIPPABLE_ITEM_HEAD

/datum/strippable_item/corgi_head/get_item(atom/source)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	return corgi_source.inventory_head

/datum/strippable_item/corgi_head/finish_equip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	corgi_source.place_on_head(equipping, user)

/datum/strippable_item/corgi_head/finish_unequip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return
	if(user)
		user.put_in_hands(corgi_source.inventory_head)
	else
		corgi_source.dropItemToGround(corgi_source.inventory_head)
	corgi_source.inventory_head = null
	corgi_source.update_corgi_fluff()
	corgi_source.regenerate_icons()

/datum/strippable_item/corgi_back
	key = STRIPPABLE_ITEM_BACK

/datum/strippable_item/corgi_back/get_item(atom/source)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	return corgi_source.inventory_back

/datum/strippable_item/corgi_back/try_equip(atom/source, obj/item/equipping, mob/user)
	. = ..()
	if (!.)
		return FALSE

	if (!ispath(equipping.dog_fashion, /datum/dog_fashion/back))
		to_chat(user, span_warning("You set [equipping] on [source]'s back, but it falls off!"))
		equipping.forceMove(source.drop_location())
		if (prob(25))
			step_rand(equipping)
		dance_rotate(source, set_original_dir = TRUE)

		return FALSE

	return TRUE

/datum/strippable_item/corgi_back/finish_equip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	equipping.forceMove(corgi_source)
	corgi_source.inventory_back = equipping
	corgi_source.update_corgi_fluff()
	corgi_source.regenerate_icons()

/datum/strippable_item/corgi_back/finish_unequip(atom/source, mob/user)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	user.put_in_hands(corgi_source.inventory_back)
	corgi_source.inventory_back = null
	corgi_source.update_corgi_fluff()
	corgi_source.regenerate_icons()

/datum/strippable_item/corgi_collar
	key = STRIPPABLE_ITEM_CORGI_COLLAR

/datum/strippable_item/corgi_collar/get_item(atom/source)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	return corgi_source.pcollar

/datum/strippable_item/corgi_collar/try_equip(atom/source, obj/item/equipping, mob/user)
	. = ..()
	if (!.)
		return FALSE

	if (!istype(equipping, /obj/item/clothing/neck/petcollar))
		to_chat(user, span_warning("That's not a collar."))
		return FALSE

	return TRUE

/datum/strippable_item/corgi_collar/finish_equip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	corgi_source.add_collar(equipping, user)
	corgi_source.update_corgi_fluff()

/datum/strippable_item/corgi_collar/finish_unequip(atom/source, mob/user)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	user.put_in_hands(corgi_source.pcollar)
	corgi_source.pcollar = null
	corgi_source.update_corgi_fluff()
	corgi_source.regenerate_icons()

/datum/strippable_item/corgi_id
	key = STRIPPABLE_ITEM_ID

/datum/strippable_item/corgi_id/get_item(atom/source)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	return corgi_source.access_card

/datum/strippable_item/corgi_id/try_equip(atom/source, obj/item/equipping, mob/user)
	. = ..()
	if (!.)
		return FALSE

	if (!istype(equipping, /obj/item/card/id))
		to_chat(user, span_warning("You can't pin [equipping] to [source]!"))
		return FALSE

	return TRUE

/datum/strippable_item/corgi_id/finish_equip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	equipping.forceMove(source)
	corgi_source.access_card = equipping

/datum/strippable_item/corgi_id/finish_unequip(atom/source, mob/user)
	var/mob/living/simple_animal/pet/dog/corgi/corgi_source = source
	if (!istype(corgi_source))
		return

	user.put_in_hands(corgi_source.access_card)
	corgi_source.access_card = null
	corgi_source.update_corgi_fluff()
	corgi_source.regenerate_icons()

/mob/living/simple_animal/pet/dog/corgi/getarmor(def_zone, type)
	var/armorval = 0

	if(def_zone)
		if(def_zone == BODY_ZONE_HEAD)
			if(inventory_head)
				armorval = inventory_head.armor.getRating(type)
		else
			if(inventory_back)
				armorval = inventory_back.armor.getRating(type)
		return armorval
	else
		if(inventory_head)
			armorval += inventory_head.armor.getRating(type)
		if(inventory_back)
			armorval += inventory_back.armor.getRating(type)
	return armorval*0.5

/mob/living/simple_animal/pet/dog/corgi/attackby(obj/item/O, mob/user, params)
	if (istype(O, /obj/item/razor))
		if (shaved)
			to_chat(user, span_warning("Этот корги уже побрит!"))
			return
		if (nofur)
			to_chat(user, span_warning("У этого корги нет шерсти!"))
			return
		user.visible_message(span_notice("[user] начинает брить [src] используя [O].") , span_notice("Начинаю брить [src] используя [O]..."))
		if(do_after(user, 50, target = src))
			user.visible_message(span_notice("[user] бреет [src] используя [O]."))
			playsound(loc, 'sound/items/welder2.ogg', 20, TRUE)
			shaved = TRUE
			icon_living = "[initial(icon_living)]_shaved"
			icon_dead = "[initial(icon_living)]_shaved_dead"
			if(stat == CONSCIOUS)
				icon_state = icon_living
			else
				icon_state = icon_dead
		return
	..()
	update_corgi_fluff()

//Corgis are supposed to be simpler, so only a select few objects can actually be put
//to be compatible with them. The objects are below.
//Many  hats added, Some will probably be removed, just want to see which ones are popular.
// > some will probably be removed

/mob/living/simple_animal/pet/dog/corgi/proc/place_on_head(obj/item/item_to_add, mob/user)
	if(inventory_head)
		if(user)
			to_chat(user, span_warning("Не могу посадить больше одной на [src]!"))
		return
	if(!item_to_add)
		user.visible_message(span_notice("[user] гладит [src].") , span_notice("Держу свою руку на голове [src]. Да?"))
		if(flags_1 & HOLOGRAM_1)
			return
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, src, /datum/mood_event/pet_animal, src)
		return

	if(user && !user.temporarilyRemoveItemFromInventory(item_to_add))
		to_chat(user, span_warning("[capitalize(item_to_add)] застрял в моей руке, у меня не получится положить его на голову [src]!"))
		return

	var/valid = FALSE
	if(ispath(item_to_add.dog_fashion, /datum/dog_fashion/head))
		valid = TRUE

	//Various hats and items (worn on his head) change Ian's behaviour. His attributes are reset when a hat is removed.

	if(valid)
		if(health <= 0)
			to_chat(user, span_notice("Просто скучный, безжизненный взгляд виден в глазах [real_name] пока я пытаюсь напялить [item_to_add] на н[ru_ego()]."))
		else if(user)
			user.visible_message(span_notice("[user] надевает [item_to_add] на голову [real_name]. [src] смотрит на [user] и гавкает радостно.") ,
				span_notice("Надеваю [item_to_add] на голову [real_name]. [src] смотрит на меня своеобразно, затем [ru_who()] подвиливает хвостиком и гавкает радостно.") ,
				span_hear("Слышу дружественно звучащий лай."))
		item_to_add.forceMove(src)
		src.inventory_head = item_to_add
		update_corgi_fluff()
		regenerate_icons()
	else
		to_chat(user, span_warning("Надеваю [item_to_add] на голову [src], но оно спадает!"))
		item_to_add.forceMove(drop_location())
		if(prob(25))
			step_rand(item_to_add)
		dance_rotate(src, set_original_dir=TRUE)

	return valid

/mob/living/simple_animal/pet/dog/corgi/proc/update_corgi_fluff()
	// First, change back to defaults
	name = real_name
	desc = initial(desc)
	// BYOND/DM doesn't support the use of initial on lists.
	speak = list("ЯП", "Вуф!", "Гав!", "АУУУУУУ")
	speak_emote = list("гавкает", "вуфает")
	emote_hear = list("гавкает!", "вуфает!", "тявкает.","ластится.")
	emote_see = list("мотает головой.", "бегает за своим хвостом.","дрожит.")
	desc = initial(desc)
	set_light(0)

	if(inventory_head?.dog_fashion)
		var/datum/dog_fashion/DF = new inventory_head.dog_fashion(src)
		DF.apply(src)

	if(inventory_back?.dog_fashion)
		var/datum/dog_fashion/DF = new inventory_back.dog_fashion(src)
		DF.apply(src)

//IAN! SQUEEEEEEEEE~
/mob/living/simple_animal/pet/dog/corgi/ian
	name = "Ян"
	real_name = "Ян"	//Intended to hold the name without altering it.
	gender = MALE
	desc = "Любимый корги главы персонала."
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "толкает"
	response_disarm_simple = "толкает"
	response_harm_continuous = "пинает"
	response_harm_simple = "пинает"
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/age = 0
	var/record_age = 1
	var/memory_saved = FALSE
	var/saved_head //path

/mob/living/simple_animal/pet/dog/corgi/ian/Initialize(mapload)
	. = ..()
	//parent call must happen first to ensure IAN
	//is not in nullspace when child puppies spawn
	Read_Memory()
	if(age == 0)
		var/turf/target = get_turf(loc)
		if(target)
			var/mob/living/simple_animal/pet/dog/corgi/puppy/P = new /mob/living/simple_animal/pet/dog/corgi/puppy(target)
			P.name = "Ян"
			P.real_name = "Ян"
			P.gender = MALE
			P.desc = "Любимый щенок корги главы персонала."
			Write_Memory(FALSE)
			return INITIALIZE_HINT_QDEL
	else if(age == record_age)
		icon_state = "old_corgi"
		icon_living = "old_corgi"
		held_state = "old_corgi"
		icon_dead = "old_corgi_dead"
		desc = "В зрелом возрасте [record_age], Ян не такой бодрый, как раньше, но он всегда будет любимым корги главы персонала." //RIP
		turns_per_move = 20

/mob/living/simple_animal/pet/dog/corgi/ian/Life(delta_time = SSMOBS_DT, times_fired)
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory(FALSE)
		memory_saved = TRUE
	..()

/mob/living/simple_animal/pet/dog/corgi/ian/death()
	if(!memory_saved)
		Write_Memory(TRUE)
	..()

/mob/living/simple_animal/pet/dog/corgi/ian/proc/Read_Memory()
	if(fexists("data/npc_saves/Ian.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Ian.sav")
		S["age"] 		>> age
		S["record_age"]	>> record_age
		S["saved_head"] >> saved_head
		fdel("data/npc_saves/Ian.sav")
	else
		var/json_file = file("data/npc_saves/Ian.json")
		if(!fexists(json_file))
			return
		var/list/json = r_json_decode(file2text(json_file))
		age = json["age"]
		record_age = json["record_age"]
		saved_head = json["saved_head"]
	if(isnull(age))
		age = 0
	if(isnull(record_age))
		record_age = 1
	if(saved_head)
		place_on_head(new saved_head)

/mob/living/simple_animal/pet/dog/corgi/ian/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Ian.json")
	var/list/file_data = list()
	if(!dead)
		file_data["age"] = age + 1
		if((age + 1) > record_age)
			file_data["record_age"] = record_age + 1
		else
			file_data["record_age"] = record_age
		if(inventory_head)
			file_data["saved_head"] = inventory_head.type
		else
			file_data["saved_head"] = null
	else
		file_data["age"] = 0
		file_data["record_age"] = record_age
		file_data["saved_head"] = null
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/pet/dog/corgi/ian/narsie_act()
	playsound(src, 'sound/magic/demon_dies.ogg', 75, TRUE)
	var/mob/living/simple_animal/pet/dog/corgi/narsie/N = new(loc)
	N.setDir(dir)
	gib()

/mob/living/simple_animal/pet/dog/corgi/narsie
	name = "Нарс-Ян"
	desc = "Ия! Ия!"
	icon_state = "narsian"
	icon_living = "narsian"
	icon_dead = "narsian_dead"
	faction = list("neutral", "cult")
	gold_core_spawnable = NO_SPAWN
	nofur = TRUE
	unique_pet = TRUE
	held_state = "narsian"

/mob/living/simple_animal/pet/dog/corgi/narsie/Life(delta_time = SSMOBS_DT, times_fired)
	..()
	for(var/mob/living/simple_animal/pet/P in range(1, src))
		if(P != src && !istype(P,/mob/living/simple_animal/pet/dog/corgi/narsie))
			visible_message(span_warning("[capitalize(src.name)] пожирает [P]!") , \
			"<span class='cult big bold'>ВКУСНЫЕ ДУШИ</span>")
			playsound(src, 'sound/magic/demon_attack1.ogg', 75, TRUE)
			narsie_act()
			P.gib()

/mob/living/simple_animal/pet/dog/corgi/narsie/update_corgi_fluff()
	..()
	speak = list("Тари'карат-паснар!", "Ия! Ия!", "БРУБУХБУБХУХ")
	speak_emote = list("воет", "зловеще лает")
	emote_hear = list("лает эхом!", "вуфает навязчиво!", "тявкает сверхъестественный образом.", "бормочет что-то невыразимое.")
	emote_see = list("общается с неназванным.", "обдумывает пожирание некоторых душ.", "шатается.")

/mob/living/simple_animal/pet/dog/corgi/narsie/narsie_act()
	adjustBruteLoss(-maxHealth)


/mob/living/simple_animal/pet/dog/corgi/regenerate_icons()
	..()
	if(inventory_head)
		var/image/head_icon
		var/datum/dog_fashion/DF = new inventory_head.dog_fashion(src)

		if(!DF.obj_icon_state)
			DF.obj_icon_state = inventory_head.icon_state
		if(!DF.obj_alpha)
			DF.obj_alpha = inventory_head.alpha
		if(!DF.obj_color)
			DF.obj_color = inventory_head.color

		if(health <= 0)
			head_icon = DF.get_overlay(dir = EAST)
			head_icon.pixel_y = -8
			head_icon.transform = turn(head_icon.transform, 180)
		else
			head_icon = DF.get_overlay()

		add_overlay(head_icon)

	if(inventory_back)
		var/image/back_icon
		var/datum/dog_fashion/DF = new inventory_back.dog_fashion(src)

		if(!DF.obj_icon_state)
			DF.obj_icon_state = inventory_back.icon_state
		if(!DF.obj_alpha)
			DF.obj_alpha = inventory_back.alpha
		if(!DF.obj_color)
			DF.obj_color = inventory_back.color

		if(health <= 0)
			back_icon = DF.get_overlay(dir = EAST)
			back_icon.pixel_y = -11
			back_icon.transform = turn(back_icon.transform, 180)
		else
			back_icon = DF.get_overlay()
		add_overlay(back_icon)

	return



/mob/living/simple_animal/pet/dog/corgi/puppy
	name = "Щенок корги"
	real_name = "Корги"
	desc = "Это же щеночек корги!"
	icon_state = "puppy"
	icon_living = "puppy"
	icon_dead = "puppy_dead"
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL
	collar_type = "puppy"

//puppies cannot wear anything.
/mob/living/simple_animal/pet/dog/corgi/puppy/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, span_warning("Не могу надеть это на [src]!"))
		return
	..()

//PUPPY IAN! SQUEEEEEEEEE~
/mob/living/simple_animal/pet/dog/corgi/puppy/ian
	name = "Ian"
	real_name = "Ian"
	gender = MALE
	desc = "It's the HoP's beloved corgi puppy."


/mob/living/simple_animal/pet/dog/corgi/puppy/void		//Tribute to the corgis born in nullspace
	name = "Пустотный щеник"
	real_name = "Пустота"
	desc = "Щенок корги, наполненный энергией дальнего космоса..."
	icon_state = "void_puppy"
	icon_living = "void_puppy"
	icon_dead = "void_puppy_dead"
	nofur = TRUE
	unsuitable_atmos_damage = 0
	minbodytemp = TCMB
	maxbodytemp = T0C + 40
	held_state = "void_puppy"

/mob/living/simple_animal/pet/dog/corgi/puppy/void/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_AI_BAGATTACK, INNATE_TRAIT)

/mob/living/simple_animal/pet/dog/corgi/puppy/void/Process_Spacemove(direction = 0, continuous_move = FALSE)
	return 1	//Void puppies can navigate space.


//LISA! SQUEEEEEEEEE~
/mob/living/simple_animal/pet/dog/corgi/lisa
	name = "Лиза"
	real_name = "Лиза"
	gender = FEMALE
	desc = "Она разорвёт тебя на части."
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	icon_state = "lisa"
	icon_living = "lisa"
	icon_dead = "lisa_dead"
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "толкает"
	response_disarm_simple = "толкает"
	response_harm_continuous = "пинает"
	response_harm_simple = "пинает"
	held_state = "lisa"
	var/puppies = 0

//Lisa already has a cute bow!
/mob/living/simple_animal/pet/dog/corgi/lisa/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, span_warning("[capitalize(src.name)] уже имеет милый вид!"))
		return
	..()

/mob/living/simple_animal/pet/dog/corgi/lisa/Life(delta_time = SSMOBS_DT, times_fired)
	. = ..()
	make_babies()
