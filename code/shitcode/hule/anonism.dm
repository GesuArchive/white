GLOBAL_LIST_INIT(anonists, list("valtosss","baldenysh","maxsc","alexs410","alex17412"))

/client/proc/get_loc_info()
	if(src.ckey in GLOB.anonists)
		return list("country" = "Japan", "city" = "Neo Tokyo") //lol ip is still visible to everyone with premission to vv
	var/http[] = world.Export("http://www.iplocate.io/api/lookup/[src.address]")
	if(http)
		var/F = json_decode(file2text(http["CONTENT"]))
		return F
	else
		return list("country" = "HTTP Is Not Received", "city" = "HTTP Is Not Received")



#define LOC_INFO_FILE "[global.config.directory]/autoeban/loc_info.fackuobema"

GLOBAL_LIST_INIT(loc_info, world.file2list(LOC_INFO_FILE))

/client/proc/proverka_na_pindosov()
	var/date = time2text(world.realtime, "YYYY-MM-DD")

	if(fexists(LOC_INFO_FILE))
		if(GLOB.loc_info[1] != date)
			fdel(LOC_INFO_FILE)
			text2file(date, LOC_INFO_FILE)
	else
		text2file(date, LOC_INFO_FILE)

	for(var/N in GLOB.loc_info)
		var/list/locparams = params2list(N)
		if(locparams["ckey"] && locparams["ckey"] == ckey)
			return N

	var/list/locinfo = get_loc_info()
	var/params = list2params(list("ckey" = ckey, "country" = locinfo["country"], "city" = locinfo["city"]))
	text2file(params, LOC_INFO_FILE)
	GLOB.loc_info += params
	return params

#undef LOC_INFO_FILE
