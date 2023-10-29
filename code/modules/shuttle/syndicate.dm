#define SYNDICATE_CHALLENGE_TIMER 12000 //20 minutes

/obj/machinery/computer/shuttle_flight/syndicate
	name = "консоль шаттла синдиката"
	desc = "Консоль, используемая для транспортировки шаттла Синдиката.."
	circuit = /obj/item/circuitboard/computer/syndicate_shuttle
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "syndicate"
	possible_destinations = "syndicate_away;syndicate_z5;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s;syndicate_custom"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/machinery/computer/shuttle_flight/syndicate/ui_act(action, params)
	if(!usr.canUseTopic(src))
		return
	var/obj/item/circuitboard/computer/syndicate_shuttle/board = circuit
	if(board.challenge && world.time < SYNDICATE_CHALLENGE_TIMER)
		to_chat(usr, span_warning("Вы бросили вызов станции! Вы ВЫНУЖДЕНЫ дать им по крайней мере [DisplayTimeText(SYNDICATE_CHALLENGE_TIMER - world.time)] для их подготовки."))
		return FALSE
	board.moved = TRUE
	. = ..()

/obj/machinery/computer/shuttle_flight/syndicate/recall
	name = "консоль призыва шаттла синдиката"
	desc = "Используйте это, если товарищи по команде оставили вас на базе."
	request_shuttle_message = "Вызвать обратно"
	recall_docking_port_id = "syndicate_away"

/obj/machinery/computer/shuttle_flight/syndicate/allowed(mob/M)
	if(issilicon(M) && !(ROLE_SYNDICATE in M.faction))
		return FALSE
	return ..()

/obj/machinery/computer/shuttle_flight/syndicate/drop_pod
	name = "пульт управления дроппода синдиката"
	desc = "Контролирует систему запуска штурмового дроппода."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "dorm_available"
	icon_keyboard = null
	light_color = LIGHT_COLOR_BLUE
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "steel_rain"
	possible_destinations = null
	recall_docking_port_id = "null"	//Make it a recall shuttle, with no default dest
	request_shuttle_message = "НАЧАТЬ ШТУРМ"

#undef SYNDICATE_CHALLENGE_TIMER
