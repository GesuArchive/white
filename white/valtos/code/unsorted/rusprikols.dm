/obj/vehicle/sealed/mecha/working/ripley/buran
	desc = "Гарантия тоталитарной власти. Держится на духовных скрепах."
	name = "APLU MK-IV \"Буран\""
	icon = 'white/valtos/icons/mecha.dmi'
	icon_state = "buran"
	max_temperature = 65000
	max_integrity = 150
	fast_pressure_step_in = 2 //step_in while in low pressure conditions
	slow_pressure_step_in = 4 //step_in while in normal pressure conditions
	movedelay = 4
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	lights_power = 7
	armor = list("melee" = 80, "bullet" = 60, "laser" = 60, "energy" = 60, "bomb" = 90, "bio" = 0, "rad" = 90, "fire" = 100, "acid" = 100)
	wreckage = /obj/structure/mecha_wreckage/ripley/buran
	enclosed = TRUE
	enter_delay = 40
	silicon_icon_state = null
	opacity = TRUE
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/obj/structure/mecha_wreckage/ripley/buran
	name = "Ошмётки Бурана"
	icon_state = "buran-broken"

/obj/machinery/porta_turret/armory
	name = "оборонительная турель"
	desc = "Автоматическая энерготурель с внутренним термоядерным ядром. Ни в малейшей степени не опасно."
	installation = null
	stun_projectile = /obj/projectile/energy/electrode
	stun_projectile_sound = 'sound/weapons/taser.ogg'
	lethal_projectile = /obj/projectile/beam/laser/penetrator
	lethal_projectile_sound = 'sound/weapons/lasercannonfire.ogg'
	max_integrity = 300
	mode = TURRET_LETHAL
	uses_stored = FALSE
	always_up = TRUE
	turret_flags = TURRET_FLAG_SHOOT_ALL_REACT
	has_cover = FALSE
	scan_range = 9
	shot_delay = 15
	use_power = NO_POWER_USE
	faction = list("silicon","turret")
	var/def_area

/obj/machinery/porta_turret/armory/ComponentInitialize()
	. = ..()
	AddComponent(/datum/element/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES)

/obj/machinery/porta_turret/armory/setup()
	var/area/A = get_area(src)
	def_area = A?.type
	return

/obj/machinery/porta_turret/armory/interact(mob/user)
	return

/obj/machinery/porta_turret/armory/assess_perp(mob/living/carbon/human/perp)
	. = ..()
	if(. && istype(get_area(perp), def_area))
		return 10
	return 0

/obj/machinery/porta_turret/armory/low_power
	lethal_projectile = /obj/projectile/beam/laser

/obj/projectile/beam/laser/penetrator
	damage = 40
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB))
	range = 9

/obj/item/melee/classic_baton/dildon
	name = "дилдо"
	desc = "При неправильном обращении окажется у меня в жопе."
	icon = 'white/valtos/icons/melee.dmi'
	icon_state = "dildo"
	inhand_icon_state = "dildo"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 10
	w_class = WEIGHT_CLASS_NORMAL
	cooldown = 40

/mob/living
	var/headstamp //надпись на башне

/datum/emote/living/ask_to_stop
	key = "ats"
	ru_name = "ОСТАНОВИТЬ"
	key_third_person = "ats"
	message = "жестом просит остановиться!"
	emote_type = EMOTE_VISIBLE|EMOTE_AUDIBLE

/datum/emote/living/ask_to_stop/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return pick('white/valtos/sounds/emotes/hey_female_1.ogg',\
							'white/valtos/sounds/emotes/hey_female_2.ogg')
			else
				return pick('white/valtos/sounds/emotes/hey_male_1.ogg',\
							'white/valtos/sounds/emotes/hey_male_2.ogg')
