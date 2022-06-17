/obj/effect/mapping_helpers/airlock/access
	layer = DOOR_HELPER_LAYER
	icon_state = "access_helper"
	var/list/access_list = list()

// These are mutually exclusive; can't have req_any and req_all
/obj/effect/mapping_helpers/airlock/access/any/payload(obj/machinery/door/airlock/airlock)
	if(airlock.req_access_txt == "0")
		// Overwrite if there is no access set, otherwise add onto existing access
		if(airlock.req_one_access_txt == "0")
			airlock.req_one_access_txt = access_list.Join(";")
		else
			airlock.req_one_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_one_access, but req_access was already set!")

/obj/effect/mapping_helpers/airlock/access/all/payload(obj/machinery/door/airlock/airlock)
	if(airlock.req_one_access_txt == "0")
		if(airlock.req_access_txt == "0")
			airlock.req_access_txt = access_list.Join(";")
		else
			airlock.req_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_access, but req_one_access was already set!")

// -------------------- Req Any (Only requires ONE of the given accesses to open)
// -------------------- Command access helpers
/obj/effect/mapping_helpers/airlock/access/any/command
	icon_state = "access_helper_com"

/obj/effect/mapping_helpers/airlock/access/any/command/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_HEADS

/obj/effect/mapping_helpers/airlock/access/any/command/ai_upload/Initialize(mapload)
	. = ..()
	access_list += ACCESS_AI_UPLOAD

/obj/effect/mapping_helpers/airlock/access/any/command/teleporter/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TELEPORTER

/obj/effect/mapping_helpers/airlock/access/any/command/eva/Initialize(mapload)
	. = ..()
	access_list += ACCESS_EVA

/obj/effect/mapping_helpers/airlock/access/any/command/gateway/Initialize(mapload)
	. = ..()
	access_list += ACCESS_GATEWAY

/obj/effect/mapping_helpers/airlock/access/any/command/hop/Initialize(mapload)
	. = ..()
	access_list += ACCESS_HOP

/obj/effect/mapping_helpers/airlock/access/any/command/captain/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CAPTAIN

// -------------------- Engineering access helpers
/obj/effect/mapping_helpers/airlock/access/any/engineering
	icon_state = "access_helper_eng"

/obj/effect/mapping_helpers/airlock/access/any/engineering/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_ENGINE

/obj/effect/mapping_helpers/airlock/access/any/engineering/construction/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CONSTRUCTION

/obj/effect/mapping_helpers/airlock/access/any/engineering/aux_base/Initialize(mapload)
	. = ..()
	access_list += ACCESS_AUX_BASE

/obj/effect/mapping_helpers/airlock/access/any/engineering/maintenance/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MAINT_TUNNELS

/obj/effect/mapping_helpers/airlock/access/any/engineering/external/Initialize(mapload)
	. = ..()
	access_list += ACCESS_EXTERNAL_AIRLOCKS

/obj/effect/mapping_helpers/airlock/access/any/engineering/tech_storage/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TECH_STORAGE

/obj/effect/mapping_helpers/airlock/access/any/engineering/atmos/Initialize(mapload)
	. = ..()
	access_list += ACCESS_ATMOSPHERICS

/obj/effect/mapping_helpers/airlock/access/any/engineering/tcoms/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TCOMSAT

/obj/effect/mapping_helpers/airlock/access/any/engineering/ce/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CE

// -------------------- Medical access helpers
/obj/effect/mapping_helpers/airlock/access/any/medical
	icon_state = "access_helper_med"

/obj/effect/mapping_helpers/airlock/access/any/medical/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MEDICAL

/obj/effect/mapping_helpers/airlock/access/any/medical/morgue/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MORGUE

/obj/effect/mapping_helpers/airlock/access/any/medical/chemistry/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CHEMISTRY

/obj/effect/mapping_helpers/airlock/access/any/medical/virology/Initialize(mapload)
	. = ..()
	access_list += ACCESS_VIROLOGY

/obj/effect/mapping_helpers/airlock/access/any/medical/surgery/Initialize(mapload)
	. = ..()
	access_list += ACCESS_SURGERY

/obj/effect/mapping_helpers/airlock/access/any/medical/cmo/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CMO

/obj/effect/mapping_helpers/airlock/access/any/medical/pharmacy/Initialize(mapload)
	. = ..()
	access_list += ACCESS_PHARMACY

/obj/effect/mapping_helpers/airlock/access/any/medical/psychology/Initialize(mapload)
	. = ..()
	access_list += ACCESS_PSYCHOLOGY

// -------------------- Science access helpers
/obj/effect/mapping_helpers/airlock/access/any/science
	icon_state = "access_helper_sci"

/obj/effect/mapping_helpers/airlock/access/any/science/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_RND

/obj/effect/mapping_helpers/airlock/access/any/science/research/Initialize(mapload)
	. = ..()
	access_list += ACCESS_RESEARCH

/obj/effect/mapping_helpers/airlock/access/any/science/ordnance/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TOXINS

/obj/effect/mapping_helpers/airlock/access/any/science/ordnance_storage/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TOXINS_STORAGE

/obj/effect/mapping_helpers/airlock/access/any/science/genetics/Initialize(mapload)
	. = ..()
	access_list += ACCESS_GENETICS

/obj/effect/mapping_helpers/airlock/access/any/science/robotics/Initialize(mapload)
	. = ..()
	access_list += ACCESS_ROBOTICS

/obj/effect/mapping_helpers/airlock/access/any/science/xenobio/Initialize(mapload)
	. = ..()
	access_list += ACCESS_XENOBIOLOGY

/obj/effect/mapping_helpers/airlock/access/any/science/minisat/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MINISAT

/obj/effect/mapping_helpers/airlock/access/any/science/rd/Initialize(mapload)
	. = ..()
	access_list += ACCESS_RD

// -------------------- Security access helpers
/obj/effect/mapping_helpers/airlock/access/any/security
	icon_state = "access_helper_sec"

/obj/effect/mapping_helpers/airlock/access/any/security/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_SECURITY

/obj/effect/mapping_helpers/airlock/access/any/security/doors/Initialize(mapload)
	. = ..()
	access_list += ACCESS_SEC_DOORS

/obj/effect/mapping_helpers/airlock/access/any/security/brig/Initialize(mapload)
	. = ..()
	access_list += ACCESS_BRIG

/obj/effect/mapping_helpers/airlock/access/any/security/armory/Initialize(mapload)
	. = ..()
	access_list += ACCESS_ARMORY

/obj/effect/mapping_helpers/airlock/access/any/security/court/Initialize(mapload)
	. = ..()
	access_list += ACCESS_COURT

/obj/effect/mapping_helpers/airlock/access/any/security/hos/Initialize(mapload)
	. = ..()
	access_list += ACCESS_HOS

// -------------------- Service access helpers
/obj/effect/mapping_helpers/airlock/access/any/service
	icon_state = "access_helper_serv"

/obj/effect/mapping_helpers/airlock/access/any/service/general/Initialize(mapload)
	. = ..()
	access_list += REGION_ACCESS_GENERAL

/obj/effect/mapping_helpers/airlock/access/any/service/kitchen/Initialize(mapload)
	. = ..()
	access_list += ACCESS_KITCHEN

/obj/effect/mapping_helpers/airlock/access/any/service/bar/Initialize(mapload)
	. = ..()
	access_list += ACCESS_BAR

/obj/effect/mapping_helpers/airlock/access/any/service/hydroponics/Initialize(mapload)
	. = ..()
	access_list += ACCESS_HYDROPONICS

/obj/effect/mapping_helpers/airlock/access/any/service/janitor/Initialize(mapload)
	. = ..()
	access_list += ACCESS_JANITOR

/obj/effect/mapping_helpers/airlock/access/any/service/chapel_office/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CHAPEL_OFFICE

/obj/effect/mapping_helpers/airlock/access/any/service/crematorium/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CREMATORIUM

/obj/effect/mapping_helpers/airlock/access/any/service/crematorium/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CREMATORIUM

/obj/effect/mapping_helpers/airlock/access/any/service/library/Initialize(mapload)
	. = ..()
	access_list += ACCESS_LIBRARY

/obj/effect/mapping_helpers/airlock/access/any/service/library/Initialize(mapload)
	. = ..()
	access_list += ACCESS_THEATRE

/obj/effect/mapping_helpers/airlock/access/any/service/lawyer/Initialize(mapload)
	. = ..()
	access_list += ACCESS_LAWYER

// -------------------- Supply access helpers
/obj/effect/mapping_helpers/airlock/access/any/supply
	icon_state = "access_helper_sup"

/obj/effect/mapping_helpers/airlock/access/any/supply/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CARGO

/obj/effect/mapping_helpers/airlock/access/any/supply/mail_sorting/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MAILSORTING

/obj/effect/mapping_helpers/airlock/access/any/supply/mining/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MINING

/obj/effect/mapping_helpers/airlock/access/any/supply/mining_station/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MINING_STATION

/obj/effect/mapping_helpers/airlock/access/any/supply/mineral_storage/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MINERAL_STOREROOM

/obj/effect/mapping_helpers/airlock/access/any/supply/qm/Initialize(mapload)
	. = ..()
	access_list += ACCESS_QM

/obj/effect/mapping_helpers/airlock/access/any/supply/vault/Initialize(mapload)
	. = ..()
	access_list += ACCESS_VAULT

// -------------------- Req All (Requires ALL of the given accesses to open)
// -------------------- Command access helpers
/obj/effect/mapping_helpers/airlock/access/all/command
	icon_state = "access_helper_com"

/obj/effect/mapping_helpers/airlock/access/all/command/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_HEADS

/obj/effect/mapping_helpers/airlock/access/all/command/ai_upload/Initialize(mapload)
	. = ..()
	access_list += ACCESS_AI_UPLOAD

/obj/effect/mapping_helpers/airlock/access/all/command/teleporter/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TELEPORTER

/obj/effect/mapping_helpers/airlock/access/all/command/eva/Initialize(mapload)
	. = ..()
	access_list += ACCESS_EVA

/obj/effect/mapping_helpers/airlock/access/all/command/gateway/Initialize(mapload)
	. = ..()
	access_list += ACCESS_GATEWAY

/obj/effect/mapping_helpers/airlock/access/all/command/hop/Initialize(mapload)
	. = ..()
	access_list += ACCESS_HOP

/obj/effect/mapping_helpers/airlock/access/all/command/captain/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CAPTAIN

// -------------------- Engineering access helpers
/obj/effect/mapping_helpers/airlock/access/all/engineering
	icon_state = "access_helper_eng"

/obj/effect/mapping_helpers/airlock/access/all/engineering/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_ENGINE

/obj/effect/mapping_helpers/airlock/access/all/engineering/construction/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CONSTRUCTION

/obj/effect/mapping_helpers/airlock/access/all/engineering/aux_base/Initialize(mapload)
	. = ..()
	access_list += ACCESS_AUX_BASE

/obj/effect/mapping_helpers/airlock/access/all/engineering/maintenance/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MAINT_TUNNELS

/obj/effect/mapping_helpers/airlock/access/all/engineering/external/Initialize(mapload)
	. = ..()
	access_list += ACCESS_EXTERNAL_AIRLOCKS

/obj/effect/mapping_helpers/airlock/access/all/engineering/tech_storage/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TECH_STORAGE

/obj/effect/mapping_helpers/airlock/access/all/engineering/atmos/Initialize(mapload)
	. = ..()
	access_list += ACCESS_ATMOSPHERICS

/obj/effect/mapping_helpers/airlock/access/all/engineering/tcoms/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TCOMSAT

/obj/effect/mapping_helpers/airlock/access/all/engineering/ce/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CE

// -------------------- Medical access helpers
/obj/effect/mapping_helpers/airlock/access/all/medical
	icon_state = "access_helper_med"

/obj/effect/mapping_helpers/airlock/access/all/medical/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MEDICAL

/obj/effect/mapping_helpers/airlock/access/all/medical/morgue/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MORGUE

/obj/effect/mapping_helpers/airlock/access/all/medical/chemistry/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CHEMISTRY

/obj/effect/mapping_helpers/airlock/access/all/medical/virology/Initialize(mapload)
	. = ..()
	access_list += ACCESS_VIROLOGY

/obj/effect/mapping_helpers/airlock/access/all/medical/surgery/Initialize(mapload)
	. = ..()
	access_list += ACCESS_SURGERY

/obj/effect/mapping_helpers/airlock/access/all/medical/cmo/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CMO

/obj/effect/mapping_helpers/airlock/access/all/medical/pharmacy/Initialize(mapload)
	. = ..()
	access_list += ACCESS_PHARMACY

/obj/effect/mapping_helpers/airlock/access/all/medical/psychology/Initialize(mapload)
	. = ..()
	access_list += ACCESS_PSYCHOLOGY

// -------------------- Science access helpers
/obj/effect/mapping_helpers/airlock/access/all/science
	icon_state = "access_helper_sci"

/obj/effect/mapping_helpers/airlock/access/all/science/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_RND

/obj/effect/mapping_helpers/airlock/access/all/science/research/Initialize(mapload)
	. = ..()
	access_list += ACCESS_RESEARCH

/obj/effect/mapping_helpers/airlock/access/all/science/ordnance/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TOXINS

/obj/effect/mapping_helpers/airlock/access/all/science/ordnance_storage/Initialize(mapload)
	. = ..()
	access_list += ACCESS_TOXINS_STORAGE

/obj/effect/mapping_helpers/airlock/access/all/science/genetics/Initialize(mapload)
	. = ..()
	access_list += ACCESS_GENETICS

/obj/effect/mapping_helpers/airlock/access/all/science/robotics/Initialize(mapload)
	. = ..()
	access_list += ACCESS_ROBOTICS

/obj/effect/mapping_helpers/airlock/access/all/science/xenobio/Initialize(mapload)
	. = ..()
	access_list += ACCESS_XENOBIOLOGY

/obj/effect/mapping_helpers/airlock/access/all/science/minisat/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MINISAT

/obj/effect/mapping_helpers/airlock/access/all/science/rd/Initialize(mapload)
	. = ..()
	access_list += ACCESS_RD

// -------------------- Security access helpers
/obj/effect/mapping_helpers/airlock/access/all/security
	icon_state = "access_helper_sec"

/obj/effect/mapping_helpers/airlock/access/all/security/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_SECURITY

/obj/effect/mapping_helpers/airlock/access/all/security/doors/Initialize(mapload)
	. = ..()
	access_list += ACCESS_SEC_DOORS

/obj/effect/mapping_helpers/airlock/access/all/security/brig/Initialize(mapload)
	. = ..()
	access_list += ACCESS_BRIG

/obj/effect/mapping_helpers/airlock/access/all/security/armory/Initialize(mapload)
	. = ..()
	access_list += ACCESS_ARMORY

/obj/effect/mapping_helpers/airlock/access/all/security/court/Initialize(mapload)
	. = ..()
	access_list += ACCESS_COURT

/obj/effect/mapping_helpers/airlock/access/all/security/hos/Initialize(mapload)
	. = ..()
	access_list += ACCESS_HOS

// -------------------- Service access helpers
/obj/effect/mapping_helpers/airlock/access/all/service
	icon_state = "access_helper_serv"

/obj/effect/mapping_helpers/airlock/access/all/service/general/Initialize(mapload)
	. = ..()
	access_list += REGION_ACCESS_GENERAL

/obj/effect/mapping_helpers/airlock/access/all/service/kitchen/Initialize(mapload)
	. = ..()
	access_list += ACCESS_KITCHEN

/obj/effect/mapping_helpers/airlock/access/all/service/bar/Initialize(mapload)
	. = ..()
	access_list += ACCESS_BAR

/obj/effect/mapping_helpers/airlock/access/all/service/hydroponics/Initialize(mapload)
	. = ..()
	access_list += ACCESS_HYDROPONICS

/obj/effect/mapping_helpers/airlock/access/all/service/janitor/Initialize(mapload)
	. = ..()
	access_list += ACCESS_JANITOR

/obj/effect/mapping_helpers/airlock/access/all/service/chapel_office/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CHAPEL_OFFICE

/obj/effect/mapping_helpers/airlock/access/all/service/crematorium/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CREMATORIUM

/obj/effect/mapping_helpers/airlock/access/all/service/crematorium/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CREMATORIUM

/obj/effect/mapping_helpers/airlock/access/all/service/library/Initialize(mapload)
	. = ..()
	access_list += ACCESS_LIBRARY

/obj/effect/mapping_helpers/airlock/access/all/service/library/Initialize(mapload)
	. = ..()
	access_list += ACCESS_THEATRE

/obj/effect/mapping_helpers/airlock/access/all/service/lawyer/Initialize(mapload)
	. = ..()
	access_list += ACCESS_LAWYER

// -------------------- Supply access helpers
/obj/effect/mapping_helpers/airlock/access/all/supply
	icon_state = "access_helper_sup"

/obj/effect/mapping_helpers/airlock/access/all/supply/general/Initialize(mapload)
	. = ..()
	access_list += ACCESS_CARGO

/obj/effect/mapping_helpers/airlock/access/all/supply/mail_sorting/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MAILSORTING

/obj/effect/mapping_helpers/airlock/access/all/supply/mining/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MINING

/obj/effect/mapping_helpers/airlock/access/all/supply/mining_station/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MINING_STATION

/obj/effect/mapping_helpers/airlock/access/all/supply/mineral_storage/Initialize(mapload)
	. = ..()
	access_list += ACCESS_MINERAL_STOREROOM

/obj/effect/mapping_helpers/airlock/access/all/supply/qm/Initialize(mapload)
	. = ..()
	access_list += ACCESS_QM

/obj/effect/mapping_helpers/airlock/access/all/supply/vault/Initialize(mapload)
	. = ..()
	access_list += ACCESS_VAULT
