/obj/item/organ/cyberimp/eyes
	name = "кибернетические импланты глаз"
	desc = "Импланты для ваших глаз."
	icon_state = "eye_implant"
	implant_overlay = "eye_implant_overlay"
	slot = ORGAN_SLOT_EYES
	zone = BODY_ZONE_PRECISE_EYES
	w_class = WEIGHT_CLASS_TINY

// HUD implants
/obj/item/organ/cyberimp/eyes/hud
	name = "имплант интерфейса"
	desc = "Эти кибернетические глаза выведут интерфейс поверх всего что вы видите. Наверное."
	slot = ORGAN_SLOT_HUD
	var/HUD_type = 0
	var/HUD_trait = null

/obj/item/organ/cyberimp/eyes/hud/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = FALSE)
	..()
	if(HUD_type)
		var/datum/atom_hud/H = GLOB.huds[HUD_type]
		H.add_hud_to(M)
	if(HUD_trait)
		ADD_TRAIT(M, HUD_trait, ORGAN_TRAIT)

/obj/item/organ/cyberimp/eyes/hud/Remove(mob/living/carbon/M, special = 0)
	if(HUD_type)
		var/datum/atom_hud/H = GLOB.huds[HUD_type]
		H.remove_hud_from(M)
	if(HUD_trait)
		REMOVE_TRAIT(M, HUD_trait, ORGAN_TRAIT)
	..()

/obj/item/organ/cyberimp/eyes/hud/medical
	name = "Имплант медицинского интерфейса"
	desc = "Эти кибернетические глаза выведут медицинский интерфейс поверх всего что вы видите."
	HUD_type = DATA_HUD_MEDICAL_ADVANCED
	HUD_trait = TRAIT_MEDICAL_HUD

/obj/item/organ/cyberimp/eyes/hud/security
	name = "Имплант интерфейса службы безопасности"
	desc = "Эти кибернетические глаза выведут интерфейс службы безопасности поверх всего что вы видите."
	HUD_type = DATA_HUD_SECURITY_ADVANCED
	HUD_trait = TRAIT_SECURITY_HUD

/obj/item/organ/cyberimp/eyes/hud/diagnostic
	name = "Имплант интерфейса диагностики"
	desc = "Эти кибернетические глаза выведут интерфейс диагностики поверх всего что вы видите."
	HUD_type = DATA_HUD_DIAGNOSTIC_ADVANCED

/obj/item/organ/cyberimp/eyes/hud/security/syndicate
	name = "Контрабандный имплант интерфейса службы безопасности"
	desc = "Интерфейс службы безопасности от КиберСан Индастриз. Эти нелегальные кибернетические глаза выведут интерфейс службы безопасности поверх всего что вы видите"
	syndicate_implant = TRUE
