/datum/design/biocorrector
	name = "Биокорректор"
	desc = "Вправляет кости и чистит кровь. Может синтезировать костный гель."
	id = "biocorrector"
	build_path = /obj/item/bonesetter/advanced
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 5000, /datum/material/silver = 2000, /datum/material/titanium = 6000)
	category = list("Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE 
