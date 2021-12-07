/obj/item/reagent_containers/chem_pack
	name = "пакет для внутривенного введения лекарств"
	desc = "Пластиковый пакет под давлением, также известный как 'химпакет' используемый для внутривенного введения медикаментов. Он снабжен термостойкой полосой. Объем 100 единиц."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "chempack"
	volume = 100
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	obj_flags = UNIQUE_RENAME
	resistance_flags = ACID_PROOF
	var/sealed = FALSE
	fill_icon_thresholds = list(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

/obj/item/reagent_containers/chem_pack/AltClick(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY) && !sealed)
		if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)))
			to_chat(user, span_warning("Ух.. бля! Я случайно разлил содержимое пакета прямо на себя."))
			SplashReagents(user)
			return

		reagents.flags = NONE
		reagent_flags = DRAWABLE | INJECTABLE //To allow for sabotage or ghetto use.
		reagents.flags = reagent_flags
		spillable = FALSE
		sealed = TRUE
		to_chat(user, span_notice("Запечатал пакет."))

/obj/item/reagent_containers/chem_pack/examine()
	. = ..()
	if(sealed)
		. += "<hr><span class='notice'>Пакет запечатан.</span>"
	else
		. += "<hr><span class='notice'>Alt+ЛКМ для того чтобы запечатать.</span>"


/obj/item/reagent_containers/chem_pack/attack_self(mob/user)
	if(sealed)
		return
	..()
