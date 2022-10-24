/obj/item/reagent_containers/glass/rag
	name = "влажная тряпка"
	desc = "Предположительно для устраненя беспорядка."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	item_flags = NOBLUDGEON
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 5
	spillable = FALSE

/obj/item/reagent_containers/glass/rag/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cleaner, 3 SECONDS, pre_clean_callback=CALLBACK(src, .proc/should_clean))

/obj/item/reagent_containers/glass/rag/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is smothering [user.ru_na()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (OXYLOSS)

/obj/item/reagent_containers/glass/rag/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!iscarbon(target) || !reagents?.total_volume)
		return ..()
	var/mob/living/carbon/C = target
	var/reagentlist = pretty_string_from_reagent_list(reagents)
	var/log_object = "containing [reagentlist]"
	if(user.a_intent == INTENT_HARM && !C.is_mouth_covered())
		reagents.trans_to(C, reagents.total_volume, transfered_by = user, methods = INGEST)
		C.visible_message(span_danger("[user] душит [C] используя [src]!") , span_userdanger("[user] душит вас используя [src]!") , span_hear("Слышу звуки борьбы и приглушенные удивленные вскрики."))
		log_combat(user, C, "задушен", src, log_object)
	else
		reagents.expose(C, TOUCH)
		reagents.clear_reagents()
		C.visible_message(span_notice("[user] трогает [C] [src]."))
		log_combat(user, C, "потроган", src, log_object)

///Checks whether or not we should clean.
/obj/item/reagent_containers/glass/rag/proc/should_clean(datum/cleaning_source, atom/atom_to_clean, mob/living/cleaner)
	return (src in cleaner)
