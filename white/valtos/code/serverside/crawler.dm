/client/proc/ask_crawler_for_support()
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, "http://nossl.crawler.station13.ru/api/?ckey=[ckey]", "", "")
	request.begin_async()
	UNTIL(request.is_complete() || !src)
	if (!src)
		return
	var/datum/http_response/response = request.into_response()

	if(response.errored || response.status_code != 200)
		return list("tauceti" = "N/A", "infinity" = "N/A", "onyx" = "N/A", "wycc" = "N/A", "bypass" = "N/A")

	return json_decode(response.body)

/client/proc/crawler_sanity_check()
	if(!ckey)
		return

	var/list/cril = ask_crawler_for_support()

	if(!cril)
		return TRUE

	if((text2num(cril["tauceti"]) > 180 || text2num(cril["infinity"]) > 180 || text2num(cril["onyx"]) > 180 || text2num(cril["wycc"]) > 180) && text2num(cril["bypass"]) == 0)
		message_admins("[key_name(src)] не наш игрок. TC: [cril["tauceti"]]m | IN: [cril["infinity"]]m | ON: [cril["onyx"]]m | SS: [cril["wycc"]]m")
		spawn(10)
			to_chat(src, "<span class='userdanger'>Тебе здесь не рады. Подробнее: <a href='https://crawler.station13.ru/?ckey=[ckey]'>https://crawler.station13.ru/?ckey=[ckey]</a></span>")
		return FALSE

	return TRUE
