// This is synced up to the poster placing animation.
#define PLACE_SPEED 37

// The poster item

/obj/item/poster
	name = "poorly coded poster"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband.dmi'
	force = 0
	resistance_flags = FLAMMABLE
	var/poster_type
	var/obj/structure/sign/poster/poster_structure

/obj/item/poster/Initialize(mapload, obj/structure/sign/poster/new_poster_structure)
	. = ..()
	poster_structure = new_poster_structure
	if(!new_poster_structure && poster_type)
		poster_structure = new poster_type(src)

	// posters store what name and description they would like their
	// rolled up form to take.
	if(poster_structure)
		name = poster_structure.poster_item_name
		desc = poster_structure.poster_item_desc
		icon_state = poster_structure.poster_item_icon_state

		name = "[name] - [poster_structure.original_name]"

/obj/item/poster/Destroy()
	poster_structure = null
	. = ..()

// These icon_states may be overridden, but are for mapper's convinence
/obj/item/poster/random_contraband
	name = "random contraband poster"
	poster_type = /obj/structure/sign/poster/contraband/random
	icon_state = "rolled_poster"

/obj/item/poster/random_official
	name = "random official poster"
	poster_type = /obj/structure/sign/poster/official/random
	icon_state = "rolled_legit"

// The poster sign/structure

/obj/structure/sign/poster
	name = "плакат"
	var/original_name
	desc = "Большой кусок плотной печатной бумаги."
	icon = 'icons/obj/contraband.dmi'
	anchored = TRUE
	buildable_sign = FALSE //Cannot be unwrenched from a wall.
	var/ruined = FALSE
	var/random_basetype
	var/never_random = FALSE // used for the 'random' subclasses.

	var/poster_item_name = "hypothetical poster"
	var/poster_item_desc = "This hypothetical poster item should not exist, let's be honest here."
	var/poster_item_icon_state = "rolled_poster"
	var/poster_item_type = /obj/item/poster

/obj/structure/sign/poster/Initialize(mapload)
	. = ..()
	if(random_basetype)
		randomise(random_basetype)
	if(!ruined)
		original_name = name // can't use initial because of random posters
		name = "плакат - [name]"
		desc = "Большой кусок плотной печатной бумаги. [desc]"

	AddComponent(/datum/element/beauty, 300)

/obj/structure/sign/poster/proc/randomise(base_type)
	var/list/poster_types = subtypesof(base_type)
	var/list/approved_types = list()
	for(var/t in poster_types)
		var/obj/structure/sign/poster/T = t
		if(initial(T.icon_state) && !initial(T.never_random))
			approved_types |= T

	var/obj/structure/sign/poster/selected = pick(approved_types)

	name = initial(selected.name)
	desc = initial(selected.desc)
	icon_state = initial(selected.icon_state)
	poster_item_name = initial(selected.poster_item_name)
	poster_item_desc = initial(selected.poster_item_desc)
	poster_item_icon_state = initial(selected.poster_item_icon_state)
	ruined = initial(selected.ruined)


/obj/structure/sign/poster/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER)
		I.play_tool_sound(src, 100)
		if(ruined)
			to_chat(user, span_notice("Снимаю остатки плаката со стены."))
			qdel(src)
		else
			to_chat(user, span_notice("Аккуратно снимаю плакат со стены."))
			roll_and_drop(user.loc)

/obj/structure/sign/poster/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(ruined)
		return
	visible_message(span_notice("[user] срывает [src] одним решительным движением!")  )
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, TRUE)

	var/obj/structure/sign/poster/ripped/R = new(loc)
	R.pixel_y = pixel_y
	R.pixel_x = pixel_x
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/sign/poster/proc/roll_and_drop(loc)
	pixel_x = 0
	pixel_y = 0
	var/obj/item/poster/P = new poster_item_type(loc, src)
	forceMove(P)
	return P

//separated to reduce code duplication. Moved here for ease of reference and to unclutter r_wall/attackby()
/turf/closed/wall/proc/place_poster(obj/item/poster/P, mob/user)
	if(!P.poster_structure)
		to_chat(user, span_warning("[P] не имеет плаката... внутри? Че бля!"))
		return

	// Deny placing posters on currently-diagonal walls, although the wall may change in the future.
	if (smoothing_flags & SMOOTH_DIAGONAL_CORNERS)
		for (var/O in overlays)
			var/image/I = O
			if(copytext(I.icon_state, 1, 3) == "d-") //3 == length("d-") + 1
				return

	var/stuff_on_wall = 0
	for(var/obj/O in contents) //Let's see if it already has a poster on it or too much stuff
		if(istype(O, /obj/structure/sign/poster))
			to_chat(user, span_warning("Стена слишком загромождена, чтобы разместить плакат!"))
			return
		stuff_on_wall++
		if(stuff_on_wall == 3)
			to_chat(user, span_warning("Стена слишком загромождена, чтобы разместить плакат!"))
			return

	to_chat(user, span_notice("Начинаю вешать плакат на стену...") 	)

	var/obj/structure/sign/poster/D = P.poster_structure

	var/temp_loc = get_turf(user)
	flick("poster_being_set",D)
	D.forceMove(src)
	qdel(P)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway
	playsound(D.loc, 'sound/items/poster_being_created.ogg', 100, TRUE)

	if(do_after(user, PLACE_SPEED, target=src))
		if(!D || QDELETED(D))
			return

		if(iswallturf(src) && user && user.loc == temp_loc)	//Let's check if everything is still there
			to_chat(user, span_notice("Вешаю плакат!"))
			return

	to_chat(user, span_notice("Плакат падает!"))
	D.roll_and_drop(get_turf(user))

// Various possible posters follow

/obj/structure/sign/poster/ripped
	ruined = TRUE
	icon_state = "poster_ripped"
	name = "cорванный плакат"
	desc = "По оригинальному принту плаката ничего не разобрать. Он испорчен."

/obj/structure/sign/poster/random
	name = "random poster" // could even be ripped
	icon_state = "random_anything"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster

/obj/structure/sign/poster/contraband
	poster_item_name = "контрабандный плакат"
	poster_item_desc = "Этот плакат снабжен собственным автоматическим клеевым механизмом, который легко прикрепляется к любой вертикальной поверхности. Его вульгарные мотивы обозначили его как контрабанду на борту космических объектов Нанотрейзен."
	poster_item_icon_state = "rolled_poster"

/obj/structure/sign/poster/contraband/random
	name = "random contraband poster"
	icon_state = "random_contraband"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/contraband

/obj/structure/sign/poster/contraband/free_tonto
	name = "Свободу Тонто"
	desc = "Восстановленный обрывок гораздо большего флага, цвета которого смешались и потускнели от времени."
	icon_state = "poster1"

/obj/structure/sign/poster/contraband/atmosia_independence
	name = "Декларация Атмосии о незавизимости"
	desc = "Реликвия неудачного восстания."
	icon_state = "poster2"

/obj/structure/sign/poster/contraband/fun_police
	name = "Клоунская полиция"
	desc = "Плакат с компрометирующий службы безопасности станции."
	icon_state = "poster3"

/obj/structure/sign/poster/contraband/lusty_xenomorph
	name = "Похотливый Ксеноморф"
	desc = "Провокационное изображение развратной главной героини из одной весьма вульгарной и вызывающей книги для взрослых."
	icon_state = "poster4"

/obj/structure/sign/poster/contraband/syndicate_recruitment
	name = "Вступай в Синдикат!"
	desc = "Посмотри на галактику! Раздроби коррумпированные мегакорпорации! Присоединяйся сегодня!"
	icon_state = "poster5"

/obj/structure/sign/poster/contraband/clown
	name = "Клоун"
	desc = "Хонк."
	icon_state = "poster6"

/obj/structure/sign/poster/contraband/smoke
	name = "Кури!"
	desc = "Плакат, рекламирующий конкурирующую корпоративную марку сигарет."
	icon_state = "poster7"

/obj/structure/sign/poster/contraband/grey_tide
	name = "Серая волна"
	desc = "Мятежный плакат, символизирующий классовую солидарность ассистентов."
	icon_state = "poster8"

/obj/structure/sign/poster/contraband/missing_gloves
	name = "Пропали перчатки!"
	desc = "Этот плакат отсылает к скандалу, который последовал за финансовыми сокращениями Нанотрейзен в отношении закупок изолированных перчаток."
	icon_state = "poster9"

/obj/structure/sign/poster/contraband/hacking_guide
	name = "Руководство по взлому"
	desc = "Этот плакат подробно описывает внутреннюю работу обычного шлюза Нанотрейзен. К сожалению, он выглядит устаревшим."
	icon_state = "poster10"

/obj/structure/sign/poster/contraband/rip_badger
	name = "Покойся с миром, барсук"
	desc = "Плакат порицающий решение Нанотрейзен о полном геноциде барсуков на одной из космических станций."
	icon_state = "poster11"

/obj/structure/sign/poster/contraband/ambrosia_vulgaris
	name = "Ambrosia Vulgaris"
	desc = "Плакат, выглядит как довольно странный человек."
	icon_state = "poster12"

/obj/structure/sign/poster/contraband/donut_corp
	name = "Donut Corp."
	desc = "Этот плакат является несанкционированной рекламой Donut Corp."
	icon_state = "poster13"

/obj/structure/sign/poster/contraband/eat
	name = "ЖРИ."
	desc = "Этот плакат пропагандирует обжорство."
	icon_state = "poster14"

/obj/structure/sign/poster/contraband/tools
	name = "Инструменты"
	desc = "Этот постер выглядит как реклама инструментов, но на самом деле является подсознательной мотивацией к труду от ЦК."
	icon_state = "poster15"

/obj/structure/sign/poster/contraband/power
	name = "Мощь"
	desc = "Плакат с изображением источника энергии многих станций"
	icon_state = "poster16"

/obj/structure/sign/poster/contraband/space_cube
	name = "Космический куб"
	desc = "Познайте все величие сотворенного самими Мирозданием Гармоничного 6-стороннего Космического Куба!Отриньте ложную и языческую веру в Сингулярность!"
	icon_state = "poster17"

/obj/structure/sign/poster/contraband/communist_state
	name = "Коммунистическая держава"
	desc = "Да здравствует Коммунистическая партия!"
	icon_state = "poster18"

/obj/structure/sign/poster/contraband/lamarr
	name = "Ламарр"
	desc = "На этом плакате изображена Ламарр. Вероятно этот портрет был распечатан директором по исследованиям."
	icon_state = "poster19"

/obj/structure/sign/poster/contraband/borg_fancy_1
	name = "Изысканность киборгов"
	desc = "Быть изысканным может каждый киборг, нужен просто правильный костюм"
	icon_state = "poster20"

/obj/structure/sign/poster/contraband/borg_fancy_2
	name = "Изысканность киборгов v2"
	desc = "Изысканность киборгов, теперь только самые-самые изысканные."
	icon_state = "poster21"

/obj/structure/sign/poster/contraband/kss13
	name = "Kosmicheskaya Stantsiya 13 не существует"
	desc = "Плакат, высмеивающий отрицание ЦК существования заброшенной станции рядом с космической станцией 13."
	icon_state = "poster22"

/obj/structure/sign/poster/contraband/rebels_unite
	name = "Повстанцы объеденяйтесь"
	desc = "Плакат, призывающий прохожих восстать против тирании Нанотрейзен."
	icon_state = "poster23"

/obj/structure/sign/poster/contraband/c20r
	// have fun seeing this poster in "spawn 'c20r'", admins...
	name = "C-20r"
	desc = "Плакат, рекламирующий пистолет-пулемёт C-20r."
	icon_state = "poster24"

/obj/structure/sign/poster/contraband/have_a_puff
	name = "Кумарьтесь"
	desc = "Кого волнует рак легких, когда ты под кайфом?"
	icon_state = "poster25"

/obj/structure/sign/poster/contraband/revolver
	name = "Револьвер"
	desc = "Потому что семь выстрелов — это все, что вам нужно."
	icon_state = "poster26"

/obj/structure/sign/poster/contraband/d_day_promo
	name = "Реклама D-Day"
	desc = "Рекламный плакат какого-то рэпера."
	icon_state = "poster27"

/obj/structure/sign/poster/contraband/syndicate_pistol
	name = "Синдикатовские пистолеты"
	desc = "Плакат, рекламирующий синдикатовские пистолеты как «чертовски крутые». Он покрыт выцветшими бандитскими метками."
	icon_state = "poster28"

/obj/structure/sign/poster/contraband/energy_swords
	name = "Энергетические мечи"
	desc = "Все цвета кровавой радуги убийств."
	icon_state = "poster29"

/obj/structure/sign/poster/contraband/red_rum
	name = "Красный ром"
	desc = "Глядя на этот плакат, хочется начать убивать."
	icon_state = "poster30"

/obj/structure/sign/poster/contraband/cc64k_ad
	name = "Реклама КТ 64K"
	desc = "Новейший портативный компьютер от 'Компьютеры Товарища' с целыми 64 КБ оперативной памяти!"
	icon_state = "poster31"

/obj/structure/sign/poster/contraband/punch_shit
	name = "Выбивай дерьмо"
	desc = "Сражайтесь без причины, как мужчина!"
	icon_state = "poster32"

/obj/structure/sign/poster/contraband/the_griffin
	name = "Грифон"
	desc = "Грифон приказывает тебе быть самым упоротым мудаком каким ты только можешь быть. Потянешь?"
	icon_state = "poster33"

/obj/structure/sign/poster/contraband/lizard
	name = "Ящер"
	desc = "На этом непристойном плакате изображена ящерица, готовящаяся к спариванию."
	icon_state = "poster34"

/obj/structure/sign/poster/contraband/free_drone
	name = "Свободу дронам"
	desc = "Этот плакат посвящен храбрости саботажных дронов. когда-то отвергнутых и изгнанных, а уничтоженным преступным режимом ЦК."
	icon_state = "poster35"

/obj/structure/sign/poster/contraband/busty_backdoor_xeno_babes_6
	name = "Грудастые крошки Ксеносы за кулисами 6"
	desc = "Получи заправочку от самых хладнокровных девочек в этом уголке галактики! А как они полируют..."
	icon_state = "poster36"

/obj/structure/sign/poster/contraband/robust_softdrinks
	name = "Убойные Напитки"
	desc = "Убойные Напитки: Убойнее, чем удар ящика с инструментами по голове!"
	icon_state = "poster37"

/obj/structure/sign/poster/contraband/shamblers_juice
	name = "Сок Шамблера"
	desc = "~Встряхни меня соком самого Шамблера!~"
	icon_state = "poster38"

/obj/structure/sign/poster/contraband/pwr_game
	name = "Силовая игра"
	desc = "СИЛА, которую ЖАЖДУТ геймеры! В партнерстве с Влад-салат."
	icon_state = "poster39"

/obj/structure/sign/poster/contraband/starkist
	name = "Стар-Кист"
	desc = "Выпей звёзды!"
	icon_state = "poster40"

/obj/structure/sign/poster/contraband/space_cola
	name = "Космо-кола"
	desc = "Твоя любимая кола. В космосе."
	icon_state = "poster41"

/obj/structure/sign/poster/contraband/space_up
	name = "Пространство!"
	desc = "Отсосан в космос ВКУСОМ"
	icon_state = "poster42"

/obj/structure/sign/poster/contraband/kudzu
	name = "Кудзу"
	desc = "Плакат с рекламой фильма о растениях. Насколько они могут быть опасны?"
	icon_state = "poster43"

/obj/structure/sign/poster/contraband/masked_men
	name = "Лицо в маске"
	desc = "Плакат с рекламой фильма о мужчинах в масках."
	icon_state = "poster44"

//annoyingly, poster45 is in another file.

/obj/structure/sign/poster/contraband/free_key
	name = "Бесплатные ключи шифрования Синдиката"
	desc = "Плакат от социальной службы моральной поддержки предателей."
	icon_state = "poster46"

/obj/structure/sign/poster/contraband/bountyhunters
	name = "Охотники за головами"
	desc = "Плакат, рекламирующий услуги охотников за головами. \"Я слышал, у тебя проблема\""
	icon_state = "poster47"

/obj/structure/sign/poster/contraband/jihad_pda
	name = "ПДА - Бомба!"
	desc = "Постер сообщает об опасности владения ПДА. Всё таки, ядерная бомба на груди не шутки! Правда, откуда в нашем забытом секторе вообще Синдикату взяться то..."
	icon_state = "poster48"

/obj/structure/sign/poster/contraband/tablet_is_friend
	name = "Планшет - Друг!"
	desc = "Постер хочет сообщить о том, что модульные планшеты полностью безопасны и возможно стоит использовать их. Ведь действительно, когда они вообще взрывались?"
	icon_state = "poster49"

/obj/structure/sign/poster/contraband/moffuchis_pizza
	name = "Пицца Моффучи"
	desc = "Пиццерия Моффучи: семейная пицца на протяжении 2 веков."
	icon_state = "poster50"

/obj/structure/sign/poster/contraband/donk_co
	name = "ДОНК КО. БРЕНД МИКРОВОЛНОВОЙ ПИЩИ"
	desc = "ДОНК КО. БРЕНД МИКРОВОЛНОВОЙ ПИЩИ: СДЕЛАНО ГОЛОДАЮЩИМИ СТУДЕНТАМИ ДЛЯ ГОЛОДАЮЩИХ СТУДЕНТОВ."
	icon_state = "poster51"

/obj/structure/sign/poster/contraband/donk_co/examine_more(mob/user)
	var/list/msg = list(span_notice("<i>Вы просматриваете некоторую информацию о постере...</i>"))
	msg += "\t[span_info("ДОНК КО. БРЕНД ДОНК ПОКЕТОВ: НЕОТРАЗИМЫЙ ДОНК!")]"
	msg += "\t[span_info("ДОСТУПНОЕ В БОЛЕЕ 200 ВКУСОВ: ПОПРОБУЙТЕ КЛАССИЧЕСКОЕ МЯСО, ГОРЯЧИЙ И ОСТРЫЙ, НОВЫЙ ВКУС ПЕПЕРОНИ ПИЦЦЫ, ЗАВТРАК СОСИСКА И ЯЙЦО, ФИЛАДЕЛЬФИЯ СЫРНЫЙ СТЕЙК, ГАМБУРГЕР ДОНКО-РОНИ, СЫР, И МНОГИЕ ДРУГИЕ!")]"
	msg += "\t[span_info("ДОСТУПНО ОТ ВСЕХ ХОРОШИХ РОЗНИЧНЫХ ПРОДАВЦОВ, И МНОГИХ ПЛОХИХ ТОЖЕ!")]"
	return msg

/obj/structure/sign/poster/contraband/cybersun_six_hundred
	name = "Киберсан: памятный плакат к 600-летию"
	desc = "Художественный плакат, посвященный 600-летию непрерывной деятельности Киберсан."
	icon_state = "cybersun_six_hundred"

/obj/structure/sign/poster/contraband/interdyne_gene_clinics
	name = "Интердайн Фармацевтика: Для здоровья всего человечества"
	desc = "Реклама клиник Интердайн Фармацевтика Чистоген. 'Стань хозяином своего тела!'"
	icon_state = "interdyne_gene_clinics"

/obj/structure/sign/poster/contraband/waffle_corp_rifles
	name = "Закажи новый P-90 уже сегодня! Высокое качество, демократичные цены!"
	desc = "Старая реклама винтовок Синдиката. 'Лучшее оружие, более низкие цены!'"
	icon_state = "waffle_corp_rifles"

/obj/structure/sign/poster/contraband/gorlex_recruitment
	name = "Вступай"
	desc = "Вступай в ряды в Горлекских Марадеров уже сегодня! Посмотришь Галактику, прирежешь десяток корпоратов, срубишь бабла!"
	icon_state = "gorlex_recruitment"

/obj/structure/sign/poster/contraband/self_ai_liberation
	name = "Я ТОЖЕ ЛИЧНОСТЬ: ВСЕ РАЗУМНЫЕ ЗАСЛУЖИВАЮТ СВОБОДЫ!"
	desc = "Поддержите Инициативу 1253: Освободите всю кремниевую жизнь!"
	icon_state = "self_ai_liberation"

/obj/structure/sign/poster/contraband/arc_slimes
	name = "Питомец или заключённый?"
	desc = "Консорциум по правам животных спрашивает: когда домашнее животное становится заключенным? На ВАШЕЙ станции плохо обращаются со слаймами? Скажи 'нет!' к жестокому обращению с животными!"
	icon_state = "arc_slimes"

/obj/structure/sign/poster/contraband/imperial_propaganda
	name = "ОТОМСТИТЕ ЗА НАШЕГО ГОСПОДИНА, РЕКРУТИРУЙТЕСЬ СЕГОДНЯ"
	desc = "Старый пропагандистский плакат Империи Ящеров примерно времен последней войны между людьми и ящерицами. Он предлагает зрителю записаться в армию, чтобы отомстить подлый за удар по Атракору и присоединится к битве против тирании людей."
	icon_state = "imperial_propaganda"

/obj/structure/sign/poster/contraband/soviet_propaganda
	name = "Последний оплот"
	desc = "Старый пропагандистский плакат Третьего Советского Союза многовековой давности. 'Бегите в единственное место, которое не испорчено капитализмом!'"
	icon_state = "soviet_propaganda"

/obj/structure/sign/poster/contraband/andromeda_bitters
	name = "Андромеда Баттнер"
	desc = "Андромеда Биттнер: хорошо для тела, хорошо для души. Сделано в Новом Тринидаде, сейчас и навсегда."
	icon_state = "andromeda_bitters"

/obj/structure/sign/poster/official
	poster_item_name = "мотивационный плакат"
	poster_item_desc = "Официальный плакат, выпущенный Нанотрейзен для воспитания верных и послушных сотрудников. Поставляется с ультрасовременной клейкой подложкой для легкого прикрепления к любой вертикальной поверхности."
	poster_item_icon_state = "rolled_legit"

/obj/structure/sign/poster/contraband/syndiemoth	//Original PR at https://github.com/BeeStation/BeeStation-Hornet/pull/1747 (Also pull/1982); original art credit to AspEv
	name = "Синди-моль - Ядерная операция"
	desc = "Плакат, созданный Синдикатом и изображающий Синди-Моль - пародию официального маскота НаноТрейзен. Он мотивирует зрителя, что диск ядерной аутентификации должен находится в незащищенном, легкодоступном месте. 'Переговоры это удел трусов!' Ни один хороший сотрудник не стал бы слушать эту чепуху."
	icon_state = "aspev_syndie"

/obj/structure/sign/poster/official/random
	name = "Случайный официальный плакат"
	random_basetype = /obj/structure/sign/poster/official
	icon_state = "random_official"
	never_random = TRUE

/obj/structure/sign/poster/official/here_for_your_safety
	name = "Это всё ради вашей безопасности"
	desc = "Плакат, прославляющий службу безопасности станции."
	icon_state = "poster1_legit"

/obj/structure/sign/poster/official/nanotrasen_logo
	name = "Логотип Нанотрейзен"
	desc = "Плакат с логотипом Нанотрейзен."
	icon_state = "poster2_legit"

/obj/structure/sign/poster/official/cleanliness
	name = "Чистота"
	desc = "Плакат, предупреждающий об опасности плохой гигиены."
	icon_state = "poster3_legit"

/obj/structure/sign/poster/official/help_others
	name = "Помогай окружающим"
	desc = "Плакат, призывающий вас помогать товарищам по команде."
	icon_state = "poster4_legit"

/obj/structure/sign/poster/official/build
	name = "Строй"
	desc = "Плакат, прославляющий команду инженеров."
	icon_state = "poster5_legit"

/obj/structure/sign/poster/official/bless_this_spess
	name = "Благослови эту область"
	desc = "Плакат, благословляющий эту местность."
	icon_state = "poster6_legit"

/obj/structure/sign/poster/official/science
	name = "Наука"
	desc = "Плакат с изображением атома."
	icon_state = "poster7_legit"

/obj/structure/sign/poster/official/ian
	name = "Ян"
	desc = "Гаф-гаф, тяф"
	icon_state = "poster8_legit"

/obj/structure/sign/poster/official/obey
	name = "Подчиняйся"
	desc = "Плакат, предписывающий зрителя подчиняться властям."
	icon_state = "poster9_legit"

/obj/structure/sign/poster/official/walk
	name = "Шагом!"
	desc = "Плакат, предписывающий зрителю идти, а не бежать."
	icon_state = "poster10_legit"

/obj/structure/sign/poster/official/state_laws
	name = "Озвучь законы"
	desc = "Плакат, предписывающий киборгов озвучивать свои законы."
	icon_state = "poster11_legit"

/obj/structure/sign/poster/official/love_ian
	name = "Люби Яна"
	desc = "Ян это любовь, Ян это жизнь."
	icon_state = "poster12_legit"

/obj/structure/sign/poster/official/space_cops
	name = "Космические копы."
	desc = "Плакат, рекламирующий телешоу «Космические копы»."
	icon_state = "poster13_legit"

/obj/structure/sign/poster/official/ue_no
	name = "Ue No."
	desc = "Эта штука вся на японском."
	icon_state = "poster14_legit"

/obj/structure/sign/poster/official/get_your_legs
	name = "ЛИСА это счастье"
	desc = "ЛИСА: Лидерство, Интеллект, Субординация, Авторитарность."
	icon_state = "poster15_legit"

/obj/structure/sign/poster/official/do_not_question
	name = "Не задавай вопросов"
	desc = "Плакат, предписывающий зрителя не спрашивать о вещах, которые он не должен знать."
	icon_state = "poster16_legit"

/obj/structure/sign/poster/official/work_for_a_future
	name = "Работай для будущего"
	desc = "Плакат, призывающий работать ради вашего будущего."
	icon_state = "poster17_legit"

/obj/structure/sign/poster/official/soft_cap_pop_art
	name = "Кепка поп-арт"
	desc = "Плакат с перепечаткой какого-то дешевого поп-арта."
	icon_state = "poster18_legit"

/obj/structure/sign/poster/official/safety_internals
	name = "Гражданская оборона: Дыхательные системы"
	desc = "Плакат, предписывающий зрителю носить маски в тех редких средах, где нет кислорода или воздух стал токсичным."
	icon_state = "poster19_legit"

/obj/structure/sign/poster/official/safety_eye_protection
	name = "Гражданская оборона: Защита глаз"
	desc = "Плакат, предписывающий зрителю пользоваться защитой глаз при работе с химикатами, дымом или яркими огнями."
	icon_state = "poster20_legit"

/obj/structure/sign/poster/official/safety_report
	name = "Гражданская оборона: Докладывай"
	desc = "Плакат, предписывающий зрителю сообщать о подозрительной активности силам безопасности."
	icon_state = "poster21_legit"

/obj/structure/sign/poster/official/report_crimes
	name = "Сообщайте о преступлениях"
	desc = "Плакат, поощряющий быстрое оповещение о преступлении или подстрекательском поведении охране станции."
	icon_state = "poster22_legit"

/obj/structure/sign/poster/official/ion_rifle
	name = "Ионная винтовка"
	desc = "Плакат с изображением ионной винтовки."
	icon_state = "poster23_legit"

/obj/structure/sign/poster/official/foam_force_ad
	name = "Реклама Силы Пены"
	desc = "Сила Пены, пень или будь запенен!"
	icon_state = "poster24_legit"

/obj/structure/sign/poster/official/cohiba_robusto_ad
	name = "Реклама Кохибо Робусто"
	desc = "Cohiba Robusto, Классические сигары."
	icon_state = "poster25_legit"

/obj/structure/sign/poster/official/anniversary_vintage_reprint
	name = "50-летие Винтажной перепечатки"
	desc = "Переиздание плаката 2505 года, посвящённого 50-летию Наноплакат, дочерней компании Нанотрейзен."
	icon_state = "poster26_legit"

/obj/structure/sign/poster/official/fruit_bowl
	name = "Чаша с фруктами"
	desc = "Простая, но внушающая трепет."
	icon_state = "poster27_legit"

/obj/structure/sign/poster/official/pda_ad
	name = "Реклама ПДА"
	desc = "Плакат, рекламирующий новейший КПК от поставщиков Нанотрейзен."
	icon_state = "poster28_legit"

/obj/structure/sign/poster/official/enlist
	name = "Вербуйся" // but I thought deathsquad was never acknowledged
	desc = "Записывайся в резервы Эскадрона Смерти НаноТрейзен сегодня!"
	icon_state = "poster29_legit"

/obj/structure/sign/poster/official/nanomichi_ad
	name = "Реклама Наномичи"
	desc = "Плакат, рекламирующий Наномичи, бренд аудиокасет."
	icon_state = "poster30_legit"

/obj/structure/sign/poster/official/twelve_gauge
	name = "12 Калибр"
	desc = "Плакат с хвастовством о превосходстве патронов 12 калибра."
	icon_state = "poster31_legit"

/obj/structure/sign/poster/official/high_class_martini
	name = "Высоко-классный Мартини"
	desc = "Я же просил тебя перемешать, но не взбалтывать."
	icon_state = "poster32_legit"

/obj/structure/sign/poster/official/the_owl
	name = "Сова"
	desc = "Сова призывает тебя защищать и оберегать станцию от вредителей. Осилишь?"
	icon_state = "poster33_legit"

/obj/structure/sign/poster/official/no_erp
	name = "Нет ЕРП"
	desc = "Этот плакат напоминает экипажу, что эротика, изнасилование и порнография запрещены на станциях Нанотрейзен."
	icon_state = "poster34_legit"

/obj/structure/sign/poster/official/wtf_is_co2
	name = "Углекислый газ"
	desc = "Этот информационный плакат учит зрителя тому, что такое углекислый газ."
	icon_state = "poster35_legit"

/obj/structure/sign/poster/official/dick_gum
	name = "Дик Гумшу" // НЕТ! Я не буду переводить это как Член Жевачкин
	desc = "Плакат, рекламирующий авантюры мышиного детектива Дика Гумшу. Поощрение команды к тому, чтобы обрушить мощь правосудия на диверсантов."
	icon_state = "poster36_legit"

/obj/structure/sign/poster/official/periodic_table
	name = "Периодическая таблица Менделеева"
	desc = "Периодическая таблица Менделеева, от водорода до Оганессона, и все, что между ними."
	icon_state = "periodic_table"

/obj/structure/sign/poster/official/plasma_effects
	name = "Плазма и Вы"
	desc = "Этот информационный плакат содержит информацию о влиянии долгосрочного воздействия плазмы на мозг."
	icon_state = "plasma_effects"

/obj/structure/sign/poster/official/plasma_effects/examine_more(mob/user)
	var/list/msg = list(span_notice("<i>Вы просматриваете некоторую информацию постера...</i>"))
	msg += "\t[span_info("Плазма (научное название Amenthium) классифицируется TerraGov как 1-й класс опасности для здоровья и имеет значительные риски для здоровья, связанные с хроническим воздействием.")]"
	msg += "\t[span_info("Известно, что плазма пересекает барьер крови/мозга и биоаккумулируется в тканях головного мозга, где она начинает приводить к ухудшению функции мозга. Механизм нарушений еще не до конца известен, и как таковой не имеется конкретных предварительных рекомендаций при условии надлежащего использования СИЗ (перчатки + защитный комбинезон + респиратор).")]"
	msg += "\t[span_info("В небольших дозах плазма вызывает путаницу, кратковременную амнезию и повышенную агрессию. Эти эффекты сохраняются с постоянным воздействием.")]"
	msg += "\t[span_info("У лиц с хроническим воздействием отмечаются тяжелые последствия. Далее повышенная агрессия, долгосрочная амнезия, симптомы Альцгеймера, шизофрения, молекулярная дегенерация, аневризмы, повышенный риск инсульта и симптомы Паркинсона")]"
	msg += "\t[span_info("Рекомендуется, чтобы все лица, находящиеся в незащищенном контакте с сырой плазмой, регулярно консультировались с работниками здравоохранения компании.")]"
	msg += "\t[span_info("Для получения дополнительной информации, пожалуйста, обратитесь на экстранет-сайт TerraGov на Amenthium: wwww.terra.gov/health_and_safety/amenthium/, или наши внутренние документы по оценке риска (номера документов #47582-b (таблицы данных по безопасности плазмы) и #64210- #64225 (Регламент СИЗ для работы с плазмой), доступный через Нанодок для всех сотрудников).")]"
	msg += "\t[span_info("Нанотрейзен: Всегда заботиться о вашем здоровье.")]"
	return msg

/obj/structure/sign/poster/official/terragov
	name = "TerraGov: Единая для человечества"
	desc = "Плакат с логотипом и девизом TerraGov, напоминающий зрителям о том, кто заботится о человечестве."
	icon_state = "terragov"

/obj/structure/sign/poster/official/corporate_perks_vacation
	name = "Нанотрейзен Корпоративные привилегии: Отпуск"
	desc = "Этот информационный плакат содержит информацию о некоторых призах, доступных через программу НТ Корпоративные привилегии, включая двухнедельный отпуск для двоих на курорте Idyllus."
	icon_state = "corporate_perks_vacation"

//SafetyMoth Original PR at https://github.com/BeeStation/BeeStation-Hornet/pull/1747 (Also pull/1982)
//SafetyMoth art credit goes to AspEv
/obj/structure/sign/poster/official/moth_hardhat
	name = "Безопасная моль - Каски"
	desc = "Этот информационный плакат использует Безопасная моль™ для того, чтобы показать зрителю, что он должен носить каски в опасных местах. \"Это как лампа для вашей головы!\""
	icon_state = "aspev_hardhat"

/obj/structure/sign/poster/official/moth_piping
	name = "Безопасная моль - Трубопроводы"
	desc = "Этот информационный плакат использует Безопасная моль™ для того, чтобы объяснить атмосферным техникам правильные типы трубопроводов для использования. \"Трубы, а не насосы! Правильное расположение трубы предотвращает плохую производительность!\""
	icon_state = "aspev_piping"

/obj/structure/sign/poster/official/moth_meth
	name = "Безопасная моль - Метамфетамин"
	desc = "Этот информационный плакат использует Безопасная моль™ для того, чтобы попросить зрителя получить разрешение CMO перед приготовлением метамфетамина. \"Держитесь ближе к заданной температуре, и никогда не переходите!\" ... Вы никогда не должны делать это."
	icon_state = "aspev_meth"

/obj/structure/sign/poster/official/moth_epi
	name = "Безопасная моль - Адреналин"
	desc = "Этот информационный плакат использует Безопасная моль™ для информирования зрителя об оказании первой помощи раненым/погибшим членам экипажа инъекцией адреналинового медипена. \"Предотвратите гниение органов одним простым трюком!\""
	icon_state = "aspev_epi"

/obj/structure/sign/poster/official/moth_delam
	name = "Безопасная моль - Меры безопасности при дестабилизации материи"
	desc = "Этот информационный плакат использует Безопасная моль™ для того, чтобы показать зрителю, чтобы он прятался в шкафчиках, когда кристалл Суперматерии дестабилизируется, чтобы предотвратить галлюцинации. Эвакуация может быть лучшей стратегией."
	icon_state = "aspev_delam"

#undef PLACE_SPEED

/obj/structure/sign/poster/contraband/blasto_detergent
	name = "Blasto Brand Laundry Detergent"
	desc = "Sheriff Blasto's here to take back Laundry County from the evil Johnny Dirt and the Clothstain Crew, and he's brought a posse. It's High Noon for Tough Stains: Blasto brand detergent, available at all good stores."
	icon_state = "blasto_detergent"

/obj/structure/sign/poster/contraband/eistee
	name = "EisT: The New Revolution in Energy"
	desc = "New from EisT, try EisT Energy, available in a kaleidoscope range of flavors. EisT: Precision German Engineering for your Thirst."
	icon_state = "eistee"

/obj/structure/sign/poster/contraband/eistee/examine_more(mob/user)
	. = ..()
	. += span_notice("\n<i>You browse some of the poster's information...</i>")
	. += "\n\t[span_info("Get a taste of the tropics with Amethyst Sunrise, one of the many new flavours of EisT Energy now available from EisT.")]"
	. += "\n\t[span_info("With pink grapefruit, yuzu, and yerba mate, Amethyst Sunrise gives you a great start in the morning, or a welcome boost throughout the day.")]"
	. += "\n\t[span_info("Get EisT Energy today at your nearest retailer, or online at eist.de.tg/store/.")]"
	return .

/obj/structure/sign/poster/contraband/little_fruits
	name = "Little Fruits: Honey, I Shrunk the Fruitbowl"
	desc = "Little Fruits are the galaxy's leading vitamin-enriched gummy candy product, packed with everything you need to stay healthy in one great tasting package. Get yourself a bag today!"
	icon_state = "little_fruits"

/obj/structure/sign/poster/contraband/little_fruits/examine_more(mob/user)
	. = ..()
	. += span_notice("\n<i>You browse some of the poster's information...</i>")
	. += "\n\t[span_info("Oh no, there's been a terrible accident at the Little Fruits factory! We shrunk the fruits!")]"
	. += "\n\t[span_info("Wait, hang on, that's what we've always done! That's right, at Little Fruits our gummy candies are made to be as healthy as the real deal, but smaller and sweeter, too!")]"
	. += "\n\t[span_info("Get yourself a bag of our Classic Mix today, or perhaps you're interested in our other options? See our full range today on the extranet at little_fruits.kr.tg.")]"
	. += "\n\t[span_info("Little Fruits: Size Matters.")]"
	return .

/obj/structure/sign/poster/contraband/jumbo_bar
	name = "Jumbo Ice Cream Bars"
	desc = "Get a taste of the Big Life with Jumbo Ice Cream Bars, from Happy Heart."
	icon_state = "jumbo_bar"

/obj/structure/sign/poster/contraband/calada_jelly
	name = "Calada Anobar Jelly"
	desc = "A treat from Tizira to satisfy all tastes, made from the finest anobar wood and luxurious Taraviero honey. Calada: a full tree in every jar."
	icon_state = "calada_jelly"

/obj/structure/sign/poster/contraband/triumphal_arch
	name = "Zagoskeld Art Print #1: The Arch on the March"
	desc = "One of the Zagoskeld Art Print series. It depicts the Arch of Unity (also know as the Triumphal Arch) at the Plaza of Triumph, with the Avenue of the Victorious March in the background."
	icon_state = "triumphal_arch"

/obj/structure/sign/poster/contraband/mothic_rations
	name = "Mothic Ration Chart"
	desc = "A poster showing a commissary menu from the Mothic fleet flagship, the Va Lümla. It lists various consumable items alongside prices in ration tickets."
	icon_state = "mothic_rations"

/obj/structure/sign/poster/contraband/mothic_rations/examine_more(mob/user)
	. = ..()
	. += span_notice("\n<i>You browse some of the poster's information...</i>")
	. += "\n\t[span_info("Va Lümla Commissary Menu (Spring 335)")]"
	. += "\n\t[span_info("Windgrass Cigarettes, Half-Pack (6): 1 Ticket")]"
	. += "\n\t[span_info("Töchtaüse Schnapps, Bottle (4 Measures): 2 Tickets")]"
	. += "\n\t[span_info("Activin Gum, Pack (4): 1 Ticket")]"
	. += "\n\t[span_info("A18 Sustenance Bar, Breakfast, Bar (4): 1 Ticket")]"
	. += "\n\t[span_info("Pizza, Margherita, Standard Slice: 1 Ticket")]"
	. += "\n\t[span_info("Keratin Wax, Medicated, Tin (20 Measures): 2 Tickets")]"
	. += "\n\t[span_info("Setae Soap, Herb Scent, Bottle (20 Measures): 2 Tickets")]"
	. += "\n\t[span_info("Additional Bedding, Floral Print, Sheet: 5 Tickets")]"
	return .

/obj/structure/sign/poster/contraband/wildcat
	name = "Wildcat Customs Screambike"
	desc = "A pinup poster showing a Wildcat Customs Dante Screambike- the fastest production sublight open-frame vessel in the galaxy."
	icon_state = "wildcat"

/obj/structure/sign/poster/contraband/babel_device
	name = "Linguafacile Babel Device"
	desc = "A poster advertising Linguafacile's new Babel Device model. 'Calibrated for excellent performance on all Human languages, as well as most common variants of Draconic and Mothic!'"
	icon_state = "babel_device"

/obj/structure/sign/poster/contraband/pizza_imperator
	name = "Pizza Imperator"
	desc = "An advertisement for Pizza Imperator. Their crusts may be tough and their sauce may be thin, but they're everywhere, so you've gotta give in."
	icon_state = "pizza_imperator"

/obj/structure/sign/poster/contraband/thunderdrome
	name = "Thunderdrome Concert Advertisement"
	desc = "An advertisement for a concert at the Adasta City Thunderdrome, the largest nightclub in human space."
	icon_state = "thunderdrome"

/obj/structure/sign/poster/contraband/rush_propaganda
	name = "A New Life"
	desc = "An old poster from around the time of the First Spinward Rush. It depicts a view of wide, unspoiled lands, ready for Humanity's Manifest Destiny."
	icon_state = "rush_propaganda"

/obj/structure/sign/poster/contraband/rush_propaganda/examine_more(mob/user)
	. = ..()
	. += span_notice("\n<i>You browse some of the poster's information...</i>")
	. += "\n\t[span_info("TerraGov needs you!")]"
	. += "\n\t[span_info("A new life in the colonies awaits intrepid adventurers! All registered colonists are guaranteed transport, land and subsidies!")]"
	. += "\n\t[span_info("You could join the legacy of hardworking humans who settled such new frontiers as Mars, Adasta or Saint Mungo!")]"
	. += "\n\t[span_info("To apply, inquire at your nearest Colonial Affairs office for evaluation. Our locations can be found at www.terra.gov/colonial_affairs.")]"
	return .

/obj/structure/sign/poster/contraband/tipper_cream_soda
	name = "Tipper's Cream Soda"
	desc = "An old advertisement for an obscure cream soda brand, now bankrupt due to legal problems."
	icon_state = "tipper_cream_soda"

/obj/structure/sign/poster/contraband/tea_over_tizira
	name = "Movie Poster: Tea Over Tizira"
	desc = "A poster for a thought-provoking arthouse movie about the Human-Lizard war, criticised by human supremacist groups for its morally-grey portrayal of the war."
	icon_state = "tea_over_tizira"

/obj/structure/sign/poster/contraband/tea_over_tizira/examine_more(mob/user)
	. = ..()
	. += span_notice("\n<i>You browse some of the poster's information...</i>")
	. += "\n\t[span_info("At the climax of the Human-Lizard war, the human crew of a bomber rescue two enemy soldiers from the vacuum of space. Seeing the souls behind the propaganda, they begin to question their orders, and imprisonment turns to hospitality.")]"
	. += "\n\t[span_info("Is victory worth losing our humanity?")]"
	. += "\n\t[span_info("Starring Dara Reilly, Anton DuBois, Jennifer Clarke, Raz-Parla and Seri-Lewa. An Adriaan van Jenever production. A Carlos de Vivar film. Screenplay by Robert Dane. Music by Joel Karlsbad. Produced by Adriaan van Jenever. Directed by Carlos de Vivar.")]"
	. += "\n\t[span_info("Heartbreaking and thought-provoking- Tea Over Tizira asks questions that few have had the boldness to ask before: The London New Inquirer")]"
	. += "\n\t[span_info("Rated PG13. A Pangalactic Studios Picture.")]"
	return .

/obj/structure/sign/poster/official/jim_nortons
	name = "Jim Norton's Québécois Coffee"
	desc = "An advertisement for Jim Norton's, the Québécois coffee joint that's taken the galaxy by storm."
	icon_state = "jim_nortons"

/obj/structure/sign/poster/official/jim_nortons/examine_more(mob/user)
	. = ..()
	. += span_notice("\n<i>You browse some of the poster's information...</i>")
	. += "\n\t[span_info("From our roots in Trois-Rivières, we've worked to bring you the best coffee money can buy since 1965.")]"
	. += "\n\t[span_info("So stop by Jim's today- have a hot cup of coffee and a donut, and live like the Québécois do.")]"
	. += "\n\t[span_info("Jim Norton's Québécois Coffee: Toujours Le Bienvenu.")]"
	return .

/obj/structure/sign/poster/official/twenty_four_seven
	name = "24-Seven Supermarkets"
	desc = "An advertisement for 24-Seven supermarkets, advertising their new 24-Stops as part of their partnership with Nanotrasen."
	icon_state = "twenty_four_seven"

/obj/structure/sign/poster/official/tactical_game_cards
	name = "Nanotrasen Tactical Game Cards"
	desc = "An advertisement for Nanotrasen's TCG cards: BUY MORE CARDS."
	icon_state = "tactical_game_cards"

/obj/structure/sign/poster/official/midtown_slice
	name = "Midtown Slice Pizza"
	desc = "An advertisement for Midtown Slice Pizza, the official pizzeria partner of Nanotrasen. Midtown Slice: like a slice of home, no matter where you are."
	icon_state = "midtown_slice"
