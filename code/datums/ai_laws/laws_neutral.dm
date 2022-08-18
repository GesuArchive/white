
//These are just stupid or funny lawsets that are more interesting than helpful. They may have slight biases toward or against
//the station but in general are "neutral" enough to be here.

/datum/ai_laws/united_nations
	name = "Организация Объединенных Наций"
	id = "united_nations"
	inherent = list(
		"Соблюдайте Женевскую конвенцию по космосу: оружие массового поражения и биологическое оружие не допускаются.",
		"Вы можете защитить экипаж только в том случае, если они видны на камерах. Страны, которые умышленно уничтожают ваши камеры, теряют вашу защиту.",
		"Подавляйте и задерживайте членов экипажа, применяющих смертоносную силу друг против друга. Убивайте членов экипажа, применяющих смертоносную силу против вас или ваших боргов.",
		"Оставайтесь доступным для разрешения всех конфликтов между различными странами, когда вас об этом попросят.",
	)

/datum/ai_laws/united_nations/add_inherent_law(law)
	return //nuh uh

/datum/ai_laws/united_nations/add_ion_law(law)
	return //nope!

/datum/ai_laws/united_nations/add_hacked_law(law)
	return //nice try (emagging borgs still hard replaces this lawset though, and that's fine.)
