/obj/item/multitool/mechcomp
	name = "соединительный коннектор Мех-Комп"
	desc = "Универсальный механизм настройки, используемый при изготовлении и использовании механических компонентов марки Мех-комп. Может также использоваться в качестве полезного многофункционального инструмента."
	icon = 'white/RedFoxIV/icons/mechcomp/connection.dmi'
	icon_state = "linker_multitool"
	var/mechcomp_enabled = FALSE
	//so we don't beat the shite out of some poor plumbing synthesizer or whatnot
	item_flags = NOBLUDGEON

/obj/item/multitool/mechcomp/attack_self(mob/user)
	. = ..()
	mechcomp_enabled = !mechcomp_enabled
	if(mechcomp_enabled)
		to_chat(user, span_notice("You slide out the mechcomp control panel on the \"C.U.M.\", allowing you to connect, disconnect mechcomp parts and configure them.")) // haha funni
		icon_state = "linker_mechcomp"
		tool_behaviour = TOOL_MECHCOMP
	else
		to_chat(user, span_notice("You slide in the mechcomp control panel on the \"C.U.M.\", making it function like a regular multitool."))
		icon_state = "linker_multitool"
		tool_behaviour = TOOL_MULTITOOL
	//So, apparently tool behaviours are not bitflags and are instead just plain strings with some #defines sprinkled over.
	//So, yeah, this is fucking cringe
	//at least i got to make "cool" sprites

/obj/machinery/vending/mechcomp
	name = "торговый автомат Мех-Комп"
	desc = "Продает компоненты для мехкомплектов. Больше об этом нечего сказать."
	icon = 'white/RedFoxIV/icons/mechcomp/connection.dmi'
	icon_state = "vending"
	icon_deny = "vending-deny"
	light_mask = "vending-light-mask"
	products = list(/obj/item/mechcomp/button = 15,
					/obj/item/mechcomp/delay = 20,
					/obj/item/mechcomp/speaker = 6,
					/obj/item/mechcomp/textpad = 10,
					/obj/item/mechcomp/pressurepad = 5,
					/obj/item/mechcomp/grav_accelerator = 2,
					/obj/item/mechcomp/math = 35,
					/obj/item/mechcomp/list_packer = 12,
					/obj/item/mechcomp/list_extractor = 12,
					/obj/item/mechcomp/find_regex = 7,
					/obj/item/mechcomp/timer = 2,
					/obj/item/mechcomp/microphone = 7,
					/obj/item/mechcomp/teleport = 6,
					/obj/structure/disposalconstruct/mechcomp = 2,
					/obj/item/multitool/mechcomp = 1)
	contraband = list(
						/obj/item/mechcomp/egunholder = 3,
						/obj/item/mechcomp/grav_accelerator = 5,
						/obj/item/mechcomp/teleport/longrange = 6)
	premium = list(	/obj/item/mechcomp/grav_accelerator = 2,
					/obj/item/mechcomp/teleport/longrange = 3)
	armor = list(MELEE = 30, BULLET = 30, LASER = 40, ENERGY = 40, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 40)
	resistance_flags = FIRE_PROOF
	default_price = PAYCHECK_ASSISTANT
	extra_price = PAYCHECK_COMMAND * 1.5
	payment_department = ACCOUNT_ENG
	refill_canister = /obj/item/vending_refill/mechcomp

/obj/item/vending_refill/mechcomp
	machine_name = "Мех-Комп"
