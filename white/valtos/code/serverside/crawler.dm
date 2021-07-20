/client/proc/ask_crawler_for_support()
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, "http://nossl.crawler.station13.ru/api/?ckey=[ckey]", "", "", null)
	request.begin_async()
	UNTIL(request.is_complete() || !src)
	if (!src)
		return
	var/datum/http_response/response = request.into_response()

	if(response.errored || response.status_code != 200)
		return FALSE

	return json_decode(response.body)

/client/proc/crawler_sanity_check()
	if(!ckey)
		return

	var/list/cril = ask_crawler_for_support()
	var/list/badlist = list("SS220", "Tau Ceti", "SS13.RU", "Fluffy", "Infinity")

	if(!cril)
		return TRUE

	if(text2num(cril[1]["bypass"]))
		return TRUE

	popleft(cril)

	var/clear_sanity = TRUE

	for(var/i in cril)
		if(text_in_list(cril[i]["servername"], badlist))
			if(text2num(cril[i]["count"]) > 360)
				message_admins("[key_name(src)] из [cril[i]["servername"]](<a href='https://crawler.station13.ru/?ckey=[ckey]'>?</a>).")
				clear_sanity = FALSE

	return clear_sanity
