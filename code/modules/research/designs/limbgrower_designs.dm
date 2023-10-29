/////////////////////////////////////
//////////Limb Grower Designs ///////
/////////////////////////////////////

/datum/design/leftarm
	name = "Левая Рука"
	id = "leftarm"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/l_arm
	category = list("initial","human","lizard","moth","plasmaman","ethereal")

/datum/design/rightarm
	name = "Правая Рука"
	id = "rightarm"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/r_arm
	category = list("initial","human","lizard","moth","plasmaman","ethereal")

/datum/design/leftleg
	name = "Левая Нога"
	id = "leftleg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/l_leg
	category = list("initial","human","lizard","moth","plasmaman","ethereal")

/datum/design/rightleg
	name = "Правая Нога"
	id = "rightleg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/r_leg
	category = list("initial","human","lizard","moth","plasmaman","ethereal")

/datum/design/digi_leftleg
	name = "Чешуйчатая Левая Нога"
	id = "digi_leftleg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 30)
	build_path = /obj/item/bodypart/l_leg/digitigrade
	category = list("lizard")

/datum/design/digi_rightleg
	name = "Чешуйчатая Правая Нога"
	id = "digi_rightleg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 30)
	build_path = /obj/item/bodypart/r_leg/digitigrade
	category = list("lizard")

//Non-limb limb designs

/datum/design/heart
	name = "Сердце"
	id = "heart"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 30)
	build_path = /obj/item/organ/heart
	category = list("human","initial")

/datum/design/lungs
	name = "Легкие"
	id = "lungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/lungs
	category = list("human","initial")

/datum/design/liver
	name = "Печень"
	id = "liver"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/liver
	category = list("human","initial")

/datum/design/stomach
	name = "Желудок"
	id = "stomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 15)
	build_path = /obj/item/organ/stomach
	category = list("human","initial")

/datum/design/appendix
	name = "Аппендикс"
	id = "appendix"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 5) //why would you need this
	build_path = /obj/item/organ/appendix
	category = list("human","initial")

/datum/design/eyes
	name = "Глаза"
	id = "eyes"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/eyes
	category = list("human","initial")

/datum/design/ears
	name = "Уши"
	id = "ears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/ears
	category = list("human","initial")

/datum/design/tongue
	name = "Язык"
	id = "tongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/tongue
	category = list("human","initial")

// Grows a fake lizard tail - not usable in lizard wine and other similar recipes.
/datum/design/lizard_tail
	name = "Хвост Ящера"
	id = "liztail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/lizard/fake
	category = list("lizard")

/datum/design/lizard_tongue
	name = "Раздвоенный Язык"
	id = "liztongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tongue/lizard
	category = list("lizard")

/datum/design/monkey_tail
	name = "Обезьяний Хвост"
	id = "monkeytail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/monkey
	category = list("other","initial")

/datum/design/cat_tail
	name = "Кошачий Хвост"
	id = "cattail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/cat
	category = list("human")

/datum/design/cat_ears
	name = "Кошачьи Уши"
	id = "catears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/ears/cat
	category = list("human")

/datum/design/plasmaman_lungs
	name = "Плазменный Фильтр"
	id = "plasmamanlungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/lungs/plasmaman
	category = list("plasmaman")

/datum/design/plasmaman_tongue
	name = "Плазменный Костяной Язык"
	id = "plasmamantongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/tongue/bone/plasmaman
	category = list("plasmaman")

/datum/design/plasmaman_liver
	name = "Кристалл для обработки реагентов"
	id = "plasmamanliver"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/liver/plasmaman
	category = list("plasmaman")

/datum/design/plasmaman_stomach
	name = "Пищеварительный кристалл"
	id = "plasmamanstomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/stomach/bone/plasmaman
	category = list("plasmaman")

/datum/design/ethereal_stomach
	name = "Биохимическая батарея"
	id = "etherealstomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity = 20)
	build_path = /obj/item/organ/stomach/ethereal
	category = list("ethereal")

/datum/design/ethereal_tongue
	name = "Электрический разрядник"
	id = "etherealtongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity = 20)
	build_path = /obj/item/organ/tongue/ethereal
	category = list("ethereal")

// Intentionally not growable by normal means - for balance conerns.
/datum/design/ethereal_heart
	name = "Кристаллическое ядро"
	id = "etherealheart"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity = 20)
	build_path = /obj/item/organ/heart/ethereal
	category = list("ethereal")

/datum/design/armblade
	name = "Рука-лезвие"
	id = "armblade"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 75)
	build_path = /obj/item/melee/synthetic_arm_blade
	category = list("other","emagged")

/// Design disks and designs - for adding limbs and organs to the limbgrower.
/obj/item/disk/design_disk/limbs
	name = "диск для биосинтезатора"
	desc = "Диск, содержащий данные для выращивания конечностей и органов для Биосинтезатора."
	icon_state = "datadisk1"
	/// List of all limb designs this disk contains.
	var/list/limb_designs = list()

/obj/item/disk/design_disk/limbs/Initialize(mapload)
	. = ..()
	max_blueprints = limb_designs.len
	for(var/design in limb_designs)
		var/datum/design/new_design = design
		blueprints += new new_design

/datum/design/limb_disk
	name = "Диск для Биосинтезатора"
	desc = "Диск, содержащий данные для выращивания конечностей и органов для Биосинтезатора."
	id = "limbdesign_parent"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100)
	build_path = /obj/item/disk/design_disk/limbs
	category = list("Medical Designs", "Медицинское оборудование")
	sub_category = list("Програмное обеспечение")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/obj/item/disk/design_disk/limbs/felinid
	name = "Диск для Биосинтезатора (Фелиниды)"
	limb_designs = list(/datum/design/cat_tail, /datum/design/cat_ears)

/datum/design/limb_disk/felinid
	name = "Диск для Биосинтезатора (Фелиниды)"
	desc = "Contains designs for felinid bodyparts for the limbgrower - Felinid ears and tail."
	id = "limbdesign_felinid"
	build_path = /obj/item/disk/design_disk/limbs/felinid

/obj/item/disk/design_disk/limbs/lizard
	name = "Диск для Биосинтезатора (Ящеры)"
	limb_designs = list(/datum/design/lizard_tail, /datum/design/lizard_tongue, /datum/design/digi_leftleg, /datum/design/digi_rightleg)

/datum/design/limb_disk/lizard
	name = "Диск для Биосинтезатора (Ящеры)"
	desc = "Contains designs for lizard bodyparts for the limbgrower - Lizard tongue, tail, and digitigrade legs."
	id = "limbdesign_lizard"
	build_path = /obj/item/disk/design_disk/limbs/lizard

/obj/item/disk/design_disk/limbs/plasmaman
	name = "Диск для Биосинтезатора (Плазмены)"
	limb_designs = list(/datum/design/plasmaman_stomach, /datum/design/plasmaman_liver, /datum/design/plasmaman_lungs, /datum/design/plasmaman_tongue)

/datum/design/limb_disk/plasmaman
	name = "Диск для Биосинтезатора (Плазмены)"
	desc = "Contains designs for plasmaman organs for the limbgrower - Plasmaman tongue, liver, stomach, and lungs."
	id = "limbdesign_plasmaman"
	build_path = /obj/item/disk/design_disk/limbs/plasmaman

/obj/item/disk/design_disk/limbs/ethereal
	name = "Диск для Биосинтезатора (Этериалы)"
	limb_designs = list(/datum/design/ethereal_stomach, /datum/design/ethereal_tongue)

/datum/design/limb_disk/ethereal
	name = "Диск для Биосинтезатора (Этериалы)"
	desc = "Contains designs for ethereal organs for the limbgrower - Ethereal tongue and stomach."
	id = "limbdesign_ethereal"
	build_path = /obj/item/disk/design_disk/limbs/ethereal
