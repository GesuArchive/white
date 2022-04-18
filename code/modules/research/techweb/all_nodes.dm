
//Current rate: 135000 research points in 90 minutes

//Base Nodes
/datum/techweb_node/base
	id = "base"
	starting_node = TRUE
	display_name = "Basic Research Technology"
	description = "NT default research technologies."
	// Default research tech, prevents bricking
	design_ids = list(
		"basic_capacitor",
		"basic_scanning",
		"micro_mani",
		"basic_micro_laser",
		"basic_matter_bin",
		"basic_cell",
		"basic_capacitor_x10",
		"basic_scanning_x10",
		"micro_mani_x10",
		"basic_micro_laser_x10",
		"basic_matter_bin_x10",
		"plasteel",
		"plastitanium",
		"rglass",
		"plasmaglass",
		"plasmareinforcedglass",
		"titaniumglass",
		"plastitaniumglass",
		"plasteel_x10",
		"plastitanium_x10",
		"rglass_x10",
		"plasmaglass_x10",
		"plasmareinforcedglass_x10",
		"titaniumglass_x10",
		"plastitaniumglass_x10",
		"bepis",
		"bucket",
		"c-reader",
		"circuit_imprinter",
//		"circuit_imprinter_offstation",
		"conveyor_belt",
		"conveyor_switch",
		"design_disk",
		"destructive_analyzer",
		"destructive_scanner",
		"desttagger",
		"doppler_array",
		"experi_scanner",
		"experimentor",
		"mechfab",
		"packagewrap",
		"plastic_fork",
		"plastic_knife",
		"plastic_spoon",
		"rdconsole",
		"rdserver",
		"rdservercontrol",
		"restaurant_portal",
		"salestagger",
		"sec_38",
		"sec_Islug",
		"sec_beanbag_slug",
		"sec_dart",
		"sec_rshot",
		"space_heater",
		"tech_disk",
		"gas_filter",
		"plasmaman_gas_filter",
		"oven_tray"
	)

/datum/techweb_node/basic_medical
	id = "basic_medical"
	starting_node = TRUE
	display_name = "Basic Medical Equipment"
	description = "Basic medical tools and equipment."
	design_ids = list("cybernetic_liver", "cybernetic_heart", "cybernetic_lungs", "cybernetic_stomach", "scalpel", "circular_saw",
					"hemostat", "retractor", "cautery", "bonesetter", "surgicaldrill", "blood_filter",
					"beaker", "large_beaker", "xlarge_beaker", "syringe", "health_sensor", "portable_chem_mixer", "stethoscope", "surgical_drapes", "plumbing_rcd",
					"dropper", "defibmountdefault", "surgical_tape", "glasses_prescription",
					"robot_low_arm_left", "robot_low_arm_right", "robot_low_leg_left", "robot_low_leg_right", "teeth_box_32",
					"body_bag", "fluid_ducts", "optable_folding", "pillbottle", "pill_bottle_big", "rollerbed")

/datum/techweb_node/mmi
	id = "mmi"
	starting_node = TRUE
	display_name = "Man Machine Interface"
	description = "A slightly Frankensteinian device that allows human brains to interface natively with software APIs."
	design_ids = list("mmi")

/datum/techweb_node/cyborg
	id = "cyborg"
	starting_node = TRUE
	display_name = "Cyborg Construction"
	description = "Sapient robots with preloaded tool modules and programmable laws."
	design_ids = list("robocontrol", "sflash", "borg_suit", "borg_head", "borg_chest", "borg_r_arm", "borg_l_arm", "borg_r_leg", "borg_l_leg", "borgupload",
					"cyborgrecharger", "borg_upgrade_restart", "borg_upgrade_rename")

/datum/techweb_node/mech
	id = "mecha"
	starting_node = TRUE
	display_name = "Mechanical Exosuits"
	description = "Mechanized exosuits that are several magnitudes stronger and more powerful than the average human."
	design_ids = list("mecha_tracking", "mechacontrol", "mechapower", "mech_recharger", "ripley_chassis", "ripley_torso", "ripley_left_arm",
					"ripley_right_arm", "ripley_left_leg", "ripley_right_leg", "ripley_main", "ripley_peri", "ripleyupgrade", "mech_hydraulic_clamp")

/datum/techweb_node/mech_tools
	id = "mech_tools"
	starting_node = TRUE
	display_name = "Basic Exosuit Equipment"
	description = "Various tools fit for basic mech units"
	design_ids = list("mech_drill", "mech_mscanner", "mech_extinguisher")

/datum/techweb_node/basic_tools
	id = "basic_tools"
	starting_node = TRUE
	display_name = "Basic Tools"
	description = "Basic mechanical, electronic, surgical and botanical tools."
	design_ids = list("screwdriver", "wrench", "wirecutters", "crowbar", "multitool", "welding_tool", "tscanner", "analyzer", "cable_coil", "pipe_painter", "airlock_painter", "decal_painter",
					"cultivator", "plant_analyzer", "shovel", "spade", "floor_painter", "hatchet", "secateurs", "mop", "pushbroom", "plunger", "spraycan", "swab", "petri_dish", "normtrash", "handlabel", "paystand",
					"cable_coil_box", "rcd_ammo", "rcd_ammo_large",	"welding_helmet", "prox_sensor", "prox_sensor2", "igniter", "condenser", "signaler", "radio_headset", "bounced_radio", "intercom_frame", "infrared_emitter",
					"timer", "voice_analyser", "light_tube", "light_bulb", "camera_assembly", "newscaster_frame", "large_welding_tool", "geigercounter", "turret_control","blast",
					"laptop", "tablet")

/datum/techweb_node/basic_circuitry
	id = "basic_circuitry"
	starting_node = TRUE
	display_name = "Basic Integrated Circuits"
	description = "Research on how to fully exploit the power of integrated circuits"
	design_ids = list(
		"circuit_multitool",
		"comp_arithmetic",
		"comp_clock",
		"comp_comparison",
		"comp_concat",
		"comp_concat_list",
		"comp_delay",
		"comp_direction",
		"comp_filter_list",
		"comp_foreach",
		"comp_get_column",
		"comp_gps",
		"comp_health",
		"comp_hear",
		"comp_index",
		"comp_index_assoc",
		"comp_index_table",
		"comp_length",
		"comp_laserpointer",
		"comp_light",
		"comp_list_literal",
		"comp_logic",
		"comp_mmi",
		"comp_module",
		"comp_multiplexer",
		"comp_not",
		"comp_ntnet_receive",
		"comp_ntnet_send",
		"comp_pinpointer",
		"comp_pressuresensor",
		"comp_radio",
		"comp_random",
		"comp_router",
		"comp_select_query",
		"comp_self",
		"comp_soundemitter",
		"comp_species",
		"comp_speech",
		"comp_speech",
		"comp_split",
		"comp_string_contains",
		"comp_tempsensor",
		"comp_textcase",
		"comp_timepiece",
		"comp_tonumber",
		"comp_tostring",
		"comp_typecast",
		"comp_typecheck",
		"compact_remote_shell",
		"component_printer",
		"integrated_circuit",
		"module_duplicator",
		"usb_cable",
	)
/////////////////////////Biotech/////////////////////////

/datum/techweb_node/biotech
	id = "biotech"
	display_name = "Биотехнологии"
	description = "То, что заставляет сердце биться."	//the MC, silly!
	prereq_ids = list("base")
	design_ids = list("chem_heater", "chem_master", "chem_dispenser", "pandemic", "defibrillator", "defibmount", "operating", "soda_dispenser", "beer_dispenser", "healthanalyzer", "medigel","genescanner", "med_spray_bottle", "meta_beaker", "chem_pack", "blood_pack", "medical_kiosk", "crewpinpointerprox", "medipen_refiller", "biopsy_tool", "plumbing_rcd_sci", "medbot_carrier", "medipenal")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	required_experiments = list(/datum/experiment/scanning/points/slime/calibration)

/datum/techweb_node/adv_biotech
	id = "adv_biotech"
	display_name = "Продвинутые Биотехнологии"
	description = "Расширят границы познания."
	prereq_ids = list("biotech")
	design_ids = list("piercesyringe", "crewpinpointer", "smoke_machine", "plasmarefiller", "limbgrower", "healthanalyzer_advanced", "harvester", "holobarrier_med", "detective_scanner", "defibrillator_compact", "ph_meter")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	required_experiments = list(/datum/experiment/scanning/points/slime/easy)
	discount_experiments = list(/datum/experiment/scanning/random/material/meat = 4000) //Big discount to reinforce doing it.

/datum/techweb_node/xenoorgan_biotech
	id = "xenoorgan_bio"
	display_name = "Ксено-органы"
	description = "Органы характерные для Фелинидов, Ящеров, Плазменов и Этериалов"
	prereq_ids = list("biotech", "cyber_organs")
	design_ids = list("limbdesign_felinid", "limbdesign_lizard", "limbdesign_plasmaman", "limbdesign_ethereal")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 6500)
	discount_experiments = list(/datum/experiment/scanning/random/cytology/easy = 1000, /datum/experiment/scanning/points/slime/expert = 5000)

/datum/techweb_node/bio_process
	id = "bio_process"
	display_name = "Биологическая обработка"
	description = "От слаймов до кухни."
	prereq_ids = list("biotech")
	design_ids = list("smartfridge", "gibber", "deepfryer", "monkey_recycler", "processor", "gibber", "microwave", "reagentgrinder", "dish_drive", "fat_sucker", "griddle")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 4000)
	discount_experiments = list(/datum/experiment/scanning/random/cytology = 3000) //Big discount to reinforce doing it.

/////////////////////////Advanced Surgery/////////////////////////

/datum/techweb_node/imp_wt_surgery
	id = "imp_wt_surgery"
	display_name = "Улучшенная Травматологическая Хирургия"
	description = "Удивительно, но оказывается, что надежно зафиксированный пациент более не нуждается в анестезии!"
	prereq_ids = list("biotech")
	design_ids = list("surgery_heal_brute_upgrade","surgery_heal_burn_upgrade","surgery_toxin_heal_toxin_upgrade")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)


/datum/techweb_node/adv_surgery
	id = "adv_surgery"
	display_name = "Продвинутая Хирургия"
	description = "Не бывает лишних органов, есть только их недостаточное количество..."
	prereq_ids = list("imp_wt_surgery")
	design_ids = list("surgery_lobotomy", "surgery_heal_brute_upgrade_femto", "surgery_heal_burn_upgrade_femto","surgery_heal_combo", "surgery_toxin_heal_toxin_upgrade_femto","surgery_wing_reconstruction")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1500)

/datum/techweb_node/exp_surgery
	id = "exp_surgery"
	display_name = "Экспериментальная Хирургия"
	description = "Когда природная эволюция не поспевает за прогрессом."
	prereq_ids = list("adv_surgery")
	design_ids = list("surgery_pacify","surgery_vein_thread","surgery_muscled_veins","surgery_nerve_splice","surgery_nerve_ground","surgery_ligament_hook","surgery_ligament_reinforcement","surgery_cortex_imprint","surgery_cortex_folding","surgery_viral_bond", "surgery_heal_combo_upgrade", "organdoc")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)
	discount_experiments = list(/datum/experiment/scanning/random/plants/traits = 4500)

/datum/techweb_node/alien_surgery
	id = "alien_surgery"
	display_name = "Инопланетная Хирургия"
	description = "Похитители ни в чем не виноваты!"
	prereq_ids = list("exp_surgery", "alientech")
	design_ids = list("surgery_brainwashing","surgery_zombie","surgery_heal_combo_upgrade_femto")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/////////////////////////data theory tech/////////////////////////

/datum/techweb_node/datatheory //Computer science
	id = "datatheory"
	display_name = "Data Theory"
	description = "Big Data, in space!"
	prereq_ids = list("base")
	design_ids = list("bounty_pad","bounty_pad_control","price_controller")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)


/////////////////////////engineering tech/////////////////////////

/datum/techweb_node/engineering
	id = "engineering"
	display_name = "Industrial Engineering"
	description = "A refresher course on modern engineering technology."
	prereq_ids = list("base")
	design_ids = list("solarcontrol", "recharger", "powermonitor", "rped", "pacman", "adv_capacitor", "adv_scanning", "nano_mani", "high_micro_laser", "adv_matter_bin", "adv_capacitor_x10", "adv_scanning_x10", "nano_mani_x10", "high_micro_laser_x10", "adv_matter_bin_x10", "w-recycler" , "emitter", "high_cell", "scanner_gate",
	"atmosalerts", "atmos_control", "recycler", "autolathe", "mesons", "welding_goggles", "thermomachine", "rad_collector", "tesla_coil", "grounding_rod",
	"apc_control", "cell_charger", "power control", "airlock_board", "firelock_board", "airalarm_electronics", "firealarm_electronics", "cell_charger", "stack_console", "stack_machine",
	"oxygen_tank", "plasma_tank", "emergency_oxygen", "emergency_oxygen_engi", "plasmaman_tank_belt", "electrolyzer", "pneumatic_seal", "crystallizer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 12500)
	discount_experiments = list(/datum/experiment/scanning/random/material/easy = 7500)

/datum/techweb_node/adv_engi
	id = "adv_engi"
	display_name = "Advanced Engineering"
	description = "Pushing the boundaries of physics, one chainsaw-fist at a time."
	prereq_ids = list("engineering", "emp_basic")
	design_ids = list("engine_goggles", "magboots", "forcefield_projector", "weldingmask", "rcd_loaded", "rpd_loaded", "sheetifier", "HFR_core", "HFR_fuel_input",
	"HFR_waste_output", "HFR_moderator_input", "HFR_corner", "HFR_interface")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/random/material/medium/one = 4000)

/datum/techweb_node/anomaly
	id = "anomaly_research"
	display_name = "Anomaly Research"
	description = "Unlock the potential of the mysterious anomalies that appear on station."
	prereq_ids = list("adv_engi", "practical_bluespace")
	design_ids = list("reactive_armour", "anomaly_neutralizer", "crystal_stabilizer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/high_efficiency
	id = "high_efficiency"
	display_name = "High Efficiency Parts"
	description = "Finely-tooled manufacturing techniques allowing for picometer-perfect precision levels."
	prereq_ids = list("engineering", "datatheory")
	design_ids = list("pico_mani", "super_matter_bin", "pico_mani_x10", "super_matter_bin_x10")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier2_lathes = 5000)

/datum/techweb_node/adv_power
	id = "adv_power"
	display_name = "Продвинутые силовые технологии"
	description = "Как можно получить больше искр?"
	prereq_ids = list("engineering")
	design_ids = list("smes", "super_cell", "hyper_cell", "super_capacitor", "super_capacitor_x10", "superpacman", "mrspacman", "power_turbine", "power_turbine_console", "power_compressor", "circulator", "teg")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3500)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_capacitors = 2500)

/////////////////////////Bluespace tech/////////////////////////
/datum/techweb_node/bluespace_basic //Bluespace-memery
	id = "bluespace_basic"
	display_name = "Basic Bluespace Theory"
	description = "Basic studies into the mysterious alternate dimension known as bluespace."
	prereq_ids = list("base")
	design_ids = list("beacon", "xenobioconsole", "telesci_gps", "bluespace_crystal")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/bluespace_travel
	id = "bluespace_travel"
	display_name = "Bluespace Travel"
	description = "Application of Bluespace for static teleportation technology."
	prereq_ids = list("practical_bluespace")
	design_ids = list("tele_station", "tele_hub", "teleconsole", "quantumpad", "launchpad", "launchpad_console", "bluespace_pod")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_bluespacemachines = 4000)

/datum/techweb_node/micro_bluespace
	id = "micro_bluespace"
	display_name = "Miniaturized Bluespace Research"
	description = "Extreme reduction in space required for bluespace engines, leading to portable bluespace technology."
	prereq_ids = list("bluespace_travel", "practical_bluespace", "high_efficiency")
	design_ids = list("triphasic_scanning", "femto_mani", "bluespace_matter_bin", "triphasic_scanning_x10", "femto_mani_x10", "bluespace_matter_bin_x10", "bluespacebodybag", "quantum_keycard", "wormholeprojector", "swapper")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_variety = 5000)
		/* /datum/experiment/exploration_scan/random/condition) this should have a point cost but im not even sure the experiment works properly lmao*/

/datum/techweb_node/advanced_bluespace
	id = "bluespace_storage"
	display_name = "Advanced Bluespace Storage"
	description = "With the use of bluespace we can create even more advanced storage devices than we could have ever done"
	prereq_ids = list("micro_bluespace", "janitor")
	design_ids = list("bag_holding")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/practical_bluespace
	id = "practical_bluespace"
	display_name = "Applied Bluespace Research"
	description = "Using bluespace to make things faster and better."
	prereq_ids = list("bluespace_basic", "engineering")
	design_ids = list("bs_rped","minerbag_holding", "bluespacebeaker", "bluespacesyringe", "phasic_scanning", "phasic_scanning_x10", "roastingstick", "ore_silo", "plumbing_receiver")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_scanmodules = 3500)

/datum/techweb_node/bluespace_power
	id = "bluespace_power"
	display_name = "Bluespace Power Technology"
	description = "Even more powerful.. power!"
	prereq_ids = list("adv_power", "practical_bluespace")
	design_ids = list("bluespace_cell", "quadratic_capacitor", "quadratic_capacitor_x10")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_pinpoint_scan/tier3_cells = 3000)

/datum/techweb_node/unregulated_bluespace
	id = "unregulated_bluespace"
	display_name = "Unregulated Bluespace Research"
	description = "Bluespace technology using unstable or unbalanced procedures, prone to damaging the fabric of bluespace. Outlawed by galactic conventions."
	prereq_ids = list("bluespace_travel", "syndicate_basic")
	design_ids = list("desynchronizer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

///////////////////////// Неевклидовые детали /////////////////////////
/datum/techweb_node/noneuclidic
	id = "noneuclidic"
	display_name = "Неевклидовые исследования"
	description = "Эксперименты в области технологий блюспейса привели к открытию неевклидовых законов физики."
	prereq_ids = list("bluespace_travel", "practical_bluespace", "bluespace_storage")
	design_ids = list("noneuclid_capacitor", "noneuclid_scanning", "noneuclid_mani", "noneuclid_micro_laser", "noneuclid_matter_bin", "noneuclid_capacitor_x10", "noneuclid_scanning_x10", "noneuclid_mani_x10", "noneuclid_micro_laser_x10", "noneuclid_matter_bin_x10")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 250000)
	required_experiments = list(/datum/experiment/explosion/maxcap)
	discount_experiments = list(/datum/experiment/explosion/medium = 500000)

/////////////////////////plasma tech/////////////////////////
/datum/techweb_node/basic_plasma
	id = "basic_plasma"
	display_name = "Basic Plasma Research"
	description = "Research into the mysterious and dangerous substance, plasma."
	prereq_ids = list("engineering")
	design_ids = list("mech_generator")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_plasma
	id = "adv_plasma"
	display_name = "Advanced Plasma Research"
	description = "Research on how to fully exploit the power of plasma."
	prereq_ids = list("basic_plasma")
	design_ids = list("mech_plasma_cutter")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/////////////////////////integrated circuits tech/////////////////////////

/datum/techweb_node/adv_shells
	id = "adv_shells"
	display_name = "Advanced Shell Research"
	description = "Grants access to more complicated shell designs."
	prereq_ids = list("basic_circuitry", "engineering")
	design_ids = list(
		"bot_shell",
		"controller_shell",
		"dispenser_shell",
		"door_shell",
		"gun_shell",
		"money_bot_shell",
		"scanner_shell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/bci_shells
	id = "bci_shells"
	display_name = "Brain-Computer Interfaces"
	description = "Grants access to biocompatable shell designs and components."
	prereq_ids = list("adv_shells")
	design_ids = list(
		"bci_implanter",
		"bci_shell",
		"comp_bar_overlay",
		"comp_bci_action",
		"comp_target_intercept",
		"comp_counter_overlay",
		"comp_object_overlay",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 500)

/datum/techweb_node/movable_shells_tech
	id = "movable_shells"
	display_name = "Movable Shell Research"
	description = "Grants access to movable shells."
	prereq_ids = list("adv_shells", "robotics")
	design_ids = list(
		"comp_pathfind",
		"comp_pull",
		"drone_shell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/datum/techweb_node/server_shell_tech
	id = "server_shell"
	display_name = "Server Technology Research"
	description = "Grants access to a server shell that has a very high capacity for components."
	prereq_ids = list("adv_shells", "computer_hardware_basic")
	design_ids = list("server_shell")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/////////////////////////robotics tech/////////////////////////
/datum/techweb_node/robotics
	id = "robotics"
	display_name = "Базовое исследование робототехники"
	description = "Программируемые машины, что делают нашу жизнь проще."
	prereq_ids = list("base")
	design_ids = list("paicard")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_robotics
	id = "adv_robotics"
	display_name = "Продвинутое исследование робототехники"
	description = "Машины, использующие нейронные сети для имитации человеческого поведения."
	prereq_ids = list("neural_programming", "robotics")
	design_ids = list("mmi_posi")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/exodrone_tech
	id = "exodrone"
	display_name = "Exploration Drone Research"
	description = "Technology for exploring far away locations."
	prereq_ids = list("robotics")
	design_ids = list("exodrone_console","exoscanner_console","exoscanner","exodrone_launcher")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/neural_programming
	id = "neural_programming"
	display_name = "Нейронное программирование"
	description = "Изучение объединенной сети процессоров, которые имитируют наш мозг."
	prereq_ids = list("biotech", "datatheory")
	design_ids = list("skill_station")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/cyborg_upg_util
	id = "cyborg_upg_util"
	display_name = "Модернизация киборгов: Утилитарные"
	description = "Utility upgrades for cyborgs."
	prereq_ids = list("adv_robotics")
	design_ids = list("borg_upgrade_thrusters", "borg_upgrade_selfrepair", "borg_upgrade_expand", "borg_upgrade_disablercooler", "borg_upgrade_trashofholding", "borg_upgrade_advancedmop", "borg_upgrade_broomer", "borg_upgrade_prt")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/cyborg_upg_engiminer
	id = "cyborg_upg_engiminer"
	display_name = "Модернизация киборгов: Шахтер и Инженер"
	description = "Модернизации для строительства и добычи ресурсов."
	prereq_ids = list("adv_engi", "basic_mining")
	design_ids = list("borg_upgrade_rped", "borg_upgrade_circuitapp", "borg_upgrade_diamonddrill", "borg_upgrade_lavaproof", "borg_upgrade_holding")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/cyborg_upg_med
	id = "cyborg_upg_med"
	display_name = "Модернизация киборгов: Медик"
	description = "Модернизации для оказания медицинской помощи в более эффективном диапазоне."
	prereq_ids = list("adv_biotech")
	design_ids = list("borg_upgrade_defibrillator", "borg_upgrade_piercinghypospray", "borg_upgrade_expandedsynthesiser", "borg_upgrade_pinpointer", "borg_upgrade_surgicalprocessor", "borg_upgrade_beakerapp")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/ai
	id = "ai"
	display_name = "Artificial Intelligence"
	description = "AI unit research."
	prereq_ids = list("adv_robotics")
	design_ids = list("aifixer", "aicore", "safeguard_module", "onehuman_module", "protectstation_module", "quarantine_module", "oxygen_module", "freeform_module",
	"reset_module", "purge_module", "remove_module", "freeformcore_module", "asimov_module", "paladin_module", "tyrant_module", "overlord_module", "corporate_module",
	"default_module", "borg_ai_control", "mecha_tracking_ai_control", "aiupload", "intellicard")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/////////////////////////EMP tech/////////////////////////
/datum/techweb_node/emp_basic //EMP tech for some reason
	id = "emp_basic"
	display_name = "Electromagnetic Theory"
	description = "Study into usage of frequencies in the electromagnetic spectrum."
	prereq_ids = list("base")
	design_ids = list("holosign", "holosignsec", "holosignengi", "holosignatmos", "inducer", "tray_goggles", "holopad", "vendatray")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/emp_adv
	id = "emp_adv"
	display_name = "Advanced Electromagnetic Theory"
	description = "Determining whether reversing the polarity will actually help in a given situation."
	prereq_ids = list("emp_basic")
	design_ids = list("ultra_micro_laser", "ultra_micro_laser_x10")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_microlaser = 1500)

/datum/techweb_node/emp_super
	id = "emp_super"
	display_name = "Quantum Electromagnetic Technology"	//bs
	description = "Even better electromagnetic technology."
	prereq_ids = list("emp_adv")
	design_ids = list("quadultra_micro_laser", "quadultra_micro_laser_x10")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_pinpoint_scan/tier3_microlaser = 4000)

/////////////////////////Clown tech/////////////////////////
/datum/techweb_node/clown
	id = "clown"
	display_name = "Clown Technology"
	description = "Honk?!"
	prereq_ids = list("base")
	design_ids = list("air_horn", "honker_main", "honker_peri", "honker_targ", "honk_chassis", "honk_head", "honk_torso", "honk_left_arm", "honk_right_arm",
	"honk_left_leg", "honk_right_leg", "mech_banana_mortar", "mech_mousetrap_mortar", "mech_honker", "mech_punching_face", "implant_trombone", "borg_transform_clown")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

////////////////////////Computer tech////////////////////////
/datum/techweb_node/comptech
	id = "comptech"
	display_name = "Computer Consoles"
	description = "Computers and how they work."
	prereq_ids = list("datatheory")
	design_ids = list("cargo", "cargorequest", "libraryconsole", "mining", "crewconsole", "rdcamera", "comconsole", "idcard", "seccamera")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/computer_hardware_basic				//Modular computers are shitty and nearly useless so until someone makes them actually useful this can be easy to get.
	id = "computer_hardware_basic"
	display_name = "Computer Hardware"
	description = "How computer hardware are made."
	prereq_ids = list("comptech")
	design_ids = list("hdd_basic", "hdd_advanced", "hdd_super", "hdd_cluster", "ssd_small", "ssd_micro", "netcard_basic", "netcard_advanced", "netcard_wired",
	"portadrive_basic", "portadrive_advanced", "portadrive_super", "cardslot", "aislot", "miniprinter", "APClink", "bat_control", "bat_normal", "bat_advanced",
	"bat_super", "bat_micro", "bat_nano", "cpu_normal", "pcpu_normal", "cpu_small", "pcpu_small", "sensorpackage", "signalpackage")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)  //they are really shitty

/datum/techweb_node/computer_board_gaming
	id = "computer_board_gaming"
	display_name = "Arcade Games"
	description = "For the slackers on the station."
	prereq_ids = list("comptech")
	design_ids = list("arcade_battle", "arcade_orion", "slotmachine")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3250)
	discount_experiments = list(/datum/experiment/physical/arcade_winner = 3000)

/datum/techweb_node/comp_recordkeeping
	id = "comp_recordkeeping"
	display_name = "Computerized Recordkeeping"
	description = "Organized record databases and how they're used."
	prereq_ids = list("comptech")
	design_ids = list("secdata", "med_data", "prisonmanage", "vendor", "automated_announcement", "accounting")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/telecomms
	id = "telecomms"
	display_name = "Telecommunications Technology"
	description = "Subspace transmission technology for near-instant communications devices."
	prereq_ids = list("comptech", "bluespace_basic")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	design_ids = list("s-receiver", "s-bus", "s-broadcaster", "s-processor", "s-hub", "s-server", "s-relay", "comm_monitor", "comm_server",
	"s-ansible", "s-filter", "s-amplifier", "ntnet_relay", "s-treatment", "s-analyzer", "s-crystal", "s-transmitter", "s-messaging")

/datum/techweb_node/integrated_hud
	id = "integrated_HUDs"
	display_name = "Integrated HUDs"
	description = "The usefulness of computerized records, projected straight onto your eyepiece!"
	prereq_ids = list("comp_recordkeeping", "emp_basic")
	design_ids = list("health_hud", "security_hud", "diagnostic_hud", "scigoggles")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1500)

/datum/techweb_node/nvg_tech
	id = "NVGtech"
	display_name = "Night Vision Technology"
	description = "Allows seeing in the dark without actual light!"
	prereq_ids = list("integrated_HUDs", "adv_engi", "emp_adv")
	design_ids = list("health_hud_night", "security_hud_night", "diagnostic_hud_night", "night_visision_goggles", "nvgmesons")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

////////////////////////Medical////////////////////////
/datum/techweb_node/genetics
	id = "genetics"
	display_name = "Genetic Engineering"
	description = "We have the technology to change him."
	prereq_ids = list("biotech")
	design_ids = list("dnascanner", "scan_console", "dna_disk")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/cryotech
	id = "cryotech"
	display_name = "Cryostasis Technology"
	description = "Smart freezing of objects to preserve them!"
	prereq_ids = list("adv_engi", "biotech")
	design_ids = list("splitbeaker", "cryotube", "cryo_Grenade", "stasis")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/subdermal_implants
	id = "subdermal_implants"
	display_name = "Subdermal Implants"
	description = "Electronic implants buried beneath the skin."
	prereq_ids = list("biotech")
	design_ids = list("implanter", "implantcase", "implant_chem", "implant_tracking", "locator", "c38_trac")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/cyber_organs
	id = "cyber_organs"
	display_name = "Cybernetic Organs"
	description = "We have the technology to rebuild him."
	prereq_ids = list("biotech")
	design_ids = list("cybernetic_ears", "cybernetic_heart_tier2", "cybernetic_liver_tier2", "cybernetic_lungs_tier2", "cybernetic_stomach_tier2")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/cyber_organs_upgraded
	id = "cyber_organs_upgraded"
	display_name = "Upgraded Cybernetic Organs"
	description = "We have the technology to upgrade him."
	prereq_ids = list("adv_biotech", "cyber_organs")
	design_ids = list("cybernetic_ears_u", "cybernetic_heart_tier3", "cybernetic_liver_tier3", "cybernetic_lungs_tier3", "cybernetic_stomach_tier3")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1500)

/datum/techweb_node/cyber_implants
	id = "cyber_implants"
	display_name = "Cybernetic Implants"
	description = "Electronic implants that improve humans."
	prereq_ids = list("adv_biotech", "datatheory")
	design_ids = list("ci-nutriment", "ci-breather", "ci-gloweyes", "ci-welding", "ci-medhud", "ci-sechud", "ci-diaghud")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_cyber_implants
	id = "adv_cyber_implants"
	display_name = "Advanced Cybernetic Implants"
	description = "Upgraded and more powerful cybernetic implants."
	prereq_ids = list("neural_programming", "cyber_implants","integrated_HUDs")
	design_ids = list("ci-toolset", "ci-surgery", "ci-reviver", "ci-nutrimentplus")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/combat_cyber_implants
	id = "combat_cyber_implants"
	display_name = "Combat Cybernetic Implants"
	description = "Military grade combat implants to improve performance."
	prereq_ids = list("adv_cyber_implants","weaponry","NVGtech","high_efficiency")
	design_ids = list("ci-xray", "ci-thermals", "ci-antidrop", "ci-antistun", "ci-thrusters")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

////////////////////////Tools////////////////////////

/datum/techweb_node/basic_mining
	id = "basic_mining"
	display_name = "Mining Technology"
	description = "Better than Efficiency V."
	prereq_ids = list("engineering", "basic_plasma")
	design_ids = list("drill", "superresonator", "triggermod", "damagemod", "cooldownmod", "rangemod", "ore_redemption", "mining_equipment_vendor", "exploration_equipment_vendor", "cargoexpress", "plasmacutter", "mecha_kineticgun")//e a r l y    g a  m e)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_mining
	id = "adv_mining"
	display_name = "Advanced Mining Technology"
	description = "Efficiency Level 127"	//dumb mc references
	prereq_ids = list("basic_mining", "adv_engi", "adv_power", "adv_plasma")
	design_ids = list("drill_diamond", "jackhammer", "hypermod", "plasmacutter_adv")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)
	discount_experiments = list(/datum/experiment/scanning/random/material/hard/one = 5000)

/datum/techweb_node/janitor
	id = "janitor"
	display_name = "Advanced Sanitation Technology"
	description = "Clean things better, faster, stronger, and harder!"
	prereq_ids = list("adv_engi")
	design_ids = list("holobarrier_jani", "advmop", "buffer", "blutrash", "light_replacer", "spraybottle", "beartrap", "paint_remover")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 4000)
	discount_experiments = list(/datum/experiment/scanning/random/janitor_trash = 3000) //75% discount for scanning some trash, seems fair right?

/datum/techweb_node/botany
	id = "botany"
	display_name = "Botanical Engineering"
	description = "Botanical tools"
	prereq_ids = list("adv_engi", "biotech")
	design_ids = list("portaseeder", "flora_gun", "hydro_tray", "biogenerator", "seed_extractor", "diskplantgene")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 4000)
	discount_experiments = list(/datum/experiment/scanning/random/plants/wild = 3000)

/datum/techweb_node/exp_tools
	id = "exp_tools"
	display_name = "Экспериментальные инструменты"
	description = "Инструменты с повышенной эффективностью работы и гибридным функционалом."
	design_ids = list("jawsoflife", "handdrill", "exwelder", "tricorder", "laserscalpel", "mechanicalpinches", "searingtool", "biocorrector", "gene_shears")
	prereq_ids = list("adv_engi")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)
	discount_experiments = list(/datum/experiment/scanning/random/material/hard/one = 5000)

/datum/techweb_node/sec_basic
	id = "sec_basic"
	display_name = "Базовое оборудование службы безопасности"
	description = "Стандартная экипировка для СБ."
	design_ids = list("seclite", "pepperspray", "bola_energy", "zipties", "evidencebag", "internals_tactical", "handbeltsmodif")
	prereq_ids = list("base")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/rcd_upgrade
	id = "rcd_upgrade"
	display_name = "Rapid Device Upgrade Designs"
	description = "Unlocks new designs that improve rapid devices."
	design_ids = list("rcd_upgrade_frames", "rcd_upgrade_simple_circuits", "rcd_upgrade_furnishing", "rpd_upgrade_unwrench")
	prereq_ids = list("adv_engi")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_rcd_upgrade
	id = "adv_rcd_upgrade"
	display_name = "Advanced RCD Designs Upgrade"
	description = "Unlocks new RCD designs."
	design_ids = list("rcd_upgrade_silo_link")
	prereq_ids = list("rcd_upgrade", "bluespace_travel")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	discount_experiments = list(/datum/experiment/scanning/random/material/hard/two = 5000)

/////////////////////////weaponry tech/////////////////////////
/datum/techweb_node/weaponry
	id = "weaponry"
	display_name = "Weapon Development Technology"
	description = "Our researchers have found new ways to weaponize just about everything now."
	prereq_ids = list("engineering")
	design_ids = list("pin_testing", "tele_shield")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	required_experiments = list(/datum/experiment/explosion/calibration)

/datum/techweb_node/adv_weaponry
	id = "adv_weaponry"
	display_name = "Advanced Weapon Development Technology"
	description = "Our weapons are breaking the rules of reality by now."
	prereq_ids = list("adv_engi", "weaponry")
	design_ids = list("pin_loyalty")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	required_experiments = list(/datum/experiment/explosion/medium)

/datum/techweb_node/electric_weapons
	id = "electronic_weapons"
	display_name = "Electric Weapons"
	description = "Weapons using electric technology"
	prereq_ids = list("weaponry", "adv_power"  , "emp_basic")
	design_ids = list("stunrevolver", "ioncarbine")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/radioactive_weapons
	id = "radioactive_weapons"
	display_name = "Radioactive Weaponry"
	description = "Weapons using radioactive technology."
	prereq_ids = list("adv_engi", "adv_weaponry")
	design_ids = list("nuclear_gun")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/beam_weapons
	id = "beam_weapons"
	display_name = "Beam Weaponry"
	description = "Various basic beam weapons"
	prereq_ids = list("adv_weaponry")
	design_ids = list("temp_gun", "xray_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_beam_weapons
	id = "adv_beam_weapons"
	display_name = "Advanced Beam Weaponry"
	description = "Various advanced beam weapons"
	prereq_ids = list("beam_weapons")
	design_ids = list("beamrifle")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/explosive_weapons
	id = "explosive_weapons"
	display_name = "Explosive & Pyrotechnical Weaponry"
	description = "If the light stuff just won't do it."
	prereq_ids = list("adv_weaponry")
	design_ids = list("large_Grenade", "pyro_Grenade", "adv_Grenade")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	required_experiments = list(/datum/experiment/explosion/maxcap)

/datum/techweb_node/ballistic_weapons
	id = "ballistic_weapons"
	display_name = "Ballistic Weaponry"
	description = "This isn't research.. This is reverse-engineering!"
	prereq_ids = list("weaponry")
	design_ids = list("mag_oldsmg", "mag_oldsmg_ap", "mag_oldsmg_ic", "traumatic")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/exotic_ammo
	id = "exotic_ammo"
	display_name = "Exotic Ammunition"
	description = "They won't know what hit em."
	prereq_ids = list("adv_weaponry")
	design_ids = list("techshotshell", "c38_hotshot", "c38_iceblox")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
/*
/datum/techweb_node/exotic_weapons
	id = "exotic_weapons"
	display_name = "Exotic Weaponry"
	description = "A fancy way of saying \"ducktape that shit together\"."
	prereq_ids = list("adv_weaponry", "beam_weapons")
	design_ids = list("energy_smg", "energy_smg_mag", "nlaw")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 12500)
*/
/datum/techweb_node/gravity_gun
	id = "gravity_gun"
	display_name = "One-point Bluespace-gravitational Manipulator"
	description = "Fancy wording for gravity gun."
	prereq_ids = list("adv_weaponry", "bluespace_travel")
	design_ids = list("gravitygun", "mech_gravcatapult")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

////////////////////////mech technology////////////////////////
/datum/techweb_node/adv_mecha
	id = "adv_mecha"
	display_name = "Продвинутые Экзокостюмы"
	description = "Боевые модели и улучшенные модули"
	prereq_ids = list("adv_robotics")
	design_ids = list("mech_repair_droid")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)
	discount_experiments = list(/datum/experiment/scanning/random/material/medium/three = 5000)

/datum/techweb_node/odysseus
	id = "mecha_odysseus"
	display_name = "ЭКЗОКОСТЮМ: Одиссей"
	description = "Медициский экзокостюм разработанный компанией Нано-Мед для помощи раненым и их быстрой транспортировки в мед-блок"
	prereq_ids = list("base")
	design_ids = list("odysseus_chassis", "odysseus_torso", "odysseus_head", "odysseus_left_arm", "odysseus_right_arm" ,"odysseus_left_leg", "odysseus_right_leg",
	"odysseus_main", "odysseus_peri")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/clarke
	id = "mecha_clarke"
	display_name = "ЭКЗОКОСТЮМ: Кларк"
	description = "Экзокостюм разработанный в равной степени для горнодобывающей и инженерной отрасли. Имеет 7 универсальных слотов для крепежа инженерного оборудования, оснащен интегрированным танком для руды и лавастойкими траками."
	prereq_ids = list("engineering")
	design_ids = list("clarke_chassis", "clarke_torso", "clarke_head", "clarke_left_arm", "clarke_right_arm", "clarke_main", "clarke_peri")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/gygax
	id = "mech_gygax"
	display_name = "ЭКЗОКОСТЮМ: Гигакс"
	description = "Легкий боевой экзокостюм. Популярен среди наемников и корпоративных армий"
	prereq_ids = list("adv_mecha", "weaponry")
	design_ids = list("gygax_chassis", "gygax_torso", "gygax_head", "gygax_left_arm", "gygax_right_arm", "gygax_left_leg", "gygax_right_leg", "gygax_main",
	"gygax_peri", "gygax_targ", "gygax_armor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_mechbay = 5000)

/datum/techweb_node/durand
	id = "mech_durand"
	display_name = "ЭКЗОКОСТЮМ: Дюранд"
	description = "Устаревший боевой экзоскелет, используемый корпорацией Нанотрасен. Сверхтяжелый и медленный, но очень прочен. Первоначально разработанный для борьбы с враждебными инопланетными формами жизни."
	prereq_ids = list("adv_mecha", "adv_weaponry")
	design_ids = list("durand_chassis", "durand_torso", "durand_head", "durand_left_arm", "durand_right_arm", "durand_left_leg", "durand_right_leg", "durand_main",
	"durand_peri", "durand_targ", "durand_armor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_mechbay = 3500)

/datum/techweb_node/phazon
	id = "mecha_phazon"
	display_name = "ЭКЗОКОСТЮМ: Фазон"
	description = "Вершина научных исследований и гордость Нанотрейзен, он использует передовые технологии блюспейс и дорогие материалы."
	prereq_ids = list("adv_mecha", "weaponry" , "micro_bluespace")
	design_ids = list("phazon_chassis", "phazon_torso", "phazon_head", "phazon_left_arm", "phazon_right_arm", "phazon_left_leg", "phazon_right_leg", "phazon_main",
	"phazon_peri", "phazon_targ", "phazon_armor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_mechbay = 2500)

/datum/techweb_node/savannah_ivanov
	id = "mecha_savannah_ivanov"
	display_name = "ЭКЗОКОСТЮМ: Саванна-Иванов"
	description = "Безумно громоздкий мех, который ловко унижает операторов с одним пилотом. Цена в том, что вам нужно два пилота, чтобы использовать его."
	prereq_ids = list("adv_mecha", "weaponry", "exp_tools")
	design_ids = list(
		"savannah_ivanov_armor",
		"savannah_ivanov_chassis",
		"savannah_ivanov_head",
		"savannah_ivanov_left_arm",
		"savannah_ivanov_left_leg",
		"savannah_ivanov_main",
		"savannah_ivanov_peri",
		"savannah_ivanov_right_arm",
		"savannah_ivanov_right_leg",
		"savannah_ivanov_targ",
		"savannah_ivanov_torso",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_mechbay = 3000)

/datum/techweb_node/adv_mecha_tools
	id = "adv_mecha_tools"
	display_name = "Продвинутая экипировка Экзокостюмов"
	description = "Промышленный РЦД и маневровые двигатели"
	prereq_ids = list("adv_mecha")
	design_ids = list("mech_rcd", "mech_thrusters")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/med_mech_tools
	id = "med_mech_tools"
	display_name = "Экипировка для медицинских экзокостюмов"
	description = "Медлуч, синтезатор медикаментов с интегрированным шприцеметом и криокапсула - стандартный набор разработанный компанией Нано-Мед для экзокостюма Одиссей"
	prereq_ids = list("biotech", "mecha_odysseus")
	design_ids = list("mech_sleeper", "mech_syringe_gun", "mech_medi_beam")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_modules
	id = "adv_mecha_modules"
	display_name = "Простые модули экзокостюмов"
	description = "Системы дополнительного бронирования и вспомогательные энергосистемы."
	prereq_ids = list("adv_mecha", "bluespace_power")
	design_ids = list(
		"mech_ccw_armor",
		"mech_proj_armor",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_scattershot
	id = "mecha_tools"
	display_name = "Тяжелая картечница \"Дуплет\""
	description = "Оружие для боевых экзокостюмов. Стреляет шквалом крупной картечи."
	prereq_ids = list("ballistic_weapons")
	design_ids = list("mech_scattershot", "mech_scattershot_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_carbine
	id = "mech_carbine"
	display_name = "Легкий зажигательный карабин БК-БЗ \"Аид\""
	description = "Оружие для боевых экзокостюмов. Стреляет зажигательными пулями."
	prereq_ids = list("ballistic_weapons")
	design_ids = list("mech_carbine", "mech_carbine_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_ion
	id = "mmech_ion"
	display_name = "Тяжелое ионное орудие МК-4"
	description = "Оружие для боевых экзокостюмов. Стреляет эми импульсами повреждающими технику. Не попадите под собственный выстрел!"
	prereq_ids = list("electronic_weapons", "emp_adv")
	design_ids = list("mech_ion")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_tesla
	id = "mech_tesla"
	display_name = "Орудие Теслы МК-1"
	description = "Оружие для боевых экзокостюмов. Стреляет разветвленными разрядами электричества, прицельный огонь невозможен."
	prereq_ids = list("electronic_weapons", "adv_power")
	design_ids = list("mech_tesla")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_laser
	id = "mech_laser"
	display_name = "Легкий лазер ЭВ-ЛЛ \"Выжигатель\""
	description = "Оружие для боевых экзокостюмов. Стреляет слабыми лазерами."
	prereq_ids = list("beam_weapons")
	design_ids = list("mech_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_laser_heavy
	id = "mech_laser_heavy"
	display_name = "Тяжелый лазер ЭВ-ТЛ \"Солярис\""
	description = "Оружие для боевых экзокостюмов. Стреляет мощными лазерами."
	prereq_ids = list("adv_beam_weapons")
	design_ids = list("mech_laser_heavy")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_disabler
	id = "mech_disabler"
	display_name =  "Усмиритель ЭВ-УЛ \"Миротворец\""
	description = "Оружие для боевых экзокостюмов. Стреляет слабыми парализующими лучами."
	prereq_ids = list("beam_weapons")
	design_ids = list("mech_disabler")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_grenade_launcher
	id = "mech_grenade_launcher"
	display_name = "Автоматический гранатомет АГС \"Заря\""
	description = "Оружие для боевых экзокостюмов. Автоматическая гранатометная система запускающая светошумовые гранаты."
	prereq_ids = list("explosive_weapons")
	design_ids = list("mech_grenade_launcher", "mech_grenade_launcher_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_missile_rack
	id = "mech_missile_rack"
	display_name = "Легкая ракетная установка РСЗО \"Пробой-6\""
	description = "Оружие для боевых экзокостюмов. Запускает маловзрывоопасные разрывные ракеты, предназначенные для взрыва только при попадании в прочную цель."
	prereq_ids = list("explosive_weapons")
	design_ids = list("mech_missile_rack", "mech_missile_rack_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/clusterbang_launcher
	id = "clusterbang_launcher"
	display_name = "Касетный гранатомет АГС \"Матрёшка\""
	description = "Оружие для боевых экзокостюмов. Запускает кластерные светошумовые гранаты. Ты чудовище."
	prereq_ids = list("explosive_weapons")
	design_ids = list("clusterbang_launcher", "clusterbang_launcher_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_teleporter
	id = "mech_teleporter"
	display_name = "Телепортер экзокостюма"
	description = "Модуль экзокостюма, который позволяет им телепортироваться в любое место в поле зрения."
	prereq_ids = list("micro_bluespace")
	design_ids = list("mech_teleporter")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_wormhole_gen
	id = "mech_wormhole_gen"
	display_name = "Генератор червоточин экзокостюма"
	description = "Модуль экзокостюма, который позволяет создавать небольшие квазистабильные червоточины, позволяющие осуществлять неточную телепортацию на большие расстояния."
	prereq_ids = list("bluespace_travel")
	design_ids = list("mech_wormhole_gen")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_lmg
	id = "mech_lmg"
	display_name = "Легкий пулемет Ультра АК-2"
	description = "Оружие для боевых экзокостюмов. Стреляет короткой очередью из трех выстрелов."
	prereq_ids = list("ballistic_weapons")
	design_ids = list("mech_lmg", "mech_lmg_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_diamond_drill
	id = "mech_diamond_drill"
	display_name =  "Алмазный бур экзокостюма"
	description = "Оборудование для инженерных и боевых экзоскелетов. Усовершенствованная версия."
	prereq_ids = list("adv_mining")
	design_ids = list("mech_diamond_drill")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/////////////////////////Nanites/////////////////////////
/datum/techweb_node/nanite_base
	id = "nanite_base"
	display_name = "Basic Nanite Programming"
	description = "The basics of nanite construction and programming."
	prereq_ids = list("datatheory")
	design_ids = list("nanite_disk","nanite_remote","nanite_comm_remote","nanite_scanner",\
						"nanite_chamber","public_nanite_chamber","nanite_chamber_control","nanite_programmer","nanite_program_hub","nanite_cloud_control",\
						"relay_nanites", "monitoring_nanites", "access_nanites", "repairing_nanites","sensor_nanite_volume", "repeater_nanites", "relay_repeater_nanites","debugging_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/nanite_smart
	id = "nanite_smart"
	display_name = "Smart Nanite Programming"
	description = "Nanite programs that require nanites to perform complex actions, act independently, roam or seek targets."
	prereq_ids = list("nanite_base","robotics")
	design_ids = list("purging_nanites", "metabolic_nanites", "stealth_nanites", "memleak_nanites","sensor_voice_nanites", "voice_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 500, TECHWEB_POINT_TYPE_NANITES = 500)

/datum/techweb_node/nanite_mesh
	id = "nanite_mesh"
	display_name = "Mesh Nanite Programming"
	description = "Nanite programs that require static structures and membranes."
	prereq_ids = list("nanite_base","engineering")
	design_ids = list("hardening_nanites", "dermal_button_nanites", "refractive_nanites", "cryo_nanites", "conductive_nanites", "shock_nanites", "emp_nanites", "temperature_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 500, TECHWEB_POINT_TYPE_NANITES = 500)

/datum/techweb_node/nanite_bio
	id = "nanite_bio"
	display_name = "Biological Nanite Programming"
	description = "Nanite programs that require complex biological interaction."
	prereq_ids = list("nanite_base","biotech")
	design_ids = list("regenerative_nanites", "bloodheal_nanites", "coagulating_nanites","poison_nanites","flesheating_nanites",\
					"sensor_crit_nanites","sensor_death_nanites", "sensor_health_nanites", "sensor_damage_nanites", "sensor_species_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 500, TECHWEB_POINT_TYPE_NANITES = 500)

/datum/techweb_node/nanite_neural
	id = "nanite_neural"
	display_name = "Neural Nanite Programming"
	description = "Nanite programs affecting nerves and brain matter."
	prereq_ids = list("nanite_bio")
	design_ids = list("nervous_nanites", "brainheal_nanites", "paralyzing_nanites", "stun_nanites", "selfscan_nanites","good_mood_nanites","bad_mood_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000, TECHWEB_POINT_TYPE_NANITES = 1000)

/datum/techweb_node/nanite_synaptic
	id = "nanite_synaptic"
	display_name = "Synaptic Nanite Programming"
	description = "Nanite programs affecting mind and thoughts."
	prereq_ids = list("nanite_neural","neural_programming")
	design_ids = list("mindshield_nanites", "pacifying_nanites", "blinding_nanites", "sleep_nanites", "mute_nanites", "speech_nanites","hallucination_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000, TECHWEB_POINT_TYPE_NANITES = 1000)

/datum/techweb_node/nanite_harmonic
	id = "nanite_harmonic"
	display_name = "Harmonic Nanite Programming"
	description = "Nanite programs that require seamless integration between nanites and biology. Passively increases nanite regeneration rate for all clouds upon researching."
	prereq_ids = list("nanite_bio","nanite_smart","nanite_mesh")
	design_ids = list("fakedeath_nanites","aggressive_nanites","defib_nanites","regenerative_plus_nanites","brainheal_plus_nanites","purging_plus_nanites","adrenaline_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000, TECHWEB_POINT_TYPE_NANITES = 3000)

/datum/techweb_node/nanite_combat
	id = "nanite_military"
	display_name = "Military Nanite Programming"
	description = "Nanite programs that perform military-grade functions."
	prereq_ids = list("nanite_harmonic", "syndicate_basic")
	design_ids = list("explosive_nanites","pyro_nanites","meltdown_nanites","viral_nanites","nanite_sting_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500, TECHWEB_POINT_TYPE_NANITES = 2500)

/datum/techweb_node/nanite_hazard
	id = "nanite_hazard"
	display_name = "Hazard Nanite Programs"
	description = "Extremely advanced Nanite programs with the potential of being extremely dangerous."
	prereq_ids = list("nanite_harmonic", "alientech")
	design_ids = list("spreading_nanites","mindcontrol_nanites","mitosis_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000, TECHWEB_POINT_TYPE_NANITES = 4000)

/datum/techweb_node/nanite_replication_protocols
	id = "nanite_replication_protocols"
	display_name = "Nanite Replication Protocols"
	description = "Protocols that overwrite the default nanite replication routine to achieve more efficiency in certain circumstances."
	prereq_ids = list("nanite_smart")
	design_ids = list("kickstart_nanites","factory_nanites","pyramid_nanites","offline_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000, TECHWEB_POINT_TYPE_NANITES = 2500)
	hidden = TRUE
	experimental = TRUE

/datum/techweb_node/nanite_storage_protocols
	id = "nanite_storage_protocols"
	display_name = "Nanite Storage Protocols"
	description = "Protocols that overwrite the default nanite storage routine to achieve more efficiency or greater capacity."
	prereq_ids = list("nanite_smart")
	design_ids = list("hive_nanites","zip_nanites","free_range_nanites","unsafe_storage_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000, TECHWEB_POINT_TYPE_NANITES = 2500)
	hidden = TRUE
	experimental = TRUE

////////////////////////Alien technology////////////////////////
/datum/techweb_node/alientech //AYYYYYYYYLMAOO tech
	id = "alientech"
	display_name = "Alien Technology"
	description = "Things used by the greys."
	prereq_ids = list("biotech","engineering")
	boost_item_paths = list(/obj/item/gun/energy/alien, /obj/item/scalpel/alien, /obj/item/hemostat/alien, /obj/item/retractor/alien, /obj/item/circular_saw/alien,
	/obj/item/cautery/alien, /obj/item/surgicaldrill/alien, /obj/item/screwdriver/abductor, /obj/item/wrench/abductor, /obj/item/crowbar/abductor, /obj/item/multitool/abductor,
	/obj/item/weldingtool/abductor, /obj/item/wirecutters/abductor, /obj/item/circuitboard/machine/abductor, /obj/item/melee/baton/abductor, /obj/item/abductor, /obj/item/gun/energy/shrink_ray)
	design_ids = list("alienalloy", "alienalloy_x10")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	hidden = TRUE

/datum/techweb_node/alientech/on_research() //Unlocks the Zeta shuttle for purchase
		SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_ALIENTECH] = TRUE

/datum/techweb_node/alien_bio
	id = "alien_bio"
	display_name = "Alien Biological Tools"
	description = "Advanced biological tools."
	prereq_ids = list("alientech", "adv_biotech")
	design_ids = list("alien_scalpel", "alien_hemostat", "alien_retractor", "alien_saw", "alien_drill", "alien_cautery")
	boost_item_paths = list(/obj/item/gun/energy/alien, /obj/item/scalpel/alien, /obj/item/hemostat/alien, /obj/item/retractor/alien, /obj/item/circular_saw/alien,
	/obj/item/cautery/alien, /obj/item/surgicaldrill/alien, /obj/item/screwdriver/abductor, /obj/item/wrench/abductor, /obj/item/crowbar/abductor, /obj/item/multitool/abductor,
	/obj/item/weldingtool/abductor, /obj/item/wirecutters/abductor, /obj/item/circuitboard/machine/abductor, /obj/item/melee/baton/abductor, /obj/item/abductor, /obj/item/gun/energy/shrink_ray)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	required_experiments = list(/datum/experiment/scanning/points/slime/hard)
	hidden = TRUE

/datum/techweb_node/alien_engi
	id = "alien_engi"
	display_name = "Alien Engineering"
	description = "Alien engineering tools"
	prereq_ids = list("alientech", "adv_engi")
	design_ids = list("alien_wrench", "alien_wirecutters", "alien_screwdriver", "alien_crowbar", "alien_welder", "alien_multitool")
	boost_item_paths = list(/obj/item/screwdriver/abductor, /obj/item/wrench/abductor, /obj/item/crowbar/abductor, /obj/item/multitool/abductor,
	/obj/item/weldingtool/abductor, /obj/item/wirecutters/abductor, /obj/item/circuitboard/machine/abductor, /obj/item/melee/baton/abductor, /obj/item/abductor,
	/obj/item/gun/energy/shrink_ray)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = TRUE

/datum/techweb_node/syndicate_basic
	id = "syndicate_basic"
	display_name = "Illegal Technology"
	description = "Dangerous research used to create dangerous objects."
	prereq_ids = list("adv_engi", "adv_weaponry", "explosive_weapons")
	design_ids = list("decloner", "borg_syndicate_module", "ai_cam_upgrade", "suppressor", "largecrossbow", "donksofttoyvendor", "donksoft_refill", "advanced_camera", "rapidsyringe")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	hidden = TRUE

/datum/techweb_node/syndicate_basic/New()		//Crappy way of making syndicate gear decon supported until there's another way.
	. = ..()
	boost_item_paths = list()
	for(var/path in GLOB.uplink_items)
		var/datum/uplink_item/UI = new path
		if(!UI.item || !UI.illegal_tech)
			continue
		boost_item_paths |= UI.item	//allows deconning to unlock.


////////////////////////B.E.P.I.S. Locked Techs////////////////////////
/datum/techweb_node/light_apps
	id = "light_apps"
	display_name = "Альтернативное освещение"
	description = "Применение технологий освещения, которые изначально не считались коммерчески жизнеспособными."
	prereq_ids = list("janitor")
	design_ids = list("rld")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	required_experiments = list(/datum/experiment/scanning/points/ne_bepis/light)	// Больше не бепис

/datum/techweb_node/extreme_office
	id = "extreme_office"
	display_name = "Advanced Office Applications"
	description = "Some of our smartest lab guys got together on a Friday and improved our office efficiency by 350%. Here's how."
	prereq_ids = list("base")
	design_ids = list("rolling_table", "mauna_mug")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = TRUE
	experimental = TRUE

/datum/techweb_node/spec_eng
	id = "spec_eng"
	display_name = "Specialized Engineering"
	description = "Conventional wisdom has deemed these engineering products 'technically' safe, but far too dangerous to traditionally condone."
	prereq_ids = list("base")
	design_ids = list("lava_rods", "eng_gloves")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = TRUE
	experimental = TRUE

/datum/techweb_node/aus_security
	id = "aus_security"
	display_name = "Australicus Security Protocols"
	description = "It is said that security in the Australicus sector is tight, so we took some pointers from their equipment. Thankfully, our sector lacks any signs of these, 'dropbears'."
	prereq_ids = list("base")
	design_ids = list("pin_explorer", "stun_boomerang")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = TRUE
	experimental = TRUE

/datum/techweb_node/interrogation
	id = "interrogation"
	display_name = "Enhanced Interrogation Technology"
	description = "By cross-referencing several declassified documents from past dictatorial regimes, we were able to develop an incredibly effective interrogation device. \
	Ethical concerns about loss of free will do not apply to criminals, according to galactic law."
	prereq_ids = list("base")
	design_ids = list("hypnochair")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3500)
	hidden = TRUE
	experimental = TRUE

/datum/techweb_node/sticky_advanced
	id = "sticky_advanced"
	display_name = "Advanced Sticky Technology"
	description = "Taking a good joke too far? Nonsense!"
	design_ids = list("super_sticky_tape", "pointy_tape")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = TRUE
	experimental = TRUE

/datum/techweb_node/tackle_advanced
	id = "tackle_advanced"
	display_name = "Advanced Grapple Technology"
	description = "Nanotrasen would like to remind its researching staff that it is never acceptable to \"glomp\" your coworkers, and further \"scientific trials\" on the subject \
	will no longer be accepted in its academic journals."
	design_ids = list("tackle_dolphin", "tackle_rocket")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = TRUE
	experimental = TRUE

/datum/techweb_node/drone_robotics
	id = "drone_robotics"
	starting_node = TRUE
	display_name = "Drone research"
	description = "Little robots that help out here and there. Immensely useful."
	prereq_ids = list("base")
	design_ids = list("maint_drone")

/datum/techweb_node/base_cryptominer
	id = "base_cryptominer"
	display_name = "Базовый криптомайнинг"
	description = "Почти всё нужное!"
	design_ids = list("nvidia")
	prereq_ids = list("comptech")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 12500)

/datum/techweb_node/adv_cryptominer
	id = "adv_cryptominer"
	display_name = "Продвинутый криптомайнинг"
	description = "Новая карточка!"
	design_ids = list("ntx420")
	prereq_ids = list("base_cryptominer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 25000)

/datum/techweb_node/qua_cryptominer
	id = "qua_cryptominer"
	display_name = "Квантовый криптомайнинг"
	description = "Ещё одна карточка у нас в кармане!"
	design_ids = list("ntx970")
	prereq_ids = list("adv_cryptominer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 50000)

/datum/techweb_node/super_cryptominer
	id = "super_cryptominer"
	display_name = "Блюспейс криптомайнинг"
	description = "Так тоже бывает."
	design_ids = list("ntx1666")
	prereq_ids = list("qua_cryptominer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 100000)

/datum/techweb_node/ultra_cryptominer
	id = "ultra_cryptominer"
	display_name = "Ультра криптомайнинг"
	description = "А почему бы и да?"
	design_ids = list("ntx2080")
	prereq_ids = list("super_cryptominer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 200000)

/datum/techweb_node/noneuclid_cryptominer
	id = "noneuclid_cryptominer"
	display_name = "Неевклидовый криптомайнинг"
	description = "Нарушение законов физики как основа."
	design_ids = list("ntx3090ti")
	prereq_ids = list("ultra_cryptominer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 500000)
	required_experiments = list(/datum/experiment/explosion/medium)
	discount_experiments = list(/datum/experiment/explosion/calibration = 200000)

/////////////////////////shuttle tech/////////////////////////
/datum/techweb_node/basic_shuttle_tech
	id = "basic_shuttle"
	display_name = "Basic Shuttle Research"
	description = "Research the technology required to create and use basic shuttles."
	prereq_ids = list("bluespace_travel", "adv_engi")
	design_ids = list("shuttle_creator", "engine_plasma", "engine_heater", "shuttle_control")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

////////////////////// Deepcore ///////////////////////

/datum/techweb_node/deepcore
	id = "deepcore"
	display_name = "Deepcore Mining"
	description = "Mining, but automated."
	prereq_ids = list("basic_mining")
	design_ids = list("deepcore_drill", "deepcore_hopper")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

//Helpers for debugging/balancing the techweb in its entirety!
/proc/total_techweb_points()
	var/list/datum/techweb_node/processing = list()
	for(var/i in subtypesof(/datum/techweb_node))
		processing += new i
	var/datum/techweb/TW = new
	TW.research_points = list()
	for(var/i in processing)
		var/datum/techweb_node/TN = i
		TW.add_point_list(TN.research_costs)
	return TW.research_points

/proc/total_techweb_points_printout()
	var/list/datum/techweb_node/processing = list()
	for(var/i in subtypesof(/datum/techweb_node))
		processing += new i
	var/datum/techweb/TW = new
	TW.research_points = list()
	for(var/i in processing)
		var/datum/techweb_node/TN = i
		TW.add_point_list(TN.research_costs)
	return TW.printout_points()
