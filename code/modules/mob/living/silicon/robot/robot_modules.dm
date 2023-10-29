/obj/item/robot_module
	name = "Default"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	w_class = WEIGHT_CLASS_GIGANTIC
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	flags_1 = CONDUCT_1
	///Host of this module
	var/mob/living/silicon/robot/robot

	var/list/basic_modules = list() //a list of paths, converted to a list of instances on New()
	var/list/emag_modules = list() //ditto
	var/list/ratvar_modules = list() //ditto
	var/list/modules = list() //holds all the usable modules
	var/list/added_modules = list() //modules not inherient to the robot module, are kept when the module changes
	var/list/storages = list()

	var/list/radio_channels = list()

	var/cyborg_base_icon = "robot" //produces the icon for the borg and, if no special_light_key is set, the lights
	var/special_light_key //if we want specific lights, use this instead of copying lights in the dmi

	var/moduleselect_icon = "nomod"

	var/clean_on_move = FALSE
	var/breakable_modules = TRUE //Whether the borg loses tool slots with damage.
	var/locked_transform = TRUE //Whether swapping to this module should lockcharge the borg

	var/did_feedback = FALSE

	var/hat_offset = -3

	var/list/ride_offset_x = list("north" = 0, "south" = 0, "east" = -6, "west" = 6)
	var/list/ride_offset_y = list("north" = 4, "south" = 4, "east" = 3, "west" = 3)
	var/allow_riding = TRUE
	var/canDispose = FALSE // Whether the borg can stuff itself into disposal

	/**
	* List of traits that will be applied to the mob if this module is used.
	*/
	var/list/module_traits = null

/obj/item/robot_module/Initialize(mapload)
	. = ..()
	for(var/i in basic_modules)
		var/obj/item/I = new i(src)
		basic_modules += I
		basic_modules -= i
	for(var/i in emag_modules)
		var/obj/item/I = new i(src)
		emag_modules += I
		emag_modules -= i
	for(var/i in ratvar_modules)
		var/obj/item/I = new i(src)
		ratvar_modules += I
		ratvar_modules -= i

/obj/item/robot_module/Destroy()
	basic_modules.Cut()
	emag_modules.Cut()
	ratvar_modules.Cut()
	modules.Cut()
	added_modules.Cut()
	storages.Cut()
	return ..()

/obj/item/robot_module/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/obj/O in modules)
		O.emp_act(severity)
	..()

/obj/item/robot_module/proc/get_usable_modules()
	. = modules.Copy()

/obj/item/robot_module/proc/get_inactive_modules()
	. = list()
	var/mob/living/silicon/robot/R = loc
	for(var/m in get_usable_modules())
		if(!(m in R.held_items))
			. += m

/obj/item/robot_module/proc/get_or_create_estorage(storage_type)
	return (locate(storage_type) in storages) || new storage_type(src)

/obj/item/robot_module/proc/add_module(obj/item/I, nonstandard, requires_rebuild)
	if(istype(I, /obj/item/stack))
		var/obj/item/stack/sheet_module = I
		if(ispath(sheet_module.source, /datum/robot_energy_storage))
			sheet_module.source = get_or_create_estorage(sheet_module.source)

		if(istype(sheet_module, /obj/item/stack/sheet/rglass/cyborg))
			var/obj/item/stack/sheet/rglass/cyborg/rglass_module = sheet_module
			if(ispath(rglass_module.glasource, /datum/robot_energy_storage))
				rglass_module.glasource = get_or_create_estorage(rglass_module.glasource)

		if(istype(sheet_module, /obj/item/stack/tile/bronze))
			sheet_module.cost = 500
			sheet_module.source = get_or_create_estorage(/datum/robot_energy_storage/bronze)

		if(istype(sheet_module.source))
			sheet_module.cost = max(sheet_module.cost, 1) // Must not cost 0 to prevent div/0 errors.
			sheet_module.is_cyborg = TRUE

	if(I.loc != src)
		I.forceMove(src)
	modules += I
	ADD_TRAIT(I, TRAIT_NODROP, CYBORG_ITEM_TRAIT)
	I.mouse_opacity = MOUSE_OPACITY_OPAQUE
	if(nonstandard)
		added_modules += I
	if(requires_rebuild)
		rebuild_modules()
	return I

/obj/item/robot_module/proc/remove_module(obj/item/I, delete_after)
	basic_modules -= I
	modules -= I
	emag_modules -= I
	ratvar_modules -= I
	added_modules -= I
	rebuild_modules()
	if(delete_after)
		qdel(I)

/obj/item/robot_module/proc/respawn_consumable(mob/living/silicon/robot/R, coeff = 1)
	for(var/datum/robot_energy_storage/st in storages)
		st.energy = min(st.max_energy, st.energy + coeff * st.recharge_rate)

	for(var/obj/item/I in get_usable_modules())
		if(istype(I, /obj/item/assembly/flash))
			var/obj/item/assembly/flash/F = I
			F.times_used = 0
			F.burnt_out = FALSE
			F.update_icon()
		else if(istype(I, /obj/item/melee/baton))
			var/obj/item/melee/baton/B = I
			if(B.cell)
				B.cell.charge = B.cell.maxcharge
		else if(istype(I, /obj/item/gun/energy))
			var/obj/item/gun/energy/EG = I
			if(!EG.chambered)
				EG.recharge_newshot() //try to reload a new shot.

	R.toner = R.tonermax

/obj/item/robot_module/proc/rebuild_modules() //builds the usable module list from the modules we have
	var/mob/living/silicon/robot/R = loc
	var/list/held_modules = R.held_items.Copy()
	var/active_module = R.module_active
	R.uneq_all()
	modules = list()
	for(var/obj/item/I in basic_modules)
		add_module(I, FALSE, FALSE)
	if(R.emagged)
		for(var/obj/item/I in emag_modules)
			add_module(I, FALSE, FALSE)
	if(is_servant_of_ratvar(R) && !R.ratvar)	//It just works :^)
		R.SetRatvar(TRUE, FALSE)
	if(R.ratvar)
		for(var/obj/item/I in ratvar_modules)
			add_module(I, FALSE, FALSE)
	for(var/obj/item/I in added_modules)
		add_module(I, FALSE, FALSE)
	for(var/i in held_modules)
		if(i)
			R.equip_module_to_slot(i, held_modules.Find(i))
	if(active_module)
		R.select_module(held_modules.Find(active_module))
	if(R.hud_used)
		R.hud_used.update_robot_modules_display()

/obj/item/robot_module/proc/transform_to(new_module_type)
	var/mob/living/silicon/robot/R = loc
	var/obj/item/robot_module/RM = new new_module_type(R)
	RM.robot = R
	if(!RM.be_transformed_to(src))
		qdel(RM)
		return
	R.module = RM
	R.update_module_innate()
	RM.rebuild_modules()
	R.radio.recalculateChannels()

	INVOKE_ASYNC(RM, PROC_REF(do_transform_animation))
	qdel(src)
	return RM

/obj/item/robot_module/proc/be_transformed_to(obj/item/robot_module/old_module)
	for(var/i in old_module.added_modules)
		added_modules += i
		old_module.added_modules -= i
	did_feedback = old_module.did_feedback
	return TRUE

/obj/item/robot_module/proc/do_transform_animation()
	var/mob/living/silicon/robot/R = loc
	if(R.hat)
		R.hat.forceMove(get_turf(R))
		R.hat = null
	R.cut_overlays()
	R.setDir(SOUTH)
	do_transform_delay()

/obj/item/robot_module/proc/do_transform_delay()
	var/mob/living/silicon/robot/R = loc
	var/prev_lockcharge = R.lockcharge
	sleep(1)
	flick("[cyborg_base_icon]_transform", R)
	R.notransform = TRUE
	if(locked_transform)
		R.SetLockdown(TRUE)
		R.set_anchored(TRUE)
	R.logevent("Chassis configuration has been set to [name].")
	sleep(1)
	for(var/i in 1 to 4)
		playsound(R, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, TRUE, -1)
		sleep(7)
	R.SetLockdown(prev_lockcharge)
	R.setDir(SOUTH)
	R.set_anchored(FALSE)
	R.notransform = FALSE
	R.updatehealth()
	R.update_icons()
	R.notify_ai(NEW_MODULE)
	if(R.hud_used)
		R.hud_used.update_robot_modules_display()
	SSblackbox.record_feedback("tally", "cyborg_modules", 1, R.module)

/**
 * Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The cyborg mob interacting with the menu
 * * old_module The old cyborg's module
 */
/obj/item/robot_module/proc/check_menu(mob/living/silicon/robot/user, obj/item/robot_module/old_module)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(user.module != old_module)
		return FALSE
	return TRUE

/obj/item/robot_module/medical
	name = "Medical"
	basic_modules = list(
		/obj/item/surgical_drapes,
		/obj/item/retractor/augment,
		/obj/item/hemostat/augment,
		/obj/item/cautery/augment,
		/obj/item/surgicaldrill/augment,
		/obj/item/scalpel/augment,
		/obj/item/circular_saw/augment,
		/obj/item/bonesetter/augment,
		/obj/item/blood_filter/augment,
		/obj/item/breathing_bag,
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/borghypo,
		/obj/item/stack/medical/gauze,
		/obj/item/stack/medical/bone_gel,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/dropper,
		/obj/item/borg/apparatus/beaker,
		/obj/item/organ_storage,
		/obj/item/roller/robo,
		/obj/item/borg/cyborghug/medical,
		/obj/item/borg/lollipop,
		/obj/item/extinguisher/mini,
		/obj/item/assembly/flash/cyborg)
	radio_channels = list(RADIO_CHANNEL_MEDICAL)
	emag_modules = list(/obj/item/reagent_containers/borghypo/hacked)
	ratvar_modules = list(
		/obj/item/clock_module/abscond,
		/obj/item/clock_module/sentinels_compromise,
		/obj/item/clock_module/prosperity_prism,
		/obj/item/clock_module/vanguard)
	cyborg_base_icon = "medical"
	moduleselect_icon = "medical"
	module_traits = list(TRAIT_PUSHIMMUNE)
	hat_offset = 3

/obj/item/robot_module/medical/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/cyborg = loc
	var/list/medical_icons = list(
		"Medical" = image(icon = 'icons/mob/robots.dmi', icon_state = "medical"),
		"Qualified Doctor" = image(icon = 'icons/mob/robots.dmi', icon_state = "qualified_doctor"),
		"Heavysd" = image(icon = 'icons/mob/robots.dmi', icon_state = "heavysd"),
		"Gibbs" = image(icon = 'icons/mob/robots.dmi', icon_state = "gibbs"),
		"Cmoborg" = image(icon = 'icons/mob/robots.dmi', icon_state = "cmoborg")
		)
	var/medical_robot_icon = show_radial_menu(cyborg, cyborg, medical_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), cyborg, old_module), radius = 38, require_near = TRUE)
	switch(medical_robot_icon)
		if("Medical")
			cyborg_base_icon = "medical"
		if("Qualified Doctor")
			cyborg_base_icon = "qualified_doctor"
		if("Heavysd")
			cyborg_base_icon = "heavysd"
		if("Gibbs")
			cyborg_base_icon = "gibbs"
		if("Cmoborg")
			cyborg_base_icon = "cmoborg"
		else
			return FALSE
	return ..()

/obj/item/robot_module/engineering
	name = "Engineering"
	basic_modules = list(
		/obj/item/crowbar/cyborg,
		/obj/item/screwdriver/cyborg,
		/obj/item/wrench/cyborg,
		/obj/item/wirecutters/cyborg,
		/obj/item/weldingtool/largetank/cyborg,
		/obj/item/multitool/cyborg,
		/obj/item/construction/rcd/borg,
		/obj/item/borg/charger,
		/obj/item/pipe_dispenser,
		/obj/item/stack/cable_coil,
		/obj/item/lightreplacer/cyborg,
		/obj/item/holosign_creator/atmos,
		/obj/item/borg/sight/meson,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/geiger_counter/cyborg,
		/obj/item/assembly/signaler/cyborg,
		/obj/item/areaeditor/blueprints/cyborg,
		/obj/item/electroadaptive_pseudocircuit,
		/obj/item/extinguisher,
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/glass,
		/obj/item/stack/sheet/rglass/cyborg,
		/obj/item/stack/rods/cyborg,
		/obj/item/stack/tile/plasteel,
		/obj/item/assembly/flash/cyborg)
	radio_channels = list(RADIO_CHANNEL_ENGINEERING)
	emag_modules = list(/obj/item/borg/stun)
	ratvar_modules = list(
		/obj/item/clock_module/abscond,
		/obj/item/clock_module/ocular_warden,
		/obj/item/clock_module/tinkerers_cache,
		/obj/item/clock_module/stargazer,
		/obj/item/clock_module/abstraction_crystal,
		/obj/item/clockwork/replica_fabricator,
		/obj/item/stack/tile/bronze/cyborg)
	cyborg_base_icon = "engineer"
	moduleselect_icon = "engineer"
	module_traits = list(TRAIT_NEGATES_GRAVITY)
	hat_offset = -4

/obj/item/robot_module/engineering/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/cyborg = loc
	var/list/engineering_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "engineer"),
		"Loader" = image(icon = 'icons/mob/robots.dmi', icon_state = "loaderborg"),
		"Handy" = image(icon = 'icons/mob/robots.dmi', icon_state = "handyeng"),
		"Heavy" = image(icon = 'icons/mob/robots.dmi', icon_state = "heavyeng"),
		"Ceborg" = image(icon = 'icons/mob/robots.dmi', icon_state = "ceborg"),
		"Ceborg" = image(icon = 'icons/mob/robots.dmi', icon_state = "ceborg"),
		"Conagher" = image(icon = 'icons/mob/robots.dmi', icon_state = "conagher")
		)
	var/engineering_robot_icon = show_radial_menu(cyborg, cyborg, engineering_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), cyborg, old_module), radius = 38, require_near = TRUE)
	switch(engineering_robot_icon)
		if("Default")
			cyborg_base_icon = "engineer"
		if("Loader")
			cyborg_base_icon = "loaderborg"
		if("Handy")
			cyborg_base_icon = "handyeng"
		if("Heavy")
			cyborg_base_icon = "heavyeng"
		if("Ceborg")
			cyborg_base_icon = "ceborg"
		if("Conagher")
			cyborg_base_icon = "conagher"
		else
			return FALSE
	return ..()

/obj/item/robot_module/security
	name = "Security"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/restraints/handcuffs/cable/zipties,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/disabler/cyborg,
		/obj/item/clothing/mask/gas/sechailer/cyborg,
		/obj/item/extinguisher/mini)
	radio_channels = list(RADIO_CHANNEL_SECURITY)
	emag_modules = list(/obj/item/gun/energy/laser/cyborg)
	ratvar_modules = list(
		/obj/item/clock_module/abscond,
		/obj/item/clockwork/weapon/brass_spear,
		/obj/item/clock_module/ocular_warden,
		/obj/item/clock_module/vanguard)
	cyborg_base_icon = "sec"
	moduleselect_icon = "security"
	module_traits = list(TRAIT_PUSHIMMUNE)
	hat_offset = 3

/obj/item/robot_module/security/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/cyborg = loc
	var/list/security_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "sec"),
		"Heavy" = image(icon = 'icons/mob/robots.dmi', icon_state = "heavysec"),
		"Eyebot" = image(icon = 'icons/mob/robots.dmi', icon_state = "eyebotsec"),
		"Spider" = image(icon = 'icons/mob/robots.dmi', icon_state = "spidersec"),
		"Sleek" = image(icon = 'icons/mob/robots.dmi', icon_state = "sleeksec"),
		"Hosborg" = image(icon = 'icons/mob/robots.dmi', icon_state = "hosborg"),
		"Woody" = image(icon = 'icons/mob/robots.dmi', icon_state = "woody")
		)
	var/security_robot_icon = show_radial_menu(cyborg, cyborg, security_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), cyborg, old_module), radius = 38, require_near = TRUE)
	switch(security_robot_icon)
		if("Default")
			cyborg_base_icon = "sec"
		if("Heavy")
			cyborg_base_icon = "heavysec"
		if("Eyebot")
			cyborg_base_icon = "eyebotsec"
		if("Spider")
			cyborg_base_icon = "spidersec"
		if("Sleek")
			cyborg_base_icon = "sleeksec"
		if("Hosborg")
			cyborg_base_icon = "hosborg"
		if("Woody")
			cyborg_base_icon = "woody"
		else
			return FALSE
	return ..()

/obj/item/robot_module/security/do_transform_animation()
	..()
	to_chat(loc, "<span class='userdanger'>ВНИМАНИЕ! При своде законов Азимова прежде всего вы предотвращаете насилие к людям, однако это не позволяет \
	вам убивать или наносить тяжелые повреждения не человеческим членам экипажа, легкие повреждения или продолжение боя допустимо если противник \
	склонен к насилию. <BR>Будучи СБ киборгом прежде всего вы действуете согласно вашим системным законам, а не космическому закону. Благодаря последнему мы можете исключительно \
	идентифицировать кого-либо как преступника и расценивать его приказы с особой подозрительностью, соответственно вы так же не можете отпустить \
	преступника на свободу, т.к. это может быть опасно для окружающих.</span>")

/obj/item/robot_module/security/respawn_consumable(mob/living/silicon/robot/R, coeff = 1)
	..()
	var/obj/item/gun/energy/e_gun/advtaser/cyborg/T = locate(/obj/item/gun/energy/e_gun/advtaser/cyborg) in basic_modules
	if(T)
		if(T.cell.charge < T.cell.maxcharge)
			var/obj/item/ammo_casing/energy/S = T.ammo_type[T.select]
			T.cell.give(S.e_cost * coeff)
			T.update_icon()
		else
			T.charge_timer = 0

/obj/item/robot_module/peacekeeper
	name = "Peacekeeper"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/rsf/cookiesynth,
		/obj/item/harmalarm,
		/obj/item/reagent_containers/borghypo/peace,
		/obj/item/holosign_creator/cyborg,
		/obj/item/borg/cyborghug/peacekeeper,
		/obj/item/extinguisher,
		/obj/item/borg/projectile_dampen)
	emag_modules = list(/obj/item/reagent_containers/borghypo/peace/hacked)
	ratvar_modules = list(
		/obj/item/clock_module/abscond,
		/obj/item/clock_module/vanguard,
		/obj/item/clock_module/kindle,
		/obj/item/clock_module/sigil_submission)
	cyborg_base_icon = "peace"
	moduleselect_icon = "standard"
	module_traits = list(TRAIT_PUSHIMMUNE)
	hat_offset = -2

/obj/item/robot_module/peacekeeper/do_transform_animation()
	..()
	to_chat(loc, "<span class='userdanger'>ВНИМАНИЕ! При своде законов Азимова прежде всего вы предотвращаете насилие к людям, однако это не позволяет \
	вам убивать или наносить тяжелые повреждения не человеческим членам экипажа, легкие повреждения или продолжение боя допустимо если противник \
	склонен к насилию. <BR>	Вы не являетесь модулем СБ и прежде всего вы предотвращаете насилие. Космический закон ничего не значит для вас.</span>")

/obj/item/robot_module/janitor
	name = JOB_JANITOR
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/screwdriver/cyborg,
		/obj/item/crowbar/cyborg,
		/obj/item/stack/tile/plasteel,
		/obj/item/soap/nanotrasen,
		/obj/item/storage/bag/trash/cyborg,
		/obj/item/melee/flyswatter,
		/obj/item/extinguisher/mini,
		/obj/item/mop/cyborg,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/paint/paint_remover,
		/obj/item/lightreplacer/cyborg,
		/obj/item/holosign_creator/janibarrier,
		/obj/item/reagent_containers/spray/cyborg_drying,
		/obj/item/stack/sheet/iron,
		/obj/item/stack/cable_coil)
	radio_channels = list(RADIO_CHANNEL_SERVICE)
	emag_modules = list(/obj/item/reagent_containers/spray/cyborg_lube)
	ratvar_modules = list(
		/obj/item/clock_module/abscond,
		/obj/item/clock_module/sigil_submission,
		/obj/item/clock_module/kindle,
		/obj/item/clock_module/vanguard)
	cyborg_base_icon = "janitor"
	moduleselect_icon = "janitor"
	hat_offset = -5
	clean_on_move = TRUE

/obj/item/robot_module/janitor/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/cyborg = loc
	var/list/janitor_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "janitor"),
		"Zoomba" = image(icon = 'icons/mob/robots.dmi', icon_state = "zoomba_jani"),
		"Zoomba_green" = image(icon = 'icons/mob/robots.dmi', icon_state = "zoomba_green"),
		"Zoomba_engi" = image(icon = 'icons/mob/robots.dmi', icon_state = "zoomba_engi"),
		"Flynn" = image(icon = 'icons/mob/robots.dmi', icon_state = "flynn"),
		"Heavy" = image(icon = 'icons/mob/robots.dmi', icon_state = "heavyres")
		)
	var/janitor_robot_icon = show_radial_menu(cyborg, cyborg, janitor_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), cyborg, old_module), radius = 38, require_near = TRUE)
	switch(janitor_robot_icon)
		if("Default")
			cyborg_base_icon = "janitor"
		if("Zoomba")
			cyborg_base_icon = "zoomba_jani" // Ну это же просто уборщик, зачем ему штраф на ХП, у остальных зумба вырезан
			special_light_key = "zoomba_jani_l"
			hat_offset = -13
		if("Zoomba_green")
			cyborg_base_icon = "zoomba_green"
			special_light_key = "zoomba_green_l"
			hat_offset = -13
		if("Zoomba_engi")
			cyborg_base_icon = "zoomba_engi"
			special_light_key = "zoomba_engi_l"
			hat_offset = -13
		if("Flynn")
			cyborg_base_icon = "flynn"
		if("Heavy")
			cyborg_base_icon = "heavyres"
		else
			return FALSE
	return ..()

/obj/item/reagent_containers/spray/cyborg_drying
	name = "drying agent spray"
	color = "#A000A0"
	list_reagents = list(/datum/reagent/drying_agent = 250)

/obj/item/reagent_containers/spray/cyborg_lube
	name = "lube spray"
	list_reagents = list(/datum/reagent/lube = 250)

/obj/item/robot_module/janitor/respawn_consumable(mob/living/silicon/robot/R, coeff = 1)
	..()
	var/obj/item/lightreplacer/LR = locate(/obj/item/lightreplacer) in basic_modules
	if(LR)
		for(var/i in 1 to coeff)
			LR.Charge(R)

	var/obj/item/reagent_containers/spray/cyborg_drying/CD = locate(/obj/item/reagent_containers/spray/cyborg_drying) in basic_modules
	if(CD)
		CD.reagents.add_reagent(/datum/reagent/drying_agent, 5 * coeff)

	var/obj/item/reagent_containers/spray/cyborg_lube/CL = locate(/obj/item/reagent_containers/spray/cyborg_lube) in emag_modules
	if(CL)
		CL.reagents.add_reagent(/datum/reagent/lube, 2 * coeff)

/obj/item/robot_module/clown
	name = JOB_CLOWN
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/toy/crayon/rainbow,
		/obj/item/instrument/bikehorn,
		/obj/item/stamp/clown,
		/obj/item/bikehorn,
		/obj/item/bikehorn/airhorn,
		/obj/item/paint/anycolor,
		/obj/item/soap/nanotrasen,
		/obj/item/pneumatic_cannon/pie/selfcharge/cyborg,
		/obj/item/razor,					//killbait material
		/obj/item/lipstick/purple,
		/obj/item/reagent_containers/spray/waterflower/cyborg,
		/obj/item/borg/cyborghug/peacekeeper,
		/obj/item/borg/lollipop/clown,
		/obj/item/picket_sign/cyborg,
		/obj/item/reagent_containers/borghypo/clown,
		/obj/item/extinguisher/mini)
	emag_modules = list(
		/obj/item/reagent_containers/borghypo/clown/hacked,
		/obj/item/reagent_containers/spray/waterflower/cyborg/hacked)
	ratvar_modules = list(
		/obj/item/clock_module/abscond,
		/obj/item/clock_module/vanguard,
		/obj/item/clockwork/weapon/brass_battlehammer)	//honk
	moduleselect_icon = "service"
	cyborg_base_icon = "clown"
	hat_offset = -2

/obj/item/robot_module/butler
	name = "Service"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/reagent_containers/glass/beaker/large, //I know a shaker is more appropiate but this is for ease of identification
		/obj/item/reagent_containers/food/condiment/enzyme,
		/obj/item/pen,
		/obj/item/toy/crayon/spraycan/borg,
		/obj/item/extinguisher/mini,
		/obj/item/hand_labeler/borg,
		/obj/item/razor,
		/obj/item/rsf,
		/obj/item/instrument/guitar,
		/obj/item/instrument/piano_synth,
		/obj/item/reagent_containers/dropper,
		/obj/item/lighter,
		/obj/item/storage/bag/tray,
		/obj/item/reagent_containers/borghypo/borgshaker,
		/obj/item/borg/lollipop,
		/obj/item/stack/pipe_cleaner_coil/cyborg,
		/obj/item/borg/apparatus/beaker/service)
	radio_channels = list(RADIO_CHANNEL_SERVICE)
	emag_modules = list(/obj/item/reagent_containers/borghypo/borgshaker/hacked)
	ratvar_modules = list(
		/obj/item/clock_module/abscond,
		/obj/item/clock_module/vanguard,
		/obj/item/clock_module/sigil_submission,
		/obj/item/clock_module/kindle,
		/obj/item/clock_module/sentinels_compromise,
		/obj/item/clockwork/replica_fabricator)
	cyborg_base_icon = "service_m" // display as butlerborg for radial model selection
	special_light_key = "service"
	hat_offset = 0

/obj/item/robot_module/butler/respawn_consumable(mob/living/silicon/robot/R, coeff = 1)
	..()
	var/obj/item/reagent_containers/O = locate(/obj/item/reagent_containers/food/condiment/enzyme) in basic_modules
	if(O)
		O.reagents.add_reagent(/datum/reagent/consumable/enzyme, 2 * coeff)

/obj/item/robot_module/butler/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/cyborg = loc
	var/list/service_icons = list(
		"Bro" = image(icon = 'icons/mob/robots.dmi', icon_state = "brobot"),
		"Butler" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_m"),
		"Kent" = image(icon = 'icons/mob/robots.dmi', icon_state = "kent"),
		"Tophat" = image(icon = 'icons/mob/robots.dmi', icon_state = "tophat"),
		"Waitress" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_f"),
		"Old" = image(icon = 'icons/mob/robots.dmi', icon_state = "robot_old"),
		"Heavy" = image(icon = 'icons/mob/robots.dmi', icon_state = "heavyserv"),
		"Lloyd" = image(icon = 'icons/mob/robots.dmi', icon_state = "lloyd"),
		"Handy" = image(icon = 'icons/mob/robots.dmi', icon_state = "handy-service"),
		)
	var/service_robot_icon = show_radial_menu(cyborg, cyborg, service_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), cyborg, old_module), radius = 38, require_near = TRUE)
	switch(service_robot_icon)
		if("Bro")
			cyborg_base_icon = "brobot"
		if("Butler")
			cyborg_base_icon = "service_m"
		if("Kent")
			cyborg_base_icon = "kent"
			special_light_key = "medical"
			hat_offset = 3
		if("Tophat")
			cyborg_base_icon = "tophat"
			special_light_key = null
			hat_offset = INFINITY //He is already wearing a hat
		if("Waitress")
			cyborg_base_icon = "service_f"
		if("Old")
			cyborg_base_icon = "robot_old"
		if("Heavy")
			cyborg_base_icon = "heavyserv"
		if("Lloyd")
			cyborg_base_icon = "lloyd"
		if("Handy")
			cyborg_base_icon = "handy-service"
		else
			return FALSE
	return ..()

/obj/item/robot_module/miner
	name = "Miner"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/borg/sight/meson,
		/obj/item/storage/bag/ore/cyborg,
		/obj/item/pickaxe/drill/cyborg,
		/obj/item/shovel,
		/obj/item/crowbar/cyborg,
		/obj/item/wrench/cyborg,
		/obj/item/weldingtool/mini,
		/obj/item/extinguisher/mini,
		/obj/item/storage/bag/sheetsnatcher/borg,
		/obj/item/gun/energy/kinetic_accelerator/cyborg,
		/obj/item/gps/cyborg,
		/obj/item/stack/marker_beacon)
	radio_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SUPPLY)
	emag_modules = list(/obj/item/borg/stun)
	ratvar_modules = list(
		/obj/item/clock_module/abscond,
		/obj/item/clock_module/vanguard,
		/obj/item/clock_module/ocular_warden,
		/obj/item/clock_module/sentinels_compromise)
	cyborg_base_icon = "miner"
	moduleselect_icon = "miner"
	hat_offset = 0
	var/obj/item/t_scanner/adv_mining_scanner/cyborg/mining_scanner //built in memes.

/obj/item/robot_module/miner/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/cyborg = loc
	var/list/miner_icons = list(
		"Asteroid Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "minerOLD"),
		"Spider Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "spidermin"),
		"Lavaland Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "miner"),
		"Heavy" = image(icon = 'icons/mob/robots.dmi', icon_state = "heavymin"),
		"Ishimura" = image(icon = 'icons/mob/robots.dmi', icon_state = "ishimura"),
		"Drone" = image(icon = 'icons/mob/robots.dmi', icon_state = "miningdrone"),
		)
	var/miner_robot_icon = show_radial_menu(cyborg, cyborg, miner_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), cyborg, old_module), radius = 38, require_near = TRUE)
	switch(miner_robot_icon)
		if("Asteroid Miner")
			cyborg_base_icon = "minerOLD"
			special_light_key = "miner"
		if("Spider Miner")
			cyborg_base_icon = "spidermin"
		if("Lavaland Miner")
			cyborg_base_icon = "miner"
		if("Heavy")
			cyborg_base_icon = "heavymin"
		if("Ishimura")
			cyborg_base_icon = "ishimura"
		if("Drone")
			cyborg_base_icon = "miningdrone"
		else
			return FALSE
	return ..()

/obj/item/robot_module/miner/rebuild_modules()
	. = ..()
	if(!mining_scanner)
		mining_scanner = new(src)

/obj/item/robot_module/miner/Destroy()
	QDEL_NULL(mining_scanner)
	return ..()

/obj/item/robot_module/syndicate
	name = "Syndicate Assault"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/melee/energy/sword/cyborg,
		/obj/item/gun/energy/printer,
		/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg,
		/obj/item/crowbar/cyborg,
		/obj/item/extinguisher/mini,
		/obj/item/pinpointer/syndicate_cyborg)

	cyborg_base_icon = "synd_sec"
	moduleselect_icon = "malf"
	module_traits = list(TRAIT_PUSHIMMUNE)
	hat_offset = 3
/*
/obj/item/robot_module/syndicate/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/cyborg = loc
	var/list/syndie_icons = list(
		"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "synd_sec"),
		"Chesty" = image(icon = 'icons/mob/robots.dmi', icon_state = "chesty"),
		"Heavy" = image(icon = 'icons/mob/robots.dmi', icon_state = "syndieheavy")
		)
	var/syndicate_robot_icon = show_radial_menu(cyborg, cyborg, syndie_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), cyborg, old_module), radius = 38, require_near = TRUE)
	switch(syndicate_robot_icon)
		if("Default")
			cyborg_base_icon = "synd_sec"
		if("Chesty")
			cyborg_base_icon = "chesty"
		if("Heavy")
			cyborg_base_icon = "syndieheavy"
		else
			return FALSE
	return ..()
*/

/obj/item/robot_module/syndicate/rebuild_modules()
	..()
	var/mob/living/silicon/robot/Syndi = loc
	Syndi.faction  -= "silicon" //ai turrets

/obj/item/robot_module/syndicate/remove_module(obj/item/I, delete_after)
	..()
	var/mob/living/silicon/robot/Syndi = loc
	Syndi.faction += "silicon" //ai is your bff now!

/obj/item/robot_module/syndicate_medical
	name = "Syndicate Medical"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/reagent_containers/borghypo/syndicate,
		/obj/item/shockpaddles/syndicate/cyborg,
		/obj/item/healthanalyzer,
		/obj/item/surgical_drapes,
		/obj/item/retractor,
		/obj/item/hemostat,
		/obj/item/cautery,
		/obj/item/surgicaldrill,
		/obj/item/scalpel,
		/obj/item/melee/energy/sword/cyborg/saw,
		/obj/item/roller/robo,
		/obj/item/card/emag,
		/obj/item/crowbar/cyborg,
		/obj/item/extinguisher/mini,
		/obj/item/pinpointer/syndicate_cyborg,
		/obj/item/stack/medical/gauze,
		/obj/item/gun/medbeam,
		/obj/item/organ_storage)

	cyborg_base_icon = "synd_medical"
	moduleselect_icon = "malf"
	module_traits = list(TRAIT_PUSHIMMUNE)
	hat_offset = 3

/obj/item/robot_module/saboteur
	name = "Syndicate Saboteur"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/borg/sight/thermal,
		/obj/item/construction/rcd/borg/syndicate,
		/obj/item/pipe_dispenser,
		/obj/item/restraints/handcuffs/cable/zipties,
		/obj/item/extinguisher,
		/obj/item/weldingtool/largetank/cyborg,
		/obj/item/screwdriver/nuke,
		/obj/item/wrench/cyborg,
		/obj/item/crowbar/cyborg,
		/obj/item/wirecutters/cyborg,
		/obj/item/multitool/cyborg,
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/glass,
		/obj/item/stack/sheet/rglass/cyborg,
		/obj/item/stack/rods/cyborg,
		/obj/item/stack/tile/plasteel,
		/obj/item/dest_tagger/borg,
		/obj/item/stack/cable_coil,
		/obj/item/pinpointer/syndicate_cyborg,
		/obj/item/borg_chameleon,
		/obj/item/card/emag,
		)

	cyborg_base_icon = "synd_engi"
	moduleselect_icon = "malf"
	module_traits = list(TRAIT_PUSHIMMUNE, TRAIT_NEGATES_GRAVITY)
	hat_offset = -4
	canDispose = TRUE

/obj/item/robot_module/syndicate/kiltborg
	name = "Highlander"
	basic_modules = list(
		/obj/item/claymore/highlander/robot,
		/obj/item/pinpointer/nuke,)
	moduleselect_icon = "kilt"
	cyborg_base_icon = "kilt"
	hat_offset = -2
	breakable_modules = FALSE
	locked_transform = FALSE //GO GO QUICKLY AND SLAUGHTER THEM ALL

/obj/item/robot_module/syndicate/kiltborg/be_transformed_to(obj/item/robot_module/old_module)
	. = ..()
	qdel(robot.radio)
	robot.radio = new /obj/item/radio/borg/syndicate(robot)
	robot.scrambledcodes = TRUE
	robot.maxHealth = 50 //DIE IN THREE HITS, LIKE A REAL SCOT
	robot.break_cyborg_slot(3) //YOU ONLY HAVE TWO ITEMS ANYWAY
	var/obj/item/pinpointer/nuke/diskyfinder = locate(/obj/item/pinpointer/nuke) in basic_modules
	diskyfinder.attack_self(robot)

/obj/item/robot_module/syndicate/kiltborg/do_transform_delay() //AUTO-EQUIPPING THESE TOOLS ANY EARLIER CAUSES RUNTIMES OH YEAH
	. = ..()
	robot.equip_module_to_slot(locate(/obj/item/claymore/highlander/robot) in basic_modules, 1)
	robot.equip_module_to_slot(locate(/obj/item/pinpointer/nuke) in basic_modules, 2)
	robot.place_on_head(new /obj/item/clothing/head/beret/highlander(robot)) //THE ONLY PART MORE IMPORTANT THAN THE SWORD IS THE HAT
	ADD_TRAIT(robot.hat, TRAIT_NODROP, HIGHLANDER)

/datum/robot_energy_storage
	var/name = "Generic energy storage"
	var/max_energy = 30000
	var/recharge_rate = 1000
	var/energy

/datum/robot_energy_storage/New(obj/item/robot_module/R = null)
	energy = max_energy
	if(R)
		R.storages |= src
	return

/datum/robot_energy_storage/proc/use_charge(amount)
	if (energy >= amount)
		energy -= amount
		if (energy == 0)
			return 1
		return 2
	else
		return 0

/datum/robot_energy_storage/proc/add_charge(amount)
	energy = min(energy + amount, max_energy)

/datum/robot_energy_storage/iron
	name = "Iron Synthesizer"

/datum/robot_energy_storage/glass
	name = "Glass Synthesizer"

/datum/robot_energy_storage/bronze
	name = "Brass Synthesizer"

/datum/robot_energy_storage/wire
	max_energy = 50
	recharge_rate = 2
	name = "Wire Synthesizer"

/datum/robot_energy_storage/medical
	max_energy = 2500
	recharge_rate = 250
	name = "Medical Synthesizer"

/datum/robot_energy_storage/beacon
	max_energy = 30
	recharge_rate = 1
	name = "Marker Beacon Storage"

/datum/robot_energy_storage/pipe_cleaner
	max_energy = 50
	recharge_rate = 2
	name = "Pipe Cleaner Synthesizer"
