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
	name = "слиток"
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
		to_chat(user, "<span class='notice'>Теперь в куче [block_count] кирпичей.</span>")
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
	user.changeNext_move(5 SECONDS)

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
	user.changeNext_move(2 SECONDS)

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
	name = "heavy stone door"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "heavystone"
	max_integrity = 600
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
