/datum/bounty/item/assistant/strange_object
	name = "Аномальный объект"
	description = "НаноТрейзен интересуется странными предметами. Найдите один в исправности и сразу же отправьте его на ЦК."
	reward = CARGO_CRATE_VALUE * 20
	wanted_types = list(/obj/item/relic)

/datum/bounty/item/assistant/scooter
	name = "Скутер"
	description = "НаноТрейзен решила, что пеший шаг вышел из моды. Отправьте скутер на ЦК, чтобы ускорить работу."
	reward = CARGO_CRATE_VALUE * 50
	wanted_types = list(/obj/vehicle/ridden/scooter)
	include_subtypes = FALSE

/datum/bounty/item/assistant/skateboard
	name = "Скейтборд"
	description = "НаноТрейзен решила, что ходить бессмысленно. Отправьте скейтборд на ЦК, чтобы ускорить работу."
	reward = CARGO_CRATE_VALUE * 40
	wanted_types = list(/obj/vehicle/ridden/scooter/skateboard, /obj/item/melee/skateboard)

/datum/bounty/item/assistant/stunprod
	name = "Самодельный электрошокер"
	description = "ЦК требует использовать палка-оглушалки против диссидентов. Сделайте одну и отправьте на ЦК."
	reward = CARGO_CRATE_VALUE * 30
	wanted_types = list(/obj/item/melee/baton/cattleprod)

/datum/bounty/item/assistant/soap
	name = "Мыло"
	description = "Мыло пропало из ванных комнат ЦК. Никто не знает, кто его взял. Отправьте мыло и станьте героем, в котором нуждается ЦК."
	reward = CARGO_CRATE_VALUE * 40
	required_count = 3
	wanted_types = list(/obj/item/soap)

/datum/bounty/item/assistant/spear
	name = "Копья"
	description = "У Службы Безопасности ЦК сокращение бюджета. Вам заплатят, если вы отправите им набор копий."
	reward = CARGO_CRATE_VALUE * 80
	required_count = 5
	wanted_types = list(/obj/item/spear)

/datum/bounty/item/assistant/toolbox
	name = "Ящик с инструментами"
	description = "На ЦК нехватка робаста! Поспешите и отправьте несколько ящиков с инструментами в качестве решения проблемы."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 6
	wanted_types = list(/obj/item/storage/toolbox)

/datum/bounty/item/assistant/statue
	name = "Статуя"
	description = "ЦК заказало статую художника для вестибюля. Отправьте одну, когда это будет возможно."
	reward = CARGO_CRATE_VALUE * 100
	wanted_types = list(/obj/structure/statue)

/datum/bounty/item/assistant/clown_box
	name = "Коробка клоуна"
	description = "Вселенной нужен смех. Отпечатайте коробку штампом клоуна и отправьте его."
	reward = CARGO_CRATE_VALUE * 50
	wanted_types = list(/obj/item/storage/box/clown)

/datum/bounty/item/assistant/cheesiehonkers
	name = "Сырные Хонкеры"
	description = "Очевидно, что компания, которая делает Сырные Хонкеры, скоро уходит из бизнеса. ЦК хочет запастись ими до того, как это произойдет!"
	reward = CARGO_CRATE_VALUE * 30
	required_count = 3
	wanted_types = list(/obj/item/food/cheesiehonkers)

/datum/bounty/item/assistant/baseball_bat
	name = "Бейсбольная бита"
	description = "В ЦентКоме продолжается бейсбольная лихорадка! Будьте добрыми и отправьте им несколько бейсбольных бит, чтобы руководство смогло осуществить их детскую мечту."
	reward = CARGO_CRATE_VALUE * 35
	required_count = 5
	wanted_types = list(/obj/item/melee/baseball_bat)

/datum/bounty/item/assistant/extendohand
	name = "Расширяющаяся рука"
	description = "Коммандер Бетси стареет и больше не может наклоняться, чтобы достать пульт. Руководство попросило отправить руку, чтобы помочь ей."
	reward = CARGO_CRATE_VALUE * 55
	wanted_types = list(/obj/item/extendohand)

/datum/bounty/item/assistant/donut
	name = "Пончики"
	description = "Силы безопасности ЦК несут большие потери против Синдиката. Отправьте им пончики, чтобы поднять боевой дух."
	reward = CARGO_CRATE_VALUE * 100
	required_count = 10
	wanted_types = list(/obj/item/food/donut)

/datum/bounty/item/assistant/donkpocket
	name = "Донк-Покеты"
	description = "Отзыв безопасности потребителей: Внимание! Донк-Покеты, изготовленные в прошлом году, содержат опасную биоматерию ящерицы. Верните их на ЦК немедленно."
	reward = CARGO_CRATE_VALUE * 100
	required_count = 10
	wanted_types = list(/obj/item/food/donkpocket)

/datum/bounty/item/assistant/briefcase
	name = "Портфель"
	description = "Центральное командование в этом году проведет деловую конвенцию. Отправьте несколько портфелей в их поддержку."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 5
	wanted_types = list(/obj/item/storage/briefcase, /obj/item/storage/secure/briefcase)

/datum/bounty/item/assistant/sunglasses
	name = "Солнечные очки"
	description = "Известный блюзовый дуэт проходит через наш сектор, но они потеряли свои очки и они не могут выступать. Отправьте новые очки на ЦК чтобы исправить это."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 2
	wanted_types = list(/obj/item/clothing/glasses/sunglasses)

/datum/bounty/item/assistant/monkey_hide
	name = "Кожа обезьяны"
	description = "Один из учёных с ЦК заинтересован тестированием продуктов из кожи обезьяны. Ваша задача достать кожу и отправить её на ЦК."
	reward = CARGO_CRATE_VALUE * 25
	wanted_types = list(/obj/item/stack/sheet/animalhide/monkey)

/datum/bounty/item/assistant/shard
	name = "Осколки стекла"
	description = "ЦК преследует убийцу-клоуна и сотрудники не могут поймать его, потому что он не носит обувь. Пожалуйста, отправьте несколько осколков, чтобы сделать ловушку."
	reward = CARGO_CRATE_VALUE * 35
	required_count = 15
	wanted_types = list(/obj/item/shard)

/datum/bounty/item/assistant/comfy_chair
	name = "Удобные кресла"
	description = "Коммандер Пэт недоволен своим креслом. Он утверждает, что у него болит спина. Отправьте несколько кресел, чтобы ублажить его."
	reward = CARGO_CRATE_VALUE * 15
	required_count = 5
	wanted_types = list(/obj/structure/chair/comfy)

/datum/bounty/item/assistant/geranium
	name = "Герань"
	description = "У командира Зота любовь к командиру Зена. Отправьте партию герани - её любимого цветка и он с радостью наградит вас."
	reward = CARGO_CRATE_VALUE * 120
	required_count = 3
	wanted_types = list(/obj/item/food/grown/poppy/geranium)
	include_subtypes = FALSE

/datum/bounty/item/assistant/poppy
	name = "Мак"
	description = "Командир Зот хочет подарить цветы офицеру безопасности Оливии. Отправьте партию маков, и он с радостью наградит вас."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 3
	wanted_types = list(/obj/item/food/grown/poppy)
	include_subtypes = FALSE

/datum/bounty/item/assistant/shadyjims
	name = "Шейди Джим"
	description = "В ЦК разгневанный офицер требует, чтобы он получил пачку сигарет Шейди Джима. Пожалуйста, отправьте одну. Он начинает угрожать."
	reward = CARGO_CRATE_VALUE * 100
	wanted_types = list(/obj/item/storage/fancy/cigarettes/cigpack_shadyjims)

/datum/bounty/item/assistant/potted_plants
	name = "Растения в горшке"
	description = "ЦК планирует ввести в эксплуатацию новую станцию класса BirdBoat. Вам было приказано отправить растения в горшках."
	reward = CARGO_CRATE_VALUE * 70
	required_count = 8
	wanted_types = list(/obj/item/kirbyplants)

/datum/bounty/item/assistant/earmuffs
	name = "Наушники"
	description = "Центральное командование устало от сообщений вашей станции. Они приказали вам отправить несколько наушников, чтобы уменьшить раздражение."
	reward = CARGO_CRATE_VALUE * 100
	wanted_types = list(/obj/item/clothing/ears/earmuffs)

/datum/bounty/item/assistant/handcuffs
	name = "Наручники"
	description = "Большой поток сбежавших осужденных прибыло на ЦК. Сейчас самое подходящее время для отправки запасных наручников."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 5
	wanted_types = list(/obj/item/restraints/handcuffs)

/datum/bounty/item/assistant/monkey_cubes
	name = "Кубики с обезьянами"
	description = "Из-за недавней генетической аварии ЦК остро нуждается в обезьянах. Ваша миссия состоит в том, чтобы отправить им кубики обезьян."
	reward = CARGO_CRATE_VALUE * 70
	required_count = 3
	wanted_types = list(/obj/item/food/monkeycube)

/datum/bounty/item/assistant/chainsaw
	name = "Бензопила"
	description = "У шеф-повара на ЦК возникают проблемы с разделкой животных. Он просит одну бензопилу..."
	reward = CARGO_CRATE_VALUE * 90
	wanted_types = list(/obj/item/chainsaw)

/datum/bounty/item/assistant/ied
	name = "Самодельная зажигательная бомба"
	description = "Тюрьма строгого режима NT на ЦК проходит обучение персонала. Отправьте несколько устройств самодельной взрывчатки, которые будут служить им учебным пособием..."
	reward = CARGO_CRATE_VALUE * 40
	required_count = 3
	wanted_types = list(/obj/item/grenade/iedcasing)

/datum/bounty/item/assistant/bonfire
	name = "Горящий костёр"
	description = "Обогреватели неисправны, и грузовой экипаж Центрального командования начинает мерзнуть. Поставьте зажженный костер, чтобы согреть их."
	reward = CARGO_CRATE_VALUE * 50
	wanted_types = list(/obj/structure/bonfire)

/datum/bounty/item/assistant/bonfire/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/structure/bonfire/B = O
	return !!B.burning

/datum/bounty/item/assistant/corgimeat
	name = "Свежее мясо корги"
	description = "Синдикат недавно украл всё мясо корги у ЦК. Отправьте замену немедленно."
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(/obj/item/food/meat/slab/corgi)

/datum/bounty/item/assistant/action_figures
	name = "Фигурки"
	description = "Сын вице-президента увидел рекламу телешоу по телевизору, и теперь он не умолкает про них. Отправьте немного фигурок, чтобы успокоить сына."
	reward = CARGO_CRATE_VALUE * 100
	required_count = 5
	wanted_types = list(/obj/item/toy/figure)

/datum/bounty/item/assistant/tail_whip
	name = "Девятихвостый кнут"
	description = "Коммандер Джексон ищет прекрасное дополнение к своей коллекции экзотического оружия. Она щедро вознаградит вас за девятихвостый кнут (кнут из ящера учитывается также)"
	reward = CARGO_CRATE_VALUE * 300
	wanted_types = list(/obj/item/melee/chainofcommand/tailwhip)

/datum/bounty/item/assistant/dead_mice
	name = "Мёртвая мышь"
	description = "Недавно открылась сеть ресторанов быстрого питания Хорошая Мышь. Отправьте партию свежих мертвых мышей."
	reward = CARGO_CRATE_VALUE * 35
	required_count = 5
	wanted_types = list(/obj/item/food/deadmouse)

/datum/bounty/item/assistant/paper_bin
	name = "Контейнеры для бумаги"
	description = "В нашем бухгалтерском отделе совсем нет бумаги. Нам немедленно нужна новая партия."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 8
	wanted_types = list(/obj/item/paper_bin)

/datum/bounty/item/assistant/crayons
	name = "Мелки"
	description = "Ребенок доктора Джонса снова съел все наши мелки. Пожалуйста, пришлите нам свои."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 24
	wanted_types = list(/obj/item/toy/crayon)

/datum/bounty/item/assistant/pens
	name = "Ручки"
	description = "Мы проводим межгалактический конкурс по балансировке пера. Нам нужно, чтобы вы прислали стандартные шариковые ручки."
	reward = CARGO_CRATE_VALUE * 40
	required_count = 10
	include_subtypes = TRUE
	wanted_types = list(/obj/item/pen)

/datum/bounty/item/assistant/guitar
	name = "Гитара"
	description = "Мы проводим межгалактический конкурс по игре на музыкальных инструментах. Нам нужно, чтобы вы прислали гитару."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/item/instrument/guitar)

/datum/bounty/item/assistant/eguitar
	name = "Электрогитара"
	description = "Мы проводим межгалактический конкурс по игре на музыкальных инструментах. Нам нужно, чтобы вы прислали электрогитару."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/item/instrument/eguitar)

/datum/bounty/item/assistant/violin
	name = "Скрипка"
	description = "Мы проводим межгалактический конкурс по игре на музыкальных инструментах. Нам нужно, чтобы вы прислали скрипку."
	reward = CARGO_CRATE_VALUE * 60
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/item/instrument/violin)

/datum/bounty/item/assistant/donbas
	name = "Рыба с Дебальцево"
	description = "У сотрудников ЦК закончилось сало. Доставьте им сушёной рыбы"
	reward = CARGO_CRATE_VALUE * 150
	required_count = 3
	include_subtypes = FALSE
	wanted_types = list(/obj/item/food/fishmeat/carp/dry/donbas)

/datum/bounty/item/assistant/donbas
	name = "Русская поваренная книга"
	description = "На станции 16 умер русский повар. Отправьте им несколько 'Русская поваренная книга', чтобы обучить новых специалистов."
	required_count = 2
	include_subtypes = FALSE
	wanted_types = list(/obj/item/book/granter/crafting_recipe/cookbook)

/datum/bounty/item/assistant/gloves
	name = "Резиновые перчатки"
	description = "Асисстенты станции 14 украли все резиновые перчатки. Доставьте им новые!"
	reward = CARGO_CRATE_VALUE * 300
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/item/clothing/gloves/color/yellow)

/datum/bounty/item/assistant/watertank
	name = "Бак с водой"
	description = "На ЦК случился пожар! Доставьте им баки с водой!"
	reward = CARGO_CRATE_VALUE * 150
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/structure/reagent_dispensers/watertank)

/datum/bounty/item/assistant/fueltank
	name = "Бак с топливом"
	description = "На ЦК случился пожар! Доставьте клоуну баки с топливом!"
	reward = CARGO_CRATE_VALUE * 200
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/bounty/item/assistant/turntable
	name = "Взрыв Каробка"
	description = "На станции 15 произошло чаепитие. Они просят музыкальный автомат для продолжения смены."
	reward = CARGO_CRATE_VALUE * 200
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/machinery/turntable)

/datum/bounty/item/assistant/loyalty
	name = "Кейс с имплантами щита разума"
	description = "Одна из станций просит доставить кейс с майндшилд имплантами в связи с революцией на их станции."
	reward = CARGO_CRATE_VALUE * 250
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/item/storage/lockbox/loyalty)

/datum/bounty/item/assistant/captains_spare
	name = "Карта Капитана"
	description = "У одной из станций отсутствует капитанская карточка. Отправьте им свою, получив щедрую награду."
	reward = CARGO_CRATE_VALUE * 5000
	required_count = 1
	include_subtypes = TRUE
	wanted_types = list(/obj/item/card/id/advanced/gold/captains_spare)

/datum/bounty/item/assistant/closet
	name = "Шкафчики и ящики"
	description = "После пожара на одном из штабов ЦК, командованию некуда складывать свои личные вещи. Отправьте им шкафчики или ящики со своей станции."
	reward = CARGO_CRATE_VALUE * 100
	required_count = 10
	include_subtypes = TRUE
	wanted_types = list(/obj/structure/closet)

/datum/bounty/item/assistant/champion
	name = "Пояс Чемпиона"
	description = "Представитель нашей станции выиграл чемпионат по робасту, только вот организаторы забыли купить пояс Чемпиона. СРОЧНО ОТПРАВЬТЕ ЕГО ИМ!!!"
	reward = CARGO_CRATE_VALUE * 1500
	required_count = 1
	include_subtypes = TRUE
	wanted_types = list(/obj/item/storage/belt/champion)

/datum/bounty/item/assistant/space_heater
	name = "Обогреватель"
	description = "После пожара на ЦК система обогрева станции сгорела. Отправьте им обогреватели!"
	reward = CARGO_CRATE_VALUE * 60
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/machinery/space_heater)

/datum/bounty/item/assistant/pumpup
	name = "Самопальный адреналин"
	description = "ДАННЫЕ УДАЛЕНЫ"
	reward = CARGO_CRATE_VALUE * 15
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/item/reagent_containers/hypospray/medipen/pumpup)

/datum/bounty/item/assistant/monkey_recycler
	name = "Переработчик макак"
	description = "Одна из станций просит доставить им плату переработчика макак."
	reward = CARGO_CRATE_VALUE * 30
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/item/circuitboard/machine/monkey_recycler)

/datum/bounty/item/assistant/relic
	name = "Странный предмет"
	description = "ЦК заметило аномальную активность на нашей станции. Отправьте им подозрительные на вид предметы!"
	reward = CARGO_CRATE_VALUE * 70
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/item/relic)

/datum/bounty/item/assistant/nuclearbomb
	name = "Ядерная бомба"
	description = "Мы не знаем, как вы это получите, но если вы случайно её найдёте, то отправьте её нам."
	reward = CARGO_CRATE_VALUE * 5000
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/machinery/nuclearbomb)

/datum/bounty/item/assistant/nuclearbomb_beer
	name = "Пивная ядерная бомба"
	description = "ЦК устроил праздник в честь дня рождения одного из их глав, но у них закончилось пиво. Отправьте им пивную ядерную бомбу!"
	reward = CARGO_CRATE_VALUE * 200
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/machinery/nuclearbomb/beer)

/datum/bounty/item/assistant/tackler
	name = "Перчатки Гориллы"
	description = "На одной из станций произошёл бунт. Отправьте им перчатки перехвата"
	reward = CARGO_CRATE_VALUE * 300
	required_count = 2
	include_subtypes = TRUE
	wanted_types = list(/obj/item/clothing/gloves/tackler)

/datum/bounty/item/assistant/breath
	name = "Дыхательные маски"
	description = "На одной из станций произошёл пожар. Отправьте им дыхательные маски"
	reward = CARGO_CRATE_VALUE * 40
	required_count = 5
	include_subtypes = TRUE
	wanted_types = list(/obj/item/clothing/mask/breath)

/datum/bounty/item/assistant/blackmarket_uplink
	name = "Терминал Чёрного Рынка"
	description = "Не забывайте, что у нас действует программа устранения источников контрабанды!"
	reward = CARGO_CRATE_VALUE * 100
	required_count = 1
	include_subtypes = TRUE
	wanted_types = list(/obj/item/blackmarket_uplink)
