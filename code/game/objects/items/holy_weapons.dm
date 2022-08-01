// CHAPLAIN CUSTOM ARMORS //

/obj/item/clothing/head/helmet/chaplain/clock
	name = "забытый шлем"
	desc = "У него непреклонный взгляд навечно забытого бога."
	icon_state = "clockwork_helmet"
	inhand_icon_state = "clockwork_helmet_inhand"
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 8 SECONDS
	dog_fashion = null

/obj/item/clothing/suit/armor/riot/chaplain/clock
	name = "забытая броня"
	desc = "Звучит как шипение пара, тиканье шестерёнок и затихание. Похоже на мёртвую машину, пытающуюся жить."
	icon_state = "clockwork_cuirass"
	inhand_icon_state = "clockwork_cuirass_inhand"
	allowed = list(/obj/item/storage/book/bible, /obj/item/nullrod, /obj/item/reagent_containers/food/drinks/bottle/holywater, /obj/item/storage/fancy/candle_box, /obj/item/candle, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	slowdown = 0
	clothing_flags = NONE

/obj/item/clothing/head/helmet/chaplain
	name = "шлем крестоносца"
	desc = "Деус Вульт!"
	icon_state = "knight_templar"
	inhand_icon_state = "knight_templar"
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 80
	dog_fashion = null

/obj/item/clothing/suit/armor/riot/chaplain
	name = "доспехи крестоносца"
	desc = "Бог желает этого!"
	icon_state = "knight_templar"
	inhand_icon_state = "knight_templar"
	allowed = list(/obj/item/storage/book/bible, /obj/item/nullrod, /obj/item/reagent_containers/food/drinks/bottle/holywater, /obj/item/storage/fancy/candle_box, /obj/item/candle, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	slowdown = 0
	clothing_flags = NONE

/obj/item/choice_beacon/holy
	name = "радиомаяк вооружения"
	desc = "Содержит набор вооружения для капеллана."

/obj/item/choice_beacon/holy/canUseBeacon(mob/living/user)
	if(user.mind && user.mind.holy_role)
		return ..()
	else
		playsound(src, 'white/valtos/sounds/error1.ogg', 40, TRUE)
		return FALSE

/obj/item/choice_beacon/holy/generate_display_names()
	var/static/list/holy_item_list
	if(!holy_item_list)
		holy_item_list = list()
		var/list/templist = typesof(/obj/item/storage/box/holy)
		for(var/V in templist)
			var/atom/A = V
			holy_item_list[initial(A.name)] = A
	return holy_item_list

/obj/item/choice_beacon/holy/spawn_option(obj/choice,mob/living/M)
	if(!GLOB.holy_armor_type)
		..()
		playsound(src, 'sound/effects/pray_chaplain.ogg', 40, TRUE)
		SSblackbox.record_feedback("tally", "chaplain_armor", 1, "[choice]")
		GLOB.holy_armor_type = choice
	else
		to_chat(M, span_warning("Выбор сделан. Самоуничтожение..."))
		return


/obj/item/storage/box/holy/clock
	name = "Забытый набор"

/obj/item/storage/box/holy/clock/PopulateContents()
	new /obj/item/clothing/head/helmet/chaplain/clock(src)
	new /obj/item/clothing/suit/armor/riot/chaplain/clock(src)

/obj/item/storage/box/holy
	name = "Набор Тамплиера"

/obj/item/storage/box/holy/PopulateContents()
	new /obj/item/clothing/head/helmet/chaplain(src)
	new /obj/item/clothing/suit/armor/riot/chaplain(src)

/obj/item/storage/box/holy/student
	name = "Набор Оскверненного Ученого"

/obj/item/storage/box/holy/student/PopulateContents()
	new /obj/item/clothing/suit/armor/riot/chaplain/studentuni(src)
	new /obj/item/clothing/head/helmet/chaplain/cage(src)

/obj/item/clothing/suit/armor/riot/chaplain/studentuni
	name = "студенческая мантия"
	desc = "Униформа древнего учебного заведения."
	icon_state = "studentuni"
	inhand_icon_state = "studentuni"
	body_parts_covered = ARMS|CHEST

/obj/item/clothing/head/helmet/chaplain/cage
	name = "клетка"
	desc = "Клетка, сдерживающая желания личности, позволяющая увидеть нечестивый мир таким, какой он есть."
	flags_inv = NONE
	icon_state = "cage"
	inhand_icon_state = "cage"
	worn_y_offset = 7
	dynamic_hair_suffix = ""

/obj/item/storage/box/holy/sentinel
	name = "Набор Каменного Стража"

/obj/item/storage/box/holy/sentinel/PopulateContents()
	new /obj/item/clothing/suit/armor/riot/chaplain/ancient(src)
	new /obj/item/clothing/head/helmet/chaplain/ancient(src)

/obj/item/clothing/head/helmet/chaplain/ancient
	name = "древний шлем"
	desc = "Никто не может пройти!"
	icon_state = "knight_ancient"
	inhand_icon_state = "knight_ancient"

/obj/item/clothing/suit/armor/riot/chaplain/ancient
	name = "древний доспех"
	desc = "Защити сокровище..."
	icon_state = "knight_ancient"
	inhand_icon_state = "knight_ancient"

/obj/item/storage/box/holy/witchhunter
	name = "Набор Охотника на Ведьм"

/obj/item/storage/box/holy/witchhunter/PopulateContents()
	new /obj/item/clothing/suit/armor/riot/chaplain/witchhunter(src)
	new /obj/item/clothing/head/helmet/chaplain/witchunter_hat(src)

/obj/item/clothing/suit/armor/riot/chaplain/witchhunter
	name = "одеяние Охотника на Ведьм."
	desc = "Это изношенное одеяние часто применялось в свое время."
	icon_state = "witchhunter"
	inhand_icon_state = "witchhunter"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/head/helmet/chaplain/witchunter_hat
	name = "шляпа Охотника на Ведьм"
	desc = "Эта изношенная шляпа часто применялась в свое время."
	inhand_icon_state = "witchhunterhat"
	flags_cover = HEADCOVERSEYES
	flags_inv = null

/obj/item/storage/box/holy/adept
	name = "Набор Божественного Адепта"

/obj/item/storage/box/holy/adept/PopulateContents()
	new /obj/item/clothing/suit/armor/riot/chaplain/adept(src)
	new /obj/item/clothing/head/helmet/chaplain/adept(src)

/obj/item/clothing/head/helmet/chaplain/adept
	name = "капюшон адепта"
	desc = "Еретично только тогда, когда это делают другие."
	icon_state = "crusader"
	inhand_icon_state = "crusader"
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS

/obj/item/clothing/suit/armor/riot/chaplain/adept
	name = "мантия адепта"
	desc = "Идеальный наряд для сжигания неверных."
	icon_state = "crusader"
	inhand_icon_state = "crusader"

/obj/item/storage/box/holy/follower
	name = "Набор Последователей Капеллана"

/obj/item/storage/box/holy/follower/PopulateContents()
	new /obj/item/clothing/suit/hooded/chaplain_hoodie/leader(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)

/obj/item/storage/box/mothic_rations
	name = "пакет с пайком для молей"
	desc = "Коробка, содержащая несколько пайков и немного жевательной резинки Activin, чтобы поддерживать голодную моль."
	icon_state = "moth_package"
	illustration = null

/obj/item/storage/box/mothic_rations/PopulateContents()
	for(var/i in 1 to 3)
		var/randomFood = pickweight(list(/obj/item/food/sustenance_bar = 10,
							  /obj/item/food/sustenance_bar/cheese = 5,
							  /obj/item/food/sustenance_bar/mint = 5,
							  /obj/item/food/sustenance_bar/neapolitan = 5,
							  /obj/item/food/sustenance_bar/wonka = 1))
		new randomFood(src)
	new /obj/item/storage/box/gum/wake_up(src)
/obj/item/clothing/suit/hooded/chaplain_hoodie
	name = "толстовка последователя"
	desc = "Толстовка сделанная для прислужников капеллана."
	icon_state = "chaplain_hoodie"
	inhand_icon_state = "chaplain_hoodie"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/storage/book/bible, /obj/item/nullrod, /obj/item/reagent_containers/food/drinks/bottle/holywater, /obj/item/storage/fancy/candle_box, /obj/item/candle, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood

/obj/item/clothing/head/hooded/chaplain_hood
	name = "капюшон последователя"
	desc = "Капюшон сделанный для прислужников капеллана."
	icon_state = "chaplain_hood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS

/obj/item/clothing/suit/hooded/chaplain_hoodie/leader
	name = "толстовка лидера секты"
	desc = "Теперь вы готовы выпить блестящей воды за 50 долларов."
	icon_state = "chaplain_hoodie_leader"
	inhand_icon_state = "chaplain_hoodie_leader"
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood/leader

/obj/item/clothing/head/hooded/chaplain_hood/leader
	name = "капюшон лидера секты"
	desc = "Я имею в виду, что вам не обязательно искать блестящую воду. Я просто думаю, что вы должны ее выпить."
	icon_state = "chaplain_hood_leader"


// CHAPLAIN NULLROD AND CUSTOM WEAPONS //

/obj/item/nullrod
	name = "жезл Нулификации"
	desc = "Жезл из чистого обсидиана. Само его присутствие разрушает и ослабляет «магические силы». Во всяком случае так написано в путеводителе."
	icon_state = "nullrod"
	inhand_icon_state = "nullrod"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 18
	throw_speed = 3
	throw_range = 4
	throwforce = 10
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_TINY
	obj_flags = UNIQUE_RENAME
	wound_bonus = -10
	var/reskinned = FALSE
	var/chaplain_spawnable = TRUE

/obj/item/nullrod/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, null, FALSE)

/obj/item/nullrod/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] убивает [user.ru_na()] себя используя [src]! Похоже, что [user.p_theyre()] пытается стать ближе к богу!"))
	return (BRUTELOSS|FIRELOSS)

/obj/item/nullrod/attack_self(mob/user)
	if(user.mind && (user.mind.holy_role) && !reskinned)
		reskin_holy_weapon(user)

/**
 * reskin_holy_weapon: Shows a user a list of all available nullrod reskins and based on his choice replaces the nullrod with the reskinned version
 *
 * Arguments:
 * * M The mob choosing a nullrod reskin
 */
/obj/item/nullrod/proc/reskin_holy_weapon(mob/M)
	if(GLOB.holy_weapon_type)
		return
	var/list/display_names = list()
	var/list/nullrod_icons = list()
	for(var/rod in typesof(/obj/item/nullrod))
		var/obj/item/nullrod/rodtype = rod
		if(initial(rodtype.chaplain_spawnable))
			display_names[initial(rodtype.name)] = rodtype
			nullrod_icons += list(initial(rodtype.name) = image(icon = initial(rodtype.icon), icon_state = initial(rodtype.icon_state)))

	nullrod_icons = sort_list(nullrod_icons)
	var/choice = show_radial_menu(M, src , nullrod_icons, custom_check = CALLBACK(src, .proc/check_menu, M), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(M))
		return

	var/picked_rod_type = display_names[choice] // This needs to be on a separate var as list member access is not allowed for new
	var/obj/item/nullrod/holy_weapon = new picked_rod_type(M.drop_location())
	GLOB.holy_weapon_type = holy_weapon.type

	SSblackbox.record_feedback("tally", "chaplain_weapon", 1, "[choice]")

	if(holy_weapon)
		holy_weapon.reskinned = TRUE
		qdel(src)
		M.put_in_hands(holy_weapon)

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 */
/obj/item/nullrod/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src) || reskinned)
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/nullrod/godhand
	icon_state = "disintegrate"
	inhand_icon_state = "disintegrate"
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	name = "божья Длань"
	desc = "Эта рука сияет с потрясающей силой!"
	slot_flags = null
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/sear.ogg'
	damtype = BURN
	attack_verb_continuous = list("бьёт", "скрещивает пальцы", "вмазывает")
	attack_verb_simple = list("бьёт", "скрещивает пальцы", "вмазывает")

/obj/item/nullrod/godhand/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/nullrod/staff
	icon_state = "godstaff-red"
	inhand_icon_state = "godstaff-red"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	name = "красный посох"
	desc = "Обладает таинственной, защитной аурой."
	w_class = WEIGHT_CLASS_HUGE
	force = 5
	slot_flags = ITEM_SLOT_BACK
	block_chance = 50
	var/shield_icon = "shield-red"

/obj/item/nullrod/staff/worn_overlays(isinhands)
	. = list()
	if(isinhands)
		. += mutable_appearance('icons/effects/effects.dmi', shield_icon, MOB_SHIELD_LAYER)

/obj/item/nullrod/staff/blue
	name = "синий посох"
	icon_state = "godstaff-blue"
	inhand_icon_state = "godstaff-blue"
	shield_icon = "shield-old"

/obj/item/nullrod/claymore
	icon_state = "claymore_gold"
	inhand_icon_state = "claymore_gold"
	worn_icon_state = "claymore_gold"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "священный клеймор"
	desc = "Оружие, подходящее для крестового похода!"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	block_chance = 30
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_sounds = list('white/valtos/sounds/block_sword.ogg')
	attack_verb_continuous = list("атакует", "рубит", "кромсает", "разрывает", "протыкает", "колбасит", "делит", "режет")
	attack_verb_simple = list("атакует", "рубит", "кромсает", "разрывает", "протыкает", "колбасит", "делит", "режет")

/obj/item/nullrod/claymore/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = 0 //Don't bring a sword to a gunfight
	return ..()

/obj/item/nullrod/claymore/darkblade
	name = "темный клинок"
	desc = "Распространяйте славу темных богов!"
	icon_state = "cultblade"
	inhand_icon_state = "cultblade"
	worn_icon_state = "cultblade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	hitsound = 'sound/hallucinations/growl1.ogg'

/obj/item/nullrod/claymore/chainsaw_sword
	icon_state = "chainswordon"
	inhand_icon_state = "chainswordon"
	worn_icon_state = "chainswordon"
	name = "цепной меч"
	desc = "Не позволь еретику жить."
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("пилит", "рвёт", "режет", "рубит", "делит")
	attack_verb_simple = list("пилит", "рвёт", "режет", "рубит", "делит")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	tool_behaviour = TOOL_SAW
	toolspeed = 1.5 //slower than a real saw

/obj/item/nullrod/claymore/glowing
	icon_state = "swordon"
	inhand_icon_state = "swordon"
	worn_icon_state = "swordon"
	name = "силовой меч"
	desc = "Клинок светится силой веры. Или, возможно, благодаря аккумулятору."

/obj/item/nullrod/claymore/katana
	name = "лезвие Ханзо"
	desc = "Способен прорезать святой клеймор."
	icon_state = "katana"
	inhand_icon_state = "katana"
	worn_icon_state = "katana"

/obj/item/nullrod/claymore/multiverse
	name = "внепространственный клинок"
	desc = "Будучи когда-то предвестником межпространственной войны, его острота сильно колеблется."
	icon_state = "multiverse"
	inhand_icon_state = "multiverse"
	worn_icon_state = "multiverse"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	force = 15

/obj/item/nullrod/claymore/multiverse/melee_attack_chain(mob/user, atom/target, params)
	var/old_force = force
	force += rand(-14, 15)
	. = ..()
	force = old_force

/obj/item/nullrod/claymore/saber
	name = "светлый энергетический меч"
	hitsound = 'sound/weapons/blade1.ogg'
	icon = 'icons/obj/transforming_energy.dmi'
	icon_state = "e_sword_on_blue"
	inhand_icon_state = "e_sword_on_blue"
	worn_icon_state = "swordblue"
	slot_flags = ITEM_SLOT_BELT
	desc = "Используй силу, юный падаван."

/obj/item/nullrod/claymore/saber/red
	name = "темный энергетический меч"
	desc = "Переходи на темную сторону!"
	icon_state = "e_sword_on_red"
	inhand_icon_state = "e_sword_on_red"
	worn_icon_state = "swordred"

/obj/item/nullrod/claymore/saber/pirate
	name = "морской энергетический меч"
	desc = "Убедить СБ в том, что ваша религия связана с пиратством, было непросто."
	icon_state = "e_cutlass_on"
	inhand_icon_state = "e_cutlass_on"
	worn_icon_state = "swordred"

/obj/item/nullrod/sord
	name = "НЕРЕАЛЬНЫЙ МЕТЧ"
	desc = "Эта штука настолько невыразимо СВЯТАЯ, что вам трудно даже держать ее в руках."
	icon_state = "sord"
	inhand_icon_state = "sord"
	worn_icon_state = "sord"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 4.13
	throwforce = 1
	slot_flags = ITEM_SLOT_BELT
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("НЕРЕАЛЬНО рубит", "НЕРЕАЛЬНО режет", "НЕРЕАЛЬНО кромсает", "НЕРЕАЛЬНО разрывает", "НЕРЕАЛЬНО протыкает", "НЕРЕАЛЬНО атакует", "НЕРЕАЛЬНО делит", "НЕРЕАЛЬНО колбасит")
	attack_verb_simple = list("НЕРЕАЛЬНО рубит", "НЕРЕАЛЬНО режет", "НЕРЕАЛЬНО кромсает", "НЕРЕАЛЬНО разрывает", "НЕРЕАЛЬНО протыкает", "НЕРЕАЛЬНО атакует", "НЕРЕАЛЬНО делит", "НЕРЕАЛЬНО колбасит")

/obj/item/nullrod/sord/suicide_act(mob/user) //a near-exact copy+paste of the actual sord suicide_act()
	user.visible_message(span_suicide("[user] пытается impale [user.ru_na()]self with [src]! It might be a suicide attempt if it weren't so HOLY.") , \
	span_suicide("Пытаюсь проткнуть себя [src], но он СЛИШКОМ СВЯТОЙ..."))
	return SHAME

/obj/item/nullrod/scythe
	icon_state = "scythe1"
	inhand_icon_state = "scythe1"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "коса жнеца"
	desc = "И жрец, и жнец, и на дуде игрец!"
	w_class = WEIGHT_CLASS_BULKY
	armour_penetration = 35
	slot_flags = ITEM_SLOT_BACK
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("рубит", "режет", "косит", "скашивает")
	attack_verb_simple = list("рубит", "режет", "косит", "скашивает")

/obj/item/nullrod/scythe/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 70, 110) //the harvest gives a high bonus chance

/obj/item/nullrod/scythe/vibro
	icon_state = "hfrequency0"
	inhand_icon_state = "hfrequency1"
	worn_icon_state = "hfrequency0"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "высокочастотный клинок"
	desc = "Плохая отсылка к ДНК души."
	attack_verb_continuous = list("рубит", "режет", "кромсает", "зандатсуирует")
	attack_verb_simple = list("рубит", "режет", "кромсает", "зандатсуирует")
	hitsound = 'sound/weapons/rapierhit.ogg'

/obj/item/nullrod/scythe/spellblade
	icon_state = "spellblade"
	inhand_icon_state = "spellblade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	worn_icon_state = "spellblade"
	icon = 'icons/obj/guns/magic.dmi'
	name = "дремлющий клинок заклинаний"
	desc = "Клинок дает владельцу почти безграничную силу... если он сможет понять, как его включить."
	hitsound = 'sound/weapons/rapierhit.ogg'

/obj/item/nullrod/scythe/talking
	icon_state = "talking_sword"
	inhand_icon_state = "talking_sword"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	worn_icon_state = "talking_sword"
	name = "одержимый клинок"
	desc = "Когда на станции царит хаос, приятно иметь рядом друга."
	attack_verb_continuous = list("рубит", "нарезает", "режет")
	attack_verb_simple = list("рубит", "нарезает", "режет")
	hitsound = 'sound/weapons/rapierhit.ogg'
	var/possessed = FALSE

/obj/item/nullrod/scythe/talking/relaymove(mob/living/user, direction)
	return //stops buckled message spam for the ghost.

/obj/item/nullrod/scythe/talking/attack_self(mob/living/user)
	if(possessed)
		return
	if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
		to_chat(user, span_notice("Аномальные потусторонние энергии мешают вам пробудить клинок!"))
		return

	to_chat(user, span_notice("Вы пытаетесь пробудить дух клинка..."))

	possessed = TRUE

	var/list/mob/dead/observer/candidates = poll_ghost_candidates("Хочешь быть духом меча [user.real_name]?", ROLE_PAI, FALSE, 100, POLL_IGNORE_POSSESSED_BLADE)

	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		var/mob/living/simple_animal/shade/S = new(src)
		S.ckey = C.ckey
		S.fully_replace_character_name(null, "Дух [name]")
		S.status_flags |= GODMODE
		S.copy_languages(user, LANGUAGE_MASTER)	//Make sure the sword can understand and communicate with the user.
		S.update_atom_languages()
		grant_all_languages(FALSE, FALSE, TRUE)	//Grants omnitongue
		var/input = sanitize_name(stripped_input(S,"Каково твое имя?", ,"", MAX_NAME_LEN))

		if(src && input)
			name = input
			S.fully_replace_character_name(null, "Дух [input]")
	else
		to_chat(user, span_warning("Клинок дремлет. Возможно, вы можете попробовать позже."))
		possessed = FALSE

/obj/item/nullrod/scythe/talking/Destroy()
	for(var/mob/living/simple_animal/shade/S in contents)
		to_chat(S, span_userdanger("Я был уничтожен!"))
		qdel(S)
	return ..()

/obj/item/nullrod/scythe/talking/chainsword
	icon_state = "chainswordon"
	inhand_icon_state = "chainswordon"
	worn_icon_state = "chainswordon"
	name = "одержимый цепной меч"
	desc = "Не позволь еретику жить."
	chaplain_spawnable = FALSE
	force = 30
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("пилит", "рвёт", "режет", "рубит", "делит")
	attack_verb_simple = list("пилит", "рвёт", "режет", "рубит", "делит")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	tool_behaviour = TOOL_SAW
	toolspeed = 0.5 //faster than normal saw

/obj/item/nullrod/hammmer
	name = "реликтовый боевой молот"
	desc = "Этот боевой молот обошелся капеллану в сорок тысяч кредитов."
	icon_state = "hammeron"
	inhand_icon_state = "hammeron"
	worn_icon_state = "hammeron"
	lefthand_file = 'icons/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/hammers_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("лупит", "бьёт", "молотит", "уничтожает")
	attack_verb_simple = list("лупит", "бьёт", "молотит", "уничтожает")

/obj/item/nullrod/chainsaw
	name = "рука-бензопила"
	desc = "Добро? Зло? Ты парень с бензопилой в руке."
	icon_state = "chainsaw_on"
	inhand_icon_state = "mounted_chainsaw"
	lefthand_file = 'icons/mob/inhands/weapons/chainsaw_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/chainsaw_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = null
	item_flags = ABSTRACT
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("пилит", "рвёт", "режет", "рубит", "делит")
	attack_verb_simple = list("пилит", "рвёт", "режет", "рубит", "делит")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	tool_behaviour = TOOL_SAW
	toolspeed = 2 //slower than a real saw

/obj/item/nullrod/chainsaw/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	AddComponent(/datum/component/butchering, 30, 100, 0, hitsound)

/obj/item/nullrod/clown
	name = "клоунский кинжал"
	desc = "Используется для веселых жертвоприношений."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "clownrender"
	inhand_icon_state = "render"
	worn_icon_state = "render"
	hitsound = 'sound/items/bikehorn.ogg'
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("атакует", "режет", "протыкает", "нарезает", "рвёт", "разрывает", "делит", "кромсает")
	attack_verb_simple = list("атакует", "режет", "протыкает", "нарезает", "рвёт", "разрывает", "делит", "кромсает")

#define CHEMICAL_TRANSFER_CHANCE 30

/obj/item/nullrod/pride_hammer
	name = "горделивый молот"
	desc = "Он резонирует аурой Гордости."
	icon_state = "pride"
	inhand_icon_state = "pride"
	worn_icon_state = "pride"
	lefthand_file = 'icons/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/hammers_righthand.dmi'
	force = 16
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("атакует", "лупит", "покушается", "нежит", "засаживает")
	attack_verb_simple = list("атакует", "лупит", "покушается", "нежит", "засаживает")
	hitsound = 'sound/weapons/blade1.ogg'


/obj/item/nullrod/pride_hammer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/kneejerk)
	AddElement(
		/datum/element/chemical_transfer,\
		span_notice("Ваша гордость отражает %VICTIM."),\
		span_userdanger("Вы чувствуете себя неуверенно, взяв на себя бремя %ATTACKER."),\
		CHEMICAL_TRANSFER_CHANCE\
	)

#undef CHEMICAL_TRANSFER_CHANCE

/obj/item/nullrod/whip
	name = "священная плеть"
	desc = "Какая ужасная ночь на космической станции 13."
	icon_state = "chain"
	inhand_icon_state = "chain"
	worn_icon_state = "whip"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("хлыстает", "приручает")
	attack_verb_simple = list("хлыстает", "приручает")
	hitsound = 'sound/weapons/chainhit.ogg'

/obj/item/nullrod/fedora
	name = "атеистическая федора"
	desc = "Поля шляпы столь же остры, как и ваш ум. Эти поля причинили бы почти такую же боль, как и опровержение существования Бога."
	icon_state = "fedora"
	inhand_icon_state = "fedora"
	slot_flags = ITEM_SLOT_HEAD
	icon = 'icons/obj/clothing/hats.dmi'
	force = 0
	throw_speed = 4
	throw_range = 7
	throwforce = 30
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("просветляет", "краснопилюлит")
	attack_verb_simple = list("просветляет", "краснопилюлит")

/obj/item/nullrod/armblade
	name = "темное благословение"
	desc = "Особо извращенные божества дарят дары сомнительной ценности."
	icon = 'icons/obj/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	slot_flags = null
	item_flags = ABSTRACT
	w_class = WEIGHT_CLASS_HUGE
	sharpness = SHARP_EDGED
	wound_bonus = -20
	bare_wound_bonus = 25

/obj/item/nullrod/armblade/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	AddComponent(/datum/component/butchering, 80, 70)

/obj/item/nullrod/armblade/tentacle
	name = "нечестивое благословение"
	icon_state = "tentacle"
	inhand_icon_state = "tentacle"

/obj/item/nullrod/carp
	name = "плюшевый Карп-Си"
	desc = "Очаровательная мягкая игрушка, напоминающая бога всех карпов. Зубы выглядят довольно острыми. Активируйте его, чтобы получить благословение Карпа-Си."
	icon = 'icons/obj/plushes.dmi'
	icon_state = "carpplush"
	inhand_icon_state = "carp_plushie"
	worn_icon_state = "nullrod"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	force = 15
	attack_verb_continuous = list("кусает", "грызёт", "шлёпает плавником")
	attack_verb_simple = list("кусает", "грызёт", "шлёпает плавником")
	hitsound = 'sound/weapons/bite.ogg'

/obj/item/nullrod/carp/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/faction_granter, "carp", holy_role_required = HOLY_ROLE_PRIEST, grant_message = span_boldnotice("You are blessed by Carp-Sie. Wild space carp will no longer attack you."))

/obj/item/nullrod/claymore/bostaff //May as well make it a "claymore" and inherit the blocking
	name = "посох монаха"
	desc = "Длинный высокий посох из полированного дерева. Традиционно используемый в боевых искусствах древней Земли, теперь он используется для преследования клоуна."
	w_class = WEIGHT_CLASS_BULKY
	force = 15
	block_chance = 40
	slot_flags = ITEM_SLOT_BACK
	sharpness = NONE
	hitsound = "swing_hit"
	attack_verb_continuous = list("сносит", "бьёт", "колотит", "стучит")
	attack_verb_simple = list("сносит", "бьёт", "колотит", "стучит")
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "bostaff0"
	inhand_icon_state = "bostaff0"
	worn_icon_state = "bostaff0"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'

/obj/item/nullrod/tribal_knife
	icon_state = "аритмический нож"
	desc = "Они говорят, что страх — настоящий убийца разума, но удар ножом в голову тоже работает. Честь обязывает не вкладывать в ножны однажды обнажив."
	inhand_icon_state = "crysknife"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "arrhythmic knife"
	w_class = WEIGHT_CLASS_HUGE
	sharpness = SHARP_EDGED
	slot_flags = null
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("атакует", "режет", "кромсает", "нарезает", "протыкает", "втыкает", "разрезает", "мясит")
	attack_verb_simple = list("атакует", "режет", "кромсает", "нарезает", "протыкает", "втыкает", "разрезает", "мясит")
	item_flags = SLOWS_WHILE_IN_HAND

/obj/item/nullrod/tribal_knife/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	AddComponent(/datum/component/butchering, 50, 100)

/obj/item/nullrod/tribal_knife/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/nullrod/tribal_knife/process()
	slowdown = rand(-10, 10)/10
	if(iscarbon(loc))
		var/mob/living/carbon/wielder = loc
		if(wielder.is_holding(src))
			wielder.update_equipment_speed_mods()

/obj/item/nullrod/pitchfork
	name = "нечестивые вилы"
	desc = "Держа это, ты выглядишь абсолютно по дьявольски."
	icon_state = "pitchfork0"
	worn_icon_state = "pitchfork0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	worn_icon_state = "pitchfork0"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("насаживает", "пробивает", "втыкает", "макаронит")
	attack_verb_simple = list("насаживает", "пробивает", "втыкает", "макаронит")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED

/obj/item/nullrod/egyptian
	name = "египетский посох"
	desc = "На посохе вырезано руководство по мумификации. Вы, вероятно, могли бы изготовить обертки, если бы у вас была ткань."
	icon = 'icons/obj/guns/magic.dmi'
	icon_state = "pharoah_sceptre"
	inhand_icon_state = "pharoah_sceptre"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	worn_icon_state = "pharoah_sceptre"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("лупит", "бьёт", "атакует")
	attack_verb_simple = list("лупит", "бьёт", "атакует")

/obj/item/nullrod/hypertool
	name = "гиперинструмент"
	desc = "Инструмент настолько мощный, что даже вы не можете им идеально пользоваться."
	icon = 'icons/obj/device.dmi'
	icon_state = "hypertool"
	inhand_icon_state = "hypertool"
	worn_icon_state = "hypertool"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	damtype = BRAIN
	armour_penetration = 35
	attack_verb_continuous = list("пульсирует", "спаивает", "режет")
	attack_verb_simple = list("пульсирует", "спаивает", "режет")
	hitsound = 'sound/effects/sparks4.ogg'

/obj/item/nullrod/spear
	name = "древнее копье"
	desc = "Старинное копье из латуни, то есть из золота, то есть из бронзы. Выглядит высокомеханичным."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "ratvarian_spear"
	inhand_icon_state = "ratvarian_spear"
	lefthand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	armour_penetration = 10
	sharpness = SHARP_POINTY
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_continuous = list("насаживает", "пробивает", "втыкает", "макаронит")
	attack_verb_simple = list("насаживает", "пробивает", "втыкает", "макаронит")
	hitsound = 'sound/weapons/bladeslice.ogg'
