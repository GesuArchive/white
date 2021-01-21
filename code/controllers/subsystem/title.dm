SUBSYSTEM_DEF(title)
	name = "Title Screen"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	var/file_path
	var/ctt = ""
	var/enabled_shit = TRUE
	var/game_loaded = FALSE
	var/current_lobby_screen = 'icons/ts.png'

/datum/controller/subsystem/title/Initialize()

	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/title_screens = list()
	var/use_rare_screens = prob(1)

	SSmapping.HACK_LoadMapConfig()

	for(var/S in provisional_title_screens)
		var/list/L = splittext(S,"+")
		if((L.len == 1 && (L[1] != "exclude" && L[1] != "blank.png"))|| (L.len > 1 && ((use_rare_screens && lowertext(L[1]) == "rare") || (lowertext(L[1]) == lowertext(SSmapping.config.map_name)))))
			title_screens += S

	if(length(title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(title_screens)]"

	if(!file_path)
		file_path = "icons/ts.png"

	ASSERT(fexists(file_path))

	current_lobby_screen = fcopy_rsc(file_path)

	update_lobby_screen()

	if(enabled_shit)
		set_load_state("init1")

	return ..()

/datum/controller/subsystem/title/proc/set_load_state(state)
	if(enabled_shit)
		switch(state)
			if("init1")
				sm("-------------------------------------------------------------------------------------------------")
				sm("")
				sm(" M\"\"MMM\"\"MMM\"\"M dP       oo   dP               M\"\"\"\"\"\"'YMM                                       ")
				sm(" M  MMM  MMM  M 88            88               M  mmmm. `M                                       ")
				sm(" M  MMP  MMP  M 88d888b. dP d8888P .d8888b.    M  MMMMM  M 88d888b. .d8888b. .d8888b. 88d8b.d8b. ")
				sm(" M  MM'  MM' .M 88'  `88 88   88   88ooood8    M  MMMMM  M 88'  `88 88ooood8 88'  `88 88'`88'`88 ")
				sm(" M  `' . '' .MM 88    88 88   88   88.  ...    M  MMMM' .M 88       88.  ... 88.  .88 88  88  88 ")
				sm(" M    .d  .dMMM dP    dP dP   dP   `88888P'    M       .MM dP       `88888P' `88888P8 dP  dP  dP ")
				sm(" MMMMMMMMMMMMMM                                MMMMMMMMMMM                                       ")
				sm("")
				sm("-------------------------------------------------------------------------------------------------")
				sm("")
				us()
			if("init2")
				sm("PMAP: PCID enabled")
				sm("ProtocolC Kernel Version 1.0.0: Tue Oct 11 20:56:35 PDT 2011 - root:xnu-1699.22.73~1/RELEASE_X86_64")
				sm("vm_page_bootstrap: 987323 free pages and 53061 wired pages")
				sm("kext submap \[0xffffff7f8072e000 - 0xffffff8000000000\], kernel text \[0xffffff8000200000 - 0xffffff800072e000\]")
				sm("zone leak detection enabled")
				sm("standard timeslicing quantum is 10000 us")
				sm("mig_table_max_displ = 72")
				sm("TSC Deadline Timer supported and enabled")
				sm("ProtocolCACPICPU: ProcessorId=1 LocalApicId=0 Enabled")
				sm("ProtocolCACPICPU: ProcessorId=2 LocalApicId=2 Enabled")
				sm("ProtocolCACPICPU: ProcessorId=3 LocalApicId=1 Enabled")
				sm("ProtocolCACPICPU: ProcessorId=4 LocalApicId=3 Enabled")
				sm("ProtocolCACPICPU: ProcessorId=5 LocalApicId=255 Disabled")
				sm("ProtocolCACPICPU: ProcessorId=6 LocalApicId=255 Disabled")
				sm("ProtocolCACPICPU: ProcessorId=7 LocalApicId=255 Disabled")
				sm("ProtocolCACPICPU: ProcessorId=8 LocalApicId=255 Disabled")
				sm("calling mpo_policy_init for TMSafetyNet")
				sm("Security policy loaded: Safety net for Rollback (TMSafetyNet)")
				sm("calling mpo_policy_init for Sandbox")
				sm("Security policy loaded: Seatbelt sandbox policy (Sandbox)")
				sm("calling mpo_policy_init for Quarantine")
				sm("Security policy loaded: Quarantine policy (Quarantine)")
				sm("Copyright (c) 1655, 1786, 1839, 1938, 1944, 1990, 2021")
				sm("The White Dream from Frosty Dev. All rights reserved.")
				sm("")
				us()
			if("atoms1")
				ctt = ""
				sm("PC_framework successfully initialized")
				sm("using 16384 buffer headers and 10240 cluster IO buffer headers")
				sm("IOAPIC: Version 0x20 Vectors 64:87")
				sm("ACPI: System State \[S0 S3 S4 S5\] (S3)")
				sm("PFM64 0xf10000000, 0xf0000000")
				sm("\[ PCI configuration begin \]")
				sm("ProtocolCIntelCPUPowerManagement: Turbo Ratios 0046")
				sm("ProtocolCIntelCPUPowerManagement: (built 13:08:12 Jan 18 2561) initialization complete")
				sm("console relocated to 0xf10000000")
				sm("PCI configuration changed (bridge=16 device=4 cardbus=0)")
				sm("\[ PCI configuration end, bridges 12 devices 16 \]")
				sm("mbinit: done \[64 MB total pool size, (42/21) split\]")
				sm("Pthread support ABORTS when sync kernel primitives misused")
				sm("com.ProtocolC.ProtocolCFSCompressionTypeZlib kmod start")
				sm("com.ProtocolC.ProtocolCTupoiHoholOpyatNakodilGovna kmod start")
				sm("com.ProtocolC.ProtocolCFSCompressionTypeZlib load succeeded")
				sm("com.ProtocolC.ProtocolCFSCompressionTypeDataless load succeeded")
				sm("")
				us()
			if("atoms2")
				sm("ProtocolCIntelCPUPowerManagementClient: ready")
				sm("BTCOEXIST off ")
				sm("wl0: Broadcom BCM4331 802.11 Wireless Controller")
				sm("5.100.98.75")
				sm("")
				us()
			if("diseases")
				sm("FireWire (OHCI) Lucent ID 5901 built-in now active, GUID c82a14fffee4a086 - max speed s800.")
				sm("rooting via boot-uuid from /chosen: F5670083-AC74-33D3-8361-AC1977EE4AA2")
				sm("Waiting on <b>Quantum Drive</b> -> IO <b>c24c-ee01-4f2f-fcea</b> -> <b>c919d65bd95698af8f15fa8133bf490d</b>")
				us()
			if("air")
				sm("Got boot device = IOService:/ProtocolCACPIPlatformExpert/PCI0@0/ProtocolCACPIPCI/SATA@1F,2/")
				sm("ProtocolCIntelPchSeriesAHCI/PRT0@0/IOAHCIDevice@0/ProtocolCAHCIDiskDriver/Van@tYanHujCocalIOAHCIBlockStorageDevice/IOBlockStorageDriver/")
				sm("ProtocolC SSD TS128C Media/IOGUIDPartitionScheme/Customer@2")
				sm("BSD root: disk0s2, major 14, minor 2")
				sm("Kernel is LP64")
				us()
			if("assets")
				ctt = ""
				sm("IOThunderboltSwitch::i2cWriteDWord - status = 0xe00002ed")
				sm("IOThunderboltSwitch::i2cWriteDWord - status = 0x00000000")
				sm("IOThunderboltSwitch::i2cWriteDWord - status = 0xe00002ed")
				sm("IOThunderboltSwitch::i2cWriteDWord - status = 0xe00002ed")
				us()
			if("smoothing")
				sm("ProtocolCUSBMultitouchDriver::checkStatus - received Status Packet, Payload 2: device was reinitialized")
				sm("PchoIsBee::checkstatus - true, Pcho::Bee")
				sm("\[IOBluetoothHCIController::setConfigState\] calling registerService")
				sm("AirPort_Brcm4331: Ethernet address e4:ce:8f:46:18:d2")
				us()
			if("overlays")
				sm("IO80211Controller::dataLinkLayerAttachComplete():  adding ProtocolCEFINVRAM notification")
				sm("IO80211Interface::efiNVRAMPublished():")
				sm("Created virtif 0xffffff800c32ee00 p2p0")
				sm("BCM5701Enet: Ethernet address c8:2a:14:57:a4:7a")
				sm("Previous Shutdown Cause: 3")
				sm("NTFS driver 3.8 \[Flags: R/W\].")
				sm("NTFS volume name BUDKAPSA, version 3.1.")
				us()
			if("light")
				sm("DSMOS has arrived")
				sm("en1: 802.11d country code set to 'RU'.")
				sm("en1: Supported channels 1 2 3 4 5 6 7 8 9 10 11 36 40 44 48 52 56 60 64 100 104 108 112 116 120 124 128 132 136 140 149 153 157 161 165")
				sm("m_opyxsoset")
				sm("MacAuthEvent ru1   Auth result for: 00:60:64:1e:e9:e4  MAC AUTH succeeded")
				us()
			if("shuttle")
				sm("MacAuthEvent en1   Auth result for: 00:60:64:1e:e9:e4 Unsolicited  Auth")
				sm("wlEvent: en1 en1 Link UP")
				sm("AirPort: Link Up on en1")
				sm("en1: BSSID changed to 00:60:64:1e:e9:e4")
				sm("virtual bool IOHIDEventSystemUserClient::initWithTask(task*, void*, UInt32): ")
				sm("Client task not privileged to open IOHIDSystem for mapping memory (e00002c1)")
				us()
			if("end")
				sm("</br></br></br></br>")
				us()
				var/nn = 0
				while(nn != 5)
					sleep(10)
					sm("")
					us()
					nn++
				sm("Boot Complete")
				us()
				sleep(10)
				cls()

/datum/controller/subsystem/title/proc/sm(msg, newline = TRUE)
	if(enabled_shit)
		if(newline)
			ctt += "[msg]</br>"
		else
			ctt += "[msg]"

/datum/controller/subsystem/title/proc/us()
	if(enabled_shit)
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.send_to_lobby_console_now(ctt)

/datum/controller/subsystem/title/proc/cls()
	if(enabled_shit)
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.clear_lobby()
				D.client.playtitlemusic()
		ctt = ""
		game_loaded = TRUE
		spawn(5)
			uplayers()

/datum/controller/subsystem/title/proc/update_lobby_screen()
	if(enabled_shit)
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.reload_lobby()

/datum/controller/subsystem/title/proc/uplayers()
	if(enabled_shit && game_loaded)
		var/list/caa = list()
		var/list/cum = list()
		ctt = ""
		var/tcc = ""
		for(var/i in GLOB.new_player_list)
			var/mob/dead/new_player/player = i
			if(player.ready == PLAYER_READY_TO_PLAY)
				caa += "<b>[player.key]</b>"
			else
				cum += "[player.key]"
		for(var/line in GLOB.whitelist)
			cum += "[line]"
		if(SSticker.current_state == GAME_STATE_PREGAME)
			tcc += "<big>Готовы:</big></br>"
			for(var/line in sortList(caa))
				tcc += " - [line]</br>"
			tcc += "</br></br><big>Не готовы:</big></br>"
		else
			tcc += "</br></br><big>Лобби:</big></br>"
		for(var/line in sortList(cum))
			tcc += " - [line]</br>"
		ctt = tcc
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.clear_lobby()
				D.client.send_to_lobby_console_now(ctt)

/datum/controller/subsystem/title/proc/afterload()
	// do nothing

/datum/controller/subsystem/title/Shutdown()

	for(var/client/thing in GLOB.clients)
		if(!thing)
			continue
		thing.fit_viewport()
		var/atom/movable/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)
