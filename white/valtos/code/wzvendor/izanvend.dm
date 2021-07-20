/obj/machinery/izanvend
	name = "Наци-вендор"
	desc = "Невероятная коллекция запрещённых вещей в одном месте."
	icon = 'white/valtos/icons/vending.dmi'
	icon_state = "trading"
	density = TRUE
	var/list/guns = list(/obj/item/gun/ballistic/automatic/l6_saw/unrestricted/mg34, /obj/item/gun/energy/taser/carbine, /obj/item/gun/ballistic/automatic/wt550/german)

	var/list/melees = list(/obj/item/melee/cultblade/great,
						  /obj/item/melee/classic_baton/german,
						  /obj/item/melee/club,
						  /obj/item/melee/baton/loaded/german,
						  /obj/item/kitchen/knife/german)

	var/list/storages = list(/obj/item/storage/belt/military/assault)

	var/list/ammos = list(/obj/item/ammo_box/n792x57, /obj/item/ammo_box/magazine/wt550m9/mc9mmt)

	var/list/uniforms = list(/obj/item/clothing/under/rank/engineering/engineer/mechanic,
                    	  /obj/item/clothing/under/rank/engineering/atmospheric_technician/aether,
                    	  /obj/item/clothing/under/rank/cargo/qm/german,
                    	  /obj/item/clothing/under/rank/centcom/officer/centcom,
                    	  /obj/item/clothing/under/rank/security/detective/detective2,
                    	  /obj/item/clothing/under/rank/rnd/research_director/rdalt,
                    	  /obj/item/clothing/under/rank/civilian/head_of_personnel/hopwhimsy)

	var/list/suits = list(/obj/item/clothing/suit/armor/vest/bulletproofsuit/vest,
						  /obj/item/clothing/suit/armor/hos/german,
						  /obj/item/clothing/suit/imperium_monk/german,
                    	  /obj/item/clothing/suit/wizrobe/psyamp,
                    	  /obj/item/clothing/suit/armor/hos/trenchcoat/jensen,
                    	  /obj/item/clothing/suit/space/syndicate/german,
						  /obj/item/clothing/suit/armor/opvest)

	var/list/glasses = list(/obj/item/clothing/glasses/welding/r, /obj/item/clothing/glasses/hud/hacker_rig)

	var/list/shoes = list()

	var/list/masks = list(/obj/item/clothing/mask/balaclava/swatclava, /obj/item/clothing/mask/breath/half, /obj/item/clothing/mask/balaclavager)

	var/list/caps = list(/obj/item/clothing/head/wizard/amp, /obj/item/clothing/head/bomb_hood/german, /obj/item/clothing/head/cap/elite)

	var/list/gloves = list()

	var/list/misc = list(
                    /mob/living/simple_animal/pet/cat,
                    /mob/living/simple_animal/pet/cat/kitten)

	var/list/products = list()

	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF

/obj/machinery/izanvend/Initialize()
	. = ..()
	fill_vendor()

/obj/machinery/izanvend/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "Izanvend", name, master_ui, state)
		ui.open()

/obj/machinery/izanvend/ui_static_data()
	var/list/data = list()
	data["products"] = list()
	for(var/thing in products)
		var/datum/data/izanvend_product/P = thing
		if(!data["products"][P.cat])
			data["products"][P.cat] = list(
				"name" = P.cat,
				"packs" = list()
			)
		data["products"][P.cat]["packs"] += list(list(
			"name" = P.name,
			"product_path" = P.product_path
		))
	return data

/obj/machinery/izanvend/ui_act(action, params, datum/tgui/ui)
	if(..())
		return
	switch(action)
		if("vend")
			. = TRUE
			var/obj/R = text2path(params["product_path"])
			new R(get_turf(src))
			playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE, extrarange = -3)


/obj/machinery/izanvend/proc/fill_vendor()
	// guns
	guns 	 += subtypesof(/obj/item/gun/ballistic/automatic)
	guns 	 += subtypesof(/obj/item/gun/ballistic/automatic/pistol)
	guns 	 += subtypesof(/obj/item/gun/ballistic/rifle/boltaction)
	build_inventory(guns, "Пушки")

	//melee
	melees   += subtypesof(/obj/item/melee/sabre)
	build_inventory(melees, "Ближний")

	//storages
	storages += subtypesof(/obj/item/storage/belt/military)
	storages += subtypesof(/obj/item/storage/pill_bottle)
	storages += subtypesof(/obj/item/storage/belt/military/army)
	storages += subtypesof(/obj/item/storage/belt/mining)
	build_inventory(storages, "Сумочки")

	//uniforms
	uniforms += subtypesof(/obj/item/clothing/under)
	uniforms += subtypesof(/obj/item/clothing/under/rank/cargo/tech)
	uniforms += subtypesof(/obj/item/clothing/under/rank/security/officer)
	uniforms += subtypesof(/obj/item/clothing/under/rank/medical/doctor)
	uniforms += subtypesof(/obj/item/clothing/under/rank/security/head_of_security)
	uniforms += subtypesof(/obj/item/clothing/under/rank/security/warden)
	uniforms += subtypesof(/obj/item/clothing/under/syndicate)
	build_inventory(uniforms, "Униформы")

	//suits
	suits 	 += subtypesof(/obj/item/clothing/suit/space/hardsuit/syndi/elite)
	suits 	 += subtypesof(/obj/item/clothing/suit/space)
	suits 	 += subtypesof(/obj/item/clothing/suit/armor/vest)
	suits 	 += subtypesof(/obj/item/clothing/suit/toggle/labcoat)
	suits 	 += subtypesof(/obj/item/clothing/suit/bomb_suit)
	suits 	 += subtypesof(/obj/item/clothing/suit/radiation)
	suits 	 += subtypesof(/obj/item/clothing/suit/hazardvest)
	suits 	 += subtypesof(/obj/item/clothing/suit)
	suits  	 += subtypesof(/obj/item/clothing/suit/toggle)
	build_inventory(suits, "Костюмы")

	//glasses
	glasses  += subtypesof(/obj/item/clothing/glasses)
	build_inventory(glasses, "Очки")

	//shoes
	shoes 	 += subtypesof(/obj/item/clothing/shoes/combat)
	shoes 	 += subtypesof(/obj/item/clothing/shoes)
	build_inventory(shoes, "Обувь")

	//masks
	masks 	 += subtypesof(/obj/item/clothing/mask/gas)
	build_inventory(masks, "Маски")

	//caps
	caps 	 += subtypesof(/obj/item/clothing/head/helmet/space)
	caps 	 += subtypesof(/obj/item/clothing/head)
	caps 	 += subtypesof(/obj/item/clothing/head/soft)
	caps 	 += subtypesof(/obj/item/clothing/head/helmet)
	caps 	 += subtypesof(/obj/item/clothing/head/welding)
	build_inventory(caps, "Шапочки")

	//gloves
	gloves 	 += subtypesof(/obj/item/clothing/gloves/combat)
	build_inventory(gloves, "Перчатки")

	//ammos
	ammos    += subtypesof(/obj/item/ammo_box/magazine)
	build_inventory(ammos, "Аммуниция")

	build_inventory(misc)

/datum/data/izanvend_product
	name = "что-то"
	var/product_path = null
	var/cat = "Другое"

/obj/machinery/izanvend/proc/build_inventory(list/productlist, var/category = "Другое")
	for(var/typepath in productlist)
		var/atom/temp = typepath
		var/datum/data/izanvend_product/R = new /datum/data/izanvend_product()
		R.name = initial(temp.name)
		R.product_path = typepath
		R.cat = category
		products += R
