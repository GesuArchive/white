/*****************Pickaxes & Drills & Shovels****************/
/obj/item/pickaxe
	name = "кирка"
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 15
	throwforce = 10
	inhand_icon_state = "pickaxe"
	worn_icon_state = "pickaxe"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron=2000) //one sheet, but where can you make them?
	tool_behaviour = TOOL_MINING
	toolspeed = 1
	usesound = list('sound/effects/picaxe1.ogg', 'sound/effects/picaxe2.ogg', 'sound/effects/picaxe3.ogg')
	attack_verb_continuous = list("бьёт", "протыкает", "рубит", "атакует")
	attack_verb_simple = list("бьёт", "протыкает", "рубит", "атакует")

/obj/item/pickaxe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging into [user.ru_ego()] chest! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/pickaxe/rusted
	name = "ржавая кирка"
	desc = "Кирка, оставленная ржаветь."
	attack_verb_continuous = list("ineffectively hits")
	attack_verb_simple = list("ineffectively hit")
	force = 1
	throwforce = 1

/obj/item/pickaxe/mini
	name = "компактная кирка"
	desc = "Меньшая, компактная версия стандартной кирки."
	icon_state = "minipick"
	worn_icon_state = "pickaxe"
	force = 10
	throwforce = 7
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=1000)

/obj/item/pickaxe/silver
	name = "посеребренная кирка"
	icon_state = "spickaxe"
	inhand_icon_state = "spickaxe"
	worn_icon_state = "spickaxe"
	toolspeed = 0.5 //mines faster than a normal pickaxe, bought from mining vendor
	desc = "Посеребренная кирка, которая добывает немного быстрее, чем стандартная."
	force = 17

/obj/item/pickaxe/diamond
	name = "кирка с алмазным наконечником"
	icon_state = "dpickaxe"
	inhand_icon_state = "dpickaxe"
	worn_icon_state = "dpickaxe"
	toolspeed = 0.3
	desc = "Кирка с алмазной головкой. Чрезвычайно устойчива к растрескиванию каменных стен и выкапыванию грязи."
	force = 19

/obj/item/pickaxe/drill
	name = "шахтёрский бур"
	icon_state = "handdrill"
	inhand_icon_state = "jackhammer"
	worn_icon_state = "jackhammer"
	slot_flags = ITEM_SLOT_BELT
	toolspeed = 0.6 //available from roundstart, faster than a pickaxe.
	usesound = 'sound/weapons/drill.ogg'
	hitsound = 'sound/weapons/drill.ogg'
	desc = "Электрическая буровая установка для особо худых."

/obj/item/pickaxe/drill/cyborg
	name = "шахтёрский бур киборга"
	desc = "Интегрированная электрическая буровая установка."
	flags_1 = NONE

/obj/item/pickaxe/drill/cyborg/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CYBORG_ITEM_TRAIT)

/obj/item/pickaxe/drill/diamonddrill
	name = "бур с алмазным напылением"
	icon_state = "diamonddrill"
	toolspeed = 0.2
	desc = "Твой бур пронзит небеса!"

/obj/item/pickaxe/drill/cyborg/diamond //This is the BORG version!
	name = "бур с алмазным напылением киборга" //To inherit the NODROP_1 flag, and easier to change borg specific drill mechanics.
	icon_state = "diamonddrill"
	toolspeed = 0.2

/obj/item/pickaxe/drill/jackhammer
	name = "звуковой пневмоперфоратор"
	icon_state = "jackhammer"
	inhand_icon_state = "jackhammer"
	worn_icon_state = "jackhammer"
	toolspeed = 0.1 //the epitome of powertools. extremely fast mining
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'
	desc = "Cracks rocks with sonic blasts."

/obj/item/pickaxe/improvised
	name = "импровизированная кирка"
	desc = "Кирка, сделанная из ножа и лома, склеенных вместе, как она не ломается?"
	icon_state = "ipickaxe"
	inhand_icon_state = "ipickaxe"
	worn_icon_state = "pickaxe"
	force = 10
	throwforce = 7
	toolspeed = 3 //3 times slower than a normal pickaxe
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=12050) //metal needed for a crowbar and for a knife, why the FUCK does a knife cost 6 metal sheets while a crowbar costs 0.025 sheets? shit makes no sense fuck this

/obj/item/shovel
	name = "лопата"
	desc = "Большой инструмент для копания и перемещения грязи."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	worn_icon_state = "shovel"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 8
	tool_behaviour = TOOL_SHOVEL
	toolspeed = 1
	usesound = 'sound/effects/shovel_dig.ogg'
	throwforce = 4
	inhand_icon_state = "shovel"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=50)
	attack_verb_continuous = list("колотит", "ударяет", "колошматит", "вмазывает")
	attack_verb_simple = list("колотит", "ударяет", "колошматит", "вмазывает")
	sharpness = SHARP_EDGED

/obj/item/shovel/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 150, 40) //it's sharp, so it works, but barely.

/obj/item/shovel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging their own grave! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/shovel/spade
	name = "лопаточка"
	desc = "Небольшой инструмент для рытья и перемещения грязи."
	icon_state = "spade"
	inhand_icon_state = "spade"
	worn_icon_state = "spade"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL

/obj/item/shovel/serrated
	name = "зубчатая костяная лопата"
	desc = "Коварный инструмент, который пробивает грязь так же легко, как и плоть. Дизайн был выполнен в стиле древних племен Лаваленда."
	icon_state = "shovel_bone"
	inhand_icon_state = "shovel_bone"
	worn_icon_state = "shovel_serr"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	force = 15
	throwforce = 12
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7
	attack_verb_continuous = list("slashes", "impales", "stabs", "slices")
	attack_verb_simple = list("slash", "impale", "stab", "slice")
	sharpness = SHARP_EDGED
