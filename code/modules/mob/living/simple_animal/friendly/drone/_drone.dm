
#define DRONE_HANDS_LAYER 1
#define DRONE_HEAD_LAYER 2
#define DRONE_TOTAL_LAYERS 2

/// Message displayed when new drone spawns in drone network
#define DRONE_NET_CONNECT span_notice("DRONE NETWORK: [name] connected.")
/// Message displayed when drone in network dies
#define DRONE_NET_DISCONNECT span_danger("DRONE NETWORK: [name] is not responding.")

/// Maintenance Drone icon_state (multiple colors)
#define MAINTDRONE	"drone_maint"
/// Repair Drone icon_state
#define REPAIRDRONE	"drone_repair"
/// Scout Drone icon_state
#define SCOUTDRONE	"drone_scout"
/// Clockwork Drone icon_state
#define CLOCKDRONE	"drone_clock"

/// [MAINTDRONE] hacked icon_state
#define MAINTDRONE_HACKED "drone_maint_red"
/// [REPAIRDRONE] hacked icon_state
#define REPAIRDRONE_HACKED "drone_repair_hacked"
/// [SCOUTDRONE] hacked icon_state
#define SCOUTDRONE_HACKED "drone_scout_hacked"

/**
 * # Maintenance Drone
 *
 * Small player controlled fixer-upper
 *
 * The maintenace drone is a ghost role with the objective to repair and
 * maintain the station.
 *
 * Featuring two dexterous hands, and a built in toolbox stocked with
 * tools.
 *
 * They have laws to prevent them from doing anything else.
 *
 */
/mob/living/simple_animal/drone
	name = "Drone"
	desc = "A maintenance drone, an expendable robot built to perform station repairs."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_maint_grey"
	icon_living = "drone_maint_grey"
	icon_dead = "drone_maint_dead"
	possible_a_intents = list(INTENT_HELP, INTENT_HARM)
	health = 30
	maxHealth = 30
	unsuitable_atmos_damage = 0
	wander = 0
	speed = 0
	ventcrawler = VENTCRAWLER_ALWAYS
	healable = 0
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	sight = (SEE_TURFS | SEE_OBJS)
	status_flags = (CANPUSH | CANSTUN | CANKNOCKDOWN)
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	speak_emote = list("chirps")
	speech_span = SPAN_ROBOT
	bubble_icon = "machine"
	initial_language_holder = /datum/language_holder/drone
	mob_size = MOB_SIZE_SMALL
	has_unlimited_silicon_privilege = 1
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	hud_possible = list(DIAG_STAT_HUD, DIAG_HUD, ANTAG_HUD, HACKER_HUD)
	unique_name = TRUE
	faction = list("neutral","silicon","turret")
	dextrous = TRUE
	dextrous_hud_type = /datum/hud/dextrous/drone
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	see_in_dark = 7
	can_be_held = TRUE
	worn_slot_flags = ITEM_SLOT_HEAD
	held_items = list(null, null)
	/// `TRUE` if we have picked our visual appearance, `FALSE` otherwise (default)
	var/picked = FALSE
	/// Stored drone color, restored when unhacked
	var/colour = "grey"
	var/list/drone_overlays[DRONE_TOTAL_LAYERS]
	/// Drone laws announced on spawn
	var/laws = \
	"1. You may not involve yourself in the matters of another being, even if such matters conflict with Law Two or Law Three, unless the other being is another Drone.\n"+\
	"2. You may not harm any being, regardless of intent or circumstance.\n"+\
	"3. Your goals are to actively build, maintain, repair, improve, and provide power to the best of your abilities within the facility that housed your activation." //for derelict drones so they don't go to station.
	/// Amount of damage sustained if hit by a heavy EMP pulse
	var/heavy_emp_damage = 25
	///Alarm listener datum, handes caring about alarm events and such
	var/datum/alarm_listener/listener
	/// Internal storage slot. Fits any item
	var/obj/item/internal_storage
	/// Headwear slot
	var/obj/item/head
	/// Default [/mob/living/simple_animal/drone/var/internal_storage] item
	var/obj/item/default_storage = /obj/item/storage/backpack/duffelbag/drone
	/// Default [/mob/living/simple_animal/drone/var/head] item
	var/obj/item/default_hatmask
	/**
	  * icon_state of drone from icons/mobs/drone.dmi
	  *
	  * Possible states are:
	  *
	  * - [MAINTDRONE]
	  * - [REPAIRDRONE]
	  * - [SCOUTDRONE]
	  * - [CLOCKDRONE]
	  */
	var/visualAppearance = MAINTDRONE
	/// Hacked state, see [/mob/living/simple_animal/drone/proc/update_drone_hack]
	var/hacked = FALSE
	/// Flavor text announced to drones on [/mob/proc/Login]
	var/flavortext = \
	"\n<big><span class='warning'>Не нарушайте правила для дронов указанные ниже. Нарушение данных правил карается пермой дронов </span></big>\n"+\
	"<span class='notice'>Будучи дроном вы ДОЛЖНЫ И ТОЛЬКО ДОЛЖНЫ производить ремонт станции. Любое вмешательство дрона в раунд карается пермой</span>\n"+\
	"<span class='notice'>Действия по которым дают по попе</span>\n"+\
	"<span class='notice'> - Использование критически важных вещей (ИД-карты, оружия, контрабанда, вещи синдиката и прочее.)</span>\n"+\
	"<span class='notice'> - Взаимодействие с живыми существами (общение, лечение, избиение и прочее.)</span>\n"+\
	"<span class='notice'> - Взаимодействие с НЕ живыми существами (перенос трупов, лутание вещей мертвого человека и прочее)</span>\n"+\
	"<span class='warning'>За любой ваш косяк администрация в праве пермануть вам дрона. Разбан дрона производится отправкой фото себя в чулках с табличкой своего сикея</span>\n"+\
	"<span class='warning'>ЕРП с дронами разрешено\n"+\
	"<span class='warning'>ЕРП с живыми существами запрещено\n"+\
	span_warning("<u>Даже если ты умудрился заспавнится без правил для силиконов ты должен подчинятся правилам которые указаны выше.</u>")

/mob/living/simple_animal/drone/Initialize()
	. = ..()
	GLOB.drones_list += src
	access_card = new /obj/item/card/id/advanced/simple_bot(src)

	// Doing this hurts my soul, but simple_animal access reworks are for another day.
	var/datum/id_trim/job/cap_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/job/captain]
	access_card.add_access(cap_trim.access + cap_trim.wildcard_access)

	if(default_storage)
		var/obj/item/I = new default_storage(src)
		equip_to_slot_or_del(I, ITEM_SLOT_DEX_STORAGE)
	if(default_hatmask)
		var/obj/item/I = new default_hatmask(src)
		equip_to_slot_or_del(I, ITEM_SLOT_HEAD)

	ADD_TRAIT(access_card, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

	alert_drones(DRONE_NET_CONNECT)

	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_to_hud(src)

	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

	listener = new(list(ALARM_ATMOS, ALARM_FIRE, ALARM_POWER), list(z))
	RegisterSignal(listener, COMSIG_ALARM_TRIGGERED, .proc/alarm_triggered)
	RegisterSignal(listener, COMSIG_ALARM_CLEARED, .proc/alarm_cleared)
	listener.RegisterSignal(src, COMSIG_LIVING_DEATH, /datum/alarm_listener/proc/prevent_alarm_changes)
	listener.RegisterSignal(src, COMSIG_LIVING_REVIVE, /datum/alarm_listener/proc/allow_alarm_changes)

/mob/living/simple_animal/drone/med_hud_set_health()
	var/image/holder = hud_list[DIAG_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "huddiag[RoundDiagBar(health/maxHealth)]"

/mob/living/simple_animal/drone/med_hud_set_status()
	var/image/holder = hud_list[DIAG_STAT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(stat == DEAD)
		holder.icon_state = "huddead2"
	else if(incapacitated())
		holder.icon_state = "hudoffline"
	else
		holder.icon_state = "hudstat"

/mob/living/simple_animal/drone/Destroy()
	GLOB.drones_list -= src
	QDEL_NULL(access_card) //Otherwise it ends up on the floor!
	QDEL_NULL(listener)
	return ..()

/mob/living/simple_animal/drone/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	check_laws()

	if(flavortext)
		to_chat(src, "[flavortext]")

	if(!picked)
		pickVisualAppearance()

/mob/living/simple_animal/drone/auto_deadmin_on_login()
	if(!client?.holder)
		return TRUE
	if(CONFIG_GET(flag/auto_deadmin_silicons) || (client.prefs?.toggles & DEADMIN_POSITION_SILICON))
		return client.holder.auto_deadmin()
	return ..()

/mob/living/simple_animal/drone/death(gibbed)
	..(gibbed)
	if(internal_storage)
		dropItemToGround(internal_storage)
	if(head)
		dropItemToGround(head)

	alert_drones(DRONE_NET_DISCONNECT)


/mob/living/simple_animal/drone/gib()
	dust()

/mob/living/simple_animal/drone/examine(mob/user)
	. = list("<span class='info'>Это же [icon2html(src, user)] <b>[src]</b>!<hr>")

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "Он держит [I.get_examine_string(user)] в его [get_held_index_name(get_held_index_of_item(I))].\n"

	//Internal storage
	if(internal_storage && !(internal_storage.item_flags & ABSTRACT))
		. += "У него есть [internal_storage.get_examine_string(user)] во внутреннем хранилище.\n"

	//Cosmetic hat - provides no function other than looks
	if(head && !(head.item_flags & ABSTRACT))
		. += "А ещё у него есть [head.get_examine_string(user)] на голове.\n"

	//Braindead
	if(!client && stat != DEAD)
		. += "Его индикатор стоит в режиме ожидания.\n"

	//Hacked
	if(hacked)
		. += "<span class='warning'>Его индикатор ярко красный!</span>\n"

	//Damaged
	if(health != maxHealth)
		if(health > maxHealth * 0.33) //Between maxHealth and about a third of maxHealth, between 30 and 10 for normal drones
			. += "<span class='warning'>Он немножечко повреждён.</span>\n"
		else //otherwise, below about 33%
			. += "<span class='boldwarning'>Он невероятно сильно повреждён!</span>\n"

	//Dead
	if(stat == DEAD)
		if(client)
			. += "<span class='deadsay'>Индикатор сообщает: \"ПЕРЕЗАГРУЗКА -- ТРЕБУЕТСЯ\".</span>\n"
		else
			. += "<span class='deadsay'>Индикатор сообщает: \"ОШИБКА -- ОФФЛАЙН\".</span>\n"
	. += "</span>"


/mob/living/simple_animal/drone/assess_threat(judgement_criteria, lasercolor = "", datum/callback/weaponcheck=null) //Secbots won't hunt maintenance drones.
	return -10


/mob/living/simple_animal/drone/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	Stun(100)
	to_chat(src, span_danger("<b>ER@%R: MME^RY CO#RU9T!</b> R&$b@0tin)..."))
	if(severity == 1)
		adjustBruteLoss(heavy_emp_damage)
		to_chat(src, span_userdanger("HeAV% DA%^MMA+G TO I/O CIR!%UUT!"))

/mob/living/simple_animal/drone/proc/alarm_triggered(datum/source, alarm_type, area/source_area)
	SIGNAL_HANDLER
	to_chat(src, "--- [alarm_type] alarm detected in [source_area.name]!")

/mob/living/simple_animal/drone/proc/alarm_cleared(datum/source, alarm_type, area/source_area)
	SIGNAL_HANDLER
	to_chat(src, "--- [alarm_type] alarm in [source_area.name] has been cleared.")

/mob/living/simple_animal/drone/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash, length = 25)
	if(affect_silicon)
		return ..()

/mob/living/simple_animal/drone/mob_negates_gravity()
	return TRUE

/mob/living/simple_animal/drone/mob_has_gravity()
	return ..() || mob_negates_gravity()

/mob/living/simple_animal/drone/experience_pressure_difference(pressure_difference, direction)
	return

/mob/living/simple_animal/drone/bee_friendly()
	// Why would bees pay attention to drones?
	return TRUE

/mob/living/simple_animal/drone/electrocute_act(shock_damage, source, siemens_coeff, flags = NONE)
	return FALSE //So they don't die trying to fix wiring
