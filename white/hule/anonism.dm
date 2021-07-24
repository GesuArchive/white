//GLOBAL_LIST_INIT(anonists, list("valtosss","baldenysh","maxsc","alexs410","alex17412"))
GLOBAL_LIST_INIT(anonists_deb, list())

/client/proc/request_loc_info()
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, "http://www.iplocate.io/api/lookup/[src.address]", "", "", null)
	request.begin_async()
	UNTIL(request.is_complete() || !src)
	if (!src)
		return
	var/datum/http_response/response = request.into_response()

	if(response.errored || response.status_code != 200)
		return list("country" = "HTTP Is Not Received", "city" = "HTTP Is Not Received")

	return json_decode(response.body)

/client/proc/get_loc_info()
	if(!ckey)
		return

	var/infofile = "data/player_saves/[ckey[1]]/[ckey]/locinfo.fackuobema"

	if(fexists(infofile))
		var/list/params = world.file2list(infofile)
		if(daysSince(text2num(params[1])) > 1)
			fdel(infofile)
		else
			if(!params[2])
				params[2] = "No Info"
			if(!params[3])
				params[3] = "No Info"
			return list("country" = params[2], "city" = params[3])

	var/list/locinfo = request_loc_info()
	if(!locinfo["country"])
		locinfo["country"] = "No Info"
	if(!locinfo["city"])
		locinfo["city"] = "No Info"
	var/list/saving = list(world.realtime, locinfo["country"], locinfo["city"])
	text2file(saving.Join("\n"), infofile)

	return locinfo

/client/proc/proverka_na_pindosov()
	var/list/locinfo = get_loc_info()
	var/list/non_pindos_countries = list("Russia", "Ukraine", "Kazakhstan", "Belarus", "Japenis", "HTTP Is Not Received", "No Info")
	if(!(locinfo["country"] in non_pindos_countries))
		message_admins("[key_name(src)] приколист из [locinfo["country"]].")
