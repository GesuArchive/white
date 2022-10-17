/datum/action/item_action/toggle_stick
	name = "Получить хоккейную клюшку"

/datum/action/item_action/make_puck
	name = "Произвести голошайбу"


/obj/item/storage/box/syndie_kit/hockey
	name = "Набор канадского хоккеиста" //перевод минимален но мне похуй блядь я ебал вставлять целый лор в один набор
	desc = "Знаменитый набор канадских боевых сил для выживания в экстремальных условиях. ПРЕДУПРЕЖДЕНИЕ: Как только он надет, его больше нельзя будет снять."

/obj/item/storage/box/syndie_kit/hockey/PopulateContents()
	new /obj/item/hockeypack(src)
	new /obj/item/storage/belt/hippie/hockey(src)
	new /obj/item/clothing/suit/hippie/hockey(src)
	new /obj/item/clothing/shoes/hippie/hockey(src)
	new /obj/item/clothing/mask/hippie/hockey(src)
	new /obj/item/clothing/head/hippie/hockey(src)
	new /obj/item/autosurgeon/organ/nutriment/plus(src) // а как жрать???


#define HOCKEYSTICK_CD	1.3
#define PUCK_STUN_AMT	2

/obj/item/hockeypack
	name = "Рюкзак канадских специальных спортивных сил"
	desc = "Держит в себе и снабжает энергией канадскую клюшку для хоккея, которая способна откидывать людей на 10 метров"
	icon = 'white/deda565/hippiehockey.dmi'
	icon_state = "hockey_bag"
	worn_icon = 'white/deda565/hockeyworn.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	actions_types = list(/datum/action/item_action/toggle_stick)
	var/obj/item/hockeystick/packstick
	var/on = FALSE
	var/volume = 500

/obj/item/hockeypack/equipped(mob/user, slot)
	. = ..()
	if (slot != ITEM_SLOT_BACK) //The Pack is cursed so this should not happen, but i'm going to play it safe.
		remove_stick()
	if(slot == ITEM_SLOT_BACK)
		ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/hockeypack/ui_action_click()
	toggle_stick()

/obj/item/hockeypack/Initialize(mapload)
	. = ..()
	packstick = make_stick()

/obj/item/hockeypack/proc/toggle_stick()
	set name = "Get Stick"
	set category = "Объект"
	if (usr.get_item_by_slot(usr.getHockeypackSlot()) != src)
		to_chat(usr, "<span class='warning'>Рюкзак надень!</span>")
		return
	if(usr.incapacitated())
		return
	on = !on

	var/mob/living/carbon/human/user = usr
	if(on)
		if(!packstick)
			packstick = make_stick()

		if(!user.put_in_hands(packstick))
			on = FALSE
			to_chat(user, "<span class='warning'>Руки заняты!</span>")
			return
	else
		remove_stick()
	return

/obj/item/hockeypack/proc/make_stick()
	return new /obj/item/hockeystick(src)

/obj/item/hockeypack/proc/remove_stick()
	if(ismob(packstick.loc))
		var/mob/M = packstick.loc
		M.temporarilyRemoveItemFromInventory(packstick, TRUE)
	return

/obj/item/hockeypack/Destroy()
	if (on)
		remove_stick()
		QDEL_NULL(packstick)
	return ..()

/obj/item/hockeypack/attack_hand(mob/user)
	if(src.loc == user)
		ui_action_click()
		return
	..()

/obj/item/hockeypack/MouseDrop(obj/over_object)
	var/mob/M = src.loc
	if(istype(M) && istype(over_object, /atom/movable/screen/inventory/hand ))
		var/atom/movable/screen/inventory/hand/H = over_object
		if(!M.temporarilyRemoveItemFromInventory(src))
			return
		M.put_in_hand(src, H.held_index)

/obj/item/hockeypack/attackby(obj/item/W, mob/user, params)
	if(W == packstick)
		remove_stick()
		return
	..()

/obj/item/hockeypack/item_action_slot_check(slot, mob/user)
	if(slot == user.getBackSlot())
		return TRUE

/mob/proc/getHockeypackSlot()
	return ITEM_SLOT_BACK

/obj/item/hockeystick
	icon = 'white/deda565/hippiehockey.dmi'
	icon_state = "hockeystick0"
	name = "Канадская хоккейная клюшка"
	desc = "Канадская клюшка для жестокого спорта, она привязана и получает энергию от рюкзака."
	icon = 'white/deda565/hippiehockey.dmi'
	lefthand_file = 'white/deda565/lefthockey.dmi'
	righthand_file = 'white/deda565/righthockey.dmi'
	force = 5
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	throwforce = 3
	throw_speed = 4
	attack_verb_simple = list("smack", "thwack", "bash", "struck", "batter")
	attack_verb_continuous = list("smacks", "thwacks", "bashes", "strucks", "batters")
	sharpness = SHARP_EDGED
	block_chance = 20
	var/obj/item/hockeypack/pack
	var/wielded = FALSE

/obj/item/hockeystick/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/hockeystick/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=10, force_wielded=25, icon_wielded="hockeystick1")

/obj/item/hockeystick/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/obj/item/hockeystick/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/hockeystick/update_icon_state()
	icon_state = "hockeystick[wielded]"
	return

/obj/item/hockeystick/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/item/hockeypack))
		pack = loc
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/hockeystick/Destroy()
	pack = null
	return ..()

/obj/item/hockeystick/attack(mob/living/target, mob/living/user) //Sure it's the powerfist code, right down to the sound effect. Gonna be fun though.
	if(!wielded)
		return ..()

	target.apply_damage(force, BRUTE)	//If it's a mob but not a humanoid, just give it plain brute damage.

	target.visible_message("<span class='danger'>[target.name] was pucked by [user] 'eh!</span>", \
		"<span class='userdanger'>You hear a loud crack 'eh!</span>", \
		"<span class='italics'>You hear the sound of bones crunching 'eh!</span>")

	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, 10, 1)	//Throws the target 10 tiles

	playsound(loc, 'sound/weapons/resonator_blast.ogg', 50, 1)

	log_combat(user, target, "used a hockey stick on", src) //Very unlikeley non-antags are going to get their hands on this but just in case...

	user.changeNext_move(CLICK_CD_MELEE * HOCKEYSTICK_CD)


	return

/obj/item/hockeystick/afterattack(obj/item/holopuck/O, mob/living/user) //Sure it's the powerfist code, right down to the sound effect. Gonna be fun though.
	if(!wielded)
		return ..()
	if(istype(O, /obj/item/holopuck))
		var/atom/throw_target = get_edge_target_turf(O, get_dir(src, get_step_away(O, src)))
		O.throw_at(throw_target, 10, 1, params = TRUE)	//Throws the target 10 tiles
		playsound(loc, 'sound/weapons/resonator_blast.ogg', 50, 1)
		QDEL_IN(O, 2 SECONDS)
		return
	else
		return ..()

/obj/item/hockeystick/dropped(mob/user) //The Stick is undroppable but just in case they lose an arm better put this here.
	. = ..()
	to_chat(user, "<span class='notice'>Палка забирается назад в рюкзак!</span>")
	snap_back()

/obj/item/hockeystick/proc/snap_back()
	if(!pack)
		return
	pack.on = FALSE
	forceMove(pack)

/obj/item/hockeystick/Move()
	. = ..()
	if(loc != pack.loc)
		snap_back()

/obj/item/hockeystick/IsReflect()
	return (wielded)

/obj/item/storage/belt/hippie/hockey
	name = "Генератор голошайб"
	desc = "Пояс с возможностью создавать голошайбы, которые способны сбивать с ног. Имеет карман для двух шайб."
	icon = 'white/deda565/hippiehockey.dmi'
	icon_state = "hockey_belt"
	worn_icon = 'white/deda565/hockeyworn.dmi'
	actions_types = list(/datum/action/item_action/make_puck)
	var/recharge_time = 100
	var/charged = TRUE

/obj/item/storage/belt/hippie/hockey/Initialize()
	. = ..()
	atom_storage.max_slots = 2
	atom_storage.can_hold = typecacheof(list(/obj/item/holopuck))

/obj/item/storage/belt/hippie/hockey/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_BELT)
		ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/storage/belt/hippie/hockey/item_action_slot_check(slot, mob/user)
	. = ..()
	if(slot == user.getBeltSlot())
		return TRUE

/obj/item/storage/belt/hippie/hockey/ui_action_click()
	make_puck()

/obj/item/storage/belt/hippie/hockey/proc/make_puck()
	set name = "Produce Puck"
	set category = "Объект"
	if (usr.get_item_by_slot(usr.getHockeybeltSlot()) != src)
		to_chat(usr, "<span class='warning'>Пояс надень!</span>")
		return
	if(usr.incapacitated())
		return

	var/mob/living/carbon/human/user = usr

	if(!charged)
		to_chat(user, "<span class='warning'>Пояс заряжается!</span>")
		return

	var/obj/item/holopuck/newpuck = new /obj/item/holopuck(get_turf(user))

	charged = FALSE
	addtimer(CALLBACK(src,.proc/reset_puck, user), recharge_time)

	if(!user.put_in_hands(newpuck))
		to_chat(user, "<span class='warning'>Шайба на полу!</span>")
		return

/mob/proc/getHockeybeltSlot()
	return ITEM_SLOT_BELT

/obj/item/storage/belt/hippie/hockey/proc/reset_puck(mob/user)
	charged = TRUE
	if(user)
		to_chat(user, "<span class='notice'>Пояс готов произвести новую голошайбу!</span>")

/obj/item/holopuck
	name = "Голошайба"
	desc = "Маленький заряженный диск"
	icon = 'icons/obj/shields.dmi'
	icon_state = "eshield"
	w_class = WEIGHT_CLASS_SMALL
	force = 3
	throwforce = 20 //ДААА ДААЙ БАФФ

/obj/item/holopuck/throw_impact(atom/hit_atom)
	. = ..()
	if(..() || !iscarbon(hit_atom))
		return
	var/mob/living/carbon/C = hit_atom
	C.apply_effect(PUCK_STUN_AMT, EFFECT_STUN)
	C.apply_damage((throwforce * 2), STAMINA) //This way the stamina damage is ALSO buffed by special throw items, the hockey stick for example.
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	visible_message("<span class='danger'>[C] has been dazed by a holopuck!</span>", \
						"<span class='userdanger'>[C] has been dazed by a holopuck!</span>")
	qdel(src)

/obj/item/holopuck/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE, quickstart = TRUE, params = FALSE)
	. = ..()
	if(params)
		throwforce = 30
	else
		throwforce = 12
	return

/obj/item/clothing/suit/hippie/hockey
	name = "Канадский зимний спортивный костюм"
	desc = "Броня, используемая канадцами для хоккея. Защищает тебя от всего, включая твоих врагов."
	icon = 'white/deda565/hippiehockey.dmi'
	icon_state = "hockey_suit"
	worn_icon = 'white/deda565/hockeyworn.dmi'
	clothing_flags = STOPSPRESSUREDAMAGE
	allowed = list(/obj/item/tank/internals)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE
	armor = list(MELEE = 70, BULLET = 45, LASER = 80, ENERGY = 45, BOMB = 75, BIO = 0, RAD = 30, FIRE = 80, ACID = 100, WOUND = 100) //хоккеисту сломали колени
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | FREEZE_PROOF
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/hippie/hockey/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		var/area/A = get_area(user)
		priority_announce("ВНИМАНИЕ! На вашей станции стартовал полуфинал Канадского хоккейного турнира! Приглашенная звезда матча [user] открыла сезон в [A.name]!", "Экстренные новости!", sound('white/Feline/sounds/hokkey.ogg'), sender_override="Синдикат")

/obj/item/clothing/shoes/hippie/hockey
	name = "Канадские коньки"
	desc = "Пара вездеходных коньков"
	icon = 'white/deda565/hippiehockey.dmi'
	icon_state = "hockey_shoes"
	worn_icon = 'white/deda565/hockeyworn.dmi'
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | FREEZE_PROOF
	slowdown = -1

/obj/item/clothing/shoes/hippie/hockey/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_FEET)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/mask/hippie/hockey
	name = "Канадская хоккейная маска"
	desc = "Теперь тебе не сломают нос одной шайбой."
	icon = 'white/deda565/hippiehockey.dmi'
	icon_state = "hockey_mask"
	worn_icon = 'white/deda565/hockeyworn.dmi'
	clothing_flags = MASKINTERNALS
	visor_flags = MASKINTERNALS
	flags_cover = MASKCOVERSMOUTH
	flags_1 = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | FREEZE_PROOF

/obj/item/clothing/mask/hippie/hockey/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_MASK)
		ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/clothing/head/hippie/hockey
	name = "Канадский хоккейный шлем"
	desc = "Боевой канадский хоккейный шлем, защищающий от всего. Теперь точно нос шайбой не разобьёт."
	icon = 'white/deda565/hippiehockey.dmi'
	icon_state = "hockey_helmet"
	worn_icon = 'white/deda565/hockeyworn.dmi'
	armor = list("melee" = 80, "bullet" = 40, "laser" = 80,"energy" = 45, "bomb" = 50, "bio" = 10, "rad" = 0, "fire" = 80, "acid" = 100, "wound" = 100)
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | FREEZE_PROOF
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/head/hockey/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HEAD)
		ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/datum/action/item_action/toggle_stick
	name = "Получить клюшку"

/datum/action/item_action/make_puck
	name = "Сделать шайбу"

#undef HOCKEYSTICK_CD
#undef PUCK_STUN_AMT
