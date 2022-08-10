/obj/item/jobanyj_rot
	name = "Ebaniy rot etogo kazino"
	desc = "Ebaniy rot etogo kazino blyat. Ti kto takoi suka, chtob eto sdelat?"
	icon = 'white/ClickerOfThings/shitspawn_deck/kazino.dmi'
	icon_state = "kazino"
	w_class = WEIGHT_CLASS_SMALL


/obj/item/toy/cards/deck/shitspawn_deck
	name = "shitspawn deck of cards"
	desc = "A deck of space-grade playing cards with some shitspawn in it."
	throwforce = 1
	hitsound = 'white/ClickerOfThings/shitspawn_deck/cardinsult.ogg'

/obj/item/toy/cards/deck/shitspawn_deck/attack_hand(mob/living/user, list/modifiers, flip_card = FALSE)
	. = ..()
	playsound(src, 'white/ClickerOfThings/shitspawn_deck/pullcard.ogg', 50, 1)
	user.visible_message("Karta razlozhena v drugom poryadke, blyat!", span_notice("Karta razlozhena v drugom poryadke, blyat!"))
	update_icon()

/obj/item/toy/cards/deck/shitspawn_deck/shuffle_cards(mob/living/user)
	if(!COOLDOWN_FINISHED(src, shuffle_cooldown))
		return
	. = ..()
	playsound(src, 'white/ClickerOfThings/shitspawn_deck/cardshuffle2.ogg', 50, 1)
	user.visible_message("Karti razlozheni v drugom poryadke, blyat!", span_notice("Karti razlozheni v drugom poryadke, blyat!"))


/obj/item/toy/cards/deck/shitspawn_deck/attackby(obj/item/item, mob/living/user, params)
	if(istype(item, /obj/item/toy/singlecard) || istype(item, /obj/item/toy/cards/cardhand))
		user.visible_message("Karta razlozhena v nuzhnom poryadke.", span_notice("Karta razlozhena v nuzhnom poryadke."))
		playsound(src, 'white/ClickerOfThings/shitspawn_deck/diler_est.ogg', 50, 1)
	else if(istype(item, /obj/item/jobanyj_rot))
		var/obj/item/jobanyj_rot = item
		playsound(src, 'white/ClickerOfThings/shitspawn_deck/sluchai_v_kazino_full.ogg', 50, 1)
		user.visible_message("[user] zamechaet, chto koloda raspolozhena v drugom poryadke. Yobaniy rot etogo kazino blyat!")
		qdel(jobanyj_rot)
	return ..()

/obj/item/toy/cards/deck/shitspawn_deck/AltClick(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, NO_TK, !iscyborg(user)))
		if(!wielded)
			user.visible_message("Ti to che delaesh?!", span_notice("Ti to che delaesh?!"))
			playsound(src, 'white/ClickerOfThings/shitspawn_deck/durak.ogg', 50, 1)
	return ..()
