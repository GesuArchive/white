/obj/item/book/granter/crafting_recipe/trash_cannon
	name = "дневник уволенного инженера"
	desc = "Потерянный дневник инженера. Он, видимо, очень расстроен из-за увольнения."
	crafting_recipe_types = list(
		/datum/crafting_recipe/trash_cannon,
		/datum/crafting_recipe/trashball,
	)
	icon_state = "book1"
	remarks = list(
		"\"Я покажу им всем! Я ПОСТРОЮ ПУШКУ!\"",
		"\"Порох подошёл бы идеально, но мне придётся импровизировать..\"",
		"\"Я наслаждаюсь взглядом старшего инженера, когда я СНОШУ стены до самого основания\"",
		"\"Если я выпущу сингулярность, то так тому и быть!\"",
		"\"Я ОКОНЧАТЕЛЬНО СЪЕХАЛ С КАТУШЕК!\""
	)

/obj/item/book/granter/crafting_recipe/trash_cannon/recoil(mob/living/user)
	to_chat(user, span_warning("Книга рассыпалась в пыль в моих руках."))
	qdel(src)

