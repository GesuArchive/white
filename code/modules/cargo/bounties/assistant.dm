/datum/bounty/item/assistant/strange_object
	name = "Странный обьект"
	description = "Нанотрейзен интересуется странными предметами. Найите один в исправности и сразу же отправьте его на ЦК."
	reward = 20
	wanted_types = list(/obj/item/relic)

/datum/bounty/item/assistant/scooter
	name = "Скутер"
	description = "Нанотрейзен решила что ходить бесполезно. Отправьте скутер на ЦК, чтобы ускорить работу."
	reward = 50
	wanted_types = list(/obj/vehicle/ridden/scooter)
	include_subtypes = FALSE

/datum/bounty/item/assistant/skateboard
	name = "Скейтборд"
	description = "Нанотрейзен решила что ходить бесполезно. Отправьте скейтборд на ЦК, чтобы ускорить работу."
	reward = 40
	wanted_types = list(/obj/vehicle/ridden/scooter/skateboard, /obj/item/melee/skateboard)

/datum/bounty/item/assistant/stunprod
	name = "Палка-Оглушалка"
	description = "ЦК требует использовать палка-оглушалки против диссидентов. Сделайте один, и затем отправьте на ЦК."
	reward = 30
	wanted_types = list(/obj/item/melee/baton/cattleprod)

/datum/bounty/item/assistant/soap
	name = "Мыло"
	description = "Мыло пропало из ванных комнат ЦК. Никто не знает кто его взял. Отправьте мыло и станьте героем, в котором нуждается ЦК."
	reward = 40
	required_count = 3
	wanted_types = list(/obj/item/soap)

/datum/bounty/item/assistant/spear
	name = "Копья"
	description = "У Службы Безопасности ЦК сокращение бюджета. Вам заплатят, если вы отправите им набор копий."
	reward = 80
	required_count = 5
	wanted_types = list(/obj/item/spear)

/datum/bounty/item/assistant/toolbox
	name = "Тулбоксы"
	description = "На ЦК нехватка робаста! Поспешите и отправьте несколько наборов инструментов в качестве решения проблемы."
	reward = 50
	required_count = 6
	wanted_types = list(/obj/item/storage/toolbox)

/datum/bounty/item/assistant/statue
	name = "Статуя"
	description = "ЦК заказало статую художника для вестибюля. Отправьте один, когда это будет возможно."
	reward = 100
	wanted_types = list(/obj/structure/statue)

/datum/bounty/item/assistant/clown_box
	name = "Коробка клоуна"
	description = "Вселенной нужен смех. Отпечатайте корбку штампом клоуна и отправьте его."
	reward = 50
	wanted_types = list(/obj/item/storage/box/clown)

/datum/bounty/item/assistant/cheesiehonkers
	name = "Сырные Хонкеры"
	description = "Очевидно, что компания, которая делает Сырные Хонкеры, скоро уходит из бизнеса. ЦК хочет запастись ими до того, как это произойдет!"
	reward = 30
	required_count = 3
	wanted_types = list(/obj/item/food/cheesiehonkers)

/datum/bounty/item/assistant/baseball_bat
	name = "Бейсбольная бита"
	description = "В ЦентКоме продолжается бейсбольная лихорадка! Будьте добрыми и отправьте им несколько бейсбольных бит, чтобы руководство смогло осуществить их детскую мечту."
	reward = 35
	required_count = 5
	wanted_types = list(/obj/item/melee/baseball_bat)

/datum/bounty/item/assistant/extendohand
	name = "Расширяющаяся рука"
	description = "Коммандер Бетси стареет и больше не может наклоняться, чтобы получить дистанционный пульт. Руководство попросило отправить руку, чтобы помочь ей."
	reward = 55
	wanted_types = list(/obj/item/extendohand)

/datum/bounty/item/assistant/donut
	name = "Пончики"
	description = "Силы безопасности CentCom несут большие потери против Синдиката. Отправьте им пончики, чтобы поднять боевой дух."
	reward = 100
	required_count = 10
	wanted_types = list(/obj/item/food/donut)

/datum/bounty/item/assistant/donkpocket
	name = "Донк-Покеты"
	description = "отзыв безопасности потребителей: Внимание! Донк-Покеты, изготовленные в прошлом году, содержат опасную биоматерию ящерицы. Верните их на ЦК немедленно."
	reward = 75
	required_count = 10
	wanted_types = list(/obj/item/food/donkpocket)

/datum/bounty/item/assistant/briefcase
	name = "Портфель"
	description = "Центральное командование в этом году проведет деловую конвенцию. Отправьте несколько портфелей в их поддержку."
	reward = 120
	required_count = 5
	wanted_types = list(/obj/item/storage/briefcase, /obj/item/storage/secure/briefcase)

/datum/bounty/item/assistant/sunglasses
	name = "Солнечные очки"
	description = "Известный блюзовый дуэт проходит через наш сектор, но они потеряли свои очки и они не могут выступать. Отправьте новые очки на ЦК чтобы исправить это."
	reward = 50
	required_count = 2
	wanted_types = list(/obj/item/clothing/glasses/sunglasses)

/datum/bounty/item/assistant/monkey_hide
	name = "Кожа обезьяны"
	description = "One of the scientists at CentCom is interested in testing products on monkey skin. Your mission is to acquire monkey's hide and ship it."
	reward = 25
	wanted_types = list(/obj/item/stack/sheet/animalhide/monkey)

/datum/bounty/item/assistant/shard
	name = "Осколки стекла"
	description = "ЦК преследует убийцу-клоуна и сотрудники не могут поймать его потому что она не носит обувь. Пожалуйста, отправьте несколько осколков, чтобы сделать ловушку."
	reward = 35
	required_count = 15
	wanted_types = list(/obj/item/shard)

/datum/bounty/item/assistant/comfy_chair
	name = "Удобные кресла"
	description = "Коммандер Пэт недоволен своим креслом. Он утверждает, что у него болит спина. Отправьте несколько кресел чтобы ублажить его."
	reward = 15
	required_count = 5
	wanted_types = list(/obj/structure/chair/comfy)

/datum/bounty/item/assistant/geranium
	name = "Герань"
	description = "У командира Зота любовь к командиру Зена. Отправьте партию герани - её любимого цветка и он с радостью наградит вас."
	reward = 120
	required_count = 3
	wanted_types = list(/obj/item/food/grown/poppy/geranium)
	include_subtypes = FALSE

/datum/bounty/item/assistant/poppy
	name = "Мак"
	description = "Командир Зот хочет подарить цветы офицеру безопасности Оливии. Отправьте партию маков, и он с радостью наградит вас."
	reward = 50
	required_count = 3
	wanted_types = list(/obj/item/food/grown/poppy)
	include_subtypes = FALSE

/datum/bounty/item/assistant/shadyjims
	name = "Шейди Джим"
	description = "В ЦК разгневанный офицер требует, чтобы он получил пачку сигарет Шейди Джима. Пожалуйста, отправьте один. Он начинает угрожать."
	reward = CARGO_CRATE_VALUE
	wanted_types = list(/obj/item/storage/fancy/cigarettes/cigpack_shadyjims)

/datum/bounty/item/assistant/potted_plants
	name = "Растения в горшке"
	description = "ЦК планирует ввести в эксплуатацию новую станцию класса BirdBoat. Вам было приказано отправить растения в горшках."
	reward = 70
	required_count = 8
	wanted_types = list(/obj/item/kirbyplants)

/datum/bounty/item/assistant/earmuffs
	name = "Наушники"
	description = "Центральное командование устало от сообщений вашей станции. Они приказали вам отправить несколько наушников, чтобы уменьшить раздражение."
	reward = 100
	wanted_types = list(/obj/item/clothing/ears/earmuffs)

/datum/bounty/item/assistant/handcuffs
	name = "Наручники"
	description = "Большой поток сбежавших осужденных прибыло на ЦК. Сейчас самое подходящее время для отправки запасных наручников."
	reward = 100
	required_count = 5
	wanted_types = list(/obj/item/restraints/handcuffs)

/datum/bounty/item/assistant/monkey_cubes
	name = "Кубики с обезьянами"
	description = "Из-за недавней генетической аварии ЦК остро нуждается в обезьянах. Ваша миссия состоит в том, чтобы отправить им кубики обезьян."
	reward = 70
	required_count = 3
	wanted_types = list(/obj/item/food/monkeycube)

/datum/bounty/item/assistant/chainsaw
	name = "Бензопила"
	description = "У шеф-повара на ЦК возникают проблемы с разделкой животных. Он просит одну бензопилу..."
	reward = 90
	wanted_types = list(/obj/item/chainsaw)

/datum/bounty/item/assistant/ied
	name = "Самодельная зажигательная бомба"
	description = "Тюрьма строгого режима НТ на ЦК проходит обучение персонала. Отправьте несколько устройств IED, которые будут служить им учебным пособием..."
	reward = 40
	required_count = 3
	wanted_types = list(/obj/item/grenade/iedcasing)

/datum/bounty/item/assistant/bonfire
	name = "Горящий костёр"
	description = "Обогреватели неисправны, и грузовой экипаж Центрального командования начинает мерзнуть. Поставьте зажженный костер, чтобы согреть их."
	reward = 50
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
	reward = CARGO_CRATE_VALUE * 10
	required_count = 5
	wanted_types = list(/obj/item/toy/figure)

/datum/bounty/item/assistant/tail_whip
	name = "Девятихвостый кнут"
	description = "Коммандер Джексон ищет прекрасное дополнение к своей коллекции экзотического оружия. Она щедро вознаградит вас за девятихвостый кнут (кнут из ящера учитывается также)"
	reward = 300
	wanted_types = list(/obj/item/melee/chainofcommand/tailwhip)

/datum/bounty/item/assistant/dead_mice
	name = "Мёртвая мышь"
	description = "Недавно открылась сеть ресторанов быстрого питания RatGood. Отправьте партию свежих мертвых мышей."
	reward = 35
	required_count = 5
	wanted_types = list(/obj/item/food/deadmouse)

/datum/bounty/item/assistant/paper_bin
	name = "Контейнеры для бумаги"
	description = "В нашем бухгалтерском отделе совсем нет бумаги. Нам немедленно нужна новая партия."
	reward = 120
	required_count = 8
	wanted_types = list(/obj/item/paper_bin)

/datum/bounty/item/assistant/crayons
	name = "Мелки"
	description = "Ребенок доктора Джонса снова съел все наши мелки. Пожалуйста, пришлите нам свой."
	reward = 100
	required_count = 24
	wanted_types = list(/obj/item/toy/crayon)

/datum/bounty/item/assistant/pens
	name = "Ручки"
	description = "Мы проводим межгалактический конкурс по балансировке пера. Нам нужно, чтобы вы прислали стандартные шариковые ручки."
	reward = 40
	required_count = 10
	include_subtypes = TRUE
	wanted_types = list(/obj/item/pen)

/datum/bounty/item/assistant/guitar
	name = "Гитара"
	description = "Мы проводим межгалактический конкурс по игре на музыкальных инструментах. Нам нужно, чтобы вы прислали гитару."
	reward = 50
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/item/instrument/guitar)

/datum/bounty/item/assistant/eguitar
	name = "Электрогитара"
	description = "Мы проводим межгалактический конкурс по игре на музыкальных инструментах. Нам нужно, чтобы вы прислали электрогитару."
	reward = 50
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/item/instrument/eguitar)

/datum/bounty/item/assistant/violin
	name = "Скрипка"
	description = "Мы проводим межгалактический конкурс по игре на музыкальных инструментах. Нам нужно, чтобы вы прислали скрипку."
	reward = 60
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/item/instrument/violin)

/datum/bounty/item/assistant/donbas
	name = "Рыба с Дебальцево"
	description = "У сотрудников ЦК закончилось сало. Доставьте им сушёной рыбы"
	reward = 150
	required_count = 3
	include_subtypes = FALSE
	wanted_types = list(/obj/item/food/fishmeat/carp/dry/donbas)

/datum/bounty/item/assistant/donbas
	name = "Русская поваренная книга"
	description = "На станции 16 умер русский повар. Отправьте им несколько 'Русская поваренная книга', чтобы обучить новых специалистов."
	required_count = 4
	include_subtypes = FALSE
	wanted_types = list(/obj/item/book/granter/crafting_recipe/cookbook)

/datum/bounty/item/assistant/gloves
	name = "Резиновые перчатки"
	description = "Асисстенты станции 14 украли все резиновые перчатки. Доставьте им новые!"
	reward = 300
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/item/clothing/gloves/color/yellow)

/datum/bounty/item/assistant/watertank
	name = "Бак с водой"
	description = "На ЦК случился пожар! Доставьте им баки с водой!"
	reward = 150
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/structure/reagent_dispensers/watertank)

/datum/bounty/item/assistant/fueltank
	name = "Бак с топливом"
	description = "На ЦК случился пожар! Доставьте клоуну баки с топливом!"
	reward = 200
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/bounty/item/assistant/turntable
	name = "Взрыв Каробка"
	description = "На станции 15 произошло чаепитие. Они просят музыкальный автомат для продолжения смены."
	reward = 200
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/machinery/turntable)

/datum/bounty/item/assistant/loyalty
	name = "Кейс с имплантами щита разума"
	description = "Одна из станций просит доставить кейс с майндшилд имплантами в связи с революцией на их станции."
	reward = 250
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/item/storage/lockbox/loyalty)

/datum/bounty/item/assistant/captains_spare
	name = "Карта Капитана"
	description = "У одной из станций отсутствует капитанская карточка. Отправьте им свою, получив щедрую награду."
	reward = 5000
	required_count = 1
	include_subtypes = TRUE
	wanted_types = list(/obj/item/card/id/advanced/gold/captains_spare)

/datum/bounty/item/assistant/closet
	name = "Шкафчики и ящики"
	description = "После пожара на одном из штабов ЦК, командованию некуда складывать свои личные вещи. Отправьте им шкафчики или ящики со своей станции.."
	reward = 100
	required_count = 10
	include_subtypes = TRUE
	wanted_types = list(/obj/structure/closet)

/datum/bounty/item/assistant/champion
	name = "Пояс Чемпиона"
	description = "Представитель нашей станции выиграл чемпионат по робасту, только вот организаторы забыли купить пояс Чемпиона. СРОЧНО ОТПРАВЬТЕ ЕГО ИМ!!!"
	reward = 1500
	required_count = 1
	include_subtypes = TRUE
	wanted_types = list(/obj/item/storage/belt/champion)

/datum/bounty/item/assistant/space_heater
	name = "Обогреватель"
	description = "После пожара на ЦК система обогрева станции сгорела. Отправьте им обогреватели!"
	reward = 60
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/machinery/space_heater)

/datum/bounty/item/assistant/pumpup
	name = "Шприц с адреналином из технических тоннелей"
	description = "ДАННЫЕ УДАЛЕНЫ"
	reward = 15
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/item/reagent_containers/hypospray/medipen/pumpup)

/datum/bounty/item/assistant/monkey_recycler
	name = "Переработчик макак"
	description = "Одна из станций просит доставить им плату переработчика макак."
	reward = CARGO_CRATE_VALUE * 3
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/item/circuitboard/machine/monkey_recycler)

/datum/bounty/item/assistant/relic
	name = "Странный предмет"
	description = "ЦК заметило аномальную активность на нашей станции. Отправьте им подозрительные на вид предметы!"
	reward = 70
	required_count = 5
	include_subtypes = FALSE
	wanted_types = list(/obj/item/relic)

/datum/bounty/item/assistant/nuclearbomb
	name = "Ядерная бомба"
	description = "Мы не знаем, как вы это получите, но если вы случайно её найдёте, то отправьте её нам."
	reward = 154009000
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/machinery/nuclearbomb)

/datum/bounty/item/assistant/nuclearbomb_beer
	name = "Пивная ядерная бомба"
	description = "ЦК устроил праздник в честь дня рождения одного из их глав, но у них закончилось пиво. Отправьте им пивную ядерную бомбу!"
	reward = 200
	required_count = 1
	include_subtypes = FALSE
	wanted_types = list(/obj/machinery/nuclearbomb/beer)

/datum/bounty/item/assistant/tackler
	name = "Перчатки Гориллы"
	description = "На одной из станций произошёл бунт. Отправьте им перчатки перехвата"
	reward = 300
	required_count = 2
	include_subtypes = TRUE
	wanted_types = list(/obj/item/clothing/gloves/tackler)

/datum/bounty/item/assistant/breath
	name = "Дыхательные маски"
	description = "На одной из станций произошёл пожар. Отправьте им дыхательные маски"
	reward = 40
	required_count = 5
	include_subtypes = TRUE
	wanted_types = list(/obj/item/clothing/mask/breath)

/datum/bounty/item/assistant/blackmarket_uplink
	name = "Терминал Чёрного Рынка"
	description = "Не забывайте что у нас действует программа устранения источников контрабанды!"
	reward = 100
	required_count = 1
	include_subtypes = TRUE
	wanted_types = list(/obj/item/blackmarket_uplink)
