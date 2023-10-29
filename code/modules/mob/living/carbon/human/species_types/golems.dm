/datum/species/golem
	// Animated beings of stone. They have increased defenses, and do not need to breathe. They're also slow as fuuuck.
	name = "голем"
	id = "iron golem"
	species_traits = list(NOBLOOD,MUTCOLORS,NO_UNDERWEAR)
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOFIRE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER)
	inherent_biotypes = MOB_HUMANOID|MOB_MINERAL
	mutant_organs = list(/obj/item/organ/adamantine_resonator)
	speedmod = 2
	payday_modifier = 0.75
	armor = 55
	siemens_coeff = 0
	punchdamagelow = 5
	punchdamagehigh = 14
	punchstunthreshold = 11 //about 40% chance to stun
	no_equip = list(ITEM_SLOT_MASK, ITEM_SLOT_OCLOTHING, ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_ICLOTHING, ITEM_SLOT_SUITSTORE)
	nojumpsuit = 1
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	sexes = 1
	damage_overlay_type = ""
	meat = /obj/item/food/meat/slab/human/mutant/golem
	species_language_holder = /datum/language_holder/golem
	// To prevent golem subtypes from overwhelming the odds when random species
	// changes, only the Random Golem type can be chosen
	limbs_id = "golem"
	fixed_mut_color = "aaa"
	swimming_component = /datum/component/swimming/golem
	var/info_text = "Будучи <span class='danger'>железным големом</span>, я не имею какой-либо характерной черты."
	var/random_eligible = TRUE //If false, the golem subtype can't be made through golem mutation toxin

	var/prefix = "Железный"
	var/list/special_names = list("Tarkus")
	var/human_surname_chance = 3
	var/special_name_chance = 5
	var/owner //dobby is a free golem

/datum/species/golem/random_name(gender,unique,lastname, en_lang = FALSE)
	var/golem_surname = pick(GLOB.golem_names)
	// 3% chance that our golem has a human surname, because
	// cultural contamination
	if(prob(human_surname_chance))
		golem_surname = pick(GLOB.last_names)
	else if(special_names?.len && prob(special_name_chance))
		golem_surname = pick(special_names)

	var/golem_name = "[prefix] [golem_surname]"
	return golem_name

/datum/species/golem/random
	name = "случайный голем"
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN
	var/static/list/random_golem_types

/datum/species/golem/random/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(!random_golem_types)
		random_golem_types = subtypesof(/datum/species/golem) - type
		for(var/V in random_golem_types)
			var/datum/species/golem/G = V
			if(!initial(G.random_eligible))
				random_golem_types -= G
	var/datum/species/golem/golem_type = pick(random_golem_types)
	var/mob/living/carbon/human/H = C
	H.set_species(golem_type)
	to_chat(H, "[initial(golem_type.info_text)]")

/datum/species/golem/adamantine
	name = "адамантиновый голем"
	id = "adamantine golem"
	meat = /obj/item/food/meat/slab/human/mutant/golem/adamantine
	mutant_organs = list(/obj/item/organ/adamantine_resonator, /obj/item/organ/vocal_cords/adamantine)
	fixed_mut_color = "4ed"
	info_text = "Будучи <span class='danger'>адамантиновым големом</span>, я владею особенными голосовыми связками, дающие мне возможность \"резонировать\" сообщения всем големам. Мой минеральный состав делает меня неуязвимым к многим видам магии."
	prefix = "Адамантиновый"
	special_names = null

/datum/species/golem/adamantine/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	ADD_TRAIT(C, TRAIT_ANTIMAGIC, SPECIES_TRAIT)

/datum/species/golem/adamantine/on_species_loss(mob/living/carbon/C)
	REMOVE_TRAIT(C, TRAIT_ANTIMAGIC, SPECIES_TRAIT)
	..()

//The suicide bombers of golemkind
/datum/species/golem/plasma
	name = "плазма голем"
	id = "plasma golem"
	fixed_mut_color = "a3d"
	meat = /obj/item/stack/ore/plasma
	//Can burn and takes damage from heat
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOBREATH, TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER) //no RESISTHEAT, NOFIRE
	info_text = "Будучи <span class='danger'>плазма големом</span>, я легко воспламеняюсь. Нужно быть осторожным, если я перегреюсь, пока горю, я взорвусь!"
	heatmod = 0 //fine until they blow up
	prefix = "Плазмовый"
	special_names = list("Flood","Fire","Bar","Man")
	var/boom_warning = FALSE
	var/datum/action/innate/ignite/ignite

/datum/species/golem/plasma/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	if(H.bodytemperature > 750)
		if(!boom_warning && H.on_fire)
			to_chat(H, span_userdanger("Чувсвую, что могу взорваться в любой момент!"))
			boom_warning = TRUE
	else
		if(boom_warning)
			to_chat(H, span_notice("Чувствую себя стабильнее."))
			boom_warning = FALSE

	if(H.bodytemperature > 850 && H.on_fire && prob(25))
		explosion(H, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 4, flame_range = 5, explosion_cause = src)
		if(H)
			H.gib()
	if(H.fire_stacks < 2) //flammable
		H.adjust_fire_stacks(0.5 * delta_time)
	..()

/datum/species/golem/plasma/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		ignite = new
		ignite.Grant(C)

/datum/species/golem/plasma/on_species_loss(mob/living/carbon/C)
	if(ignite)
		ignite.Remove(C)
	..()

/datum/action/innate/ignite
	name = "поджечь себя"
	desc = "Поджечь себя, чтобы бахнуть!"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "sacredflame"

/datum/action/innate/ignite/Activate()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.fire_stacks)
			to_chat(owner, span_notice("Поджёг себя!"))
		else
			to_chat(owner, span_warning("Пытаюсь поджечь себя, но моя затея не удалась..."))
		H.ignite_mob() //firestacks are already there passively

//Harder to hurt
/datum/species/golem/diamond
	name = "алмазный голем"
	id = "diamond golem"
	fixed_mut_color = "0ff"
	armor = 70 //up from 55
	meat = /obj/item/stack/ore/diamond
	info_text = "Будучи <span class='danger'>алмазным големом</span>, я более стойкий, чем среднестатистический голем."
	prefix = "Алмазный"
	special_names = list("Back","Grill")

//Faster but softer and less armoured
/datum/species/golem/gold
	name = "золотой голем"
	id = "gold golem"
	fixed_mut_color = "cc0"
	speedmod = 1
	armor = 25 //down from 55
	meat = /obj/item/stack/ore/gold
	info_text = "будучи <span class='danger'>золотым големом</span>, я быстрее, но менее стойкий чем среднестатистический голем."
	prefix = "Золотой"
	special_names = list("Boy")

//Heavier, thus higher chance of stunning when punching
/datum/species/golem/silver
	name = "серебряный голем"
	id = "silver golem"
	fixed_mut_color = "ddd"
	punchstunthreshold = 9 //60% chance, from 40%
	meat = /obj/item/stack/ore/silver
	info_text = "Будучи <span class='danger'>серебряным големом</span>, мои атаки чаще оглушают. Так как моё тело состоит из серебра, большая часть магии не действует на меня."
	prefix = "Серебряный"
	special_names = list("Surfer", "Chariot", "Lining")

/datum/species/golem/silver/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	ADD_TRAIT(C, TRAIT_HOLY, SPECIES_TRAIT)

/datum/species/golem/silver/on_species_loss(mob/living/carbon/C)
	REMOVE_TRAIT(C, TRAIT_HOLY, SPECIES_TRAIT)
	..()

//Harder to stun, deals more damage, massively slowpokes, but gravproof and obstructive. Basically, The Wall.
/datum/species/golem/plasteel
	name = "Plasteel Golem"
	id = "plasteel golem"
	fixed_mut_color = "bbb"
	stunmod = 0.4
	punchdamagelow = 12
	punchdamagehigh = 21
	punchstunthreshold = 18 //still 40% stun chance
	speedmod = 4 //pretty fucking slow
	meat = /obj/item/stack/ore/iron
	info_text = "Будучи <span class='danger'>пласталевым големом </span> я медленнее, но меня сложнее оглушить, и я очень сильно бью. также я магическим способом примагничиваюсь к поверхностям, поэтому можно ходить без гравитации, и со мной никто не может меняться местами."
	attack_verb = "ломает"
	attack_effect = ATTACK_EFFECT_SMASH
	attack_sound = 'sound/effects/meteorimpact.ogg' //hits pretty hard
	prefix = "Пласталевый"
	special_names = null

/datum/species/golem/plasteel/negates_gravity(mob/living/carbon/human/H)
	return TRUE

/datum/species/golem/plasteel/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	ADD_TRAIT(C, TRAIT_NOMOBSWAP, SPECIES_TRAIT) //THE WALL THE WALL THE WALL

/datum/species/golem/plasteel/on_species_loss(mob/living/carbon/C)
	REMOVE_TRAIT(C, TRAIT_NOMOBSWAP, SPECIES_TRAIT) //NOTHING ON ERF CAN MAKE IT FALL
	..()

//Immune to ash storms
/datum/species/golem/titanium
	name = "титановый голем"
	id = "titanium golem"
	fixed_mut_color = "fff"
	meat = /obj/item/stack/ore/titanium
	info_text = "Будучи <span class='danger'>титановым големом</span> мне не страшны пыльные бури, и я более стойкий к урону от ожогов."
	burnmod = 0.9
	prefix = "Титановый"
	special_names = list("Dioxide")

/datum/species/golem/titanium/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	LAZYOR(C.weather_immunities, WEATHER_ASH)

/datum/species/golem/titanium/on_species_loss(mob/living/carbon/C)
	. = ..()
	LAZYREMOVE(C.weather_immunities, WEATHER_ASH)

//Immune to ash storms and lava
/datum/species/golem/plastitanium
	name = "пластитановый голем"
	id = "plastitanium golem"
	fixed_mut_color = "888"
	meat = /obj/item/stack/ore/titanium
	info_text = "Будучи <span class='danger'>пластитановым големом</span> мне не страшны пыльные бури и лавовые реки, и я более стойкий к урону от ожогов."
	burnmod = 0.8
	prefix = "Пластитановый"
	special_names = null

/datum/species/golem/plastitanium/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	LAZYOR(C.weather_immunities, WEATHER_LAVA)
	LAZYOR(C.weather_immunities, WEATHER_ASH)

/datum/species/golem/plastitanium/on_species_loss(mob/living/carbon/C)
	. = ..()
	LAZYREMOVE(C.weather_immunities, WEATHER_ASH)
	LAZYREMOVE(C.weather_immunities, WEATHER_LAVA)

//Fast and regenerates... but can only speak like an abductor
/datum/species/golem/alloy
	name = "Alien Alloy Golem"
	id = "alloy golem"
	fixed_mut_color = "333"
	meat = /obj/item/stack/sheet/mineral/abductor
	mutanttongue = /obj/item/organ/tongue/abductor
	speedmod = 1 //faster
	info_text = "Будучи <span class='danger'>големом из инопланетного сплава</span> я быстрее и могу регенерировать со временем. Однако, можно только слышать големов, сделанных из такого-же сплава, что и я."
	prefix = "Чужеродный"
	special_names = list("Outsider", "Technology", "Watcher", "Stranger") //ominous and unknown

//Regenerates because self-repairing super-advanced alien tech
/datum/species/golem/alloy/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	if(H.stat == DEAD)
		return
	H.heal_overall_damage(1 * delta_time, 1 * delta_time, 0, BODYPART_ORGANIC)
	H.adjustToxLoss(-1 * delta_time)
	H.adjustOxyLoss(-1 * delta_time)

//Since this will usually be created from a collaboration between podpeople and free golems, wood golems are a mix between the two races
/datum/species/golem/wood
	name = "деревянный голем"
	id = "wood golem"
	fixed_mut_color = "9E704B"
	meat = /obj/item/stack/sheet/mineral/wood
	//Can burn and take damage from heat
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOBREATH, TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER)
	armor = 30
	burnmod = 1.25
	heatmod = 1.5
	info_text = "Будучи <span class='danger'>деревянным големом</span> я имею такие-же черты, что и растения: получаю урон от высоких температур, могу быть поддожён, и я менее стойкий, чем другие големы. Ещё я регенерируюсь, когда нахожусь у света, и увядаю, при его отсутствии."
	prefix = "Деревянный"
	special_names = list("Bark", "Willow", "Catalpa", "Woody", "Oak", "Sap", "Twig", "Branch", "Maple", "Birch", "Elm", "Basswood", "Cottonwood", "Larch", "Aspen", "Ash", "Beech", "Buckeye", "Cedar", "Chestnut", "Cypress", "Fir", "Hawthorn", "Hazel", "Hickory", "Ironwood", "Juniper", "Leaf", "Mangrove", "Palm", "Pawpaw", "Pine", "Poplar", "Redwood", "Redbud", "Sassafras", "Spruce", "Sumac", "Trunk", "Walnut", "Yew")
	human_surname_chance = 0
	special_name_chance = 100
	inherent_factions = list("plants", "vines")

/datum/species/golem/wood/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	if(H.stat == DEAD)
		return
	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		light_amount = min(1, T.get_lumcount()) - 0.5
		H.adjust_nutrition(5 * light_amount * delta_time)
		if(H.nutrition > NUTRITION_LEVEL_ALMOST_FULL)
			H.set_nutrition(NUTRITION_LEVEL_ALMOST_FULL)
		if(light_amount > 0.2) //if there's enough light, heal
			H.heal_overall_damage(0.5 * delta_time, 0.5 * delta_time, 0, BODYPART_ORGANIC)
			H.adjustToxLoss(-0.5 * delta_time)
			H.adjustOxyLoss(-0.5 * delta_time)

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		H.take_overall_damage(2,0)

/datum/species/golem/wood/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	if(chem.type == /datum/reagent/toxin/plantbgone)
		H.adjustToxLoss(3 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)
		return TRUE

//Radioactive puncher, hits for burn but only as hard as human, slightly more durable against brute but less against everything else
/datum/species/golem/uranium
	name = "урановый голем"
	id = "uranium golem"
	fixed_mut_color = "7f0"
	meat = /obj/item/stack/ore/uranium
	info_text = "Будучи <span class='danger'>урановым големом</span> мои касания сжигают и облучают органические формы жизни. Мои атаки слабее, чем у других големов, но я более стойкий к ударам тупого предмета."
	attack_verb = "burn"
	attack_sound = 'sound/weapons/sear.ogg'
	attack_type = BURN
	var/last_event = 0
	var/active = null
	armor = 40
	brutemod = 0.5
	punchdamagelow = 1
	punchdamagehigh = 10
	punchstunthreshold = 9
	prefix = "Урановый"
	special_names = list("Oxide", "Rod", "Meltdown", "235")
	COOLDOWN_DECLARE(radiation_emission_cooldown)

/datum/species/golem/uranium/proc/radiation_emission(mob/living/carbon/human/H)
	if(!COOLDOWN_FINISHED(src, radiation_emission_cooldown))
		return
	else
		radiation_pulse(H, 50)
		COOLDOWN_START(src, radiation_emission_cooldown, 2 SECONDS)

/datum/species/golem/uranium/spec_unarmedattacked(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/obj/item/bodypart/affecting = target.get_bodypart(ran_zone(user.zone_selected))
	var/radiation_block = target.run_armor_check(affecting, RAD)
	///standard damage roll for use in determining how much you irradiate per punch
	var/attacker_irradiate_value = rand(user.dna.species.punchdamagelow, user.dna.species.punchdamagehigh)
	target.apply_effect(attacker_irradiate_value*5, EFFECT_IRRADIATE, radiation_block)

/datum/species/golem/uranium/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	..()
	if(COOLDOWN_FINISHED(src, radiation_emission_cooldown) && M != H &&  M.a_intent != INTENT_HELP)
		radiation_emission(H)

/datum/species/golem/uranium/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	..()
	if(COOLDOWN_FINISHED(src, radiation_emission_cooldown) && user != H)
		radiation_emission(H)

/datum/species/golem/uranium/on_hit(obj/projectile/P, mob/living/carbon/human/H)
	..()
	if(COOLDOWN_FINISHED(src, radiation_emission_cooldown))
		radiation_emission(H)

//Immune to physical bullets and resistant to brute, but very vulnerable to burn damage. Dusts on death.
/datum/species/golem/sand
	name = "песчаный голем"
	id = "sand golem"
	fixed_mut_color = "ffdc8f"
	meat = /obj/item/stack/ore/glass //this is sand
	armor = 0
	burnmod = 3 //melts easily
	brutemod = 0.25
	info_text = "Будучи <span class='danger'>песчаным големом</span>, пули не наносят мне вреда, а физические повреждения наносятся слабее, чем другим големам, но я уязвим к ожогам и энергетическим оружиям. Я превращусь в песок, когда умру, предотвращая возможность любого вида восстановления."
	attack_sound = 'sound/effects/shovel_dig.ogg'
	prefix = "Песчаный"
	special_names = list("Castle", "Bag", "Dune", "Worm", "Storm")

/datum/species/golem/sand/spec_death(gibbed, mob/living/carbon/human/H)
	H.visible_message(span_danger("[H] превращается в кучу песка."))
	for(var/obj/item/W in H)
		H.dropItemToGround(W)
	for(var/i=1, i <= rand(3,5), i++)
		new /obj/item/stack/ore/glass(get_turf(H))
	qdel(H)

/datum/species/golem/sand/bullet_act(obj/projectile/P, mob/living/carbon/human/H)
	if(!(P.original == H && P.firer == H))
		if(P.flag == BULLET || P.flag == BOMB)
			playsound(H, 'sound/effects/shovel_dig.ogg', 70, TRUE)
			H.visible_message(span_danger("[P.name] впитывается в тело [H]!") , \
			span_userdanger("[P.name] впитывается в тело [H]!"))
			return BULLET_ACT_BLOCK
	return ..()

//Reflects lasers and resistant to burn damage, but very vulnerable to brute damage. Shatters on death.
/datum/species/golem/glass
	name = "стеклянный голем"
	id = "glass golem"
	fixed_mut_color = "5a96b4aa" //transparent body
	meat = /obj/item/shard
	armor = 0
	brutemod = 3 //very fragile
	burnmod = 0.25
	info_text = "Будучи <span class='danger'>стеклянным големом</span> я отражаю лазеры и энергию, и очень стойкий к ожогам. Тем не менее я очень сильно уязвим к травмам. При смерти я разломаюсь на куски без возможности восстановления."
	attack_sound = 'sound/effects/glassbr2.ogg'
	prefix = "Стеклянный"
	special_names = list("Lens", "Prism", "Fiber", "Bead")

/datum/species/golem/glass/spec_death(gibbed, mob/living/carbon/human/H)
	playsound(H, "shatter", 70, TRUE)
	H.visible_message(span_danger("[H] разламывается на куски!"))
	for(var/obj/item/W in H)
		H.dropItemToGround(W)
	for(var/i=1, i <= rand(3,5), i++)
		new /obj/item/shard(get_turf(H))
	qdel(H)

/datum/species/golem/glass/bullet_act(obj/projectile/P, mob/living/carbon/human/H)
	if(!(P.original == H && P.firer == H)) //self-shots don't reflect
		if(P.flag == LASER || P.flag == ENERGY)
			H.visible_message(span_danger("[P.name] отражается от [H]!") , \
			span_userdanger("[P.name] отражается от [H]!"))
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				// redirect the projectile
				P.firer = H
				P.preparePixelProjectile(locate(clamp(new_x, 1, world.maxx), clamp(new_y, 1, world.maxy), H.z), H)
			return BULLET_ACT_FORCE_PIERCE
	return ..()

//Teleports when hit or when it wants to
/datum/species/golem/bluespace
	name = "блюспейс голем"
	id = "bluespace golem"
	fixed_mut_color = "33f"
	meat = /obj/item/stack/ore/bluespace_crystal
	info_text = "Будучи <span class='danger'>блюспейс големом</span> моё тело пространственно нестабильно. При ударе по мне, я телепортируюсь в случайное место, а также могу вручную телепортироваться на далёкие расстояния."
	attack_verb = "блюспейс бьёт"
	attack_sound = 'sound/effects/phasein.ogg'
	prefix = "Блюспейсовый"
	special_names = list("Crystal", "Polycrystal")

	var/datum/action/innate/unstable_teleport/unstable_teleport
	var/teleport_cooldown = 100
	var/last_teleport = 0

/datum/species/golem/bluespace/proc/reactive_teleport(mob/living/carbon/human/H)
	H.visible_message(span_warning("[H] teleports!") , span_danger("YЯ дестабилизируюсь, и телепортируюсь!"))
	new /obj/effect/particle_effect/sparks(get_turf(H))
	playsound(get_turf(H), "zap", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	do_teleport(H, get_turf(H), 6, asoundin = 'sound/weapons/emitter2.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
	last_teleport = world.time

/datum/species/golem/bluespace/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	..()
	var/obj/item/I
	if(istype(AM, /obj/item))
		I = AM
		if(I.thrownby == WEAKREF(H)) //No throwing stuff at yourself to trigger the teleport
			return 0
		else
			reactive_teleport(H)

/datum/species/golem/bluespace/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	..()
	if(world.time > last_teleport + teleport_cooldown && M != H &&  M.a_intent != INTENT_HELP)
		reactive_teleport(H)

/datum/species/golem/bluespace/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	..()
	if(world.time > last_teleport + teleport_cooldown && user != H)
		reactive_teleport(H)

/datum/species/golem/bluespace/on_hit(obj/projectile/P, mob/living/carbon/human/H)
	..()
	if(world.time > last_teleport + teleport_cooldown)
		reactive_teleport(H)

/datum/species/golem/bluespace/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		unstable_teleport = new
		unstable_teleport.Grant(C)
		last_teleport = world.time

/datum/species/golem/bluespace/on_species_loss(mob/living/carbon/C)
	if(unstable_teleport)
		unstable_teleport.Remove(C)
	..()

/datum/action/innate/unstable_teleport
	name = "нестабильный телепорт"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "jaunt"
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	var/cooldown = 150
	var/last_teleport = 0

/datum/action/innate/unstable_teleport/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return
	if(world.time > last_teleport + cooldown)
		return TRUE
	return FALSE

/datum/action/innate/unstable_teleport/Activate()
	var/mob/living/carbon/human/H = owner
	H.visible_message(span_warning("[H] starts vibrating!") , span_danger("начинаю заряжать своё блюспейс ядро..."))
	playsound(get_turf(H), 'sound/weapons/flash.ogg', 25, TRUE)
	addtimer(CALLBACK(src, PROC_REF(teleport), H), 15)

/datum/action/innate/unstable_teleport/proc/teleport(mob/living/carbon/human/H)
	H.visible_message(span_warning("[H] исчезает в куче искр!") , span_danger("Телепортируюсь!"))
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(10, 0, src)
	spark_system.attach(H)
	spark_system.start()
	do_teleport(H, get_turf(H), 12, asoundin = 'sound/weapons/emitter2.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
	last_teleport = world.time
	build_all_button_icons() //action icon looks unavailable
	//action icon looks available again
	addtimer(CALLBACK(src, PROC_REF(build_all_button_icons)), cooldown + 5)


//honk
/datum/species/golem/bananium
	name = "бананиевый голем"
	id = "bananium golem"
	fixed_mut_color = "ff0"
	say_mod = "хонкает"
	inherent_traits = list(
		TRAIT_RESISTHEAT,
		TRAIT_NOBREATH,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_NOFIRE,
		TRAIT_CHUNKYFINGERS,
		TRAIT_CLUMSY,
		TRAIT_RADIMMUNE,
		TRAIT_GENELESS,
		TRAIT_PIERCEIMMUNE,
		TRAIT_NODISMEMBER,
		TRAIT_CAN_STRIP,
	)
	punchdamagelow = 0
	punchdamagehigh = 1
	punchstunthreshold = 2 //Harmless and can't stun
	meat = /obj/item/stack/ore/bananium
	info_text = "Будучи <span class='danger'>бананиевым големом</span> я сделан для пранков. Моё тело издаёт звуки хонка, из-за чего мои удары почти не вредят остальным. При получении урона, моё тело кровоточит банановыми кожурами."
	attack_verb = "ХОНКАЕТ"
	attack_sound = 'sound/items/airhorn2.ogg'
	prefix = "Бананиумовый"
	special_names = null

	/// Cooldown for producing honks
	COOLDOWN_DECLARE(honkooldown)
	/// Cooldown for producing bananas
	COOLDOWN_DECLARE(banana_cooldown)
	/// Time between possible banana productions
	var/banana_delay = 10 SECONDS
	/// Same as the uranium golem. I'm pretty sure this is vestigial.
	var/active = FALSE

/datum/species/golem/bananium/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	COOLDOWN_START(src, honkooldown, 0)
	COOLDOWN_START(src, banana_cooldown, banana_delay)
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	var/obj/item/organ/liver/liver = C.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver)
		ADD_TRAIT(liver, TRAIT_COMEDY_METABOLISM, SPECIES_TRAIT)

/datum/species/golem/bananium/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

	var/obj/item/organ/liver/liver = C.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver)
		REMOVE_TRAIT(liver, TRAIT_COMEDY_METABOLISM, SPECIES_TRAIT)

/datum/species/golem/bananium/random_name(gender, unique, lastname, en_lang)
	var/clown_name = pick(GLOB.clown_names)
	var/golem_name = "[uppertext(clown_name)]"
	return golem_name

/datum/species/golem/bananium/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	..()
	if(COOLDOWN_FINISHED(src, banana_cooldown) && M != H && M.a_intent != INTENT_HELP)
		new /obj/item/grown/bananapeel/specialpeel(get_turf(H))
		COOLDOWN_START(src, banana_cooldown, banana_delay)

/datum/species/golem/bananium/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	..()
	if((user != H) && COOLDOWN_FINISHED(src, banana_cooldown))
		new /obj/item/grown/bananapeel/specialpeel(get_turf(H))
		COOLDOWN_START(src, banana_cooldown, banana_delay)

/datum/species/golem/bananium/on_hit(obj/projectile/P, mob/living/carbon/human/H)
	..()
	if(COOLDOWN_FINISHED(src, banana_cooldown))
		new /obj/item/grown/bananapeel/specialpeel(get_turf(H))
		COOLDOWN_START(src, banana_cooldown, banana_delay)

/datum/species/golem/bananium/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	..()
	var/obj/item/I
	if(istype(AM, /obj/item))
		I = AM
		if(I.thrownby == WEAKREF(H)) //No throwing stuff at yourself to make bananas
			return 0
		else
			new/obj/item/grown/bananapeel/specialpeel(get_turf(H))
			COOLDOWN_START(src, banana_cooldown, banana_delay)

/datum/species/golem/bananium/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	if(!active && COOLDOWN_FINISHED(src, honkooldown))
		active = TRUE
		playsound(get_turf(H), 'sound/items/bikehorn.ogg', 50, TRUE)
		COOLDOWN_START(src, honkooldown, rand(2 SECONDS, 8 SECONDS))
		active = FALSE
	..()

/datum/species/golem/bananium/spec_death(gibbed, mob/living/carbon/human/H)
	playsound(get_turf(H), 'sound/misc/sadtrombone.ogg', 70, FALSE)

/datum/species/golem/bananium/proc/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_CLOWN

/datum/species/golem/runic
	name = "рунический голем"
	id = "runic golem"
	limbs_id = "cultgolem"
	sexes = FALSE
	info_text = "Будучи <span class='danger'>руническим големом</span> я обладаю сверхъестественными силами, дарованные Старшей Богиней Нар Си."
	species_traits = list(NOBLOOD,NO_UNDERWEAR,NOEYESPRITES) //no mutcolors
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOFLASH,TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOFIRE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER)
	inherent_biotypes = MOB_HUMANOID|MOB_MINERAL
	prefix = "Рунический"
	special_names = null
	inherent_factions = list("cult")
	species_language_holder = /datum/language_holder/golem/runic

	/// A ref to our jaunt spell that we get on species gain.
	var/datum/action/cooldown/spell/jaunt/ethereal_jaunt/shift/golem/jaunt
	/// A ref to our gaze spell that we get on species gain.
	var/datum/action/cooldown/spell/pointed/abyssal_gaze/abyssal_gaze
	/// A ref to our dominate spell that we get on species gain.
	var/datum/action/cooldown/spell/pointed/dominate/dominate

/datum/species/golem/runic/random_name(gender,unique,lastname, en_lang = FALSE)
	var/edgy_first_name = pick("Razor","Blood","Dark","Evil","Cold","Pale","Black","Silent","Chaos","Deadly","Coldsteel")
	var/edgy_last_name = pick("Edge","Night","Death","Razor","Blade","Steel","Calamity","Twilight","Shadow","Nightmare") //dammit Razor Razor
	var/golem_name = "[edgy_first_name] [edgy_last_name]"
	return golem_name

/datum/species/golem/runic/on_species_gain(mob/living/carbon/grant_to, datum/species/old_species)
	. = ..()
	// Create our species specific spells here.
	// Note we link them to the mob, not the mind,
	// so they're not moved around on mindswaps
	jaunt = new(grant_to)
	jaunt.StartCooldown()
	jaunt.Grant(grant_to)

	abyssal_gaze = new(grant_to)
	abyssal_gaze.StartCooldown()
	abyssal_gaze.Grant(grant_to)

	dominate = new(grant_to)
	dominate.StartCooldown()
	dominate.Grant(grant_to)

/datum/species/golem/runic/on_species_loss(mob/living/carbon/C)
	// Aaand cleanup our species specific spells.
	// No free rides.
	QDEL_NULL(jaunt)
	QDEL_NULL(abyssal_gaze)
	QDEL_NULL(dominate)
	return ..()

/datum/species/golem/runic/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	if(istype(chem, /datum/reagent/water/holywater))
		H.adjustFireLoss(4 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)

	if(chem.type == /datum/reagent/fuel/unholywater)
		H.adjustBruteLoss(-4 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		H.adjustFireLoss(-4 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)

/datum/species/golem/cloth
	name = "тканевый голем"
	id = "cloth golem"
	limbs_id = "clothgolem"
	sexes = FALSE
	info_text = "Будучи <span class='danger'>тканевым големом</span> после смерти можно преобразовать своё тело и заново возродиться, если мои остатки не сгорели или не уничтожены. Также меня легко воспламенить. \
	Так как я сделан из ткани, моё тело игнорирует магию и быстрее, чем у других големов, но оно слабее."
	species_traits = list(NOBLOOD,NO_UNDERWEAR) //no mutcolors, and can burn
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_RESISTCOLD,TRAIT_NOBREATH,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER,TRAIT_CHUNKYFINGERS)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	armor = 15 //feels no pain, but not too resistant
	burnmod = 2 // don't get burned
	speedmod = 1 // not as heavy as stone
	punchdamagelow = 4
	punchstunthreshold = 7
	punchdamagehigh = 8 // not as heavy as stone
	prefix = "Тканевый"
	special_names = null

/datum/species/golem/cloth/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	ADD_TRAIT(C, TRAIT_HOLY, SPECIES_TRAIT)

/datum/species/golem/cloth/on_species_loss(mob/living/carbon/C)
	REMOVE_TRAIT(C, TRAIT_HOLY, SPECIES_TRAIT)
	..()

/datum/species/golem/cloth/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return ..()

/datum/species/golem/cloth/random_name(gender,unique,lastname, en_lang = FALSE)
	var/pharaoh_name = pick("Neferkare", "Hudjefa", "Khufu", "Mentuhotep", "Ahmose", "Amenhotep", "Thutmose", "Hatshepsut", "Tutankhamun", "Ramses", "Seti", \
	"Merenptah", "Djer", "Semerkhet", "Nynetjer", "Khafre", "Pepi", "Intef", "Ay") //yes, Ay was an actual pharaoh
	var/golem_name = "[pharaoh_name] \Roman[rand(1,99)]"
	return golem_name

/datum/species/golem/cloth/spec_life(mob/living/carbon/human/H)
	if(H.fire_stacks < 1)
		H.adjust_fire_stacks(1) //always prone to burning
	..()

/datum/species/golem/cloth/spec_death(gibbed, mob/living/carbon/human/H)
	if(gibbed)
		return
	if(H.on_fire)
		H.visible_message(span_danger("[H] сгорает до тла!"))
		H.dust(just_ash = TRUE)
		return

	H.visible_message(span_danger("[H] распадается на куски ткани!"))
	new /obj/structure/cloth_pile(get_turf(H), H)
	..()

/obj/structure/cloth_pile
	name = "куча из ткани"
	desc = "Эта куча испускает странную ауру, будто в ней есть чья-то жизнь..."
	max_integrity = 50
	armor = list(MELEE = 90, BULLET = 90, LASER = 25, ENERGY = 80, BOMB = 50, BIO = 100, FIRE = -50, ACID = -50)
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "pile_bandages"
	resistance_flags = FLAMMABLE

	var/revive_time = 900
	var/mob/living/carbon/human/cloth_golem

/obj/structure/cloth_pile/Initialize(mapload, mob/living/carbon/human/H)
	. = ..()
	if(!QDELETED(H) && is_species(H, /datum/species/golem/cloth))
		H.unequip_everything()
		H.forceMove(src)
		cloth_golem = H
		to_chat(cloth_golem, span_notice("Начинаю собирать жизненную энергию, чтобы восстать из мёртвых..."))
		addtimer(CALLBACK(src, PROC_REF(revive)), revive_time)
	else
		return INITIALIZE_HINT_QDEL

/obj/structure/cloth_pile/Destroy()
	if(cloth_golem)
		QDEL_NULL(cloth_golem)
	return ..()

/obj/structure/cloth_pile/burn()
	visible_message(span_danger("[capitalize(src.name)] сгорает до тла!"))
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	..()

/obj/structure/cloth_pile/proc/revive(full_heal = FALSE, admin_revive = FALSE)
	if(QDELETED(src) || QDELETED(cloth_golem)) //QDELETED also checks for null, so if no cloth golem is set this won't runtime
		return
	if(cloth_golem.suiciding)
		QDEL_NULL(cloth_golem)
		return

	invisibility = INVISIBILITY_MAXIMUM //disappear before the animation
	new /obj/effect/temp_visual/mummy_animation(get_turf(src))
	if(cloth_golem.revive(full_heal = TRUE, admin_revive = TRUE))
		cloth_golem.grab_ghost() //won't pull if it's a suicide
	sleep(20)
	cloth_golem.forceMove(get_turf(src))
	cloth_golem.visible_message(span_danger("[capitalize(src.name)] встаёт и преобразовывается в [cloth_golem]!") ,span_userdanger("Преобразовываю себя!"))
	cloth_golem = null
	qdel(src)

/obj/structure/cloth_pile/attackby(obj/item/P, mob/living/carbon/human/user, params)
	. = ..()

	if(resistance_flags & ON_FIRE)
		return

	if(P.get_temperature())
		visible_message(span_danger("[capitalize(src.name)] горит!"))
		fire_act()

/datum/species/golem/plastic
	name = "пластиковый голем"
	id = "plastic golem"
	prefix = "Пластмассовый"
	special_names = list("Sheet", "Bag", "Bottle")
	fixed_mut_color = "fffa"
	info_text = "Будучи <span class='danger'>пластиковым големом</span> мне дана возможность ходить по вентиляциям и проходить сквозь пластиковые заслонки пока я голый."
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_CHUNKYFINGERS,
		TRAIT_GENELESS,
		TRAIT_NOBREATH,
		TRAIT_NODISMEMBER,
		TRAIT_NOFIRE,
		TRAIT_PIERCEIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_VENTCRAWLER_NUDE,
	)

/datum/species/golem/bronze
	name = "латунный голем"
	id = "bronze golem"
	prefix = "латунный"
	special_names = list("Bell")
	fixed_mut_color = "cd7f32"
	info_text = "Будучи <span class='danger'>бронзовым големом</span> мне не опасны громкие звуки. Если меня кто-то бьёт, я издаю громкие звуки, тем не менее такая способность вредит моим ушам... Звучит логично!"
	special_step_sounds = list('sound/machines/clockcult/integration_cog_install.ogg', 'sound/magic/clockwork/fellowship_armory.ogg' )
	mutantears = /obj/item/organ/ears/bronze
	var/last_gong_time = 0
	var/gong_cooldown = 150

/datum/species/golem/bronze/bullet_act(obj/projectile/P, mob/living/carbon/human/H)
	if(!(world.time > last_gong_time + gong_cooldown))
		return ..()
	if(P.flag == BULLET || P.flag == BOMB)
		gong(H)
		return ..()

/datum/species/golem/bronze/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	..()
	if(world.time > last_gong_time + gong_cooldown)
		gong(H)

/datum/species/golem/bronze/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	..()
	if(world.time > last_gong_time + gong_cooldown &&  M.a_intent != INTENT_HELP)
		gong(H)

/datum/species/golem/bronze/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	..()
	if(world.time > last_gong_time + gong_cooldown)
		gong(H)

/datum/species/golem/bronze/on_hit(obj/projectile/P, mob/living/carbon/human/H)
	..()
	if(world.time > last_gong_time + gong_cooldown)
		gong(H)

/datum/species/golem/bronze/proc/gong(mob/living/carbon/human/H)
	last_gong_time = world.time
	for(var/mob/living/M in get_hearers_in_view(7,H))
		if(M.stat == DEAD)	//F
			continue
		if(M == H)
			H.show_message(span_narsiesmall("Сьёживаюсь от боли как только моё тело начало звенеть!") , MSG_AUDIBLE)
			H.playsound_local(H, 'sound/effects/gong.ogg', 100, TRUE)
			H.soundbang_act(2, 0, 100, 1)
			H.jitteriness += 7
		var/distance = max(0,get_dist(get_turf(H),get_turf(M)))
		switch(distance)
			if(0 to 1)
				M.show_message(span_narsiesmall("ГОНГ!") , MSG_AUDIBLE)
				M.playsound_local(H, 'sound/effects/gong.ogg', 100, TRUE)
				M.soundbang_act(1, 0, 30, 3)
				M.add_confusion(10)
				M.jitteriness += 4
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "gonged", /datum/mood_event/loud_gong)
			if(2 to 3)
				M.show_message(span_cult("ГОНГ!") , MSG_AUDIBLE)
				M.playsound_local(H, 'sound/effects/gong.ogg', 75, TRUE)
				M.soundbang_act(1, 0, 15, 2)
				M.jitteriness += 3
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "gonged", /datum/mood_event/loud_gong)
			else
				M.show_message(span_warning("ГОНГ!") , MSG_AUDIBLE)
				M.playsound_local(H, 'sound/effects/gong.ogg', 50, TRUE)


/datum/species/golem/cardboard //Faster but weaker, can also make new shells on its own
	name = "картонный голем"
	id = "cardboard golem"
	prefix = "Картонный"
	special_names = list("Box")
	info_text = "Будучи <span class='danger'>картонным големом</span> я слаб, но немного быстрее и могу с лёгкостью создать себе подобных братьев с помощью использования картона на себе."
	species_traits = list(NOBLOOD,NO_UNDERWEAR,NOEYESPRITES)
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOBREATH, TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER, TRAIT_NOFLASH)
	limbs_id = "c_golem" //special sprites
	attack_verb = "шлёпает"
	attack_sound = 'sound/weapons/whip.ogg'
	miss_sound = 'sound/weapons/etherealmiss.ogg'
	fixed_mut_color = null
	armor = 25
	burnmod = 1.25
	heatmod = 2
	speedmod = 1.5
	punchdamagelow = 4
	punchstunthreshold = 7
	punchdamagehigh = 8
	var/last_creation = 0
	var/brother_creation_cooldown = 300

/datum/species/golem/cardboard/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	. = ..()
	if(user != H)
		return FALSE //forced reproduction is rape.
	if(istype(I, /obj/item/stack/sheet/cardboard))
		var/obj/item/stack/sheet/cardboard/C = I
		if(last_creation + brother_creation_cooldown > world.time) //no cheesing dork
			return
		if(C.amount < 10)
			to_chat(H, span_warning("Не хватает картона!"))
			return FALSE
		to_chat(H, span_notice("Пытаюсь создать нового картонного брата."))
		if(do_after(user, 30, target = user))
			if(last_creation + brother_creation_cooldown > world.time) //no cheesing dork
				return
			if(!C.use(10))
				to_chat(H, span_warning("Не хватает картона!"))
				return FALSE
			to_chat(H, span_notice("Создаю новую картонную оболочку голема."))
			create_brother(H.loc)

/datum/species/golem/cardboard/proc/create_brother(location)
	new /obj/effect/mob_spawn/human/golem/servant(location, /datum/species/golem/cardboard, owner)
	last_creation = world.time

/datum/species/golem/leather
	name = "кожаный голем"
	id = "leather golem"
	special_names = list("Face", "Man", "Belt") //Ah dude 4 strength 4 stam leather belt AHHH
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOBREATH, TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER, TRAIT_STRONG_GRABBER)
	prefix = "Кожаный"
	fixed_mut_color = "624a2e"
	info_text = "Будучи <span class='danger'>кожаным големом</span> меня легко воспламенить, но можно брать вещи с невероятной лёгкостью, позволяя сразу хватать крепче."
	grab_sound = 'sound/weapons/whipgrab.ogg'
	attack_sound = 'sound/weapons/whip.ogg'

/datum/species/golem/durathread
	name = "дюратканевый голем"
	id = "дюратканевый golem"
	prefix = "Дюратканевый"
	limbs_id = "d_golem"
	special_names = list("Boll","Weave")
	species_traits = list(NOBLOOD,NO_UNDERWEAR,NOEYESPRITES)
	fixed_mut_color = null
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOBREATH, TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER, TRAIT_NOFLASH)
	info_text = "Будучи <span class='danger'>дюратканевым големом</span> мои атаки душат цели, но моё тканевое тело легко воспламеняемое."

/datum/species/golem/durathread/spec_unarmedattacked(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	target.apply_status_effect(STATUS_EFFECT_CHOKINGSTRAND)

/datum/species/golem/bone
	name = "костяной голем"
	id = "bone golem"
	say_mod = "костлявит"
	prefix = "Костяной"
	limbs_id = "b_golem"
	special_names = list("Head", "Broth", "Fracture", "Rattler", "Appetit")
	liked_food = GROSS | MEAT | RAW
	toxic_food = null
	species_traits = list(NOBLOOD,NO_UNDERWEAR,NOEYESPRITES,HAS_BONE)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	mutanttongue = /obj/item/organ/tongue/bone
	mutantstomach = /obj/item/organ/stomach/bone
	sexes = FALSE
	fixed_mut_color = null
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOFLASH,TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOFIRE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER,TRAIT_FAKEDEATH)
	species_language_holder = /datum/language_holder/golem/bone
	info_text = "Будучи <span class='danger'>костяным големом</span> я имею способность. которая пробирает врагов до страха. Меня лечит молоко."
	var/datum/action/innate/bonechill/bonechill

/datum/species/golem/bone/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		bonechill = new
		bonechill.Grant(C)

/datum/species/golem/bone/on_species_loss(mob/living/carbon/C)
	if(bonechill)
		bonechill.Remove(C)
	..()

/datum/species/golem/bone/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	. = ..()
	if(chem.type == /datum/reagent/toxin/bonehurtingjuice)
		H.adjustStaminaLoss(7.5 * REAGENTS_EFFECT_MULTIPLIER * delta_time, 0)
		H.adjustBruteLoss(0.5 * REAGENTS_EFFECT_MULTIPLIER * delta_time, 0)
		if(DT_PROB(10, delta_time))
			switch(rand(1, 3))
				if(1)
					H.say(pick("oof.", "ouch.", "my bones.", "oof ouch.", "oof ouch my bones."), forced = /datum/reagent/toxin/bonehurtingjuice)
				if(2)
					H.manual_emote(pick("oofs silently.", "looks like their bones hurt.", "grimaces, as though their bones hurt."))
				if(3)
					to_chat(H, span_warning("Мои кости болят!"))
		if(chem.overdosed)
			if(DT_PROB(2, delta_time) && iscarbon(H)) //big oof
				var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly.
				var/obj/item/bodypart/bp = H.get_bodypart(selected_part) //We're so sorry skeletons, you're so misunderstood
				if(bp)
					playsound(H, get_sfx("desecration"), 50, TRUE, -1) //You just want to socialize
					H.visible_message(span_warning("[H] rattles loudly and flails around!!") , span_danger("Your bones hurt so much that your missing muscles spasm!!"))
					H.say("OOF!!", forced=/datum/reagent/toxin/bonehurtingjuice)
					bp.receive_damage(200, 0, 0) //But I don't think we should
				else
					to_chat(H, span_warning("Your missing arm aches from wherever you left it."))
					H.emote("sigh")
		H.reagents.remove_reagent(chem.type, chem.metabolization_rate * delta_time)
		return TRUE

/datum/action/innate/bonechill
	name = "Bone Chill"
	desc = "Rattle your bones and strike fear into your enemies!"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "bonechill"
	var/cooldown = 600
	var/last_use
	var/snas_chance = 3

/datum/action/innate/bonechill/Activate()
	if(world.time < last_use + cooldown)
		to_chat(span_warning("You aren't ready yet to rattle your bones again!"))
		return
	owner.visible_message(span_warning("[owner] rattles [owner.ru_ego()] bones harrowingly.") , span_notice("You rattle your bones"))
	last_use = world.time
	if(prob(snas_chance))
		playsound(get_turf(owner),'sound/magic/RATTLEMEBONES2.ogg', 100)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			var/mutable_appearance/badtime = mutable_appearance('icons/mob/human_parts.dmi', "b_golem_eyes", -FIRE_LAYER-0.5)
			badtime.appearance_flags = RESET_COLOR
			H.overlays_standing[FIRE_LAYER+0.5] = badtime
			H.apply_overlay(FIRE_LAYER+0.5)
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon, remove_overlay), FIRE_LAYER+0.5), 25)
	else
		playsound(get_turf(owner),'sound/magic/RATTLEMEBONES.ogg', 100)
	for(var/mob/living/L in orange(7, get_turf(owner)))
		if((L.mob_biotypes & MOB_UNDEAD) || isgolem(L) || HAS_TRAIT(L, TRAIT_RESISTCOLD))
			continue //Do not affect our brothers

		to_chat(L, span_cultlarge("A spine-chilling sound chills you to the bone!"))
		L.apply_status_effect(/datum/status_effect/bonechill)
		SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "spooked", /datum/mood_event/spooked)

/datum/species/golem/snow
	name = "Snow Golem"
	id = "snow golem"
	limbs_id = "sn_golem"
	fixed_mut_color = "null" //custom sprites
	armor = 45 //down from 55
	burnmod = 3 //melts easily
	info_text = "As a <span class='danger'>Snow Golem</span>, you are extremely vulnerable to burn damage, but you can generate snowballs and shoot cryokinetic beams. You will also turn to snow when dying, preventing any form of recovery."
	prefix = "Снежный"
	special_names = list("Flake", "Blizzard", "Storm")
	species_traits = list(NOBLOOD,NO_UNDERWEAR,NOEYESPRITES) //no mutcolors, no eye sprites
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER)

	/// A ref to our "throw snowball" spell we get on species gain.
	var/datum/action/cooldown/spell/conjure_item/snowball/snowball
	/// A ref to our cryobeam spell we get on species gain.
	var/datum/action/cooldown/spell/pointed/projectile/cryo/cryo

/datum/species/golem/snow/spec_death(gibbed, mob/living/carbon/human/H)
	H.visible_message(span_danger("[H] turns into a pile of snow!"))
	for(var/obj/item/W in H)
		H.dropItemToGround(W)
	for(var/i=1, i <= rand(3,5), i++)
		new /obj/item/stack/sheet/mineral/snow(get_turf(H))
	new /obj/item/food/grown/carrot(get_turf(H))
	qdel(H)

/datum/species/golem/snow/on_species_gain(mob/living/carbon/grant_to, datum/species/old_species)
	. = ..()
	LAZYOR(grant_to.weather_immunities, WEATHER_SNOW)
	snowball = new(grant_to)
	snowball.StartCooldown()
	snowball.Grant(grant_to)

	cryo = new(grant_to)
	cryo.StartCooldown()
	cryo.Grant(grant_to)

/datum/species/golem/snow/on_species_loss(mob/living/carbon/C)
	LAZYREMOVE(C.weather_immunities, WEATHER_SNOW)
	QDEL_NULL(snowball)
	QDEL_NULL(cryo)
	return ..()

/datum/species/golem/mhydrogen
	name = "Metallic Hydrogen Golem"
	id = "Metallic Hydrogen golem"
	fixed_mut_color = "ddd"
	info_text = "As a <span class='danger'>Metallic Hydrogen Golem</span>, you were forged in the highest pressures and the highest heats. Your unique mineral makeup makes you immune to most types of damages."
	prefix = "Металл-водороный"
	special_names = null
	inherent_traits = list(TRAIT_CAN_STRIP,TRAIT_ADVANCEDTOOLUSER,TRAIT_NOFLASH, TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTHIGHPRESSURE,TRAIT_NOFIRE,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_NODISMEMBER,TRAIT_CHUNKYFINGERS)

/datum/species/golem/mhydrogen/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	ADD_TRAIT(C, TRAIT_ANTIMAGIC, SPECIES_TRAIT)

/datum/species/golem/mhydrogen/on_species_loss(mob/living/carbon/C)
	REMOVE_TRAIT(C, TRAIT_ANTIMAGIC, SPECIES_TRAIT)
	return ..()
