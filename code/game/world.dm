#define RESTART_COUNTER_PATH "data/round_counter.txt"

GLOBAL_VAR(restart_counter)

/**
 * World creation
 *
 * Here is where a round itself is actually begun and setup.
 * * db connection setup
 * * config loaded from files
 * * loads admins
 * * Sets up the dynamic menu system
 * * and most importantly, calls initialize on the master subsystem, starting the game loop that causes the rest of the game to begin processing and setting up
 *
 *
 * Nothing happens until something moves. ~Albert Einstein
 *
 * For clarity, this proc gets triggered later in the initialization pipeline, it is not the first thing to happen, as it might seem.
 *
 * Initialization Pipeline:
 *		Global vars are new()'ed, (including config, glob, and the master controller will also new and preinit all subsystems when it gets new()ed)
 *		Compiled in maps are loaded (mainly centcom). all areas/turfs/objs/mobs(ATOMs) in these maps will be new()ed
 *		world/New() (You are here)
 *		Once world/New() returns, client's can connect.
 *		1 second sleep
 *		Master Controller initialization.
 *		Subsystem initialization.
 *			Non-compiled-in maps are maploaded, all atoms are new()ed
 *			All atoms in both compiled and uncompiled maps are initialized()
 */
/world/New()
	//Keep the auxtools stuff at the top
	AUXTOOLS_CHECK(AUXMOS)

	if(cs_setup_threads())
		log_world("CS active!")

	log_world("World loaded at [time_stamp()]!")

	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)

	GLOB.config_error_log = GLOB.world_manifest_log = GLOB.world_pda_log = GLOB.world_job_debug_log = GLOB.sql_error_log = GLOB.world_href_log = GLOB.world_runtime_log = GLOB.world_attack_log = GLOB.world_game_log = GLOB.world_econ_log = GLOB.world_shuttle_log = "data/logs/config_error.[GUID()].log" //temporary file used to record errors with loading config, moved to log directory once logging is set bl

	GLOB.revdata = new

	config.Load(params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])

	load_admins()

	//SetupLogs depends on the RoundID, so lets check
	//DB schema and set RoundID if we can
	SSdbcore.CheckSchemaVersion()
	SSdbcore.SetRoundID()
	SetupLogs()
	load_poll_data()

	populate_gear_list()

#ifndef USE_CUSTOM_ERROR_HANDLER
	world.log = file("[GLOB.log_directory]/dd.log")
#endif

	LoadVerbs(/datum/verbs/menu)

	load_whitelist()

	load_whitelist_exrp()

	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	if(fexists(RESTART_COUNTER_PATH))
		GLOB.restart_counter = text2num(trim(file2text(RESTART_COUNTER_PATH)))
		fdel(RESTART_COUNTER_PATH)

	if(NO_INIT_PARAMETER in params)
		return

	Master.Initialize(10, FALSE, TRUE)

	#ifdef UNIT_TESTS
	HandleTestRun()
	#endif

	#ifdef AUTOWIKI
	setup_autowiki()
	#endif

/world/proc/HandleTestRun()
	//trigger things to run the whole process
	Master.sleep_offline_after_initializations = FALSE
	SSticker.start_immediately = TRUE
	CONFIG_SET(number/round_end_countdown, 0)
	var/datum/callback/cb
#ifdef UNIT_TESTS
	cb = CALLBACK(GLOBAL_PROC, /proc/RunUnitTests)
#else
	cb = VARSET_CALLBACK(SSticker, force_ending, TRUE)
#endif
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/_addtimer, cb, 10 SECONDS))


/world/proc/SetupLogs()
	var/override_dir = params[OVERRIDE_LOG_DIRECTORY_PARAMETER]
	if(!override_dir)
		var/realtime = world.realtime
		var/texttime = time2text(realtime, "YYYY/MM/DD")
		GLOB.log_directory = "data/logs/[texttime]/round-"
		GLOB.picture_logging_prefix = "L_[time2text(realtime, "YYYYMMDD")]_"
		GLOB.picture_log_directory = "data/picture_logs/[texttime]/round-"
		if(GLOB.round_id)
			GLOB.log_directory += "[GLOB.round_id]"
			GLOB.picture_logging_prefix += "R_[GLOB.round_id]_"
			GLOB.picture_log_directory += "[GLOB.round_id]"
		else
			var/timestamp = replacetext(time_stamp(), ":", ".")
			GLOB.log_directory += "[timestamp]"
			GLOB.picture_log_directory += "[timestamp]"
			GLOB.picture_logging_prefix += "T_[timestamp]_"
	else
		GLOB.log_directory = "data/logs/[override_dir]"
		GLOB.picture_logging_prefix = "O_[override_dir]_"
		GLOB.picture_log_directory = "data/picture_logs/[override_dir]"

	GLOB.dynamic_log = "[GLOB.log_directory]/dynamic.log"
	GLOB.world_game_log = "[GLOB.log_directory]/game.log"
	GLOB.world_mecha_log = "[GLOB.log_directory]/mecha.log"
	GLOB.world_mob_tag_log = "[GLOB.log_directory]/mob_tags.log"
	GLOB.world_virus_log = "[GLOB.log_directory]/virus.log"
	GLOB.world_cloning_log = "[GLOB.log_directory]/cloning.log"
	GLOB.world_asset_log = "[GLOB.log_directory]/asset.log"
	GLOB.world_attack_log = "[GLOB.log_directory]/attack.log"
	GLOB.world_econ_log = "[GLOB.log_directory]/econ.log"
	GLOB.world_pda_log = "[GLOB.log_directory]/pda.log"
	GLOB.world_telecomms_log = "[GLOB.log_directory]/telecomms.log"
	GLOB.world_speech_indicators_log = "[GLOB.log_directory]/speech_indicators.log"
	GLOB.world_manifest_log = "[GLOB.log_directory]/manifest.log"
	GLOB.world_href_log = "[GLOB.log_directory]/hrefs.log"
	GLOB.sql_error_log = "[GLOB.log_directory]/sql.log"
	GLOB.world_qdel_log = "[GLOB.log_directory]/qdel.log"
	GLOB.world_map_error_log = "[GLOB.log_directory]/map_errors.log"
	GLOB.world_runtime_log = "[GLOB.log_directory]/runtime.log"
	GLOB.query_debug_log = "[GLOB.log_directory]/query_debug.log"
	GLOB.world_job_debug_log = "[GLOB.log_directory]/job_debug.log"
	GLOB.world_paper_log = "[GLOB.log_directory]/paper.log"
	GLOB.tgui_log = "[GLOB.log_directory]/tgui.log"

	GLOB.demo_log = "[GLOB.log_directory]/demo.txt"

	GLOB.world_shuttle_log = "[GLOB.log_directory]/shuttle.log"
	GLOB.world_silicon_log = "[GLOB.log_directory]/silicon.log"
	GLOB.world_mechcomp_log = "[GLOB.log_directory]/mechcomp.log"
	GLOB.world_exrp_log = "[GLOB.log_directory]/exrp.log"
	GLOB.world_uplink_log = "[GLOB.log_directory]/uplink.log"
	GLOB.world_tool_log = "[GLOB.log_directory]/tools.log"
	GLOB.demo_log = "[GLOB.log_directory]/demo.log"
	GLOB.world_suspicious_login_log = "[GLOB.log_directory]/suspicious_logins.log"

	GLOB.lua_log = "[GLOB.log_directory]/lua.log"

#ifdef UNIT_TESTS
	GLOB.test_log = "[GLOB.log_directory]/tests.log"
	start_log(GLOB.test_log)
#endif
	start_log(GLOB.world_game_log)
	start_log(GLOB.world_attack_log)
	start_log(GLOB.world_econ_log)
	start_log(GLOB.world_pda_log)
	start_log(GLOB.world_telecomms_log)
	start_log(GLOB.world_manifest_log)
	start_log(GLOB.world_href_log)
	start_log(GLOB.world_qdel_log)
	start_log(GLOB.world_runtime_log)
	start_log(GLOB.world_job_debug_log)
	start_log(GLOB.world_uplink_log)
	start_log(GLOB.tgui_log)
	start_log(GLOB.world_shuttle_log)
	start_log(GLOB.world_mechcomp_log)
	start_log(GLOB.world_exrp_log)

	GLOB.changelog_hash = md5(file2text("data/changelog.json")) //for telling if the changelog has changed recently
	if(fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	if(GLOB.round_id)
		log_game("Round ID: [GLOB.round_id]")

/world/Topic(T, addr, master, key)
	var/static/list/topic_handlers = TopicHandlers()

	var/list/input = params2list(T)
	var/datum/world_topic/handler
	for(var/I in topic_handlers)
		if(I in input)
			handler = topic_handlers[I]
			break

	if((!handler || initial(handler.log)) && config && CONFIG_GET(flag/log_world_topic))
		log_topic("\"[T]\", from:[addr], master:[master], key:[key]")

	if(!handler)
		return

	handler = new handler()
	return handler.TryRun(input)

/world/proc/AnnouncePR(announcement, list/payload)
	var/static/list/PRcounts = list()	//PR id -> number of times announced this round
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > PR_ANNOUNCEMENTS_PER_ROUND)
			return

	var/final_composed = span_announce("PR: [announcement]")
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

/world/proc/FinishTestRun()
	set waitfor = FALSE
	var/list/fail_reasons
	if(GLOB)
		if(GLOB.total_runtimes != 0)
			fail_reasons = list("Total runtimes: [GLOB.total_runtimes]")
#ifdef UNIT_TESTS
		if(GLOB.failed_any_test)
			LAZYADD(fail_reasons, "Unit Tests failed!")
#endif
		if(!GLOB.log_directory)
			LAZYADD(fail_reasons, "Missing GLOB.log_directory!")
	else
		fail_reasons = list("Missing GLOB!")
	if(!fail_reasons)
		text2file("Success!", "[GLOB.log_directory]/clean_run.lk")
	else
		log_world("Test run failed!\n[fail_reasons.Join("\n")]")
	sleep(0)	//yes, 0, this'll let Reboot finish and prevent byond memes
	qdel(src)	//shut it down

/world/Reboot(reason = 0, fast_track = FALSE)
	var/rid = GLOB.round_id
	if (reason || fast_track) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		to_chat(world, span_boldannounce("Немедленная перезагрузка по требованию сервера."))
	else
		to_chat(world, span_boldannounce("Конец!"))
		Master.Shutdown()	//run SS shutdowns

	#ifdef UNIT_TESTS
	FinishTestRun()
	return
	#endif

	log_world("World rebooted at [time_stamp()]")

	shutdown_logging() // Past this point, no logging procs can be used, at risk of data loss.
	if(CONFIG_GET(flag/this_shit_is_stable))
		shelleo("curl -X POST http://localhost:3636/hard-reboot-white/[rid]")
	AUXTOOLS_SHUTDOWN(AUXMOS)
	AUXTOOLS_FULL_SHUTDOWN(AUXLUA)
	..()

/world/Del()
	shutdown_logging() // makes sure the thread is closed before end, else we terminate
	AUXTOOLS_SHUTDOWN(AUXMOS)
	AUXTOOLS_FULL_SHUTDOWN(AUXLUA)
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_shutdown")()
	..()

/*
:::y+-+oooossoosssysoshyssyo/+``````````+y..++hhhhhdoyhyoosydddodh+/+//.:o//+ddh++oooossyhmdhmmdhsydmmmddmmmNmymmmmmmmmm
::yo-+osoosoooosyysoysyoos+:o.``````````+o``++yyhhhmyhdhhddddddydy+s+/:.-///+ddh+++++++++ohdhmhsooosdmmyymmmNmshmmmmmmmm
:ys./osossoooosyysos:oooss-+:```````````s/``++yyhhhmhyhhhhdddhdhdhyho+/-:s//ohdy++++++++++ohymsooooosddsymmmNmsymdmmmmmm
yh.:osoosoooooyysoo:.yosy--o````````````s:``/+ysyhhdhyhhhhddhddhdhhdh+/-:s/+shdh+++++++++++sydsoooossyyssmmmNmssdhyhdmmm
d/-+soosooooohysoo-`+sss+`/:````````````o:``:+ysyyyddshhhyhhhhhhdhhhhy/-/y+oyddh+++++++++++oydsoooosssyssmdmNdssyyyyyhhh
o`/ssossooooyysos-``yoso.`o.````````````+:``.+yyssyhmsyhhyhhhhhhdhhhdhs:/dyhhddho+++++++osssydyoooossyysyddmNhssyyyyyyyh
.-osooy++o+shsoo-``.yso+:-s:---..```````:/```+hsysssdyoyysyhhhhhdhhhhhh//hdhhddddhsooosydmhshmhoosssymysymdmNyssyyyyyyyh
`/sooyo++oohyoo-```.s+o:--+/-:://++/-.``.s```:hsysssyyossysyyyyyhhhhhhho+sdhhdddddddhhddmmdhdmdossssdmyshmdmNssshyyyyyhh
-osooyo+ooyhso:`````::-```.-``````.-/+/.`s-``.hyysoossyosyssssyyhyhhhhho+odyydddddddddddmmhmmmdssssdmmhsdmdmdsshdyyyyyyh
/soossoooshyo+```````-````````````````-+.:+```/hsyooososossosssyyyyyyyhs+oyhyhddddddddddddhmdmmysshmmmdymmdNhshmhhdmdhhd
+sooyoooohhys.```````````````````````````.+-``.+sys+os/sooyoosssyhyyyyhy+++hyhddmdddddddddhmdmmdyhmmmmddmmdNyymmmmNNNNNN
ssoohoooyhdh+``````````.....-::-.`````````./.``-sos++os:sosyooooshsssyyys//sysyhddhhddddddhmdmmmdmmmdmmmmdmmymNmmNNNNNNN
ssooho+ohhdhhhso++//-.`````````...`````````./.``:s++++s/-ssssoooohsssssyos//yssyhmhhhhhhhdhddmdddmmmdmdmddmmmmmmmNNNNNNN
soooy++shdNMMMMMMMMMMNmho:.`````````````````...``:oo+++s--ssssooosyssssyoy+/+hssydhyyyhhhhhhmmdddddmddddddNmmmNNNNNNNNNN
ooooh++ydy/oNs----:/oNMMMMMdo-````````````````.``.:oo/++o--+ssossoysssssy/y//sysyhmyyyhhhhhhmmhhddddhddddmmmmmmmNNNNNNNN
ooooho+hho:`.s.     :NNmNNMMMMdo-`````````````````.-+s/++o-./sso+osyssssy++s//sysymhyyyyyyhyNdhhhhhdhddddNmmmmmmmNNNNNNN
ooosho+hs/-```.`   `-yhhhhdmNNMMd+-`````````````````.:o::+s/.-oso/osyossososs++yyshmhyyyyyyyNdhhhhhdhdddmNdmmmmmmNNNNNNm
oooshs+h+:-````````shhhhyhhmdhdNMN+-`````````````````..::.-/+-.:oo/+sssssoo:+ysshyyddyyyyyyymmhhhhhdhdddNddmmmmmmmNNNNNd
oooshhoy/.-`````````.-:+oydNdhyhdNNs`````````````````````.``.--.-:/+/+ssooo+:+s+osyydhyyyyyydmhyhhhhhhdmmdddmmmmmmmmmmNy
oooshdys/````````````````.-/+syhhmNd/``````````````````````````....---:/ossoo//o//syydhyyyyyhNdyhhhhhhmNdddddmmmmmmmmmds
sooshdhs+.``.````...``````````.-+y:..``````````````````````````````.---::+osso++s++syddhyyyyymmyyhdyhdNdhhddddmmmmmmmmyo
dooohmsoo-.....---........`````````````````````````````````````````````````.-+oo+oo+ohddhyyyymmhyhdhdNdyhhdddddmmmmmmdso
dyoohNo/o/.........---....`````````````````````````````````..----....`````````.::-:+oohmdhyyyhNdyhhhmmyhhhdddddmmmmmmsos
ydsohm:.-::........```....--.``````````````````````````.:+sdmmmmmmmmdhyo/-.``````..`-ooshddysymmhdhmNyyhhhddddddmmmmhooh
sydosm.`....```.....--....`````.``````````````````````.-///:::::::/oNMMMMMmds/-```````-+oyddyshmdddNhshhhhhdddddmmmdsosm
syyhsy/``````.---...```....----..````   `````````````````````     ``smdmmNNMMMNds:.`````.odhdhydmmmdsyhhhhhdddddmmmyoodm
yssyhsy.```````````````.....````.--`    ````````````````````````..yhhhhhhhdmmNMMMMNy/````./hhhhhNmmsyyyhhhhdddddmmdooymm
sssyhoyo.```````````````````````.``````````````````````````````````.:+shhhmNdhhmNMMMMms-```.yhhmmmssyyyhhhhhhdddddsoodmm
sssho./os/.````````````````````````````````````````````````````````````-:odmhyyhdmNMMMMMdo-``+dmmssyyyyhhhhhhddddyoohmmN
sssm:`.-:/+/:-.````````````````````````````````````````````````````````````-/syhhdNm/sNMMMmo:`dNyssyyyyyhhhhhdddhoosmmNm
sssm.`````````````````````````````````````````````````````````````````````````.:smh. `:mMMMy::mysssyyyyyhhhhddddo+odmmmd
sssm```````````````````````````````````````ХУЙ``````````...-------.````````.`````.```.:osssymdhssssyyyyyykahdddsoohmmNmh
sssm` `````````````````````````````````````````````````````````........----.```````````````/syssssyyyyyyhhhhdds+osdmNmdm
sssm. ``````````````:.`````````````````````````````````````----................-.`````````+sssssssyyyyyhhhhddy++odmNmdyy
sssd/ ``````````````.:-```````````````````````````````````````.......----.......```..````+ssssssssyyyyhhhhhdho+ohdmNmhoo
sssyy`````````````````....``````````````````````````````````..-.......`........---...``-ssssssssssyyyyhhhhhho++ydmNmdydd
syysyo````````````````````...``````````````````````````````````````````.......````````:o+ossssssyyyyyhhhhhho++yddmdmhsyd
yyyysh+ ``````````````````````````.`````````````````````````````````````````.....----+++oosssssyyyyyhhhhhho++sddmdddo+hy
yyysssh/ ``````````````````````````.....````````````````````````````````````....``.+++oooosssyysyyhhhhhhho++oddmdhdy+ohs
yssssssh+` ``````````````````````````````.........```````.-`````````````````````-os++oooosssyssyhdhyyhhhs//ohdmmhdyo/oyo
ysssssssho``````````````````````````````````````.....----.````````````````````:sy+/ooooossyssshdhyyyhhho//+hdmmdhyy++o+y
yysssssysys````````````````````````````````````````````````````````````````-+yyo+ooooosyyssyhddyyyyyhho//+hhmmdyy+soosdN
yysssyysssyy. `````````````````````````````````````````````````````````.:oyhso+oooosyhyyyhddhyssyyyhho//+hhmmdyhoyoydNNm
yyyhhysssssyh-``````````````````````````````````````````````:..--::/+shhyysooooosyhdhhhhdhyysssyyyyyo//+yhmddhyyoyNNNNmy
hyso+oyhyssssh:`````````````````````````````````````````````.:+osyyyyyssssssyhhhyshdhhhyyssysyyyyyyo//+hhmyhhyhdhmNNNNdo
++++ooosyhysssy+````````````````````````````````````````````````.-://+++++/////:/yhhyyysssssyyyyyy+//+yhmdydydNNhNNNNmh+
+ossssssssyhyosyy.``````````````````````````````````````````````````........-::ohyyyyhsssssyyyyyy+//oyhNNNNhyNNmdNNNNdy+
sssoo++++++oyhsoyh-``````````````````````````````````````````````````````.-:/+yhyyyhhyssssyyyyys+//oyhNNmNhymNNhmNNNNdoo
ooo++++++++ooymyosh/`````````````````````````````````````````````````..-:/oyddysyyhhyssssyyyyys///syhNNmNmsmNNmhNNNNmh+s
//++ooosssssyyhmhyyh+```````````````````````````````````````````...-:/+shhhdhssyyhhsssssyyyyyo///syhNNmmNshNNmdmNNNNmyoy
``````.`..-:+++oooooss-`````````````````````````````  ``````.-::/+shhhyyyhdysssydhssssyyyyyy+//+syhNNmmNyyNNNmhNmNNNdysy
``````````.:/++++++++ohs+:--.....````````````......--:://++oosssyddysssydhssssydhssosyyyyyy+//oyydNNmmNhsNNNmddmNNNNdyyh
````````-/ooyhhyssssssmsooooooooooooooooo++++++++++++//////////oddsssyhhysssshdhssssyyyyys///oysdNNmmNmomNNmmhNmNNNNhyyh
``````-+syyyhhyyssoosys/:::::::::::::::::::::::::::::::::::::/sdyssshdyssssyddhsssysyyyyo/:+syymmNmmmmsdNNNddhNmNmNNdysh
````:+os+//////+++++oo:/:::::::::::::::::::::::::::::::::::::ydssshdyssysydddyosssyyyyy+//+ysymmNmmmmsdNNNmdymmmNmNNdysh
``:ooo+////////////+s.:/::::::::::::::::::::::::::::::::::::hhsshdyssyyyhdhyssssssyyys///sysdmmNmmmmshmNNNdhhmdNNdNNdsoh
*/

GLOBAL_VAR_INIT(status_for_mentally_ill_amoeba_users, TRUE)
GLOBAL_VAR_INIT(custom_status_text, "- Пoлный пepeвoд нa Kитaйcкий\n - Уникaльныe лaги\n - Без шyccoидoв\n \[<b>Bcё, выpyбaй, y мeня xyй вcтaл</b>")

/world/proc/update_status()

	var/s = ""

	if(GLOB.status_for_mentally_ill_amoeba_users)
		s = "SS13.SU\] <b>[prob(1) ? "Чёpнaя Peaльнocть" : "Бeлaя Мeчтa"]:</b> <a href=\"https://discord.gg/2WAsvv5B5v\">DISCORD</a>\n" // length 87

		s += GLOB.custom_status_text // 168 max

		status = s
		return

	s = "SS13.SU\] <big><b>FDev: White Dream: RU</b></big> <a href=\"http://station13.ru\">SITE</a> | <a href=\"https://discord.gg/2WAsvv5B5v\">DISCORD</a>\n"

	switch(rand(1, 6))
		if(1)
			s += "<img src='https://assets.station13.ru/l/w7.png'>\n"
			s += "\[<big>CLASSIC STATION</big>"
		if(2)
			s += "<img src='https://assets.station13.ru/l/w6.png'>\n"
			s += "\[<big>ANIME HENTAI</big>"
		if(3)
			s += "<img src='https://assets.station13.ru/l/w5.png'>\n"
			s += "\[<big>GRIMDARK EDITION</big>"
		if(4)
			s += "<img src='https://assets.station13.ru/l/w4.png'>\n"
			s += "\[<big>CYBERPUNK EDITION</big>"
		if(5)
			s += "<img src='https://assets.station13.ru/l/w8.png'>\n"
			s += "\[<big>REMOVE KEBAB</big>"
		if(6)
			s += "<img src='https://assets.station13.ru/l/w9.png'>\n"
			s += "\[<big>PROBABLY NOT HARAM</big>"

	status = s

/world/proc/update_hub_visibility(new_visibility)
	if(new_visibility == GLOB.hub_visibility)
		return
	GLOB.hub_visibility = new_visibility
	if(GLOB.hub_visibility)
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"

/world/proc/incrementMaxZ()
	maxz++
	SSmobs.MaxZChanged()
	SSidlenpcpool.MaxZChanged()
	world.refresh_atmos_grid()


/world/proc/change_fps(new_value = 20)
	if(new_value <= 0)
		CRASH("change_fps() called with [new_value] new_value.")
	if(fps == new_value)
		return //No change required.

	fps = new_value
	on_tickrate_change()


/world/proc/change_tick_lag(new_value = 0.5)
	if(new_value <= 0)
		CRASH("change_tick_lag() called with [new_value] new_value.")
	if(tick_lag == new_value)
		return //No change required.

	tick_lag = new_value
	on_tickrate_change()


/world/proc/on_tickrate_change()
	SStimer?.reset_buckets()

/world/proc/refresh_atmos_grid()

// "PxPlus IBM VGA9"
// "Retroville NC"
var/list/extra_resources = list(\
	'html/ibmvga9.ttf', \
	'html/rvnc.ttf',
)

