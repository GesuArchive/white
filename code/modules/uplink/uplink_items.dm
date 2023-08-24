GLOBAL_LIST_INIT(uplink_items, subtypesof(/datum/uplink_item))

/proc/get_uplink_items(uplink_flag, allow_sales = TRUE, allow_restricted = TRUE)
	var/list/filtered_uplink_items = list()
	var/list/sale_items = list()

	for(var/path in GLOB.uplink_items)
		var/datum/uplink_item/I = new path
		if(!I.item)
			continue
		if (!(I.purchasable_from & uplink_flag))
			continue
		if(I.player_minimum && I.player_minimum > GLOB.joined_player_list.len)
			continue
		if (I.restricted && !allow_restricted)
			continue

		if(!filtered_uplink_items[I.category])
			filtered_uplink_items[I.category] = list()
		filtered_uplink_items[I.category][I.name] = I
		if(I.limited_stock < 0 && !I.cant_discount && I.item && I.cost > 1)
			sale_items += I
	if(allow_sales)
		var/datum/team/nuclear/nuclear_team
		if (uplink_flag & UPLINK_NUKE_OPS) // uplink code kind of needs a redesign
			nuclear_team = locate() in GLOB.antagonist_teams // the team discounts could be in a GLOB with this design but it would make sense for them to be team specific...
		if (!nuclear_team)
			create_uplink_sales(3, "Discounted Gear", 1, sale_items, filtered_uplink_items)
		else
			if (!nuclear_team.team_discounts)
				// create 5 unlimited stock discounts
				create_uplink_sales(5, "Discounted Team Gear", -1, sale_items, filtered_uplink_items)
				// Create 10 limited stock discounts
				create_uplink_sales(10, "Limited Stock Team Gear", 1, sale_items, filtered_uplink_items)
				nuclear_team.team_discounts = list("Discounted Team Gear" = filtered_uplink_items["Discounted Team Gear"], "Limited Stock Team Gear" = filtered_uplink_items["Limited Stock Team Gear"])
			else
				for(var/cat in nuclear_team.team_discounts)
					for(var/item in nuclear_team.team_discounts[cat])
						var/datum/uplink_item/D = nuclear_team.team_discounts[cat][item]
						var/datum/uplink_item/O = filtered_uplink_items[initial(D.category)][initial(D.name)]
						O.refundable = FALSE

				filtered_uplink_items["Discounted Team Gear"] = nuclear_team.team_discounts["Discounted Team Gear"]
				filtered_uplink_items["Limited Stock Team Gear"] = nuclear_team.team_discounts["Limited Stock Team Gear"]


	return filtered_uplink_items

/proc/create_uplink_sales(num, category_name, limited_stock, sale_items, uplink_items)
	if (num <= 0)
		return

	if(!uplink_items[category_name])
		uplink_items[category_name] = list()

	for (var/i in 1 to num)
		var/datum/uplink_item/I = pick_n_take(sale_items)
		var/datum/uplink_item/A = new I.type
		var/discount = A.get_discount()
		var/list/disclaimer = list(
			"Не действует там, где запрещено законом.",
			"Не рекомендуется для детей.",
			"Содержит мелкие детали.",
			"Проверьте регионные законы на легальность.",
			"Не игрушка.",
			"Не несет ответственности за прямые, косвенные, случайные или косвенные убытки, возникшие в результате любого дефекта, ошибки или сбоя.",
			"Держите подальше от огня.",
			"Продукт предоставлен \"как есть\" без каких-либо подразумеваемых или выраженных гарантий.",
			"Как было в рекламе.",
			"Только для рекреационного пользования.",
			"Используйте только по назначению.",
			"Взимается 16% налог с заказа, отправленный с Космической Небраски."
		)
		A.limited_stock = limited_stock
		I.refundable = FALSE //THIS MAN USES ONE WEIRD TRICK TO GAIN FREE TC, CODERS HATES HIM!
		A.refundable = FALSE
		if(A.cost >= 20) //Tough love for nuke ops
			discount *= 0.5
		A.category = category_name
		A.cost = max(round(A.cost * discount),1)
		A.name += " |СКИДКА| ([round(((initial(A.cost)-A.cost)/initial(A.cost))*100)]%!)"
		A.desc += " Оригинальная стоимость [initial(A.cost)] ТК. Цены окончательные. [pick(disclaimer)]"
		A.item = I.item

		uplink_items[category_name][A.name] = A


/**
 * Uplink Items
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/
/datum/uplink_item
	var/name = "item name"
	var/category = "item category"
	var/desc = "item description"
	var/item = null // Path to the item to spawn.
	var/refund_path = null // Alternative path for refunds, in case the item purchased isn't what is actually refunded (ie: holoparasites).
	var/cost = 0
	var/refund_amount = 0 // specified refund amount in case there needs to be a TC penalty for refunds.
	var/refundable = FALSE
	var/surplus = 100 // Chance of being included in the surplus crate.
	var/surplus_nullcrates //Chance of being included in null crates. null = pull from surplus
	var/cant_discount = FALSE
	var/limited_stock = -1 //Setting this above zero limits how many times this item can be bought by the same traitor in a round, -1 is unlimited
	/// A bitfield to represent what uplinks can purchase this item.
	/// See [`code/__DEFINES/uplink.dm`].
	var/purchasable_from = ALL
	var/list/restricted_roles = list() //If this uplink item is only available to certain roles. Roles are dependent on the frequency chip or stored ID.
	var/player_minimum //The minimum crew size needed for this item to be added to uplinks.
	var/purchase_log_vis = TRUE // Visible in the purchase log?
	var/restricted = FALSE // Adds restrictions for VR/Events
	var/list/restricted_species //Limits items to a specific species. Hopefully.
	var/illegal_tech = TRUE // Can this item be deconstructed to unlock certain techweb research nodes?

/datum/uplink_item/New()
	. = ..()
	if(isnull(surplus_nullcrates))
		surplus_nullcrates = surplus

/datum/uplink_item/proc/get_discount()
	return pick(4;0.75,2;0.5,1;0.25)

/datum/uplink_item/proc/purchase(mob/user, datum/component/uplink/U)
	var/atom/A = spawn_item(item, user, U)
	if(purchase_log_vis && U.purchase_log)
		U.purchase_log.LogPurchase(A, src, cost)

/datum/uplink_item/proc/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	if(!spawn_path)
		return
	var/atom/A
	if(ispath(spawn_path))
		A = new spawn_path(get_turf(user))
	else
		A = spawn_path
	if(ishuman(user) && istype(A, /obj/item))
		var/mob/living/carbon/human/H = user
		if(H.put_in_hands(A))
			to_chat(H, span_boldnotice("[A] материализуется в ваших руках!"))
			return A
	to_chat(user, span_boldnotice("[A] материализуется на полу!"))
	return A

//Discounts (dynamically filled above)
/datum/uplink_item/discounts
	category = "Скидки"

//All bundles and telecrystals
/datum/uplink_item/bundles_tc
	category = "Наборы"
	surplus = 0
	cant_discount = TRUE

/datum/uplink_item/bundles_tc/chemical
	name = "Набор биотеррориста"
	desc = "Содержит ручной биотеррористический химический распылитель, вирусную пенную гранату, коробку ядовитых химикатов, шприцемёт, \
			коробка со шприцами, игрушечная винтовка DonkSoft и несколько пенных дротиков для борьбы с беспорядками. Помните: Перед использованием герметизируйте костюм и включите подачу воздуха."
	item = /obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	cost = 30 // normally 42
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/bundles_tc/bulldog
	name = "Набор с дробовиком \"Bulldog\""
	desc = "Предназначен для ведения боя на близких дистанциях. \
			Содержит автоматический дробовик \"Bulldog\", два барабана с патронами 12х70мм калибра и пара термальных очков."
	item = /obj/item/storage/backpack/duffelbag/syndie/bulldogbundle
	cost = 13 // normally 16
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/c20r
	name = "Набор с C-20r"
	desc = "Старый и верный: классический C-20r, в комплекте с двумя магазинами и глушителем по сниженной цене."
	item = /obj/item/storage/backpack/duffelbag/syndie/c20rbundle
	cost = 14 // normally 16
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/cyber_implants
	name = "Набор имплантов"
	desc = "Случайный набор кибернетических имплантатов. Гарантировано 5 высококачественных имплантатов. Поставляется с автохирургом."
	item = /obj/item/storage/box/cyber_implants
	cost = 40
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/medical
	name = "Медицинский набор"
	desc = "Набор боевого медика. С этим набором вы сможете оказать своим напарникам медицинскую помощь. Содержит тактическую аптечку, \
			Игрушечный пулемёт DonkSoft, коробка пенных дротиков для борьбы с беспорядками и пара магнитных ботинок, чтобы спасти ваших друзей в условиях невесомости."
	item = /obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	cost = 15 // normally 20
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/sniper
	name = "Снайперский набор"
	desc = "Элегантный и изысканный: Содержит разобранную снайперскую винтовку в чемодане для переноски, \
			два усыпляющих магазина, универсальный глушитель и стильный тактический костюм. \
			Мы добавим бесплатный красный галстук, если вы закажете ПРЯМО СЕЙЧАС."
	item = /obj/item/storage/briefcase/sniperbundle
	cost = 20 // normally 26
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/firestarter
	name = "Набор Пиротехнических Средств Спецназа"
	desc = "Для систематического подавления углеродных форм жизни в непосредственной близости: Содержит рюкзак с смертельным спреем, элитный защитный костюм, \
			пистолет Стечкина, два магазина с зажигательной смесью, граната и шприц со стимулятором. \
			Закажите СЕЙЧАС, и товарищ Борис добавит дополнительный спортивный костюм."
	item = /obj/item/storage/backpack/duffelbag/syndie/firestarter
	cost = 30
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/bundle_a
	name = "Тактический Синди-Набор"
	desc = "Комплект Синдиката, также известные как синди-наборы, представляют из себя специальные группы товаров, которые поступают в простой коробке. \
			Эти предметы все вместе стоят более 20 телекристаллов, но вы не знаете, какую специальность \
			вы получите. Может содержать снятые с производства и/или некоторые экзотические товары."
	item = /obj/item/storage/box/syndicate/bundle_a
	cost = 20
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/bundles_tc/bundle_b
	name = "Специальный Синди-Набор"
	desc = "Комплект Синдиката, также известные как синди-наборы, представляют из себя специальные группы товаров, которые поступают в простой коробке. \
			В этом синди-наборе вы получите предметы, которые использовались известными агентами синдиката прошлого. Имея в общей стоимости более 20 ТК, товары имеют хорошую отдачу далекого прошлого."
	item = /obj/item/storage/box/syndicate/bundle_b
	cost = 20
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/bundles_tc/surplus
	name = "Ящик с излишками Синдиката"
	desc = "Пыльный ящик из задней части склада Синдиката. По слухам, в нем содержится ценный ассортимент предметов, \
			но неизвестно, каких. Содержимое сортируется так, чтобы их общая стоимость всегда была 50 ТК."
	item = /obj/structure/closet/crate
	cost = 20
	player_minimum = 25
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	var/starting_crate_value = 50

/datum/uplink_item/bundles_tc/surplus/super
	name = "Супер Избыточный Ящик Синдиката"
	desc = "Пыльный СУПЕРБОЛЬШОЙ с задней части склада Синдиката. По слухам, в нем содержится ценный ассортимент предметов, \
			но неизвестно, каких. Содержимое сортируется так, чтобы их общая стоимость всегда была 125 ТК."
	cost = 40
	player_minimum = 40
	starting_crate_value = 125

/datum/uplink_item/bundles_tc/surplus/purchase(mob/user, datum/component/uplink/U)
	var/list/uplink_items = get_uplink_items(UPLINK_TRAITORS, FALSE)

	var/crate_value = starting_crate_value
	var/obj/structure/closet/crate/C = spawn_item(/obj/structure/closet/crate, user, U)
	log_uplink("[key_name(user)] puchased [src] worth [crate_value] telecrystals for [cost] telecrystals using [U.parent]'s uplink")
	if(U.purchase_log)
		U.purchase_log.LogPurchase(C, src, cost)
	while(crate_value)
		var/category = pick(uplink_items)
		var/item = pick(uplink_items[category])
		var/datum/uplink_item/I = uplink_items[category][item]

		if(!I.surplus || prob(100 - I.surplus))
			continue
		if(crate_value < I.cost)
			continue
		crate_value -= I.cost
		var/obj/goods = new I.item(C)
		log_uplink("- [key_name(user)] received [goods] from [src]")
		if(U.purchase_log)
			U.purchase_log.LogPurchase(goods, I, 0)
	return C

/datum/uplink_item/bundles_tc/random
	name = "Случайный предмет"
	desc = "Покупает абсолютно случайный предмет из доступного списка. Полезно, если вы не можете самому определить свою стратегию."
	item = /obj/effect/gibspawner/generic // non-tangible item because techwebs use this path to determine illegal tech
	cost = 0

/datum/uplink_item/bundles_tc/random/purchase(mob/user, datum/component/uplink/U)
	var/list/uplink_items = U.uplink_items
	var/list/possible_items = list()
	for(var/category in uplink_items)
		for(var/item in uplink_items[category])
			var/datum/uplink_item/I = uplink_items[category][item]
			if(src == I || !I.item)
				continue
			if(U.telecrystals < I.cost)
				continue
			if(I.limited_stock == 0)
				continue
			possible_items += I

	if(possible_items.len)
		var/datum/uplink_item/I = pick(possible_items)
		//log_uplink("[key_name(user)] purchased a random uplink item from [U.parent]'s uplink with [U.telecrystals] telecrystals remaining")
		SSblackbox.record_feedback("tally", "traitor_random_uplink_items_gotten", 1, initial(I.name))
		U.MakePurchase(user, I)

/datum/uplink_item/bundles_tc/telecrystal
	name = "1 телекристалл"
	desc = "Телекристалл в его самой чистой и необработанной форме. Может быть использован в аплинках."
	item = /obj/item/stack/telecrystal
	cost = 1
	// Don't add telecrystals to the purchase_log since
	// it's just used to buy more items (including itself!)
	purchase_log_vis = FALSE

/datum/uplink_item/bundles_tc/telecrystal/five
	name = "5 телекристаллов"
	desc = "5 телекристаллов в их самых чистых и необработанных формах. Может быть использован в аплинках."
	item = /obj/item/stack/telecrystal/five
	cost = 5

/datum/uplink_item/bundles_tc/telecrystal/twenty
	name = "20 телекристаллов"
	desc = "20 телекристаллов в их самых чистых и необработанных формах. Может быть использован в аплинках."
	item = /obj/item/stack/telecrystal/twenty
	cost = 20

// Dangerous Items
/datum/uplink_item/dangerous
	category = "Заметное оружие"

/datum/uplink_item/dangerous/rawketlawnchair
	name = "84-мм реактивный гранатомёт"
	desc = "Многоразовый реактивный гранатомет с заряженным 84-мм осколочно-фугасным снарядом. \
			Гарантированно отправит вашу цель к небесам, или мы вернем деньги!"
	item = /obj/item/gun/ballistic/rocketlauncher
	cost = 8
	surplus = 30
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/pie_cannon
	name = "Банановая пироговая пушка"
	desc = "Особая пироговая пушка для такого же особого клоуна, это оружие может вмещать до 20 пирогов и автоматически изготавливает по одному каждые две секунды!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/bananashield
	name = "Bananium Energy Shield" // лень переводить
	desc = "A clown's most powerful defensive weapon, this personal shield provides near immunity to ranged energy attacks \
		by bouncing them back at the ones who fired them. It can also be thrown to bounce off of people, slipping them, \
		and returning to you even if you miss. WARNING: DO NOT ATTEMPT TO STAND ON SHIELD WHILE DEPLOYED, EVEN IF WEARING ANTI-SLIP SHOES."
	item = /obj/item/shield/energy/bananium
	cost = 16
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/clownsword
	name = "Bananium Energy Sword"  // лень переводить
	desc = "An energy sword that deals no damage, but will slip anyone it contacts, be it by melee attack, thrown \
	impact, or just stepping on it. Beware friendly fire, as even anti-slip shoes will not protect against it."
	item = /obj/item/melee/energy/sword/bananium
	cost = 3
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/clownoppin
	name = "Ultra Hilarious Firing Pin" // лень переводить
	desc = "A firing pin that, when inserted into a gun, makes that gun only useable by clowns and clumsy people and makes that gun honk whenever anyone tries to fire it."
	cost = 1 //much cheaper for clown ops than for clowns
	item = /obj/item/firing_pin/clown/ultra
	purchasable_from = UPLINK_CLOWN_OPS
	illegal_tech = FALSE

/datum/uplink_item/dangerous/clownopsuperpin
	name = "Super Ultra Hilarious Firing Pin" // лень переводить
	desc = "Like the ultra hilarious firing pin, except the gun you insert this pin into explodes when someone who isn't clumsy or a clown tries to fire it."
	cost = 4 //much cheaper for clown ops than for clowns
	item = /obj/item/firing_pin/clown/ultra/selfdestruct
	purchasable_from = UPLINK_CLOWN_OPS
	illegal_tech = FALSE

/datum/uplink_item/dangerous/bioterror
	name = "Биотоксичный Химический спрей"
	desc = "Ручной химический распылитель, который позволяет распылять выбранные химические вещества. Будучи изготовленными организацией Tiger \
			Cooperative, смесь, которой снабжен спрей, дезориентирует, повреждает, и вырубает ваших оппонентов. \
			Используйте с крайней осторожностью, чтобы предотвратить попадание смеси на вас или ваших товарищей по команде."
	item = /obj/item/reagent_containers/spray/chemsprayer/bioterror
	cost = 20
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/throwingweapons
	name = "Коробка метательного оружия"
	desc = "Коробка сюрикенов и крепких бол, используемые различными древними боевыми искусствами. \
			Крепкие болы при успешном метании сбивают с ног противника, а сюрикены впиваются в конечности и вызывают кровотечение."
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 3
	illegal_tech = FALSE

/datum/uplink_item/dangerous/shotgun
	name = "Автоматический дробовик \"Bulldog\""
	desc = "Полуавтоматический дробовик с барабанным питанием. Совместим со всеми барабанами 12 калибра. Предназначен для \
			боя на близких дистанциях."
	item = /obj/item/gun/ballistic/shotgun/bulldog
	cost = 8
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/smg
	name = "Автомат C-20r"
	desc = "Снаряжённый пистолет-пулемёт в компоновке буллпап, изготовленный концерном \"Scarborough Arms\". C20-r использует патроны .45 калибра \
			с магазинами на 24 патрона и имеет совместимость с глушителями."
	item = /obj/item/gun/ballistic/automatic/c20r
	cost = 13
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/doublesword
	name = "Двойной энергетический меч"
	desc = "Мощный двойной энергетический меч, позволяющий полностью отражать энергетические снаряды обратно в стрелка \
			и имеет некоторый шанс парировать оружие ближнего боя, однако требует обе руки для использования."
	item = /obj/item/dualsaber
	player_minimum = 25
	cost = 16
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/doublesword/get_discount()
	return pick(4;0.8,2;0.65,1;0.5)

/datum/uplink_item/dangerous/sword
	name = "Энергетический меч"
	desc = "Активируемое холодное энергетическое оружие с лезвием из чистой энергии. Его размера достаточно, чтобы \
			поместить меч в карман. Активация меча издает характерный и громкий звук."
	item = /obj/item/melee/energy/sword/saber
	cost = 8
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/shield
	name = "Энергетический щит"
	desc = "Персональный энергетический щит, отражающий любые энергетические снаряды обратно в стрелка, но \
			крайне неэффективен против пуль и оружия ближнего боя."
	item = /obj/item/shield/energy
	cost = 16
	surplus = 20
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/flamethrower
	name = "Огнемёт"
	desc = "Огнемёт, заправленный легковоспленяющейся плазмой, украденная с одного из комплексов NanoTrasen \
			Заявите о себе, поджарив гниль в их собственной жадности. Используйте с осторожностью."
	item = /obj/item/flamethrower/full/tank
	cost = 4
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS
	illegal_tech = FALSE

/datum/uplink_item/dangerous/rapid
	name = "Перчатки северной звезды"
	desc = "Перчатки, позволяющие наносить носителю быстрые удары кулаками. Не работает, если используется любое оружие \
			ближнего боя, или если носитель является халком"
	item = /obj/item/clothing/gloves/rapid
	cost = 8

/datum/uplink_item/dangerous/guardian
	name = "Голопаразит"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an \
			organic host as a home base and source of fuel. Holoparasites come in various types and share damage with their host."
	item = /obj/item/storage/box/syndie_kit/guardian
	cost = 18
	surplus = 0
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	player_minimum = 25
	restricted = TRUE

/datum/uplink_item/dangerous/machinegun
	name = "Ручной пулемёт L6"
	desc = "Заряженный ручной пулемёт компании \"Aussec Armoury\" с ленточным питанием. \
			Это смертоносное оружие оснащается магазином на 50 патронов с не менее смертоносным 7,12х82мм калибром."
	item = /obj/item/gun/ballistic/automatic/l6_saw
	cost = 18
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/carbine
	name = "Боевой карабин M-90gl"
	desc = "Специализированный и мощный карабин с режимом выстрела по три патрона. Использует 30-ти зарядные магазины 5.56 калибра, пробивающий броню и \
			имеющий подствольный 40мм гранатомёт. Используйте вторичный огонь для ведения стрельбы из подствольника."
	item = /obj/item/gun/ballistic/automatic/m90
	cost = 14
	surplus = 50
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/powerfist
	name = "Силовой кулак"
	desc = "Металлическая перчатка со встроенным поршнем-тараном, работающим от внешнего источника газа. \
			При попадании в цель, поршень-таран выдвигается вперед для нанесения серьезных повреждений. \
			С помощью ключа на клапане поршня вы можете регулировать количество газа, используемого для удара, чтобы \
			нанести дополнительный урон и поразить цель на большем расстоянии. Используйте отвертку, чтобы вытащить все прикрепленные баллоны."
	item = /obj/item/melee/powerfist
	cost = 6

/datum/uplink_item/dangerous/sniper
	name = "Снайперская Винтовка"
	desc = "Ярость на расстоянии, в стиле Синдиката. Гарантированно вызовет шок и трепет или мы вернем ваши телекристаллы!"
	item = /obj/item/gun/ballistic/automatic/sniper_rifle/syndicate
	cost = 16
	surplus = 25
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/pistol
	name = "Пистолет Макарова"
	desc = "Небольшой, легко скрываемый пистолет, использующий 9-мм автоматические патроны в магазинах на 8 патронов и совместимый с глушителями."
	item = /obj/item/gun/ballistic/automatic/pistol
	cost = 7
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/aps
	name = "Автоматический пистолет Стечкина"
	desc = "Старинный советский пистолет, отреставрированный для современной эпохи. Использует 9-мм патроны в магазинах на 15 патронов и совместим \
			с глушителями. Стреляет очередями по три патрона."
	item = /obj/item/gun/ballistic/automatic/pistol/aps
	cost = 10
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/surplus_smg
	name = "Низкокачественный ПП"
	desc = "Ужасно устаревшее автоматическое оружие. Почему вы хотите использовать это?"
	item = /obj/item/gun/ballistic/automatic/plastikov
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/revolver
	name = "Револьвер Синдиката"
	desc = "Примитивный, но мощный синдикатовский револьвер, стреляющий патронами калибра .357 Магнум. Вмещает 7 патронов."
	item = /obj/item/gun/ballistic/revolver
	cost = 13
	surplus = 50
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/foamsmg
	name = "Игрушечный пистолет-пулемёт"
	desc = "Игрушечная копия C20r \"DonkSoft\", стреляющая пенными дротиками с магазином на 20 патронов."
	item = /obj/item/gun/ballistic/automatic/c20r/toy
	cost = 5
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/foammachinegun
	name = "Игрушечный пулемёт"
	desc = "Полностью заряженный пулемет \"DonkSoft\" с ленточным питанием. Это оружие имеет  магазин на 50 патронов с жесткими \
			пенными дротиками, изнуряющие цель."
	item = /obj/item/gun/ballistic/automatic/l6_saw/toy
	cost = 10
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/foampistol
	name = "Игрушечный пистолет с жесткими дротиками"
	desc = "Невинный на вид игрушечный пистолет, предназначенный для стрельбы пенными дротиками. Изначально заряжен жесткими дротиками, \
			эффективно изнуряющая цель."
	item = /obj/item/gun/ballistic/automatic/pistol/toy/riot
	cost = 2
	surplus = 10

// Stealthy Weapons
/datum/uplink_item/stealthy_weapons
	category = "Скрытное оружие"

/datum/uplink_item/stealthy_weapons/combatglovesplus
	name = "+Боевые перчатки+"
	desc = "Пара огнеупорных и электроизолированных перчаток, однако, в отличие от обычных боевых перчаток, в этих используются нанотехнологии \
			для обучения владельца боевому искусству крав-мага."
	item = /obj/item/clothing/gloves/krav_maga/combatglovesplus
	cost = 5
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	surplus = 0

/datum/uplink_item/stealthy_weapons/cqc
	name = "Руководство по CQC"
	desc = "Руководство, обучающее одного пользователя тактике боя в ближнем бою. Использованное руководство при попытке прочитать самоуничтожается."
	item = /obj/item/book/granter/martial/cqc
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	cost = 13
	surplus = 0

/datum/uplink_item/stealthy_weapons/dart_pistol
	name = "Мини-шприцемет"
	desc = "Миниатюрная версия обычного шприцемёта. Он очень тихий при выстреле и может поместиться в карман."
	item = /obj/item/gun/syringe/syndicate
	cost = 4
	surplus = 50

/datum/uplink_item/stealthy_weapons/dehy_carp
	name = "Обезвоженный космический карп"
	desc = "Выглядит как плюшевый карп, но стоит добавить воды, и он превращается в настоящего космического карпа! Активируйте \
			в руке перед использованием, чтобы пометить себя для карпа в качестве друга."
	item = /obj/item/toy/plush/carpplushie/dehy_carp
	cost = 1

/datum/uplink_item/stealthy_weapons/edagger
	name = "Энергетический кинжал"
	desc = "Энергокинжал, который в выключенном состоянии выглядит и функционирует как ручка."
	item = /obj/item/pen/edagger
	cost = 2

/datum/uplink_item/stealthy_weapons/martialarts
	name = "Свиток боевых искусств"
	desc = "Этот свиток содержит секреты древней техники боевых искусств. Вы овладеете навыками безоружного боя \
			и обретете способность отражать пули руками, но вы также не сможете использовать дальнобойное оружие."
	item = /obj/item/book/granter/martial/carp
	player_minimum = 25
	cost = 20
	surplus = 0
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_weapons/crossbow
	name = "Миниатюрный энергетический арбалет"
	desc = "Короткий лук, установленный на румпеле в миниатюре. \
	Достаточно маленький, чтобы поместиться в карман или незаметно проскользнуть в сумку. \
	Он синтезирует и стреляет болтами с изнуряющим токсином, \
	который наносит урон и дезориентирует цели, заставляя их \
	говорить невнятно, как будто опьянели. Он может производить бесконечное количество \
	болтов, но требует времени для автоматической перезарядки после каждого выстрела."
	item = /obj/item/gun/energy/kinetic_accelerator/crossbow
	player_minimum = 25
	cost = 10
	surplus = 50
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_weapons/origami_kit
	name = "Коробка Оригами"
	desc = "В этой коробке находится руководство по мастерству оригами, позволяющее превратить обычные листы бумаги в \
			идеально аэродинамические (и потенциально смертоносные) бумажные самолеты."
	item = /obj/item/storage/box/syndie_kit/origami_bundle
	cost = 14
	surplus = 0
	purchasable_from = ~UPLINK_NUKE_OPS //clown ops intentionally left in, because that seems like some s-tier shenanigans.

/datum/uplink_item/stealthy_weapons/traitor_chem_bottle
	name = "Набор с ядами"
	desc = "Ассортимент смертоносных химикатов, упакованных в компактную коробку. Поставляется с пустым шприцем."
	item = /obj/item/storage/box/syndie_kit/chemical
	cost = 6
	surplus = 50

/datum/uplink_item/stealthy_weapons/romerol_kit
	name = "Ромерол"
	desc = "Экспериментальный агент биотеррора, который создает спящие узелки, вытравливаемые в сером веществе мозга. \
			После смерти эти узелки берут под контроль мертвое тело, вызывая ограниченное оживление, \
			наряду с невнятной речью, агрессией и способностью заражать этим агентом других людей."
	item = /obj/item/storage/box/syndie_kit/romerol
	cost = 25
	cant_discount = TRUE

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "Усыпляющая ручка"
	desc = "Шприц, замаскированный под функциональную ручку, наполненный сильнодействующей смесью наркотиков, включая \
			сильный анестетик и химическое вещество, не позволяющее цели говорить. \
			Ручка вмещает одну дозу смеси, и может быть пополнена любыми химикатами. Обратите внимание, что перед тем, как объект \
			уснет, он будет в состоянии двигаться и действовать."
	item = /obj/item/pen/sleepy
	cost = 4
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_weapons/suppressor
	name = "Глушитель"
	desc = "Глушитель, который подавляют звуки выстрелов у оружия, к которому он прикреплен, обеспечивая повышенную скрытность и превосходные возможности для засады. Он совместим со многими небольшими баллистическими пистолетами, включая пистолеты Макарова, пистолета Стечкина и С-20р, но не с револьверами или энергетическим вооружением."
	item = /obj/item/suppressor
	cost = 3
	surplus = 10
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/stealthy_weapons/holster
	name = "Синдикатская кобура"
	desc = "Полезная кобура, позволяющая незаметно носить оружие, оснащенная технологией хамелеона. Она также позволяет круто вращать оружием."
	item = /obj/item/storage/belt/holster/chameleon
	cost = 1

// Ammunition
/datum/uplink_item/ammo
	category = "Аммуниция"
	surplus = 40

/datum/uplink_item/ammo/pistol
	name = "Магазин 9 мм"
	desc = "Магазин на 8 патронов калибра 9 мм, совместимый с пистолетом Макарова."
	item = /obj/item/ammo_box/magazine/m9mm
	cost = 1
	purchasable_from = ~UPLINK_CLOWN_OPS
	illegal_tech = FALSE

/datum/uplink_item/ammo/pistolap
	name = "Магазин 9 мм БП"
	desc = "Дополнительный магазин на 8 патронов калибра 9 мм, совместимый с пистолетом Макарова. \
			Эти патроны менее эффективны при ранении цели, но пробивают броню."
	item = /obj/item/ammo_box/magazine/m9mm/ap
	cost = 2
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolhp
	name = "Магазин 9 мм HP"
	desc = "Дополнительный магазин на 8 патронов калибра 9 мм, совместимый с пистолетом Макарова. \
			Эти патроны наносят больший урон, но неэффективны против брони."
	item = /obj/item/ammo_box/magazine/m9mm/hp
	cost = 3
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolfire
	name = "Магазин 9 мм Т"
	desc = "Дополнительный магазин на 8 патронов калибра 9 мм, совместимый с пистолетом Макарова. \
			Заряжен зажигательными патронами, которые наносят небольшой урон, но поджигают цель."
	item = /obj/item/ammo_box/magazine/m9mm/fire
	cost = 2
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolaps
	name = "Магазин 9 мм АПС"
	desc = "Дополнительный магазин на 15 патронов калибра 9мм, совместимый с автоматическим пистолетом Стечкина."
	item = /obj/item/ammo_box/magazine/m9mm_aps
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/shotgun
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/shotgun/bag
	name = "Сумка с барабанами 12 калибра"
	desc = "Вещмешок, наполненный 12x70 дробью, которых хватит на всю команду, по сниженной цене."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun
	cost = 12

/datum/uplink_item/ammo/shotgun/buck
	name = "Барабанный магазин 12 калибра"
	desc = "Дополнительный магазин для картечи на 8 патронов для использования с дробовиком Bulldog. Направлять в сторону противника."
	item = /obj/item/ammo_box/magazine/m12g

/datum/uplink_item/ammo/shotgun/dragon
	name = "Барабанный зажигательный магазин 12 калибра"
	desc = "Альтернативный магазин на 8 патронов \"дыхание дракона\" для использования в дробовике Bulldog. \
			'I'm a fire starter, twisted fire starter!'"
	item = /obj/item/ammo_box/magazine/m12g/dragon
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/shotgun/meteor
	name = "Барабанный метеорпулевой магазин 12 калибра"
	desc = "Альтернативный магазин на 8 патронов для дробовика Bulldog. \
			Отлично подходит для выбивания шлюзов и сбивания врагов с ног."
	item = /obj/item/ammo_box/magazine/m12g/meteor
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/shotgun/slug
	name = "Барабанный пулевой магазин 12 калибра"
	desc = "Дополнительный пулевой магазин на 8 патронов для дробовика Bulldog. \
			Теперь в 8 раз меньше шансов застрелить своих друзей."
	cost = 3
	item = /obj/item/ammo_box/magazine/m12g/slug

/datum/uplink_item/ammo/shotgun/apslug
	name = "Барабанный магазин 12 калибра ББ"
	desc = "Барабанный магазин на 8 патронов, заряженный бронебойными патронами, подходит для дробовика Bulldog."
	cost = 4
	item = /obj/item/ammo_box/magazine/m12g/apslug

/datum/uplink_item/ammo/revolver
	name = "Скорозарядник .357"
	desc = "Скорозарядник, содержащий патроны калибра .357 Магнум, используемый в револьверах. \
			Для тех случаев, когда вам действительно нужно, чтобы многие вещи были мертвыми."
	item = /obj/item/ammo_box/a357
	cost = 4
	purchasable_from = ~UPLINK_CLOWN_OPS
	illegal_tech = FALSE

/datum/uplink_item/ammo/a40mm
	name = "Коробка с 40 мм гранатами"
	desc = "Ящик 40мм гранат для использования с подствольным гранатометом M-90gl. \
			Ваши товарищи по команде попросят вас не стрелять в них в маленьких корридорах."
	item = /obj/item/ammo_box/a40mm
	cost = 6
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/smg/bag
	name = "Сумка с магазинами .45 калибра"
	desc = "Вещевой мешок, наполненный магазинами 45-го калибра, которых хватит на всю команду, всего по сниженной цене."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/smg
	cost = 20 //instead of 27 TC
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/smg
	name = "Магазин .45 калибра"
	desc = "Дополнительный магазин на 24 патрона калибра .45, подходящий для использования с пистолетом-пулеметом C-20r."
	item = /obj/item/ammo_box/magazine/smgm45
	cost = 3
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/smgap
	name = "Магазин .45 калибра ББ"
	desc = "Дополнительный магазин на 24 патрона 45-го калибра, предназначенный для пистолета-пулемета C-20r.\
			Эти патроны менее эффективны при ранении цели, но пробивают броню."
	item = /obj/item/ammo_box/magazine/smgm45/ap
	cost = 5
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/smgfire
	name = "Зажигательный магазин .45 калибра"
	desc = "Дополнительный магазин на 24 патрона 45-го калибра, предназначенный для пистолета-пулемета C-20r.\
			Заряжен зажигательными патронами, которые наносят небольшой урон, но поджигают цель."
	item = /obj/item/ammo_box/magazine/smgm45/incen
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/sniper
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/sniper/basic
	name = "Магазин .50"
	desc = "Дополнительный стандартный магазин на 6 патронов для использования со снайперскими винтовками .50 калибра."
	item = /obj/item/ammo_box/magazine/sniper_rounds

/datum/uplink_item/ammo/sniper/penetrator
	name = "Магазин .50 ББ"
	desc = "Магазин на 5 патронов, предназначенный для снайперских винтовок калибра .50. \
			Может пробивать стены и кучу врагов."
	item = /obj/item/ammo_box/magazine/sniper_rounds/penetrator
	cost = 5

/datum/uplink_item/ammo/sniper/soporific
	name = "Усыпляющий магазин .50 калибра"
	desc = "Магазин усыпляющих патронов на 3 патрона, предназначенный для снайперских винтовок калибра .50. Скажите спокойной ночи вашим противникам!"
	item = /obj/item/ammo_box/magazine/sniper_rounds/soporific
	cost = 6

/datum/uplink_item/ammo/sniper/marksman
	name = "Снайперский магазин .50 калибра"
	desc = "Пятизарядный магазин созданный специально для снайперской винтовки. Один выстрел - одно убийство!"
	item = /obj/item/ammo_box/magazine/sniper_rounds/marksman
	cost = 5

/datum/uplink_item/ammo/carbine
	name = "Верхний магазин 5.56 калибра"
	desc = "Магазин на 30 патронов калибра 5,56 мм для использования с карабином M-90gl. \
			Эти пули обладают меньшей мощью, чем патроны 7,12х82 мм, но они все равно мощнее патронов 45 калибра благодаря своей бронепробиваемости."
	item = /obj/item/ammo_box/magazine/m556
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/carbinephase
	name = "Верхний фазовый магазин 5.56 калибра"
	desc = "An additional 30-round 5.56mm magazine; suitable for use with the M-90gl carbine. \
			These bullets are made from an experimental alloy, 'Ghost Lead', that allows it to pass through almost any non-organic material. \
			The name is a misnomer. It doesn't contain any lead whatsoever!"
	item = /obj/item/ammo_box/magazine/m556/phasic
	cost = 8
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/machinegun
	cost = 6
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/machinegun/basic
	name = "Патронная коробка 7.12x82 калибра"
	desc = "Магазин на 50 патронов калибра 7,12x82мм для использования в пулемете L6 SAW. \
			К тому времени, когда вам понадобится это использовать, вы уже будете стоять на груде трупов."
	item = /obj/item/ammo_box/magazine/mm712x82

/datum/uplink_item/ammo/machinegun/ap
	name = "Патронная коробка 7.12x82 калибра БП"
	desc = "Магазин на 50 патронов калибра 7,12х82мм для использования в пулемета L6 SAW; обладающий возможностью пробивать \
			даже самую прочную броню."
	item = /obj/item/ammo_box/magazine/mm712x82/ap
	cost = 9

/datum/uplink_item/ammo/machinegun/hollow
	name = "Патронная коробка 7.12x82 калибра НР"
	desc = "Магазин на 50 патронов 7.12x82 мм для использования в L6 SAW; снаряжен экспансивными пулями, чтобы помочь стрелку \
			с небронированной массой экипажа."
	item = /obj/item/ammo_box/magazine/mm712x82/hollow

/datum/uplink_item/ammo/machinegun/incen
	name = "Патронная коробка 7.12x82 калибра Т"
	desc = "Магазин на 50 патронов 7.12x82 мм для использования в L6 SAW; снаряжен специальной воспламеняющейся \
			которая воспламенит любого, кто попадет под пулю. Некоторые люди мечтают видеть мир в огне."
	item = /obj/item/ammo_box/magazine/mm712x82/incen

/datum/uplink_item/ammo/machinegun/match
	name = "Патронная коробка 7.12x82 калибра М"
	desc = "Магазин на 50 патронов калибра 7.12x82 мм для использования в L6 SAW; вы не знали, что существует спрос на матчевые патроны, \
			но эти патроны тонко изготовлены и идеально подходят для рикошета от стен."
	item = /obj/item/ammo_box/magazine/mm712x82/match
	cost = 10

/datum/uplink_item/ammo/rocket
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/rocket/basic
	name = "84-мм противопехотная ракета"
	desc = "Маломощная противопехотная ракета. Уберет тебя в стиле!"
	item = /obj/item/ammo_casing/caseless/rocket
	cost = 4

/datum/uplink_item/ammo/rocket/hedp
	name = "84-мм кумулятивная ракета"
	desc = "Высокомощная кумулятивная ракета; чрезвычайно эффективна против бронированных целей, а также окружающего персонала. \
			Наведите страх на сердца ваших врагов."
	item = /obj/item/ammo_casing/caseless/rocket/hedp
	cost = 6

/datum/uplink_item/ammo/toydarts
	name = "Коробка с жёсткими пенными дротиками"
	desc = "Коробка с 40 жёсткими пенными дротиками, для перезарядки любого игрушечного магазина. Не забудьте поделиться!"
	item = /obj/item/ammo_box/foambox/riot
	cost = 2
	surplus = 0
	illegal_tech = FALSE

/datum/uplink_item/ammo/bioterror
	name = "Коробка со шприцами для биотеррора"
	desc = "Коробка, наполненная заранее заряженными шприцами, содержащими различные химикаты, которые парализуют двигательную систему жертвы. \
			и участок мозга, делая невозможным двигаться или говорить в течение некоторого времени."
	item = /obj/item/storage/box/syndie_kit/bioterror
	cost = 6
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/surplus_smg
	name = "Магазин для низкокачественного ПП"
	desc = "Цилиндрический магазин, предназначенный для устаревшего ПП-95."
	item = /obj/item/ammo_box/magazine/plastikov9mm
	cost = 1
	purchasable_from = UPLINK_NUKE_OPS
	illegal_tech = FALSE

/datum/uplink_item/ammo/mech/bag
	name = "Комплект поддержки экзокостюмов"
	desc = "Вещевой мешок, содержащий патроны для карабина Scattershot, которым оснащены экзокостюмы Dark Gygax и Mauler. Также прилагается вспомогательное оборудование для обслуживания мехов, включая инструменты и индуктор."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/mech
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/mauler/bag
	name = "Сумка с патронами для меха Mauler"
	desc = "Вещевой мешок, содержащий патроны для пулемета, карабина Scattershot и ракетной установки SRM-8, установленных на стандартном экзокостюме Mauler."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	cost = 6
	purchasable_from = UPLINK_NUKE_OPS

//Grenades and Explosives
/datum/uplink_item/explosives
	category = "Взрывчатка"

/datum/uplink_item/explosives/bioterrorfoam
	name = "Пенная граната биотеррора"
	desc = "Мощная химическая пенная граната, создающая смертоносный поток пены, который заглушает, ослепляет, сбивает с толку, \
			вызывает мутации и раздражает различные углеродные формы жизни. Изготовлена специалистами по химическому оружию из Tiger Cooperative, \
			используя дополнительный спор токсинов. Убедитесь, что ваш костюм запечатан перед использованием."
	item = /obj/item/grenade/chem_grenade/bioterrorfoam
	cost = 5
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/bombanana
	name = "Бомбанана"
	desc = "Банан со взрывным вкусом! Имеет взрывную мощность, сравнивая с минибомбой Синдиката. \
			Детонируется сам по себе только после поедания банана."
	item = /obj/item/food/grown/banana/bombanana
	cost = 4 //it is a bit cheaper than a minibomb because you have to take off your helmet to eat it, which is how you arm it
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/buzzkill
	name = "Коробка с пчелонатами"
	desc = "Коробка с тремя гранатами, которые при активации выпускают рой злобных пчел. Эти пчелы без разбора атакуют всех подряд \
			с помощью случайных токсинов. Любезно предоставлено вашими товарищами из BLF и Tiger Cooperative."
	item = /obj/item/storage/box/syndie_kit/bee_grenades
	cost = 15
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/c4
	name = "Взрывчатка С-4"
	desc = "Пластичная взрывчатка военного назначения. Используется для пробивания стен, саботажа различного оборудования или подключения к какой-нибудь сборке \
			для иного способа детонации. Его можно прикрепить почти ко всем предметам, и у него есть изменяемый таймер с минимальным значением в 10 секунд."
	item = /obj/item/grenade/c4
	cost = 1

/datum/uplink_item/explosives/c4bag
	name = "Мешок с С-4"
	desc = "Ведь иногда количество - это качество. Содержит 10 пластичных взрывчаток C-4."
	item = /obj/item/storage/backpack/duffelbag/syndie/c4
	cost = 8 //20% discount!
	cant_discount = TRUE

/datum/uplink_item/explosives/x4bag
	name = "Мешок с Х-4"
	desc = "Содержит 3 пластичных заряда X-4. Похожи на C-4, но имеют более сильный взрыв, направленный, а не круговой. \
			X-4 можно поместить на твердую поверхность, например, стену или окно, и она прорвется сквозь стену, поражая все, что находится на противоположной стороне, и при этом будет более безопасной для пользователя. \
			Для случаев, когда вам нужен контролируемый взрыв, оставляющий более широкое и глубокое отверстие."
	item = /obj/item/storage/backpack/duffelbag/syndie/x4
	cost = 4 //
	cant_discount = TRUE

/datum/uplink_item/explosives/clown_bomb_clownops
	name = "Клоунбомба"
	desc = "Уморительное устройство, способное на массовые розыгрыши. Она имеет регулируемый таймер, \
			с минимальным временем в 90 секунд, и может быть прикручена к полу с помощью гаечного ключа.\
			Громоздкая и не может быть перемещена; при заказе этого товара, вам будет доставлен маячок,\
			который при активации телепортирует к вам настоящую бомбу. Обратите внимание, что эту бомбу можно \
			обезвредить, и некоторые члены экипажа могут попытаться сделать это."
	item = /obj/item/sbeacondrop/clownbomb
	cost = 15
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/detomatix
	name = "Диск ПДА \"Детоматикс\""
	desc = "При установке в планшет этот картридж дает вам четыре заряда \
			для детонации планшетов остальных членов экипажа, у которых включена передача сообщений. \
			Заряд взорвет планшет получателя и выведет из строя его пользователя на короткое время, оглушив его."
	item = /obj/item/computer_disk/virus/detomatix
	cost = 6
	restricted = TRUE

/datum/uplink_item/explosives/emp
	name = "Коробка с ЭМИ гранатами и имплантом"
	desc = "Ящик, содержащий пять ЭМИ-гранат и ЭМИ-имплант с тремя зарядами. Пригодится, чтобы вывести из строя гарнитуру противника, \
			энергетическое оружие службы безопасности и киборгов, особенно когда вы находитесь в затруднительном положении."
	item = /obj/item/storage/box/syndie_kit/emp
	cost = 2

/datum/uplink_item/explosives/virus_grenade
	name = "Граната грибкового туберкулеза"
	desc = "Заправленная био-граната, упакованная в компактную коробку. Поставляется с пятью био-вирусными антидотами (BVAK) и \
			автоинъекторами для быстрого применения на двух целях, шприцом и бутылкой с \
			раствором BVAK."
	item = /obj/item/storage/box/syndie_kit/tuberculosisgrenade
	cost = 12
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	restricted = TRUE

/datum/uplink_item/explosives/grenadier
	name = "Пояс гренадера"
	desc = "Пояс, содержащий 26 смертельно опасных и разрушительных гранат. Поставляется с дополнительным мультитулом и отверткой."
	item = /obj/item/storage/belt/grenade/full
	purchasable_from = UPLINK_NUKE_OPS
	cost = 22
	surplus = 0

/datum/uplink_item/explosives/pizza_bomb
	name = "Пицца-бомба"
	desc = "Коробка из-под пиццы с бомбой, хитроумно прикрепленной к крышке. Таймер нужно установить, открыв коробку; после этого,\
			если открыть коробку снова, то по истечении таймера произойдет детонация. Поставляется с бесплатной пиццей для вас или вашей цели!"
	item = /obj/item/pizzabox/bomb
	cost = 6
	surplus = 8

/datum/uplink_item/explosives/soap_clusterbang
	name = "Кластербанг Слипокалипсиса"
	desc = "Традиционная кластерная граната с полезной нагрузкой, полностью состоящей из мыла Синдиката. Пригодится в любом сценарии!"
	item = /obj/item/grenade/clusterbuster/soap
	cost = 3

/datum/uplink_item/explosives/syndicate_bomb
	name = "Бомба Синдиката"
	desc = "страшное устройство, способное произвести массовые разрушения. Она имеет регулируемый таймер, \
			с минимальным временем в 90 секунд для закрепления на месте детонации, предотвращающий перенос бомбы. \
			Громоздкая и не может быть помещена в рюкзаки или карманы; однако при заказе этого товара, вам будет доставлен маячок, \
			который при активации телепортирует к вам настоящую бомбу. Обратите внимание, что эту бомбу можно \
			обезвредить, и некоторые члены экипажа могут попытаться это сделать. \
			Ядро бомбы может быть выломано и взорвано вручную с помощью других взрывчатых веществ."
	item = /obj/item/sbeacondrop/bomb
	cost = 11

/datum/uplink_item/explosives/syndicate_bomb/emp
	name = "ЭМИ-бомба Синдиката"
	desc = "Разновидность синдикатской бомбы, предназначенная для создания огромного электромагнитного импульса."
	item = /obj/item/sbeacondrop/emp
	cost = 7

/datum/uplink_item/explosives/syndicate_detonator
	name = "Детонатор"
	desc = "Устройство, позволяющее детонировать бомбы Синдиката на расстоянии. Просто нажмите на кнопку, \
			и зашифрованная радиочастота даст команду всем бомбам Синдиката взорваться. \
			Пригодится, когда важна скорость или вы хотите синхронизировать несколько взрывов. Убедитесь, что вы не находитесь в радиусе \
			взрыва, прежде чем использовать детонатор."
	item = /obj/item/syndicatedetonator
	cost = 3
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/syndicate_minibomb
	name = "Граната Синдиката"
	desc = "Граната с пятисекундным запалом. При детонации она образует небольшую пробоину в корпусе, \
			а также наносит большой урон находящемуся рядом персоналу."
	item = /obj/item/grenade/syndieminibomb
	cost = 6
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/tearstache
	name = "Усная граната"
	desc = "Граната со слезоточивым газом, которая запускает липкие усы в лицо всем, кто не носит маску клоуна или мима. Усы \
			остаются прикрепленными к лицу всех целей в течение одной минуты, препятствуя использованию дыхательных масок и других подобных устройств."
	item = /obj/item/grenade/chem_grenade/teargas/moustache
	cost = 3
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/viscerators
	name = "Граната с висцераторами"
	desc = "Уникальная граната с мэнхаками, которая при активации запускает рой висцераторов, которые будут преследовать и уничтожать \
			всех неоперативников в округе."
	item = /obj/item/grenade/spawnergrenade/manhacks
	cost = 5
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

//Support and Mechs
/datum/uplink_item/support
	category = "Поддержка и экзокостюмы"
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/support/clown_reinforcement
	name = "Подкрепление-клоун"
	desc = "Вызывает дополнительного клоуна вам в команду, чтобы он разделил с вами веселье, оснащенного полным стартовым снаряжением, но без телекристаллов."
	item = /obj/item/antag_spawner/nuke_ops/clown
	cost = 20
	purchasable_from = UPLINK_CLOWN_OPS
	restricted = TRUE

/datum/uplink_item/support/reinforcement
	name = "Подкрепление"
	desc = "Вызывает дополнительного оперативника вам в команду. У него не будет никакого снаряжения, поэтому вам придется оставить немного телекристаллов, \
			чтобы вооружить его."
	item = /obj/item/antag_spawner/nuke_ops
	cost = 25
	refundable = TRUE
	purchasable_from = UPLINK_NUKE_OPS
	restricted = TRUE

/datum/uplink_item/support/reinforcement/assault_borg
	name = "Штурмовой киборг Синдиката"
	desc = "Киборг, созданный и запрограммированный для систематического уничтожения людей, не принадлежащих к Синдикату. \
			Оснащен самозарядным пулеметом, гранатометом, энергетическим мечом, криптографическим секвенсером, пинпоинтером, флэшем и ломом."
	item = /obj/item/antag_spawner/nuke_ops/borg_tele/assault
	refundable = TRUE
	cost = 65
	restricted = TRUE

/datum/uplink_item/support/reinforcement/medical_borg
	name = "Медицинский киборг Синдиката"
	desc = "Боевой медицинский киборг. Имеет ограниченный наступательный потенциал, но с лихвой компенсирует его своими вспомогательными возможностями. \
			Оснащен нанитовым гипоспреем, медицинским лучом, боевым дефибриллятором, полным хирургическим набором, включая энергетическую пилу, криптографический секвенсор, пинпоинтер и флэш. \
			Благодаря сумке для хранения органов, он может проводить операции не хуже любого гуманоида."
	item = /obj/item/antag_spawner/nuke_ops/borg_tele/medical
	refundable = TRUE
	cost = 35
	restricted = TRUE

/datum/uplink_item/support/reinforcement/saboteur_borg
	name = "Диверсионный киборг Синдиката"
	desc = "Перекрашенный инженерный киборг, оснащенный скрытыми модулями. \
			Помимо обычного инженерного оборудования, оснащен специальным маркером назначения, позволяющим преодолевать сети утилизации. \
			Его проектор-хамелеон позволяет ему маскироваться под киборга NanoTrasen, а также у него есть тепловое зрение и пинпоинтер."
	item = /obj/item/antag_spawner/nuke_ops/borg_tele/saboteur
	refundable = TRUE
	cost = 35
	restricted = TRUE

/datum/uplink_item/support/gygax
	name = "Темный Гигакс"
	desc = "Легкий экзокостюм, окрашенный в темный цвет. Его скорость и выбор снаряжения делают его отличным \
			для атак в стиле \"бей и беги\". Имеет дробовик, усилитель брони против атак ближнего и дальнего боя, ионные движители и энергетическую пушку Тесла."
	item = /obj/vehicle/sealed/mecha/combat/gygax/dark/loaded
	cost = 80

/datum/uplink_item/support/honker
	name = "Темный Х.О.Н.К."
	desc = "Боевой мех клоуна, оснащенный гранатометами с бомбананами и слезными усами, а также вездесущим HoNkER BlAsT 5000."
	item = /obj/vehicle/sealed/mecha/combat/honker/dark/loaded
	cost = 80
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/support/mauler
	name = "Темный Маулер"
	desc = "Массивный и невероятно смертоносный экзокостюм военного класса. Имеет дальнее наведение, вектор тяги \
			и развертываемым дымом. Оснащен пулемётом, карабином Scattershot, ракетной установкой, противоракетной броней и энергетической решеткой Тесла."
	item = /obj/vehicle/sealed/mecha/combat/marauder/mauler/loaded
	cost = 140

/datum/uplink_item/support/turretbox
	name = "Развёртываемая турель"
	desc = "Многоразовая система развертывания турели, ловко замаскированная под ящик с инструментами, с применением гаечного ключа для функциональности. Встречайте - инженер!"
	item = /obj/item/storage/toolbox/emergency/turret/nukie
	cost = 16

// Stealth Items
/datum/uplink_item/stealthy_tools
	category = "Стелс-гаджеты"

/datum/uplink_item/stealthy_tools/armorpolish
	name = "Бронирующая полироль"
	desc = "Этот полироль, рассчитанный на два применения, позволяет укрепить одежду до прочности, не уступающей стандартному бронежилету.  \
			Усиленная нанитами, она позволит вам сохранить привлекательный внешний вид, пока вы устраиваете резню на станции. \
			Осторожно, полировать можно только костюмы и головные уборы!"
	item = /obj/item/armorpolish
	cost = 9

/datum/uplink_item/stealthy_tools/reflectivepolish
    name = "Отражающая полироль"
    desc = "Этот полироль, рассчитанный на два использования, укрепляет одежду, обеспечивая повышенную защиту от лазерного и энергитического оружия."
    item = /obj/item/armorpolish/reflective
    cost = 10

/datum/uplink_item/stealthy_tools/agent_card
	name = "Идентификационная карта агента"
	desc = "Хамелеон-карта, не позволяющая ИИ отслеживать владельца. \
			Позволяет изменять вид карты и надписи на ней, но не добавляет доступа. Может \"воровать\" доступы с других карт, проведясь картой агента по ним. \
			Имеет неограниченное использование. Доступ в некоторые зоны и устройства Синдиката возможен только \
			только с помощью этих карт"
	item = /obj/item/card/id/advanced/chameleon
	cost = 2

/datum/uplink_item/stealthy_tools/ai_detector
	name = "Детектор ИИ"
	desc = "Функциональный мультитул, который меняет цвет на индикаторе, когда обнаруживает, что за ним наблюдает искусственный интеллект. \
			Полезен для того, чтобы знать, когда нужно укрыться, а обнаружение близлежащих \
			слепых зон может помочь вам определить пути."
	item = /obj/item/multitool/ai_detect
	cost = 1

/datum/uplink_item/stealthy_tools/chameleon
	name = "Набор Хамелеона"
	desc = "Набор с костюмом, содержащий технологию хамелеона, позволяющую пользователю маскироваться под практически любую вещь на станции, и многое другое! \
			В связи с сокращением бюджета, обувь не обеспечивает защиту от скольжения, а чипы навыков продаются отдельно."
	item = /obj/item/storage/box/syndie_kit/chameleon
	cost = 2
	purchasable_from = ~UPLINK_NUKE_OPS //clown ops are allowed to buy this kit, since it's basically a costume

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Проектор-хамелеон"
	desc = "Проецирует изображение на пользователя, маскируя его под сканируемый объект, до тех пор, пока он не \
			уберет проектор из рук. Замаскированные пользователи двигаются медленно, а снаряды пролетают над ними."
	item = /obj/item/chameleon
	cost = 7

/datum/uplink_item/stealthy_tools/codespeak_manual
	name = "Руководство по кодовому языку"
	desc = "Агенты синдиката могут быть обучены использовать серию кодовых слов для передачи сложной информации, которая для любого слушателя звучит как случайные термины или названия напитков. \
			Это руководство научит вас этому кодовому языку. Вы также можете ударить кого-то другого этим пособием, чтобы научить его. Имеет неограниченное использование."
	item = /obj/item/language_manual/codespeak_manual/unlimited
	cost = 3

/datum/uplink_item/stealthy_tools/combatbananashoes
	name = "Боевые банановые ботинки"
	desc = "В отличие от обычных ботинок боевого клоуна, эти ботинки невосприимчивы к большинству атак на скольжение, \
			могут генерировать большое количество синтетической банановой кожуры, когда владелец идет, ускользая от потенциальных преследователей. Они также \
			скрипят значительно громче."
	item = /obj/item/clothing/shoes/clown_shoes/banana_shoes/combat
	cost = 6
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/stealthy_tools/emplight
	name = "ЭМИ фонарик"
	desc = "Маленькое, самозаряжающееся, короткодействующее электромагнитное устройство, замаскированное под рабочий фонарик. \
			Полезно для выведения из строя гарнитур, камер, дверей, шкафчиков и боргов во время скрытных операций. \
			Атакуя цель этим фонариком, он направляет на нее ЭМ импульс, расходуя заряд."
	item = /obj/item/flashlight/emp
	cost = 4
	surplus = 30

/datum/uplink_item/stealthy_tools/mulligan
	name = "Муллиган"
	desc = "Вы облажались и у вас на хвосте служба безопасности? Этот удобный шприц даст вам совершенно новую личность \
			и внешность."
	item = /obj/item/reagent_containers/syringe/mulligan
	cost = 4
	surplus = 30
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "Нескользящие ботинки-хамелеоны"
	desc = "Эта обувь позволит владельцу бегать по мокрому полу и скользким предметам, не падая. \
			Не работают на сильно смазанных поверхностях."
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 2
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	player_minimum = 20

/datum/uplink_item/stealthy_tools/syndigaloshes/nuke
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/suits/modsuit/elite
	name = "Elite Syndicate MODsuit"
	desc = "An upgraded, elite version of the Syndicate MODsuit. It features fireproofing, and also \
			provides the user with superior armor and mobility compared to the standard Syndicate MODsuit."
	item = /obj/item/mod/control/pre_equipped/elite
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/energy_shield
	name = "MODsuit Energy Shield Module"
	desc = "An energy shield module for a MODsuit. The shields can handle up to three impacts \
			within a short duration and will rapidly recharge while not under fire."
	item = /obj/item/mod/module/energy_shield
	cost = 15
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/emp_shield
	name = "MODsuit Advanced EMP Shield Module"
	desc = "An advanced EMP shield module for a MODsuit. It protects your entire body from electromagnetic pulses."
	item = /obj/item/mod/module/emp_shield/advanced
	cost = 5
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/injector
	name = "MODsuit Injector Module"
	desc = "An injector module for a MODsuit. It is an extendable piercing injector with 30u capacity."
	item = /obj/item/mod/module/injector
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/holster
	name = "MODsuit Holster Module"
	desc = "A holster module for a MODsuit. It can stealthily store any not too heavy gun inside it."
	item = /obj/item/mod/module/holster
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/stealthy_tools/jammer
	name = "Радиоглушилка"
	desc = "Устройство, при активации которого создает помехи для любой исходящей радиосвязи поблизости. Не влияет на бинарный канал."
	item = /obj/item/jammer
	cost = 5

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Сумка контрабандиста"
	desc = "Этот ранец достаточно тонок, чтобы его можно было спрятать в щели между обшивкой и плиткой; отлично подходит для того, чтобы спрятать \
			краденное. Поставляется с ломом, напольной плиткой и кое-какой контрабандой внутри."
	item = /obj/item/storage/backpack/satchel/flat/with_tools
	cost = 1
	surplus = 30
	illegal_tech = FALSE

//Space Suits and Hardsuits
/datum/uplink_item/suits
	category = "Скафандры"
	surplus = 40

/datum/uplink_item/suits/infiltrator_bundle
	name = "Чемодан лазутчика"
	desc = "Разработанный компанией Roseus Galactic совместно с Gorlex Marauders для создания эффективного костюма для городских операций. \
			Этот костюм дешевле, чем стандартный скафандр, и не имеет ограничений в движении, как устаревшие скафандры, используемые корпорацией. \
			В комплект входит бронежилет, шлем, ботинки, костюм, специализированные боевые перчатки и высокотехнологичная балаклава. Кейс также довольно полезен в качестве контейнера для хранения различного вооружения."
	item = /obj/item/storage/toolbox/infiltrator
	cost = 6
	limited_stock = 1 //you only get one so you don't end up with too many gun cases
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/suits/space_suit
	name = "Скафандр Синдиката"
	desc = "Этот красно-черный скафандр Синдиката менее громоздкий, чем варианты NTС, \
			помещается в сумки и имеет слот для оружия. Тем не менее, члены экипажа NanoTrasen обучены сообщать о замеченных красных скафандрах."
	item = /obj/item/storage/box/syndie_kit/space
	cost = 4

// Low progression cost

/datum/uplink_item/suits/modsuit
	name = "Syndicate MODsuit"
	desc = "The feared MODsuit of a Syndicate agent. Features armoring and a set of inbuilt modules."
	item = /obj/item/mod/control/pre_equipped/traitor
	cost = 8
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS) //you can't buy it in nuke, because the elite modsuit costs the same while being better

/datum/uplink_item/suits/thermal
	name = "MODsuit Thermal Visor Module"
	desc = "A visor for a MODsuit. Lets you see living beings through walls."
	item = /obj/item/mod/module/visor/thermal
	cost = 3

/datum/uplink_item/suits/night
	name = "MODsuit Night Visor Module"
	desc = "A visor for a MODsuit. Lets you see clearer in the dark."
	item = /obj/item/mod/module/visor/night
	cost = 2

/datum/uplink_item/suits/chameleon
	name = "MODsuit Chameleon Module"
	desc = "A MODsuit module that lets the suit disguise itself as other objects."
	item = /obj/item/mod/module/chameleon
	cost = 2

/datum/uplink_item/suits/plate_compression
	name = "MODsuit Plate Compression Module"
	desc = "A MODsuit module that lets the suit compress into a smaller size. Not compatible with storage modules."
	item = /obj/item/mod/module/plate_compression
	cost = 2

// Medium progression cost

/datum/uplink_item/suits/noslip
	name = "MODsuit Anti-Slip Module"
	desc = "A MODsuit module preventing the user from slipping on water."
	item = /obj/item/mod/module/noslip
	cost = 2

// Very high progression cost

/datum/uplink_item/suits/modsuit/elite_traitor
	name = "Elite Syndicate MODsuit"
	desc = "An upgraded, elite version of the Syndicate MODsuit. It features fireproofing, and also \
			provides the user with superior armor and mobility compared to the standard Syndicate MODsuit."
	item = /obj/item/mod/control/pre_equipped/traitor_elite
	// This one costs more than the nuke op counterpart
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	cost = 16

/datum/uplink_item/suits/hardsuit
	name = "Хардсьют Синдиката"
	desc = "Страшный костюм оперативника Синдиката. Имеет немного лучшую броню по сравнению с его устаревшим аналогом и встроенный реактивный ранец \
			который работает от стандартных баллонов. Переключение костюма из режима космоса \
			в боевой позволит вам получить всю мобильность свободного облегающего костюма без ущерба для брони. \
			Кроме того, костюм является складным, что делает его достаточно маленьким, чтобы поместиться в рюкзак. \
			Известно, что экипаж NanoTrasen, заметивший эти костюмы, впадает в панику."
	item = /obj/item/clothing/suit/space/hardsuit/syndi
	cost = 8
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS) //you can't buy it in nuke, because the elite hardsuit costs the same while being better

/datum/uplink_item/suits/hardsuit/elite
	name = "Элитный хардсьют Синдиката"
	desc = "Улучшенная, элитная версия комбинезона Синдиката. Имеет огнеупорную защиту, а также \
			обеспечивает пользователю лучшую броню и мобильность по сравнению со стандартным хардсьютом Синдиката."
	item = /obj/item/clothing/suit/space/hardsuit/syndi/elite
	cost = 8
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/hardsuit/shielded
	name = "Щитовой хардсьют Синдиката"
	desc = "Усовершенствованная версия стандартного хардсьюта Синдиката. Имеет встроенную энергетическую систему защиты. \
			Щиты могут выдержать до трех ударов в течение короткого времени и быстро перезаряжаются, пока не находятся под атакой."
	item = /obj/item/clothing/suit/space/hardsuit/shielded/syndi
	cost = 30
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

// Devices and Tools
/datum/uplink_item/device_tools
	category = "Разное"

/datum/uplink_item/device_tools/cutouts
	name = "Адаптивные выкройки из картона"
	desc = "Картонные вырезки, покрытые тонким материалом, который предотвращает обесцвечивание и делает изображения на них более реалистичными. \
			В этой упаковке их три, а также мелки для изменения их внешнего вида."
	item = /obj/item/storage/box/syndie_kit/cutouts
	cost = 1
	surplus = 20

/datum/uplink_item/device_tools/assault_pod
	name = "Устройство целеуказания штурмового пода"
	desc = "Используйте это для выбора зоны приземления вашей штурмовой капсулы."
	item = /obj/item/assault_pod
	cost = 30
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	restricted = TRUE

/datum/uplink_item/device_tools/binary
	name = "Ключ двоичного ретранслятора"
	desc = "Ключ, который, будучи вставленным в радиогарнитуру, позволяет вам слушать и разговаривать с кремниевыми формами жизни, такими как ИИ и киборги, по их частному бинарному каналу. \
			Следует соблюдать осторожность, так как если они не являются вашими союзниками, и они запрограммированы сообщать о таких вмешательствах."
	item = /obj/item/encryptionkey/binary
	cost = 5
	surplus = 75
	restricted = TRUE

/datum/uplink_item/device_tools/magboots
	name = "Кроваво-красные магнитные ботинки"
	desc = "Пара магнитных ботинок с раскраской Синдиката, которые помогают свободнее передвигаться в космосе или на станции во время сбоев гравитационного генератора. \
			Эти магнитные ботинки замедляют носителя в симулированных гравитационных средах так же, как и стандартные ботинки корпорации."
	item = /obj/item/clothing/shoes/magboots/syndie
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/device_tools/briefcase_launchpad
	name = "Чемоданчик с телепадом"
	desc = "Кейс, содержащий пусковую установку, устройство, способное телепортировать предметы и людей к целям, расположенным на расстоянии до восьми метров от кейса. \
			Также в портфель входит пульт дистанционного управления, замаскированный под обычную папку. Прикоснитесь пультом к портфелю, чтобы связать его."
	surplus = 0
	item = /obj/item/storage/briefcase/launchpad
	cost = 6

/datum/uplink_item/device_tools/syndicate_teleporter
	name = "Экспериментальный телепортер Синдиката"
	desc = "Портативное устройство, которое телепортирует пользователя на 4-8 метров вперед. Осторожно, телепортирование в стену вызовет параллельный экстренный телепорт; \
			однако, если это не сработает, вам, возможно, придётся сшиться с кем-то. Поставляется с 4 зарядами, заряжается случайным образом. Гарантия нулевая и будет аннулирована ещё раз, если он подвергается воздействию электромагнитного импульса."
	item = /obj/item/storage/box/syndie_kit/syndicate_teleporter
	cost = 8

/datum/uplink_item/device_tools/camera_bug
	name = "Жучок камеры"
	desc = "Позволяет просматривать все камеры в основной сети, настраивать оповещения о движении и отслеживать цель. \
			Подслушивание камер позволяет отключать их удаленно."
	item = /obj/item/camera_bug
	cost = 1
	surplus = 90

/datum/uplink_item/device_tools/military_belt
	name = "Разгрузка"
	desc = "Робастная разгрузка, имеющая 8 подсумок, способная удерживать всевозможное тактическое снаряжение."
	item = /obj/item/storage/belt/military
	cost = 1

/datum/uplink_item/device_tools/emag
	name = "Криптографический секвенсор"
	desc = "Криптографический секвенсор, электромагнитная карта, или емаг - это маленькая карта, которая отпирает скрытые функции в электронных устройствах, \
			подрывает предназначенные функции какого-либо оборудования и легко ломает защитные механизмы. Не может быть использована для открытия шлюзов"
	item = /obj/item/card/emag
	cost = 4

/datum/uplink_item/device_tools/syndie_jaws_of_life
	name = "Гидравлические ножницы Синдиката"
	desc = "Переработанная версия гидравлических ножниц Нанотрейзен. Как и оригинал может использоваться для форсированного открытия воздушных шлюзов."
	item = /obj/item/crowbar/power/syndicate
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/device_tools/doorjack
	name = "Карта обхода аутентификации шлюза"
	desc = "Специализированный криптографический секвенсор, специально разработанный для взлома шлюзов станции. \
			После взлома определенного количества шлюзов устройству потребуется некоторое время для перезарядки."
	item = /obj/item/card/emag/doorjack
	cost = 3

/datum/uplink_item/device_tools/fakenucleardisk
	name = "Ложный диск ядерной аутентификации"
	desc = "Это обычный диск. Визуально он идентичен настоящему, но он не выдержит более тщательного изучения капитаном. \
			Не пытайтесь отдать этот диск нам, чтобы выполнить вашу же задачу, ведь мы знаем лучше вас!"
	item = /obj/item/disk/nuclear/fake
	cost = 1
	surplus = 1
	illegal_tech = FALSE

/datum/uplink_item/device_tools/frame
	name = "Диск F.R.A.M.E."
	desc = "При установке в планшет этот картридж дает вам пять вирусов для планшета, которые \
			при использовании заставляют целевой планшет стать новым аплинком с нулевым ТК, и немедленно разблокируется. \
			Вы получите код разблокировки после активации вируса, и новый аплинк может быть заряжен \
			телекристаллами в обычном режиме. Так же является хорошим выбором для подставы кого-то из членов экипажа."
	item = /obj/item/computer_disk/virus/frame
	cost = 4
	restricted = TRUE

/datum/uplink_item/device_tools/failsafe
	name = "Код самоуничтожения аплинка"
	desc = "После ввода аплинк немедленно самоуничтожится."
	item = /obj/effect/gibspawner/generic
	cost = 1
	surplus = 0
	restricted = TRUE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/device_tools/failsafe/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	if(!U)
		return
	U.failsafe_code = U.generate_code()
	var/code = "[islist(U.failsafe_code) ? english_list(U.failsafe_code) : U.failsafe_code]"
	to_chat(user, span_warning("Новый код для самоподрыва: [code]."))
	if(user.mind)
		user.mind.store_memory("Код для самоуничтожения аплинка [U.parent] : [code]")
	return U.parent //For log icon

/datum/uplink_item/device_tools/toolbox
	name = "Набор с инструментами Синдиката"
	desc = "Ящик с инструментами Синдиката, выполненный в подозрительном черно-красном цвете. \
			В нем полный набор инструментов, включая мультитул и боевые перчатки, которые устойчивы к ударам и высоким температурам."
	item = /obj/item/storage/toolbox/syndicate
	cost = 1
	illegal_tech = FALSE

/datum/uplink_item/device_tools/hacked_module
	name = "Взломанный модуль загрузки законов ИИ"
	desc = "При использовании с консолью загрузки, этот модуль позволяет загружать приоритетные законы в искусственный интеллект. \
			Будьте осторожны с формулировками, так как искусственные интеллекты могут искать лазейки для использования."
	item = /obj/item/ai_module/syndicate
	cost = 4

/datum/uplink_item/device_tools/hypnotic_flash
	name = "Гипнофлэш"
	desc = "Модифицированная вспышка, способная загипнотизировать цель. Если цель не находится в психически уязвимом состоянии, она лишь временно запутает и успокоит её."
	item = /obj/item/assembly/flash/hypnotic
	cost = 7

/datum/uplink_item/device_tools/hypnotic_grenade
	name = "Гипнотическая граната"
	desc = "Модифицированная светошумовая граната, способная гипнотизировать цели. Звуковая часть гранаты вызывает галлюцинации, а вспышка позволяет ввести зрителей в гипнотический транс."
	item = /obj/item/grenade/hypnotic
	cost = 12

/datum/uplink_item/device_tools/medgun
	name = "Медицинский луч"
	desc = "Чудо инженерной мысли Синдиката, медицинский луч, позволяет медику поддерживать своих товарищей \
			в бою, даже находясь под огнем. Не пересекайте лучи!"
	item = /obj/item/gun/medbeam
	cost = 15
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/device_tools/singularity_beacon
	name = "Энергетический маячок"
	desc = "Когда это большое устройство прикручено к проводке, подключенной к электрической сети, и активировано, \
			оно притягивает к себе любые активные гравитационные сингулярности или Теслу. Это не сработает, \
			если двигатель все еще защищён. Из-за его размера, его нельзя переносить. \
			Заказав его, вы получите маленький маячок, который при активации телепортирует большой маяк в ваше местоположение."
	item = /obj/item/sbeacondrop
	cost = 10

/datum/uplink_item/device_tools/powersink
	name = "Энергопоглотитель"
	desc = "Когда это большое устройство прикручивается к проводам, подключенным к электросети, и активируется, оно загорается и создает чрезмерную нагрузку на сеть, \
			вызывая отключение электричества на всей станции, поглощая её. Энергопоглотитель имеет большие размеры и не может храниться в большинстве традиционных сумок и коробок. \
			Осторожно: взорвётся, если энергосеть содержит достаточное количество энергии."
	item = /obj/item/powersink
	cost = 11

/datum/uplink_item/device_tools/rad_laser
	name = "Радиоактивный микролазер"
	desc = "Радиоактивный микролазер, замаскированный под стандартный анализатор здоровья NanoTrasen. \
			При использовании он испускает мощный всплеск радиации, который после короткой задержки может вывести из строя всех, \
			кроме самых защищенных гуманоидов. У него есть две настройки: интенсивность, которая регулирует мощность излучения, \
			и длина волны, которая регулирует задержку перед началом действия."
	item = /obj/item/healthanalyzer/rad_laser
	cost = 3

/datum/uplink_item/device_tools/stimpack
	name = "Стимпак"
	desc = "Стимпаки, инструмент многих великих героев, делают вас почти неуязвимым к оглушению и нокдаунам примерно на \
			5 минут после введения в организм."
	item = /obj/item/reagent_containers/hypospray/medipen/stimulants
	cost = 5
	surplus = 90

/datum/uplink_item/device_tools/medkit
	name = "Набор боевого медика Синдиката"
	desc = "Аптечка, имеющая подозрительный черно-красный цвет. В комплект входит инъектор боевого стимулятора для быстрого заживления, \
			ПНВ с медицинским интерфейсом для быстрой идентификации раненых и другие предметы, полезные для полевого медика."
	item = /obj/item/storage/firstaid/tactical
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/device_tools/soap
	name = "Мыло Синдиката"
	desc = "Зловеще выглядящее поверхностно-активное мыло, используемое для очистки пятен крови, чтобы скрыть убийства и предотвратить анализ ДНК. \
			Вы также можете бросить его под ноги, чтобы на нём подскользнулись ваши преследователи."
	item = /obj/item/soap/syndie
	cost = 1
	surplus = 50
	illegal_tech = FALSE

/datum/uplink_item/device_tools/surgerybag
	name = "Хирургическая сумка Синдиката"
	desc = "Хирургический вещевой мешок Синдиката, содержащий все хирургические инструменты и \
			ММИ марки Синдиката, а также смирительную рубашку и намордник."
	item = /obj/item/storage/backpack/duffelbag/syndie/surgery
	cost = 3

/datum/uplink_item/device_tools/encryptionkey
	name = "Ключ шифрования Синдиката"
	desc = "Ключ, который, будучи вставленным в радиогарнитуру, позволяет прослушивать все каналы отдела станции \
			а также общаться по зашифрованному каналу Синдиката с другими агентами, имеющими такой же ключ."
	item = /obj/item/encryptionkey/syndicate
	cost = 2
	surplus = 75
	restricted = TRUE

/datum/uplink_item/device_tools/syndietome
	name = "Том Синдиката"
	desc = "Используя редкие артефакты, приобретенные за большие деньги, \
			Синдикат переработал кажущиеся магическими книги определенного культа. \
			Не обладая эзотерическими способностями оригиналов, эти неполноценные копии все же весьма полезны, \
			они могут принести как пользу, так и горе на поле боя, даже если иногда откусят палец."
	item = /obj/item/storage/book/bible/syndicate
	cost = 5

/datum/uplink_item/device_tools/thermal
	name = "Хамелеонные термальные очки"
	desc = "Тепловизиооные очки с технологией хамелеона, позволяющая изменять их вид. \
			Они позволяют видеть организмы сквозь стены, улавливая верхнюю часть инфракрасного спектра света, \
			излучаемого объектами в виде тепла и света. Более горячие объекты, такие как теплые тела, кибернетические организмы и ядра \
			искусственного интеллекта, излучают больше света, чем более холодные объекты, такие как стены и шлюзы."
	item = /obj/item/clothing/glasses/thermal/syndi
	cost = 4

/datum/uplink_item/device_tools/potion
	name = "Зелье разума Синдиката"
	item = /obj/item/slimepotion/slime/sentience/nuclear
	desc = "Зелье, добытое с большим риском для жизни оперативниками Синдиката под прикрытием, а затем модифицированное с помощью технологии Синдиката. \
			С помощью этого зелья любое животное становится разумным и обязано служить вам, а также ему вживляется внутреннее радио для связи и внутренняя идентификационная карта для открытия дверей."
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	restricted = TRUE

/datum/uplink_item/device_tools/suspiciousphone
	name = "Телефон с протоколом CRAB-17"
	desc = "Телефон с протоколом CRAB-17, позаимствованный у неизвестного третьего лица, он может быть использован для обвала космического рынка, перечисляя потери средств экипажа на ваш банковский счет.\
			Экипаж может перевести свои средства на новый банковский счет, если только они не ходлеры, в таком случае они заслуживают этого."
	item = /obj/item/suspiciousphone
	restricted = TRUE
	cost = 7
	limited_stock = 1

/datum/uplink_item/device_tools/guerillagloves
	name = "Партизанские перчатки"
	desc = "Пара высокопрочных боевых перчаток для захвата, которые отлично подходят для проведения захватов на близком расстоянии, с дополнительной изоляционной подкладкой. Осторожно, не ударьтесь о стену!"
	item = /obj/item/clothing/gloves/tackler/combat/insulated
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	cost = 2
	illegal_tech = FALSE

/datum/uplink_item/device_tools/loic_remote
	name = "Пульт управления ионной пушкой LOIC"
	desc = "Синдикат недавно установил поблизости удаленный спутник, способный генерировать локальную ионную бурю каждые 20 минут. \
			Однако при его активации местные власти будут проинформированы о вашем общем местонахождении."
	item = /obj/item/device/loic_remote
	// TODO: When /datum/corporation/self is pickable for non-AI traitors, add it here.
	limited_stock = 1 // Might be too annoying if someone had mulitple.
	cost = 5 // Lacks the precision that a hacked law board (at 4 TCs) would give, but can be used on the go.


// Implants
/datum/uplink_item/implants
	category = "Импланты"
	surplus = 50

/datum/uplink_item/implants/adrenal
	name = "Адреналиновый имплант"
	desc = "Имплантат, который вводится в тело и активируется по желанию пользователя. Он впрыскивает химический \
			коктейль, который позволяет вам выходить из оглушения. По возможности избегайте больших доз."
	item = /obj/item/storage/box/syndie_kit/imp_adrenal
	cost = 8
	player_minimum = 25

/datum/uplink_item/implants/antistun
	name = "Имплант восстановления ЦНС"
	desc = "Имплант, позволяющий вам быстрее встать на ноги после оглушения. Поставляется с автохирургом."
	item = /obj/item/autosurgeon/organ/syndicate/anti_stun
	cost = 12
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/implants/freedom
	name = "Имплант свободы"
	desc = "Имплантат, который вводится в тело и активируется по желанию пользователя. \
			Использование импланта освобождает пользователя от наручников и иных средств ограничения."
	item = /obj/item/storage/box/syndie_kit/imp_freedom
	cost = 5

/datum/uplink_item/implants/microbomb
	name = "Имплант микробомбы"
	desc = "Имплант, вводимый в тело и активируемый вручную или автоматически после смерти. \
			Чем больше имплантатов внутри вас, тем выше взрывная сила. Тем не менее, это навсегда разрушит ваше тело, и вы не получите свою страховку."
	item = /obj/item/storage/box/syndie_kit/imp_microbomb
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/implants/macrobomb
	name = "Имплант макробомбы"
	desc = "Имплант, вводимый в тело и активируемый вручную или автоматически после смерти. \
			После смерти производит мощный взрыв, который уничтожает все вокруг. Не забывайте предупредить своих товарищей по команде, если вы покупаете этот имплант."
	item = /obj/item/storage/box/syndie_kit/imp_macrobomb
	cost = 20
	purchasable_from = UPLINK_NUKE_OPS
	restricted = TRUE

/datum/uplink_item/implants/radio
	name = "Внутренний радиоимплант Синдиката"
	desc = "Имплантат, вводимый в тело, позволяющий использовать внутреннее радио Синдиката. \
			Используется как обычная гарнитура, но может быть отключена, чтобы нормально использовать внешние гарнитуры и избежать обнаружения."
	item = /obj/item/storage/box/syndie_kit/imp_radio
	cost = 4
	restricted = TRUE

/datum/uplink_item/implants/reviver
	name = "Имплант оживления"
	desc = "Этот имплант попытается оживить и вылечить вас, если вы потеряете сознание. Поставляется с автохирургом."
	item = /obj/item/autosurgeon/organ/syndicate/reviver
	cost = 8
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/implants/stealthimplant
	name = "Стелс-имплант"
	desc = "Этот единственный в своем роде имплант сделает вас почти невидимым, если вы правильно разыграете свои карты. \
			При активации он спрячет вас внутри картонной коробки-хамелеона, которая откроется только тогда, когда кто-то на нее наткнется."
	item = /obj/item/storage/box/syndie_kit/imp_stealth
	cost = 8

/datum/uplink_item/implants/storage
	name = "Имплант хранения"
	desc = "Имплантат, который вводится в тело и активируется по желанию пользователя. \
			Он открывает небольшой пространственный карман, в котором можно хранить два предмета среднего размера."
	item = /obj/item/storage/box/syndie_kit/imp_storage
	cost = 8

/datum/uplink_item/implants/thermals
	name = "Термальные глаза"
	desc = "Эти кибернетические глаза обеспечат вам тепловое зрение. Поставляется с бесплатным автохирургом."
	item = /obj/item/autosurgeon/organ/syndicate/thermal_eyes
	cost = 8
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/implants/uplink
	name = "Имплант аплинка"
	desc = "Имплант, вводимый в тело и активируемый по желанию пользователя. Изначально не имеет ТК и должен быть заряжен их физической формой. \
			Не обнаруживается медицинскими интерфейсами (кроме хирургического вмешательства) и отлично подходит для побега из заточения."
	item = /obj/item/storage/box/syndie_kit // the actual uplink implant is generated later on in spawn_item
	cost = UPLINK_IMPLANT_TELECRYSTAL_COST
	// An empty uplink is kinda useless.
	surplus = 0
	restricted = TRUE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/implants/uplink/spawn_item(spawn_path, mob/user, datum/component/uplink/purchaser_uplink)
	var/obj/item/storage/box/syndie_kit/uplink_box = ..()
	uplink_box.name = "Коробка импланта аплинка"
	new /obj/item/implanter/uplink(uplink_box, purchaser_uplink.uplink_flag)
	return uplink_box


/datum/uplink_item/implants/xray
	name = "Рентгеновский имплант"
	desc = "Эти кибернетические глаза дадут вам рентгеновское зрение. Поставляется с автохирургом."
	item = /obj/item/autosurgeon/organ/syndicate/xray_eyes
	cost = 10
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/implants/deathrattle
	name = "Коробка с имплантами оповещения смерти"
	desc = "Коллекция имплантов (и один многоразовый имплантер), \
			которые могут быть введены в членов вашей команды. Когда один из членов команды умирает, все остальные владельцы имплантатов \
			получают ментальное сообщение, информирующее их об имени товарища и месте его смерти. \
			В отличие от большинства имплантатов, эти предназначены для вживления в любое существо, биологическое или механическое."
	item = /obj/item/storage/box/syndie_kit/imp_deathrattle
	cost = 4
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/support/aimbot
	name = "Коробка с имплантом боевого ассистента"
	desc = "Когда уж очень хочется попасть в цель."
	item = /obj/item/storage/box/syndie_kit/aimbot
	cost = 10
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_NUKE_OPS

/datum/uplink_item/implants/emp_shield
	name = "Коробка с имплантом ЭМИ щита"
	desc = "Имплант, который делает вас и ваши внутренности невосприимчивыми к электромагнитным помехам, защищая вас от ионного оружия и ЭМИ. \
			В связи с техническими ограничениями при слишком частом срабатывании перегружается и отключается на короткое время."
	item = /obj/item/storage/box/syndie_kit/emp_shield
	cost = 6

//Race-specific items
/datum/uplink_item/race_restricted
	category = "Расовые"
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	surplus = 0

/datum/uplink_item/race_restricted/syndilamp // нахуй эта хуйня нужна?
	name = "Крайне-яркий фонарь"
	desc = "Мы слышали, что мотыльки, такие как вы, очень любят лампы, \
			поэтому мы решили предоставить вам ранний доступ к прототипу марки \"Extra-Bright Lantern™\" Синдиката. Наслаждайтесь!"
	cost = 2
	item = /obj/item/flashlight/lantern/syndicate
	restricted_species = list("moth")

// Role-specific items
/datum/uplink_item/role_restricted
	category = "Спец.-проф."
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	surplus = 0

/datum/uplink_item/role_restricted/ancient_jumpsuit
	name = "Древний комбинезон"
	desc = "Рваный старый комбинезон, который не принесет вам абсолютно никакой пользы."
	item = /obj/item/clothing/under/color/grey/ancient
	cost = 20
	restricted_roles = list(JOB_ASSISTANT)
	surplus = 0

/datum/uplink_item/role_restricted/oldtoolboxclean
	name = "Древний ящик с инструментами"
	desc = "Культовый ящик для инструментов, известная ассистентам по всему миру, \
			специально разработанная для того, чтобы становиться сильнее с каждым телекристаллом внутри! Инструменты и изоляционные перчатки в комплекте."
	item = /obj/item/storage/toolbox/mechanical/old/clean
	cost = 2
	restricted_roles = list(JOB_ASSISTANT)
	surplus = 0

/datum/uplink_item/role_restricted/pie_cannon
	name = "Банановай кримпай пушка"
	desc = "Специальная пушка для пирога для специального клоуна, этот гаджет вмещает до 20 пирогов и автоматически изготавливает один пирог каждые две секунды!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	restricted_roles = list(JOB_CLOWN)
	surplus = 0 //No fun unless you're the clown!

/datum/uplink_item/role_restricted/blastcannon
	name = "Бомбастер"
	desc = "Являясь высокоспециализированным оружием, эта пушка на самом деле довольно проста. Она содержит крепление для перепускного клапана резервуара, \
			установленное на наклонной трубе, специально сконструированной для выдерживания экстремального давления и температур, \
			и имеет механический спусковой крючок для приведения в действие перепускного клапана. По сути, он превращает взрывную силу бомбы в \"снаряд\" \
			с узкоугольной взрывной волной. Начинающие ученые могут найти это весьма полезным, \
			так как ударная волна под узким углом, похоже, способна обойти все причуды физики, \
			запрещающие взрывы на расстоянии больше определенного, что позволяет устройству использовать \
			теоретическую мощность бомбы с клапаном переноса, а не фактическую. Простая конструкция делает его легко скрываемым.\
			Мы не продаем бомбастеры лицам старше 12 лет."
	item = /obj/item/gun/blastcannon
	cost = 14 //High cost because of the potential for extreme damage in the hands of a skilled scientist.
	restricted_roles = list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST)

/datum/uplink_item/role_restricted/gorillacubes
	name = "Коробка с кубиками Гориллы"
	desc = "Коробка с тремя кубиками горилл марки Waffle Co. Ешьте много, чтобы стать больше. \
			Осторожно: При контакте с водой продукт может регидратироваться."
	item = /obj/item/storage/box/gorillacubes
	cost = 6
	restricted_roles = list(JOB_GENETICIST, JOB_RESEARCH_DIRECTOR)

/datum/uplink_item/role_restricted/brainwash_disk
	name = "Программа хирургии промывания мозгов"
	desc = "Диск, содержащий процедуру проведения операции по промыванию мозгов, \
			позволяющую внедрить задание в оперируемого. Вставьте в операционную консоль, чтобы включить процедуру."
	item = /obj/item/disk/surgery/brainwashing
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_ROBOTICIST)
	cost = 5

/datum/uplink_item/role_restricted/springlock_module
	name = "Heavily Modified Springlock MODsuit Module"
	desc = "A module that spans the entire size of the MOD unit, sitting under the outer shell. \
		This mechanical exoskeleton pushes out of the way when the user enters and it helps in booting \
		up, but was taken out of modern suits because of the springlock's tendency to \"snap\" back \
		into place when exposed to humidity. You know what it's like to have an entire exoskeleton enter you? \
		This version of the module has been modified to allow for near instant activation of the MODsuit. \
		Useful for quickly getting your MODsuit on/off, or for taking care of a target via a tragic accident."
	item = /obj/item/mod/module/springlock/bite_of_87
	restricted_roles = list(JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR)
	cost = 2

/datum/uplink_item/role_restricted/clown_bomb
	name = "Клоунбомба"
	desc = "Уморительное устройство, способное на массовые розыгрыши. Она имеет регулируемый таймер, \
			с минимальным временем в 90 секунд, и может быть прикручена к полу с помощью гаечного ключа.\
			Громоздкая и не может быть перемещена; при заказе этого товара, вам будет доставлен маячок,\
			который при активации телепортирует к вам настоящую бомбу. Обратите внимание, что эту бомбу можно \
			обезвредить, и некоторые члены экипажа могут попытаться сделать это."
	item = /obj/item/sbeacondrop/clownbomb
	cost = 15
	restricted_roles = list(JOB_CLOWN)

/datum/uplink_item/role_restricted/clumsinessinjector //clown ops can buy this too, but it's in the pointless badassery section for them
	name = "Инъектор неуклюжести"
	desc = "Сделайте себе инъекцию, чтобы стать таким же неуклюжим, как клоун... \
			или сделайте инъекцию кому-нибудь другому, чтобы он стал таким же неуклюжим, как клоун. \
			Полезно для клоунов, которые хотят воссоединиться со своей прежней клоунской натурой, или для клоунов,\
			которые хотят помучить и поиграть со своей жертвой, прежде чем убить ее."
	item = /obj/item/dnainjector/clumsymut
	cost = 1
	restricted_roles = list(JOB_CLOWN)
	illegal_tech = FALSE

/datum/uplink_item/role_restricted/spider_injector
	name = "Австралийский мутатор слизи"
	desc = "Приятель, это было дикое путешествие из сектора Австраликус, \
			но нам удалось получить специальный паучий экстракт от гигантских пауков там. \
			Используйте этот инжектор на ядре золотой слизи, чтобы создать несколько таких же пауков, \
			которых мы нашли на планетах. Они немного приручаются, пока вы не наделите их разумом."
	item = /obj/item/reagent_containers/syringe/spider_extract
	cost = 10
	restricted_roles = list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST, JOB_ROBOTICIST)

/datum/uplink_item/role_restricted/clowncar
	name = "Клоунмобиль"
	desc = "Идеальное средство передвижения для любого достойного клоуна! \
			Просто вставьте свой велосипедный рожок, сядьте внутрь и приготовьтесь к самой смешной поездке в вашей жизни! \
			Вы можете таранить всех встречных космонавтов и запихивать их в свою машину, похищая их и запирая внутри, \
			пока кто-нибудь не спасет их или они не выберутся наружу. Не врезайтесь в стены или торговые автоматы, так как подпружиненные \
			сиденья очень чувствительны. Теперь с включенным механизмом защиты от смазки, который защитит вас от любого разъяренного говнюка! \
			Премиум функции могут быть разблокированы с помощью криптографического секвенсора!"
	item = /obj/vehicle/sealed/car/clowncar
	cost = 20
	restricted_roles = list(JOB_CLOWN)

/datum/uplink_item/role_restricted/haunted_magic_eightball
	name = "Призрачный магический шар"
	desc = "Большинство магических восьмишариков - это игрушки с игральными костями внутри. \
			Хотя по внешнему виду оно идентично безобидной игрушке, это оккультное устройство проникает в мир духов, чтобы найти ответы. \
			Стоит предупредить, что духи часто бывают капризными или просто маленькими засранцами. Чтобы использовать, \
			просто произнесите свой вопрос вслух, а затем начните трясти."
	item = /obj/item/toy/eightball/haunted
	cost = 2
	restricted_roles = list(JOB_CURATOR)
	limited_stock = 1 //please don't spam deadchat

/datum/uplink_item/role_restricted/his_grace
	name = "Его Благодать"
	desc = "Невероятно опасное оружие, найденное на станции, захваченная серой волной. \
		После активации Он жаждет крови и должен быть использован для убийства, чтобы утолить эту жажду. \
		Его милость дарует своему владельцу постепенную регенерацию и полный иммунитет к оглушению, но будьте осторожны: \
		если Он слишком проголодается, Его станет невозможно сбросить, и в конечном итоге он убьет вас, если его не кормить. \
		Однако, если оставить его в покое надолго, он снова погрузится в дремоту. Чтобы активировать Его Милость, просто откройте Его."
	item = /obj/item/his_grace
	cost = 20
	restricted_roles = list(JOB_CHAPLAIN)
	surplus = 5 //Very low chance to get it in a surplus crate even without being the chaplain

/datum/uplink_item/role_restricted/explosive_hot_potato
	name = "Взрывающийся горячая картошка"
	desc = "Картошка, начиненная взрывчаткой. При активации включается специальный механизм, который предотвращает его падение. \
			Единственный способ избавиться от него, если вы держите его в руках, это атаковать им кого-то другого, в результате чего он прикрепляется к этому человеку."
	item = /obj/item/hot_potato/syndicate
	cost = 4
	surplus = 0
	restricted_roles = list(JOB_COOK, JOB_BOTANIST, JOB_CLOWN, JOB_MIME)

/datum/uplink_item/role_restricted/ez_clean_bundle
	name = "Набор очистительных гранат EZ"
	desc = "Коробка с тремя гранатами-чистильщиками, использующими фирменную формулу Waffle Co. \
			Служит в качестве чистящего средства и наносит урон кислотой всем, кто стоит рядом. Кислота действует только на гуманоидов."
	item = /obj/item/storage/box/syndie_kit/ez_clean
	cost = 6
	surplus = 20
	restricted_roles = list(JOB_JANITOR)

/datum/uplink_item/role_restricted/mimery
	name = "Руководство по продвинутой пантомиме"
	desc = "Классическая серия из двух частей о том, как отточить свои навыки мимики. \
			После изучения этой серии пользователь будет уметь создавать невидимые стены 3x1 и стрелять пулями из пальцев. Очевидно, работает только для мимов."
	cost = 12
	item = /obj/item/storage/box/syndie_kit/mimery
	restricted_roles = list(JOB_MIME)
	surplus = 0

/datum/uplink_item/role_restricted/pressure_mod
	name = "Модификатор давления кинетического ускорителя"
	desc = "Модификация, позволяющая кинетическим ускорителям наносить значительно больший урон, находясь вне вакуума. \
			Занимает 35% мощности модификации."
	item = /obj/item/borg/upgrade/modkit/indoors
	cost = 5 //you need two for full damage, so total of 10 for maximum damage
	limited_stock = 2 //you can't use more than two!
	restricted_roles = list(JOB_SHAFT_MINER, JOB_HUNTER)

/datum/uplink_item/role_restricted/magillitis_serum
	name = "Автоинъектор сыворотки Магиллит"
	desc = "Одноразовый автоинъектор, содержащий экспериментальную сыворотку, которая вызывает быстрый мышечный рост у Hominidae. \
			Побочные эффекты могут включать гипертрихоз, вспышки ярости и бесконечное пристрастие к бананам."
	item = /obj/item/reagent_containers/hypospray/medipen/magillitis
	cost = 15
	restricted_roles = list(JOB_GENETICIST, JOB_RESEARCH_DIRECTOR)

/datum/uplink_item/role_restricted/modified_syringe_gun
	name = "Модифицированный шприцемёт"
	desc = "Шприц-пистолет, стреляющий ДНК-инъекторами вместо обычных шприцев."
	item = /obj/item/gun/syringe/dna
	cost = 14
	restricted_roles = list(JOB_GENETICIST, JOB_RESEARCH_DIRECTOR)

/datum/uplink_item/role_restricted/chemical_gun
	name = "Реагентный дротикомёт"
	desc = "Тяжело-модифицированный шприцемёт, способный синтезировать собственные химические дротики, используя исходные реагенты. Вмещает 100 юнитов реагентов."
	item = /obj/item/gun/chem
	cost = 12
	restricted_roles = list(JOB_CHEMIST, JOB_CHIEF_MEDICAL_OFFICER, JOB_BOTANIST)

/datum/uplink_item/role_restricted/scarecrow
	name = "Набор пугала"
	desc = "Включает в себя 6 газовых гранат с психотропными веществами и маску, замкнутого цикла не требующую кислородного балона. Противогаз имеет функцию обратной акселирации фильтров, при использовании выдыхая дым и ненадолго активирую термосенсорный визор."
	item = /obj/item/storage/box/syndie_kit/scarecrow
	cost = 12
	restricted_roles = list(JOB_CHEMIST, JOB_PSYCHOLOGIST)

/datum/uplink_item/role_restricted/reverse_bear_trap
	name = "Обратный медвежий капкан"
	desc = "Изобретательное устройство для казни, надеваемое на голову (насильно). \
			При его включении запускается 1-минутный таймер, установленный на медвежьем капкане. \
			Когда он сработает, челюсти капкана с силой откроются, мгновенно убивая того, кто его носит, разрывая челюсти жертвы пополам. \
			Для применения атакуйте цель без головного убора, и вы наденете его на голову жертвы через три секунды без чужого вмешательства."
	cost = 5
	item = /obj/item/reverse_bear_trap
	restricted_roles = list(JOB_CLOWN)

/datum/uplink_item/role_restricted/reverse_revolver
	name = "Реверс-револьвер"
	desc = "Револьвер, который всегда стреляет в своего пользователя. Случайно уроните оружие и смотрите, как жадные \
			корпоративные свиньи разнесут свои собственные мозги по всей стене. \
			Сам револьвер на самом деле настоящий. \
			Только неуклюжие люди и клоуны могут из него нормально стрелять. Поставляется в коробке с объятиями. Хонк."
	cost = 14
	item = /obj/item/storage/box/hug/reverse_revolver
	restricted_roles = list(JOB_CLOWN)

/datum/uplink_item/role_restricted/apostle_syringe
	name = "Токсин клоуна-апостола"
	desc = "Этот шприц превратит пользователя в нечто очень красивое, но смертельно опасное."
	cost = 20
	item = /obj/item/reagent_containers/hypospray/medipen/apostletoxin
	restricted_roles = list(JOB_CLOWN)

/datum/uplink_item/role_restricted/clownpin
	name = "Ультравеселый крючок для стрельбы"
	desc = "Спусковой крючок, который, будучи вставленным в пистолет, \
			делает его пригодным для использования только клоунами и людьми с генами неуклюжости, заставляя пистолет гудеть всякий раз, \
			когда кто-то пытается выстрелить из него."
	cost = 4
	item = /obj/item/firing_pin/clown/ultra
	restricted_roles = list(JOB_CLOWN)
	illegal_tech = FALSE

/datum/uplink_item/role_restricted/clownsuperpin
	name = "Супер-ультра веселый крючок для стрельбы"
	desc = "Как ультравеселый крючок для стрельбы, только пистолет, в который вы вставляете этот спусковой крочюк, \
			взрывается, когда кто-то, кто не является неуклюжим или клоуном, пытается выстрелить."
	cost = 7
	item = /obj/item/firing_pin/clown/ultra/selfdestruct
	restricted_roles = list(JOB_CLOWN)
	illegal_tech = FALSE

/datum/uplink_item/role_restricted/laser_arm
	name = "Имплант лазерной пушки"
	desc = "Имплантат, который дает вам перезаряжающуюся лазерную пушку внутри руки. Уязвим к ЭМИ. \
			Поставляется с автохирургом синдиката для немедленного применения."
	cost = 10
	item = /obj/item/autosurgeon/organ/syndicate/laser_arm
	restricted_roles = list(JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR)

/datum/uplink_item/role_restricted/bureaucratic_error_remote
	name = "Индуктор вызова бюрократической ошибки"
	desc = "Устройство, которое косвенно делает бюрократический ад в органических ресурсах. Одноразовое использование."
	cost = 2
	limited_stock = 1
	item = /obj/item/devices/ocd_device
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL, JOB_QUARTERMASTER)


/datum/uplink_item/role_restricted/meathook
	name = "Мясной крюк мясника"
	desc = "Брутальное лезвие на длинной цепи, позволяющее притягивать людей к себе. Свежий кабанчик!"
	item = /obj/item/gun/magic/hook
	cost = 11
	restricted_roles = list(JOB_COOK)

/datum/uplink_item/role_restricted/turretbox
	name = "Расходная турель"
	desc = "Одноразовая система развертывания турели, ловко замаскированная под ящик с инструментами, с применением гаечного ключа для функциональности. Встречайте - инженер!"
	item = /obj/item/storage/toolbox/emergency/turret
	cost = 11
	restricted_roles = list(JOB_STATION_ENGINEER)

// Pointless
/datum/uplink_item/badass
	category = "(Бесполезное) Крутое"
	surplus = 0

/datum/uplink_item/badass/costumes/obvious_chameleon
	name = "Сломанный набор хамелеона"
	desc = "Набор предметов, содержащих технологию хамелеона, позволяющую вам маскироваться под практически любую вещь на станции, и многое другое! \
			Пожалуйста, обратите внимание, что этот набор НЕ прошел контроль качества."
	item = /obj/item/storage/box/syndie_kit/chameleon/broken

/datum/uplink_item/badass/costumes
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	cost = 4
	cant_discount = TRUE

/datum/uplink_item/badass/costumes/centcom_official
	name = "Костюм представителя ЦК"
	desc = "Попросите команду \"осмотреть\" их ядерный диск и арсенал, \
			а когда они откажутся, достаньте автоматическую винтовку и расстреляйте капитана. Радиогарнитура не включает ключ шифрования. Оружие в комплект не входит."
	item = /obj/item/storage/box/syndie_kit/centcom_costume

/datum/uplink_item/badass/stickers
	name = "Набор стикеров Синдиката"
	desc = "Содержит 8 случайных наклеек, точно подобранных так, чтобы они напоминали подозрительные предметы, которые могут быть полезны, а могут и не быть полезными для одурачивания экипажа."
	item = /obj/item/storage/box/syndie_kit/stickers
	cost = 1

/datum/uplink_item/badass/costumes/clown
	name = "Костюм клоуна"
	desc = "Нет ничего более страшного, чем клоуны с автоматическим оружием."
	item = /obj/item/storage/backpack/duffelbag/clown/syndie

/datum/uplink_item/badass/costumes/tactical_naptime
	name = "Пижамный комплект"
	desc = "Даже солдатам нужно хорошо выспаться. В комплект входит кроваво-красная пижама, одеяло, кружка горячего какао и пушистый товарищ."
	item = /obj/item/storage/box/syndie_kit/sleepytime
	cost = 4
	limited_stock = 1
	cant_discount = TRUE

/datum/uplink_item/badass/balloon
	name = "Шарик Синдиката"
	desc = "За демонстрацию того, что вы - БОСС: бесполезный красный шар с логотипом Синдиката. \
			Может сорвать самые глубокие покровы."
	item = /obj/item/toy/balloon/syndicate
	cost = 20
	cant_discount = TRUE
	illegal_tech = FALSE

/datum/uplink_item/badass/syndiecash
	name = "Чемодан с деньгами"
	desc = "Надежный портфель, содержащий 500000 космических кредитов. Пригодится для подкупа персонала или покупки товаров и услуг по выгодным ценам. \
			Портфель также кажется немного тяжелее в руках; он был изготовлен, \
			чтобы придать ему больше урона, если вашему клиенту понадобится убедить его."
	item = /obj/item/storage/secure/briefcase/syndie
	cost = 20
	restricted = TRUE
	illegal_tech = FALSE

/datum/uplink_item/badass/syndiecards
	name = "Игральные карты Синдиката"
	desc = "Специальная колода игральных карт космического класса с острым краем и металлическим усилением,\
			что делает их чуть более смертоносными, чем обычная колода карт. Вы также можете играть с ними в карты, очевидно."
	item = /obj/item/toy/cards/deck/syndicate
	cost = 1
	surplus = 40
	illegal_tech = FALSE

/datum/uplink_item/badass/syndiecigs
	name = "Сигареты Синдиката"
	desc = "Сигареты с сильным ароматом и плотным дымом, пропитанные омнизином."
	item = /obj/item/storage/fancy/cigarettes/cigpack_syndicate
	cost = 2
	illegal_tech = FALSE

/datum/uplink_item/badass/clownopclumsinessinjector //clowns can buy this too, but it's in the role-restricted items section for them
	name = "Инъектор неуклюжести"
	desc = "Сделайте себе инъекцию, чтобы стать таким же неуклюжим, как клоун... \
			или сделайте инъекцию кому-нибудь другому, чтобы он стал таким же неуклюжим, как клоун. \
			Полезно для клоунов, которые хотят воссоединиться со своей прежней клоунской натурой, или для садистов,\
			которые хотят помучить и поиграть со своей жертвой, прежде чем убить ее."
	item = /obj/item/dnainjector/clumsymut
	cost = 1
	purchasable_from = UPLINK_CLOWN_OPS
	illegal_tech = FALSE

/datum/uplink_item/badass/executionersword
	name = "Меч палача"
	desc = "Отрубай головы во славу своих фракций."
	item = /obj/item/melee/execution_sword
	cost = 1

/datum/uplink_item/bundles_tc/syndicate_team
	name = "Командный набор"
	desc = "Набор, предназначенный для двух агентов синдиката"
	item = /obj/item/storage/box/syndicate_team
	cost = 40
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/dangerous/hockey
	name = "Набор канадского хоккеиста"
	desc = "Ходят слухи, что канадские хоккеисты - сильнейшие существа в мире."
	item = /obj/item/storage/box/syndie_kit/hockey
	cost = 41
	player_minimum = 20
	surplus = 0
	cant_discount = FALSE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/badass/leetball
	name = "Ботинки футболиста"
	desc = "Специализированная пара спортивных ботинок предназначенных для игры в профессиональный футбол."
	item = /obj/item/clothing/shoes/leetball
	cost = 8

/datum/uplink_item/support/bomb_key
	name = "Syndicate Ordnance Laboratory Access Card"
	desc = "Do you fancy yourself an explosives expert? If so, then consider yourself lucky! With this special Authorization Key, \
			you can blow those corpo suits away with your very own home-made explosive devices. Made in your local firebase's \
			very own Ordnance Laboratory! *The Syndicate is not responsible for injuries or deaths sustained while utilizing the lab."
	item = /obj/item/keycard/syndicate_bomb
	cost = 15
	purchasable_from = UPLINK_NUKE_OPS
	cant_discount = TRUE

/datum/uplink_item/support/bio_key
	name = "Syndicate Bio-Weapon Laboratory Access Card"
	desc = "In the right hands, even vile corpo technology can be turned into a vast arsenal of liberation and justice. From \
			micro-organism symbiosis to slime-core weaponization, this special Authorization Key can let you push past the boundaries \
			of bio-terrorism at breakneck speeds. As a bonus, these labs even come equipped with natural life support! *Plants not included."
	item = /obj/item/keycard/syndicate_bio
	cost = 17
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_NUKE_OPS
	cant_discount = TRUE

/datum/uplink_item/support/chem_key
	name = "Syndicate Chemical Plant Access Card"
	desc = "For some of our best Operatives, watching corpo space stations blow up with a flash of retribution just isn't enough. \
			Folks like those prefer a more personal touch to their artistry. For those interested, a special Authorization Key \
			can be instantly delivered to your location. Create groundbreaking chemical agents, cook up, sell the best of drugs, \
			and listen to the best classic music today!"
	item = /obj/item/keycard/syndicate_chem
	cost = 12
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_NUKE_OPS
	cant_discount = TRUE

/datum/uplink_item/support/fridge_key
	name = "Lopez's Access Card"
	desc = "Hungry? So is everyone in Firebase Balthazord. Lopez is a great cook, don't get me wrong, but he's stubborn when it \
			comes to the meal plans. Sometimes you just want to pig out. Listen, don't tell anyone, ok? I picked this out of his \
			pocket during this morning's briefing. He's been looking for it since. Take it, get into the fridge, and cook up whatever \
			you need before he gets back. And remember: DON'T TELL ANYONE! -M.T"
	item = /obj/item/keycard/syndicate_fridge
	cost = 5
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_NUKE_OPS
