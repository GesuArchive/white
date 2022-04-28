/mob/living/carbon/alien/humanoid/royal
	//Common stuffs for Praetorian and Queen
	icon = 'icons/mob/alienqueen.dmi'
	status_flags = 0
	ventcrawler = VENTCRAWLER_NONE //pull over that ass too fat
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
	plane = GAME_PLANE_FOV_HIDDEN //So it won't hide smaller mobs.

/mob/living/carbon/alien/humanoid/royal/on_standing_up(new_lying_angle)
	. = ..()
	plane = initial(plane)

/mob/living/carbon/alien/humanoid/royal/can_inject(mob/user, target_zone, injection_flags)
	return FALSE

/mob/living/carbon/alien/humanoid/royal/queen
	name = "королева чужих"
	caste = "q"
	maxHealth = 400
	health = 400
	icon_state = "alienq"
	var/datum/action/small_sprite/smallsprite = new/datum/action/small_sprite/queen()

/mob/living/carbon/alien/humanoid/royal/queen/Initialize()
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

	AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/repulse/xeno(src))
	AddAbility(new/obj/effect/proc_holder/alien/royal/queen/promote())
	smallsprite.Grant(src)

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
/obj/effect/proc_holder/alien/lay_egg
	name = "Отложить яйца"
	desc = "Королева способна отложить кожистые яйца из которых в дальнейшем вырастут лицехваты, ужасающие паразиты, погубившие уже не одну колонию."
	plasma_cost = 75
	check_turf = TRUE
	action_icon_state = "alien_egg"

/obj/effect/proc_holder/alien/lay_egg/fire(mob/living/carbon/user)
	if(!check_vent_block(user))
		return FALSE

	if(locate(/obj/structure/alien/egg) in get_turf(user))
		to_chat(user, span_alertalien("Здесь уже есть яйцо."))
		return FALSE

	user.visible_message(span_alertalien("[user] откладывает яйцо!"))
	new /obj/structure/alien/egg(user.loc)
	return TRUE

//Button to let queen choose her praetorian.
/obj/effect/proc_holder/alien/royal/queen/promote
	name = "Возвысить"
	desc = "Возведите одного из своих детей в статус гвардейца, увеличившись в размерах и силе он станет надежным помощником и охранником."
	plasma_cost = 500 //Plasma cost used on promotion, not spawning the parasite.

	action_icon_state = "alien_queen_promote"



/obj/effect/proc_holder/alien/royal/queen/promote/fire(mob/living/carbon/alien/user)
	var/obj/item/queenpromote/prom
	if(get_alien_type(/mob/living/carbon/alien/humanoid/royal/praetorian/))
		to_chat(user, span_noticealien("У меня уже есть преторианец!"))
		return
	else
		for(prom in user)
			to_chat(user, span_noticealien("Мне пока не понадобится [prom]."))
			qdel(prom)
			return

		prom = new (user.loc)
		if(!user.put_in_active_hand(prom, 1))
			to_chat(user, span_warning("Мне нужны свободные руки для этого."))
			return
		else //Just in case telling the player only once is not enough!
			to_chat(user, span_noticealien("Введите королевского паразита одной из взрослых особей для того чтобы возвысить ее до преторианского гвардейца!"))
	return

/obj/item/queenpromote
	name = "королевский паразит"
	desc = "Содержит в себе генетический мутатор, позволяющий возвысить одну из взрослых особей до преторианского гвардейца!"
	icon_state = "alien_medal"
	item_flags = ABSTRACT | DROPDEL
	icon = 'icons/mob/alien.dmi'

/obj/item/queenpromote/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/queenpromote/attack(mob/living/M, mob/living/carbon/alien/humanoid/user)
	if(!isalienadult(M) || isalienroyal(M))
		to_chat(user, span_noticealien("Возвысить можно только взрослые, не королевские особи!"))
		return
	if(get_alien_type(/mob/living/carbon/alien/humanoid/royal/praetorian/))
		to_chat(user, span_noticealien("У меня уже есть преторианец!"))
		return

	var/mob/living/carbon/alien/humanoid/A = M
	if(A.stat == CONSCIOUS && A.mind && A.key)
		if(!user.usePlasma(500))
			to_chat(user, span_noticealien("Мне нужно по крайней мере 500 единиц плазмы для возвышения!"))
			return

		to_chat(A, span_noticealien("Королева возвысила меня до преторианца!"))
		user.visible_message(span_alertalien("Тело [A] начинает искажаться и увеличиваться!"))
		var/mob/living/carbon/alien/humanoid/royal/praetorian/new_prae = new (A.loc)
		A.mind.transfer_to(new_prae)
		qdel(A)
		qdel(src)
		return
	else
		to_chat(user, span_warning("Этот детеныш слишком вялый и не достоин статуса преторианца!"))

/obj/item/queenpromote/attack_self(mob/user)
	to_chat(user, span_noticealien("Мне пока не понадобится [src]."))
	qdel(src)
