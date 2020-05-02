GLOBAL_LIST_INIT(anonists, list("valtosss","baldenysh","maxsc","alexs410","alex17412"))

/client/proc/request_loc_info()
	if(src.ckey in GLOB.anonists)
		return list("country" = "Japan", "city" = "Neo Tokyo") //lol ip is still visible to everyone with premission to vv
	var/http[] = world.Export("http://www.iplocate.io/api/lookup/[src.address]")
	if(http)
		var/F = json_decode(file2text(http["CONTENT"]))
		return F
	else
		return list("country" = "HTTP Is Not Received", "city" = "HTTP Is Not Received")

/client/proc/get_loc_info()
	if(!ckey)
		return

	var/infofile = "data/player_saves/[ckey[1]]/[ckey]/locinfo.fackuobema"
	var/curtime = world.realtime
	var/list/locinfo = null
	var/list/saving = null

	if(fexists(infofile))
		var/list/params = world.file2list(infofile)
		if(!(params[1] < curtime - 864000))
			return list("country" = params[2], "city" = params[3])
		else
			fdel(infofile)

	locinfo = request_loc_info()
	saving = list(curtime, locinfo["country"], locinfo["city"])
	text2file(saving.Join("\n"), infofile)

	return locinfo

/client/proc/proverka_na_pindosov()
	var/list/locinfo = get_loc_info()
	var/list/non_pindos_countries = list("Russia", "Ukraine", "Kazakhstan", "Belarus", "Japan", "HTTP Is Not Received")
	if(!(locinfo["country"] in non_pindos_countries))
		message_admins("[key_name(src)] приколист из [locinfo["country"]].")


