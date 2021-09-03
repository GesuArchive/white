/obj/machinery/airalarm/unlocked
	locked = FALSE

/obj/machinery/airalarm/engine
	name = "котроллер воздуха в двигателе"
	locked = FALSE
	req_access = null
	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_ENGINE)

/obj/machinery/airalarm/mixingchamber
	name = "контроллер воздуха в смешивателе"
	locked = FALSE
	req_access = null
	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_TOXINS)

/obj/machinery/airalarm/all_access
	name = "вседоступный контроллер воздуха"
	desc = "Похоже этот контроллер может использовать любой."
	locked = FALSE
	req_access = null
	req_one_access = null

/obj/machinery/airalarm/syndicate //general syndicate access
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/airalarm/away //general away mission access
	req_access = list(ACCESS_AWAY_GENERAL)

/obj/machinery/airalarm/directional/north //Pixel offsets get overwritten on New()
	dir = SOUTH
	pixel_y = 24

/obj/machinery/airalarm/directional/south
	dir = NORTH
	pixel_y = -24

/obj/machinery/airalarm/directional/east
	dir = WEST
	pixel_x = 24

/obj/machinery/airalarm/directional/west
	dir = EAST
	pixel_x = -24
