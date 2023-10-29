/datum/map_template/shuttle
	name = "Base Shuttle Template"
	var/prefix = "_maps/shuttles/"
	var/suffix
	var/port_id
	var/shuttle_id

	var/description
	var/prerequisites
	var/admin_notes
	/// How much does this shuttle cost the cargo budget to purchase? Put in terms of CARGO_CRATE_VALUE to properly scale the cost with the current balance of cargo's income.
	var/credit_cost = INFINITY
	/// Can the  be legitimately purchased by the station? Used by hardcoded or pre-mapped shuttles like the lavaland or cargo shuttle.
	var/can_be_bought = TRUE
	/// If set, overrides default movement_force on shuttle
	var/list/movement_force
	// If set, the shuttle becomes untowable
	var/untowable = FALSE

	var/port_x_offset
	var/port_y_offset
	var/extra_desc = ""

/datum/map_template/shuttle/proc/prerequisites_met()
	return TRUE

/datum/map_template/shuttle/New(path = null, rename = null, cache = FALSE, admin_load = null)
	if(admin_load)//This data must be populated for the system to not shit itself apparently
		suffix = admin_load
		port_id = "custom"
		can_be_bought = FALSE
	shuttle_id = "[port_id]_[suffix]"
	if(!admin_load)
		mappath = "[prefix][shuttle_id].dmm"
	. = ..()

/datum/map_template/shuttle/preload_size(path, cache)
	. = ..(path, TRUE) // Done this way because we still want to know if someone actualy wanted to cache the map
	if(!cached_map)
		return

	var/offset = discover_offset(/obj/docking_port/mobile)

	port_x_offset = offset[1]
	port_y_offset = offset[2]

	if(!cache)
		cached_map = null

/datum/map_template/shuttle/load(turf/T, centered, init_atmos = TRUE, finalize = TRUE, register=TRUE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
		centered = FALSE
	//This assumes a non-multi-z shuttle. If you are making a multi-z shuttle, you'll need to change the z bounds for this block. Good luck.
	var/list/turfs = block(locate(max(T.x, 1), max(T.y, 1),  T.z),
							locate(min(T.x+width, world.maxx), min(T.y+height, world.maxy), T.z))
	for(var/turf/turf in turfs)
		turfs[turf] = turf.loc
	keep_cached_map = TRUE //We need to access some stuff here below for shuttle skipovers
	. = ..(T, centered, init_atmos = TRUE, finalize = FALSE)
	keep_cached_map = initial(keep_cached_map)
	if(!.)
		cached_map = keep_cached_map ? cached_map : null
		return
	var/obj/docking_port/mobile/my_port
	for(var/turf/place in turfs)
		if(place.loc == turfs[place] || !istype(place.loc, /area/shuttle)) //If not part of the shuttle, ignore it
			turfs -= place
			continue
		for(var/obj/docking_port/mobile/port in place)
			my_port = port
			port.untowable = untowable
			if(!isnull(port_x_offset))
				switch(port.dir) // Yeah this looks a little ugly but mappers had to do this in their head before
					if(NORTH)
						port.width = width
						port.height = height
						port.dwidth = port_x_offset - 1
						port.dheight = port_y_offset - 1
					if(EAST)
						port.width = height
						port.height = width
						port.dwidth = height - port_y_offset
						port.dheight = port_x_offset - 1
					if(SOUTH)
						port.width = width
						port.height = height
						port.dwidth = width - port_x_offset
						port.dheight = height - port_y_offset
					if(WEST)
						port.width = height
						port.height = width
						port.dwidth = port_y_offset - 1
						port.dheight = width - port_x_offset
			// initTemplateBounds explicitly ignores the shuttle's docking port, to ensure that it calculates the bounds of the shuttle correctly
			// so we need to manually initialize it here
			SSatoms.InitializeAtoms(list(port))
			if(register)
				port.register()

	for(var/turf/shuttle_turf in turfs)
		var/area/shuttle/turf_loc = turfs[shuttle_turf]
		my_port.underlying_turf_area[shuttle_turf] = turf_loc
		if(istype(turf_loc) && turf_loc.mobile_port)
			turf_loc.mobile_port.towed_shuttles |= my_port

		//Getting the amount of baseturfs added
		var/z_offset = shuttle_turf.z - T.z
		var/y_offset = shuttle_turf.y - T.y
		var/x_offset = shuttle_turf.x - T.x
		//retrieving our cache
		var/line
		var/list/cache
		for(var/datum/grid_set/gset as() in cached_map.gridSets)
			if(gset.zcrd - 1 != z_offset) //Not our Z-level
				continue
			if((gset.ycrd - 1 < y_offset) || (gset.ycrd - length(gset.gridLines) > y_offset)) //Our y coord isn't in the bounds
				continue
			line = gset.gridLines[length(gset.gridLines) - y_offset] //Y goes from top to bottom
			if((gset.xcrd - 1 < x_offset) || (gset.xcrd + (length(line)/cached_map.key_len) - 2 > x_offset)) ///Our x coord isn't in the bounds
				continue
			cache = cached_map.modelCache[copytext(line, 1+((x_offset-gset.xcrd+1)*cached_map.key_len), 1+((x_offset-gset.xcrd+2)*cached_map.key_len))]
			break
		if(!cache) //Our turf isn't in the cached map, something went very wrong
			continue

		//How many baseturfs were added to this turf by the mapload
		var/baseturf_length
		var/turf/P //Typecasted for the initial call
		for(P as() in cache[1])
			if(ispath(P, /turf))
				var/list/added_baseturfs = GLOB.created_baseturf_lists[initial(P.baseturfs)] //We can assume that our turf type will be included here because it was just generated in the mapload.
				if(!islist(added_baseturfs))
					added_baseturfs = list(added_baseturfs)
				baseturf_length = length(added_baseturfs - GLOB.blacklisted_automated_baseturfs)
				break
		if(ispath(P, /turf/template_noop)) //No turf was added, don't add a skipover
			continue

		if(!islist(shuttle_turf.baseturfs))
			shuttle_turf.baseturfs = list(shuttle_turf.baseturfs)

		shuttle_turf.baseturfs.Insert(shuttle_turf.baseturfs.len + 1 - baseturf_length, /turf/baseturf_skipover/shuttle)

	//If this is a superfunction call, we don't want to initialize atoms here, let the subfunction handle that
	if(finalize)
		//initialize things that are normally initialized after map load
		initTemplateBounds(cached_map.bounds, init_atmos)

		log_game("[name] loaded at [T.x],[T.y],[T.z]")

	cached_map = keep_cached_map ? cached_map : null

//Whatever special stuff you want
/datum/map_template/shuttle/post_load(obj/docking_port/mobile/M)
	if(movement_force)
		M.movement_force = movement_force.Copy()
	//M.linkup()

/datum/map_template/shuttle/emergency
	port_id = "emergency"
	name = "Base Shuttle Template (Emergency)"
	untowable = TRUE

/datum/map_template/shuttle/cargo
	port_id = "cargo"
	name = "Base Shuttle Template (Cargo)"
	can_be_bought = FALSE

/datum/map_template/shuttle/ferry
	port_id = "ferry"
	name = "Base Shuttle Template (Ferry)"

/datum/map_template/shuttle/whiteship
	port_id = "whiteship"

/datum/map_template/shuttle/labour
	port_id = "labour"
	can_be_bought = FALSE

/datum/map_template/shuttle/mining
	port_id = "mining"
	can_be_bought = FALSE

/datum/map_template/shuttle/mining_common
	port_id = "mining_common"
	suffix = "meta"
	can_be_bought = FALSE

/datum/map_template/shuttle/arrival
	port_id = "arrival"
	can_be_bought = FALSE
	untowable = TRUE

/datum/map_template/shuttle/infiltrator
	port_id = "infiltrator"
	can_be_bought = FALSE

/datum/map_template/shuttle/aux_base
	port_id = "aux_base"
	can_be_bought = FALSE

/datum/map_template/shuttle/escape_pod
	port_id = "escape_pod"
	can_be_bought = FALSE

/datum/map_template/shuttle/assault_pod
	port_id = "assault_pod"
	can_be_bought = FALSE

/datum/map_template/shuttle/pirate
	port_id = "pirate"
	can_be_bought = FALSE

/datum/map_template/shuttle/hunter
	port_id = "hunter"
	can_be_bought = FALSE

/datum/map_template/shuttle/ruin //For random shuttles in ruins
	port_id = "ruin"
	can_be_bought = FALSE

/datum/map_template/shuttle/snowdin
	port_id = "snowdin"
	can_be_bought = FALSE

/datum/map_template/shuttle/partyhard
	port_id = "partyhard"
	can_be_bought = FALSE

/datum/map_template/shuttle/yohei
	name = "Сборщик Йохеев"
	port_id = "yohei"
	suffix = "harvester"
	can_be_bought = FALSE

/datum/map_template/shuttle/freelancer
	name = "Фрегат Путешественника: Малый"
	port_id = "freelancer"
	suffix = "small"
	can_be_bought = FALSE

/datum/map_template/shuttle/freelancer/medium
	name = "Фрегат Путешественника: Средний"
	suffix = "medium"

// Shuttles start here:

/datum/map_template/shuttle/emergency/backup
	suffix = "backup"
	name = "Backup Shuttle"
	can_be_bought = FALSE

/datum/map_template/shuttle/emergency/construction
	suffix = "construction"
	name = "Набор построй свой собственный шаттл"
	description = "Для предпиимчевого челночного инженера! Шасси будет пристыковано при покупке, но запуск должен быть разрешен в обычном порядке через вызов шаттла. Поставляется вместе со строительными материалами. Разблокирует возможность купить ящики с двигателем шаттла в отделе снабжения."
	admin_notes = "No brig, no medical facilities, no shuttle console."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/construction/post_load()
	. = ..()
	//enable buying engines from cargo
	var/datum/supply_pack/P = SSshuttle.supply_packs[/datum/supply_pack/engineering/shuttle_engine]
	P.special_enabled = TRUE


/datum/map_template/shuttle/emergency/asteroid
	suffix = "asteroid"
	name = "Эвакуационный шаттл Астероидной Станции"
	description = "Респектабельный шаттл среднего размера, который впервые заступил на службу доставляя экипаж NanoTrasen на их внутренные объекты в поясе астероидов и обратно."
	credit_cost = CARGO_CRATE_VALUE * 6

/datum/map_template/shuttle/emergency/bar
	suffix = "bar"
	name = "Бар Аварийного Выхода"
	description = "К услугам гостей разумный персонал бара (Бардрон и Барменша), ванная, качественная гостинная для руководителей и большой стол для собраний."
	admin_notes = "Bardrone and Barmaid are GODMODE, will be automatically sentienced by the fun balloon at 60 seconds before arrival. \
	Has medical facilities."
	credit_cost = CARGO_CRATE_VALUE * 10

/datum/map_template/shuttle/emergency/pod
	suffix = "pod"
	name = "Спасательные Капсулы"
	description = "Мы не ожидали эвакуации так рано. Всё что у нас есть это эти две спасательные капсулы."
	admin_notes = "For player punishment."
	can_be_bought = FALSE

/datum/map_template/shuttle/emergency/russiafightpit
	suffix = "russiafightpit"
	name = "Mother Russia Bleeds"
	description = "Это довольно высококачественный шаттл, da. Сидений много, много пространства, вся экипировка! Даже есть развлечения! Например куча бухла и арена для пьяного экипажа, весело! Если арены не достаточно, просто нажмите на кнопку выпуска выпуска медведей. Волноваться нет смысла, медведи обучены не вылезать из бойцовской ямы, ток что полностью безопасно до момента пока никто не слишком глуп или пьян, чтобы оставить дверь открытой. И не позволяйте детям Азимова испортить веселье!"
	admin_notes = "Includes a small variety of weapons. And bears. Only captain-access can release the bears. Bears won't smash the windows themselves, but they can escape if someone lets them."
	credit_cost = CARGO_CRATE_VALUE * 10 // While the shuttle is rusted and poorly maintained, trained bears are costly.

/datum/map_template/shuttle/emergency/meteor
	suffix = "meteor"
	name = "Астероид С Привязанными К Нему Двигателями"
	description = "Опустошенный астероид с привязанными к нему двигателями, процедура опустошения делает его очень сложной целью для угона, но и весьма ценной. Этот шаттл ввиду своих размеров и сложностей с управлением может повредить зону стыковки."
	admin_notes = "This shuttle will likely crush escape, killing anyone there."
	credit_cost = CARGO_CRATE_VALUE * 30
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)

/datum/map_template/shuttle/emergency/luxury
	suffix = "luxury"
	name = "Роскошный шаттл"
	description = "Роскошный золотой шаттл с крытым бассейном. Каждый член экипажа желающий попасть на борт должен принести 500 кредитов, оплата принимается наличными и минеральными монетами"
	extra_desc = "Зайти на шаттл стоит 500 кредитов."
	admin_notes = "Due to the limited space for non paying crew, this shuttle may cause a riot."
	credit_cost = CARGO_CRATE_VALUE * 20

/datum/map_template/shuttle/emergency/medisim
	suffix = "medisim"
	name = "Купол симуляции Средневековой эры"
	description = "A state of the art simulation dome, loaded onto your shuttle! Watch and laugh at how petty humanity used to be before it reached the stars. Guaranteed to be at least 40% historically accurate."
	admin_notes = "Ghosts can spawn in and fight as knights or archers. The CTF auto restarts, so no admin intervention necessary."
	credit_cost = CARGO_CRATE_VALUE * 20

/datum/map_template/shuttle/emergency/medisim/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_MEDISIM]

/datum/map_template/shuttle/emergency/discoinferno
	suffix = "discoinferno"
	name = "Disco Inferno"
	description = "The glorious results of centuries of plasma research done by Nanotrasen employees. This is the reason why you are here. Get on and dance like you're on fire, burn baby burn!"
	admin_notes = "Flaming hot. The main area has a dance machine as well as plasma floor tiles that will be ignited by players every single time."
	credit_cost = CARGO_CRATE_VALUE * 20
	can_be_bought = FALSE

/datum/map_template/shuttle/emergency/arena
	suffix = "arena"
	name = "Арена"
	description = "Персонал должен пройти через потустороннюю арену чтобы попасть на шаттл. Ожидайте огромное количество жертв. Для разблокировки этого шаттла необходимо найти и устранить источник кровавого сигнала."
	admin_notes = "RIP AND TEAR."
	credit_cost = CARGO_CRATE_VALUE * 20
	/// Whether the arena z-level has been created
	var/arena_loaded = FALSE

/datum/map_template/shuttle/emergency/arena/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_BUBBLEGUM]

/datum/map_template/shuttle/emergency/arena/post_load(obj/docking_port/mobile/M)
	. = ..()
	if(!arena_loaded)
		arena_loaded = TRUE
		var/datum/map_template/arena/arena_template = new()
		arena_template.load_new_z()

/datum/map_template/arena
	name = "Арена"
	mappath = "_maps/templates/the_arena.dmm"

/datum/map_template/shuttle/emergency/birdboat
	suffix = "birdboat"
	name = "эвакуационный шаттл станции \"birdboat\""
	description = "Не смотря на то что этот шаттл немного маловат - он полностью укомплектован, чего не скажешь о типе станции, на которой он был заказан."
	credit_cost = CARGO_CRATE_VALUE * 2

/datum/map_template/shuttle/emergency/box
	suffix = "box"
	name = "эвакуационный шаттл станции \"Box\""
	credit_cost = CARGO_CRATE_VALUE * 4
	description = "Проверенный временем золотой стандарт для экстренной эксфильтрации, оборудованный всем, что может пригодиться экипажу для безопасного полета домой."

/datum/map_template/shuttle/emergency/donut
	suffix = "donut"
	name = "эвакуационный шаттл станции \"donut\""
	description = "Прекрасно налезет на любую грубую шутку с формой станции, шаттл содержит несколько камер для заключенных и небольшое медицинское крыло."
	admin_notes = "Has airlocks on both sides of the shuttle and will probably intersect near the front on some stations that build past departures."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/clown
	suffix = "clown"
	name = "Snappop(tm)!"
	description = "Привет дети и взрослые! \
	Устали от СКУЧНЫХ и НУДНЫХ поездок на шаттле после того как эвакуировались из-за, наверняка, УТОМИТЕЛЬНЫХ причин. В таком случае закажи Snappop(tm) уже сегодня! \
	У нас куча веселых занятий для всех, доступ во все кабины и никакого скучного брига безопасности! Бу! Играйте в переодевание со своими друзьями! \
	Соберите все простыни раньше соседа! Узнайте, наблюдает ли за вами ИИ  с помощью нашего ожидающего патента изобретения \"Пикающий ТОМ: Многоинструментальный ИИ Детектор\" или, если коротко, ПИИИТОР. \
	Веселой поездки!"
	admin_notes = "Brig is replaced by anchored greentext book surrounded by lavaland chasms, stationside door has been removed to prevent accidental dropping. No brig."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/emergency/cramped
	suffix = "cramped"
	name = "Secure Transport Vessel 5 (STV5)"
	description = "Well, looks like CentCom only had this ship in the area, they probably weren't expecting you to need evac for a while. \
	Probably best if you don't rifle around in whatever equipment they were transporting. I hope you're friendly with your coworkers, because there is very little space in this thing.\n\
	\n\
	Contains contraband armory guns, maintenance loot, and abandoned crates!"
	admin_notes = "Due to origin as a solo piloted secure vessel, has an active GPS onboard labeled STV5. Has roughly as much space as Hi Daniel, except with explosive crates."

/datum/map_template/shuttle/emergency/meta
	suffix = "meta"
	name = "Meta Station Emergency Shuttle"
	credit_cost = CARGO_CRATE_VALUE * 8
	description = "A fairly standard shuttle, though larger and slightly better equipped than the Box Station variant."

/datum/map_template/shuttle/emergency/kilo
	suffix = "kilo"
	name = "Kilo Station Emergency Shuttle"
	credit_cost = CARGO_CRATE_VALUE * 10
	description = "A fully functional shuttle including a complete infirmary, storage facilties and regular amenities."

/datum/map_template/shuttle/emergency/mini
	suffix = "mini"
	name = "Ministation emergency shuttle"
	credit_cost = CARGO_CRATE_VALUE * 2
	description = "Despite its namesake, this shuttle is actually only slightly smaller than standard, and still complete with a brig and medbay."

/datum/map_template/shuttle/emergency/tram
	suffix = "tram"
	name = "Tram Station Emergency Shuttle"
	credit_cost = CARGO_CRATE_VALUE * 4
	description = "A train but in space, choo choo!"

/datum/map_template/shuttle/emergency/scrapheap
	suffix = "scrapheap"
	name = "Standby Evacuation Vessel \"Scrapheap Challenge\""
	credit_cost = CARGO_CRATE_VALUE * -2
	description = "Due to a lack of functional emergency shuttles, we bought this second hand from a scrapyard and pressed it into service. Please do not lean too heavily on the exterior windows, they are fragile."
	admin_notes = "An abomination with no functional medbay, sections missing, and some very fragile windows. Surprisingly airtight."
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 15)

/datum/map_template/shuttle/emergency/narnar
	suffix = "narnar"
	name = "Shuttle 667"
	description = "Looks like this shuttle may have wandered into the darkness between the stars on route to the station. Let's not think too hard about where all the bodies came from."
	admin_notes = "Contains real cult ruins, mob eyeballs, and inactive constructs. Cult mobs will automatically be sentienced by fun balloon. \
	Cloning pods in 'medbay' area are showcases and nonfunctional."
	credit_cost = 6667 ///The joke is the number so no defines

/datum/map_template/shuttle/emergency/narnar/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_NARNAR]

/datum/map_template/shuttle/emergency/pubby
	suffix = "pubby"
	name = "Pubby Station Emergency Shuttle"
	description = "A train but in space! Complete with a first, second class, brig and storage area."
	admin_notes = "Choo choo motherfucker!"
	credit_cost = CARGO_CRATE_VALUE * 2

/datum/map_template/shuttle/emergency/cere
	suffix = "cere"
	name = "Cere Station Emergency Shuttle"
	description = "The large, beefed-up version of the box-standard shuttle. Includes an expanded brig, fully stocked medbay, enhanced cargo storage with mech chargers, \
	an engine room stocked with various supplies, and a crew capacity of 80+ to top it all off. Live large, live Cere."
	admin_notes = "Seriously big, even larger than the Delta shuttle."
	credit_cost = CARGO_CRATE_VALUE * 20

/datum/map_template/shuttle/emergency/supermatter
	suffix = "supermatter"
	name = "Hyperfractal Gigashuttle"
	description = "\"I dunno, this seems kinda needlessly complicated.\"\n\
	\"This shuttle has very a very high safety record, according to CentCom Officer Cadet Yins.\"\n\
	\"Are you sure?\"\n\
	\"Yes, it has a safety record of N-A-N, which is apparently larger than 100%.\""
	admin_notes = "Supermatter that spawns on shuttle is special anchored 'hugbox' supermatter that cannot take damage and does not take in or emit gas. \
	Outside of admin intervention, it cannot explode. \
	It does, however, still dust anything on contact, emits high levels of radiation, and induce hallucinations in anyone looking at it without protective goggles. \
	Emitters spawn powered on, expect admin notices, they are harmless."
	credit_cost = CARGO_CRATE_VALUE * 200
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)

/datum/map_template/shuttle/emergency/imfedupwiththisworld
	suffix = "imfedupwiththisworld"
	name = "Oh, Hi Daniel"
	description = "How was space work today? Oh, pretty good. We got a new space station and the company will make a lot of money. What space station? I cannot tell you; it's space confidential. \
	Aw, come space on. Why not? No, I can't. Anyway, how is your space roleplay life?"
	admin_notes = "Tiny, with a single airlock and wooden walls. What could go wrong?"
	can_be_bought = FALSE
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 15)

/datum/map_template/shuttle/emergency/goon
	suffix = "goon"
	name = "NES Port"
	description = "The Nanotrasen Emergency Shuttle Port(NES Port for short) is a shuttle used at other less known Nanotrasen facilities and has a more open inside for larger crowds, but fewer onboard shuttle facilities."
	credit_cost = CARGO_CRATE_VALUE

/datum/map_template/shuttle/emergency/rollerdome
	suffix = "rollerdome"
	name = "Uncle Pete's Rollerdome"
	description = "Developed by a member of Nanotrasen's R&D crew that claims to have travelled from the year 2028. \
	He says this shuttle is based off an old entertainment complex from the 1990s, though our database has no records on anything pertaining to that decade."
	admin_notes = "ONLY NINETIES KIDS REMEMBER. Uses the fun balloon and drone from the Emergency Bar."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/wabbajack
	suffix = "wabbajack"
	name = "NT Lepton Violet"
	description = "The research team based on this vessel went missing one day, and no amount of investigation could discover what happened to them. \
	The only occupants were a number of dead rodents, who appeared to have clawed each other to death. \
	Needless to say, no engineering team wanted to go near the thing, and it's only being used as an Emergency Escape Shuttle because there is literally nothing else available."
	admin_notes = "If the crew can solve the puzzle, they will wake the wabbajack statue. It will likely not end well. There's a reason it's boarded up. Maybe they should have just left it alone."
	credit_cost = CARGO_CRATE_VALUE * 30

/datum/map_template/shuttle/emergency/omega
	suffix = "omega"
	name = "Omegastation Emergency Shuttle"
	description = "On the smaller size with a modern design, this shuttle is for the crew who like the cosier things, while still being able to stretch their legs."
	credit_cost = CARGO_CRATE_VALUE * 2
/*
/datum/map_template/shuttle/emergency/cruise // проебывает атмос, не ебу почему но мне pohyi
	suffix = "cruise"
	name = "The NTSS Independence"
	description = "Ordinarily reserved for special functions and events, the Cruise Shuttle Independence can bring a summery cheer to your next station evacuation for a 'modest' fee!"
	admin_notes = "This motherfucker is BIG. You might need to force dock it."
	credit_cost = CARGO_CRATE_VALUE * 100
*/
/datum/map_template/shuttle/emergency/monkey
	suffix = "nature"
	name = "Dynamic Environmental Interaction Shuttle"
	description = "A large shuttle with a center biodome that is flourishing with life. Frolick with the monkeys! (Extra monkeys are stored on the bridge.)"
	admin_notes = "Pretty freakin' large, almost as big as Raven or Cere. Excercise caution with it."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/ferry/base
	suffix = "base"
	name = "transport ferry"
	description = "Standard issue Box/Metastation CentCom ferry."

/datum/map_template/shuttle/ferry/meat
	suffix = "meat"
	name = "\"meat\" ferry"
	description = "Ahoy! We got all kinds o' meat aft here. Meat from plant people, people who be dark, not in a racist way, just they're dark black. \
	Oh and lizard meat too,mighty popular that is. Definitely 100% fresh, just ask this guy here. *person on meatspike moans* See? \
	Definitely high quality meat, nothin' wrong with it, nothin' added, definitely no zombifyin' reagents!"
	admin_notes = "Meat currently contains no zombifying reagents, lizard on meatspike must be spawned in."

/datum/map_template/shuttle/ferry/lighthouse
	suffix = "lighthouse"
	name = "The Lighthouse(?)"
	description = "*static*... part of a much larger vessel, possibly military in origin. \
	The weapon markings aren't anything we've seen ...static... by almost never the same person twice, possible use of unknown storage ...static... \
	seeing ERT officers onboard, but no missions are on file for ...static...static...annoying jingle... only at The LIGHTHOUSE! \
	Fulfilling needs you didn't even know you had. We've got EVERYTHING, and something else!"
	admin_notes = "Currently larger than ferry docking port on Box, will not hit anything, but must be force docked. Trader and ERT bodyguards are not included."

/datum/map_template/shuttle/ferry/fancy
	suffix = "fancy"
	name = "fancy transport ferry"
	description = "At some point, someone upgraded the ferry to have fancier flooring... and fewer seats."

/datum/map_template/shuttle/ferry/kilo
	suffix = "kilo"
	name = "kilo transport ferry"
	description = "Standard issue CentCom Ferry for Kilo pattern stations. Includes additional equipment and rechargers."

/datum/map_template/shuttle/whiteship/box
	suffix = "box"
	name = "Hospital Ship"

/datum/map_template/shuttle/whiteship/meta
	suffix = "meta"
	name = "Salvage Ship"

/datum/map_template/shuttle/whiteship/pubby
	suffix = "pubby"
	name = "NT White UFO"

/datum/map_template/shuttle/whiteship/cere
	suffix = "cere"
	name = "NT Construction Vessel"

/datum/map_template/shuttle/whiteship/kilo
	suffix = "kilo"
	name = "NT Mining Shuttle"

/datum/map_template/shuttle/whiteship/donut
	suffix = "donut"
	name = "NT Long-Distance Bluespace Jumper"

/datum/map_template/shuttle/whiteship/tram
	suffix = "tram"
	name = "NT Long-Distance Bluespace Freighter"

/datum/map_template/shuttle/whiteship/delta
	suffix = "delta"
	name = "NT Frigate"

/datum/map_template/shuttle/whiteship/pod
	suffix = "whiteship_pod"
	name = "Salvage Pod"

/datum/map_template/shuttle/cargo/kilo
	suffix = "kilo"
	name = "supply shuttle (Kilo)"

/datum/map_template/shuttle/cargo/birdboat
	suffix = "birdboat"
	name = "supply shuttle (Birdboat)"

/datum/map_template/shuttle/cargo/donut
	suffix = "donut"
	name = "supply shuttle (Donut)"

/datum/map_template/shuttle/cargo/pubby
	suffix = "pubby"
	name = "supply shuttle (Pubby)"

/datum/map_template/shuttle/emergency/delta
	suffix = "delta"
	name = "Delta Station Emergency Shuttle"
	description = "A large shuttle for a large station, this shuttle can comfortably fit all your overpopulation and crowding needs. Complete with all facilities plus additional equipment."
	admin_notes = "Go big or go home."
	credit_cost = CARGO_CRATE_VALUE * 15

/datum/map_template/shuttle/emergency/raven
	suffix = "raven"
	name = "CentCom Raven Cruiser"
	description = "The CentCom Raven Cruiser is a former high-risk salvage vessel, now repurposed into an emergency escape shuttle. \
	Once first to the scene to pick through warzones for valuable remains, it now serves as an excellent escape option for stations under heavy fire from outside forces. \
	This escape shuttle boasts shields and numerous anti-personnel turrets guarding its perimeter to fend off meteors and enemy boarding attempts."
	admin_notes = "Comes with turrets that will target anything without the neutral faction (nuke ops, xenos etc, but not pets)."
	credit_cost = CARGO_CRATE_VALUE * 60

/datum/map_template/shuttle/emergency/zeta
	suffix = "zeta"
	name = "Tr%nPo2r& Z3TA"
	description = "A glitch appears on your monitor, flickering in and out of the options laid before you. \
	It seems strange and alien, you may need a special technology to access the signal.."
	admin_notes = "Has alien surgery tools, and a void core that provides unlimited power."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/emergency/zeta/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_ALIENTECH]

/datum/map_template/shuttle/arrival/box
	suffix = "box"
	name = "arrival shuttle (Box)"

/datum/map_template/shuttle/cargo/box
	suffix = "box"
	name = "cargo ferry (Box)"

/datum/map_template/shuttle/mining/box
	suffix = "box"
	name = "mining shuttle (Box)"

/datum/map_template/shuttle/labour/box
	suffix = "box"
	name = "labour shuttle (Box)"

/datum/map_template/shuttle/arrival/donut
	suffix = "donut"
	name = "arrival shuttle (Donut)"

/datum/map_template/shuttle/infiltrator/basic
	suffix = "basic"
	name = "basic syndicate infiltrator"

/datum/map_template/shuttle/infiltrator/advanced
	suffix = "advanced"
	name = "advanced syndicate infiltrator"

/datum/map_template/shuttle/cargo/delta
	suffix = "delta"
	name = "cargo ferry (Delta)"

/datum/map_template/shuttle/mining/delta
	suffix = "delta"
	name = "mining shuttle (Delta)"

/datum/map_template/shuttle/mining/kilo
	suffix = "kilo"
	name = "mining shuttle (Kilo)"

/datum/map_template/shuttle/mining/large
	suffix = "large"
	name = "mining shuttle (Large)"

/datum/map_template/shuttle/exploration
	port_id = "exploration"
	suffix = "shuttle"
	name = "Шаттл Рейнджеров"
	can_be_bought = FALSE

/datum/map_template/shuttle/labour/delta
	suffix = "delta"
	name = "labour shuttle (Delta)"

/datum/map_template/shuttle/labour/kilo
	suffix = "kilo"
	name = "labour shuttle (Kilo)"

/datum/map_template/shuttle/mining_common/meta
	suffix = "meta"
	name = "lavaland shuttle (Meta)"

/datum/map_template/shuttle/mining_common/kilo
	suffix = "kilo"
	name = "lavaland shuttle (Kilo)"

/datum/map_template/shuttle/arrival/delta
	suffix = "delta"
	name = "arrival shuttle (Delta)"

/datum/map_template/shuttle/arrival/kilo
	suffix = "kilo"
	name = "arrival shuttle (Kilo)"

/datum/map_template/shuttle/arrival/pubby
	suffix = "pubby"
	name = "arrival shuttle (Pubby)"

/datum/map_template/shuttle/arrival/omega
	suffix = "omega"
	name = "arrival shuttle (Omega)"

/datum/map_template/shuttle/aux_base/default
	suffix = "default"
	name = "auxilliary base (Default)"

/datum/map_template/shuttle/aux_base/small
	suffix = "small"
	name = "auxilliary base (Small)"

/datum/map_template/shuttle/escape_pod/default
	suffix = "default"
	name = "escape pod (Default)"

/datum/map_template/shuttle/escape_pod/large
	suffix = "large"
	name = "escape pod (Large)"

/datum/map_template/shuttle/assault_pod/default
	suffix = "default"
	name = "assault pod (Default)"

/datum/map_template/shuttle/pirate/default
	suffix = "default"
	name = "pirate ship (Default)"

/datum/map_template/shuttle/pirate/silverscale
	suffix = "silverscale"
	name = "pirate ship (Silver Scales)"

/datum/map_template/shuttle/pirate/dutchman
	suffix = "dutchman"
	name = "pirate ship (Flying Dutchman)"

/datum/map_template/shuttle/hunter/space_cop
	suffix = "space_cop"
	name = "Police Spacevan"

/datum/map_template/shuttle/hunter/russian
	suffix = "russian"
	name = "Russian Cargo Ship"

/datum/map_template/shuttle/hunter/bounty
	suffix = "bounty"
	name = "Bounty Hunter Ship"

/datum/map_template/shuttle/ruin/caravan_victim
	suffix = "caravan_victim"
	name = "Небольшое грузовое судно"

/datum/map_template/shuttle/ruin/pirate_cutter
	suffix = "pirate_cutter"
	name = "Пиратский куттер"

/datum/map_template/shuttle/ruin/syndicate_dropship
	suffix = "syndicate_dropship"
	name = "Syndicate Dropship"

/datum/map_template/shuttle/ruin/syndicate_fighter_shiv
	suffix = "syndicate_fighter_shiv"
	name = "Синди-истребитель "

/datum/map_template/shuttle/snowdin/mining
	suffix = "mining"
	name = "Snowdin Mining Elevator"

/datum/map_template/shuttle/snowdin/excavation
	suffix = "excavation"
	name = "Snowdin Excavation Elevator"

/datum/map_template/shuttle/tramstation/tram
	port_id = "tramstation"
	suffix = "tram"
	name = "Tramstation Transit Shuttle"

/datum/map_template/shuttle/partyhard/elevator
	suffix = "elevator"
	name = "PH Station Elevator"

/datum/map_template/shuttle/cargo/partyhard
	suffix = "partyhard"
	name = "cargo ferry (PartyHard)"

/datum/map_template/shuttle/mining/unit
	suffix = "unit"
	name = "mining shuttle (Unit)"
