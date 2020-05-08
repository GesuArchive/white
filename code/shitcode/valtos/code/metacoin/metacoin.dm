/client/proc/process_endround_metacoin()
	if(!mob)	return
	var/mob/M = mob
	if(M.mind && !isnewplayer(M))
		if(M.stat != DEAD && !isbrain(M))
			if(EMERGENCY_ESCAPED_OR_ENDGAMED)
				if(!M.onCentCom() && !M.onSyndieBase())
					inc_metabalance(M, METACOIN_SURVIVE_REWARD, reason="Выжил.")
				else
					inc_metabalance(M, METACOIN_ESCAPE_REWARD, reason="Выжил и сбежал!")
			else
				inc_metabalance(M, METACOIN_ESCAPE_REWARD, reason="Выжил.")
		else
			inc_metabalance(M, METACOIN_NOTSURVIVE_REWARD, reason="Я пытался...")

/client/proc/process_greentext()
	inc_metabalance(mob, METACOIN_GREENTEXT_REWARD, reason="Задача выполнена!")

/client/proc/process_ten_minute_living()
	inc_metabalance(mob, METACOIN_TENMINUTELIVING_REWARD, FALSE)

/client/proc/get_metabalance()
	var/datum/DBQuery/query_get_metacoins = SSdbcore.NewQuery("SELECT metacoins FROM [format_table_name("player")] WHERE ckey = '[ckey]'")
	var/mc_count = 0
	if(query_get_metacoins.warn_execute())
		if(query_get_metacoins.NextRow())
			mc_count = query_get_metacoins.item[1]

	if(mc_count == null)
		set_metacoin_count(0, FALSE)

	qdel(query_get_metacoins)
	return text2num(mc_count)

/client/proc/update_metabalance_cache()
	mc_cached = get_metabalance()

/client/proc/set_metacoin_count(mc_count, ann=TRUE)
	var/datum/DBQuery/query_set_metacoins = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET metacoins = '[mc_count]' WHERE ckey = '[ckey]'")
	query_set_metacoins.warn_execute()
	update_metabalance_cache()
	qdel(query_set_metacoins)
	if(ann)
		to_chat(src, "<span class='rose bold'>Мой новый баланс [mc_count] метакэша!</span>")

/proc/inc_metabalance(mob/M, mc_count, ann=TRUE, reason=null)
	if(mc_count > 0 && !M.client)
		return
	var/datum/DBQuery/query_inc_metacoins = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET metacoins = metacoins + '[mc_count]' WHERE ckey = '[M.ckey]'")
	query_inc_metacoins.warn_execute()
	M.client.update_metabalance_cache()
	qdel(query_inc_metacoins)
	if(ann)
		if(reason)
			to_chat(M, "<span class='rose bold'>[reason] [mc_count >= 0 ? "Получено" : "Потеряно"] [abs(mc_count)] метакэша!</span>")
		else
			to_chat(M, "<span class='rose bold'>[mc_count >= 0 ? "Получено" : "Потеряно"] [abs(mc_count)] метакэша!</span>")

// PROCS FOR HANDLING CHECKING WHAT ITEMS USER HAS

/client
	/// A cached list of "onlyone" metacoin items this client has bought.
	var/list/metacoin_items = list()
	var/mc_cached = 0

/client/proc/update_metacoin_items()
	metacoin_items = list()

	var/datum/DBQuery/query_get_metacoin_purchases
	query_get_metacoin_purchases = SSdbcore.NewQuery("SELECT item_id,item_class FROM [format_table_name("metacoin_item_purchases")] WHERE ckey = '[ckey]'")

	if(!query_get_metacoin_purchases.warn_execute())
		return

	while (query_get_metacoin_purchases.NextRow())
		var/id = query_get_metacoin_purchases.item[1]
		metacoin_items += id

	qdel(query_get_metacoin_purchases)
