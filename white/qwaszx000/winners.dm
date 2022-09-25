#define ENGINEER_WINER_CKEY "Laxesh"
#define ROBUST_WINER_CKEY "Chituka09" // 2022 2. Old winner is Zarri. 2022. Old winner is Jzouz. 2021. Old winner is Moonmandoom. 2020. Old winner is DarkKeeper072

/obj/item/extinguisher/robust
	name = "мощный огнетушитель"
	desc = "Использовался для убийства людей."
	icon_state = "foam_extinguisher0"
	inhand_icon_state = "foam_extinguisher"
	dog_fashion = null
	sprite_name = "foam_extinguisher"
	throwforce = 15
	force = 15
	precision = TRUE
	can_explode = FALSE


/obj/item/clothing/neck/cloak/engineer_winer
	name = "плащ эксперта в инженерных областях"
	desc = "Trust me - i'm an ENGINEER!!!"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 5, "energy" = 10, "bomb" = 20, "bio" = 10, "rad" = 50, "fire" = 20, "acid" = 20)
	icon_state = "cecloak"


/obj/structure/displaycase/winner
	name = "витрина славы"
	desc = "Витрина для ценных вещей. Имеет небольшой дактильный замок сбоку - made by qwaszx000."
	var/winner_key = null

/obj/structure/displaycase/winner/Initialize(mapload)
	. = ..()
	if(start_showpieces.len > 0)
		if("trophy_message" in start_showpieces)
			trophy_message = start_showpieces["trophy_message"]
		if("winner_key" in start_showpieces)
			winner_key = start_showpieces["winner_key"]
		if("type" in start_showpieces)
			if(showpiece)
				QDEL_NULL(showpiece)
			start_showpiece_type = start_showpieces["type"]
			showpiece = new start_showpiece_type (src)
			update_icon()

/obj/structure/displaycase/winner/obj_break(damage_flag)
	. = ..()
	if(broken && !(flags_1 & NODECONSTRUCT_1))
		src.Destroy()
		QDEL_NULL(src)

/obj/structure/displaycase/winner/attackby(obj/item/W, mob/user, params)
	if(open && !showpiece)
		if(user.transferItemToLoc(W, src))
			showpiece = W
			to_chat(user, span_notice("Ставлю [W] в витрину."))
			update_icon()
	else if(W.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP && !broken)
		if(obj_integrity < max_integrity)
			if(!W.tool_start_check(user, amount=5))
				to_chat(user, span_warning("Нет топлива!"))
				return
			to_chat(user, span_notice("Начинаю чинить [src]."))
			if(W.use_tool(src, user, 40, amount=5, volume=50))
				obj_integrity = max_integrity
				update_icon()
				to_chat(user, span_notice("Чиню [src]."))
				return
		else
			to_chat(user, span_warning("[capitalize(src.name)] уже в отличном состоянии!"))
			return
	else if(W.GetID() && !broken && openable)
		to_chat(user, span_warning("Имеет защиту по отпечатку пальца! Не ID!"))
		return
	else
		return ..()

/obj/structure/displaycase/winner/attack_hand(mob/user)
	if(ckey(user.ckey) == ckey(winner_key) && !broken && openable)
		to_chat(user,  span_notice("[open ? "Закрываю":"Открываю"] [src]."))
		toggle_lock(user)
	else
		to_chat(user, span_warning("Лузер."))

/obj/structure/displaycase/winner/AltClick(mob/user)
	if(open)
		dump()
		update_icon()

/obj/structure/displaycase/winner/robust
	winner_key = ROBUST_WINER_CKEY
	start_showpieces = list(list("type" = /obj/item/extinguisher/robust, "trophy_message" = "Слава <span class='boldnotice'>" + ROBUST_WINER_CKEY + "</span>!", "winner_key" = ROBUST_WINER_CKEY))

/obj/structure/displaycase/winner/engineer
	start_showpieces = list(list("type" = /obj/item/clothing/neck/cloak/engineer_winer, "trophy_message" = "Слава <span class='boldnotice'>" + ENGINEER_WINER_CKEY + "</span>!", "winner_key" = ENGINEER_WINER_CKEY))

/obj/structure/statue/gold/robust
	name = "Статуя: Алексия Истер и Андрей Ершов"
	desc = "Победитель осеннего робаст-турнира 2022. Надпись гласит: \"Битва за мать Редкокса\".<hr><b>Chituka09</b> - первое место осеннего турнира!"
	icon = 'white/kacherkin/icons/robust_statue.dmi'
	icon_state = "robust_2023"
	can_be_unanchored = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = ABOVE_MOB_LAYER
	density = FALSE
	anchored = TRUE
	flags_1 = NODECONSTRUCT_1
	pixel_x = -8
	var/list/coomers = list()

/obj/structure/statue/gold/robust/attack_hand(mob/user)
	. = ..()
	if(!(user.name in coomers))
		if(isliving(user))
			inc_metabalance(user, 1, TRUE)
			visible_message(span_noticeital("[user] кланяется статуе!"))
			coomers += user.name

/obj/structure/statue/gold/robust/examine_more(mob/user)
	if(coomers)
		return "<hr><b>Уважение проявили:</b> <i>[english_list(coomers)]</i>."

/obj/structure/sign/plaques/robust
	name = "Портрет: Норман Норманс"
	desc = "Мудилла на электрике.<hr><b>TheLone</b> - второе место осеннего турнира!"
	icon = 'white/valtos/icons/robust.dmi'
	icon_state = "silver_2022_2"
	can_be_unanchored = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	custom_materials = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT*2)
	flags_1 = NODECONSTRUCT_1
	var/list/coomers = list()

/obj/structure/sign/plaques/robust/examine_more(mob/user)
	. = ..()
	if(coomers)
		. += "<hr><b>Уважение проявили:</b> <i>[english_list(coomers)]</i>."

/obj/structure/sign/plaques/robust/attack_hand(mob/user)
	. = ..()
	if(!(user.name in coomers))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.end_dance(null, null)
			coomers += user.name

/obj/structure/sign/plaques/robust/bronze
	name = "Портрет: Estrella Picard"
	desc = "Глядя на портрет вы чувствуете себя в надежных руках.<hr><b>Alex971</b> - третье место осеннего турнира!"
	icon_state = "bronze_2022_2"
	custom_materials = list(/datum/material/bronze=MINERAL_MATERIAL_AMOUNT*2)
	flags_1 = NODECONSTRUCT_1

/obj/structure/sign/plaques/robust/bronze/duo
	name = "Портрет: Charlotte Wiltshire"
	desc = "Оставайтесь чисто белыми!<hr><b>Kamenshik13</b> - третье место осеннего турнира!"
	icon_state = "bronze_2022_3"
