GLOBAL_LIST_EMPTY(dwarf_crowns)

/obj/item/blacksmith
	name = "штука"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "iron_ingot"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	custom_materials = list(/datum/material/iron = 10000)
	var/real_force = 0
	var/grade = ""
	var/level = 1

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
			visible_message(span_danger("<b>[user]</b> бьёт молотом по <b>стене</b>!") , null, COMBAT_MESSAGE_RANGE)
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
	desc = "Для обработки каменных поверхностей."
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

/obj/item/blacksmith/tongs/attack_self(mob/user)
	. = ..()
	if(contents.len)
		var/obj/O = contents[contents.len]
		O.forceMove(drop_location())
		icon_state = "tongs"

/obj/item/blacksmith/tongs/attack(mob/living/carbon/C, mob/user)
	if(tearoutteeth(C, user))
		return FALSE
	else
		..()

/obj/item/blacksmith/ingot
	name = "железный слиток"
	desc = "Из него можно сделать что-то."
	icon_state = "iron_ingot"
	w_class = WEIGHT_CLASS_NORMAL
	force = 2
	throwforce = 5
	throw_range = 7
	var/datum/smithing_recipe/recipe = null
	var/durability = 6
	var/progress_current = 0
	var/progress_need = 10
	var/heattemp = 0
	var/type_metal = "iron"
	var/mod_grade = 1

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
			to_chat(user, span_warning("Некуда!"))
			return
		else
			src.forceMove(I)
			if(heattemp > 0)
				I.icon_state = "tongs_hot"
			else
				I.icon_state = "tongs_cold"
			to_chat(user, span_notice("Беру слиток клещами."))
			return

/datum/material/stone
	name = "камень"
	skloname = "камня"
	desc = "Олдфаг."
	color = "#878687"
	sheet_type = /obj/item/stack/sheet/stone

/obj/item/stack/ore/stone
	name = "камень"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "stone"
	singular_name = "Кусок камня"
	max_amount = 1
	refined_type = /obj/item/stack/sheet/stone
	merge_type = /obj/item/stack/ore/stone

/obj/item/stack/ore/stone/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/blacksmith/chisel))
		playsound(src, 'white/valtos/sounds/tough.wav', 100, TRUE)
		if(prob(25))
			to_chat(user, span_warning("Обрабатываю камень."))
			return
		new /obj/item/stack/sheet/stone(user.loc)
		to_chat(user, span_notice("Обрабатываю камень."))
		qdel(src)
		return
	if(istype(I, /obj/item/blacksmith/smithing_hammer))
		playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE)
		new /obj/item/stack/ore/glass(drop_location())
		to_chat(user, span_notice("Разбиваю [src]."))
		qdel(src)
		return

/obj/item/stack/sheet/stone
	name = "Кирпич"
	desc = "\"Кастрат\" - могли бы сказать Вы, если бы он не вырубил Вас одним попаданием."
	singular_name = "Кирпич"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "block"
	inhand_icon_state = "sheet-metal"
	force = 10
	throwforce = 10
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_TINY
	merge_type = /obj/item/stack/sheet/stone
	material_type = /datum/material/stone
	matter_amount = 4
	cost = 500

/obj/item/blacksmith/katanus
	name = "катанус"
	desc = "Не путать с катаной."
	icon_state = "katanus"
	inhand_icon_state = "katanus"
	worn_icon_state = "katanus"
	worn_icon = 'white/valtos/icons/weapons/mob/back.dmi'
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
	block_chance = 20
	sharpness = SHARP_EDGED
	max_integrity = 150
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	reach = 2
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/blacksmith/zwei/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/blacksmith/zwei/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(3 SECONDS)

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
	attack_verb_simple = list("ударяет")
	block_chance = 10
	max_integrity = 50
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/blacksmith/cep/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(3 SECONDS)

/obj/item/blacksmith/dagger
	name = "кинжал"
	desc = "Быстрый, лёгкий и довольный острый."
	icon_state = "dagger"
	inhand_icon_state = "dagger"
	worn_icon_state = "dagger"
	flags_1 = CONDUCT_1
	force = 6
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
	armor = list("melee" = 20, "bullet" = 15, "laser" = 15, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "wound" = 35)
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
	flags_inv = HIDEJUMPSUIT
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 20, "wound" = 50)
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
	SIGNAL_HANDLER
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
	armor = list("melee" = 15, "bullet" = 10, "laser" = 0, "energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0, "wound" = 30)
	custom_materials = list(/datum/material/iron = 10000)
	species_exception = list(/datum/species/dwarf)
	has_sensor = NO_SENSORS

/obj/item/clothing/head/helmet/plate_helmet
	name = "железный шлем"
	desc = "Спасёт голову от внезапного удара по ней."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "plate_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5, "wound" = 50)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/gloves/plate_gloves
	name = "железные перчатки"
	desc = "Уберегут ваши руки от внезапных потерь."
	worn_icon = 'white/valtos/icons/clothing/mob/glove.dmi'
	icon = 'white/valtos/icons/clothing/gloves.dmi'
	icon_state = "plate_gloves"
	armor = list("melee" = 25, "bullet" = 30, "laser" = 20,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 25, "wound" = 30)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/shoes/jackboots/plate_boots
	name = "железные сапоги"
	desc = "Спасут ваши ноги от внезапных переломов и других страшных штук."
	worn_icon = 'white/valtos/icons/clothing/mob/shoe.dmi'
	icon = 'white/valtos/icons/clothing/shoes.dmi'
	icon_state = "plate_boots"
	armor = list("melee" = 25, "bullet" = 30, "laser" = 20,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 25, "wound" = 30)
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
			to_chat(user, span_notice("Создаю винтовку."))
			new /obj/item/gun/ballistic/rifle/boltaction/kar98k/empty(get_turf(src))
			qdel(src)
			return
		else
			to_chat(user, span_warning("Требуется пять единиц досок!"))
			return

/obj/structure/mineral_door/detailed_door
	name = "Красивая каменная дверь"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "detaileddoor"
	max_integrity = 600
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	var/locked_door = FALSE
	sheetType = /obj/item/stack/sheet/stone

/obj/structure/mineral_door/detailed_door/examine(mob/user)
	. = ..()
	if(isdwarf(user))
		. += "<hr><span class='notice'>CTRL-клик для [locked_door ? "раз" : ""]блокировки двери.</span>"

/obj/structure/mineral_door/detailed_door/CtrlClick(mob/user)
	. = ..()
	if(isdwarf(user) && !door_opened)
		visible_message(span_notice("<b>[user]</b> [locked_door ? "от" : "за"]пирает дверь.") , null, COMBAT_MESSAGE_RANGE)
		locked_door = !locked_door
		playsound(get_turf(src), 'white/valtos/sounds/stonelock.ogg', 65, vary = TRUE)

/obj/structure/mineral_door/detailed_door/SwitchState()
	if(locked_door)
		return FALSE
	. = ..()
/obj/structure/mineral_door/heavystone
	name = "тяжёлая каменная дверь"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "heavystone"
	max_integrity = 600
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	var/locked_door = FALSE
	sheetType = /obj/item/stack/sheet/stone
	var/busy = FALSE

/obj/structure/mineral_door/heavystone/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/blacksmith/chisel))
		if(busy)
			to_chat(user, span_warning("Сейчас занято."))
			return
		busy = TRUE
		if(!do_after(user, 10 SECONDS, target = src))
			busy = FALSE
			return
		busy = FALSE
		to_chat(user, span_warning("Обрабатываю [src]."))
		var/obj/structure/mineral_door/D = new /obj/structure/mineral_door/detailed_door(loc)
		D.dir = dir
		qdel(src)


/obj/structure/mineral_door/heavystone/examine(mob/user)
	. = ..()
	if(isdwarf(user))
		. += "<hr><span class='notice'>CTRL-клик для [locked_door ? "раз" : ""]блокировки двери.</span>"

/obj/structure/mineral_door/heavystone/CtrlClick(mob/user)
	. = ..()
	if(isdwarf(user) && !door_opened)
		visible_message(span_notice("<b>[user]</b> [locked_door ? "от" : "за"]пирает дверь.") , null, COMBAT_MESSAGE_RANGE)
		locked_door = !locked_door
		playsound(get_turf(src), 'white/valtos/sounds/stonelock.ogg', 65, vary = TRUE)

/obj/structure/mineral_door/heavystone/SwitchState()
	if(locked_door)
		return FALSE
	. = ..()
/obj/item/clothing/head/helmet/dwarf_crown
	name = "Королевская корона"
	desc = "Достойна настоящего короля. Или не настоящего. Я за него не голосовал."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "dwarf_king"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5, "wound" = 15)
	custom_materials = list(/datum/material/gold = 10000)
	actions_types = list(/datum/action/item_action/send_message_action)
	var/mob/assigned_count = null

/obj/item/clothing/head/helmet/dwarf_crown/Initialize()
	. = ..()
	GLOB.dwarf_crowns+=src

/obj/item/clothing/head/helmet/dwarf_crown/Destroy()
    . = ..()
    GLOB.dwarf_crowns-=src

/datum/action/item_action/send_message_action
	name = "Отправить сообщение подданым"

/obj/item/clothing/head/helmet/dwarf_crown/proc/send_message(mob/user, msg)
	message_admins("DF: [ADMIN_LOOKUPFLW(user)]: [msg]")
	for(var/mob/M in GLOB.dwarf_list)
		to_chat(M, span_revenbignotice("[msg]"))
		SEND_SOUND(M, 'white/valtos/sounds/siren.ogg')

/obj/item/clothing/head/helmet/dwarf_crown/attack_self(mob/user)
	. = ..()
	var/busy = FALSE
	var/mob/king
	for(var/obj/item/clothing/head/helmet/dwarf_crown/C in GLOB.dwarf_crowns)
		if(C.assigned_count && C.assigned_count?.stat != DEAD)
			busy = TRUE
			king = C.assigned_count
	if(busy && assigned_count != user)
		if(user != king)
			to_chat(user, span_warning("У МЕНЯ ЗДЕСЬ НЕТ ВЛАСТИ!"))
		else
			to_chat(user, span_warning("У МЕНЯ УЖЕ ЕСТЬ ВЛАСТЬ!"))
		return

	if(is_species(user, /datum/species/dwarf) && (!assigned_count || assigned_count?.stat == DEAD))
		assigned_count = user
		send_message(user, "Волей Армока <b>[user]</b> был выбран как наш новый Лидер Экспедиции! Ура!")
	if(assigned_count == user)
		var/msg = stripped_input(user, "Что же мы скажем?", "Сообщение:")
		if(!msg)
			return
		user.whisper("[msg]")
		send_message(user, "<b>[user]</b>: [pointization(msg)]")
	else
		to_chat(user, span_warning("У МЕНЯ ЗДЕСЬ НЕТ ВЛАСТИ!"))

/obj/item/blacksmith/torch_handle
	name = "Скоба"
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
		to_chat(user, span_warning("Пол не подходит для установки держателя!"))
		return
	if(locate(/obj/machinery/torch_fixture) in view(1))
		to_chat(user, span_warning("Здесь уже что-то есть на стене!"))
		return

	return TRUE

/obj/item/blacksmith/torch_handle/proc/attach(turf/on_wall, mob/user)
	if(result_path)
		playsound(src.loc, 'sound/machines/click.ogg', 75, TRUE)
		user.visible_message(span_notice("[user.name] прикрепляет скобу к стене.") ,
			span_notice("Прикрепляю скобу к стене.") ,
			span_hear("Слышу щелчки."))
		var/ndir = get_dir(on_wall, user)

		new result_path(get_turf(user), ndir, TRUE)
	qdel(src)

/obj/machinery/torch_fixture
	name = "Скоба"
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
	dir = turn(ndir, 180)
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
			to_chat(user, span_warning("Здесь уже есть факел!"))
		else
			src.add_fingerprint(user)
			var/obj/item/flashlight/flare/torch/L = W
			if(istype(L, light_type))
				if(!user.temporarilyRemoveItemFromInventory(L))
					return
				src.add_fingerprint(user)
				to_chat(user, span_notice("Ставлю [L] на место."))
				status = LIGHT_OK
				fuel = L.fuel
				on = L.on
				recalculate_light()
				qdel(L)
				START_PROCESSING(SSobj, src)
			else
				to_chat(user, span_warning("Эта штука поддерживает только обычные факелы!"))
	else
		return ..()

/obj/machinery/torch_fixture/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		to_chat(user, span_warning("Здесь нет факела!"))
		return

	var/obj/item/flashlight/flare/torch/L = new light_type()

	L.on = on
	L.fuel = fuel
	L.forceMove(loc)
	L.update_brightness()

	if(!fuel)
		L.icon_state = "torch-empty"

	if(user)
		L.add_fingerprint(user)
		user.put_in_active_hand(L)

	status = LIGHT_EMPTY
	STOP_PROCESSING(SSobj, src)
	recalculate_light()
	return

#define SHPATEL_BUILD_FLOOR 1
#define SHPATEL_BUILD_WALL 2
#define SHPATEL_BUILD_DOOR 3
#define SHPATEL_BUILD_TABLE 4
#define SHPATEL_BUILD_CHAIR 5

/obj/item/blacksmith/shpatel
	name = "Мастерок"
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
	for(var/obj/item/stack/sheet/stone/B in view(1))
		mat_to += B.amount
	switch(mode)
		if(SHPATEL_BUILD_WALL) mat_need = 4
		if(SHPATEL_BUILD_FLOOR) mat_need = 1
	if(mat_to >= mat_need)
		return TRUE
	else
		return FALSE

/obj/item/blacksmith/shpatel/proc/use_resources(var/turf/open/floor/T, mob/user)
	switch(mode)
		if(SHPATEL_BUILD_WALL)
			var/blocks_need = 5
			for(var/obj/item/stack/sheet/stone/B in view(1))
				blocks_need -= B.amount
				B.amount = -blocks_need
				B.update_icon()
				if(B.amount <= 0)
					qdel(B)
				if(blocks_need <= 0)
					break
			T.ChangeTurf(/turf/closed/wall/stonewall, flags = CHANGETURF_IGNORE_AIR)
			user.visible_message(span_notice("<b>[user]</b> возводит каменную стену.") , \
								span_notice("Возвожу каменную стену."))
		if(SHPATEL_BUILD_FLOOR)
			var/blocks_need = 1
			for(var/obj/item/stack/sheet/stone/B in view(1))
				blocks_need -= B.amount
				B.amount = -blocks_need
				B.update_icon()
				if(B.amount <= 0)
					qdel(B)
				if(blocks_need <= 0)
					break
			T.ChangeTurf(/turf/open/floor/grass/gensgrass/dirty/stone, flags = CHANGETURF_INHERIT_AIR)
			user.visible_message(span_notice("<b>[user]</b> создаёт каменный пол.") , \
								span_notice("Делаю каменный пол."))

/obj/item/blacksmith/shpatel/proc/do_job(atom/A, mob/user)
	if(!istype(A, /turf/open/floor))
		return
	if(mode != SHPATEL_BUILD_FLOOR && !istype(A, /turf/open/floor/grass/gensgrass/dirty/stone))
		to_chat(user, span_warning("Не могу построить на этом полу!"))
		return
	if(mode==SHPATEL_BUILD_FLOOR && istype(A, /turf/open/floor/grass/gensgrass/dirty/stone))
		var/turf/open/floor/grass/gensgrass/dirty/stone/S = A
		if(S.stoned)
			return
	var/turf/T = get_turf(A)
	if(check_resources())
		if(do_after(user, 5 SECONDS, target = A))
			if(check_resources())
				use_resources(T, user)
				playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
				return TRUE
	else
		to_chat(user, span_warning("Не хватает материалов!"))

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
	w_class = WEIGHT_CLASS_HUGE
	force = 9
	throwforce = 4
	throw_range = 5
	custom_materials = list(/datum/material/gold = 10000)
	var/mode = SHPATEL_BUILD_FLOOR
	var/cur_markers = 0
	var/max_markers = 64

/obj/item/blacksmith/scepter/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/blacksmith/scepter/attack_self(mob/user)
	..()
	var/list/choices = list(
		"Полы"   = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "plan_floor"),
		"Стены"  = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "plan_wall"),
		"Двери"  = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "plan_door"),
		"Столы"  = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "plan_table"),
		"Стулья" = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "plan_chair"),
		"Очистка"= image(icon = 'white/valtos/icons/objects.dmi', icon_state = "clear")
	)
	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Полы")
			mode = SHPATEL_BUILD_FLOOR
		if("Стены")
			mode = SHPATEL_BUILD_WALL
		if("Двери")
			mode = SHPATEL_BUILD_DOOR
		if("Столы")
			mode = SHPATEL_BUILD_TABLE
		if("Стулья")
			mode = SHPATEL_BUILD_CHAIR
		if("Очистка")
			clear(user)

/obj/item/blacksmith/scepter/proc/clear(mob/user)
	var/i = 0
	for(var/obj/effect/plan_marker/M in view(7, user))
		qdel(M)
		i++
	to_chat(user, span_notice("Удалено [i] маркеров."))

/obj/item/blacksmith/scepter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(QDELETED(target))
		return
	if(isturf(target))
		var/turf/T = get_turf(target)
		for(var/atom/A in T)
			if(istype(A, /obj/effect/plan_marker))
				qdel(A)
				to_chat(user, span_notice("Убираю маркер."))
				cur_markers--
				return
		if(cur_markers >= max_markers)
			to_chat(user, span_warning("Максимум 64!"))
			return
		var/obj/visual = new /obj/effect/plan_marker(T)
		cur_markers++
		switch(mode)
			if(SHPATEL_BUILD_FLOOR)
				visual.icon_state = "plan_floor"
			if(SHPATEL_BUILD_WALL)
				visual.icon_state = "plan_wall"
			if(SHPATEL_BUILD_DOOR)
				visual.icon_state = "plan_door"
			if(SHPATEL_BUILD_TABLE)
				visual.icon_state = "plan_table"
			if(SHPATEL_BUILD_CHAIR)
				visual.icon_state = "plan_chair"

#undef SHPATEL_BUILD_FLOOR
#undef SHPATEL_BUILD_WALL
#undef SHPATEL_BUILD_DOOR
#undef SHPATEL_BUILD_TABLE
#undef SHPATEL_BUILD_CHAIR

/obj/effect/plan_marker
	name = "маркер"
	icon = 'white/valtos/icons/objects.dmi'
	anchored = TRUE
	icon_state = "plan_floor"
	layer = ABOVE_NORMAL_TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 190

/obj/structure/chair/comfy/stone
	name = "каменный стул"
	desc = "Это выглядит НЕ удобно."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "stoool"
	color = rgb(255,255,255)
	resistance_flags = LAVA_PROOF
	max_integrity = 150
	buildstacktype = /obj/item/stack/sheet/stone

/obj/structure/chair/comfy/stone/GetArmrest()
	return mutable_appearance('white/valtos/icons/objects.dmi', "stoool_armrest")

/obj/structure/chair/comfy/stone/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		user.visible_message(span_notice("[user] пытается разобрать каменный стул <b>ГАЕЧНЫМ КЛЮЧОМ</b>.") , \
		span_notice("Пытаюсь разобрать каменный стул..."))
		return
	else
		return ..()

/obj/structure/chair/comfy/stone/throne
	name = "каменный трон"
	desc = "Выглядит роскошно, но не удобно."
	icon_state = "throne"
	max_integrity = 650

/obj/structure/chair/comfy/stone/throne/GetArmrest()
	return mutable_appearance('white/valtos/icons/objects.dmi', "throne_armrest")

/obj/structure/table/stone
	name = "каменный стол"
	desc = "Прочный стол из камня."
	icon = 'white/valtos/icons/stone_table.dmi'
	icon_state = "stone_table-0"
	base_icon_state = "stone_table"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 300
	buildstack = /obj/item/stack/sheet/stone
	smoothing_groups = list(SMOOTH_GROUP_BRONZE_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_BRONZE_TABLES)

/obj/structure/table/stone/attackby(obj/item/W, mob/user, params)
	if (W.tool_behaviour == TOOL_WRENCH || W.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_warning("А че как..."))
		return
	else
		return ..()

/obj/machinery/microwave/furnace
	name = "печка"
	icon = 'white/valtos/icons/peeech.dmi'
	icon_state = "peeech"
	use_power = NO_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	efficiency = 4
	circuit = null

/obj/machinery/microwave/furnace/update_icon_state()
	if(broken)
		icon_state = "peech"
	else if(dirty_anim_playing)
		icon_state = "peech"
	else if(dirty == 100)
		icon_state = "peech"
	else if(operating)
		icon_state = "peech1"
	else if(panel_open)
		icon_state = "peech"
	else
		icon_state = "peech"

/obj/machinery/microwave/furnace/attackby(obj/item/O, mob/user, params)
	efficiency = 4
	broken = 0
	dirty = 0
	if(is_wire_tool(O))
		return FALSE
	..()

/obj/structure/closet/crate/sarcophage
	name = "саркофаг"
	desc = "Души усопших запечатаны здесь. В нём не рекомендуется спать."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "sarcophage"
	drag_slowdown = 4
	var/dead_used = FALSE

/obj/structure/closet/crate/sarcophage/close(mob/living/user)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/H in contents)
			if(H.stat == DEAD)
				name = "саркофаг [skloname(H.real_name, VINITELNI, H.gender)]"
				for(var/obj/item/W in H)
					if(!H.dropItemToGround(W))
						qdel(W)
						H.regenerate_icons()
				qdel(H)
				dead_used = TRUE
				var/turf/where_is_new = get_turf(pick(GLOB.dwarf_shkonka_list))
				new /obj/effect/mob_spawn/human/dwarf(where_is_new)
				return TRUE

/obj/item/blacksmith/partial
	desc = "Похоже на часть чего-то большего."
	var/item_grade = "*"

/obj/item/blacksmith/partial/Initialize()
	. = ..()
	force = 1

/obj/item/blacksmith/partial/zwei
	name = "лезвие цвая"
	real_force = 40
	icon_state = "zwei_part"

/obj/item/blacksmith/partial/katanus
	name = "лезвие катануса"
	real_force = 16
	icon_state = "katanus_part"

/obj/item/blacksmith/partial/cep
	name = "шар с цепью"
	real_force = 20
	icon_state = "cep_part"

/obj/item/blacksmith/partial/dwarfsord
	name = "лезвие прямого меча"
	real_force = 16
	icon_state = "dwarfsord_part"

/obj/item/blacksmith/partial/crown_empty
	name = "Пустая корона"
	icon_state = "crown_empty"

/obj/item/blacksmith/partial/scepter_part
	name = "части скипетра"
	icon_state = "scepter_part"

/obj/item/scepter_shaft
	name = "рукоять скипетра"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "scepter_shaft"

/obj/item/blacksmith/dwarfsord
	name = "прямой меч"
	desc = "Точно не гейский"
	icon_state = "dwarfsord"
	inhand_icon_state = "dwarfsord"
	worn_icon_state = "dwarfsord"
	worn_icon = 'white/valtos/icons/weapons/mob/back.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	force = 18
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет", "колбасит")
	block_chance = 30
	sharpness = SHARP_EDGED
	max_integrity = 50
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/iron = 10000)
