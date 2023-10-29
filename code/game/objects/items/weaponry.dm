/obj/item/banhammer
	desc = "A banhammer."
	name = "banhammer"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "toyhammer"
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	force = 1
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	attack_verb_continuous = list("пермабанит")
	attack_verb_simple = list("пермабанит")
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 70)
	resistance_flags = FIRE_PROOF

/obj/item/banhammer/suicide_act(mob/user)
		user.visible_message(span_suicide("[user] is hitting [user.ru_na()]self with [src]! It looks like [user.p_theyre()] trying to ban [user.ru_na()]self from life."))
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)
/*
oranges says: This is a meme relating to the english translation of the ss13 russian wiki page on lurkmore.
mrdoombringer sez: and remember kids, if you try and PR a fix for this item's grammar, you are admitting that you are, indeed, a newfriend.
for further reading, please see: https://github.com/tgstation/tgstation/pull/30173 and https://translate.google.com/translate?sl=auto&tl=en&js=y&prev=_t&hl=en&ie=UTF-8&u=%2F%2Flurkmore.to%2FSS13&edit-text=&act=url
*/
/obj/item/banhammer/attack(mob/M, mob/user)
	if(user.zone_selected == BODY_ZONE_HEAD)
		M.visible_message(span_danger("[user] are stroking the head of [M] with a bangammer.") , span_userdanger("[user] are stroking your head with a bangammer.") , span_hear("You hear a bangammer stroking a head.")) // see above comment
	else
		M.visible_message(span_danger("[M] has been banned FOR NO REISIN by [user]!") , span_userdanger("You have been banned FOR NO REISIN by [user]!") , span_hear("You hear a banhammer banning someone."))
	playsound(loc, 'sound/effects/adminhelp_old.ogg', 30) //keep it at 15% volume so people don't jump out of their skin too much
	if(user.a_intent != INTENT_HELP)
		return ..(M, user)

/obj/item/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	inhand_icon_state = "sord"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 2
	throwforce = 1
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	attack_verb_continuous = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")

/obj/item/sord/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] пытается impale [user.ru_na()]self with [src]! It might be a suicide attempt if it weren't so shitty.") , \
	span_suicide("Пытаюсь impale yourself with [src], but it's USELESS..."))
	return SHAME

/obj/item/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 40
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("атакует", "рубит", "втыкает", "прорезает", "кромсает", "подрезает", "нарезает", "режет")
	attack_verb_simple = list("атакует", "рубит", "втыкает", "прорезает", "кромсает", "подрезает", "нарезает", "режет")
	block_chance = 50
	block_sounds = list('sound/weapons/sword_p1.ogg', 'sound/weapons/sword_p2.ogg', 'sound/weapons/sword_p3.ogg')
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF

/obj/item/claymore/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 40, 105)

/obj/item/claymore/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is falling on [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return(BRUTELOSS)

//statistically similar to e-cutlasses
/obj/item/claymore/cutlass
	name = "cutlass"
	desc = "A piratey sword used by buckaneers to \"negotiate\" the transfer of treasure."
	icon_state = "cutlass"
	inhand_icon_state = "cutlass"
	worn_icon_state = "cutlass"
	slot_flags = ITEM_SLOT_BACK
	force = 30
	throwforce = 20
	throw_speed = 3
	throw_range = 5
	armour_penetration = 35

/obj/item/claymore/highlander //ALL COMMENTS MADE REGARDING THIS SWORD MUST BE MADE IN ALL CAPS
	desc = "<b><i>THERE CAN BE ONLY ONE, AND IT WILL BE YOU!!!</i></b>\nActivate it in your hand to point to the nearest victim."
	flags_1 = CONDUCT_1
	item_flags = DROPDEL //WOW BRO YOU LOST AN ARM, GUESS WHAT YOU DONT GET YOUR SWORD ANYMORE //I CANT BELIEVE SPOOKYDONUT WOULD BREAK THE REQUIREMENTS
	slot_flags = null
	block_chance = 0 //RNG WON'T HELP YOU NOW, PANSY
	light_range = 3
	attack_verb_continuous = list("потрошит", "уничтожает", "проламывает", "унижает", "разрубает") //ONLY THE MOST VISCERAL ATTACK VERBS
	attack_verb_simple = list("потрошит", "уничтожает", "проламывает", "унижает", "разрубает") //Я БРУТАЛЛИРОВАЛ ПЕРЕПОДЧИКОВ ЭТОГО ГОВНА
	var/notches = 0 //HOW MANY PEOPLE HAVE BEEN SLAIN WITH THIS BLADE
	var/obj/item/disk/nuclear/nuke_disk //OUR STORED NUKE DISK

/obj/item/claymore/highlander/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER)
	START_PROCESSING(SSobj, src)

/obj/item/claymore/highlander/Destroy()
	if(nuke_disk)
		nuke_disk.forceMove(get_turf(src))
		nuke_disk.visible_message(span_warning("The nuke disk is vulnerable!"))
		nuke_disk = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/claymore/highlander/process()
	if(ishuman(loc))
		var/mob/living/carbon/human/holder = loc
		SET_PLANE_EXPLICIT(holder, GAME_PLANE_UPPER_FOV_HIDDEN, src) //NO HIDING BEHIND PLANTS FOR YOU, DICKWEED (HA GET IT, BECAUSE WEEDS ARE PLANTS)
		ADD_TRAIT(holder, TRAIT_NOBLEED, HIGHLANDER_TRAIT) //AND WE WON'T BLEED OUT LIKE COWARDS
	else
		if(!(flags_1 & ADMIN_SPAWNED_1))
			qdel(src)


/obj/item/claymore/highlander/pickup(mob/living/user)
	. = ..()
	to_chat(user, span_notice("The power of Scotland protects you! You are shielded from all stuns and knockdowns."))
	user.add_stun_absorption("highlander", INFINITY, 1, " is protected by the power of Scotland!", "The power of Scotland absorbs the stun!", " is protected by the power of Scotland!")
	user.ignore_slowdown(HIGHLANDER)

/obj/item/claymore/highlander/dropped(mob/living/user)
	. = ..()
	user.unignore_slowdown(HIGHLANDER)

/obj/item/claymore/highlander/examine(mob/user)
	. = ..()
	. += "<hr>It has [!notches ? "nothing" : "[notches] notches"] scratched into the blade."
	if(nuke_disk)
		. += span_boldwarning("\nIt's holding the nuke disk!")

/obj/item/claymore/highlander/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!QDELETED(target) && target.stat == DEAD && target.mind && target.mind.special_role == "highlander")
		user.fully_heal(admin_revive = FALSE) //STEAL THE LIFE OF OUR FALLEN FOES
		add_notch(user)
		target.visible_message(span_warning("[target] crumbles to dust beneath [user] blows!") , span_userdanger("As you fall, your body crumbles to dust!"))
		target.dust()

/obj/item/claymore/highlander/attack_self(mob/living/user)
	var/closest_victim
	var/closest_distance = 255
	for(var/mob/living/carbon/human/scot in GLOB.player_list - user)
		if(scot.mind.special_role == "highlander" && (!closest_victim || get_dist(user, closest_victim) < closest_distance))
			closest_victim = scot
	for(var/mob/living/silicon/robot/siliscot in GLOB.player_list - user)
		if(siliscot.mind.special_role == "highlander" && (!closest_victim || get_dist(user, closest_victim) < closest_distance))
			closest_victim = siliscot

	if(!closest_victim)
		to_chat(user, span_warning("[capitalize(src.name)] thrums for a moment and falls dark. Perhaps there's nobody nearby."))
		return
	to_chat(user, span_danger("[capitalize(src.name)] thrums and points to the [dir2ru_text(get_dir(user, closest_victim))]."))

/obj/item/claymore/highlander/IsReflect()
	return 1 //YOU THINK YOUR PUNY LASERS CAN STOP ME?

/obj/item/claymore/highlander/proc/add_notch(mob/living/user) //DYNAMIC CLAYMORE PROGRESSION SYSTEM - THIS IS THE FUTURE
	notches++
	force++
	var/new_name = name
	switch(notches)
		if(1)
			to_chat(user, span_notice("Your first kill - hopefully one of many. You scratch a notch into [src] blade."))
			to_chat(user, span_warning("You feel your fallen foe's soul entering your blade, restoring your wounds!"))
			new_name = "notched claymore"
		if(2)
			to_chat(user, span_notice("Another falls before you. Another soul fuses with your own. Another notch in the blade."))
			new_name = "double-notched claymore"
			add_atom_colour(rgb(255, 235, 235), ADMIN_COLOUR_PRIORITY)
		if(3)
			to_chat(user, span_notice("You're beginning to</span> <span class='danger'><b>relish</b> the <b>thrill</b> of <b>battle.</b>"))
			new_name = "triple-notched claymore"
			add_atom_colour(rgb(255, 215, 215), ADMIN_COLOUR_PRIORITY)
		if(4)
			to_chat(user, span_notice("You've lost count of</span> <span class='boldannounce'>how many you've killed."))
			new_name = "many-notched claymore"
			add_atom_colour(rgb(255, 195, 195), ADMIN_COLOUR_PRIORITY)
		if(5)
			to_chat(user, span_boldannounce("Five voices now echo in your mind, cheering the slaughter."))
			new_name = "battle-tested claymore"
			add_atom_colour(rgb(255, 175, 175), ADMIN_COLOUR_PRIORITY)
		if(6)
			to_chat(user, span_boldannounce("Is this what the vikings felt like? Visions of glory fill your head as you slay your sixth foe."))
			new_name = "battle-scarred claymore"
			add_atom_colour(rgb(255, 155, 155), ADMIN_COLOUR_PRIORITY)
		if(7)
			to_chat(user, span_boldannounce("Kill. Butcher. <i>Conquer.</i>"))
			new_name = "vicious claymore"
			add_atom_colour(rgb(255, 135, 135), ADMIN_COLOUR_PRIORITY)
		if(8)
			to_chat(user, span_userdanger("IT NEVER GETS OLD. THE <i>SCREAMING</i>. THE <i>BLOOD</i> AS IT <i>SPRAYS</i> ACROSS YOUR <i>FACE.</i>"))
			new_name = "bloodthirsty claymore"
			add_atom_colour(rgb(255, 115, 115), ADMIN_COLOUR_PRIORITY)
		if(9)
			to_chat(user, span_userdanger("ANOTHER ONE FALLS TO YOUR BLOWS. ANOTHER WEAKLING UNFIT TO LIVE."))
			new_name = "gore-stained claymore"
			add_atom_colour(rgb(255, 95, 95), ADMIN_COLOUR_PRIORITY)
		if(10)
			user.visible_message(span_warning("[user] eyes light up with a vengeful fire!") , \
			span_userdanger("YOU FEEL THE POWER OF VALHALLA FLOWING THROUGH YOU! <i>THERE CAN BE ONLY ONE!!!</i>"))
			user.update_icons()
			new_name = "GORE-DRENCHED CLAYMORE OF [pick("THE WHIMSICAL SLAUGHTER", "A THOUSAND SLAUGHTERED CATTLE", "GLORY AND VALHALLA", "ANNIHILATION", "OBLITERATION")]"
			icon_state = "claymore_gold"
			inhand_icon_state = "cultblade"
			remove_atom_colour(ADMIN_COLOUR_PRIORITY)

	name = new_name
	playsound(user, 'sound/items/screwdriver2.ogg', 50, TRUE)

/obj/item/claymore/highlander/robot //BLOODTHIRSTY BORGS NOW COME IN PLAID
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "claymore_cyborg"
	var/mob/living/silicon/robot/robot

/obj/item/claymore/highlander/robot/Initialize(mapload)
	var/obj/item/robot_module/kiltkit = loc
	robot = kiltkit.loc
	if(!istype(robot))
		qdel(src)
	return ..()

/obj/item/claymore/highlander/robot/process()
	SET_PLANE_IMPLICIT(loc, GAME_PLANE_UPPER_FOV_HIDDEN)

/obj/item/katana
	name = "катана"
	desc = "Woefully underpowered in D20."
	icon_state = "katana"
	inhand_icon_state = "katana"
	worn_icon_state = "katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 60
	throwforce = 10
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	block_sounds = list('sound/weapons/sword_p1.ogg', 'sound/weapons/sword_p2.ogg', 'sound/weapons/sword_p3.ogg')
	attack_verb_continuous = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	block_chance = 50
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF

/obj/item/katana/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is slitting [user.ru_ego()] stomach open with [src]! It looks like [user.p_theyre()] trying to commit seppuku!"))
	return(BRUTELOSS)

/obj/item/katana/cursed //used by wizard events, see the tendril_loot.dm file for the miner one
	slot_flags = null

/obj/item/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	inhand_icon_state = "rods"
	flags_1 = CONDUCT_1
	force = 9
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=1150, /datum/material/glass=75)
	attack_verb_continuous = list("бьёт", "ударяет", "вмазывает", "тычет")
	attack_verb_simple = list("бьёт", "ударяет", "вмазывает", "тычет")

/obj/item/wirerod/Initialize(mapload)
	. = ..()

	var/static/list/hovering_item_typechecks = list(
		/obj/item/shard = list(
			SCREENTIP_CONTEXT_LMB = "Сделать копьё",
		),

		/obj/item/assembly/igniter = list(
			SCREENTIP_CONTEXT_LMB = "Сделать шокер",
		),
	)

	AddElement(/datum/element/contextual_screentip_item_typechecks, hovering_item_typechecks)

/obj/item/wirerod/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/shard))
		var/obj/item/spear/S = new /obj/item/spear

		remove_item_from_storage(user)
		if (!user.transferItemToLoc(I, S))
			return
		S.CheckParts(list(I))
		qdel(src)

		user.put_in_hands(S)
		to_chat(user, span_notice("You fasten the glass shard to the top of the rod with the cable."))

	else if(istype(I, /obj/item/assembly/igniter) && !(HAS_TRAIT(I, TRAIT_NODROP)))
		var/obj/item/melee/baton/cattleprod/P = new /obj/item/melee/baton/cattleprod

		remove_item_from_storage(user)

		to_chat(user, span_notice("You fasten [I] to the top of the rod with the cable."))

		qdel(I)
		qdel(src)

		user.put_in_hands(P)
	else
		return ..()


/obj/item/throwing_star
	name = "throwing star"
	desc = "An ancient weapon still used to this day, due to its ease of lodging itself into its victim's body parts."
	icon_state = "throwingstar"
	inhand_icon_state = "eshield0"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	force = 2
	throwforce = 10 //10 + 2 (WEIGHT_CLASS_SMALL) * 4 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = 18 damage on hit due to guaranteed embedding
	throw_speed = 4
	embedding = list("pain_mult" = 4, "embed_chance" = 100, "fall_chance" = 0)
	armour_penetration = 40

	w_class = WEIGHT_CLASS_SMALL
	sharpness = SHARP_POINTY
	hitsound = 'sound/weapons/stab1.ogg'
	custom_materials = list(/datum/material/iron=500, /datum/material/glass=500)
	resistance_flags = FIRE_PROOF

/obj/item/throwing_star/stamina
	name = "shock throwing star"
	desc = "An aerodynamic disc designed to cause excruciating pain when stuck inside fleeing targets, hopefully without causing fatal harm."
	throwforce = 5
	embedding = list("pain_chance" = 5, "embed_chance" = 100, "fall_chance" = 0, "jostle_chance" = 10, "pain_stam_pct" = 0.8, "jostle_pain_mult" = 3)

/obj/item/throwing_star/toy
	name = "toy throwing star"
	desc = "An aerodynamic disc strapped with adhesive for sticking to people, good for playing pranks and getting yourself killed by security."
	sharpness = NONE
	force = 0
	throwforce = 0
	embedding = list("pain_mult" = 0, "jostle_pain_mult" = 0, "embed_chance" = 100, "fall_chance" = 0)

/obj/item/switchblade
	name = "switchblade"
	icon_state = "switchblade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	desc = "A sharp, concealable, spring-loaded knife."
	flags_1 = CONDUCT_1
	force = 3
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5
	throw_speed = 3
	throw_range = 6
	custom_materials = list(/datum/material/iron=12000)
	hitsound = 'sound/weapons/genhit.ogg'
	attack_verb_continuous = list("бьёт", "протыкает")
	attack_verb_simple = list("бьёт", "протыкает")
	resistance_flags = FIRE_PROOF
	/// Whether the switchblade starts extended or not.
	var/start_extended = FALSE

/obj/item/switchblade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/butchering, 7 SECONDS, 100)
	AddComponent(/datum/component/transforming, \
		start_transformed = start_extended, \
		force_on = 20, \
		throwforce_on = 23, \
		throw_speed_on = throw_speed, \
		sharpness_on = SHARP_EDGED, \
		hitsound_on = 'sound/weapons/sword_kill_slash_02.ogg', \
		w_class_on = WEIGHT_CLASS_NORMAL, \
		attack_verb_continuous_on = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts"), \
		attack_verb_simple_on = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut"))

/obj/item/switchblade/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is slitting [user.ru_ego()] own throat with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)

/obj/item/switchblade/extended
	start_extended = TRUE

/obj/item/phone
	name = "красный phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "red_phone"
	force = 3
	throwforce = 2
	throw_speed = 3
	throw_range = 4
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("вызывает", "звонит")
	attack_verb_simple = list("вызывает", "звонит")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/phone/suicide_act(mob/user)
	if(locate(/obj/structure/chair/stool) in user.loc)
		user.visible_message(span_suicide("[user] begins to tie a noose with [src] cord! It looks like [user.p_theyre()] trying to commit suicide!"))
	else
		user.visible_message(span_suicide("[user] is strangling [user.ru_na()]self with [src] cord! It looks like [user.p_theyre()] trying to commit suicide!"))
	return(OXYLOSS)

/obj/item/cane
	name = "cane"
	desc = "A cane used by a true gentleman. Or a clown."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "cane"
	inhand_icon_state = "stick"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	attack_verb_continuous = list("ударяет", "вмазывает", "учит", "лупит")
	attack_verb_simple = list("ударяет", "вмазывает", "учит", "лупит")

/obj/item/staff
	name = "wizard staff"
	desc = "Apparently a staff used by the wizard."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	armour_penetration = 100
	attack_verb_continuous = list("ударяет", "вмазывает", "учит")
	attack_verb_simple = list("ударяет", "вмазывает", "учит")
	resistance_flags = FLAMMABLE

/obj/item/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"
	resistance_flags = FLAMMABLE

/obj/item/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "cane"
	inhand_icon_state = "stick"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ectoplasm
	name = "ectoplasm"
	desc = "Spooky."
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/obj/item/ectoplasm/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is inhaling [src]! It looks like [user.p_theyre()] trying to visit the astral plane!"))
	return (OXYLOSS)

/obj/item/ectoplasm/angelic
	icon = 'icons/obj/wizard.dmi'
	icon_state = "angelplasm"

/obj/item/ectoplasm/mystic
	icon_state = "mysticplasm"


/obj/item/mounted_chainsaw
	name = "mounted chainsaw"
	desc = "A chainsaw that has replaced your arm."
	icon_state = "chainsaw_on"
	inhand_icon_state = "mounted_chainsaw"
	lefthand_file = 'icons/mob/inhands/weapons/chainsaw_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/chainsaw_righthand.dmi'
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 24
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("пилит", "кромсает", "режет", "рубит", "нарезает")
	attack_verb_simple = list("пилит", "кромсает", "режет", "рубит", "нарезает")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	tool_behaviour = TOOL_SAW
	toolspeed = 1

/obj/item/mounted_chainsaw/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/mounted_chainsaw/Destroy()
	var/obj/item/bodypart/part
	new /obj/item/chainsaw(get_turf(src))
	if(iscarbon(loc))
		var/mob/living/carbon/holder = loc
		var/index = holder.get_held_index_of_item(src)
		if(index)
			part = holder.hand_bodyparts[index]
	. = ..()
	if(part)
		part.drop_limb()

/obj/item/statuebust
	name = "bust"
	desc = "A priceless ancient marble bust, the kind that belongs in a museum." //or you can hit people with it
	icon = 'icons/obj/statue.dmi'
	icon_state = "bust"
	force = 15
	throwforce = 10
	throw_speed = 5
	throw_range = 2
	attack_verb_continuous = list("долбит")
	attack_verb_simple = list("долбит")
	var/impressiveness = 45

/obj/item/statuebust/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/art, impressiveness)
	AddComponent(/datum/element/beauty, 1000)

/obj/item/statuebust/hippocratic
	name = "hippocrates bust"
	desc = "A bust of the famous Greek physician Hippocrates of Kos, often referred to as the father of western medicine."
	icon_state = "hippocratic"
	impressiveness = 50

/obj/item/tailclub
	name = "tail club"
	desc = "For the beating to death of lizards with their own tails."
	icon_state = "tailclub"
	force = 14
	throwforce = 1 // why are you throwing a club do you even weapon
	throw_speed = 1
	throw_range = 1
	attack_verb_continuous = list("долбит", "ударяет")
	attack_verb_simple = list("долбит", "ударяет")

/obj/item/melee/chainofcommand/tailwhip
	name = "liz o' nine tails"
	desc = "A whip fashioned from the severed tails of lizards."
	icon_state = "tailwhip"
	inhand_icon_state = "tailwhip"
	item_flags = NONE

/obj/item/melee/chainofcommand/tailwhip/kitty
	name = "cat o' nine tails"
	desc = "A whip fashioned from the severed tails of cats."
	icon_state = "catwhip"
	inhand_icon_state = "catwhip"

/obj/item/melee/skateboard
	name = "skateboard"
	desc = "A skateboard. It can be placed on its wheels and ridden, or used as a radical weapon."
	icon_state = "skateboard"
	inhand_icon_state = "skateboard"
	force = 12
	throwforce = 4
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("лупит", "вмазывает", "хреначит", "размазывает")
	attack_verb_simple = list("лупит", "вмазывает", "хреначит", "размазывает")
	///The vehicle counterpart for the board
	var/board_item_type = /obj/vehicle/ridden/scooter/skateboard

/obj/item/melee/skateboard/attack_self(mob/user)
	var/obj/vehicle/ridden/scooter/skateboard/S = new board_item_type(get_turf(user))//this probably has fucky interactions with telekinesis but for the record it wasn't my fault
	S.buckle_mob(user)
	qdel(src)

/obj/item/melee/skateboard/improvised
	name = "improvised skateboard"
	desc = "A jury-rigged skateboard. It can be placed on its wheels and ridden, or used as a radical weapon."
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/improvised

/obj/item/melee/skateboard/pro
	name = "skateboard"
	desc = "An EightO brand professional skateboard. It looks sturdy and well made."
	icon_state = "skateboard2"
	inhand_icon_state = "skateboard2"
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/pro
	custom_premium_price = PAYCHECK_HARD * 5

/obj/item/melee/skateboard/hoverboard
	name = "hoverboard"
	desc = "A blast from the past, so retro!"
	icon_state = "hoverboard_red"
	inhand_icon_state = "hoverboard_red"
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/hoverboard
	custom_premium_price = PAYCHECK_COMMAND * 5.4 //If I can't make it a meme I'll make it RAD

/obj/item/melee/skateboard/hoverboard/admin
	name = "Board Of Directors"
	desc = "The engineering complexity of a spaceship concentrated inside of a board. Just as expensive, too."
	icon_state = "hoverboard_nt"
	inhand_icon_state = "hoverboard_nt"
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/hoverboard/admin

#define DRILLED_BAT 1
#define CHARGED_BAT 2

/obj/item/melee/baseball_bat
	name = "бейсбольная бита"
	desc = "There ain't a skull in the league that can withstand a swatter."
	gender = FEMALE
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "baseball_bat"
	inhand_icon_state = "baseball_bat"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 10
	wound_bonus = -10
	throwforce = 12
	attack_verb_continuous = list("бьёт", "вмазывает")
	attack_verb_simple = list("бьёт", "вмазывает")
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 3.5)
	w_class = WEIGHT_CLASS_HUGE
	var/homerun_ready = 0
	var/homerun_able = 0
	var/explosive = FALSE

/obj/item/melee/baseball_bat/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item.tool_behaviour == TOOL_DRILL)
		if(explosive == CHARGED_BAT)
			attacking_item.play_tool_sound(get_turf(src), 100)
			to_chat(user, span_userdanger("Совершаю глупость!"))
			do_boom(user, user)
			return
		if(explosive == FALSE && do_after(user, (5 SECONDS * attacking_item.toolspeed), src))
			attacking_item.play_tool_sound(get_turf(src), 100)
			to_chat(user, span_info("Делаю идеальное отверстие в бите."))
			visible_message(span_info("<b>[user]</b> сверлит биту."))
			explosive = DRILLED_BAT
			return
	else if (istype(attacking_item, /obj/item/ammo_casing) && explosive == DRILLED_BAT)
		var/obj/item/ammo_casing/AC = attacking_item
		if(AC.loaded_projectile)
			playsound(get_turf(src), 'sound/weapons/gun/general/mag_bullet_insert.ogg', 100)
			AC.forceMove(src)
			to_chat(user, span_info("Вставляю патрон в биту. Гениально."))
			explosive = CHARGED_BAT
			return
	else
		return ..()

/obj/item/melee/baseball_bat/proc/do_boom(mob/user, mob/target)
	if(explosive == CHARGED_BAT)
		var/obj/item/ammo_casing/AC = locate(/obj/item/ammo_casing) in src
		if(AC)
			AC.fire_casing(target, user, fired_from = src)
			explosive = FALSE
			qdel(AC)
			return TRUE
	return FALSE

/obj/item/melee/baseball_bat/attack(mob/living/target, mob/living/user)
	. = ..()
	if(do_boom(user, target))
		playsound(get_turf(src), 'sound/weapons/gun/pistol/shot.ogg', 100)
		user.dropItemToGround(src)
		throw_at(get_edge_target_turf(target, REVERSE_DIR(user.dir)), rand(8,10), 14, user)
		if(prob(25))
			var/obj/item/bodypart/cute = user.get_active_hand()
			cute.dismember(BRUTE, FALSE, TRUE)

#undef DRILLED_BAT
#undef CHARGED_BAT

/obj/item/melee/baseball_bat/Initialize(mapload)
	. = ..()
	if(prob(1))
		name = "cricket bat"
		desc = "You've got red on you."
		icon_state = "baseball_bat_brit"
		inhand_icon_state = "baseball_bat_brit"

	AddElement(/datum/element/kneecapping)

/obj/item/melee/baseball_bat/homerun
	name = "home run bat"
	desc = "This thing looks dangerous... Dangerously good at baseball, that is."
	homerun_able = 1

/obj/item/melee/baseball_bat/attack_self(mob/user)
	if(!homerun_able)
		..()
		return
	if(homerun_ready)
		to_chat(user, span_warning("You're already ready to do a home run!"))
		..()
		return
	to_chat(user, span_warning("You begin gathering strength..."))
	playsound(get_turf(src), 'sound/magic/lightning_chargeup.ogg', 65, TRUE)
	if(do_after(user, 90, target = src))
		to_chat(user, span_userdanger("You gather power! Time for a home run!"))
		homerun_ready = 1
	..()

/obj/item/melee/baseball_bat/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(homerun_ready)
		user.visible_message(span_userdanger("It's a home run!"))
		target.throw_at(throw_target, rand(8,10), 14, user)
		SSexplosions.medturf += throw_target
		playsound(get_turf(src), 'sound/weapons/homerun.ogg', 100, TRUE)
		homerun_ready = 0
		return
	else if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user, gentle = TRUE) // sorry friends, 7 speed batting caused wounds to absolutely delete whoever you knocked your target into (and said target)

/obj/item/melee/baseball_bat/ablative
	name = "стальная бейсбольная бита"
	desc = "Высокопрочная бита из стали, которая неплохо отражает лазеры."
	icon_state = "baseball_bat_metal"
	inhand_icon_state = "baseball_bat_metal"
	force = 12
	throwforce = 15

/obj/item/melee/baseball_bat/ablative/IsReflect()//some day this will reflect thrown items instead of lasers
	obj_integrity -= rand(10, 50)
	var/picksound = rand(1,2)
	var/turf = get_turf(src)
	if(picksound == 1)
		playsound(turf, 'sound/weapons/effects/batreflect1.ogg', 50, TRUE)
	if(picksound == 2)
		playsound(turf, 'sound/weapons/effects/batreflect2.ogg', 50, TRUE)
	if(obj_integrity <= 0)
		visible_message(span_danger("[capitalize(src.name)] ломается!"))
		qdel(src)
	return TRUE

/obj/item/melee/flyswatter
	name = "flyswatter"
	desc = "Useful for killing pests of all sizes."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "flyswatter"
	inhand_icon_state = "flyswatter"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 1
	throwforce = 1
	attack_verb_continuous = list("шлёпает", "прихлопывает")
	attack_verb_simple = list("шлёпает", "прихлопывает")
	hitsound = 'sound/effects/snap.ogg'
	w_class = WEIGHT_CLASS_SMALL
	//Things in this list will be instantly splatted.  Flyman weakness is handled in the flyman species weakness proc.
	var/list/strong_against

/obj/item/melee/flyswatter/Initialize(mapload)
	. = ..()
	strong_against = typecacheof(list(
					/mob/living/simple_animal/hostile/poison/bees/,
					/mob/living/simple_animal/butterfly,
					/mob/living/simple_animal/hostile/cockroach,
					/obj/item/queen_bee,
					/obj/structure/spider/spiderling
	))


/obj/item/melee/flyswatter/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		if(is_type_in_typecache(target, strong_against))
			new /obj/effect/decal/cleanable/insectguts(target.drop_location())
			to_chat(user, span_warning("You easily splat the [target]."))
			if(istype(target, /mob/living/))
				var/mob/living/bug = target
				bug.death(1)
			else
				qdel(target)

/obj/item/extendohand
	name = "extendo-hand"
	desc = "Futuristic tech has allowed these classic spring-boxing toys to essentially act as a fully functional hand-operated hand prosthetic."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "extendohand"
	inhand_icon_state = "extendohand"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 0
	throwforce = 5
	reach = 2
	var/min_reach = 2

/obj/item/extendohand/acme
	name = "\improper ACME Extendo-Hand"
	desc = "A novelty extendo-hand produced by the ACME corporation. Originally designed to knock out roadrunners."

/obj/item/extendohand/attack(atom/M, mob/living/carbon/human/user)
	var/dist = get_dist(M, user)
	if(dist < min_reach)
		to_chat(user, span_warning("[M] is too close to use [src] on."))
		return
	M.attack_hand(user)

/obj/item/gohei
	name = "gohei"
	desc = "A wooden stick with white streamers at the end. Originally used by shrine maidens to purify things. Now used by the station's valued weeaboos."
	force = 5
	throwforce = 5
	hitsound = "swing_hit"
	attack_verb_continuous = list("whacks", "thwacks", "wallops", "socks")
	attack_verb_simple = list("whack", "thwack", "wallop", "sock")
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "gohei"
	inhand_icon_state = "gohei"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'

//HF blade
/obj/item/vibro_weapon
	icon_state = "hfrequency0"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "вибромеч"
	desc = "Мощное оружие, способное прорезать практически все. Держа его двумя руками, вы сможете отражать выстрелы."
	armour_penetration = 100
	block_chance = 40
	force = 15
	throwforce = 20
	wound_bonus = 40
	throw_speed = 4
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("режет", "рубит", "разрубает")
	attack_verb_simple = list("режет", "рубит", "разрубает")
	actions_types = list(/datum/action/item_action/area_attack)
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	block_sounds = list('sound/weapons/sword_p1.ogg', 'sound/weapons/sword_p2.ogg', 'sound/weapons/sword_p3.ogg')
	var/wielded = FALSE // track wielded status on item
	var/max_area_cd = 60 SECONDS
	COOLDOWN_DECLARE(area_attack_cd)
	/// The color of the slash we create
	var/slash_color = COLOR_BLUE
	/// Previous x position of where we clicked on the target's icon
	var/previous_x
	/// Previous y position of where we clicked on the target's icon
	var/previous_y
	/// The previous target we attacked
	var/datum/weakref/previous_target

/obj/item/vibro_weapon/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/vibro_weapon/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 20, 105)
	AddComponent(/datum/component/two_handed, force_multiplier=2, icon_wielded="hfrequency1")

/obj/item/vibro_weapon/attack(mob/living/target, mob/living/user, params)
	if(!wielded)
		return ..()
	slash(target, user, params)

/obj/item/vibro_weapon/attack_obj(atom/target, mob/living/user, params)
	if(wielded)
		return
	return ..()

/obj/item/vibro_weapon/afterattack(atom/target, mob/user, proximity_flag, params)
	if(!wielded)
		return ..()
	if(!proximity_flag || !(isclosedturf(target) || isitem(target) || ismachinery(target) || isstructure(target) || isvehicle(target)))
		return
	slash(target, user, params)

/obj/item/vibro_weapon/proc/slash(atom/target, mob/living/user, params)
	user.do_attack_animation(target, "nothing")
	var/list/modifiers = params2list(params)
	var/damage_mod = 1
	var/x_slashed = text2num(modifiers[ICON_X]) || world.icon_size/2 //in case we arent called by a client
	var/y_slashed = text2num(modifiers[ICON_Y]) || world.icon_size/2 //in case we arent called by a client
	new /obj/effect/temp_visual/slash(get_turf(target), target, x_slashed, y_slashed, slash_color)
	if(target == previous_target?.resolve()) //if the same target, we calculate a damage multiplier if you swing your mouse around
		var/x_mod = previous_x - x_slashed
		var/y_mod = previous_y - y_slashed
		damage_mod = max(1, round((sqrt(x_mod ** 2 + y_mod ** 2) / 10), 0.1))
	previous_target = WEAKREF(target)
	previous_x = x_slashed
	previous_y = y_slashed
	playsound(src, hitsound, 100, vary = TRUE)
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_damage(force * damage_mod, BRUTE, sharpness = SHARP_EDGED, wound_bonus = wound_bonus, bare_wound_bonus = bare_wound_bonus, def_zone = user.zone_selected)
		log_combat(user, living_target, "slashed", src)
		if(living_target.stat == DEAD && prob(force * damage_mod*0.5))
			living_target.visible_message(span_danger("[living_target] разлетается на куски мяса!"), blind_message = span_hear("Слышу как разрывается плоть!"))
			living_target.gib()
			log_combat(user, living_target, "gibbed", src)
	else if(isobj(target))
		var/obj/obj_target = target
		obj_target.take_damage(force * damage_mod * 3, BRUTE, MELEE, FALSE, null, 50)
	else if(iswallturf(target) && prob(force * damage_mod*0.5))
		var/turf/closed/wall/wall_target = target
		wall_target.dismantle_wall()
	else if(ismineralturf(target) && prob(force * damage_mod))
		var/turf/closed/mineral/mineral_target = target
		mineral_target.gets_drilled()

/// triggered on wield of two handed item
/obj/item/vibro_weapon/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/vibro_weapon/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/vibro_weapon/update_icon_state()
	. = ..()
	icon_state = "hfrequency0"

/datum/action/item_action/area_attack
	name = "Нарезать капусту!"

/obj/item/vibro_weapon/ui_action_click(mob/user, action)
	if(!COOLDOWN_FINISHED(src, area_attack_cd))
		to_chat(user, span_warning("Ещё [DisplayTimeText(COOLDOWN_TIMELEFT(src, area_attack_cd))]."))
		return

	if(!istype(user) || user.incapacitated())
		return

	COOLDOWN_START(src, area_attack_cd, max_area_cd)

	user.AddElement(/datum/element/phantom, 1 SECONDS)

	var/ct = 0
	for(var/mob/living/M in get_hearers_in_view(7, get_turf(user)))
		if(M == user)
			continue
		ct += 1.5
		addtimer(CALLBACK(src, PROC_REF(fast_attack), user, M), ct)

/obj/item/vibro_weapon/proc/fast_attack(mob/user, mob/living/target)
	var/atom/last_target_atom = previous_target?.resolve()
	playsound(last_target_atom, 'sound/weapons/effects/vs.ogg', 100, TRUE)
	var/turf/near_turf = pick(get_adjacent_open_turfs(target))
	last_target_atom?.Beam(target, icon_state="1-full", time = 2 SECONDS, beam_color = slash_color)
	if(near_turf)
		user.forceMove(near_turf)
	user.setDir(get_dir(user, target))
	attack(target, user)

/obj/item/vibro_weapon/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(wielded)
		final_block_chance *= 2
	if(wielded || attack_type != PROJECTILE_ATTACK)
		if(prob(final_block_chance))
			if(attack_type == PROJECTILE_ATTACK)
				owner.visible_message(span_danger("[owner] отражает [attack_text] используя [src]!"))
				playsound(src, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, TRUE)
				return TRUE
			else
				owner.visible_message(span_danger("[owner] парирует [attack_text] используя [src]!"))
				return TRUE
	return FALSE

/obj/effect/temp_visual/slash
	icon_state = "highfreq_slash"
	alpha = 150
	duration = 0.5 SECONDS
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/effect/temp_visual/slash/Initialize(mapload, atom/target, x_slashed, y_slashed, slash_color)
	. = ..()
	if(!target)
		return
	var/matrix/new_transform = matrix()
	new_transform.Turn(rand(1, 360)) // Random slash angle
	var/datum/decompose_matrix/decomp = target.transform.decompose()
	new_transform.Translate((x_slashed - world.icon_size/2) * decomp.scale_x, (y_slashed - world.icon_size/2) * decomp.scale_y) // Move to where we clicked
	//Follow target's transform while ignoring scaling
	new_transform.Turn(decomp.rotation)
	new_transform.Translate(decomp.shift_x, decomp.shift_y)
	new_transform.Translate(target.pixel_x, target.pixel_y) // Follow target's pixel offsets
	transform = new_transform
	//Double the scale of the matrix by doubling the 2x2 part without touching the translation part
	var/matrix/scaled_transform = new_transform + matrix(new_transform.a, new_transform.b, 0, new_transform.d, new_transform.e, 0)
	animate(src, duration*0.5, color = slash_color, transform = scaled_transform, alpha = 255)

/obj/item/vibro_weapon/butcher
	block_chance = 100
	force = 100
	throwforce = 200
	wound_bonus = 250
	max_area_cd = 0
	slash_color = COLOR_VIOLET

/obj/item/melee/moonlight_greatsword
	name = "moonlight greatsword"
	desc = "Don't tell anyone you put any points into dex, though."
	icon_state = "swordon"
	inhand_icon_state = "swordon"
	worn_icon_state = "swordon"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	block_chance = 20
	sharpness = SHARP_EDGED
	force = 14
	throwforce = 12
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	block_sounds = list('sound/weapons/sword_p1.ogg', 'sound/weapons/sword_p2.ogg', 'sound/weapons/sword_p3.ogg')
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

/obj/item/proc/can_trigger_gun(mob/living/user)
	if(!user.can_use_guns(src))
		return FALSE
	return TRUE
