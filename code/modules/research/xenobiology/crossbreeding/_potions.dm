/*
Slimecrossing Potions
	Potions added by the slimecrossing system.
	Collected here for clarity.
*/

//Extract cloner - Charged Grey
/obj/item/slimepotion/extract_cloner
	name = "экстракт зелья клонирования"
	desc = "Более мощная версия зелья усиления экстракта, способная клонировать обычные экстракты слизи."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "potpurple"

/obj/item/slimepotion/extract_cloner/afterattack(obj/item/target, mob/user , proximity)
	if(!proximity)
		return
	if(istype(target, /obj/item/reagent_containers))
		return ..(target, user, proximity)
	if(istype(target, /obj/item/slimecross))
		to_chat(user, span_warning("[target] слишком сложный чтобы быть клонированным зельем!"))
		return
	if(!istype(target, /obj/item/slime_extract))
		return
	var/obj/item/slime_extract/S = target
	if(S.recurring)
		to_chat(user, span_warning("[target] слишком сложный чтобы быть клонированным зельем!"))
		return
	var/path = S.type
	var/obj/item/slime_extract/C = new path(get_turf(target))
	C.Uses = S.Uses
	to_chat(user, span_notice("Выливаю зелье на [target], и жидкость превращается в его копию!"))
	qdel(src)
	return

//Peace potion - Charged Light Pink
/obj/item/slimepotion/peacepotion
	name = "зелье успокоения"
	desc = "Светло-розовая смесь химикатов, пахнущая как жидкий мир. И соли ртути."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "potlightpink"

/obj/item/slimepotion/peacepotion/attack(mob/living/M, mob/user)
	if(!isliving(M) || M.stat == DEAD)
		to_chat(user, span_warning("[capitalize(src.name)] работает только на одушевленных."))
		return ..()
	if(istype(M, /mob/living/simple_animal/hostile/megafauna))
		to_chat(user, span_warning("[capitalize(src.name)] не работает на созданий сущего зла!"))
		return ..()
	if(M != user)
		M.visible_message(span_danger("[user] начинает кормить [M] [src]!") ,
			span_userdanger("[user] начинает кормить меня [src]!"))
	else
		M.visible_message(span_danger("[user] начинает пить [src]!") ,
			span_danger("Начинаю пить [src]!"))

	if(!do_after(user, 100, target = M))
		return
	if(M != user)
		to_chat(user, span_notice("Кормлю [M] [src]!"))
	else
		to_chat(user, span_warning("Пью [src]!"))
	if(isanimal(M))
		ADD_TRAIT(M, TRAIT_PACIFISM, MAGIC_TRAIT)
	else if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_SURGERY)
	qdel(src)

//Love potion - Charged Pink
/obj/item/slimepotion/lovepotion
	name = "зелье любви"
	desc = "Розовая химическая смесь, развивающая чувство любви."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "potpink"

/obj/item/slimepotion/lovepotion/attack(mob/living/M, mob/user)
	if(!isliving(M) || M.stat == DEAD)
		to_chat(user, span_warning("Зелье любви работает только на одушевлённые вещи, псих!"))
		return ..()
	if(istype(M, /mob/living/simple_animal/hostile/megafauna))
		to_chat(user, span_warning("Зелье любви не работает на созданий сущего зла!"))
		return ..()
	if(user == M)
		to_chat(user, span_warning("Нельзя выпить зелье любви, если ты только не самовлюблённый."))
		return ..()
	if(M.has_status_effect(STATUS_EFFECT_INLOVE))
		to_chat(user, span_warning("[M] уже влюблён!"))
		return ..()

	M.visible_message(span_danger("[user] начинает поить [M] зельем любви!") ,
		span_userdanger("[user] начинает поить тебя зельем любви!"))

	if(!do_after(user, 50, target = M))
		return
	to_chat(user, span_notice("Пою [M] зельем любви!"))
	to_chat(M, span_notice("Чувства к [user] усилились, и к другим [user.ru_who()] подобным."))
	if(M.mind)
		M.mind.store_memory("You are in love with [user].")
	M.faction |= "[REF(user)]"
	M.apply_status_effect(STATUS_EFFECT_INLOVE, user)
	qdel(src)

//Pressure potion - Charged Dark Blue
/obj/item/slimepotion/spaceproof
	name = "зелье стойкости к давлению"
	desc = "Сильный химический герметик, который сделает любую одежду герметичной. Имеет два применения."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "potblue"
	var/uses = 2

/obj/item/slimepotion/spaceproof/afterattack(obj/item/clothing/C, mob/user, proximity)
	. = ..()
	if(!uses)
		qdel(src)
		return
	if(!proximity)
		return
	if(!istype(C))
		to_chat(user, span_warning("Зелье может быть использовано только на одежду!"))
		return
	if(istype(C, /obj/item/clothing/suit/space))
		to_chat(user, span_warning("[C] уже устойчив к давлению!"))
		return ..()
	if(C.min_cold_protection_temperature == SPACE_SUIT_MIN_TEMP_PROTECT && C.clothing_flags & STOPSPRESSUREDAMAGE)
		to_chat(user, span_warning("[C] уже устойчив к давлению!"))
		return ..()
	to_chat(user, span_notice("Наношу зелье на [C], делая её герметичной."))
	C.name = "pressure-resistant [C.name]"
	C.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	C.add_atom_colour("#000080", FIXED_COLOUR_PRIORITY)
	C.min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	C.cold_protection = C.body_parts_covered
	C.clothing_flags |= STOPSPRESSUREDAMAGE
	uses--
	if(!uses)
		qdel(src)

//Enhancer potion - Charged Cerulean
/obj/item/slimepotion/enhancer/max
	name = "максимизатор экстракта"
	desc = "Чрезвычайно мощная химическая смесь, которая максимально эффективно использует экстракты слизи, значительно увеличивая количество применений."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "potpurple"

//Lavaproofing potion - Charged Red
/obj/item/slimepotion/lavaproof
	name = "зелье огнестойкости"
	desc = "Странная красноватая слизь отталкивает лаву, как воду, но при этом вас можно поджечь. Имеет два применения."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "potred"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	var/uses = 2

/obj/item/slimepotion/lavaproof/afterattack(obj/item/C, mob/user, proximity)
	. = ..()
	if(!uses)
		qdel(src)
		return ..()
	if(!proximity)
		return ..()
	if(!istype(C))
		to_chat(user, span_warning("Невозможно покрыть это зельем огнестойкости!"))
		return ..()
	to_chat(user, span_notice("Наношу красную слизь на [C], делая её лавоупорной."))
	C.name = "lavaproof [C.name]"
	C.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	C.add_atom_colour("#800000", FIXED_COLOUR_PRIORITY)
	C.resistance_flags |= LAVA_PROOF
	if (istype(C, /obj/item/clothing))
		var/obj/item/clothing/CL = C
		CL.clothing_flags |= LAVAPROTECT
	uses--
	if(!uses)
		qdel(src)

//Revival potion - Charged Grey
/obj/item/slimepotion/slime_reviver
	name = "зелье воскрешения слайма"
	desc = "Состоит из плазмы и пресованного геля. Возвращает мёртвых слаймов к жизни."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "potsilver"

/obj/item/slimepotion/slime_reviver/attack(mob/living/simple_animal/slime/M, mob/user)
	if(!isslime(M))
		to_chat(user, span_warning("Можно применить только на слаймов!"))
		return ..()
	if(M.stat != DEAD)
		to_chat(user, span_warning("Этот слайм ещё живой!"))
		return
	if(M.maxHealth <= 0)
		to_chat(user, span_warning("Слайм слишком нестабилен, чтобы воскреснуть!"))
	M.revive(full_heal = TRUE, admin_revive = FALSE)
	M.set_stat(CONSCIOUS)
	M.visible_message(span_notice("[M] наполнен зельем и открывает глаза!"))
	M.maxHealth -= 10 //Revival isn't healthy.
	M.health -= 10
	M.regenerate_icons()
	qdel(src)

//Stabilizer potion - Charged Blue
/obj/item/slimepotion/slime/chargedstabilizer
	name = "стабилизатор слайма"
	desc = "An extremely potent chemical mix that will stop a slime from mutating completely."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "potcyan"

/obj/item/slimepotion/slime/chargedstabilizer/attack(mob/living/simple_animal/slime/M, mob/user)
	if(!isslime(M))
		to_chat(user, span_warning("The stabilizer only works on slimes!"))
		return ..()
	if(M.stat)
		to_chat(user, span_warning("The slime is dead!"))
		return
	if(M.mutation_chance == 0)
		to_chat(user, span_warning("The slime already has no chance of mutating!"))
		return

	to_chat(user, span_notice("You feed the slime the omnistabilizer. It will not mutate this cycle!"))
	M.mutation_chance = 0
	qdel(src)
