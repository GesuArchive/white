/obj/item/gun/magic/staff
	slot_flags = ITEM_SLOT_BACK
	ammo_type = /obj/item/ammo_casing/magic/nothing
	worn_icon_state = null
	icon_state = "staff"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	item_flags = NEEDS_PERMIT | NO_MAT_REDEMPTION
	var/allow_intruder_use = FALSE

/obj/item/gun/magic/staff/proc/is_wizard_or_friend(mob/user)
	if(!user?.mind?.has_antag_datum(/datum/antagonist/wizard) \
		&& !user.mind.has_antag_datum(/datum/antagonist/survivalist/magic) \
		&& !user.mind.has_antag_datum(/datum/antagonist/wizard_minion))
		return FALSE
	return TRUE

/obj/item/gun/magic/staff/check_botched(mob/living/user, atom/target)
	if(allow_intruder_use)
		return ..()

	if(!is_wizard_or_friend(user))
		return !on_intruder_use(user, target)
	return ..()

/// Called when someone who isn't a wizard or magician uses this staff.
/// Return TRUE to allow usage.
/obj/item/gun/magic/staff/proc/on_intruder_use(mob/living/user, atom/target)
	return TRUE

/obj/item/gun/magic/staff/change
	name = "посох перемен"
	desc = "Артефакт испускающий лучи сверкающей энергии, заставляющей форму цели менять саму себя."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "staffofchange"
	inhand_icon_state = "staffofchange"
	school = SCHOOL_TRANSMUTATION

/obj/item/gun/magic/staff/change/unrestricted
	allow_intruder_use = TRUE

/obj/item/gun/magic/staff/change/pickup(mob/user)
	. = ..()
	if(!is_wizard_or_friend(user))
		to_chat(user, span_hypnophrase("<span style='font-size: 24px'>You don't feel strong enough to properly wield this staff!</span>"))
		balloon_alert(user, "you feel weak holding this staff")

/obj/item/gun/magic/staff/change/on_intruder_use(mob/living/user, atom/target)
	user.dropItemToGround(src, TRUE)
	var/randomize = pick("monkey","humanoid","animal")
	var/mob/new_body = wabbajack(user, randomize)
	balloon_alert(new_body, "wabbajack, wabbajack!")

/obj/item/gun/magic/staff/animate
	name = "посох анимации"
	desc = "Артефакт испускающий лучи жизненной силы, которая анимирует и оживляет коснувшиеся её объекты! Эта магия не действует на механизмы."
	fire_sound = 'sound/magic/staff_animation.ogg'
	ammo_type = /obj/item/ammo_casing/magic/animate
	icon_state = "staffofanimation"
	inhand_icon_state = "staffofanimation"
	school = SCHOOL_EVOCATION

/obj/item/gun/magic/staff/healing
	name = "посох исцеления"
	desc = "Артефакт испускающий лучи восстанавливающей магии, способной исцелять все известные недуги и даже воскрешать мертвых."
	fire_sound = 'sound/magic/staff_healing.ogg'
	ammo_type = /obj/item/ammo_casing/magic/heal
	icon_state = "staffofhealing"
	inhand_icon_state = "staffofhealing"
	school = SCHOOL_RESTORATION
	var/obj/item/gun/medbeam/healing_beam

/obj/item/gun/magic/staff/healing/pickup(mob/user)
	. = ..()
	if(!is_wizard_or_friend(user))
		to_chat(user, span_hypnophrase("<span style='font-size: 24px'>The staff feels weaker as you touch it</span>"))
		balloon_alert(user, "the staff feels weaker as you touch it")

/obj/item/gun/magic/staff/healing/Initialize(mapload)
	. = ..()
	healing_beam = new(src)
	healing_beam.mounted = TRUE

/obj/item/gun/magic/staff/healing/Destroy()
	qdel(healing_beam)
	return ..()

/obj/item/gun/magic/staff/healing/unrestricted
	allow_intruder_use = TRUE

/obj/item/gun/magic/staff/healing/on_intruder_use(mob/living/user, atom/target)
	if(target == user)
		return FALSE
	healing_beam.process_fire(target, user)
	return FALSE

/obj/item/gun/magic/staff/healing/dropped(mob/user)
	healing_beam.LoseTarget()
	return ..()

/obj/item/gun/magic/staff/healing/handle_suicide() //Stops people trying to commit suicide to heal themselves
	return

/obj/item/gun/magic/staff/chaos
	name = "посох хаоса"
	desc = "Артефакт испускающий лучи хаотичной магии которая может привести к любым возможным последствиям."
	fire_sound = 'sound/magic/staff_chaos.ogg'
	ammo_type = /obj/item/ammo_casing/magic/chaos
	icon_state = "staffofchaos"
	inhand_icon_state = "staffofchaos"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1
	school = SCHOOL_FORBIDDEN //this staff is evil. okay? it just is. look at this projectile type list. this is wrong.
	var/allowed_projectile_types = list(/obj/projectile/magic/change, /obj/projectile/magic/animate, /obj/projectile/magic/resurrection,
	/obj/projectile/magic/death, /obj/projectile/magic/teleport, /obj/projectile/magic/door, /obj/projectile/magic/fireball,
	/obj/projectile/magic/spellblade, /obj/projectile/magic/arcane_barrage, /obj/projectile/magic/locker, /obj/projectile/magic/flying,
	/obj/projectile/magic/bounty, /obj/projectile/magic/antimagic, /obj/projectile/magic/fetch, /obj/projectile/magic/sapping,
	/obj/projectile/magic/necropotence, /obj/projectile/magic, /obj/projectile/temp/chill, /obj/projectile/magic/wipe)

/obj/item/gun/magic/staff/chaos/unrestricted
	allow_intruder_use = TRUE

/obj/item/gun/magic/staff/chaos/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	chambered.projectile_type = pick(allowed_projectile_types)
	. = ..()

/obj/item/gun/magic/staff/chaos/on_intruder_use(mob/living/user)
	if(user.anti_magic_check(TRUE, FALSE, FALSE)) // Don't let people with antimagic use the staff of chaos.
		balloon_alert(user, "the staff refuses to fire!")
		return FALSE

	if(prob(95)) // You have a 5% chance of hitting yourself when using the staff of chaos.
		return TRUE
	balloon_alert(user, "chaos!")
	user.dropItemToGround(src, TRUE)
	process_fire(user, user, FALSE)
	return FALSE

/obj/item/gun/magic/staff/door
	name = "посох создания дверей"
	desc = "Артефакт испускающий лучи трансформирующей магии, способной создавать двери в стенах."
	fire_sound = 'sound/magic/staff_door.ogg'
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "staffofdoor"
	inhand_icon_state = "staffofdoor"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1
	school = SCHOOL_TRANSMUTATION

/obj/item/gun/magic/staff/honk
	name = "посох хонкоматери"
	desc = "Хонк."
	fire_sound = 'sound/items/airhorn.ogg'
	ammo_type = /obj/item/ammo_casing/magic/honk
	icon_state = "honker"
	inhand_icon_state = "honker"
	max_charges = 4
	recharge_rate = 8
	school = SCHOOL_EVOCATION

/obj/item/gun/magic/staff/spellblade
	name = "зачарованный клинок"
	desc = "Смертельная комбинация лени и жажды крови, этот клинок позволяет рубить врагов без трудной части с маханием мечом."
	fire_sound = 'sound/magic/fireball.ogg'
	ammo_type = /obj/item/ammo_casing/magic/spellblade
	icon_state = "spellblade"
	inhand_icon_state = "spellblade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/rapierhit.ogg'
	force = 20
	armour_penetration = 75
	block_chance = 50
	sharpness = SHARP_EDGED
	max_charges = 4
	school = SCHOOL_EVOCATION

/obj/item/gun/magic/staff/spellblade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 15, 125, 0, hitsound)

/obj/item/gun/magic/staff/spellblade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = 0
	return ..()

/obj/item/gun/magic/staff/locker
	name = "посох блокировки"
	desc = "Артефакт испускающий лучи изолирующей магии, обезвреживающей ваших врагов."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/locker
	icon_state = "locker"
	inhand_icon_state = "locker"
	worn_icon_state = "lockerstaff"
	max_charges = 6
	recharge_rate = 4
	school = SCHOOL_TRANSMUTATION //in a way

//yes, they don't have sounds. they're admin staves, and their projectiles will play the chaos bolt sound anyway so why bother?

/obj/item/gun/magic/staff/flying
	name = "посох полета"
	desc = "Артефакт испускающий лучи грациозной магии, способной позволить чему-то летать."
	fire_sound = 'sound/magic/staff_healing.ogg'
	ammo_type = /obj/item/ammo_casing/magic/flying
	icon_state = "staffofflight"
	inhand_icon_state = "staffofchange"
	worn_icon_state = "flightstaff"
	school = SCHOOL_EVOCATION

/obj/item/gun/magic/staff/sapping
	name = "посох иссушения"
	desc = "Артефакт испускающий лучи иссушающей магии, способной сделать что-то грустное."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/sapping
	icon_state = "staffofsapping"
	inhand_icon_state = "staffofdoor"
	worn_icon_state = "sapstaff"
	school = SCHOOL_FORBIDDEN //evil

/obj/item/gun/magic/staff/necropotence
	name = "посох некросилы"
	desc = "Артефакт испускающий лучи смертельной магии, способной переиначить душу."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/necropotence
	icon_state = "staffofnecropotence"
	inhand_icon_state = "staffofchaos"
	worn_icon_state = "necrostaff"
	school = SCHOOL_NECROMANCY //REALLY evil

/obj/item/gun/magic/staff/wipe
	name = "посох владения"
	desc = "Артефакт, испускающий лучи магии, способной создать брешь в разуме жертвы, позволяя призракам вселиться в её разум."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/wipe
	icon_state = "staffofwipe"
	inhand_icon_state = "pharoah_sceptre"
	worn_icon_state = "wipestaff"
	school = SCHOOL_FORBIDDEN //arguably the worst staff in the entire game effect wise
