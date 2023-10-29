/obj/item/banner
	name = "знамя"
	desc = "знамя с логотипом Нанотрейзен."
	icon = 'icons/obj/banner.dmi'
	icon_state = "banner"
	inhand_icon_state = "banner"
	force = 8
	attack_verb_continuous = list("сильно вдохновляет", "яростно поощрает", "неумолимо цинкует")
	attack_verb_simple = list("сильно вдохновляет", "яростно поощрает", "неумолимо цинкует")
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	var/inspiration_available = TRUE //If this banner can be used to inspire crew
	var/morale_time = 0
	var/morale_cooldown = 600 //How many deciseconds between uses
	var/list/job_loyalties //Mobs with any of these assigned roles will be inspired
	var/list/role_loyalties //Mobs with any of these special roles will be inspired
	var/warcry

/obj/item/banner/examine(mob/user)
	. = ..()
	if(inspiration_available)
		. += "<hr><span class='notice'>Используйте в активной руке, чтобы вдохновить ближайших союзников!</span>"

/obj/item/banner/attack_self(mob/living/carbon/human/user)
	if(!inspiration_available)
		return
	if(morale_time > world.time)
		to_chat(user, span_warning("Я недостаточно вдохновлён, чтобы снова размахивать [src]."))
		to_chat(user, span_warning("You aren't feeling inspired enough to flourish [src] again yet."))
		return
	user.visible_message("<span class='big notice'>[user] размахивает [src]!</span>", \
	span_notice("Я поднимаю [src] ввысь, вдохновляя союзников!"))
	playsound(src, "rustle", 100, FALSE)
	if(warcry)
		user.say("[warcry]", forced="banner")
	var/old_transform = user.transform
	user.transform *= 1.2
	animate(user, transform = old_transform, time = 10)
	morale_time = world.time + morale_cooldown

	var/list/inspired = list()
	var/has_job_loyalties = LAZYLEN(job_loyalties)
	var/has_role_loyalties = LAZYLEN(role_loyalties)
	inspired += user //The user is always inspired, regardless of loyalties
	for(var/mob/living/carbon/human/H in range(4, get_turf(src)))
		if(H.stat == DEAD || H == user)
			continue
		if(H.mind && (has_job_loyalties || has_role_loyalties))
			if(has_job_loyalties && (H.mind.assigned_role in job_loyalties))
				inspired += H
			else if(has_role_loyalties && (H.mind.special_role in role_loyalties))
				inspired += H
		else if(check_inspiration(H))
			inspired += H

	for(var/V in inspired)
		var/mob/living/carbon/human/H = V
		if(H != user)
			to_chat(H, span_notice("Я становлюсь более уверенным по мере того, как [user] размахивает [user.ru_ego()] [name]!"))
		inspiration(H)
		special_inspiration(H)

/obj/item/banner/proc/check_inspiration(mob/living/carbon/human/H) //Banner-specific conditions for being eligible
	return

/obj/item/banner/proc/inspiration(mob/living/carbon/human/H)
	H.adjustBruteLoss(-15)
	H.adjustFireLoss(-15)
	H.AdjustStun(-40)
	H.AdjustKnockdown(-40)
	H.AdjustImmobilized(-40)
	H.AdjustParalyzed(-40)
	H.AdjustUnconscious(-40)
	playsound(H, 'sound/magic/staff_healing.ogg', 25, FALSE)

/obj/item/banner/proc/special_inspiration(mob/living/carbon/human/H) //Any banner-specific inspiration effects go here
	return

/obj/item/banner/security
	name = "знамя СБстана"
	desc = "Знамя Сбстана, правящего станцией своим железным кулаком."
	icon_state = "banner_security"
	inhand_icon_state = "banner_security"
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	warcry = "EVERYONE DOWN ON THE GROUND!!"

/obj/item/banner/security/Initialize(mapload)
	. = ..()
	job_loyalties = GLOB.security_positions

/obj/item/banner/security/mundane
	inspiration_available = FALSE

/datum/crafting_recipe/security_banner
	name = "знамя СБстана"
	result = /obj/item/banner/security/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/security/officer = 1)
	category = CAT_MISC

/obj/item/banner/medical
	name = "знамя Медистана"
	desc = "Знамя Медистана, щедрых благотворителей, которые лечат раны и дают кров нуждающимся."
	icon_state = "banner_medical"
	inhand_icon_state = "banner_medical"
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	warcry = "Нет таких ран, которые бы мы не смогли залечить!"

/obj/item/banner/medical/Initialize(mapload)
	. = ..()
	job_loyalties = GLOB.medical_positions

/obj/item/banner/medical/mundane
	inspiration_available = FALSE

/obj/item/banner/medical/check_inspiration(mob/living/carbon/human/H)
	return H.stat //Meditopia is moved to help those in need

/datum/crafting_recipe/medical_banner
	name = "знамя Медистана"
	result = /obj/item/banner/medical/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/medical = 1)
	category = CAT_MISC

/obj/item/banner/medical/special_inspiration(mob/living/carbon/human/H)
	H.adjustToxLoss(-15)
	H.setOxyLoss(0)
	H.reagents.add_reagent(/datum/reagent/medicine/inaprovaline, 5)

/obj/item/banner/science
	name = "знамя Научстана"
	desc = "Знамя Научстана, смелых тауматургов и исследователей."
	icon_state = "banner_science"
	inhand_icon_state = "banner_science"
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	warcry = "Во имя кубинца Пита!"

/obj/item/banner/science/Initialize(mapload)
	. = ..()
	job_loyalties = GLOB.science_positions

/obj/item/banner/science/mundane
	inspiration_available = FALSE

/obj/item/banner/science/check_inspiration(mob/living/carbon/human/H)
	return H.on_fire //Sciencia is pleased by dedication to the art of Toxins

/datum/crafting_recipe/science_banner
	name = "знамя Научстана"
	result = /obj/item/banner/science/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/rnd/scientist = 1)
	category = CAT_MISC

/obj/item/banner/cargo
	name = "знамя Каргонии"
	desc = "Знамя вечной Каргонии, обладающее мистической силой возвращать к жизни."
	icon_state = "banner_cargo"
	inhand_icon_state = "banner_cargo"
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	warcry = "Да здравствует Каргония!"

/obj/item/banner/cargo/Initialize(mapload)
	. = ..()
	job_loyalties = GLOB.supply_positions

/obj/item/banner/cargo/mundane
	inspiration_available = FALSE

/datum/crafting_recipe/cargo_banner
	name = "Знамя Каргонии"
	result = /obj/item/banner/cargo/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/cargo/tech = 1)
	category = CAT_MISC

/obj/item/banner/engineering
	name = "знамя Инжестана"
	desc = "Знамя Инжестана, обладателей безграничной власти."
	icon_state = "banner_engineering"
	inhand_icon_state = "banner_engineering"
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	warcry = "Славьте лорда Сингулота!!"

/obj/item/banner/engineering/Initialize(mapload)
	. = ..()
	job_loyalties = GLOB.engineering_positions

/obj/item/banner/engineering/mundane
	inspiration_available = FALSE

/obj/item/banner/engineering/special_inspiration(mob/living/carbon/human/H)
	H.radiation = 0

/datum/crafting_recipe/engineering_banner
	name = "Знамя Инжестана"
	result = /obj/item/banner/engineering/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/engineering/engineer = 1)
	category = CAT_MISC

/obj/item/banner/command
	name = "знамя командования"
	desc = "Знамя командования, верного и древнего рода бюрократических королей и королев"
	//No icon state here since the default one is the NT banner
	warcry = "Слава Нанотрейзен!"

/obj/item/banner/command/Initialize(mapload)
	. = ..()
	job_loyalties = GLOB.command_positions

/obj/item/banner/command/mundane
	inspiration_available = FALSE

/obj/item/banner/command/check_inspiration(mob/living/carbon/human/H)
	return HAS_TRAIT(H, TRAIT_MINDSHIELD) //Command is stalwart but rewards their allies.

/datum/crafting_recipe/command_banner
	name = "Знамя командования"
	result = /obj/item/banner/command/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/captain/parade = 1)
	category = CAT_MISC

/obj/item/banner/red
	name = "красное знамя"
	icon_state = "banner-red"
	inhand_icon_state = "banner-red"
	desc = "Знамя с логотипом красного божества."

/obj/item/banner/blue
	name = "синее знамя"
	icon_state = "banner-blue"
	inhand_icon_state = "banner-blue"
	desc = "Знамя с логотипом синего божества."

/obj/item/storage/backpack/bannerpack
	name = "\improper Nanotrasen banner backpack"
	desc = "It's a backpack with lots of extra room. A banner with Nanotrasen's logo is attached, that can't be removed."
	icon_state = "bannerpack"

/obj/item/storage/backpack/bannerpack/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 27 //6 more then normal, for the tradeoff of declaring yourself an antag at all times.

/obj/item/storage/backpack/bannerpack/red
	name = "красный banner backpack"
	desc = "It's a backpack with lots of extra room. A red banner is attached, that can't be removed."
	icon_state = "bannerpack-red"

/obj/item/storage/backpack/bannerpack/blue
	name = "синий banner backpack"
	desc = "It's a backpack with lots of extra room. A blue banner is attached, that can't be removed."
	icon_state = "bannerpack-blue"

//this is all part of one item set
/obj/item/clothing/suit/armor/plate/crusader
	name = "Доспехи крестоносца"
	desc = "Броня из металла и ткани."
	icon_state = "crusader"
	w_class = WEIGHT_CLASS_BULKY
	slowdown = 2.0 //gotta pretend we're balanced.
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 50, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 60, BIO = 0, RAD = 0, FIRE = 60, ACID = 60)

/obj/item/clothing/suit/armor/plate/crusader/red
	icon_state = "crusader-red"

/obj/item/clothing/suit/armor/plate/crusader/blue
	icon_state = "crusader-blue"

/obj/item/clothing/head/helmet/plate/crusader
	name = "Капюшон крестоносца"
	desc = "Коричневатый капюшон."
	icon_state = "crusader"
	w_class = WEIGHT_CLASS_NORMAL
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE
	armor = list(MELEE = 50, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 60, BIO = 0, RAD = 0, FIRE = 60, ACID = 60)

/obj/item/clothing/head/helmet/plate/crusader/blue
	icon_state = "crusader-blue"

/obj/item/clothing/head/helmet/plate/crusader/red
	icon_state = "crusader-red"

//Prophet helmet
/obj/item/clothing/head/helmet/plate/crusader/prophet
	name = "Шляпа пророка"
	desc = "Выглядит религиозно."
	icon_state = null
	flags_1 = 0
	armor = list(MELEE = 60, BULLET = 60, LASER = 60, ENERGY = 60, BOMB = 70, BIO = 50, RAD = 50, FIRE = 60, ACID = 60) //religion protects you from disease and radiation, honk.
	worn_y_offset = 6

/obj/item/clothing/head/helmet/plate/crusader/prophet/red
	icon_state = "prophet-red"

/obj/item/clothing/head/helmet/plate/crusader/prophet/blue
	icon_state = "prophet-blue"

//Structure conversion staff
/obj/item/godstaff
	name = "божественный посох"
	desc = "Это палка..?"
	icon_state = "godstaff-red"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	var/conversion_color = "#ffffff"
	var/staffcooldown = 0
	var/staffwait = 30


/obj/item/godstaff/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(staffcooldown + staffwait > world.time)
		return

	user.visible_message(span_notice("[user] напевает и размахивает [user.ru_ego()] посохом!"))
	if(do_after(user, 2 SECONDS, src))
		target.add_atom_colour(conversion_color, WASHABLE_COLOUR_PRIORITY) //wololo
	staffcooldown = world.time

/obj/item/godstaff/red
	icon_state = "godstaff-red"
	conversion_color = "#ff0000"

/obj/item/godstaff/blue
	icon_state = "godstaff-blue"
	conversion_color = "#0000ff"

/obj/item/clothing/gloves/plate
	name = "Латные рукавицы"
	icon_state = "crusader"
	desc = "Как перчатки, но сделаны из железа."
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT

/obj/item/clothing/gloves/plate/red
	icon_state = "crusader-red"

/obj/item/clothing/gloves/plate/blue
	icon_state = "crusader-blue"

/obj/item/clothing/shoes/plate
	name = "Латные сапоги"
	desc = "Выглядят тяжелыми."
	icon_state = "crusader"
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(MELEE = 50, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 60, BIO = 0, RAD = 0, FIRE = 60, ACID = 60) //does this even do anything on boots?
	clothing_flags = NOSLIP
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT


/obj/item/clothing/shoes/plate/red
	icon_state = "crusader-red"

/obj/item/clothing/shoes/plate/blue
	icon_state = "crusader-blue"


/obj/item/storage/box/itemset/crusader
	name = "Доспехи крестоносца" //i can't into ck2 references
	desc = "Говорят, эта броня была скопирована с доспехов королей из другого мира, которые жили тысячи лет назад. Они убивали, устраивали заговоры и казнили всех, кто пытался сделать то же самое с ними. Некоторые вещи никогда не меняются."


/obj/item/storage/box/itemset/crusader/blue/PopulateContents()
	new /obj/item/clothing/suit/armor/plate/crusader/blue(src)
	new /obj/item/clothing/head/helmet/plate/crusader/blue(src)
	new /obj/item/clothing/gloves/plate/blue(src)
	new /obj/item/clothing/shoes/plate/blue(src)


/obj/item/storage/box/itemset/crusader/red/PopulateContents()
	new /obj/item/clothing/suit/armor/plate/crusader/red(src)
	new /obj/item/clothing/head/helmet/plate/crusader/red(src)
	new /obj/item/clothing/gloves/plate/red(src)
	new /obj/item/clothing/shoes/plate/red(src)


/obj/item/claymore/weak
	desc = "This one is rusted."
	force = 30
	armour_penetration = 15

/obj/item/claymore/weak/ceremonial
	desc = "A rusted claymore, once at the heart of a powerful scottish clan struck down and oppressed by tyrants, it has been passed down the ages as a symbol of defiance."
	force = 15
	block_chance = 30
	armour_penetration = 5
