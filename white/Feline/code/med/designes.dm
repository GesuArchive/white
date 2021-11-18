/datum/design/biocorrector
	name = "Биокорректор"
	desc = "Вправляет кости и чистит кровь. Может синтезировать костный гель."
	id = "biocorrector"
	build_path = /obj/item/bonesetter/advanced
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 5000, /datum/material/silver = 2000, /datum/material/titanium = 6000)
	category = list("Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/medbot_carrier
	name = "Переноска для медботов"
	desc = "Разгрузка для транспортировки медботов."
	id = "medbot_carrier"
	build_path = /obj/item/medbot_carrier
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 1000, /datum/material/plastic = 2000)
	category = list("Снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE
/*
/datum/design/surgery/toxin_healing //PLEASE ACCOUNT FOR UNIQUE HEALING BRANCHES IN THE hptech HREF (currently 2 for Brute/Burn; Combo is bonus)
	name = "Фильтрация лимфы (токсины)"
	desc = "Продвинутая версия операции."
	id = "surgery_healing_base" //holder because CI cries otherwise. Not used in techweb unlocks.
	surgery = /datum/surgery/healing
	research_icon_state = "surgery_chest"
*/
/datum/design/surgery/healing/toxin
	name = "Фильтрация лимфы (токсины, Продвинутое)"
	surgery = /datum/surgery/toxin_healing/toxin/upgraded
	id = "surgery_toxin_heal_toxin_upgrade"

/datum/design/surgery/healing/toxin_2
	name = "Фильтрация лимфы (токсины, Экспертное)"
	surgery = /datum/surgery/toxin_healing/toxin/upgraded/femto
	id = "surgery_toxin_heal_toxin_upgrade_femto"

