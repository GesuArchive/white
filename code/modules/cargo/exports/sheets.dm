/datum/export/stack
	unit_name = "лист"

/datum/export/stack/get_amount(obj/O)
	var/obj/item/stack/S = O
	if(istype(S))
		return S.amount
	return 0

// Hides

/datum/export/stack/skin/monkey
	cost = 50
	unit_name = "шкура обезьяны"
	export_types = list(/obj/item/stack/sheet/animalhide/monkey)

/datum/export/stack/skin/human
	cost = 100
	export_category = EXPORT_CONTRABAND
	unit_name = "кусок"
	message = "человеческой кожи"
	export_types = list(/obj/item/stack/sheet/animalhide/human)

/datum/export/stack/skin/goliath_hide
	cost = 200
	unit_name = "шкура голиафа"
	export_types = list(/obj/item/stack/sheet/animalhide/goliath_hide)

/datum/export/stack/skin/cat
	cost = 150
	export_category = EXPORT_CONTRABAND
	unit_name = "кошачья шкура"
	export_types = list(/obj/item/stack/sheet/animalhide/cat)

/datum/export/stack/skin/corgi
	cost = 200
	export_category = EXPORT_CONTRABAND
	unit_name = "шкура корги"
	export_types = list(/obj/item/stack/sheet/animalhide/corgi)

/datum/export/stack/skin/lizard
	cost = 150
	unit_name = "шкура ящерицы"
	export_types = list(/obj/item/stack/sheet/animalhide/lizard)

/datum/export/stack/skin/gondola
	cost = 5000
	unit_name = "шкура гондолы"
	export_types = list(/obj/item/stack/sheet/animalhide/gondola)

/datum/export/stack/skin/xeno
	cost = 500
	unit_name = "шкура ксеноса"
	export_types = list(/obj/item/stack/sheet/animalhide/xeno)

/datum/export/stack/licenseplate
	cost = 25
	unit_name = "номерной знак"
	export_types = list(/obj/item/stack/license_plates/filled)


// Common materials.
// For base materials, see materials.dm

/datum/export/stack/plasteel
	cost = 155 // 2000u of plasma + 2000u of metal.
	message = "пластали"
	export_types = list(/obj/item/stack/sheet/plasteel)

// 1 glass + 0.5 metal, cost is rounded up.
/datum/export/stack/rglass
	cost = 8
	message = "армированного стекла"
	export_types = list(/obj/item/stack/sheet/rglass)

/datum/export/stack/plastitanium
	cost = 325 // plasma + titanium costs
	message = "пластитана"
	export_types = list(/obj/item/stack/sheet/mineral/plastitanium)

/datum/export/stack/wood
	cost = 30
	unit_name = "деревянных досок"
	export_types = list(/obj/item/stack/sheet/mineral/wood)

/datum/export/stack/cardboard
	cost = 2
	message = "картона"
	export_types = list(/obj/item/stack/sheet/cardboard)

/datum/export/stack/sandstone
	cost = 1
	unit_name = "блоков"
	message = "песчаника"
	export_types = list(/obj/item/stack/sheet/mineral/sandstone)

/datum/export/stack/cable
	cost = 0.2
	unit_name = "кабеля"
	export_types = list(/obj/item/stack/cable_coil)

/datum/export/stack/ammonia_crystals
	cost = 25
	unit_name = "кристалла аммиака"
	export_types = list(/obj/item/stack/ammonia_crystals)

// Weird Stuff

/datum/export/stack/abductor
	cost = 1000
	message = "инопланетного сплава"
	export_types = list(/obj/item/stack/sheet/mineral/abductor)
