/obj/item/clothing/under/chronos
	name = "Военный костюм Новой Мекки"
	desc = "В этом костюме твой дед пиздил унтеров"
	icon = 'white/kacherkin/icons/station/clothing/uniforms.dmi'
	worn_icon = 'white/kacherkin/icons/station/clothing/mob/uniforms_mob.dmi'
	icon_state = "torch_uniform"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/obj/item/clothing/head/beret/chronos
	name = "Военный берет Новой Мекки"
	desc = "But burning those villages, watching those naked peasants cry..."
	icon = 'white/kacherkin/icons/station/clothing/hats.dmi'
	worn_icon = 'white/kacherkin/icons/station/clothing/mob/hats_mob.dmi'
	icon_state = "torch_beret"

/obj/item/clothing/suit/cape/chronos
	name = "Военный плащ новой Мекки"
	desc = "Плащ, пахнущий кровью унтеров, солдат из Новой Мекки, а так же шлюхами из лимузина"
	icon = 'white/kacherkin/icons/station/clothing/suits.dmi'
	worn_icon = 'white/kacherkin/icons/station/clothing/mob/suits_mob.dmi'
	icon_state = "torch_cape"
	allowed = list(/obj/item/gun, /obj/item/tank/internals)

/datum/gear/uniform/chronos
	display_name = "Военный костюм Новой Мекки"
	path = /obj/item/clothing/under/chronos
	cost = 500

/datum/gear/suit/cape/chronos
	display_name = "Военный плащ Новой Мекки"
	path = /obj/item/clothing/suit/cape/chronos
	cost = 500

/datum/gear/hat/chronos
	display_name = "Военный берет Новой Мекки"
	path = /obj/item/clothing/head/beret/chronos
	cost = 500
