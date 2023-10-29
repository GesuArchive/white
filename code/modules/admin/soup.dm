#define WHITELISTSOUPFILE "[global.config.directory]/whitelist_soup.txt"

/proc/load_whitelist_soup()
	GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal = list()
	for(var/line in world.file2list(WHITELISTSOUPFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal += ckey(line)

	if(!GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal.len)
		GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal = null

#undef WHITELISTSOUPFILE
