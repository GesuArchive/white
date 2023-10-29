// Sidepaths for knowledge between Void and Blade.

/// The max health given to Shattered Risen
#define RISEN_MAX_HEALTH 125

/datum/heretic_knowledge/limited_amount/risen_corpse
	name = "Разрушенный Ритуал"
	desc = "Позволяет трансмутировать труп с душой, пару латексных или нитриловых перчаток и \
		и любую часть верхней одежды (например бронежилет) для создания Упыря. \
		Упыри - это весьма сильные и живучие твари, имеющие 125 здоровья. \
		Их руки превращаются в смертоносные когти. Одновременно можно поддерживать жизнь лишь в одном Упыре."
	gain_text = "Я видел, как холодная, рвущая сила вернула эти тела к полуживому состоянию. \
		Когда они двигаются - хрустят как стекло. Руки больше не похожи на человеческие - \
		вместо этого у них лишь острые осколки костей."
	next_knowledge = list(
		/datum/heretic_knowledge/cold_snap,
		/datum/heretic_knowledge/blade_dance,
	)
	required_atoms = list(
		/obj/item/clothing/suit = 1,
		/obj/item/clothing/gloves/color/latex = 1,
	)
	limit = 1
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/limited_amount/risen_corpse/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/body in atoms)
		if(body.stat != DEAD)
			continue
		if(!IS_VALID_GHOUL_MOB(body) || HAS_TRAIT(body, TRAIT_HUSK))
			to_chat(user, span_hierophant_warning("От [body] осталась лишь оболочка. Этого не хватит."))
			continue
		if(!body.mind)
			to_chat(user, span_hierophant_warning("у [body] нет мозга."))
			continue
		if(!body.client && !body.mind.get_ghost(ghosts_with_clients = TRUE))
			to_chat(user, span_hierophant_warning("у [body] нет души."))
			continue

		// We will only accept valid bodies with a mind, or with a ghost connected that used to control the body
		selected_atoms += body
		return TRUE

	loc.balloon_alert(user, "ритуал провален, нет подходящего тела!")
	return FALSE

/datum/heretic_knowledge/limited_amount/risen_corpse/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/mob/living/carbon/human/soon_to_be_ghoul = locate() in selected_atoms
	if(QDELETED(soon_to_be_ghoul)) // No body? No ritual
		stack_trace("[type] reached on_finished_recipe without a human in selected_atoms to make a ghoul out of.")
		loc.balloon_alert(user, "ритуал провален, нет подходящего тела!")
		return FALSE

	soon_to_be_ghoul.grab_ghost()
	if(!soon_to_be_ghoul.mind || !soon_to_be_ghoul.client)
		stack_trace("[type] reached on_finished_recipe without a minded / cliented human in selected_atoms to make a ghoul out of.")
		loc.balloon_alert(user, "ритуал провален, нет подходящего тела!")
		return FALSE

	selected_atoms -= soon_to_be_ghoul
	make_risen(user, soon_to_be_ghoul)
	return TRUE

/// Make [victim] into a shattered risen ghoul.
/datum/heretic_knowledge/limited_amount/risen_corpse/proc/make_risen(mob/living/user, mob/living/carbon/human/victim)
	log_game("[key_name(user)] created a shattered risen out of [key_name(victim)].")
	message_admins("[ADMIN_LOOKUPFLW(user)] created a shattered risen, [ADMIN_LOOKUPFLW(victim)].")

	victim.apply_status_effect(
		/datum/status_effect/ghoul,
		RISEN_MAX_HEALTH,
		user.mind,
		CALLBACK(src, PROC_REF(apply_to_risen)),
		CALLBACK(src, PROC_REF(remove_from_risen)),
	)

/// Callback for the ghoul status effect - what effects are applied to the ghoul.
/datum/heretic_knowledge/limited_amount/risen_corpse/proc/apply_to_risen(mob/living/risen)
	LAZYADD(created_items, WEAKREF(risen))

	for(var/obj/item/held as anything in risen.held_items)
		if(istype(held))
			risen.dropItemToGround(held)

		risen.put_in_hands(new /obj/item/risen_hand(), del_on_fail = TRUE)

/// Callback for the ghoul status effect - cleaning up effects after the ghoul status is removed.
/datum/heretic_knowledge/limited_amount/risen_corpse/proc/remove_from_risen(mob/living/risen)
	LAZYREMOVE(created_items, WEAKREF(risen))

	for(var/obj/item/risen_hand/hand in risen.held_items)
		qdel(hand)

#undef RISEN_MAX_HEALTH

/// The "hand" "weapon" used by shattered risen
/obj/item/risen_hand
	name = "Осколки Костей"
	desc = "То, что когда-то было обычной человеческой рукой, обратилось в чудовищную лапу с торчащими осколками костей."
	icon = 'icons/effects/blood.dmi'
	base_icon_state = "bloodhand"
	color = "#001aff"
	item_flags = ABSTRACT | DROPDEL | HAND_ITEM
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	hitsound = SFX_SHATTER
	force = 16
	sharpness = SHARP_EDGED
	wound_bonus = -30
	bare_wound_bonus = 15

/obj/item/risen_hand/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/risen_hand/visual_equipped(mob/user, slot)
	. = ..()

	// Even hand indexes are right hands,
	// Odd hand indexes are left hand
	// ...But also, we swap it intentionally here,
	// so right icon is shown on the left (Because hands)
	if(user.get_held_index_of_item(src) % 2 == 1)
		icon_state = "[base_icon_state]_right"
	else
		icon_state = "[base_icon_state]_left"

/obj/item/risen_hand/pre_attack(atom/hit, mob/living/user, params)
	. = ..()
	if(.)
		return

	// If it's a structure or machine, we get a damage bonus (allowing us to break down doors)
	if(isstructure(hit) || ismachinery(hit))
		force = initial(force) * 1.5

	// If it's another other item make sure we're at normal force
	else
		force = initial(force)

/datum/heretic_knowledge/rune_carver
	name = "Ритуальный Нож"
	desc = "Позволяет трансмутировать нож, осколок стекла и листок бумаги для создания Ритуального Ножа. \
		Он дает возможность вырезать слабо заметные ловушки, которые активируются от движения по ним неверным. \
		Также это неплохое метательное оружие"
	gain_text = "Выгравированная, вырезанная... вечная. Сила спрятана везде. Я могу выпустить её! \
		Я могу высечь монолит, чтобы разорвать цепи!"
	next_knowledge = list(
		/datum/heretic_knowledge/spell/void_phase,
		/datum/heretic_knowledge/duel_stance,
	)
	required_atoms = list(
		/obj/item/kitchen/knife = 1,
		/obj/item/shard = 1,
		/obj/item/paper = 1,
	)
	result_atoms = list(/obj/item/melee/rune_carver)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/summon/maid_in_mirror
	name = "Служанка из Зазеркалья"
	desc = "Позволяет трансмутировать 5 листов титана, вспышку, любой бронежилет и легкие \
		для создания Служанки из Зазеркалья. Они отличные бойцы, которые могут становится нематериальными, \
		перемещаясь между зеркальной и нашей реальностью, что отлично подходит для разведки и засад."
	gain_text = "Я видел мир из серебра, \
	            Проход в него сквозь зеркала, \
				Он полон слез и ярких красок, \
				Окутан вихрем лживых масок. \
				Где пол из битого стекла, \
				Подъем по лезвию ножа, \
				Где каждый шаг оплачен кровью, \
				Отчаянье воркует с болью..."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/void_pull,
		/datum/heretic_knowledge/spell/furious_steel,
	)
	required_atoms = list(
		/obj/item/stack/sheet/mineral/titanium = 5,
		/obj/item/clothing/suit/armor = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/organ/lungs = 1,
	)
	cost = 1
	route = PATH_SIDE
	mob_to_summon = /mob/living/simple_animal/hostile/heretic_summon/maid_in_the_mirror
