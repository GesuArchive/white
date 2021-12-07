// Медицинский пояс СМО MK2
/obj/item/storage/belt/medical/ems/cmo

/obj/item/reagent_containers/glass/bottle/penacid
	name = "Пентетовая кислота"
	desc = "Небольшая бутылка кислоты, способной выводить токсины и радиацию."
	list_reagents = list(/datum/reagent/medicine/pen_acid = 30)

/obj/item/reagent_containers/glass/bottle/sal_acid
	name = "Салициловая кислота"
	desc = "Небольшая бутылка со средством для лечения побоев и ушибов."
	list_reagents = list(/datum/reagent/medicine/sal_acid = 30)

/obj/item/storage/belt/medical/ems/cmo/PopulateContents()
	new /obj/item/surgical_drapes(src)
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/cautery/advanced(src)
	new /obj/item/bonesetter/advanced(src)
	new /obj/item/reagent_containers/medigel/sal_acid_oxandrolone(src)
	new /obj/item/reagent_containers/medigel/pen_acid(src)
