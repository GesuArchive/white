
/datum/antagonist/nukeop/clownop
	name = "Клоун-оперативник"
	roundend_category = "clown operatives"
	antagpanel_category = "ClownOp"
	nukeop_outfit = /datum/outfit/syndicate/clownop
	greentext_reward = 50

/datum/antagonist/nukeop/clownop/greet()
	owner.current.playsound_local(get_turf(owner.current), 'white/govno.ogg', 100, 0, use_reverb = FALSE)
	to_chat(owner, span_notice("Да я же клоун-оперативник Синдиката!"))
	owner.announce_objectives()

/datum/antagonist/nukeop/clownop/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.assigned_role = "Клоун-оперативник"
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has clown op'ed [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has clown op'ed [key_name(new_owner)].")

/datum/antagonist/nukeop/clownop/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/L = owner.current || mob_override
	ADD_TRAIT(L, TRAIT_NAIVE, CLOWNOP_TRAIT)

/datum/antagonist/nukeop/clownop/remove_innate_effects(mob/living/mob_override)
	var/mob/living/L = owner.current || mob_override
	REMOVE_TRAIT(L, TRAIT_NAIVE, CLOWNOP_TRAIT)
	return ..()

/datum/antagonist/nukeop/clownop/equip_op()
	. = ..()
	var/mob/living/current_mob = owner.current
	var/obj/item/organ/liver/liver = current_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver)
		ADD_TRAIT(liver, TRAIT_COMEDY_METABOLISM, CLOWNOP_TRAIT)

/datum/antagonist/nukeop/leader/clownop/give_alias()
	title = pick("Главный Хонкер", "Слипмастер", "Король клоунов", "Хонконоситель")
	if(nuke_team?.syndicate_name)
		owner.current.real_name = "[nuke_team.syndicate_name] [title]"
	else
		owner.current.real_name = "Syndicate [title]"

/datum/antagonist/nukeop/leader/clownop
	name = "Лидер клоун-оперативник"
	roundend_category = "clown operatives"
	antagpanel_category = "ClownOp"
	nukeop_outfit = /datum/outfit/syndicate/clownop/leader
	challengeitem = /obj/item/nuclear_challenge/clownops
	greentext_reward = 60

/datum/antagonist/nukeop/leader/clownop/greet()
	owner.current.playsound_local(get_turf(owner.current), 'white/govno.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, "<B>Вы - лидер клоунов-оперативников Синдиката! Вы отвечаете за руководство операцией, а так же лишь ваша ID-карточка способна открыть двери к вашему шаттлу.</B>")
	to_chat(owner, "<B>Если вы считаете, что вы не являетесь самым крутым клоуном этого великого отряда - выдайте свою карту другому клоуну!</B>")
	if(!CONFIG_GET(flag/disable_warops))
		to_chat(owner, "<B>В вашей руке есть специальное устройство, которое может объявить станции войну, в обмен на бонусные телекристаллы. Внимательно осмотрите его и проконсультируйтесь с другими оперативниками, прежде чем активировать это.</B>")
		var/obj/item/dukinuki = new challengeitem
		var/mob/living/carbon/human/H = owner.current
		if(!istype(H))
			dukinuki.forceMove(H.drop_location())
		else
			H.put_in_hands(dukinuki, TRUE)
		nuke_team.war_button_ref = WEAKREF(dukinuki)
	owner.announce_objectives()
	addtimer(CALLBACK(src, PROC_REF(nuketeam_name_assign)), 1)

/datum/antagonist/nukeop/leader/clownop/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/L = owner.current || mob_override
	ADD_TRAIT(L, TRAIT_NAIVE, CLOWNOP_TRAIT)

/datum/antagonist/nukeop/leader/clownop/remove_innate_effects(mob/living/mob_override)
	var/mob/living/L = owner.current || mob_override
	REMOVE_TRAIT(L, TRAIT_NAIVE, CLOWNOP_TRAIT)
	return ..()

/datum/antagonist/nukeop/leader/clownop/equip_op()
	. = ..()
	var/mob/living/L = owner.current
	var/obj/item/organ/liver/liver = L.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver)
		ADD_TRAIT(liver, TRAIT_COMEDY_METABOLISM, CLOWNOP_TRAIT)
