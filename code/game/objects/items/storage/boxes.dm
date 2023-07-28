/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *		Action Figure Boxes
 *		Various paper bags.
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/storage/box
	name = "коробка"
	desc = "Просто обычная коробка."
	icon_state = "box"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/cardboardbox_drop.ogg'
	pickup_sound =  'sound/items/handling/cardboardbox_pickup.ogg'
	var/foldable = /obj/item/stack/sheet/cardboard
	var/illustration = "writing"

/obj/item/storage/box/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/box/suicide_act(mob/living/carbon/user)
	var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
	if(myhead)
		inc_metabalance(user, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить и за это тоже, сладенький.")
		user.visible_message(span_suicide("[user] puts [user.ru_ego()] head into <b>[src.name]</b>, and begins closing it! It looks like [user.p_theyre()] trying to commit suicide!"))
		myhead.dismember()
		myhead.forceMove(src)//force your enemies to kill themselves with your head collection box!
		playsound(user, "desecration-01.ogg", 50, TRUE, -1)
		return BRUTELOSS
	user.visible_message(span_suicide("[user] beating [user.ru_na()]self with <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/storage/box/update_overlays()
	. = ..()
	if(illustration)
		. += illustration

/obj/item/storage/box/attack_self(mob/user)
	..()

	if(!foldable || (flags_1 & HOLOGRAM_1))
		return
	if(contents.len)
		to_chat(user, span_warning("Не могу сложить коробку с предметами внутри!"))
		return
	if(!ispath(foldable))
		return

	to_chat(user, span_notice("Складываю [src]."))
	var/obj/item/I = new foldable
	qdel(src)
	user.put_in_hands(I)

/obj/item/storage/box/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/package_wrap))
		return FALSE
	return ..()

//Mime spell boxes

/obj/item/storage/box/mime
	name = "невидимая коробка"
	desc = "К сожалению, недостаточно большая, чтобы поймать мима."
	foldable = null
	icon_state = "box"
	inhand_icon_state = null
	alpha = 0

/obj/item/storage/box/mime/attack_hand(mob/user)
	..()
	if(user.mind.miming)
		alpha = 255

/obj/item/storage/box/mime/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	if (iscarbon(old_loc))
		alpha = 0
	return ..()

//Disk boxes

/obj/item/storage/box/disks
	name = "коробка для дискет"
	illustration = "disk_kit"

/obj/item/storage/box/disks/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/disk/data(src)

/obj/item/storage/box/disks_plantgene
	name = "коробка для дисков с ДНК растений"
	illustration = "disk_kit"

/obj/item/storage/box/disks_plantgene/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/disk/plantgene(src)

/obj/item/storage/box/disks_nanite
	name = "коробка для дисков с программами для нанитов"
	illustration = "disk_kit"

/obj/item/storage/box/disks_nanite/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/disk/nanite_program(src)

// Ordinary survival box
/obj/item/storage/box/survival
	var/mask_type = /obj/item/clothing/mask/breath/cheap
	var/internal_type = /obj/item/tank/internals/emergency_oxygen
	var/medipen_type = /obj/item/reagent_containers/hypospray/medipen
	var/bottle_type = /obj/item/reagent_containers/food/drinks/waterbottle/large
	var/emergency_shield_type = /obj/item/emergency_shield

/obj/item/storage/box/survival/PopulateContents()
	new mask_type(src)
	if(!isnull(medipen_type))
		new medipen_type(src)

	if(!isplasmaman(loc))
		new internal_type(src)
	else
		new /obj/item/tank/internals/plasmaman/belt(src)
	new emergency_shield_type(src)
	new bottle_type(src)

/obj/item/storage/box/survival/radio/PopulateContents()
	..() // we want the survival stuff too.
	new /obj/item/radio/off(src)

/obj/item/storage/box/survival/proc/wardrobe_removal()
	if(!isplasmaman(loc)) //We need to specially fill the box with plasmaman gear, since it's intended for one
		return
	var/obj/item/mask = locate(mask_type) in src
	var/obj/item/internals = locate(internal_type) in src
	new /obj/item/tank/internals/plasmaman/belt(src)
	qdel(mask) // Get rid of the items that shouldn't be
	qdel(internals)


// Mining survival box
/obj/item/storage/box/survival/mining
	mask_type = /obj/item/clothing/mask/gas/explorer

/obj/item/storage/box/survival/mining/PopulateContents()
	..()
	new /obj/item/crowbar/red(src)

// Engineer survival box
/obj/item/storage/box/survival/engineer
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi

/obj/item/storage/box/survival/engineer/radio/PopulateContents()
	..() // we want the regular items too.
	new /obj/item/radio/off(src)

// Syndie survival box
/obj/item/storage/box/survival/syndie
	mask_type = /obj/item/clothing/mask/gas/syndicate
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi
	medipen_type = null

// Security survival box
/obj/item/storage/box/survival/security
	mask_type = /obj/item/clothing/mask/gas/sechailer

/obj/item/storage/box/survival/security/radio/PopulateContents()
	..() // we want the regular stuff too
	new /obj/item/radio/off(src)

// Medical survival box
/obj/item/storage/box/survival/medical
	mask_type = /obj/item/clothing/mask/breath/medical

// Intern survival box
/obj/item/storage/box/survival/intern
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi
	emergency_shield_type = /obj/item/emergency_shield/adv

/obj/item/storage/box/survival/intern/PopulateContents()
	..()
	var/burg = pick(subtypesof(/obj/item/food/burger))
	new burg(src)
	new /obj/item/stack/medical/suture(src)
	new /obj/item/stack/medical/mesh(src)

/obj/item/storage/box/gloves
	name = "коробка латексных перчаток"
	desc = "Содержит стерильные латексные перчатки."
	illustration = "latex"

/obj/item/storage/box/gloves/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/gloves/color/latex(src)

/obj/item/storage/box/masks
	name = "коробка стерильных масок"
	desc = "В этой коробке находятся стерильные медицинские маски."
	illustration = "sterile"

/obj/item/storage/box/masks/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/mask/surgical(src)

/obj/item/storage/box/syringes
	name = "коробка шприцев"
	desc = "Коробка со шприцами."
	illustration = "syringe"

/obj/item/storage/box/syringes/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/syringe(src)

/obj/item/storage/box/syringes/variety
	name = "коробка разнообразных шприцов"

/obj/item/storage/box/syringes/variety/PopulateContents()
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/syringe/lethal(src)
	new /obj/item/reagent_containers/syringe/piercing(src)
	new /obj/item/reagent_containers/syringe/bluespace(src)

/obj/item/storage/box/medipens
	name = "коробка медипенов"
	desc = "Коробка, полная адреналином медипенов."
	illustration = "epipen"

/obj/item/storage/box/medipens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/hypospray/medipen(src)

/obj/item/storage/box/medipens/utility
	name = "набор стимуляторов"
	desc = "Коробка с несколькими стимуляторами для экономичного шахтёра."
	illustration = "epipen"

/obj/item/storage/box/medipens/utility/PopulateContents()
	..() // includes regular medipens.
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/hypospray/medipen/stimpack(src)

/obj/item/storage/box/beakers
	name = "коробка химических стаканов"
	illustration = "beaker"

/obj/item/storage/box/beakers/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/glass/beaker( src )

/obj/item/storage/box/beakers/bluespace
	name = "коробка блюспейс химических стаканов"
	illustration = "beaker"

/obj/item/storage/box/beakers/bluespace/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/glass/beaker/bluespace(src)

/obj/item/storage/box/beakers/variety
	name = "коробка различных химических стаканов"

/obj/item/storage/box/beakers/variety/PopulateContents()
	new /obj/item/reagent_containers/glass/beaker(src)
	new /obj/item/reagent_containers/glass/beaker/large(src)
	new /obj/item/reagent_containers/glass/beaker/plastic(src)
	new /obj/item/reagent_containers/glass/beaker/meta(src)
	new /obj/item/reagent_containers/glass/beaker/noreact(src)
	new /obj/item/reagent_containers/glass/beaker/bluespace(src)

/obj/item/storage/box/medigels
	name = "коробка аэрозолей"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля."
	illustration = "medgel"

/obj/item/storage/box/medigels/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/medigel( src )

/obj/item/storage/box/injectors
	name = "коробка ДНК инъекторов"
	desc = "В этой коробке, кажется, находятся инъекторы."
	illustration = "dna"

/obj/item/storage/box/injectors/PopulateContents()
	var/static/items_inside = list(
		/obj/item/dnainjector/h2m = 3,
		/obj/item/dnainjector/m2h = 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/flashbangs
	name = "коробка светошумовых гранат"
	desc = "<B>ВНИМАНИЕ: Гранаты чрезвычайно опасны и могут вызвать слепоту или глухоту при многократном использовании.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/flashbangs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/flashbang(src)

/obj/item/storage/box/stingbangs
	name = "коробка травматических гранат"
	desc = "<B>ВНИМАНИЕ: Гранаты чрезвычайно опасны и могут привести к тяжелым травмам или смерти при повторном использовании.</B>"
	icon_state = "secbox"
	illustration = "stingbangs"

/obj/item/storage/box/stingbangs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/box/flashes
	name = "коробка вспышек"
	desc = "<B>ВНИМАНИЕ: Вспышки могут вызвать серьезные повреждения глаз, необходимо использовать защитные очки.</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/flashes/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/flash/handheld(src)

/obj/item/storage/box/wall_flash
	name = "комплект настенной вспышки"
	desc = "Эта коробка содержит все необходимое для создания настенной вспышки. <B> ВНИМАНИЕ: Вспышки могут вызвать серьезные повреждения глаз, необходимо использовать защитные очки.</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/wall_flash/PopulateContents()
	var/id = rand(1000, 9999)
	// FIXME what if this conflicts with an existing one?

	new /obj/item/wallframe/button(src)
	new /obj/item/electronics/airlock(src)
	var/obj/item/assembly/control/flasher/remote = new(src)
	remote.id = id
	var/obj/item/wallframe/flasher/frame = new(src)
	frame.id = id
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/screwdriver(src)

/obj/item/storage/box/energy_bola
	name = "энергобола"
	desc = "Специализированные бола сплетенная из волокон жесткого света, предназначенная для ловли убегающих преступников и помощи в арестах."
	icon_state = "secbox"

/obj/item/storage/box/energy_bola/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/legcuffs/bola/energy(src)

/obj/item/storage/box/teargas
	name = "ящик со слезоточивым газом"
	desc = "<B>ВНИМАНИЕ: Гранаты чрезвычайно опасны и могут вызвать слепоту и раздражение кожи.</B>"
	icon_state = "secbox"
	illustration = "teargas"

/obj/item/storage/box/teargas/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/teargas(src)

/obj/item/storage/box/emps
	name = "коробка с ЭМИ гранатами"
	desc = "Простая коробка с 5 ЭМИ гранатами."
	illustration = "emp"

/obj/item/storage/box/emps/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/empgrenade(src)

/obj/item/storage/box/trackimp
	name = "комплект отслеживающих имплантов"
	desc = "Коробка с приспособлениями для отслеживания подонков."
	icon_state = "secbox"
	illustration = "implant"

/obj/item/storage/box/trackimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/tracking = 5,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/minertracker
	name = "комплект отслеживающих имплантов"
	desc = "Для поиска погибших в проклятом мире Лаваленда."
	illustration = "implant"

/obj/item/storage/box/minertracker/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/tracking = 3,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/chemimp
	name = "комплект химических имплантов"
	desc = "Коробка с вещами, используемыми для имплантации химикатов."
	illustration = "implant"

/obj/item/storage/box/chemimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/chem = 5,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/exileimp
	name = "набор имплантатов для изгнания"
	desc = "Коробка с набором имплантатов для изгнания. На нем есть изображение клоуна, которого выкидывают через Врата."
	illustration = "implant"

/obj/item/storage/box/exileimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/exile = 5,
		/obj/item/implanter = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/bodybags
	name = "сумки для тела"
	desc = "На этикетке указано, что он содержит мешки для тела."
	illustration = "bodybags"

/obj/item/storage/box/bodybags/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/bodybag(src)

/obj/item/storage/box/rxglasses
	name = "коробка очков по рецепту"
	desc = "В этой коробке находятся очки для ботаников."
	illustration = "glasses"

/obj/item/storage/box/rxglasses/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/glasses/regular(src)

/obj/item/storage/box/drinkingglasses
	name = "коробка стаканов"
	desc = "На ней изображены стаканы."
	illustration = "drinkglass"

/obj/item/storage/box/drinkingglasses/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/drinks/drinkingglass(src)

/obj/item/storage/box/condimentbottles
	name = "коробка бутылок для приправ"
	desc = "На нем большой мазок кетчупа."
	illustration = "condiment"

/obj/item/storage/box/condimentbottles/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/condiment(src)

/obj/item/storage/box/cups
	name = "коробка бумажных стаканчиков"
	desc = "На лицевой стороне изображены бумажные стаканчики."
	illustration = "cup"

/obj/item/storage/box/cups/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/food/drinks/sillycup( src )

/obj/item/storage/box/donkpockets
	name = "коробка донк-покетов"
	desc = "<B>Инструкция:</B><I>Нагрейте в микроволновой печи. Продукт остынет, если его не съесть в течение семи минут.</I>"
	icon_state = "donkpocketbox"
	illustration = null
	var/donktype = /obj/item/food/donkpocket

/obj/item/storage/box/donkpockets/PopulateContents()
	for(var/i in 1 to 6)
		new donktype(src)

/obj/item/storage/box/donkpockets/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/donkpocket))

/obj/item/storage/box/donkpockets/donkpocketspicy
	name = "коробка донк-покетов с пряным вкусом"
	icon_state = "donkpocketboxspicy"
	donktype = /obj/item/food/donkpocket/spicy

/obj/item/storage/box/donkpockets/donkpocketteriyaki
	name = "коробка донк-покетов со вкусом терияки"
	icon_state = "donkpocketboxteriyaki"
	donktype = /obj/item/food/donkpocket/teriyaki

/obj/item/storage/box/donkpockets/donkpocketpizza
	name = "коробка донк-покетов со вкусом пиццы"
	icon_state = "donkpocketboxpizza"
	donktype = /obj/item/food/donkpocket/pizza

/obj/item/storage/box/donkpockets/donkpocketgondola
	name = "коробка донк-покетов со вкусом гондолы"
	icon_state = "donkpocketboxgondola"
	donktype = /obj/item/food/donkpocket/gondola

/obj/item/storage/box/donkpockets/donkpocketberry
	name = "коробка донк-покетов со вкусом ягод"
	icon_state = "donkpocketboxberry"
	donktype = /obj/item/food/donkpocket/berry

/obj/item/storage/box/donkpockets/donkpockethonk
	name = "коробка донк-покетов со вкусом банана"
	icon_state = "donkpocketboxbanana"
	donktype = /obj/item/food/donkpocket/honk

/obj/item/storage/box/monkeycubes
	name = "коробка кубиков с обезьянами"
	desc = "Кубики обезьяны бренда Drymate. Просто добавь воды!"
	icon_state = "monkeycubebox"
	illustration = null
	var/cube_type = /obj/item/food/monkeycube

/obj/item/storage/box/monkeycubes/Initialize()
	. = ..()
	atom_storage.max_slots = 7
	atom_storage.set_holdable(list(/obj/item/food/monkeycube))

/obj/item/storage/box/monkeycubes/PopulateContents()
	for(var/i in 1 to 5)
		new cube_type(src)

/obj/item/storage/box/monkeycubes/syndicate
	desc = "Обезьяньи кубики марки Waffle Co. Просто добавьте воды и немного уловок!"
	cube_type = /obj/item/food/monkeycube/syndicate

/obj/item/storage/box/gorillacubes
	name = "коробка куба гориллы"
	desc = "Кубики гориллы бренда Waffle Co. Не насмехайтесь."
	icon_state = "monkeycubebox"
	illustration = null

/obj/item/storage/box/gorillacubes/Initialize()
	. = ..()
	atom_storage.max_slots = 3
	atom_storage.set_holdable(list(/obj/item/food/monkeycube))

/obj/item/storage/box/gorillacubes/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/food/monkeycube/gorilla(src)

/obj/item/storage/box/ids
	name = "коробка запасных идентификаторов"
	desc = "В нём так много пустых идентификаторов."
	illustration = "id"

/obj/item/storage/box/ids/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id/advanced(src)

//Some spare PDAs in a box
/obj/item/storage/box/pdas
	name = "Коробка запасных картриджей ПДА"
	desc = "Коробка запасных картриджей ПДА."
	illustration = "pda"

/obj/item/storage/box/pdas/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/modular_computer/tablet/pda(src)

/obj/item/storage/box/silver_ids
	name = "коробка запасных серебряных удостоверений"
	desc = "Блестящие идентификаторы для важных людей."
	illustration = "id"

/obj/item/storage/box/silver_ids/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id/advanced/silver(src)

/obj/item/storage/box/prisoner
	name = "коробка с идентификаторами для заключенных"
	desc = "Лишите их последнего клочка достоинства - их имени."
	icon_state = "secbox"
	illustration = "id"

/obj/item/storage/box/prisoner/PopulateContents()
	..()
	new /obj/item/card/id/advanced/prisoner/one(src)
	new /obj/item/card/id/advanced/prisoner/two(src)
	new /obj/item/card/id/advanced/prisoner/three(src)
	new /obj/item/card/id/advanced/prisoner/four(src)
	new /obj/item/card/id/advanced/prisoner/five(src)
	new /obj/item/card/id/advanced/prisoner/six(src)
	new /obj/item/card/id/advanced/prisoner/seven(src)

/obj/item/storage/box/seccarts
	name = "коробка картриджей безопасности для ПДА"
	desc = "Коробка, полная картриджей для ПДА, используемых службой безопасности."
	icon_state = "secbox"
	illustration = "pda"

/obj/item/storage/box/seccarts/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/computer_disk/security(src)

/obj/item/storage/box/firingpins
	name = "коробка штатных бойков"
	desc = "Коробка со стандартными бойками для стрельбы из нового огнестрельного оружия."
	icon_state = "secbox"
	illustration = "firingpin"

/obj/item/storage/box/firingpins/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/firing_pin(src)

/obj/item/storage/box/firingpins/paywall
	name = "коробка с платными бойками"
	desc = "Слыш. Плати"
	illustration = "firingpin"

/obj/item/storage/box/firingpins/paywall/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/firing_pin/paywall(src)

/obj/item/storage/box/firingpins/off_station
	name = "коробка с внестанционными ударниками"
	desc = "Разрешает стрелять из пушек, когда пушки не на станции. Полезно."
	illustration = "firingpin"

/obj/item/storage/box/firingpins/off_station/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/firing_pin/off_station(src)

/obj/item/storage/box/lasertagpins
	name = "ящик  бойков для лазертага"
	desc = "Коробка, полная бойков для лазертага, чтобы новое огнестрельное оружие требовало ношения яркой пластиковой брони, прежде чем его можно будет использовать."
	illustration = "firingpin"

/obj/item/storage/box/lasertagpins/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/firing_pin/tag/red(src)
		new /obj/item/firing_pin/tag/blue(src)

/obj/item/storage/box/flare
	name = "коробка с осветительным инвентарем"
	desc = "коробка с сигнальными шашками и фонариком."
	icon_state = "secbox"

/obj/item/storage/box/flare/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/flashlight/flare(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/flashlight/seclite(src)

/obj/item/storage/box/handcuffs
	name = "коробка запасных наручников"
	desc = "коробка запасных наручников."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/handcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs(src)

/obj/item/storage/box/zipties
	name = "коробка запасных стяжек"
	desc = "коробка запасных стяжек."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/zipties/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/cable/zipties(src)

/obj/item/storage/box/alienhandcuffs
	name = "коробка запасных наручников"
	desc = "коробка запасных наручников."
	icon_state = "alienbox"
	illustration = "handcuff"

/obj/item/storage/box/alienhandcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new	/obj/item/restraints/handcuffs/alien(src)

/obj/item/storage/box/fakesyndiesuit
	name = "упакованные скафандр и шлем"
	desc = "Гладкая и прочная коробка, в которой хранятся копии скафандров."
	icon_state = "syndiebox"
	illustration = "syndiesuit"

/obj/item/storage/box/fakesyndiesuit/PopulateContents()
	new /obj/item/clothing/head/syndicatefake(src)
	new /obj/item/clothing/suit/syndicatefake(src)

/obj/item/storage/box/mousetraps
	name = "коробка мышеловок Pest-B-Gon"
	desc = span_alert("Храните в недоступном для детей месте.")
	illustration = "mousetrap"

/obj/item/storage/box/mousetraps/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/mousetrap(src)

/obj/item/storage/box/pillbottles
	name = "коробка с баночками для таблеток"
	desc = "На передней панели изображены пузырьки с таблетками."
	illustration = "pillbox"

/obj/item/storage/box/pillbottles/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/storage/pill_bottle(src)

/obj/item/storage/box/pillbottlesbig
	name = "коробка с большими баночками для таблеток"
	desc = "На передней панели изображены большие пузырьки с таблетками."
	illustration = "pillbox"

/obj/item/storage/box/pillbottlesbig/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/storage/pill_bottle/big(src)

/obj/item/storage/box/snappops
	name = "коробка бахающих фантиков"
	desc = "Восемь фантиков веселья! От 8 лет и старше. Не подходит для детей."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"

/obj/item/storage/box/snappops/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/toy/snappop))
	atom_storage.max_slots = 8

/obj/item/storage/box/snappops/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/matches
	name = "спичечный коробок"
	desc = "Маленькая коробочка Почти, Но Не Совсем Плазменных Премиальных Спичек."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	inhand_icon_state = "zippo"
	worn_icon_state = "lighter"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	drop_sound = 'sound/items/handling/matchbox_drop.ogg'
	pickup_sound =  'sound/items/handling/matchbox_pickup.ogg'
	custom_price = PAYCHECK_ASSISTANT * 0.4
	illustration = null

/obj/item/storage/box/matches/Initialize()
	. = ..()
	atom_storage.max_slots = 10
	atom_storage.set_holdable(list(/obj/item/match))

/obj/item/storage/box/matches/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/match(src)

/obj/item/storage/box/matches/attackby(obj/item/match/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/match))
		W.matchignite()

/obj/item/storage/box/lights
	name = "коробка сменных лампочек"
	icon = 'icons/obj/storage.dmi'
	illustration = "light"
	desc = "Эта коробка имеет такую форму, что туда вмещаются только лампочки и лампы накаливания."
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap

/obj/item/storage/box/lights/Initialize()
	. = ..()
	atom_storage.max_slots = 21
	atom_storage.set_holdable(list(/obj/item/light/tube, /obj/item/light/bulb))
	atom_storage.max_total_storage = 21
	atom_storage.allow_quick_gather = FALSE //temp workaround to re-enable filling the light replacer with the box

/obj/item/storage/box/lights/bulbs/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/item/light/bulb(src)

/obj/item/storage/box/lights/tubes
	name = "коробка ламп дневного света "
	illustration = "lighttube"

/obj/item/storage/box/lights/tubes/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/item/light/tube(src)

/obj/item/storage/box/lights/mixed
	name = "коробка сменных ламп"
	illustration = "lightmixed"

/obj/item/storage/box/lights/mixed/PopulateContents()
	for(var/i in 1 to 14)
		new /obj/item/light/tube(src)
	for(var/i in 1 to 7)
		new /obj/item/light/bulb(src)

/obj/item/storage/box/autobuild_lights
	name = "анкерные каркасы больших ламп"
	desc = "Используется для быстрого монтажа каркаса и подключения проводки. Лампочка в комплект не входит."
	illustration = "lighttube"

/obj/item/storage/box/autobuild_lights/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/wallframe/autobuild(src)

/obj/item/storage/box/autobuild_lights/small
	name = "анкерные каркасы маленьких ламп"
	desc = "Используется для быстрого монтажа каркаса и подключения проводки. Лампочка в комплект не входит."
	illustration = "light"

/obj/item/storage/box/autobuild_lights/small/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/wallframe/autobuild/small(src)

/obj/item/storage/box/deputy
	name = "коробка с повязками Службы Безопасности"
	desc = "Выдается лицам, уполномоченным действовать в качестве работника службы безопасности."
	icon_state = "secbox"
	illustration = "depband"

/obj/item/storage/box/deputy/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/accessory/armband/deputy(src)

/obj/item/storage/box/metalfoam
	name = "коробка с гранатами с металлопеной"
	desc = "Используется для быстрого закрытия пробоин в корпусе."
	illustration = "metalfoam"

/obj/item/storage/box/metalfoam/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/metalfoam(src)

/obj/item/storage/box/resin_foam
	name = "коробка с противопожарными гранатами"
	desc = "Используется для быстрого тушения пожаров."
	illustration = "resin_foam"

/obj/item/storage/box/resin_foam/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/resin_foam(src)

/obj/item/storage/box/cleaner
	name = "коробка с очистительными гранатами"
	desc = "Убер граната от компании Космочист. Является товарной маркой - все права защищены."
	illustration = "cleaner"

/obj/item/storage/box/cleaner/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/cleaner(src)


/obj/item/storage/box/lube
	name = "коробка с скользкими гранатами"
	desc = "Граната созданная лучшими учеными Хонк Ко в качестве протеста против военных преступлений компании Космочист."
	illustration = "clown"

/obj/item/storage/box/lube/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/lube(src)

/obj/item/storage/box/smart_metal_foam
	name = "коробка умных гранат из металлопены"
	desc = "Используется для быстрой заделки пробоин в корпусе. Эта разновидность соответствует стенам своего участка."
	illustration = "grenade"

/obj/item/storage/box/smart_metal_foam/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/smart_metal_foam(src)

/obj/item/storage/box/hug
	name = "коробка объятий"
	desc = "Специальная коробка для чувствительных людей."
	gender = FEMALE
	icon_state = "hugbox"
	illustration = "heart"
	foldable = null

/obj/item/storage/box/hug/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] clamps the box of hugs on [user.ru_ego()] jugular! Guess it wasn't such a hugbox after all.."))
	return (BRUTELOSS)

/obj/item/storage/box/hug/attack_self(mob/user)
	..()
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, "rustle", 50, TRUE, -5)
	user.visible_message(span_notice("[user] обнимает <b>[skloname(name, VINITELNI, gender)]</b>.") ,span_notice("Обнимаю <b>[skloname(name, VINITELNI, gender)]</b>."))

/////clown box & honkbot assembly
/obj/item/storage/box/clown
	name = "коробка клоуна"
	desc = "Красочная картонная коробка для клоуна"
	illustration = "clown"

/obj/item/storage/box/clown/attackby(obj/item/I, mob/user, params)
	if((istype(I, /obj/item/bodypart/l_arm/robot)) || (istype(I, /obj/item/bodypart/r_arm/robot)))
		if(contents.len) //prevent accidently deleting contents
			to_chat(user, span_warning("Нужно опустошить [src] сначала!"))
			return
		if(!user.temporarilyRemoveItemFromInventory(I))
			return
		qdel(I)
		to_chat(user, span_notice("Добавляю колёса для [src]! Теперь у меня есть сборка хонкбота! Хонк!"))
		var/obj/item/bot_assembly/honkbot/A = new
		qdel(src)
		user.put_in_hands(A)
	else
		return ..()

//////
/obj/item/storage/box/hug/medical/PopulateContents()
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)

// Clown survival box
/obj/item/storage/box/hug/survival/PopulateContents()
	new /obj/item/clothing/mask/breath/cheap(src)
	new /obj/item/tank/internals/emergency_oxygen(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)
	new /obj/item/reagent_containers/food/drinks/waterbottle/large(src)
	new /obj/item/emergency_shield(src)

	if(!isplasmaman(loc))
		new /obj/item/tank/internals/emergency_oxygen(src)
	else
		new /obj/item/tank/internals/plasmaman/belt(src)

////////////Ружейные коробки
/obj/item/storage/box/beanbag
	name = "12 Калибр: Резиновая пуля - 20 шт."
	desc = "Коробка с травматическими пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/beanbag/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/beanbag/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/storage/box/rubbershot
	name = "12 Калибр: Резиновая картечь - 20 шт."
	desc = "Коробка с резиновой картечью 12 калибра, предназначенными для дробовиков."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/rubbershot/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/rubbershot/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun/rubbershot(src)

/obj/item/storage/box/s12_bullet
	name = "12 Калибр: Пулевой - 20 шт."
	desc = "Коробка с боевыми пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/s12_bullet/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/s12_bullet/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun(src)

/obj/item/storage/box/lethalshot
	name = "12 Калибр: Картечь - 20 шт."
	desc = "Коробка с патронами 12 калибра с дробью."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/lethalshot/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/lethalshot/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/box/battle_incendiary
	name = "12 Калибр: Зажигательный - 20 шт."
	desc = "Коробка с зажигательными пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/battle_incendiary/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/battle_incendiary/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun/incendiary(src)

/obj/item/storage/box/battle_dart
	name = "12 Калибр: Дротик - 20 шт."
	desc = "Коробка с химическими пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/battle_dart/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/battle_dart/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun/dart(src)

/obj/item/storage/box/battle_stunslug
	name = "12 Калибр: Электрошок - 20 шт."
	desc = "Коробка с парализующими пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/battle_stunslug/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/battle_stunslug/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun/stunslug(src)

/obj/item/storage/box/battle_techshell
	name = "12 Калибр: Высокотехнологичные - 20 шт."
	desc = "Коробка с зажигательными пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/battle_techshell/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/battle_techshell/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun/techshell(src)

/obj/item/storage/box/battle_pulverizer
	name = "12 Калибр: Увечащие - 20 шт."
	desc = "Коробка с травмирующими пулями 12 калибра, предназначенными для дробовиков."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/battle_pulverizer/Initialize()
	. = ..()
	atom_storage.max_slots = 20
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/ammo_casing/shotgun))
	atom_storage.max_total_storage = 20

/obj/item/storage/box/battle_pulverizer/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/ammo_casing/shotgun/pulverizer(src)

//////////////////////

/obj/item/storage/box/actionfigure
	name = "коробка фигурок"
	desc = "Последний набор коллекционных фигурок."
	icon_state = "box"

/obj/item/storage/box/actionfigure/PopulateContents()
	for(var/i in 1 to 4)
		var/randomFigure = pick(subtypesof(/obj/item/toy/figure))
		new randomFigure(src)

/obj/item/storage/box/papersack
	name = "бумажный мешок"
	desc = "Мешочек, аккуратно сделанный из бумаги."
	icon_state = "paperbag_None"
	inhand_icon_state = "paperbag_None"
	illustration = null
	resistance_flags = FLAMMABLE
	foldable = null
	/// A list of all available papersack reskins
	var/list/papersack_designs = list()

/obj/item/storage/box/papersack/Initialize(mapload)
	. = ..()
	papersack_designs = sort_list(list(
		"None" = image(icon = src.icon, icon_state = "paperbag_None"),
		"NanotrasenStandard" = image(icon = src.icon, icon_state = "paperbag_NanotrasenStandard"),
		"SyndiSnacks" = image(icon = src.icon, icon_state = "paperbag_SyndiSnacks"),
		"Heart" = image(icon = src.icon, icon_state = "paperbag_Heart"),
		"SmileyFace" = image(icon = src.icon, icon_state = "paperbag_SmileyFace")
		))

/obj/item/storage/box/papersack/update_icon_state()
	. = ..()
	if(contents.len == 0)
		icon_state = "[inhand_icon_state]"
	else
		icon_state = "[inhand_icon_state]_closed"

/obj/item/storage/box/papersack/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		var/choice = show_radial_menu(user, src , papersack_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user, W), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		if(icon_state == "paperbag_[choice]")
			return FALSE
		switch(choice)
			if("None")
				desc = "Мешок, аккуратно сделанный из бумаги."
			if("NanotrasenStandard")
				desc = "Стандартный бумажный обеденный мешок NanoTrasen для лояльных сотрудников в дороге."
			if("SyndiSnacks")
				desc = "Дизайн этого бумажного пакета - пережиток печально известной программы СиндиЗакуски.."
			if("Heart")
				desc = "Бумажный мешок с выгравированным на боку сердечком."
			if("SmileyFace")
				desc = "Бумажный мешок с грубой улыбкой на боку."
			else
				return FALSE
		to_chat(user, span_notice("Видоизменяю [src] используя ручку."))
		icon_state = "paperbag_[choice]"
		inhand_icon_state = "paperbag_[choice]"
		return FALSE
	else if(W.get_sharpness())
		if(!contents.len)
			if(inhand_icon_state == "paperbag_None")
				user.show_message(span_notice("Прорезаю дыры для глаз [src].") , MSG_VISUAL)
				new /obj/item/clothing/head/papersack(user.loc)
				qdel(src)
				return FALSE
			else if(inhand_icon_state == "paperbag_SmileyFace")
				user.show_message(span_notice("Прорезаю дыры для глаз в [src] и меняю его дизайн.") , MSG_VISUAL)
				new /obj/item/clothing/head/papersack/smiley(user.loc)
				qdel(src)
				return FALSE
	return ..()

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 * * P The pen used to interact with a menu
 */
/obj/item/storage/box/papersack/proc/check_menu(mob/user, obj/item/pen/P)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(contents.len)
		to_chat(user, span_warning("Не могу изменить [src] с предметами внутри!"))
		return FALSE
	if(!P || !user.is_holding(P))
		to_chat(user, span_warning("Мне понадобится ручка, чтобы изменить [src]!"))
		return FALSE
	return TRUE

/obj/item/storage/box/papersack/meat
	desc = "Он немного влажный и воняет бойней."

/obj/item/storage/box/papersack/meat/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/food/meat/slab(src)

/obj/item/storage/box/emptysandbags
	name = "коробка пустых мешков с песком"
	illustration = "sandbag"

/obj/item/storage/box/emptysandbags/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/emptysandbag(src)

/obj/item/storage/box/rndboards
	name = "наследие освободителя"
	desc = "Коробка с подарком для достойных големов."
	illustration = "scicircuit"

/obj/item/storage/box/rndboards/PopulateContents()
	new /obj/item/circuitboard/machine/protolathe(src)
	new /obj/item/circuitboard/machine/destructive_analyzer(src)
	new /obj/item/circuitboard/machine/circuit_imprinter(src)
	new /obj/item/circuitboard/computer/rdconsole(src)

/obj/item/storage/box/silver_sulf
	name = "коробка пластырей сульфадиазина серебра"
	desc = "Содержит пластыри, используемые для лечения ожогов."
	illustration = "firepatch"

/obj/item/storage/box/silver_sulf/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/patch/aiuri(src)

/obj/item/storage/box/fountainpens
	name = "коробка перьевых ручек"
	illustration = "fpen"

/obj/item/storage/box/fountainpens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/pen/fountain(src)

/obj/item/storage/box/holy_grenades
	name = "коробка священных гранат"
	desc = "Содержит несколько гранат, используемых для быстрого избавления от ереси."
	illustration = "grenade"

/obj/item/storage/box/holy_grenades/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/holy(src)

/obj/item/storage/box/holy_pena_grenades
	name = "освящающая граната"
	desc = "Граната для быстрого освящения больших помещений."
	illustration = "grenade"

/obj/item/storage/box/holy_pena_grenades/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/holy_pena(src)

/obj/item/storage/box/stockparts/basic //for ruins where it's a bad idea to give access to an autolathe/protolathe, but still want to make stock parts accessible
	name = "коробка запасных частей"
	desc = "Содержит множество основных запасных частей."

/obj/item/storage/box/stockparts/basic/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/scanning_module = 3,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stock_parts/matter_bin = 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/stockparts/deluxe
	name = "коробка роскошных запасных частей"
	desc = "Содержит множество роскошных запасных частей."
	icon_state = "syndiebox"

/obj/item/storage/box/stockparts/deluxe/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stock_parts/capacitor/quadratic = 3,
		/obj/item/stock_parts/scanning_module/triphasic = 3,
		/obj/item/stock_parts/manipulator/femto = 3,
		/obj/item/stock_parts/micro_laser/quadultra = 3,
		/obj/item/stock_parts/matter_bin/bluespace = 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/dishdrive
	name = "комплект утилизатора тарелок"
	desc = "Содержит детали длям ашины, которая использует преобразование вещества в энергию для хранения посуды и осколков. Удобно!"
	custom_premium_price = PAYCHECK_EASY * 3

/obj/item/storage/box/dishdrive/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stack/sheet/iron/five = 1,
		/obj/item/stack/cable_coil/five = 1,
		/obj/item/circuitboard/machine/dish_drive = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/material
	name = "коробка с материалами"
	illustration = "implant"

/obj/item/storage/box/material/PopulateContents() 	//less uranium because radioactive
	var/static/items_inside = list(
		/obj/item/stack/sheet/iron/fifty=1,\
		/obj/item/stack/sheet/glass/fifty=1,\
		/obj/item/stack/sheet/rglass=50,\
		/obj/item/stack/sheet/plasmaglass=50,\
		/obj/item/stack/sheet/titaniumglass=50,\
		/obj/item/stack/sheet/plastitaniumglass=50,\
		/obj/item/stack/sheet/plasteel=50,\
		/obj/item/stack/sheet/mineral/plastitanium=50,\
		/obj/item/stack/sheet/mineral/titanium=50,\
		/obj/item/stack/sheet/mineral/gold=50,\
		/obj/item/stack/sheet/mineral/silver=50,\
		/obj/item/stack/sheet/mineral/plasma=50,\
		/obj/item/stack/sheet/mineral/uranium=20,\
		/obj/item/stack/sheet/mineral/diamond=50,\
		/obj/item/stack/sheet/bluespace_crystal=50,\
		/obj/item/stack/sheet/mineral/bananium=50,\
		/obj/item/stack/sheet/mineral/wood=50,\
		/obj/item/stack/sheet/plastic/fifty=1,\
		/obj/item/stack/sheet/runed_metal/fifty=1
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/debugtools
	name = "ДЕБАГ КАРОБКА"
	icon_state = "syndiebox"

/obj/item/storage/box/debugtools/PopulateContents()
	var/static/items_inside = list(
		/obj/item/flashlight/emp/debug=1,\
		/obj/item/modular_computer/tablet/pda=1,\
		/obj/item/geiger_counter=1,\
		/obj/item/construction/rcd/combat/admin=1,\
		/obj/item/pipe_dispenser=1,\
		/obj/item/card/emag=1,\
		/obj/item/stack/spacecash/c1000=50,\
		/obj/item/healthanalyzer/advanced=1,\
		/obj/item/disk/tech_disk/debug=1,\
		/obj/item/uplink/debug=1,\
		/obj/item/uplink/nuclear/debug=1,\
		/obj/item/storage/box/beakers/bluespace=1,\
		/obj/item/storage/box/beakers/variety=1,\
		/obj/item/storage/box/material=1
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/plastic
	name = "пластиковая коробка"
	desc = "Прочная пластиковая коробка."
	icon_state = "plasticbox"
	foldable = null
	illustration = "writing"
	custom_materials = list(/datum/material/plastic = 1000) //You lose most if recycled.


/obj/item/storage/box/fireworks
	name = "коробка фейерверков"
	desc = "Содержит ассортимент фейерверков."
	illustration = "sparkler"

/obj/item/storage/box/fireworks/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	new /obj/item/toy/snappop(src)

/obj/item/storage/box/fireworks/dangerous

/obj/item/storage/box/fireworks/dangerous/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	if(prob(20))
		new /obj/item/grenade/frag(src)
	else
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/firecrackers
	name = "коробка петард"
	desc = "Коробка с нелегальной петардой. Вы задаетесь вопросом, кто до сих пор их делает."
	icon_state = "syndiebox"
	illustration = "firecracker"

/obj/item/storage/box/firecrackers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/firecracker(src)

/obj/item/storage/box/sparklers
	name = "коробка бенгальских огней"
	desc = "Коробка бенгальских огней марки НТ, горит даже в холод космической зимы."
	illustration = "sparkler"

/obj/item/storage/box/sparklers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/sparkler(src)

/obj/item/storage/box/gum
	name = "упаковка жевательной резинки"
	desc = "Видимо, упаковка полностью на японском языке. Вы не можете разобрать ни слова."
	icon_state = "bubblegum_generic"
	w_class = WEIGHT_CLASS_TINY
	illustration = null
	foldable = null
	custom_price = PAYCHECK_EASY

/obj/item/storage/box/gum/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/chewable/bubblegum))
	atom_storage.max_slots = 4

/obj/item/storage/box/gum/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/chewable/bubblegum(src)

/obj/item/storage/box/gum/nicotine
	name = "упаковка никотиновой жевательной резинки"
	desc = "Разработан, чтобы помочь избавиться от никотиновой зависимости и оральной фиксации одновременно, не разрушая при этом легкие. Со вкусом мяты!"
	icon_state = "bubblegum_nicotine"
	custom_premium_price = PAYCHECK_EASY * 1.5

/obj/item/storage/box/gum/nicotine/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/chewable/bubblegum/nicotine(src)

/obj/item/storage/box/gum/happiness
	name = "упаковка резинок HP +"
	desc = "Внешне самодельная упаковка со странным запахом. У него есть странный рисунок улыбающегося лица, высунувшего язык."
	icon_state = "bubblegum_happiness"
	custom_price = PAYCHECK_HARD * 3
	custom_premium_price = PAYCHECK_HARD * 3

/obj/item/storage/box/gum/happiness/Initialize(mapload)
	. = ..()
	if (prob(25))
		desc += "Можно смутно разобрать слово «Гемопагоприл», которое когда-то было нацарапано на нем."

/obj/item/storage/box/gum/happiness/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/chewable/bubblegum/happiness(src)

/obj/item/storage/box/gum/bubblegum
	name = "упаковка жевательной резинки"
	desc = "Упаковка, по всей видимости, полностью демоническая. Чувствую, что даже открыть это было бы грехом."
	icon_state = "bubblegum_bubblegum"

/obj/item/storage/box/gum/bubblegum/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/chewable/bubblegum/bubblegum(src)

/obj/item/storage/box/shipping
	name = "коробка припасов снабжения"
	desc = "Содержит несколько сканеров и этикетировщиков для транспортировки вещей. Упаковочная бумага в комплект не входит."
	illustration = "shipping"

/obj/item/storage/box/shipping/PopulateContents()
	var/static/items_inside = list(
		/obj/item/dest_tagger=1,\
		/obj/item/sales_tagger=1,\
		/obj/item/export_scanner=1,\
		/obj/item/stack/package_wrap/small=2,\
		/obj/item/stack/wrapping_paper/small=1
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/skillchips
	name = "коробка чипов навыков"
	desc = "Содержит по одной копии каждого чипа навыков"

/obj/item/storage/box/skillchips/PopulateContents()
	var/list/skillchips = subtypesof(/obj/item/skillchip)

	for(var/skillchip in skillchips)
		new skillchip(src)

/obj/item/storage/box/skillchips/science
	name = "коробка с чипами для научных работ"
	desc = "Содержит запасные чипы для всех научных работ."

/obj/item/storage/box/skillchips/science/PopulateContents()
	new /obj/item/skillchip/job/roboticist(src)
	new /obj/item/skillchip/job/roboticist(src)
	new /obj/item/skillchip/job/roboticist(src)

/obj/item/storage/box/skillchips/engineering
	name = "Коробка с чипами инженерных навыков"
	desc = "Содержит запасные чипы для всех технических навыков."

/obj/item/storage/box/skillchips/engineering/PopulateContents()
	new /obj/item/skillchip/job/engineer(src)
	new /obj/item/skillchip/job/engineer(src)
	new /obj/item/skillchip/job/engineer(src)

/obj/item/storage/box/skillchips/medic
	name = "Коробка с чипами медицинских навыков"
	desc = "Содержит запасные чипы для хирургических операций."

/obj/item/storage/box/skillchips/medic/PopulateContents()
	new /obj/item/skillchip/job/medic/advanced(src)
	new /obj/item/skillchip/job/medic/advanced(src)
	new /obj/item/skillchip/job/medic/advanced(src)

/obj/item/storage/box/swab
	name = "коробка микробиологических ватных дисков"
	desc = "Содержит несколько стерильных ватных дисков для взятия микробиологических проб."
	illustration = "swab"

/obj/item/storage/box/swab/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/swab(src)

/obj/item/storage/box/petridish
	name = "коробка чашек Петри"
	desc = "Якобы эта коробка содержит несколько чашек Петри с высоким ободком."
	illustration = "petridish"

/obj/item/storage/box/petridish/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/petri_dish(src)

/obj/item/storage/box/plumbing
	name = "ящик с сантехникой"
	desc = "Содержит небольшой запас труб, рециркуляторов воды и железа для подключения к остальной части станции."

/obj/item/storage/box/plumbing/PopulateContents()
	var/list/items_inside = list(
		/obj/item/stock_parts/water_recycler = 2,
		/obj/item/stack/ducts/fifty = 1,
		/obj/item/stack/sheet/iron/ten = 1,
		)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/tail_pin
	name = "pin the tail on the corgi supplies"
	desc = "For ages 10 and up. ...Why is this even on a space station? Aren't you a little old for babby games?" //Intentional typo.

/obj/item/storage/box/tail_pin/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/poster/tail_board(src)
		new /obj/item/tail_pin(src)

/obj/item/storage/box/stabilized //every single stabilized extract from xenobiology
	name = "box of stabilized extracts"
	icon_state = "syndiebox"

/obj/item/storage/box/stabilized/PopulateContents()
	var/static/items_inside = list(
		/obj/item/slimecross/stabilized/grey=1,\
		/obj/item/slimecross/stabilized/orange=1,\
		/obj/item/slimecross/stabilized/purple=1,\
		/obj/item/slimecross/stabilized/blue=1,\
		/obj/item/slimecross/stabilized/metal=1,\
		/obj/item/slimecross/stabilized/yellow=1,\
		/obj/item/slimecross/stabilized/darkpurple=1,\
		/obj/item/slimecross/stabilized/darkblue=1,\
		/obj/item/slimecross/stabilized/silver=1,\
		/obj/item/slimecross/stabilized/bluespace=1,\
		/obj/item/slimecross/stabilized/sepia=1,\
		/obj/item/slimecross/stabilized/cerulean=1,\
		/obj/item/slimecross/stabilized/pyrite=1,\
		/obj/item/slimecross/stabilized/red=1,\
		/obj/item/slimecross/stabilized/green=1,\
		/obj/item/slimecross/stabilized/pink=1,\
		/obj/item/slimecross/stabilized/gold=1,\
		/obj/item/slimecross/stabilized/oil=1,\
		/obj/item/slimecross/stabilized/black=1,\
		/obj/item/slimecross/stabilized/lightpink=1,\
		/obj/item/slimecross/stabilized/adamantine=1,\
		/obj/item/slimecross/stabilized/rainbow=1,\
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/stickers
	name = "коробка стикеров"
	desc = "Полная коробка случайных стикеров. Не давать клоуну."

/obj/item/storage/box/stickers/proc/generate_non_contraband_stickers_list()
	. = list()
	for(var/obj/item/sticker/sticker_type as anything in subtypesof(/obj/item/sticker))
		if(!initial(sticker_type.contraband))
			. += sticker_type
	return .
/obj/item/storage/box/stickers/PopulateContents()
	var/static/list/non_contraband
	if(!non_contraband)
		non_contraband = generate_non_contraband_stickers_list()
	for(var/i in 1 to rand(4,8))
		var/type = pick(non_contraband)
		new type(src)

/obj/item/storage/box/stickers/googly
	name = "коробка глазиков"
	desc = "Время сделать что-то живым!"

/obj/item/storage/box/stickers/googly/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/sticker/googly(src)

/obj/item/storage/box/aimbot
	name = "комплект импланта боевого ассистента"
	desc = "Самоописуемо."
	illustration = "implant"

/obj/item/storage/box/aimbot/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/aimbot = 1,
		/obj/item/implanter = 1)
	generate_items_inside(items_inside,src)
