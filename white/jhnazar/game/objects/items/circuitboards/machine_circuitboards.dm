/obj/item/circuitboard/machine/chem_dispenser/botany
	name = "Botany Chem Dispenser (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/botany
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_dispenser/gunpowder
	name = "Gunpowder Chem Dispenser (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/gunpowder
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)
	needs_anchored = FALSE
