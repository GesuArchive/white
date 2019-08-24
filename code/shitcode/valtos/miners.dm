////////////////////////////////////////////
// SPACECOIN miners
// fuck this
/////////////////////////////////////

/obj/machinery/power/spaceminer
	name = "spacecoin miner"
	desc = "Converts energy into money."
	icon = 'code/shitcode/valtos/icons/miner.dmi'
	icon_state = "miner-off"

	anchored = FALSE
	density = TRUE

	use_power = NO_POWER_USE
	idle_power_usage = 80

	var/coins = 0
	var/tier = 1
	var/mining = FALSE
	var/diff = 10

/obj/machinery/power/spaceminer/Initialize()
	. = ..()
	if(anchored)
		connect_to_network()

/obj/machinery/power/spaceminer/attack_ai(mob/user)
	interact(user)

/obj/machinery/power/spaceminer/attack_paw(mob/user)
	interact(user)

/obj/machinery/power/spaceminer/process()
	..()
	if(mining)
		if (stat & (BROKEN|NOPOWER))
			say("Insufficient power. Halting mining.")
			icon_state = "miner-off"
			idle_power_usage = 40
			mining = FALSE
		playsound(src, 'code/shitcode/valtos/sounds/ping.ogg', 100, 1)
		coins += tier
		if(prob(50))
			diff -= rand(1, 3) //lol //balanced maybe
		else
			diff += rand(1, 5)

/obj/machinery/power/spaceminer/attackby(obj/item/O, mob/user, params)
	if(!mining)
		if(O.tool_behaviour == TOOL_WRENCH)
			if(!anchored && !isinspace())
				to_chat(user, "<span class='notice'>You secure the coinminer to the floor.</span>")
				anchored = TRUE
				connect_to_network()
				update_cable_icons_on_turf(get_turf(src))
			else if(anchored)
				to_chat(user, "<span class='notice'>You unsecure the coinminer from the floor.</span>")
				anchored = FALSE
				disconnect_from_network()
				update_cable_icons_on_turf(get_turf(src))

			playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
			return
	return ..()

/obj/machinery/power/spaceminer/proc/eject_money()
	if (coins == 0)
		return
	var/money = coins * diff
	say("[coins] SC converted to $[money].")
	new /obj/item/holochip(drop_location(), money)
	coins = 0

/obj/machinery/power/spaceminer/ui_interact(mob/user)
	if(!anchored)
		return
	. = ..()

	var/dat = "Current Balance: [coins] SC<br>"
	dat += "Current Conversion: $[diff]<br>"
	dat += "Current Power Usage: [idle_power_usage] W<br>"

	if(!mining)
		dat += "<A href='?src=[REF(src)];mine=1'>Turn ON</A><br>"
	else
		dat += "<A href='?src=[REF(src)];stop=1'>Turn OFF</A><br>"

	dat += "<A href='?src=[REF(src)];money=1'>Withdraw money</A><br>"

	var/datum/browser/popup = new(user, "miner", "Spacecoin Miner Tier [tier]", 300, 200)
	popup.set_content("<center>[dat]</center>")
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/machinery/power/spaceminer/Topic(href, href_list)
	if(..())
		return
	if(href_list["mine"])
		say("Booting up...")
		icon_state = "miner-on"
		playsound(src, 'code/shitcode/valtos/sounds/up.ogg', 100, 1)
		idle_power_usage = 80000 * tier
		mining = TRUE
		src.updateUsrDialog()
	if(href_list["stop"])
		say("Shutdown...")
		icon_state = "miner-off"
		playsound(src, 'code/shitcode/valtos/sounds/down.ogg', 100, 1)
		idle_power_usage = 40
		mining = FALSE
		src.updateUsrDialog()
	if(href_list["money"])
		eject_money()
		src.updateUsrDialog()

/obj/machinery/power/spaceminer/tier2
	tier = 2

/obj/machinery/power/spaceminer/tier3
	tier = 3

/obj/machinery/power/spaceminer/tier4
	tier = 4

/datum/supply_pack/misc/spaceminer
	name = "Spacecoin Miner Tier 1"
	desc = "Ping!"
	cost = 80000
	contains = list(/obj/machinery/power/spaceminer,
					/obj/item/wrench)
	crate_name = "coinminer tier 1 crate"
/*
/datum/supply_pack/misc/spaceminer2
	name = "Spacecoin Miner Tier 2"
	desc = "Ping!"
	cost = 180000
	contains = list(/obj/machinery/spaceminer/tier2,
					/obj/item/wrench)
	crate_name = "coinminer tier 2 crate"

/datum/supply_pack/misc/spaceminer3
	name = "Spacecoin Miner Tier 3"
	desc = "Ping!"
	cost = 300000
	contains = list(/obj/machinery/spaceminer/tier3,
					/obj/item/wrench)
	crate_name = "coinminer tier 3 crate"

/datum/supply_pack/misc/spaceminer4
	name = "Spacecoin Miner Tier 4"
	desc = "Pong!"
	cost = 800000
	contains = list(/obj/machinery/spaceminer/tier4,
					/obj/item/wrench)
	crate_name = "coinminer tier 4 crate"
*/
/datum/supply_pack/misc/minerchallenge
	name = "You can do it! The Miner Challenge"
	desc = "Pong!"
	cost = 70000069
	contains = list(/obj/item/gun/energy/pulse/prize)
	crate_name = "coinminer tier 4 crate"