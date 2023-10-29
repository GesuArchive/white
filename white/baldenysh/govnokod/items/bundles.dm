/obj/item/storage/briefcase/surgery
	name = "кейс полевого хирурга"
	desc = "Алюминиевый кейс, содержащий все необходимое для проведения операций в полевых условиях."
	icon_state = "surgerycase"
	icon = 'white/baldenysh/icons/obj/briefcase.dmi'
	lefthand_file = 'white/baldenysh/icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'white/baldenysh/icons/mob/inhands/equipment/briefcase_righthand.dmi'
	force = 12
	throwforce = 12

/obj/item/storage/briefcase/surgery/Initialize()
	. = ..()
	atom_storage.max_total_storage = 22
	atom_storage.max_slots = 14

/obj/item/storage/briefcase/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/breathing_bag(src)
	new /obj/item/reagent_containers/medigel/sterilizine(src)
	new /obj/item/razor(src)
	new /obj/item/blood_filter(src)
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/glass/bottle/epinephrine(src)
	new /obj/item/healthanalyzer(src)
