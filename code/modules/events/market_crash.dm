/**
 * An event which decreases the station target temporarily, causing the inflation var to increase heavily.
 *
 * Done by decreasing the station_target by a high value per crew member, resulting in the station total being much higher than the target, and causing artificial inflation.
 */
/datum/round_event_control/market_crash
	name = "Событие: Увеличение цен"
	typepath = /datum/round_event/market_crash
	weight = 10

/datum/round_event/market_crash
	var/market_dip = 0

/datum/round_event/market_crash/setup()
	startWhen = 1
	endWhen = rand(25, 50)
	announceWhen = 2

/datum/round_event/market_crash/announce(fake)
	var/list/poss_reasons = list("наклон луны относительно звезды",\
		"некоторые рискованные домашние доходы",\
		"невероятное падение акций B.E.P.I.S.",\
		"спекулятивные манипуляции с акциями от правительства Земли",\
		"невероятно завышенные новости о том, что сотрудники Банковского агенства НаноТрейзен совершают массовые самоубийства")
	var/reason = pick(poss_reasons)
	priority_announce("Учитывая [reason], цены в станционных раздатчиках будут увеличены на неопределённый срок.", "Агенство Финансов НаноТрейзен")

/datum/round_event/market_crash/start()
	. = ..()
	market_dip = rand(1000,10000) * length(SSeconomy.bank_accounts_by_id)
	SSeconomy.station_target = max(SSeconomy.station_target - market_dip, 1)
	SSeconomy.price_update()
	SSeconomy.market_crashing = TRUE

/datum/round_event/market_crash/end()
	. = ..()
	SSeconomy.station_target += market_dip
	SSeconomy.market_crashing = FALSE
	SSeconomy.price_update()
	priority_announce("Цены в станционных раздатчиках стабилизировались.", "Агенство Финансов НаноТрейзен")

