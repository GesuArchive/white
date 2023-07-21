///Fish feed can
/obj/item/fish_feed
	name = "банка корма для рыб"
	desc = "Автоматически генерирует питательный корм для рыб на основе образца, находящегося внутри."
	icon = 'icons/obj/aquarium.dmi'
	icon_state = "fish_feed"
	w_class = WEIGHT_CLASS_TINY

/obj/item/fish_feed/Initialize(mapload)
	. = ..()
	create_reagents(5, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/consumable/nutriment, 1) //Default fish diet

///Stasis fish case container for moving fish between aquariums safely.
/obj/item/storage/fish_case
	name = "стазисный кейс для рыб"
	desc = "Маленький футляр, в котором рыба находится в стазисе."
	icon_state = "fishbox"

	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

/obj/item/storage/fish_case/Initialize(mapload)
	ADD_TRAIT(src, TRAIT_FISH_SAFE_STORAGE, TRAIT_GENERIC) // Before populate so fish instatiates in ready container already
	. = ..()
	create_storage(max_slots = 1)
	atom_storage.can_hold_trait = TRAIT_FISH_CASE_COMPATIBILE
	atom_storage.can_hold_description = "оборудование для рыб и аквариумов"

///Fish case with single random fish inside.
/obj/item/storage/fish_case/random/PopulateContents()
	. = ..()
	var/fish_type = select_fish_type()
	new fish_type(src)

/obj/item/storage/fish_case/random/proc/select_fish_type()
	return random_fish_type()

/obj/item/storage/fish_case/random/freshwater/select_fish_type()
	return random_fish_type(required_fluid=AQUARIUM_FLUID_FRESHWATER)

/obj/item/storage/fish_case/random/saltwater/select_fish_type()
	return random_fish_type(required_fluid=AQUARIUM_FLUID_SALTWATER)

/obj/item/storage/fish_case/syndicate
	name = "зловещий кейс для рыб"

/obj/item/storage/fish_case/syndicate/PopulateContents()
	. = ..()
	var/fish_type = pick(/obj/item/fish/donkfish, /obj/item/fish/emulsijack)
	new fish_type(src)

/obj/item/storage/fish_case/tiziran
	name = "импортный кейс для рыб"

/obj/item/storage/fish_case/tiziran/PopulateContents()
	. = ..()
	var/fish_type = pick(/obj/item/fish/dwarf_moonfish, /obj/item/fish/gunner_jellyfish, /obj/item/fish/needlefish, /obj/item/fish/armorfish)
	new fish_type(src)

/obj/item/aquarium_kit
	name = "Набор для строительства аквариума своими руками"
	desc = "Все, что вам нужно для создания вашего собственного аквариума. Рыба в комплект не входит."
	icon = 'icons/obj/aquarium.dmi'
	icon_state = "construction_kit"
	w_class = WEIGHT_CLASS_TINY

/obj/item/aquarium_kit/attack_self(mob/user)
	. = ..()
	to_chat(user,span_notice("Внутри есть инструкция и инструменты, необходимые для постройки аквариума. Все, что вам нужно, это начать создавать."))


/obj/item/aquarium_prop
	name = "универсальный реквизит для аквариума"
	desc = "очень скучно"
	icon = 'icons/obj/aquarium.dmi'

	w_class = WEIGHT_CLASS_TINY
	var/layer_mode = AQUARIUM_LAYER_MODE_BOTTOM

/obj/item/aquarium_prop/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/aquarium_content)

/obj/item/aquarium_prop/rocks
	name = "камушки"
	icon_state = "rocks"

/obj/item/aquarium_prop/seaweed_top
	name = "густые водоросли"
	icon_state = "seaweeds_front"
	layer_mode = AQUARIUM_LAYER_MODE_TOP

/obj/item/aquarium_prop/seaweed
	name = "морские водоросли"
	icon_state = "seaweeds_back"
	layer_mode = AQUARIUM_LAYER_MODE_BOTTOM

/obj/item/aquarium_prop/rockfloor
	name = "каменное дно"
	icon_state = "rockfloor"
	layer_mode = AQUARIUM_LAYER_MODE_BOTTOM

/obj/item/aquarium_prop/treasure
	name = "крошечный сундучок с сокровищами"
	icon_state = "treasure"
	layer_mode = AQUARIUM_LAYER_MODE_BOTTOM

/obj/item/storage/box/aquarium_props
	name = "коробка для аквариумного реквизита"
	desc = "Все, что вам нужно для того, чтобы ваш аквариум хорошо выглядел."

/obj/item/storage/box/aquarium_props/PopulateContents()
	for(var/prop_type in subtypesof(/obj/item/aquarium_prop))
		new prop_type(src)
