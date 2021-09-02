/obj/item/taster
	name = "taster"
	desc = "Tastes things, so you don't have to!"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "tonguenormal"

	w_class = WEIGHT_CLASS_TINY

	var/taste_sensitivity = 15

/obj/item/taster/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(!O.reagents)
		to_chat(user, span_notice("[capitalize(src.name)] не может вкусить [O], потому что ничего не осталось."))
	else if(O.reagents.total_volume == 0)
		to_chat(user, "<span class='notice'>[capitalize(src.name)] не может вкусить [O], потому что ничего нет.")
	else
		var/message = O.reagents.generate_taste_message(user, taste_sensitivity)
		to_chat(user, span_notice("[capitalize(src.name)] вкушает <span class='italics'>[message]</span> в [O]."))
