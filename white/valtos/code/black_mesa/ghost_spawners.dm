/obj/effect/mob_spawn/human/black_mesa
	name = "Research Facility Science Team"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	density = TRUE
	roundstart = FALSE
	death = FALSE
	outfit = /datum/outfit/science_team
	short_desc = "You are a scientist in a top secret government facility. You blacked out. Now, you have woken up to the horrors that lay within."
	flavour_text = "You are a scientist in a top secret government facility. You blacked out. Now, you have woken up to the horrors that lay within."

/obj/effect/mob_spawn/human/black_mesa/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.grant_language(/datum/language/uncommon, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.remove_language(/datum/language/common)

/datum/outfit/science_team
	name = JOB_SCIENTIST
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/radio, /obj/item/reagent_containers/glass/beaker)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/science_team

/datum/outfit/science_team/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_BLACKMESA

/datum/id_trim/science_team
	assignment = "Science Team Scientist"
	trim_state = "trim_scientist"
	access = list(ACCESS_RND)

/obj/effect/mob_spawn/human/black_mesa/guard
	name = "Research Facility Security Guard"
	outfit = /datum/outfit/security_guard
	short_desc = "You are a security guard in a top secret government facility. You blacked out. Now, you have woken up to the horrors that lay within. DO NOT TRY TO EXPLORE THE LEVEL. STAY AROUND YOUR AREA."

/obj/effect/mob_spawn/human/black_mesa/guard/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.grant_language(/datum/language/uncommon, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.remove_language(/datum/language/common)

/obj/item/clothing/under/rank/security
	name = "security guard uniform"
	desc = "About that beer I owe'd ya!"

/datum/outfit/security_guard
	name = "Security Guard"
	uniform = /obj/item/clothing/under/rank/security
	head = /obj/item/clothing/head/helmet/blueshirt
	gloves = /obj/item/clothing/gloves/color/black
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/radio, /obj/item/gun/ballistic/automatic/pistol)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/security_guard

/datum/outfit/security_guard/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_BLACKMESA

/datum/id_trim/security_guard
	assignment = "Security Guard"
	trim_state = "trim_securityofficer"
	access = list(ACCESS_BRIG, ACCESS_SECURITY, ACCESS_AWAY_SEC)

/obj/effect/mob_spawn/human/black_mesa/hecu
	name = "HECU"
	outfit = /datum/outfit/hecu
	short_desc = "You are an elite tactical squad deployed into the research facility to contain the infestation."
	flavour_text = "You and four other marines have been selected for a guard duty near one of the Black Mesa's entrances. You haven't heard much from the north-west post, except for the sounds of gunshots, and their radios went silent. On top of that, your escape helicopter was shot down mid-flight, and another one won't arrive so soon; with your machinegunner being shot down with a precise headshot by something, or SOMEONE. You are likely on your own, at least for now."

/obj/effect/mob_spawn/human/black_mesa/hecu/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.remove_language(/datum/language/common)
	spawned_human.grant_language(/datum/language/uncommon, TRUE, TRUE, LANGUAGE_MIND)

/obj/item/clothing/under/rank/security/officer/hecu
	name = "urban camouflage BDU"
	desc = "A baggy military camouflage uniform with an ERDL pattern. The range of whites and greys proves useful in urban environments."
	icon = 'white/valtos/icons/black_mesa/uniforms.dmi'
	worn_icon = 'white/valtos/icons/black_mesa/uniform.dmi'
	icon_state = "hecu_uniform"
	inhand_icon_state = "r_suit"
	unique_reskin = null

/obj/item/storage/backpack/ert/odst/hecu
	name = "hecu backpack"
	icon = 'white/valtos/icons/black_mesa/hecucloth.dmi'
	worn_icon = 'white/valtos/icons/black_mesa/hecumob.dmi'
	icon_state = "hecu_pack"
	worn_icon_state = "hecu_pack"
	unique_reskin = list(
		"Olive" = "hecu_pack",
		"Black" = "hecu_pack_black",
	)

/obj/item/storage/belt/military/assault/hecu
	name = "hecu warbelt"
	icon = 'white/valtos/icons/black_mesa/hecucloth.dmi'
	worn_icon = 'white/valtos/icons/black_mesa/hecumob.dmi'
	icon_state = "hecu_belt"
	worn_icon_state = "hecu_belt"
	unique_reskin = list(
		"Olive" = "hecu_belt",
		"Black" = "hecu_belt_black",
	)

/datum/outfit/hecu
	name = "HECU Grunt"
	uniform = /obj/item/clothing/under/rank/security/officer/hecu
	mask = /obj/item/clothing/mask/gas/heavy/m40
	gloves = /obj/item/clothing/gloves/combat
	belt = /obj/item/storage/belt/military/assault/hecu
	ears = /obj/item/radio/headset/headset_faction
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/reagent_containers/food/drinks/flask
	r_pocket = /obj/item/flashlight/flare
	back = /obj/item/storage/backpack/ert/odst/hecu
	backpack_contents = list(
		/obj/item/storage/box/survival/radio,
		/obj/item/storage/firstaid/emergency,
		/obj/item/storage/box/hecu_rations,
		/obj/item/kitchen/knife/combat,
		/obj/item/armament_points_card/hecu
	)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/hecu

/datum/outfit/hecu/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_HECU

/datum/id_trim/hecu
	assignment = "HECU Marine"
	trim_state = "trim_securityofficer"
	access = list(ACCESS_BRIG, ACCESS_SECURITY, ACCESS_AWAY_SEC)

/obj/effect/mob_spawn/human/black_mesa/hecu/leader
	name = "HECU Squad Leader"
	outfit = /datum/outfit/hecu/leader
	short_desc = "You are an elite tactical squad's leader deployed into the research facility to contain the infestation."
	flavour_text = "You and four other marines have been selected for a guard duty near one of the Black Mesa's entrances. Due to the lack of any real briefing, and your briefing officer's death during the landing, you have no clue as to what your objective is, so you and your group have set up a camp here. You haven't heard much from the north-west post, except for the sounds of gunshots, and their radios went silent. On top of that, your escape helicopter was shot down mid-flight, and another one won't arrive so soon; with your machinegunner being shot down with a precise headshot by something, or SOMEONE. You are likely on your own, at least for now."

/obj/effect/mob_spawn/human/black_mesa/hecu/leader/special(mob/living/carbon/human/spawned_human)
	. = ..()
	spawned_human.grant_language(/datum/language/uncommon, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.grant_language(/datum/language/arab, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.grant_language(/datum/language/xoxol, TRUE, TRUE, LANGUAGE_MIND)
	spawned_human.remove_language(/datum/language/common)

/datum/outfit/hecu/leader
	name = "HECU Captain"
	uniform = /obj/item/clothing/under/rank/security/officer/hecu
	head = /obj/item/clothing/head/beret/sec
	mask = /obj/item/clothing/mask/gas/heavy/m40
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	belt = /obj/item/storage/belt/military/assault/hecu
	ears = /obj/item/radio/headset/headset_faction/bowman/captain
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/grenade/smokebomb
	r_pocket = /obj/item/binoculars
	back = /obj/item/storage/backpack/ert/odst/hecu
	backpack_contents = list(
		/obj/item/storage/box/survival/radio,
		/obj/item/storage/firstaid/emergency,
		/obj/item/storage/box/hecu_rations,
		/obj/item/kitchen/knife/combat,
		/obj/item/book/granter/martial/cqc,
		/obj/item/armament_points_card/hecu
	)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/hecu_leader

/datum/outfit/hecu/leader/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_HECU

/datum/id_trim/hecu_leader
	assignment = "HECU Captain"
	trim_state = "trim_securityofficer"
	access = list(ACCESS_BRIG, ACCESS_SECURITY, ACCESS_AWAY_SEC)
