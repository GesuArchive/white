/obj/item/disk/tech_disk/research
	desc = "A research disk that will unlock a research node when uploaded into a research console."
	var/node_id
	var/node_path = /datum/techweb_node/weaponry

/obj/item/disk/tech_disk/research/Initialize(mapload)
	. = ..()
	SSorbits.research_disks += src
	if(node_id)
//		stored_research.hidden_nodes[node_id] = FALSE
		var/datum/techweb_node/node = SSresearch.techweb_node_by_id(node_id)
		name = "диск с исследованиями ([node.display_name])"

/obj/item/disk/tech_disk/research/Destroy()
	SSorbits.research_disks -= src
	. = ..()
/*
/obj/item/disk/tech_disk/research/random/Initialize(mapload)
	var/list/valid_nodes = list()
	for(var/obj/item/disk/tech_disk/research/disk as() in subtypesof(/obj/item/disk/tech_disk/research))
		if(!initial(disk.node_id))
			continue
		if(!SSresearch.science_tech.isNodeResearchedID(initial(disk.node_id)))
			valid_nodes += initial(disk.node_id)
	if(!length(valid_nodes))
		new /obj/effect/spawner/lootdrop/ruinloot/basic(get_turf(src))
		return INITIALIZE_HINT_QDEL
	node_id = pick(valid_nodes)
	. = ..()
*/

// Датумы технод

/datum/techweb/weaponry
	researched_nodes = list(weaponry = 1)

/datum/techweb/adv_weaponry
	researched_nodes = list(adv_weaponry = 1)

/datum/techweb/explosive_weapons
	researched_nodes = list(explosive_weapons = 1)

/datum/techweb/radioactive_weapons
	researched_nodes = list(radioactive_weapons = 1)

/datum/techweb/beam_weapons
	researched_nodes = list(beam_weapons = 1)

/datum/techweb/adv_beam_weapons
	researched_nodes = list(adv_beam_weapons = 1)

/datum/techweb/exotic_ammo
	researched_nodes = list(exotic_ammo = 1)

/datum/techweb/phazon
	researched_nodes = list(mecha_phazon = 1)

/datum/techweb/cyber_implants
	researched_nodes = list(cyber_implants = 1)

/datum/techweb/adv_cyber_implants
	researched_nodes = list(adv_cyber_implants = 1)

/datum/techweb/combat_cyber_implants
	researched_nodes = list(combat_cyber_implants = 1)

/datum/techweb/syndicate_basic
	researched_nodes = list(syndicate_basic = 1)

/datum/techweb/alien_bio_adv
	researched_nodes = list(alien_bio_adv = 1)

/datum/techweb/noneuclidic
	researched_nodes = list(noneuclidic = 1)

// Диски

/obj/item/disk/tech_disk/research/Initialize(mapload)
	. = ..()
	stored_research = new node_path

/obj/item/disk/tech_disk/research/weaponry
	node_id = "weaponry"
	node_path = /datum/techweb/weaponry

/obj/item/disk/tech_disk/research/adv_weaponry
	node_id = "adv_weaponry"
	node_path = /datum/techweb/adv_weaponry

/obj/item/disk/tech_disk/research/explosive_weapons
	node_id = "explosive_weapons"
	node_path = /datum/techweb/explosive_weapons

/obj/item/disk/tech_disk/research/radioactive_weapons
	node_id = "radioactive_weapons"
	node_path = /datum/techweb/radioactive_weapons

/obj/item/disk/tech_disk/research/beam_weapons
	node_id = "beam_weapons"
	node_path = /datum/techweb/beam_weapons

/obj/item/disk/tech_disk/research/adv_beam_weapons
	node_id = "adv_beam_weapons"
	node_path = /datum/techweb/adv_beam_weapons

/obj/item/disk/tech_disk/research/exotic_ammo
	node_id = "exotic_ammo"
	node_path = /datum/techweb/exotic_ammo

/obj/item/disk/tech_disk/research/phazon
	node_id = "mecha_phazon"
	node_path = /datum/techweb/phazon

/obj/item/disk/tech_disk/research/cyber_implants
	node_id = "cyber_implants"
	node_path = /datum/techweb/cyber_implants

/obj/item/disk/tech_disk/research/adv_cyber_implants
	node_id = "adv_cyber_implants"
	node_path = /datum/techweb/adv_cyber_implants

/obj/item/disk/tech_disk/research/combat_cyber_implants
	node_id = "combat_cyber_implants"
	node_path = /datum/techweb/combat_cyber_implants

/obj/item/disk/tech_disk/research/syndicate_basic
	node_id = "syndicate_basic"
	node_path = /datum/techweb/syndicate_basic

/obj/item/disk/tech_disk/research/alien_bio_adv
	node_id = "alien_bio_adv"
	node_path = /datum/techweb/alien_bio_adv

/obj/item/disk/tech_disk/research/noneuclidic
	node_id = "noneuclidic"
	node_path = /datum/techweb/noneuclidic
