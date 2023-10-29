/datum/outfit/yohei
	name = "Йохей: Дженерик"

	ears = /obj/item/radio/headset/headset_yohei
	uniform = /obj/item/clothing/under/syndicate/yohei
	mask = /obj/item/clothing/mask/breath/yohei
	shoes = /obj/item/clothing/shoes/jackboots/yohei
	gloves = /obj/item/clothing/gloves/combat/yohei
	suit = /obj/item/clothing/suit/hooded/yohei
	id = /obj/item/card/id/yohei

	suit_store = /obj/item/cat_hook

	r_hand = /obj/item/book/yohei_codex

	r_pocket = /obj/item/flashlight/seclite

	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/armament_points_card/yohei = 1)

	implants = list(/obj/item/implant/explosive/disintegrate)

/datum/outfit/yohei/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/radio/R = H.ears
	R.independent = TRUE
	ADD_TRAIT(H, TRAIT_YOHEI, JOB_TRAIT)
	spawn(1 SECONDS) // fucking
		var/obj/item/card/id/yohei/Y = H.get_idcard(FALSE)
		if(Y && H.mind)
			Y.assigned_to = H.mind

/datum/outfit/yohei/medic
	name = "Йохей: Медик"

	glasses = /obj/item/clothing/glasses/hud/health/sunglasses
	belt = /obj/item/defibrillator/compact/loaded/yohei
	uniform = /obj/item/clothing/under/syndicate/yohei/blue

	backpack_contents = list(/obj/item/pamk = 1, /obj/item/storage/firstaid/medical/surg = 1, /obj/item/optable = 1, /obj/item/armament_points_card/yohei = 1)

/datum/outfit/yohei/combatant
	name = "Йохей: Боевик"

	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	belt = /obj/item/shadowcloak/yohei
	uniform = /obj/item/clothing/under/syndicate/yohei/red

	backpack_contents = list(/obj/item/restraints/handcuffs/energy = 2, /obj/item/armament_points_card/yohei = 1)

/datum/outfit/yohei/breaker
	name = "Йохей: Взломщик"

	glasses = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	belt = /obj/item/storage/belt/military/abductor/full
	uniform = /obj/item/clothing/under/syndicate/yohei/yellow

	backpack_contents = list(/obj/item/quikdeploy/cade/plasteel = 5, /obj/item/armament_points_card/yohei = 1)

/datum/outfit/yohei/prospector
	name = "Йохей: Разведчик"

	glasses = /obj/item/clothing/glasses/meson/night
	belt = /obj/item/shadowcloak/yohei
	uniform = /obj/item/clothing/under/syndicate/yohei/green

	backpack_contents = list(/obj/item/armament_points_card/yohei = 1)
