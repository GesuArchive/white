GLOBAL_LIST_INIT(anonists, list("valtosss","coolden","maxsc"))

/client/proc/get_loc_info()
	if(src.ckey in GLOB.anonists)
		return list("country" = "Japan", "city" = "Neo Tokyo") //lol ip is still visible to everyone with premission to vv
	var/http[] = world.Export("http://www.iplocate.io/api/lookup/[src.address]")
	if(http)
		var/F = json_decode(file2text(http["CONTENT"]))
		return F
	else
		return list("country" = "HTTP Is Not Received", "city" = "HTTP Is Not Received")



#define LOC_INFO_DIR "[global.config.directory]/autoeban/loc_info.fackuobema"

GLOBAL_LIST_INIT(loc_info, world.file2list(LOC_INFO_DIR))

/client/proc/proverka_na_pindosov()
	var/date = time2text(world.realtime, "YYYY-MM-DD")

	if(fexists(LOC_INFO_DIR))
		if(GLOB.loc_info[1] != date)
			fdel(LOC_INFO_DIR)
			text2file(date, LOC_INFO_DIR)
	else
		text2file(date, LOC_INFO_DIR)

	for(var/N in GLOB.loc_info)
		var/list/locparams = params2list(N)
		if(locparams[1] == ckey)
			return locparams

	var/list/locinfo = get_loc_info()
	var/params = list2params(list(ckey,locinfo[1],locinfo[2]))
	text2file(params, LOC_INFO_DIR)
	GLOB.loc_info += params
	return list(ckey,locinfo[1],locinfo[2])