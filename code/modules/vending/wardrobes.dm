/obj/item/vending_refill/wardrobe
	icon_state = "refill_clothes"

/obj/machinery/vending/wardrobe
	default_price = PAYCHECK_ASSISTANT
	extra_price = PAYCHECK_HARD
	payment_department = NO_FREEBIES
	input_display_header = "Returned Clothing"
	light_mask = "wardrobe-light-mask"

/obj/machinery/vending/wardrobe/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "Коммандос"
	desc = "Автомат охраны по продаже спецодежды!"
	icon_state = "secdrobe"
	product_ads = "Лучшая химическая завивка в стиле!;Она красная, поэтому крови не видно!;У тебя есть право быть модной!;Теперь ты можешь быть модной полицией, которой всегда хотел быть!"
	vend_reply = "Спасибо за использование Коммандоса!"
	products = list(
		/obj/item/clothing/suit/hooded/wintercoat/security = 3,
		/obj/item/storage/backpack/security = 3,
		/obj/item/storage/backpack/satchel/sec = 3,
		/obj/item/storage/backpack/duffelbag/sec = 3,
		/obj/item/clothing/under/rank/security/officer = 3,
		/obj/item/clothing/shoes/jackboots = 3,
		/obj/item/clothing/head/beret/sec = 3,
		/obj/item/clothing/head/soft/sec = 3,
		/obj/item/clothing/mask/bandana/striped/security = 3,
		/obj/item/clothing/gloves/color/black = 3,
		/obj/item/clothing/under/rank/security/officer/skirt = 3,
		/obj/item/clothing/under/rank/security/officer/grey = 3,
		/obj/item/clothing/under/pants/khaki = 3,
		/obj/item/clothing/under/rank/security/officer/blueshirt = 3
		)
	premium = list(
		/obj/item/clothing/under/rank/security/officer/formal = 3,
		/obj/item/clothing/suit/security/officer = 3,
		/obj/item/clothing/head/beret/sec/navyofficer = 3
		)
	refill_canister = /obj/item/vending_refill/wardrobe/sec_wardrobe
	payment_department = ACCOUNT_SEC
	light_color = COLOR_MOSTLY_PURE_RED

/obj/item/vending_refill/wardrobe/sec_wardrobe
	machine_name = "Коммандос"

/obj/machinery/vending/wardrobe/medi_wardrobe
	name = "Госпитальер"
	desc = "По слухам, торговый автомат может выдавать одежду для медицинского персонала."
	icon_state = "medidrobe"
	product_ads = "Сделайте эти пятна крови модными!!!"
	vend_reply = "Спасибо за использование Госпитальера!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 4,
		/obj/item/storage/backpack/duffelbag/med = 4,
		/obj/item/storage/backpack/medic = 4,
		/obj/item/storage/backpack/satchel/med = 4,
		/obj/item/clothing/suit/hooded/wintercoat/medical = 4,
		/obj/item/clothing/under/rank/medical/paramedic = 4,
		/obj/item/clothing/under/rank/medical/paramedic/skirt = 4,
		/obj/item/clothing/under/rank/medical/doctor/nurse = 4,
		/obj/item/clothing/head/nursehat = 4,
		/obj/item/clothing/head/beret/medical = 4,
		/obj/item/clothing/head/surgerycap = 4,
		/obj/item/clothing/head/surgerycap/purple = 4,
		/obj/item/clothing/head/surgerycap/green = 4,
		/obj/item/clothing/under/rank/medical/doctor/skirt= 4,
		/obj/item/clothing/under/rank/medical/doctor/blue = 4,
		/obj/item/clothing/under/rank/medical/doctor/green = 4,
		/obj/item/clothing/under/rank/medical/doctor/purple = 4,
		/obj/item/clothing/under/rank/medical/doctor = 4,
		/obj/item/clothing/suit/toggle/labcoat = 4,
		/obj/item/clothing/suit/toggle/labcoat/paramedic = 4,
		/obj/item/clothing/shoes/sneakers/white = 4,
		/obj/item/clothing/head/beret/medical/paramedic = 4,
		/obj/item/clothing/head/soft/paramedic = 4,
		/obj/item/clothing/suit/apron/surgical = 4,
		/obj/item/clothing/mask/surgical = 4
	)
	refill_canister = /obj/item/vending_refill/wardrobe/medi_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/medi_wardrobe
	machine_name = "Госпитальер"

/obj/machinery/vending/wardrobe/engi_wardrobe
	name = "Работяга"
	desc = "Торговый автомат, известный торговлей одеждой промышленного класса."
	icon_state = "engidrobe"
	product_ads = "Гарантированно защитит ноги от несчастных случаев на производстве!;Боитесь радиации? Тогда наденьте желтое!"
	vend_reply = "Спасибо за использование Работяги!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 3,
					/obj/item/storage/backpack/duffelbag/engineering = 3,
					/obj/item/storage/backpack/industrial = 3,
					/obj/item/storage/backpack/satchel/eng = 3,
					/obj/item/clothing/suit/hooded/wintercoat/engineering = 3,
					/obj/item/clothing/under/rank/engineering/engineer = 3,
					/obj/item/clothing/under/rank/engineering/engineer/skirt = 3,
					/obj/item/clothing/under/rank/engineering/engineer/hazard = 3,
					/obj/item/clothing/suit/hazardvest = 3,
					/obj/item/clothing/shoes/workboots = 3,
					/obj/item/clothing/head/beret/engi = 3,
					/obj/item/clothing/mask/bandana/gold = 3,
					/obj/item/clothing/head/hardhat = 3,
					/obj/item/clothing/head/hardhat/weldhat = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/engi_wardrobe
	payment_department = ACCOUNT_ENG
	light_color = COLOR_VIVID_YELLOW

/obj/item/vending_refill/wardrobe/engi_wardrobe
	machine_name = "Работяга"

/obj/machinery/vending/wardrobe/atmos_wardrobe
	name = "Зефир"
	desc = "Этот относительно неизвестный торговый автомат доставляет одежду для техников по атмосфере, работа столь же неизвестная."
	icon_state = "atmosdrobe"
	product_ads = "Возьмите легковоспламеняющуюся одежду прямо здесь!!!"
	vend_reply = "Спасибо за использование Зефира!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 2,
					/obj/item/storage/backpack/duffelbag/engineering = 2,
					/obj/item/storage/backpack/satchel/eng = 2,
					/obj/item/storage/backpack/industrial = 2,
					/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos = 3,
					/obj/item/clothing/under/rank/engineering/atmospheric_technician = 3,
					/obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt = 3,
					/obj/item/clothing/head/beret/atmos = 3,
					/obj/item/clothing/shoes/sneakers/black = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/atmos_wardrobe
	payment_department = ACCOUNT_ENG
	light_color = COLOR_VIVID_YELLOW

/obj/item/vending_refill/wardrobe/atmos_wardrobe
	machine_name = "Зефир"

/obj/machinery/vending/wardrobe/cargo_wardrobe
	name = "Перевозчик"
	desc = "Усовершенствованный торговый автомат для бесплатной покупки грузовой одежды."
	icon_state = "cargodrobe"
	product_ads = "Модернизированный стиль ассистента!;Выберите себе сегодня!;Эти шорты удобны и их легко носить, приобретите сейчас!"
	vend_reply = "Спасибо за использование Перевозчика!"
	products = list(/obj/item/storage/bag/mail = 3,
					/obj/item/clothing/suit/hooded/wintercoat/cargo = 3,
					/obj/item/clothing/under/rank/cargo/tech = 3,
					/obj/item/clothing/under/rank/cargo/tech/skirt = 3,
					/obj/item/clothing/shoes/sneakers/black = 3,
					/obj/item/clothing/gloves/fingerless = 3,
					/obj/item/clothing/head/beret/cargo = 3,
					/obj/item/clothing/head/soft = 3,
					/obj/item/radio/headset/headset_cargo = 3)
	premium = list(
					/obj/item/clothing/under/rank/cargo/miner = 3,
					/obj/item/clothing/head/mailman = 1,
					/obj/item/clothing/under/misc/mailman = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/cargo_wardrobe
	payment_department = ACCOUNT_CAR

/obj/item/vending_refill/wardrobe/cargo_wardrobe
	machine_name = "Перевозчик"

/obj/machinery/vending/wardrobe/robo_wardrobe
	name = "Омниссия"
	desc = "Торговый автомат, предназначенный для раздачи одежды, известный только робототехникам."
	icon_state = "robodrobe"
	product_ads = "Вы превращаете меня в ИСТИНУ, используя определения!;0110001101101100011011110111010001101000011001010111001101101000011001010111001001100101;Во славу Омниссии!"
	vend_reply = "Спасибо за использование Омниссии!"
	products = list(
		/obj/item/clothing/glasses/hud/diagnostic = 2,
		/obj/item/storage/belt/univeral = 2,
		/obj/item/storage/belt/utility = 2,
		/obj/item/clothing/under/rank/rnd/roboticist = 2,
		/obj/item/clothing/under/rank/rnd/roboticist/skirt = 2,
		/obj/item/clothing/suit/toggle/labcoat/roboticist = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/clothing/gloves/fingerless = 2,
		/obj/item/clothing/head/soft/black = 2,
		/obj/item/clothing/mask/bandana/skull/black = 2,
		/obj/item/clothing/suit/hooded/techpriest = 2,
		)
	contraband = list(
		/obj/item/organ/tongue/robot = 2
		)
	refill_canister = /obj/item/vending_refill/wardrobe/robo_wardrobe
	extra_price = PAYCHECK_HARD * 1.2
	payment_department = ACCOUNT_SCI
/obj/item/vending_refill/wardrobe/robo_wardrobe
	machine_name = "Омниссия"

/obj/machinery/vending/wardrobe/science_wardrobe
	name = "Стиль Нобеля"
	desc = "Простой торговый автомат, подходящий для продажи прочно скроенной научной одежды."
	icon_state = "scidrobe"
	product_ads = "Тоска по запаху сожженной плоти? Купите свою научную одежду прямо сейчас!;Сделано с 10% ауксетиков, так что вам не нужно беспокоиться о потере руки!"
	vend_reply = "Спасибо за использование Стиля Нобеля!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 3,
					/obj/item/storage/backpack/science = 3,
					/obj/item/storage/backpack/satchel/tox = 3,
					/obj/item/clothing/head/beret/science = 3,
					/obj/item/clothing/head/beret/science/fancy = 3,
					/obj/item/clothing/mask/bandana/striped/science = 3,
					/obj/item/clothing/suit/hooded/wintercoat/science = 3,
					/obj/item/clothing/under/rank/rnd/scientist = 3,
					/obj/item/clothing/under/rank/rnd/scientist/skirt = 3,
					/obj/item/clothing/suit/toggle/labcoat/science = 3,
					/obj/item/clothing/shoes/sneakers/white = 3,
					/obj/item/radio/headset/headset_sci = 3,
					/obj/item/clothing/mask/gas = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/science_wardrobe
	payment_department = ACCOUNT_SCI
/obj/item/vending_refill/wardrobe/science_wardrobe
	machine_name = "Стиль Нобеля"

/obj/machinery/vending/wardrobe/hydro_wardrobe
	name = "Сельский шик"
	desc = "Машина с запоминающимся названием. Он продает одежду и снаряжение, относящиеся к ботанике."
	icon_state = "hydrobe"
	product_ads = "Вы любите почву? Тогда покупайте нашу одежду!;Приобретайте здесь наряды на свой вкус!"
	vend_reply = "Спасибо за использование Сельского шика!"
	products = list(/obj/item/storage/backpack/botany = 2,
					/obj/item/storage/backpack/satchel/hyd = 2,
					/obj/item/clothing/suit/hooded/wintercoat/hydro = 2,
					/obj/item/clothing/suit/apron = 2,
					/obj/item/clothing/suit/apron/overalls = 3,
					/obj/item/clothing/suit/apron/waders = 3,
					/obj/item/clothing/under/rank/civilian/hydroponics = 3,
					/obj/item/clothing/under/rank/civilian/hydroponics/skirt = 3,
					/obj/item/clothing/mask/bandana/striped/botany = 3,
					/obj/item/clothing/accessory/armband/hydro = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/hydro_wardrobe
	payment_department = ACCOUNT_SRV
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

/obj/item/vending_refill/wardrobe/hydro_wardrobe
	machine_name = "Сельский шик"

/obj/machinery/vending/wardrobe/curator_wardrobe
	name = "Время приключений"
	desc = "Продавец, способный продавать одежду только кураторам и библиотекарям."
	icon_state = "curadrobe"
	product_ads = "Очки для глаз и литература для души - в Времени приключений есть все!;Произведите впечатление и порадуйте посетителей вашей библиотеки расширенной линейкой ручек Время приключений!"
	vend_reply = "Спасибо за использование Времени приключений!"
	products = list(/obj/item/pen = 4,
					/obj/item/pen/red = 2,
					/obj/item/pen/blue = 2,
					/obj/item/pen/fourcolor = 1,
					/obj/item/pen/fountain = 2,
					/obj/item/clothing/accessory/pocketprotector = 2,
					/obj/item/clothing/under/rank/civilian/curator/skirt = 2,
					/obj/item/clothing/under/rank/captain/suit/skirt = 2,
					/obj/item/clothing/under/rank/civilian/head_of_personnel/suit/skirt = 2,
					/obj/item/storage/backpack/satchel/explorer = 1,
					/obj/item/clothing/glasses/regular = 2,
					/obj/item/clothing/glasses/regular/jamjar = 1,
					/obj/item/storage/bag/books = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/curator_wardrobe
	payment_department = ACCOUNT_SRV
/obj/item/vending_refill/wardrobe/curator_wardrobe
	machine_name = "Время приключений"

/obj/machinery/vending/wardrobe/bar_wardrobe
	name = "Октоберфест"
	desc = "Стильный продавец самой стильной одежды для бара!"
	icon_state = "bardrobe"
	product_ads = "Гарантированно защищает от пятен от пролитых напитков!"
	vend_reply = "Спасибо за использование Октоберфеста!"
	products = list(/obj/item/clothing/head/that = 2,
					/obj/item/radio/headset/headset_srv = 2,
					/obj/item/clothing/under/suit/sl = 2,
					/obj/item/clothing/under/rank/civilian/bartender = 2,
					/obj/item/clothing/under/rank/civilian/bartender/purple = 2,
					/obj/item/clothing/under/rank/civilian/bartender/skirt = 2,
					/obj/item/clothing/accessory/waistcoat = 2,
					/obj/item/clothing/suit/apron/purple_bartender = 2,
					/obj/item/clothing/head/soft/black = 2,
					/obj/item/clothing/shoes/sneakers/black = 2,
					/obj/item/reagent_containers/glass/rag = 2,
					/obj/item/storage/box/beanbag = 1,
					/obj/item/clothing/suit/armor/vest/alt = 1,
					/obj/item/circuitboard/machine/dish_drive = 1,
					/obj/item/clothing/glasses/sunglasses/reagent = 1,
					/obj/item/clothing/neck/petcollar = 1,
					/obj/item/storage/belt/bandolier = 1,
					/obj/item/storage/pill_bottle/dice/hazard = 1,
					/obj/item/storage/bag/money = 2)
	premium = list(/obj/item/storage/box/dishdrive = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/bar_wardrobe
	payment_department = ACCOUNT_SRV
	extra_price = PAYCHECK_HARD
/obj/item/vending_refill/wardrobe/bar_wardrobe
	machine_name = "Октоберфест"

/obj/machinery/vending/wardrobe/chef_wardrobe
	name = "Шеф-шеф"
	desc = "Этот торговый автомат может не продавать мясо, но он, безусловно, раздает одежду, связанную с поварством."
	icon_state = "chefdrobe"
	product_ads = "Наша одежда гарантированно защитит вас от брызг еды!"
	vend_reply = "Спасибо за использование Шеф-шефа!"
	products = list(/obj/item/clothing/under/suit/waiter = 2,
					/obj/item/radio/headset/headset_srv = 2,
					/obj/item/clothing/accessory/waistcoat = 2,
					/obj/item/clothing/suit/apron/chef = 3,
					/obj/item/clothing/head/soft/mime = 2,
					/obj/item/storage/box/mousetraps = 2,
					/obj/item/circuitboard/machine/dish_drive = 1,
					/obj/item/clothing/suit/toggle/chef = 1,
					/obj/item/clothing/under/rank/civilian/chef = 1,
					/obj/item/clothing/under/rank/civilian/chef/skirt = 2,
					/obj/item/clothing/head/chefhat = 1,
					/obj/item/clothing/under/rank/civilian/cookjorts = 2,
					/obj/item/clothing/shoes/cookflops = 2,
					/obj/item/reagent_containers/glass/rag = 1,
					/obj/item/clothing/suit/hooded/wintercoat = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/chef_wardrobe
	payment_department = ACCOUNT_SRV
/obj/item/vending_refill/wardrobe/chef_wardrobe
	machine_name = "Шеф-шеф"

/obj/machinery/vending/wardrobe/jani_wardrobe
	name = "Мойдодыр"
	desc = "Автомат с самоочисткой, позволяющий раздавать одежду уборщикам."
	icon_state = "janidrobe"
	product_ads = "Приходите и возьмите свою одежду для уборщиков, которую теперь одобряют уборщики-ящеры повсюду!"
	vend_reply = "Спасибо за использование Мойдодыра!"
	products = list(
		/obj/item/clothing/under/rank/civilian/janitor = 2,
		/obj/item/clothing/under/rank/civilian/janitor/skirt = 2,
		/obj/item/clothing/under/rank/civilian/janitor/maid = 2,
		/obj/item/clothing/suit/hazardvest/janitor = 2,
		/obj/item/clothing/gloves/color/black = 2,
		/obj/item/clothing/head/soft/purple = 2,
		/obj/item/clothing/mask/bandana/purple = 2,
		/obj/item/pushbroom = 2,
		/obj/item/paint/paint_remover = 2,
		/obj/item/melee/flyswatter = 2,
		/obj/item/flashlight = 2,
		/obj/item/clothing/suit/caution = 6,
		/obj/item/holosign_creator = 2,
		/obj/item/lightreplacer = 2,
		/obj/item/soap/nanotrasen = 2,
		/obj/item/storage/bag/trash = 2,
		/obj/item/clothing/shoes/galoshes = 2,
		/obj/item/watertank/janitor = 1,
		/obj/item/storage/belt/janitor = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/jani_wardrobe
	default_price = PAYCHECK_EASY
	extra_price = PAYCHECK_HARD * 0.8
	payment_department = ACCOUNT_SRV
	light_color = COLOR_STRONG_MAGENTA

/obj/item/vending_refill/wardrobe/jani_wardrobe
	machine_name = "Мойдодыр"

/obj/machinery/vending/wardrobe/law_wardrobe
	name = "Сол и Гудмэн"
	desc = "Возражение! В этом гардеробе нет правопорядка... и одежды юриста."
	icon_state = "lawdrobe"
	product_ads = "ВОЗРАЖЕНИЕ! Добейтесь верховенства закона для себя!"
	vend_reply = "Спасибо за использование Сол и Гудмэна!"
	products = list(
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/purpsuit = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer/purple = 1,
		/obj/item/clothing/under/suit/black = 1,
		/obj/item/clothing/under/suit/black/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer/black = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/female = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/female/skirt = 1,
		/obj/item/clothing/under/suit/black_really = 1,
		/obj/item/clothing/under/suit/black_really/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/blue = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/blue/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/red = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/red/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/black = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/black/skirt = 1,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/clothing/accessory/lawyers_badge = 2
		)
	refill_canister = /obj/item/vending_refill/wardrobe/law_wardrobe
	payment_department = ACCOUNT_SRV
/obj/item/vending_refill/wardrobe/law_wardrobe
	machine_name = "Сол и Гудмэн"

/obj/machinery/vending/wardrobe/chap_wardrobe
	name = "Праведник"
	desc = "Эта самая благословенная и святая машина продает одежду, на которую можно смотреть только капелланам."
	icon_state = "chapdrobe"
	product_ads = "Вас беспокоят культисты или надоедливые призраки? Тогда приходи и одевайся как святой! Одежда для мужчин из ткани!"
	vend_reply = "Спасибо за использование Праведника!"
	products = list(
		/obj/item/choice_beacon/holy = 1,
		/obj/item/storage/backpack/cultpack = 1,
		/obj/item/clothing/accessory/pocketprotector/cosmetology = 1,
		/obj/item/clothing/under/rank/civilian/chaplain = 1,
		/obj/item/clothing/under/rank/civilian/chaplain/skirt = 2,
		/obj/item/clothing/shoes/sneakers/black = 1,
		/obj/item/clothing/suit/chaplainsuit/nun = 1,
		/obj/item/clothing/head/nun_hood = 1,
		/obj/item/clothing/suit/chaplainsuit/holidaypriest = 1,
		/obj/item/clothing/suit/hooded/chaplainsuit/monkhabit = 1,
		/obj/item/storage/fancy/candle_box = 2,
		/obj/item/clothing/head/kippah = 3,
		/obj/item/clothing/suit/chaplainsuit/whiterobe = 1,
		/obj/item/clothing/head/taqiyahwhite = 1,
		/obj/item/clothing/head/taqiyahred = 3,
		/obj/item/clothing/suit/chaplainsuit/monkrobeeast = 1,
		/obj/item/clothing/head/rasta = 1,
		/obj/item/grenade/chem_grenade/holy_pena =5,
		)
	contraband = list(
		/obj/item/toy/plush/ratplush = 1,
		/obj/item/toy/plush/narplush = 1,
		/obj/item/clothing/head/medievaljewhat = 3,
		/obj/item/clothing/suit/chaplainsuit/clownpriest = 1,
		/obj/item/clothing/head/clownmitre = 1
		)
	premium = list(
		/obj/item/clothing/suit/chaplainsuit/bishoprobe = 1,
		/obj/item/clothing/head/bishopmitre = 1
		)
	refill_canister = /obj/item/vending_refill/wardrobe/chap_wardrobe
	payment_department = ACCOUNT_SRV
/obj/item/vending_refill/wardrobe/chap_wardrobe
	machine_name = "Праведник"

/obj/machinery/vending/wardrobe/chem_wardrobe
	name = "Мистер Уайт"
	desc = "Торговый автомат по продаже одежды, связанной с химией."
	icon_state = "chemdrobe"
	product_ads = "Наша одежда на 0,5% более устойчива к проливам кислоты! Получите прямо сейчас!"
	vend_reply = "Спасибо за использование \"Мистер Уайт\"!"
	products = list(/obj/item/clothing/under/rank/medical/chemist = 2,
					/obj/item/clothing/under/rank/medical/chemist/skirt = 2,
					/obj/item/clothing/head/beret/medical = 2,
					/obj/item/clothing/shoes/sneakers/white = 2,
					/obj/item/clothing/suit/toggle/labcoat/chemist = 2,
					/obj/item/storage/backpack/chemistry = 2,
					/obj/item/storage/backpack/satchel/chem = 2,
					/obj/item/storage/bag/chemistry = 2,
					/obj/item/ph_booklet = 3)
	contraband = list(/obj/item/reagent_containers/spray/syndicate = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/chem_wardrobe
	payment_department = ACCOUNT_MED
/obj/item/vending_refill/wardrobe/chem_wardrobe
	machine_name = "Мистер Уайт"

/obj/machinery/vending/wardrobe/gene_wardrobe
	name = "Дарвин"
	desc = "Автомат для выдачи одежды, связанной с генетикой."
	icon_state = "genedrobe"
	product_ads = "ПАКУПАЙ АДЕЖДА!;ПИХАЙ ДЕНЬГИ СЮДА!;ВААААГГХХХ!!!!!;АВТОМАТ ДАВИТЬ!ТВОЯ ПОКУПАТЬ!"
	vend_reply = "Спасибо за использование Дарвина!"
	products = list(/obj/item/clothing/under/rank/rnd/geneticist = 2,
					/obj/item/clothing/under/rank/rnd/geneticist/skirt = 2,
					/obj/item/clothing/shoes/sneakers/white = 2,
					/obj/item/clothing/suit/toggle/labcoat/genetics = 2,
					/obj/item/storage/backpack/genetics = 2,
					/obj/item/storage/backpack/satchel/gen = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/gene_wardrobe
	payment_department = ACCOUNT_SCI
/obj/item/vending_refill/wardrobe/gene_wardrobe
	machine_name = "Дарвин"

/obj/machinery/vending/wardrobe/viro_wardrobe
	name = "Петри"
	desc = "Нестерилизованная машина для выдачи одежды, связанной с вирусологией."
	icon_state = "virodrobe"
	product_ads = "Вирусы вас раздражают? Тогда перейдите на стерильную одежду сегодня!"
	vend_reply = "Спасибо за использование Петри"
	products = list(/obj/item/clothing/under/rank/medical/virologist = 2,
					/obj/item/clothing/under/rank/medical/virologist/skirt = 2,
					/obj/item/clothing/head/beret/medical = 2,
					/obj/item/clothing/shoes/sneakers/white = 2,
					/obj/item/clothing/suit/toggle/labcoat/virologist = 2,
					/obj/item/clothing/mask/surgical = 2,
					/obj/item/storage/backpack/virology = 2,
					/obj/item/storage/backpack/satchel/vir = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/viro_wardrobe
	payment_department = ACCOUNT_MED
/obj/item/vending_refill/wardrobe/viro_wardrobe
	machine_name = "Петри"

/obj/machinery/vending/wardrobe/det_wardrobe
	name = "Нуар"
	desc = "Машина для всех ваших детективных потребностей, если вам нужна одежда."
	icon_state = "detdrobe"
	product_ads = "Применяйте свои блестящие дедуктивные методы со стилем!"
	vend_reply = "Спасибо за использование Нуара!"
	products = list(/obj/item/clothing/under/rank/security/detective = 2,
					/obj/item/clothing/under/rank/security/detective/skirt = 2,
					/obj/item/clothing/shoes/sneakers/brown = 2,
					/obj/item/clothing/suit/det_suit = 2,
					/obj/item/clothing/head/fedora/det_hat = 2,
					/obj/item/clothing/under/rank/security/detective/grey = 2,
					/obj/item/clothing/under/rank/security/detective/grey/skirt = 2,
					/obj/item/clothing/accessory/waistcoat = 2,
					/obj/item/clothing/shoes/laceup = 2,
					/obj/item/clothing/suit/det_suit/grey = 1,
					/obj/item/clothing/suit/det_suit/noir = 1,
					/obj/item/clothing/head/fedora = 2,
					/obj/item/clothing/gloves/color/black = 2,
					/obj/item/clothing/gloves/color/latex = 2,
					/obj/item/clothing/under/rank/security/detective/disco = 1,
					/obj/item/clothing/suit/det_suit/disco = 1,
					/obj/item/clothing/shoes/discoshoes = 1,
					/obj/item/clothing/neck/tie/disco = 1,
					/obj/item/clothing/under/rank/security/detective/kim = 1,
					/obj/item/clothing/suit/det_suit/kim = 1,
					/obj/item/clothing/shoes/kim = 1,
					/obj/item/clothing/gloves/kim = 1,
					/obj/item/clothing/glasses/regular/kim = 1,
					/obj/item/reagent_containers/food/drinks/flask/det = 2,
					/obj/item/storage/fancy/cigarettes = 5)
	premium = list(/obj/item/clothing/head/flatcap = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/det_wardrobe
	extra_price = PAYCHECK_COMMAND * 1.75
	payment_department = ACCOUNT_SEC

/obj/item/vending_refill/wardrobe/det_wardrobe
	machine_name = "Нуар"
