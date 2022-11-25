/obj/item/stack/teeth
	name = "зубы"
	singular_name = "зуб"
	w_class = 1
	throwforce = 2
	max_amount = 32
	desc = "Кто-то потерял зуб. Класс."
	icon = 'white/valtos/icons/teeth.dmi'
	icon_state = "teeth"
	merge_type = /obj/item/stack/teeth

/obj/item/stack/teeth/update_icon_state()
	. = ..()
	switch(amount)
		if(1)
			icon_state = initial(icon_state)
			return
		if(2 to 5)
			icon_state = "[initial(icon_state)]_[amount]"
			return
		else
			icon_state = "[initial(icon_state)]_5"
			return

/obj/item/stack/teeth/Initialize(mapload)
	. = ..()
	var/matrix/M = matrix()
	M.Turn(rand(0, 360))
	transform = M

/obj/item/stack/teeth/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] jams [src] into \his eyes! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS)

/obj/item/stack/teeth/human
	name = "человеческие зубы"
	singular_name = "человеческие зубы"
	merge_type = /obj/item/stack/teeth/human

/obj/item/stack/teeth/human/gold //Special traitor objective maybe?
	name = "золотые зубы"
	singular_name = "золотой зуб"
	desc = "Кто-то потратился на это."
	icon_state = "teeth_gold"
	merge_type = /obj/item/stack/teeth/human/gold

/obj/item/stack/teeth/human/wood
	name = "деревянные зубы"
	singular_name = "деревянный зуб"
	desc = "Сделано из самой худшей древесины."
	icon_state = "teeth_wood"
	merge_type = /obj/item/stack/teeth/human/wood

/obj/item/stack/teeth/generic //Used for species without unique teeth defined yet
	name = "зуб"
	merge_type = /obj/item/stack/teeth/generic

/obj/item/stack/teeth/replacement
	name = "искусственные зубы"
	singular_name = "искусственный зуб"
	desc = "Вау, искуственные зубы?"
	icon_state = "dentals"
	custom_materials = list(/datum/material/iron = 250)
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	merge_type = /obj/item/stack/teeth/replacement

/datum/design/replacement_teeth
	name = "Искусственный зуб"
	id = "replacement_teeth"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 250)
	build_path = /obj/item/stack/teeth/replacement
	category = list("initial", "Медицина")
	maxstack = 32

/datum/surgery/teeth_reinsertion
	name = "Вставка зуба"
	steps = list(/datum/surgery_step/handle_teeth)
	possible_locs = list("mouth")

/datum/surgery_step/handle_teeth
	accept_hand = 1
	accept_any_item = 1
	time = 64

/datum/surgery_step/handle_teeth/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/stack/teeth/T, datum/surgery/surgery)
	var/obj/item/bodypart/head/O = locate(/obj/item/bodypart/head) in target.bodyparts
	if(!O)
		user.visible_message(span_notice("Че за... у [target] нет башки!"))
		return -1
	if(istype(T))
		if(O.get_teeth() >= O.max_teeth)
			to_chat(user, "<span class='notice'>Все зубы [target] в порядке.")
			return -1
		user.visible_message(span_notice("[user] начинает вставлять [T] в рот [target]."))
	else
		user.visible_message(span_notice("[user] начинает вырывать зубы [target]."))

/datum/surgery_step/handle_teeth/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/stack/teeth/T, datum/surgery/surgery)
	var/obj/item/bodypart/head/O = locate(/obj/item/bodypart/head) in target.bodyparts
	if(!O)
		user.visible_message(span_notice("Че за... у [target] нет башки!"))
		return -1
	if(istype(T))
		if(O.get_teeth()) //Has teeth, check if they need "refilling"
			if(O.get_teeth() >= O.max_teeth)
				user.visible_message(span_notice("[user] похоже не получится вставить [T] [target] в качестве зуба.") , span_notice("Все зубы [target] в порядке."))
				return 0
			var/obj/item/stack/teeth/F = locate(T.type) in O.teeth_list //Look for same type of teeth inside target's mouth for merging
			var/amt = T.amount
			if(F)
				amt = T.merge(F) //Try to merge provided teeth into person's teeth.
			else
				amt = min(T.amount, O.max_teeth-O.get_teeth())
				T.use(amt)
				var/obj/item/stack/teeth/E = new T.type(target, amt)
				O.teeth_list += E
				// E.forceMove(target)
				T = E
			user.visible_message(span_notice("[user] вставляет [amt] [skloname(T.name, VINITELNI)] в рот [target]!"))
			return 1
		else //No teeth to speak of.
			var/amt = min(T.amount, O.max_teeth)
			T.use(amt)
			var/obj/item/stack/teeth/F = new T.type(target, amt)
			O.teeth_list += F
			// F.forceMove(target)
			T = F
			user.visible_message(span_notice("[user] вставляет [amt] [skloname(T.name, VINITELNI)] в рот [target]!"))
			return 1
	else
		if(O.teeth_list.len)
			user.visible_message(span_notice("[user] вырывает все зубы изо рта [target]!"))
			for(var/obj/item/stack/teeth/F in O.teeth_list)
				O.teeth_list -= F
				F.forceMove(get_turf(target))
			return 1
		else
			user.visible_message(span_notice("[user] не может найти что-то подходящее во рту [target]."))
			return 0

/datum/species
	var/teeth_type = /obj/item/stack/teeth/generic

/datum/species/human
	teeth_type = /obj/item/stack/teeth/human

/datum/species/skeleton
	teeth_type = /obj/item/stack/teeth/human
