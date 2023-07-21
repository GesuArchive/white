/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "аварийный шкаф"
	desc = "Место для хранения масок для дыхания и баллонов с кислородом."
	icon_state = "emergency"

/obj/structure/closet/emcloset/anchored
	anchored = TRUE

/obj/structure/closet/emcloset/Initialize(mapload)
	. = ..()

	if (prob(1))
		return INITIALIZE_HINT_QDEL

/obj/structure/closet/emcloset/PopulateContents()
	..()

	if (prob(40))
		new /obj/item/storage/toolbox/emergency(src)

	switch (pick_weight(list("small" = 35, "aid" = 30, "tank" = 20, "both" = 10, "nothing" = 4)))
		if ("small")
			new /obj/item/tank/internals/emergency_oxygen(src)
			new /obj/item/tank/internals/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath/cheap(src)
			new /obj/item/clothing/mask/breath/cheap(src)

		if ("aid")
			new /obj/item/tank/internals/emergency_oxygen(src)
			new /obj/item/storage/firstaid/emergency(src)
			new /obj/item/clothing/mask/breath/cheap(src)

		if ("tank")
			new /obj/item/tank/internals/oxygen(src)
			new /obj/item/clothing/mask/breath/cheap(src)

		if ("both")
			new /obj/item/tank/internals/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath/cheap(src)

		if ("nothing")
			pass()

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "пожарные инструменты"
	desc = "Место для хранения средств пожаротушения."
	icon_state = "fire"

/obj/structure/closet/firecloset/PopulateContents()
	..()

	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/clothing/mask/gas/cheap(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/crowbar/red(src)

/obj/structure/closet/firecloset/full/PopulateContents()
	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/clothing/mask/gas/cheap(src)
	new /obj/item/flashlight(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/clothing/head/hardhat/red(src)

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "инструменты"
	desc = "Место для хранения инструментов."
	icon_state = "eng"
	icon_door = "eng_tool"

/obj/structure/closet/toolcloset/PopulateContents()
	..()
	if(prob(40))
		new /obj/item/clothing/suit/hazardvest(src)
	if(prob(70))
		new /obj/item/flashlight(src)
	if(prob(70))
		new /obj/item/screwdriver(src)
	if(prob(70))
		new /obj/item/wrench(src)
	if(prob(70))
		new /obj/item/weldingtool(src)
	if(prob(70))
		new /obj/item/crowbar(src)
	if(prob(70))
		new /obj/item/wirecutters(src)
	if(prob(70))
		new /obj/item/t_scanner(src)
	if(prob(20))
		new /obj/item/storage/belt/utility(src)
	if(prob(30))
		new /obj/item/stack/cable_coil(src)
	if(prob(30))
		new /obj/item/stack/cable_coil(src)
	if(prob(30))
		new /obj/item/stack/cable_coil(src)
	if(prob(20))
		new /obj/item/multitool(src)
	if(prob(5))
		new /obj/item/clothing/gloves/color/yellow(src)
	if(prob(40))
		new /obj/item/clothing/head/hardhat(src)


/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "анти-радиационная защита"
	desc = "Место для хранения костюмов радиозащиты."
	icon_state = "eng"
	icon_door = "eng_rad"

/obj/structure/closet/radiation/PopulateContents()
	..()
	new /obj/item/geiger_counter(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "защита от взрывов"
	desc = "Место для хранения костюмов взрывозащиты."
	icon_state = "bomb"

/obj/structure/closet/bombcloset/PopulateContents()
	..()
	new /obj/item/clothing/suit/bomb_suit(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/head/bomb_hood(src)

/obj/structure/closet/bombcloset/security/PopulateContents()
	new /obj/item/clothing/suit/bomb_suit/security(src)
	new /obj/item/clothing/under/rank/security/officer(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/head/bomb_hood/security(src)
	new /obj/item/storage/belt/grenade/sapper(src)

/obj/structure/closet/bombcloset/white/PopulateContents()
	new /obj/item/clothing/suit/bomb_suit/white(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/head/bomb_hood/white(src)

/*
 * Ammunition
 */
/obj/structure/closet/ammunitionlocker
	name = "аммуниция"

/obj/structure/closet/ammunitionlocker/PopulateContents()
	..()
	for(var/i in 1 to 8)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
