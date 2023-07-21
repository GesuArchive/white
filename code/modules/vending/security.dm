/obj/machinery/vending/security
	name = "Закон и порядок"
	desc = "Раздатчик инструментов для охраны."
	product_ads = "Раскалывай капиталистические черепа!;Забей несколько голов!;Не забывай - вред - это полезно!;Твое оружие прямо здесь.;Наручники!;Замри, отморозок!;Не трогай меня, братан! Почему бы не съесть пончик?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	light_mask = "sec-light-mask"
	req_access = list(ACCESS_SECURITY)
	products = list(
		/obj/item/restraints/handcuffs = 10,
		/obj/item/restraints/handcuffs/cable/zipties = 10,
		/obj/item/grenade/flashbang = 20,
		/obj/item/grenade/barbed_wire = 20,
		/obj/item/grenade/stingbang = 20,
		/obj/item/assembly/flash/handheld = 20,
		/obj/item/food/donut = 20,
		/obj/item/storage/box/evidence = 10,
		/obj/item/flashlight/seclite = 10,
		/obj/item/restraints/legcuffs/bola/energy = 10,
		/obj/item/book/manual/wiki/security_space_law = 5
		)
	contraband = list(
		/obj/item/clothing/glasses/sunglasses = 5,
		/obj/item/storage/fancy/donut_box = 5,
		)
	premium = list(
		/obj/item/storage/belt/security/webbing = 5,
		/obj/item/clothing/under/costume/jabroni/sec = 5,
		/obj/item/coin/antagtoken = 1,
		/obj/item/clothing/head/helmet/blueshirt = 1,
		/obj/item/clothing/suit/armor/vest/blueshirt = 1,
		/obj/item/clothing/gloves/tackler = 5,
		)
	refill_canister = /obj/item/vending_refill/security
	default_price = PAYCHECK_MEDIUM
	extra_price = PAYCHECK_HARD * 1.5
	payment_department = ACCOUNT_SEC

/obj/machinery/vending/security/pre_throw(obj/item/I)
	if(istype(I, /obj/item/grenade))
		var/obj/item/grenade/G = I
		G.arm_grenade()
	else if(istype(I, /obj/item/flashlight))
		var/obj/item/flashlight/F = I
		F.on = TRUE
		F.update_brightness()

/obj/item/vending_refill/security
	machine_name = "Закон и порядок"
	icon_state = "refill_sec"
