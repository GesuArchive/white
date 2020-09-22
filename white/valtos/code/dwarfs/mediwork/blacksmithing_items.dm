/obj/item/blacksmith
	name = "штука"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "iron_ingot"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/blacksmith/smithing_hammer
	name = "молот"
	desc = "Используется для ковки. По идее."
	icon_state = "molotochek"
	w_class = WEIGHT_CLASS_HUGE
	force = 20
	throwforce = 25
	throw_range = 4

/obj/item/blacksmith/smithing_hammer/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=20, force_wielded=20)

/obj/item/blacksmith/smithing_hammer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()

	if(iswallturf(target) && proximity_flag)
		var/turf/closed/wall/W = target
		var/chance = (W.hardness * 0.5)
		if(chance < 10)
			return FALSE

		if(prob(chance))
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			W.dismantle_wall(TRUE)

		else
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			W.add_dent(WALL_DENT_HIT)
			visible_message("<span class='danger'><b>[user]</b> бьёт молотом по <b>стене</b>!</span>", null, COMBAT_MESSAGE_RANGE)
	return TRUE

/obj/item/blacksmith/anvil_free
	name = "наковальня"
	desc = "На ней неудобно ковать. Стоит поставить её на что-то крепкое."
	icon_state = "anvil_free"
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 20
	throw_range = 2

/obj/item/blacksmith/anvil_free/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=10, force_wielded=10)

/obj/item/blacksmith/srub
	name = "полено"
	desc = "Достаточно крепкое, чтобы удерживать на себе наковальню."
	icon_state = "srub"
	w_class = WEIGHT_CLASS_HUGE
	force = 7
	throwforce = 10
	throw_range = 3
	custom_materials = null

/obj/item/blacksmith/srub/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=7, force_wielded=7)

/obj/item/blacksmith/chisel
	name = "стамеска"
	desc = "Для обработки различных поверхностей."
	icon_state = "chisel"
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_SMALL
	force = 10
	throwforce = 12
	throw_range = 7

/obj/item/blacksmith/tongs
	name = "клещи"
	desc = "Для ковки. Не для анальных утех."
	icon_state = "tongs"
	w_class = WEIGHT_CLASS_SMALL
	force = 4
	throwforce = 6
	throw_range = 7

/obj/item/blacksmith/tongs/attack(mob/living/carbon/C, mob/user)
	if(tearoutteeth(C, user))
		return FALSE
	else
		..()

/obj/item/blacksmith/tongs/attack_self(mob/user)
	. = ..()
	if(contents.len)
		if(istype(contents[contents.len], /obj/item/blacksmith/ingot))
			var/obj/item/blacksmith/ingot/N = contents[contents.len]
			if(N.progress_current == N.progress_need + 1)
				for(var/i in 1 to rand(1, N.recipe.max_resulting))
					var/obj/item/O = new N.recipe.result(drop_location())
					if(istype(O, /obj/item/blacksmith))
						O.force = round((O.force / 1.25) * N.mod_grade)
					if(istype(O, /obj/item/pickaxe))
						O.force = round((O.force / 2) * N.mod_grade)
						O.toolspeed = round(1 / N.mod_grade, 0.1)
					if(istype(O, /obj/item/clothing))
						O.armor = O.armor.modifyAllRatings(5 * N.mod_grade)
					switch(N.mod_grade)
						if(5 to INFINITY)
							O.name = "☼[O.name]☼"
						if(4)
							O.name = "≡[O.name]≡"
						if(3)
							O.name = "+[O.name]+"
						if(2)
							O.name = "-[O.name]-"
						if(1)
							O.name = "*[O.name]*"
				qdel(N)
				LAZYCLEARLIST(contents)
				playsound(src, 'white/valtos/sounds/vaper.ogg', 100)
			else
				N.forceMove(drop_location())
		icon_state = "tongs"

/obj/item/blacksmith/ingot
	name = "железный слиток"
	desc = "Из него можно сделать что-то."
	icon_state = "iron_ingot"
	w_class = WEIGHT_CLASS_NORMAL
	force = 2
	throwforce = 5
	throw_range = 7
	var/datum/smithing_recipe/recipe = null
	var/mod_grade = 1
	var/durability = 5
	var/progress_current = 0
	var/progress_need = 10
	var/heattemp = 0
	var/type_metal = "iron"

/obj/item/blacksmith/ingot/gold
	name = "золотой слиток"
	icon_state = "gold_ingot"
	type_metal = "gold"

/obj/item/blacksmith/ingot/examine(mob/user)
	. = ..()
	var/ct = ""
	switch(heattemp)
		if(200 to INFINITY)
			ct = "раскалена до бела"
		if(100 to 199)
			ct = "очень горячая"
		if(1 to 99)
			ct = "достаточно тёплая"
		else
			ct = "холодная"

	. += "Болванка [ct]."

/obj/item/blacksmith/ingot/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/blacksmith/ingot/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/blacksmith/ingot/process()
	if(heattemp >= 25)
		heattemp -= 25
		if(!overlays.len)
			add_overlay("ingot_hot")
	else if(overlays.len)
		cut_overlays()


/obj/item/blacksmith/ingot/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/blacksmith/tongs))
		if(I.contents.len)
			to_chat(user, "<span class='warning'>Некуда!</span>")
			return
		else
			src.forceMove(I)
			if(heattemp > 0)
				I.icon_state = "tongs_hot"
			else
				I.icon_state = "tongs_cold"
			to_chat(user, "<span class='notice'>Беру слиток клещами.</span>")
			return

/obj/item/raw_stone
	name = "камень"
	desc = "Олдфаг."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "stone"
	w_class = WEIGHT_CLASS_TINY
	force = 3
	throwforce = 7
	throw_range = 14

/obj/item/raw_stone/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/blacksmith/chisel) && isstrictlytype(src, /obj/item/raw_stone))
		playsound(src, 'white/valtos/sounds/tough.wav', 100, TRUE)
		if(prob(25))
			to_chat(user, "<span class='warning'>Обрабатываю камень.</span>")
			return
		new /obj/item/raw_stone/block(drop_location())
		to_chat(user, "<span class='notice'>Обрабатываю камень.</span>")
		qdel(src)
		return

/obj/item/raw_stone/block
	name = "кирпич"
	desc = "\"Кастрат\" - могли бы сказать Вы, если бы он не вырубил Вас одним попаданием."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "block"
	w_class = WEIGHT_CLASS_TINY
	force = 10
	throwforce = 20
	throw_range = 12
	var/block_count = 1

/obj/item/raw_stone/block/examine()
	. = ..()
	. += "<hr><span class='notice'>Всего тут [block_count] кирпичных единиц.</span>"

/obj/item/raw_stone/block/update_icon()
	. = ..()
	switch(block_count)
		if(1)
			icon_state = "block"
		if(2)
			icon_state = "block_2"
		if(3 to INFINITY)
			icon_state = "block_more"

/obj/item/raw_stone/block/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/raw_stone/block))
		var/obj/item/raw_stone/block/B = I
		if((block_count + B.block_count) > 5)
			to_chat(user, "<span class='warning'>СЛИШКОМ МНОГО КИРПИЧЕЙ!</span>")
			return
		block_count += B.block_count
		to_chat(user, "<span class='notice'>Теперь в куче [block_count] кирпичных единиц.</span>")
		update_icon()
		qdel(I)
		return

/obj/item/raw_stone/block/attack_self(mob/user)
	. = ..()

	if(block_count > 1)
		new /obj/item/raw_stone/block(drop_location())
		block_count--
		to_chat(user, "<span class='notice'>Аккуратно вытаскиваю один кирпичик из кучи.</span>")
		update_icon()
		return

/obj/item/blacksmith/katanus
	name = "катанус"
	desc = "Не путать с катаной."
	icon_state = "katanus"
	inhand_icon_state = "katanus"
	worn_icon_state = "katanus"
	worn_icon = 'white/valtos/icons/back.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	force = 16
	throwforce = 10
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	block_chance = 25
	sharpness = SHARP_EDGED
	max_integrity = 50
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/blacksmith/zwei
	name = "цвай"
	desc = "Таким можно рубить деревья."
	icon_state = "zwei"
	inhand_icon_state = "zwei"
	worn_icon_state = "katanus"
	lefthand_file = 'white/valtos/icons/96x96_lefthand.dmi'
	righthand_file = 'white/valtos/icons/96x96_righthand.dmi'
	inhand_x_dimension = -32
	flags_1 = CONDUCT_1
	force = 40
	throwforce = 15
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	block_chance = 5
	sharpness = SHARP_EDGED
	max_integrity = 150
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	reach = 2
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/blacksmith/zwei/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/zwei/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(5)

/obj/item/blacksmith/cep
	name = "цеп"
	desc = "Хрустим - не тормозим!"
	icon_state = "cep"
	inhand_icon_state = "cep"
	worn_icon_state = "cep"
	flags_1 = CONDUCT_1
	force = 20
	throwforce = 15
	w_class = WEIGHT_CLASS_HUGE
	//hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("захуяривает")
	block_chance = 10
	max_integrity = 50
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/blacksmith/cep/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(3)

/obj/item/blacksmith/dagger
	name = "кинжал"
	desc = "Быстрый, лёгкий и довольный острый."
	icon_state = "dagger"
	inhand_icon_state = "dagger"
	worn_icon_state = "dagger"
	flags_1 = CONDUCT_1
	force = 5
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	block_chance = 15
	sharpness = SHARP_EDGED
	max_integrity = 20
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/blacksmith/dagger/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(CLICK_CD_RAPID)

/obj/item/clothing/suit/armor/light_plate
	name = "нагрудная пластина"
	desc = "Защищает только грудь, плохо останавливает пули."
	body_parts_covered = CHEST|GROIN
	icon_state = "light_plate"
	inhand_icon_state = "light_plate"
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	armor = list("melee" = 55, "bullet" = 20, "laser" = 20, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "wound" = 35)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/suit/armor/heavy_plate
	name = "латный доспех"
	desc = "Останавливает иногда и пули. Замедляет скорость передвижения."
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	w_class = WEIGHT_CLASS_GIGANTIC
	slowdown = 1
	icon_state = "heavy_plate"
	inhand_icon_state = "heavy_plate"
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	armor = list("melee" = 85, "bullet" = 60, "laser" = 40, "energy" = 10, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 20, "wound" = 65)
	custom_materials = list(/datum/material/iron = 10000)
	var/footstep = 1
	var/mob/listeningTo
	var/list/random_step_sound = list('white/valtos/sounds/armorstep/heavystep1.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep2.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep3.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep4.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep5.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep6.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep7.ogg'=1)

/obj/item/clothing/suit/armor/heavy_plate/proc/on_mob_move()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.wear_suit != src)
		return
	if(footstep > 2)
		playsound(src, pick(random_step_sound), 100, TRUE)
		footstep = 0
	else
		footstep++

/obj/item/clothing/suit/armor/heavy_plate/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_OCLOTHING)
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		return
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/on_mob_move)
	listeningTo = user

/obj/item/clothing/suit/armor/heavy_plate/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)

/obj/item/clothing/suit/armor/heavy_plate/Destroy()
	listeningTo = null
	return ..()

/obj/item/clothing/under/chainmail
	name = "кольчуга"
	desc = "Неплохо защищает от всех видов колющего и режущего оружия. Немного стесняет движения."
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "chainmail"
	inhand_icon_state = "chainmail"
	armor = list("melee" = 35, "bullet" = 15, "laser" = 0, "energy" = 0, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0, "wound" = 55)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/head/helmet/plate_helmet
	name = "железный шлем"
	desc = "Спасёт голову от внезапного удара по ней."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "plate_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	armor = list("melee" = 75, "bullet" = 35, "laser" = 10,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5, "wound" = 55)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/gloves/plate_gloves
	name = "железные перчатки"
	desc = "Уберегут ваши руки от внезапных потерь."
	worn_icon = 'white/valtos/icons/clothing/mob/glove.dmi'
	icon = 'white/valtos/icons/clothing/gloves.dmi'
	icon_state = "plate_gloves"
	armor = list("melee" = 65, "bullet" = 30, "laser" = 5,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 25, "wound" = 55)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/shoes/jackboots/plate_boots
	name = "железные сапоги"
	desc = "Спасут ваши ноги от внезапных переломов и других страшных штук."
	worn_icon = 'white/valtos/icons/clothing/mob/shoe.dmi'
	icon = 'white/valtos/icons/clothing/shoes.dmi'
	icon_state = "plate_boots"
	armor = list("melee" = 75, "bullet" = 35, "laser" = 10,"energy" = 0, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15, "wound" = 55)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/blacksmith/gun_parts
	name = "запчасть"
	desc = "Для оружия какого-нибудь. Да?"

/obj/item/blacksmith/gun_parts/kar98k
	name = "основа Kar98k"
	desc = "Используется для создания винтовки Kar98k. Похоже, здесь не хватает дерева."
	icon_state = "kar98k-part"

/obj/item/blacksmith/gun_parts/kar98k/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/S = I
		if(S.amount >= 5)
			S.use(5)
			to_chat(user, "<span class='notice'>Создаю винтовку.</span>")
			new /obj/item/gun/ballistic/rifle/boltaction/wzzzz/kar98k(get_turf(src))
			qdel(src)
			return
		else
			to_chat(user, "<span class='warning'>Требуется пять единиц досок!</span>")
			return

/obj/structure/mineral_door/heavystone
	name = "тяжёлая каменная дверь"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "heavystone"
	max_integrity = 600
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)

/obj/item/clothing/head/helmet/dwarf_crown
	name = "золотая корона"
	desc = "Материал указывает на то, что её носитель имеет какой-то важный статус."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "dwarf_king"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5, "wound" = 15)
	custom_materials = list(/datum/material/gold = 10000)
	var/mob/assigned_count = null

/datum/action/item_action/send_message_action
	name = "Отправить сообщение подданым"

/obj/item/clothing/head/helmet/dwarf_crown/proc/send_message(mob/user, msg)
	message_admins("DF: [ADMIN_LOOKUPFLW(user)]: [msg]")
	for(var/mob/M in GLOB.dwarf_list)
		to_chat(M, "<span class='revenbignotice'>[msg]</span>")

/obj/item/clothing/head/helmet/dwarf_crown/attack_self(mob/user)
	. = ..()
	if(is_species(user, /datum/species/dwarf) && !assigned_count)
		assigned_count = user
		send_message("Волей Армока <b>[user]</b> был выбран как наш новый Граф! Ура!")
		actions_types = list(/datum/action/item_action/send_message_action)
		var/obj/item/SC = new /obj/item/blacksmith/scepter(get_turf(src))
		user.put_in_hands(SC)
	if(assigned_count == user)
		var/msg = input(user, "Что же мы скажем?", "Сообщение:")
		if(!msg)
			return
		user.whisper("[msg]")
		send_message("<b>[user]</b>: [pointization(msg)]")
	else
		to_chat(user, "<span class='warning'>У МЕНЯ ЗДЕСЬ НЕТ ВЛАСТИ!</span>")

/obj/item/blacksmith/torch_handle
	name = "скоба"
	desc = "Её можно установить на стену."
	icon_state = "torch_handle"
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron = 10000)
	var/result_path = /obj/machinery/torch_fixture

/obj/item/blacksmith/torch_handle/proc/try_build(turf/on_wall, mob/user)
	if(get_dist(on_wall, user)>1)
		return
	var/ndir = get_dir(on_wall, user)
	if(!(ndir in GLOB.cardinals))
		return
	var/turf/T = get_turf(user)
	if(!isfloorturf(T))
		to_chat(user, "<span class='warning'>Пол не подходит для установки держателя!</span>")
		return
	if(locate(/obj/machinery/torch_fixture) in view(1))
		to_chat(user, "<span class='warning'>Здесь уже что-то есть на стене!</span>")
		return

	return TRUE

/obj/item/blacksmith/torch_handle/proc/attach(turf/on_wall, mob/user)
	if(result_path)
		playsound(src.loc, 'sound/machines/click.ogg', 75, TRUE)
		user.visible_message("<span class='notice'>[user.name] прикрепляет скобу к стене.</span>",
			"<span class='notice'>Прикрепляю скобу к стене.</span>",
			"<span class='hear'>Слышу щелчки.</span>")
		var/ndir = get_dir(on_wall, user)

		new result_path(get_turf(user), ndir, TRUE)
	qdel(src)

/obj/machinery/torch_fixture
	name = "скоба"
	desc = "Держит факел. Да."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "torch_handle_wall"
	layer = BELOW_MOB_LAYER
	max_integrity = 100
	use_power = NO_POWER_USE
	var/light_type = /obj/item/flashlight/flare/torch
	var/status = LIGHT_EMPTY
	var/fuel = 0
	var/on = FALSE

/obj/machinery/torch_fixture/Initialize(mapload, ndir)
	if(on)
		fuel = 5000
		status = LIGHT_OK
		recalculate_light()
	dir = ndir
	switch(dir)
		if(WEST)	pixel_x = -32
		if(EAST)	pixel_x = 32
		if(NORTH)	pixel_y = 32
	. = ..()

/obj/machinery/torch_fixture/process(delta_time)
	if(on)
		fuel = max(fuel -= delta_time, 0)
		recalculate_light()

/obj/machinery/torch_fixture/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/machinery/torch_fixture/proc/recalculate_light()
	if(status == LIGHT_EMPTY)
		set_light(0, 0, LIGHT_COLOR_ORANGE)
		cut_overlays()
		on = FALSE
		return
	if(on)
		var/mutable_appearance/torch_underlay = mutable_appearance(icon, "torch_handle_overlay_on", HIGH_OBJ_LAYER)
		cut_overlays()
		add_overlay(torch_underlay)
	else if(fuel)
		var/mutable_appearance/torch_underlay = mutable_appearance(icon, "torch_handle_overlay_off", HIGH_OBJ_LAYER)
		cut_overlays()
		add_overlay(torch_underlay)
		return
	else
		var/mutable_appearance/torch_underlay = mutable_appearance(icon, "torch_handle_overlay_burned", HIGH_OBJ_LAYER)
		cut_overlays()
		add_overlay(torch_underlay)
		return
	switch(fuel)
		if(-INFINITY to 0)
			set_light(0, 0, LIGHT_COLOR_ORANGE)
			var/mutable_appearance/torch_underlay = mutable_appearance(icon, "torch_handle_overlay_burned", HIGH_OBJ_LAYER)
			cut_overlays()
			add_overlay(torch_underlay)
			on = FALSE
		if(1 to 1000)
			set_light(4, 1, LIGHT_COLOR_ORANGE)
		if(1001 to 2000)
			set_light(6, 1, LIGHT_COLOR_ORANGE)
		if(2001 to INFINITY)
			set_light(9, 1, LIGHT_COLOR_ORANGE)

/obj/machinery/torch_fixture/attackby(obj/item/W, mob/living/user, params)

	if(istype(W, /obj/item/flashlight/flare/torch))
		if(status == LIGHT_OK)
			to_chat(user, "<span class='warning'>Здесь уже есть факел!</span>")
		else
			src.add_fingerprint(user)
			var/obj/item/flashlight/flare/torch/L = W
			if(istype(L, light_type))
				if(!user.temporarilyRemoveItemFromInventory(L))
					return
				src.add_fingerprint(user)
				to_chat(user, "<span class='notice'>Ставлю [L] на место.</span>")
				status = LIGHT_OK
				fuel = L.fuel
				on = L.on
				recalculate_light()
				qdel(L)
				START_PROCESSING(SSobj, src)
			else
				to_chat(user, "<span class='warning'>Эта штука поддерживает только обычные факелы!</span>")
	else
		return ..()

/obj/machinery/torch_fixture/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		to_chat(user, "<span class='warning'>Здесь нет факела!</span>")
		return

	var/obj/item/flashlight/flare/torch/L = new light_type()

	L.on = on
	L.fuel = fuel
	L.forceMove(loc)
	L.update_brightness()

	if(user)
		L.add_fingerprint(user)
		user.put_in_active_hand(L)

	status = LIGHT_EMPTY
	STOP_PROCESSING(SSobj, src)
	recalculate_light()
	return

#define SHPATEL_BUILD_FLOOR 1
#define SHPATEL_BUILD_WALL 2

/obj/item/blacksmith/shpatel
	name = "мастерок"
	desc = "Передовое устройство для строительства большинства объектов."
	icon_state = "shpatel"
	w_class = WEIGHT_CLASS_SMALL
	force = 8
	throwforce = 12
	throw_range = 3
	var/mode = SHPATEL_BUILD_FLOOR

/obj/item/blacksmith/shpatel/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	do_job(A, user)

/obj/item/blacksmith/shpatel/proc/check_resources()
	var/mat_to = 0
	var/mat_need = 0
	for(var/obj/item/raw_stone/block/B in view(1))
		mat_to += B.block_count
	switch(mode)
		if(SHPATEL_BUILD_WALL) mat_need = 4
		if(SHPATEL_BUILD_FLOOR) mat_need = 1
	if(mat_to >= mat_need)
		return TRUE
	else
		return FALSE

/obj/item/blacksmith/shpatel/proc/use_resources(var/turf/open/floor/grass/gensgrass/dirty/T, mob/user)
	switch(mode)
		if(SHPATEL_BUILD_WALL)
			var/list/blocks = list()
			var/total_count = 0
			for(var/obj/item/raw_stone/block/B in view(1))
				blocks += B
				total_count += B.block_count
				if(total_count >= 4)
					break
			QDEL_LIST(blocks)
			T.ChangeTurf(/turf/closed/wall/stonewall, flags = CHANGETURF_IGNORE_AIR)
			user.visible_message("<span class='notice'><b>[user]</b> возводит каменную стену.</span>", \
								"<span class='notice'>Возвожу каменную стену.</span>")
		if(SHPATEL_BUILD_FLOOR)
			if(!T.stoned)
				var/list/blocks = list()
				var/total_count = 0
				for(var/obj/item/raw_stone/block/B in view(1))
					blocks += B
					total_count += B.block_count
					if(total_count >= 1)
						break
				QDEL_LIST(blocks)
				T.stoned = TRUE
				T.ChangeTurf(/turf/open/floor/grass/gensgrass/dirty/stone, flags = CHANGETURF_INHERIT_AIR)
				user.visible_message("<span class='notice'><b>[user]</b> создаёт каменный пол.</span>", \
									"<span class='notice'>Делаю каменный пол.</span>")

/obj/item/blacksmith/shpatel/proc/do_job(atom/A, mob/user)
	if(!istype(A, /turf/open/floor/grass/gensgrass/dirty))
		return
	var/turf/T = get_turf(A)
	if(check_resources())
		if(do_after(user, 5 SECONDS, target = A))
			if(check_resources())
				use_resources(T, user)
				playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
				return TRUE
	else
		to_chat(user, "<span class='warning'>Не хватает материалов!</span>")

/obj/item/blacksmith/shpatel/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/blacksmith/shpatel/attack_self(mob/user)
	..()
	var/list/choices = list(
		"Пол" = image(icon = 'white/valtos/icons/gensokyo/turfs.dmi', icon_state = "stone_floor"),
		"Стена" = image(icon = 'white/valtos/icons/stonewall.dmi', icon_state = "wallthefuck")
	)
	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Пол")
			mode = SHPATEL_BUILD_FLOOR
		if("Стена")
			mode = SHPATEL_BUILD_WALL

/obj/item/blacksmith/scepter
	name = "скипетр власти"
	desc = "Выглядит солидно? Ну так положи туда, откуда взял, а то ещё поцарапаешь..."
	icon_state = "scepter"
	w_class = WEIGHT_CLASS_SMALL
	force = 9
	throwforce = 4
	throw_range = 5
	custom_materials = list(/datum/material/gold = 10000)
	var/mode = SHPATEL_BUILD_FLOOR
	var/cur_markers = 0
	var/max_markers = 64

/obj/item/blacksmith/scepter/attack_self(mob/user)
	. = ..()
	if(mode == SHPATEL_BUILD_FLOOR)
		mode = SHPATEL_BUILD_WALL
		to_chat(user, "<span class='notice'>Выбираю режим разметки стен.</span>")
	else if(mode == SHPATEL_BUILD_WALL)
		mode = SHPATEL_BUILD_FLOOR
		to_chat(user, "<span class='notice'>Выбираю режим разметки полов.</span>")

/obj/item/blacksmith/scepter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(QDELETED(target))
		return
	if(isturf(target))
		var/turf/T = get_turf(target)
		for(var/atom/A in T)
			if(istype(A, /obj/effect/plan_marker))
				qdel(A)
				to_chat(user, "<span class='notice'>Убираю маркер.</span>")
				cur_markers--
				return
		if(cur_markers >= max_markers)
			to_chat(user, "<span class='warning'>Максимум 64!</span>")
			return
		var/obj/visual = new /obj/effect/plan_marker(T)
		cur_markers++
		switch(mode)
			if(SHPATEL_BUILD_FLOOR)
				visual.icon_state = "plan_floor"
			if(SHPATEL_BUILD_WALL)
				visual.icon_state = "plan_wall"

#undef SHPATEL_BUILD_FLOOR
#undef SHPATEL_BUILD_WALL

/obj/effect/plan_marker
	name = "маркер"
	icon = 'white/valtos/icons/objects.dmi'
	anchored = TRUE
	icon_state = "plan_floor"
	layer = BYOND_LIGHTING_LAYER
