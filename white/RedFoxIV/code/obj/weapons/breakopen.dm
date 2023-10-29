#define NO_AUTO_EJECT 0
#define AUTO_EJECT_SPENT 1
#define AUTO_EJECT_ALL 2
#define NO_MANUAL_EJECT 0
#define MANUAL_EJECT_SINGLE 1
#define MANUAL_EJECT_SPENT 2
#define MANUAL_EJECT_ALL 3


/obj/item/gun/breakopen
	name = "break-open gun"
	icon = 'white/RedFoxIV/icons/obj/weapons/breakopen.dmi'
	icon_state = "dshotgun"
	w_class = WEIGHT_CLASS_BULKY
	var/icon_state_closed = "dshotgun"
	var/icon_state_open = "dshotgun_open"

	var/open = FALSE
	///resets current_chamber to 1 when opening the gun.
	var/reset_current_chamber = TRUE
	/**Whether autoeject casings upon opening the gun. Autoejected casings are dropped on the floor.
	 * NO_AUTO_EJECT - Do not eject any casing when opening the gun
	 * AUTO_EJECT_SPENT - autoeject only spent casings
	 * AUTO_EJECT_ALL - autoeject all casings
	 */
	var/auto_eject = AUTO_EJECT_ALL
	/**
	 * Whether to eject casings when open and the user holding the gun clicks on it while it's open.
	 * NO_MANUAL_EJECT - Cannot manually remove a casing
	 * MANUAL_EJECT_SINGLE - ejects a single casing in user's hand when manually ejecting
	 * MANUAL_EJECT_ALL - ejects all casings on the floor when manually ejecting
	 * MANUAL_EJECT_SPENT - ejects all SPENT casings on the floor when manually ejecting.
	 */
	var/manual_eject = MANUAL_EJECT_SINGLE
	///Sound to play when opening
	var/open_sound = 'sound/weapons/gun/general/magazine_remove_full.ogg'
	///Sound to play when closing the gun
	var/close_sound = 'sound/weapons/gun/general/magazine_insert_full.ogg'
	var/insert_sound = 'sound/weapons/gun/general/mag_bullet_insert.ogg'
	///if we compare /breakopen type gun to a /ballistic type gun, they all have an internal magazine. Since we're not using a /ballistic type, we can cast away useless magazines and replace them with a list.
	var/list/obj/item/ammo_casing/magazine = list()
	///How much casings can the gun hold.
	var/max_ammo = 2
	///types of casings the gun can hold.
	var/list/casing_type = /obj/item/ammo_casing/shotgun
	///self-explanatory
	var/can_be_sawn_off = FALSE
	///goes from 1 to max_ammo when shooting.
	var/current_chamber = 1
	///whether this gun can shoot ALL rounds in one trigger pull if user's intent is harm. Typically possible on guns that have multiple triggers, like a double-barrel shotgun.
	var/can_fire_all_rounds_at_once = FALSE
	///for how many deciseconds to sleep between shots when shooting all rounds at once (see can_fire_all_rounds_at_once)
	var/sleep_time = 1

/obj/item/gun/breakopen/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][sawn_off ? "_sawn":""][open ? "_open" : ""]"

/obj/item/gun/breakopen/handle_atom_del(atom/A)
	. = ..()
	if(magazine.Find(A))
		magazine -= A


/obj/item/gun/breakopen/attack_self(mob/living/user)
	open = !open
	if(open)
		if(reset_current_chamber)
			current_chamber = 1
		playsound(user, open_sound, 40, TRUE)
		autoeject()
	else
		playsound(user, close_sound, 40, TRUE)
	update_icon()



/obj/item/gun/breakopen/attack_hand(mob/user)
	if(!loc == user || !user.is_holding(src) || !open || !magazine.len)
		return ..()
	manualeject(user)

/obj/item/gun/breakopen/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(can_be_sawn_off)
		sawoff(user, I)


	if(istype(I, /obj/item/ammo_casing))
		if(!open)
			to_chat(user, span_notice("Can't load [src.name] while it's closed!"))
			return

		if(!istype(I, casing_type))
			to_chat(user, span_notice("[src.name] does not accept [I.name]!"))
			return
		var/current_ammo = magazine.len
		if(current_ammo + 1 > max_ammo)
			to_chat(user, span_notice("[src.name] is full!"))
			return
		to_chat(user, span_notice("Вставляю [I.name] в <b>[src.name]</b>."))
		playsound(src, insert_sound, 40, TRUE)
		I.forceMove(src)
		magazine.Add(I)

/obj/item/gun/breakopen/proc/autoeject()
	if(auto_eject == NO_AUTO_EJECT)
		return
	for(var/obj/item/ammo_casing/AC in magazine)
		if(AC.loaded_projectile && auto_eject != AUTO_EJECT_ALL)
			continue
		magazine.Remove(AC)
		AC.forceMove(drop_location())
		AC.bounce_away()

/obj/item/gun/breakopen/proc/manualeject(mob/user)
	switch(manual_eject)
		if(NO_MANUAL_EJECT)
			return

		if(MANUAL_EJECT_SINGLE)
			var/obj/item/ammo_casing/AC = magazine?[1]
			if(!AC) // check if we have anything to eject
				return
			magazine -= AC
			if(!user.put_in_hands(AC))
				AC.bounce_away()

		if(MANUAL_EJECT_SPENT to MANUAL_EJECT_ALL)
			for(var/obj/item/ammo_casing/AC in magazine)
				if(AC.loaded_projectile && manual_eject != MANUAL_EJECT_ALL)
					continue
				magazine -= AC
				AC.forceMove(drop_location())
				AC.bounce_away()


/obj/item/gun/breakopen/afterattack(atom/target, mob/living/user, flag, params, aimed)
	if(open)
		to_chat(user, span_notice("Can't fire [src.name] while it's open!"))
		return
	if(can_fire_all_rounds_at_once && user.a_intent == INTENT_HARM && max_ammo > 1 && magazine.len)
		for(var/obj/item/ammo_casing/AC in magazine)
			chambered = AC
			. = ..()
			sleep(1)
		return
	chambered = null
	if(current_chamber <= magazine.len)
		chambered = magazine[current_chamber]
	. = ..()
	current_chamber = (current_chamber % max_ammo) + 1

/obj/item/gun/breakopen/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread, aimed)
	if (sawn_off)
		bonus_spread += SAWN_OFF_ACC_PENALTY
	. = ..()

/obj/item/gun/breakopen/proc/sawoff(mob/user, obj/item/saw)
	if(!saw.get_sharpness() || (!is_type_in_typecache(saw, GLOB.gun_saw_types) && saw.tool_behaviour != TOOL_SAW)) //needs to be sharp. Otherwise turned off eswords can cut this.
		return
	if(sawn_off)
		to_chat(user, span_warning("<b>[capitalize(src)]</b> уже обрезан!"))
		return
	if(bayonet)
		to_chat(user, span_warning("Не могу отпилить <b>[src.name]</b> с прикрепленным [bayonet]!"))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_notice("[user] начинает обрезать <b>[src.name]</b>.") , span_notice("Начинаю обрезать <b>[src.name]</b>..."))

	//if there's any live ammo inside the gun, makes it go off
	if(blow_up(user))
		user.visible_message(span_danger("<b>[capitalize(src)]</b> отлетает!") , span_danger("<b>[capitalize(src)]</b> отлетает в мое лицо!"))
		return

	if(do_after(user, 30, target = src))
		if(sawn_off)
			return
		user.visible_message(span_notice("[user] обзрезал <b>[src.name]</b>!") , span_notice("Обрезал <b>[src.name]</b>."))
		name = "обрезанный [src.name]"
		desc = sawn_desc
		w_class = WEIGHT_CLASS_NORMAL
		inhand_icon_state = "gun"
		worn_icon_state = "gun"
		slot_flags &= ~ITEM_SLOT_BACK	//you can't sling it on your back
		slot_flags |= ITEM_SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
		recoil = SAWN_OFF_RECOIL
		sawn_off = TRUE
		update_icon()
		return TRUE

/obj/item/gun/breakopen/proc/blow_up(mob/user)
	if(!magazine.len)
		return FALSE
	for(var/obj/item/ammo_casing/AC in magazine)
		if(AC.loaded_projectile)
			chambered = AC
			process_fire(user, user, FALSE)
			. = TRUE



#undef NO_AUTO_EJECT
#undef AUTO_EJECT_SPENT
#undef AUTO_EJECT_ALL
#undef NO_MANUAL_EJECT
#undef MANUAL_EJECT_SINGLE
#undef MANUAL_EJECT_SPENT
#undef MANUAL_EJECT_ALL
