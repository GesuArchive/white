//caravan ambush

/obj/item/wrench/caravan
	color = "#ff0000"
	desc = "Опытный образец нового гаечного ключа. Говорят, что красные цвета делают его быстрее."
	name = "экспериментальный гаечный ключ"
	toolspeed = 0.3

/obj/item/screwdriver/caravan
	color = "#ff0000"
	desc = "Опытный образец новой отвертки. Говорят, что красные цвета делают её быстрее."
	name = "экспериментальная отвертка"
	toolspeed = 0.3
	random_color = FALSE

/obj/item/wirecutters/caravan
	color = "#ff0000"
	desc = "Опытный образец новых кусачек. Говорят, что красные цвета делают их быстрее."
	name = "экспериментальные кусачки"
	worn_icon_state = "cutters"
	toolspeed = 0.3
	random_color = FALSE

/obj/item/crowbar/red/caravan
	color = "#ff0000"
	desc = "Опытный образец новой монтировки. Говорят, что красные цвета делают её быстрее."
	name = "экспериментальная монтировка"
	toolspeed = 0.3

/obj/machinery/computer/shuttle_flight/caravan

/obj/item/circuitboard/computer/caravan
	build_path = /obj/machinery/computer/shuttle_flight/caravan

/obj/item/circuitboard/computer/caravan/trade1
	build_path = /obj/machinery/computer/shuttle_flight/caravan/trade1

/obj/item/circuitboard/computer/caravan/pirate
	build_path = /obj/machinery/computer/shuttle_flight/caravan/pirate

/obj/item/circuitboard/computer/caravan/syndicate1
	build_path = /obj/machinery/computer/shuttle_flight/caravan/syndicate1

/obj/item/circuitboard/computer/caravan/syndicate2
	build_path = /obj/machinery/computer/shuttle_flight/caravan/syndicate2

/obj/item/circuitboard/computer/caravan/syndicate3
	build_path = /obj/machinery/computer/shuttle_flight/caravan/syndicate3

/obj/machinery/computer/shuttle_flight/caravan/trade1
	name = "Консоль Управления Малым Грузовым кораблем"
	desc = "Используется для управления Малым Грузовым кораблем."
	circuit = /obj/item/circuitboard/computer/caravan/trade1
	shuttleId = "caravantrade1"
	possible_destinations = "whiteship_away;whiteship_home;whiteship_z4;whiteship_lavaland;caravantrade1_custom;caravantrade1_ambush"

/obj/machinery/computer/shuttle_flight/caravan/pirate
	name = "Консоль Управления Пиратским охранным Катером"
	desc = "Используется для управления Пиратским охранным Катером."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	circuit = /obj/item/circuitboard/computer/caravan/pirate
	shuttleId = "caravanpirate"
	possible_destinations = "caravanpirate_custom;caravanpirate_ambush"

/obj/machinery/computer/shuttle_flight/caravan/syndicate1
	name = "Консоль Управления Истребителем Синдиката"
	desc = "Используется для управления Истребителем Синдиката."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list(ACCESS_SYNDICATE)
	circuit = /obj/item/circuitboard/computer/caravan/syndicate1
	shuttleId = "caravansyndicate1"
	possible_destinations = "caravansyndicate1_custom;caravansyndicate1_ambush;caravansyndicate1_listeningpost"

/obj/machinery/computer/shuttle_flight/caravan/syndicate2
	name = "Syndicate Fighter Shuttle Console"
	desc = "Used to control the Syndicate Fighter."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	req_access = list(ACCESS_SYNDICATE)
	light_color = COLOR_SOFT_RED
	circuit = /obj/item/circuitboard/computer/caravan/syndicate2
	shuttleId = "caravansyndicate2"
	possible_destinations = "caravansyndicate2_custom;caravansyndicate2_ambush;caravansyndicate1_listeningpost"

/obj/machinery/computer/shuttle_flight/caravan/syndicate3
	name = "Консоль управления Десантным Кораблём Синдиката"
	desc = "Используется для управления Десантным Кораблём Синдиката."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	req_access = list(ACCESS_SYNDICATE)
	light_color = COLOR_SOFT_RED
	circuit = /obj/item/circuitboard/computer/caravan/syndicate3
	shuttleId = "caravansyndicate3"
	possible_destinations = "caravansyndicate3_custom;caravansyndicate3_ambush;caravansyndicate3_listeningpost"
