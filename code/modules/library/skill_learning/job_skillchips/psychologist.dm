/obj/item/skillchip/job/psychology
	name = "медицинский скилчип MED-301-PSIH"
	desc = "Позволяет заглянуть в бездну безумия."
	auto_traits = list(TRAIT_SUPERMATTER_SOOTHER, TRAIT_SUPERMATTER_MADNESS_IMMUNE, TRAIT_PSIH_HUD)
	chip_category = "mind"
	incompatibility_list = list("mind")
	skill_name = "Зеркало бездны"
	skill_description = "Закрепляет стабильные ментальные паттерны, позволяющие выдержать давление материи в гиперфрактальном состоянии, вызывая невосприимчивость к видениям и синдрому \"кальмара\"."
	skill_icon = "spa"
	activate_message = span_notice("Внезапно начинаю воспринимать мир намного спокойнее и рациональнее.")
	deactivate_message = span_notice("Мир вновь стал казаться коварным и не реальным...")

//  ХУД церебралов
/obj/item/skillchip/job/psychology/on_activate(mob/living/carbon/user, silent=FALSE)
	. = ..()
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_PSIH]
	hud.show_to(user)

/obj/item/skillchip/job/psychology/on_deactivate(mob/living/carbon/user, silent=FALSE)
	. = ..()
//  ХУД церебралов
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_PSIH]
	hud.hide_from(user)
