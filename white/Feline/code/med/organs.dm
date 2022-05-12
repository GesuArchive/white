// Коробочка с искусственными зубами

/obj/item/storage/box/teeth_box_32
	name = "Комплект зубных коронок"
	desc = "Стоматологический набор универсальных зубных протезов. Не очень удобные, сомнительного стального цвета, однако весьма дешевых, что положительно сказывается на стоимости медицинской страховки."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "box_teeth"

/obj/item/storage/box/teeth_box_32/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stack/teeth/replacement = 32)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/teeth_box_32/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.allow_quick_gather = TRUE
	STR.click_gather = TRUE
	STR.display_numerical_stacking = TRUE
	STR.max_items = 3
	STR.max_combined_w_class = 100
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.set_holdable(list(/obj/item/stack/teeth))

// 	Импланты

/obj/item/organ/cyberimp/brain/biomonitor
	name = "имплант биомонитора"
	desc = "Этот кибернетический мозговой имплант подключается к кровеносной и нервной системе носителя для определения его физического состояния и химанализа крови. Для активации необходимо мысленно <b>ОСМОТРЕТЬ СЕБЯ</b>."
	icon = 'white/Feline/icons/implants.dmi'
	icon_state = "biomonitor"
	slot = ORGAN_SLOT_BRAIN_BIOMONITOR
	implant_overlay = null

/obj/item/autosurgeon/organ/biomonitor
	name = "Биомонитор"
	desc = "Автохирург с установленным внутри имплантом биомонитора. Этот кибернетический мозговой имплант подключается к кровеносной и нервной системе носителя для определения его физического состояния и химанализа крови. Для активации необходимо мысленно <b>ОСМОТРЕТЬ СЕБЯ</b>."
	uses = 1
	starting_organ = /obj/item/organ/cyberimp/brain/biomonitor
