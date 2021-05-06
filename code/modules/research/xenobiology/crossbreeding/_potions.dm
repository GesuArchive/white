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
		to_chat(user, "<span class='warning'>[target] слишком сложный чтобы быть клонированным зельем!</span>")
		return
	if(!istype(target, /obj/item/slime_extract))
		return
	var/obj/item/slime_extract/S = target
	if(S.recurring)
		to_chat(user, "<span class='warning'>[target] слишком сложный чтобы быть клонированным зельем!</span>")
		return
	var/path = S.type
	var/obj/item/slime_extract/C = new path(get_turf(target))
	C.Uses = S.Uses
	to_chat(user, "<span class='notice'>Выливаю зелье на [target], и жидкость превращается в его копию!</span>")
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
		to_chat(user, "<span class='warning'>[capitalize(src.name)] работает только на одушевленных.</span>")
		return ..()
	if(istype(M, /mob/living/simple_animal/hostile/megafauna))
		to_chat(user, "<span class='warning'>[capitalize(src.name)] не работает на созданий сущего зла!</span>")
		return ..()
	if(M != user)
		M.visible_message("<span class='danger'>[user] начинает кормить [M] [src]!</span>",
			"<span class='userdanger'>[user] начинает кормить меня [src]!</span>")
	else
		M.visible_message("<span class='danger'>[user] начинает пить [src]!</span>",
			"<span class='danger'>Начинаю пить [src]!</span>")

	if(!do_after(user, 100, target = M))
		return
	if(M != user)
		to_chat(user, "<span class='notice'>Кормлю [M] [src]!</span>")
	else
		to_chat(user, "<span class='warning'>Пью [src]!</span>")
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
		to_chat(user, "<span class='warning'>Зелье любви работает только на одушевлённые вещи, псих!</span>")
		return ..()
	if(istype(M, /mob/living/simple_animal/hostile/megafauna))
		to_chat(user, "<span class='warning'>Зелье любви не работает на созданий сущего зла!</span>")
		return ..()
	if(user == M)
		to_chat(user, "<span class='warning'>Нельзя выпить зелье любви, если ты только не самовлюблённый.</span>")
		return ..()
	if(M.has_status_effect(STATUS_EFFECT_INLOVE))
		to_chat(user, "<span class='warning'>[M] уже влюблён!</span>")
		return ..()

	M.visible_message("<span class='danger'>[user] начинает поить [M] зельем любви!</span>",
		"<span class='userdanger'>[user] начинает поить тебя зельем любви!</span>")

	if(!do_after(user, 50, target = M))
		return
	to_chat(user, "<span class='notice'>Пою [M] зельем любви!</span>")
	to_chat(M, "<span class='notice'>Чувства к [user] усилились, и к другим [user.ru_who()] подобным.</span>")
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
		to_chat(user, "<span class='warning'>Зелье может быть использовано только на одежду!</span>")
		return
	if(istype(C, /obj/item/clothing/suit/space))
		to_chat(user, "<span class='warning'>[C] уже устойчив к давлению!</span>")
		return ..()
	if(C.min_cold_protection_temperature == SPACE_SUIT_MIN_TEMP_PROTECT && C.clothing_flags & STOPSPRESSUREDAMAGE)
		to_chat(user, "<span class='warning'>[C] уже устойчив к давлению!</span>")
		return ..()
	to_chat(user, "<span class='notice'>Наношу зелье на [C], делая её герметичной.</span>")
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
	name = "extract maximizer"
	desc = "An extremely potent chemical mix that will maximize a slime extract's uses."
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
		to_chat(user, "<span class='warning'>Невозможно покрыть это зельем огнестойкости!</span>")
		return ..()
	to_chat(user, "<span class='notice'>Наношу красную слизь на [C], делая её лавоупорной.</span>")
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
		to_chat(user, "<span class='warning'>Можно применить только на слаймов!</span>")
		return ..()
	if(M.stat != DEAD)
		to_chat(user, "<span class='warning'>Этот слайм ещё живой!</span>")
		return
	if(M.maxHealth <= 0)
		to_chat(user, "<span class='warning'>Слайм слишком нестабилен, чтобы воскреснуть!</span>")
	M.revive(full_heal = TRUE, admin_revive = FALSE)
	M.set_stat(CONSCIOUS)
	M.visible_message("<span class='notice'>[M] наполнен зельем и открывает глаза!</span>")
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
		to_chat(user, "<span class='warning'>The stabilizer only works on slimes!</span>")
		return ..()
	if(M.stat)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return
	if(M.mutation_chance == 0)
		to_chat(user, "<span class='warning'>The slime already has no chance of mutating!</span>")
		return

	to_chat(user, "<span class='notice'>You feed the slime the omnistabilizer. It will not mutate this cycle!</span>")
	M.mutation_chance = 0
	qdel(src)
