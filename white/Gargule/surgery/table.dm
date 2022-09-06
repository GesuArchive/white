/obj/item/optable
	name = "раскладной операционный стол"
	desc = "Компактный операционный стол для полевой хирургии"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/optable/attack_self(mob/user)
	deploy_table(user, user.loc)

/obj/item/optable/afterattack(obj/target, mob/user , proximity)
	if(!proximity)
		return
	if(isopenturf(target))
		deploy_table(user, target)

/obj/item/optable/proc/deploy_table(mob/user, atom/location)
	var/obj/structure/table/optable/folding/R = new /obj/structure/table/optable/folding(location)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/table/optable/folding
	buildstack = null
	var/foldabletype = /obj/item/optable

/obj/structure/table/optable/folding/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
			return 0
		if(has_buckled_mobs())
			return 0
		usr.visible_message("[usr] collapses [src.name].", span_notice("You collapse [src.name]."))
		var/obj/structure/bed/roller/B = new foldabletype(get_turf(src))
		usr.put_in_hands(B)
		qdel(src)
