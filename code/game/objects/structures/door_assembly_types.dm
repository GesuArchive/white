/obj/structure/door_assembly/door_assembly_public
	name = "каркас общедоступного шлюза"
	icon = 'icons/obj/doors/airlocks/station2/glass.dmi'
	overlays_file = 'icons/obj/doors/airlocks/station2/overlays.dmi'
	glass_type = /obj/machinery/door/airlock/public/glass
	airlock_type = /obj/machinery/door/airlock/public

/obj/structure/door_assembly/door_assembly_com
	name = "каркас шлюза командования"
	icon = 'icons/obj/doors/airlocks/station/command.dmi'
	base_name = "command airlock"
	glass_type = /obj/machinery/door/airlock/command/glass
	airlock_type = /obj/machinery/door/airlock/command

/obj/structure/door_assembly/door_assembly_sec
	name = "каркас шлюза службы безопасности"
	icon = 'icons/obj/doors/airlocks/station/security.dmi'
	base_name = "security airlock"
	glass_type = /obj/machinery/door/airlock/security/glass
	airlock_type = /obj/machinery/door/airlock/security

/obj/structure/door_assembly/door_assembly_eng
	name = "каркас шлюза инженерного отсека"
	icon = 'icons/obj/doors/airlocks/station/engineering.dmi'
	base_name = "engineering airlock"
	glass_type = /obj/machinery/door/airlock/engineering/glass
	airlock_type = /obj/machinery/door/airlock/engineering

/obj/structure/door_assembly/door_assembly_min
	name = "каркас шлюза шахтеров"
	icon = 'icons/obj/doors/airlocks/station/mining.dmi'
	base_name = "mining airlock"
	glass_type = /obj/machinery/door/airlock/mining/glass
	airlock_type = /obj/machinery/door/airlock/mining

/obj/structure/door_assembly/door_assembly_atmo
	name = "каркас шлюза атмосферных техников"
	icon = 'icons/obj/doors/airlocks/station/atmos.dmi'
	base_name = "atmospherics airlock"
	glass_type = /obj/machinery/door/airlock/atmos/glass
	airlock_type = /obj/machinery/door/airlock/atmos

/obj/structure/door_assembly/door_assembly_research
	name = "каркас шлюза исследовательского отдела"
	icon = 'icons/obj/doors/airlocks/station/research.dmi'
	base_name = "research airlock"
	glass_type = /obj/machinery/door/airlock/research/glass
	airlock_type = /obj/machinery/door/airlock/research

/obj/structure/door_assembly/door_assembly_science
	name = "каркас шлюза научного отдела"
	icon = 'icons/obj/doors/airlocks/station/science.dmi'
	base_name = "science airlock"
	glass_type = /obj/machinery/door/airlock/science/glass
	airlock_type = /obj/machinery/door/airlock/science

/obj/structure/door_assembly/door_assembly_med
	name = "каркас шлюза медбэя"
	icon = 'icons/obj/doors/airlocks/station/medical.dmi'
	base_name = "medical airlock"
	glass_type = /obj/machinery/door/airlock/medical/glass
	airlock_type = /obj/machinery/door/airlock/medical

/obj/structure/door_assembly/door_assembly_mai
	name = "каркас шлюза технических тоннелей"
	icon = 'icons/obj/doors/airlocks/station/maintenance.dmi'
	base_name = "maintenance airlock"
	glass_type = /obj/machinery/door/airlock/maintenance/glass
	airlock_type = /obj/machinery/door/airlock/maintenance

/obj/structure/door_assembly/door_assembly_extmai
	name = "каркас шлюза технических туннелей ведущих в космос"
	icon = 'icons/obj/doors/airlocks/station/maintenanceexternal.dmi'
	base_name = "external maintenance airlock"
	glass_type = /obj/machinery/door/airlock/maintenance/external/glass
	airlock_type = /obj/machinery/door/airlock/maintenance/external

/obj/structure/door_assembly/door_assembly_ext
	name = "каркас шлюза ведущего в космос"
	icon = 'icons/obj/doors/airlocks/external/external.dmi'
	base_name = "external airlock"
	overlays_file = 'icons/obj/doors/airlocks/external/overlays.dmi'
	glass_type = /obj/machinery/door/airlock/external/glass
	airlock_type = /obj/machinery/door/airlock/external

/obj/structure/door_assembly/door_assembly_fre
	name = "каркас шлюза морозильника"
	icon = 'icons/obj/doors/airlocks/station/freezer.dmi'
	base_name = "freezer airlock"
	airlock_type = /obj/machinery/door/airlock/freezer
	noglass = TRUE

/obj/structure/door_assembly/door_assembly_hatch
	name = "каркас герметичного люка"
	icon = 'icons/obj/doors/airlocks/hatch/centcom.dmi'
	base_name = "airtight hatch"
	overlays_file = 'icons/obj/doors/airlocks/hatch/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/hatch
	noglass = TRUE

/obj/structure/door_assembly/door_assembly_mhatch
	name = "каркас люка технического обслуживания"
	icon = 'icons/obj/doors/airlocks/hatch/maintenance.dmi'
	base_name = "maintenance hatch"
	overlays_file = 'icons/obj/doors/airlocks/hatch/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/maintenance_hatch
	noglass = TRUE

/obj/structure/door_assembly/door_assembly_highsecurity
	name = "каркас укрепленного шлюза"
	icon = 'icons/obj/doors/airlocks/highsec/highsec.dmi'
	base_name = "high security airlock"
	overlays_file = 'icons/obj/doors/airlocks/highsec/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/highsecurity
	noglass = TRUE
	material_type = /obj/item/stack/sheet/plasteel
	material_amt = 4

/obj/structure/door_assembly/door_assembly_vault
	name = "каркас двери хранилища"
	icon = 'icons/obj/doors/airlocks/vault/vault.dmi'
	base_name = "vault door"
	overlays_file = 'icons/obj/doors/airlocks/vault/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/vault
	noglass = TRUE
	material_type = /obj/item/stack/sheet/plasteel
	material_amt = 6

/obj/structure/door_assembly/door_assembly_shuttle
	name = "каркас шлюза шаттла"
	icon = 'icons/obj/doors/airlocks/shuttle/shuttle.dmi'
	base_name = "shuttle airlock"
	overlays_file = 'icons/obj/doors/airlocks/shuttle/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/shuttle
	glass_type = /obj/machinery/door/airlock/shuttle/glass

/obj/structure/door_assembly/door_assembly_cult
	name = "каркас шлюза культа"
	icon = 'icons/obj/doors/airlocks/cult/runed/cult.dmi'
	base_name = "cult airlock"
	overlays_file = 'icons/obj/doors/airlocks/cult/runed/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/cult
	glass_type = /obj/machinery/door/airlock/cult/glass

/obj/structure/door_assembly/door_assembly_cult/unruned
	icon = 'icons/obj/doors/airlocks/cult/unruned/cult.dmi'
	overlays_file = 'icons/obj/doors/airlocks/cult/unruned/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/cult/unruned
	glass_type = /obj/machinery/door/airlock/cult/unruned/glass

/obj/structure/door_assembly/door_assembly_viro
	name = "каркас шлюза вирусологии"
	icon = 'icons/obj/doors/airlocks/station/virology.dmi'
	base_name = "virology airlock"
	glass_type = /obj/machinery/door/airlock/virology/glass
	airlock_type = /obj/machinery/door/airlock/virology

/obj/structure/door_assembly/door_assembly_centcom
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	overlays_file = 'icons/obj/doors/airlocks/centcom/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/centcom
	noglass = TRUE

/obj/structure/door_assembly/door_assembly_grunge
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	overlays_file = 'icons/obj/doors/airlocks/centcom/overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/grunge
	noglass = TRUE

/obj/structure/door_assembly/door_assembly_gold
	name = "каркас золотой двери"
	icon = 'icons/obj/doors/airlocks/station/gold.dmi'
	base_name = "gold airlock"
	airlock_type = /obj/machinery/door/airlock/gold
	mineral = "gold"
	glass_type = /obj/machinery/door/airlock/gold/glass

/obj/structure/door_assembly/door_assembly_silver
	name = "каркас серебряной двери"
	icon = 'icons/obj/doors/airlocks/station/silver.dmi'
	base_name = "silver airlock"
	airlock_type = /obj/machinery/door/airlock/silver
	mineral = "silver"
	glass_type = /obj/machinery/door/airlock/silver/glass

/obj/structure/door_assembly/door_assembly_diamond
	name = "каркас алмазной двери"
	icon = 'icons/obj/doors/airlocks/station/diamond.dmi'
	base_name = "diamond airlock"
	airlock_type = /obj/machinery/door/airlock/diamond
	mineral = "diamond"
	glass_type = /obj/machinery/door/airlock/diamond/glass

/obj/structure/door_assembly/door_assembly_uranium
	name = "каркас урановой двери"
	icon = 'icons/obj/doors/airlocks/station/uranium.dmi'
	base_name = "uranium airlock"
	airlock_type = /obj/machinery/door/airlock/uranium
	mineral = "uranium"
	glass_type = /obj/machinery/door/airlock/uranium/glass

/obj/structure/door_assembly/door_assembly_plasma
	name = "каркас плазменной двери"
	icon = 'icons/obj/doors/airlocks/station/plasma.dmi'
	base_name = "plasma airlock"
	airlock_type = /obj/machinery/door/airlock/plasma
	mineral = "plasma"
	glass_type = /obj/machinery/door/airlock/plasma/glass

/obj/structure/door_assembly/door_assembly_bananium
	name = "каркас двери из банания"
	desc = "Хонк."
	icon = 'icons/obj/doors/airlocks/station/bananium.dmi'
	base_name = "bananium airlock"
	airlock_type = /obj/machinery/door/airlock/bananium
	mineral = "bananium"
	glass_type = /obj/machinery/door/airlock/bananium/glass

/obj/structure/door_assembly/door_assembly_sandstone
	name = "каркас двери из песчаника"
	icon = 'icons/obj/doors/airlocks/station/sandstone.dmi'
	base_name = "sandstone airlock"
	airlock_type = /obj/machinery/door/airlock/sandstone
	mineral = "sandstone"
	glass_type = /obj/machinery/door/airlock/sandstone/glass

/obj/structure/door_assembly/door_assembly_titanium
	name = "каркас двери из титана"
	icon = 'icons/obj/doors/airlocks/shuttle/shuttle.dmi'
	base_name = "shuttle airlock"
	overlays_file = 'icons/obj/doors/airlocks/shuttle/overlays.dmi'
	glass_type = /obj/machinery/door/airlock/titanium/glass
	airlock_type = /obj/machinery/door/airlock/titanium
	mineral = "titanium"

/obj/structure/door_assembly/door_assembly_wood
	name = "каркас деревянной двери"
	icon = 'icons/obj/doors/airlocks/station/wood.dmi'
	base_name = "wooden airlock"
	airlock_type = /obj/machinery/door/airlock/wood
	mineral = "wood"
	glass_type = /obj/machinery/door/airlock/wood/glass

/obj/structure/door_assembly/door_assembly_bronze
	name = "каркас латунной двери"
	icon = 'icons/obj/doors/airlocks/clockwork/pinion_airlock.dmi'
	base_name = "bronze airlock"
	airlock_type = /obj/machinery/door/airlock/bronze
	noglass = TRUE
	material_type = /obj/item/stack/tile/bronze

/obj/structure/door_assembly/door_assembly_bronze/seethru
	airlock_type = /obj/machinery/door/airlock/bronze/seethru
