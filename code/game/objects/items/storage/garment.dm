/obj/item/storage/bag/garment
	name = "сумка для одежды"
	icon = 'icons/obj/storage.dmi'
	icon_state = "garment_bag"
	desc = "Специально для хранения одежды."
	slot_flags = NONE
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/garment/captain
	name = "сумка для одежды капитана"

/obj/item/storage/bag/garment/hos
	name = "сумка для одежды начальника охраны"

/obj/item/storage/bag/garment/hop
	name = "сумка для одежды главы персонала"

/obj/item/storage/bag/garment/research_director
	name = "сумка для одежды научного руководителя"

/obj/item/storage/bag/garment/chief_medical
	name = "сумка для одежды главного врача"

/obj/item/storage/bag/garment/engineering_chief
	name = "сумка для одежды старшего инженера"

/obj/item/storage/bag/garment/Initialize()
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.numerical_stacking = FALSE
	atom_storage.max_total_storage = 200
	atom_storage.max_slots = 15
	atom_storage.insert_preposition = "в"
	atom_storage.set_holdable(list(
		/obj/item/clothing,
	))

/obj/item/storage/bag/garment/captain/PopulateContents()
	new /obj/item/clothing/under/rank/captain(src)
	new /obj/item/clothing/under/rank/captain/skirt(src)
	new /obj/item/clothing/under/rank/captain/parade(src)
	new /obj/item/clothing/suit/armor/vest/capcarapace(src)
	new /obj/item/clothing/suit/toggle/captains_parade(src)
	new /obj/item/clothing/suit/captunic(src)
	new /obj/item/clothing/glasses/sunglasses/gar/supergar(src)
	new /obj/item/clothing/gloves/color/captain(src)
	new /obj/item/clothing/head/caphat(src)
	new /obj/item/clothing/head/caphat/parade(src)
	new /obj/item/clothing/head/crown/fancy(src)
	new /obj/item/clothing/neck/cloak/cap(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/suit/hooded/wintercoat/captain(src)


/obj/item/storage/bag/garment/hop/PopulateContents()
	new /obj/item/clothing/under/rank/civilian/head_of_personnel(src)
	new /obj/item/clothing/under/rank/civilian/head_of_personnel/skirt(src)
	new /obj/item/clothing/suit/armor/vest/hop(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/hopcap(src)
	new /obj/item/clothing/neck/cloak/hop(src)
	new /obj/item/clothing/shoes/laceup(src)

/obj/item/storage/bag/garment/hos/PopulateContents()
	new /obj/item/clothing/under/rank/security/head_of_security/grey(src)
	new /obj/item/clothing/under/rank/security/head_of_security/skirt(src)
	new /obj/item/clothing/under/rank/security/head_of_security/alt(src)
	new /obj/item/clothing/under/rank/security/head_of_security/alt/skirt(src)
	new /obj/item/clothing/under/rank/security/head_of_security/parade/female(src)
	new /obj/item/clothing/under/rank/security/head_of_security/parade(src)
	new /obj/item/clothing/suit/armor/hos(src)
	new /obj/item/clothing/suit/toggle/armor/hos/hos_formal(src)
	new /obj/item/clothing/suit/armor/vest/leather(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/gars/supergars(src)
	new /obj/item/clothing/head/hos(src)
	new /obj/item/clothing/mask/gas/sechailer/swat(src)
	new /obj/item/clothing/neck/cloak/hos(src)
	new /obj/item/clothing/head/hos/dermal(src)
	new /obj/item/clothing/suit/armor/hos/trenchcoat/winter(src)

/obj/item/storage/bag/garment/research_director/PopulateContents()
	new /obj/item/clothing/under/rank/rnd/research_director(src)
	new /obj/item/clothing/under/rank/rnd/research_director/skirt(src)
	new /obj/item/clothing/under/rank/rnd/research_director/alt(src)
	new /obj/item/clothing/under/rank/rnd/research_director/alt/skirt(src)
	new /obj/item/clothing/under/rank/rnd/research_director/turtleneck(src)
	new /obj/item/clothing/under/rank/rnd/research_director/turtleneck/skirt(src)
	new /obj/item/clothing/suit/toggle/labcoat(src)
	new /obj/item/clothing/head/beret/science(src)
	new /obj/item/clothing/neck/cloak/rd(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)

/obj/item/storage/bag/garment/chief_medical/PopulateContents()
	new /obj/item/clothing/head/beret/medical/cmo(src)
	new /obj/item/clothing/head/surgerycap/cmo(src)
	new /obj/item/clothing/under/rank/medical/chief_medical_officer(src)
	new /obj/item/clothing/under/rank/medical/chief_medical_officer/skirt(src)
	new /obj/item/clothing/under/rank/medical/chief_medical_officer/scrubs(src)
	new /obj/item/clothing/suit/toggle/labcoat/cmo(src)
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
	new /obj/item/clothing/neck/cloak/cmo(src)
	new /obj/item/clothing/shoes/sneakers/blue (src)

/obj/item/storage/bag/garment/engineering_chief/PopulateContents()
	new /obj/item/clothing/under/rank/engineering/chief_engineer(src)
	new /obj/item/clothing/under/rank/engineering/chief_engineer/skirt(src)
	new /obj/item/clothing/glasses/meson/engine(src)
	new /obj/item/clothing/gloves/color/chief_engineer(src)
	new /obj/item/clothing/head/hardhat/white(src)
	new /obj/item/clothing/head/hardhat/weldhat/white(src)
	new /obj/item/clothing/neck/cloak/ce(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
