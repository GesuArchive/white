/mob/living/carbon/alien/humanoid/royal
	//Common stuffs for Praetorian and Queen
	icon = 'icons/mob/alienqueen.dmi'
	status_flags = 0
	pixel_x = -16
	base_pixel_x = -16
	bubble_icon = "alienroyal"
	mob_size = MOB_SIZE_LARGE
	layer = LARGE_MOB_LAYER //above most mobs, but below speechbubbles
	plane = GAME_PLANE_UPPER_FOV_HIDDEN
	pressure_resistance = 200 //Because big, stompy xenos should not be blown around like paper.
	butcher_results = list(/obj/item/food/meat/slab/xeno = 20, /obj/item/stack/sheet/animalhide/xeno = 3)

	var/alt_inhands_file = 'icons/mob/alienqueen.dmi'

/mob/living/carbon/alien/humanoid/royal/on_lying_down(new_lying_angle)
	. = ..()
	SET_PLANE_IMPLICIT(src, GAME_PLANE_FOV_HIDDEN) //So it won't hide smaller mobs.

/mob/living/carbon/alien/humanoid/royal/on_standing_up(new_lying_angle)
	. = ..()
	SET_PLANE_IMPLICIT(src, initial(plane))

/mob/living/carbon/alien/humanoid/royal/can_inject(mob/user, target_zone, injection_flags)
	return FALSE

/mob/living/carbon/alien/humanoid/royal/queen
	name = "королева чужих"
	caste = "q"
	maxHealth = 400
	health = 400
	icon_state = "alienq"
	var/datum/action/small_sprite/smallsprite = new/datum/action/small_sprite/queen()

/mob/living/carbon/alien/humanoid/royal/queen/Initialize(mapload)
	//there should only be one queen
	for(var/mob/living/carbon/alien/humanoid/royal/queen/Q in GLOB.carbon_list)
		if(Q == src)
			continue
		if(Q.stat == DEAD)
			continue
		if(Q.client)
			name = "фрейлина чужих ([rand(1, 999)])"	//if this is too cutesy feel free to change it/remove it.
			break

	real_name = src.name

	var/datum/action/cooldown/spell/aoe/repulse/xeno/tail_whip = new(src)
	tail_whip.Grant(src)

	var/datum/action/small_sprite/queen/smallsprite = new(src)
	smallsprite.Grant(src)

	var/datum/action/cooldown/alien/promote/promotion = new(src)
	promotion.Grant(src)

	priority_announce("На станции [station_name()] обнаружена королева ксеноморфов. Заблокируйте любой внешний доступ, включая воздуховоды и вентиляцию.", "Боевая Тревога", ANNOUNCER_ALIENS)

	return ..()

/mob/living/carbon/alien/humanoid/royal/queen/create_internal_organs()
	internal_organs += new /obj/item/organ/alien/plasmavessel/large/queen
	internal_organs += new /obj/item/organ/alien/resinspinner
	internal_organs += new /obj/item/organ/alien/acid
	internal_organs += new /obj/item/organ/alien/neurotoxin
	internal_organs += new /obj/item/organ/alien/eggsac
	..()

//Queen verbs
/datum/action/cooldown/alien/make_structure/lay_egg
	name = "Отложить яйца"
	desc = "Королева способна отложить кожистые яйца из которых в дальнейшем вырастут лицехваты, ужасающие паразиты, погубившие уже не одну колонию."
	button_icon_state = "alien_egg"
	plasma_cost = 75
	made_structure_type = /obj/structure/alien/egg

/datum/action/cooldown/alien/make_structure/lay_egg/Activate(atom/target)
	. = ..()
	owner.visible_message(span_alertalien("[owner] откладывает яйцо!"))

//Button to let queen choose her praetorian.
/datum/action/cooldown/alien/promote
	name = "Возвысить"
	desc = "Возведите одного из своих детей в статус гвардейца, увеличившись в размерах и силе он станет надежным помощником и охранником."
	button_icon_state = "alien_queen_promote"
	/// The promotion only takes plasma when completed, not on activation.
	var/promotion_plasma_cost = 500

/datum/action/cooldown/alien/promote/set_statpanel_format()
	. = ..()
	if(!islist(.))
		return

	.[PANEL_DISPLAY_STATUS] = "ПЛАЗМА - [promotion_plasma_cost]"

/datum/action/cooldown/alien/promote/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/carbon_owner = owner
	if(carbon_owner.getPlasma() < promotion_plasma_cost)
		return FALSE

	if(get_alien_type(/mob/living/carbon/alien/humanoid/royal/praetorian))
		return FALSE

	return TRUE

/datum/action/cooldown/alien/promote/Activate(atom/target)
	var/obj/item/queen_promotion/existing_promotion = locate() in owner.held_items
	if(existing_promotion)
		to_chat(owner, span_noticealien("Мне пока не понадобится [existing_promotion]."))
		owner.temporarilyRemoveItemFromInventory(existing_promotion)
		qdel(existing_promotion)
		return TRUE

	if(!owner.get_empty_held_indexes())
		to_chat(owner, span_warning("Мне нужны свободные руки для этого."))
		return FALSE

	var/obj/item/queen_promotion/new_promotion = new(owner.loc)
	if(!owner.put_in_hands(new_promotion, del_on_fail = TRUE))
		to_chat(owner, span_noticealien("Не вышло подготовить паразита."))
		return FALSE

	to_chat(owner, span_noticealien("Введите королевского паразита одной из взрослых особей для того чтобы возвысить ее до преторианского гвардейца!"))
	return TRUE

/obj/item/queen_promotion
	name = "королевский паразит"
	desc = "Содержит в себе генетический мутатор, позволяющий возвысить одну из взрослых особей до преторианского гвардейца!"
	icon_state = "alien_medal"
	item_flags = ABSTRACT | DROPDEL
	icon = 'icons/mob/alien.dmi'

/obj/item/queen_promotion/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/queen_promotion/attack(mob/living/to_promote, mob/living/carbon/alien/humanoid/queen)
	. = ..()
	if(.)
		return

	var/datum/action/cooldown/alien/promote/promotion = locate() in queen.actions
	if(!promotion)
		CRASH("[type] was created and handled by a mob ([queen]) that didn't have a promotion action associated.")

	if(!isalienhumanoid(to_promote) || isalienroyal(to_promote))
		to_chat(queen, span_noticealien("Возвысить можно только взрослые, не королевские особи!"))
		return

	if(!promotion.IsAvailable())
		to_chat(queen, span_noticealien("Не могу возвысить на данный момент!"))
		return

	if(to_promote.stat != CONSCIOUS || !to_promote.mind || !to_promote.key)
		return

	queen.adjustPlasma(-promotion.promotion_plasma_cost)

	to_chat(queen, span_noticealien("Возвышаю [to_promote] до преторианца!"))
	to_promote.visible_message(
		span_alertalien("Тело [to_promote] начинает искажаться и увеличиваться!"),
		span_noticealien("Королева возвысила меня до преторианца!"),
	)

	var/mob/living/carbon/alien/humanoid/royal/praetorian/new_prae = new(to_promote.loc)
	to_promote.mind.transfer_to(new_prae)

	qdel(to_promote)
	qdel(src)
	return TRUE

/obj/item/queen_promotion/attack_self(mob/user)
	to_chat(user, span_noticealien("Мне пока не понадобится [src]."))
	qdel(src)

/obj/item/queen_promotion/dropped(mob/user, silent)
	if(!silent)
		to_chat(user, span_noticealien("Мне пока не понадобится [src]."))
	return ..()
