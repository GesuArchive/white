/obj/item/circuitboard/machine/chem_dispenser/botany
	name = "Botany Chem Dispenser (Машинерия)"
	icon_state = "service"
	build_path = /obj/machinery/chem_dispenser/botany
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)
	needs_anchored = FALSE
