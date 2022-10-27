// 	Мобы

// 	Ратвар

/mob/living/simple_animal/hostile/ratvar
	name = "Мехскарабей"
	desc = "Механическое устройство, наполненное движущимися шестерёнками и механическими частями, создано для Риби."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_clock"
	icon_living = "drone_clock"
	icon_dead = "drone_clock_dead"

	health = 30
	maxHealth = 30
	discovery_points = 2000

	obj_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 10

	attack_verb_continuous = "бьет"
	attack_verb_simple = "бьет"
	attack_sound = 'sound/weapons/stab2.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	faction = list("ratvar")
	deathsound = 'sound/magic/clockwork/anima_fragment_death.ogg'

	gold_core_spawnable = HOSTILE_SPAWN
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/ratvar/marauder
	name = "механический мародёр"
	desc = "Латунная машина разрушения."
	icon = 'icons/mob/clockwork_mobs.dmi'
	icon_state = "clockwork_marauder"
	icon_living = "clockwork_marauder"
	icon_dead = "anime_fragment"
	health = 140
	maxHealth = 140
	discovery_points = 3000

	obj_damage = 30
	melee_damage_lower = 25
	melee_damage_upper = 35

// 	Саморастущая паутина

/obj/structure/spider/stickyweb/expand

/obj/structure/spider/stickyweb/expand/Initialize(mapload)
	. = ..()
	for(var/T in circle_view_turfs(src, 1))
		if(!isclosedturf(T))
			new /obj/structure/spider/stickyweb(T)

// 	Спавнеры
/obj/effect/spawner/lootdrop/genetics_filler	//	14 хороших/24 плохих
	name = "спавнер мутаторов наполнителей"
	loot = list(
		/obj/item/dnainjector/dwarf = 1,
		/obj/item/dnainjector/firemut = 1,
		/obj/item/dnainjector/chameleonmut = 1,
		/obj/item/dnainjector/antenna = 1,
		/obj/item/dnainjector/olfaction = 1,
		/obj/item/dnainjector/insulated = 1,
		/obj/item/dnainjector/geladikinesis = 1,
		/obj/item/dnainjector/cryokinesis = 1,
		/obj/item/dnainjector/thermal = 1,
		/obj/item/dnainjector/glow = 1,
		/obj/item/dnainjector/webbing = 1,
		/obj/item/dnainjector/telepathy = 1,
		/obj/item/dnainjector/tongue_spike = 1,
		/obj/item/dnainjector/self_amputation = 1,
		/obj/item/dnainjector/telemut = 1,

		/obj/item/dnainjector/glassesmut = 2,
		/obj/item/dnainjector/epimut = 2,
		/obj/item/dnainjector/coughmut = 2,
		/obj/item/dnainjector/clumsymut = 2,
		/obj/item/dnainjector/tourmut = 2,
		/obj/item/dnainjector/stuttmut = 2,
		/obj/item/dnainjector/blindmut = 2,
		/obj/item/dnainjector/deafmut = 2,
		/obj/item/dnainjector/h2m = 2,
		/obj/item/dnainjector/wackymut = 2,
		/obj/item/dnainjector/mutemut = 2,
		/obj/item/dnainjector/unintelligiblemut = 2,
		/obj/item/dnainjector/swedishmut = 2,
		/obj/item/dnainjector/chavmut = 2,
		/obj/item/dnainjector/elvismut = 2,
		/obj/item/dnainjector/void = 2,
		/obj/item/dnainjector/paranoia = 2,
		/obj/item/dnainjector/radioactive = 2,
		/obj/item/dnainjector/spatialinstability = 2,
		/obj/item/dnainjector/antiacidflesh = 2,
		/obj/item/dnainjector/gigantism = 2,
		/obj/item/dnainjector/spastic = 2,
		/obj/item/dnainjector/twoleftfeet = 2,
		/obj/item/dnainjector/bad_dna = 2,
		)
	lootdoubles = TRUE

/obj/effect/spawner/lootdrop/genetics_good		//	14 хороших/6 комбинаторных/3 закрытых
	name = "спавнер наградных мутаторов"
	loot = list(
		/obj/item/dnainjector/dwarf = 2,
		/obj/item/dnainjector/firemut = 2,
		/obj/item/dnainjector/chameleonmut = 2,
		/obj/item/dnainjector/antenna = 2,
		/obj/item/dnainjector/olfaction = 2,
		/obj/item/dnainjector/insulated = 2,
		/obj/item/dnainjector/geladikinesis = 2,
		/obj/item/dnainjector/cryokinesis = 2,
		/obj/item/dnainjector/thermal = 2,
		/obj/item/dnainjector/glow = 2,
		/obj/item/dnainjector/webbing = 2,
		/obj/item/dnainjector/telepathy = 2,
		/obj/item/dnainjector/tongue_spike = 2,
		/obj/item/dnainjector/self_amputation = 2,
		/obj/item/dnainjector/telemut = 2,

		/obj/item/dnainjector/hulkmut = 1,
		/obj/item/dnainjector/mindread = 1,
		/obj/item/dnainjector/shock = 1,
		/obj/item/dnainjector/antiglow = 1,
		/obj/item/dnainjector/martyrdom = 1,
		/obj/item/dnainjector/chemtongue_spike = 1,

		/obj/item/dnainjector/xraymut = 1,
		/obj/item/dnainjector/lasereyesmut = 1,
		/obj/item/dnainjector/firebreath = 1,
		)
	lootdoubles = TRUE

/obj/effect/spawner/lootdrop/pins
	name = "спавнер ударников 6 шт."
	lootcount = 6
	loot = list(
		/obj/item/firing_pin = 3,
		/obj/item/firing_pin/implant/mindshield = 2,
		/obj/item/firing_pin/dna = 1,
		)
	lootdoubles = TRUE

/obj/structure/window/reinforced/fulltile/derelict
	name = "армированное пластинчатое окно"
	icon = 'white/valtos/icons/windows.dmi'
	icon_state = "windows-0"
	base_icon_state = "windows"
	max_integrity = 200
//	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE)

/obj/effect/spawner/structure/window/reinforced/derelict
	name = "спавнер окна дереликта"
	icon = 'icons/obj/smooth_structures/pod_window.dmi'
	icon_state = "pod_window-0"
	spawn_list = list(/obj/structure/window/reinforced/fulltile/derelict)
