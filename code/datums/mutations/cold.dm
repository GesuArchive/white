/datum/mutation/human/geladikinesis
	name = "Аквакрионика"
	desc = "Позволяет сконденсировать влагу из воздуха в руках и обратить ее в снег."
	quality = POSITIVE
	text_gain_indication = span_notice("Мои руки холодные, как снег...")
	instability = 10
	difficulty = 10
	synchronizer_coeff = 1
	power = /obj/effect/proc_holder/spell/targeted/conjure_item/snow

/obj/effect/proc_holder/spell/targeted/conjure_item/snow
	name = "Десублимация влаги"
	desc = "Позволяет сконденсировать влагу из воздуха в руках и обратить ее в снег."
	item_type = /obj/item/stack/sheet/mineral/snow
	charge_max = 50
	delete_old = FALSE
	action_icon_state = "snow"


/datum/mutation/human/cryokinesis
	name = "Криокинез"
	desc = "Псионическая способность заморозить цель на рассстоянии."
	quality = POSITIVE //upsides and downsides
	text_gain_indication = span_notice("Мои руки холодные, как лед...")
	instability = 20
	difficulty = 12
	synchronizer_coeff = 1
	power = /obj/effect/proc_holder/spell/aimed/cryo

/obj/effect/proc_holder/spell/aimed/cryo
	name = "Криокинез"
	desc = "Псионическая способность заморозить цель на рассстоянии."
	charge_max = 150
	cooldown_min = 150
	clothes_req = FALSE
	range = 3
	projectile_type = /obj/projectile/temp/cryo
	base_icon_state = "icebeam"
	action_icon_state = "icebeam"
	active_msg = "Выпускаю стужу на свободу..."
	deactive_msg = "Втягиваю холод обратно в себя."
	active = FALSE

