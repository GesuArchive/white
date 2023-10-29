/datum/export/organ
	include_subtypes = FALSE	//CentCom doesn't need organs from non-humans.

/datum/export/organ/heart
	cost = CARGO_CRATE_VALUE * 0.2 //For the man who has everything and nothing.
	unit_name = "гуманоидное сердце"
	export_types = list(/obj/item/organ/heart)

/datum/export/organ/eyes
	cost = CARGO_CRATE_VALUE * 0.1
	unit_name = "гуманоидные глаза"
	export_types = list(/obj/item/organ/eyes)

/datum/export/organ/ears
	cost = CARGO_CRATE_VALUE * 0.1
	unit_name = "гуманоидные уши"
	export_types = list(/obj/item/organ/ears)

/datum/export/organ/liver
	cost = CARGO_CRATE_VALUE * 0.1
	unit_name = "гуманоидные печень"
	export_types = list(/obj/item/organ/liver)

/datum/export/organ/lungs
	cost = CARGO_CRATE_VALUE * 0.1
	unit_name = "гуманоидные легкие"
	export_types = list(/obj/item/organ/lungs)

/datum/export/organ/stomach
	cost = CARGO_CRATE_VALUE * 0.1
	unit_name = "гуманоидный желудок"
	export_types = list(/obj/item/organ/stomach)

/datum/export/organ/tongue
	cost = CARGO_CRATE_VALUE * 0.1
	unit_name = "гуманоидный язык"
	export_types = list(/obj/item/organ/tongue)

/datum/export/organ/tail/lizard
	cost = CARGO_CRATE_VALUE * 1.25
	unit_name = "хвост ящера"
	export_types = list(/obj/item/organ/tail/lizard)


/datum/export/organ/tail/cat
	cost = CARGO_CRATE_VALUE * 1.5
	unit_name = "хвост кота"
	export_types = list(/obj/item/organ/tail/cat)

/datum/export/organ/ears/cat
	cost = CARGO_CRATE_VALUE
	unit_name = "уши кота"
	export_types = list(/obj/item/organ/ears/cat)

