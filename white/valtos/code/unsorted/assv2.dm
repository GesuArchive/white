GLOBAL_DATUM_INIT(maploader, /datum/dmm_suite, new())

/datum/dmm_suite
	var/static/quote = "\""

	// These regexes are global - meaning that starting the maploader again mid-load will
	// reset progress - which means we need to track our index per-map, or we'll
	// eternally recurse
		// /"([a-zA-Z]+)" = \(((?:.|\n)*?)\)\n(?!\t)|\((\d+),(\d+),(\d+)\) = \{"([a-zA-Z\n]*)"\}/g
	var/static/regex/dmmRegex = new/regex({""(\[a-zA-Z]+)" = \\(((?:.|\n)*?)\\)\n(?!\t)|\\((\\d+),(\\d+),(\\d+)\\) = \\{"(\[a-zA-Z\n]*)"\\}"}, "g")
		// /^[\s\n]+"?|"?[\s\n]+$|^"|"$/g
	var/static/regex/trimQuotesRegex = new/regex({"^\[\\s\n]+"?|"?\[\\s\n]+$|^"|"$"}, "g")
		// /^[\s\n]+|[\s\n]+$/
	var/static/regex/trimRegex = new/regex("^\[\\s\n]+|\[\\s\n]+$", "g")
	var/static/list/modelCache = list()

	var/static/list/letter_digits = list(
		"a", "b", "c", "d", "e",
		"f", "g", "h", "i", "j",
		"k", "l", "m", "n", "o",
		"p", "q", "r", "s", "t",
		"u", "v", "w", "x", "y",
		"z",
		"A", "B", "C", "D", "E",
		"F", "G", "H", "I", "J",
		"K", "L", "M", "N", "O",
		"P", "Q", "R", "S", "T",
		"U", "V", "W", "X", "Y",
		"Z"
	)

#define DMM_IGNORE_AREAS 1
#define DMM_IGNORE_TURFS 2
#define DMM_IGNORE_OBJS 4
#define DMM_IGNORE_NPCS 8
#define DMM_IGNORE_PLAYERS 16
#define DMM_IGNORE_MOBS 24
#define DMM_USE_JSON 32

// MAX 2 ZLEVELS FUCK YOU
/datum/dmm_suite/proc/save_station()
	save_map(locate(16, 16, 2), locate(world.maxx - 16, world.maxy - 16, 2), "z1", (DMM_IGNORE_NPCS | DMM_IGNORE_PLAYERS | DMM_IGNORE_MOBS), "data/map_saves/[ckey(SSmapping.config?.map_name)]/[GLOB.round_id]/")
	var/turf/ttop = locate(125, 125, 3)
	if(is_station_level(ttop.z))
		save_map(locate(16, 16, 3), locate(world.maxx - 16, world.maxy - 16, 3), "z2", (DMM_IGNORE_NPCS | DMM_IGNORE_PLAYERS | DMM_IGNORE_MOBS), "data/map_saves/[ckey(SSmapping.config?.map_name)]/[GLOB.round_id]/")

/datum/dmm_suite/proc/save_map(turf/t1, turf/t2, map_name = "", flags = 0, map_prefix = "_maps/quicksave/")
	// Check for illegal characters in file name... in a cheap way.
	if(!((ckeyEx(map_name) == map_name) && ckeyEx(map_name)))
		CRASH("Invalid text supplied to proc save_map, invalid characters or empty string.")
	// Check for valid turfs.
	if(!isturf(t1) || !isturf(t2))
		CRASH("Invalid arguments supplied to proc save_map, arguments were not turfs.")

	var/map_path = "[map_prefix][map_name].dmm"
	if(fexists(map_path))
		fdel(map_path)
	var/saved_map = file(map_path)
	var/map_text = write_map(t1, t2, flags, saved_map)
	saved_map << map_text
	return saved_map

/datum/dmm_suite/proc/write_map(turf/t1, turf/t2, flags = 0)
	// Check for valid turfs.
	if(!isturf(t1) || !isturf(t2))
		CRASH("Invalid arguments supplied to proc write_map, arguments were not turfs.")

	var/turf/ne = locate(max(t1.x, t2.x), max(t1.y, t2.y), max(t1.z, t2.z)) // Outer corner
	var/turf/sw = locate(min(t1.x, t2.x), min(t1.y, t2.y), min(t1.z, t2.z)) // Inner corner
	var/list/templates[0]
	var/list/template_buffer = list()
	var/template_buffer_text
	var/dmm_text = ""

	var/total_timer = REALTIMEOFDAY
	var/timer = REALTIMEOFDAY
	message_admins("Reading turfs...")

	// Read the contents of all the turfs we were given
	for(var/pos_z in sw.z to ne.z)
		for(var/pos_y in ne.y to sw.y step -1) // We're reversing this because the map format is silly
			for(var/pos_x in sw.x to ne.x)
				var/turf/test_turf = locate(pos_x, pos_y, pos_z)
				var/test_template = make_template(test_turf, flags)
				var/template_number = templates.Find(test_template)
				if(!template_number)
					templates.Add(test_template)
					template_number = length(templates)
				template_buffer += "[template_number],"
				CHECK_TICK
			template_buffer += ";"
		template_buffer += "."

	template_buffer_text = jointext(template_buffer, "")
	message_admins("Reading turfs took [round(0.1 * (REALTIMEOFDAY - timer), 0.1)]s.")

	if(length(templates) == 0)
		CRASH("No templates found!")

	var/key_length = round(log(length(letter_digits), length(templates) - 1) + 1) // or floor
	var/list/keys[length(templates)]

	// Write the list of key/model pairs to the file
	timer = REALTIMEOFDAY
	message_admins("Writing out key/model pairs to file header...")
	var/list/key_models = list()
	for(var/key_pos in 1 to length(templates))
		keys[key_pos] = get_model_key(key_pos, key_length)
		key_models += "\"[keys[key_pos]]\" = ([templates[key_pos]])\n"
		CHECK_TICK

	dmm_text += jointext(key_models,"")
	message_admins("Writing key/model pairs complete, took [round(0.1 * (REALTIMEOFDAY - timer), 0.1)]s.")

	var/z_level = 0
	// Loop over all z in our zone
	timer = REALTIMEOFDAY
	message_admins("Writing out key map...")

	var/list/key_map = list()
	var/z_pos = 1
	while(TRUE)
		if(z_pos >= length(template_buffer_text))
			break

		if(z_level)
			key_map += "\n"

		key_map += "\n(1,1,[++z_level]) = {\"\n"

		var/z_block = copytext(template_buffer_text, z_pos, findtext(template_buffer_text, ".", z_pos))
		var/y_pos = 1
		while(TRUE)
			if(y_pos >= length(z_block))
				break

			var/y_block = copytext(z_block, y_pos, findtext(z_block, ";", y_pos))
			// A row of keys
			y_pos = findtext(z_block, ";", y_pos) + 1
			var/x_pos = 1
			while(TRUE)
				if(x_pos >= length(y_block))
					break

				var/x_block = copytext(y_block, x_pos, findtext(y_block, ",", x_pos))
				var/key_number = text2num(x_block)
				var/temp_key = keys[key_number]
				key_map += temp_key
				CHECK_TICK
				x_pos = findtext(y_block, ",", x_pos) + 1
			key_map += "\n"
		key_map += "\"}"
		z_pos = findtext(template_buffer_text, ".", z_pos) + 1

	dmm_text += jointext(key_map, "")
	message_admins("Writing key map complete, took [round(0.1 * (REALTIMEOFDAY - timer), 0.1)]s.")
	message_admins("TOTAL TIME: [round(0.1 * (REALTIMEOFDAY - total_timer), 0.1)]s.")

	return dmm_text

/datum/dmm_suite/proc/make_template(turf/model, flags = 0)
	var/use_json = (flags & DMM_USE_JSON) ? TRUE : FALSE

	var/template = ""
	var/turf_template = ""
	var/list/obj_template = list()
	var/list/mob_template = list()
	var/area_template = ""

	// Turf
	if(!(flags & DMM_IGNORE_TURFS))
		turf_template = "[model.type][check_attributes(model,use_json=use_json)],"
	else
		turf_template = "[world.turf],"

	// Objects loop
	if(!(flags & DMM_IGNORE_OBJS))
		for(var/obj/O in model.contents)
			if(QDELETED(O))
				continue

			obj_template += "[O.type][check_attributes(O,use_json=use_json)],"

	// Mobs Loop
	for(var/mob/M in model.contents)
		if(QDELETED(M))
			continue

		if(M.client)
			if(!(flags & DMM_IGNORE_PLAYERS))
				mob_template += "[M.type][check_attributes(M,use_json=use_json)],"
		else
			if(!(flags & DMM_IGNORE_NPCS))
				mob_template += "[M.type][check_attributes(M,use_json=use_json)],"

	// Area
	if(!(flags & DMM_IGNORE_AREAS))
		var/area/m_area = model.loc
		area_template = "[m_area.type][check_attributes(m_area,use_json=use_json)]"
	else
		area_template = "[world.area]"

	template = "[jointext(obj_template,"")][jointext(mob_template,"")][turf_template][area_template]"
	return template

/datum/dmm_suite/proc/check_attributes(atom/A, use_json = FALSE)
	var/attributes_text = "{"
	var/list/attributes = list()
	if(!use_json)
		for(var/V in A.vars)
			CHECK_TICK
			if((!issaved(A.vars[V])) || (A.vars[V] == initial(A.vars[V])))
				continue

			attributes += var_to_dmm(A.vars[V], V)
	else
		var/list/to_encode = A.serialize()
		// We'll want to write out vars that are important to the editor
		// So that the map is legible as before
		for(var/T in A.map_important_vars())
			// Save vars that are important for the map editor, so that
			// json-encoded maps are legible for standard editors
			if(A.vars[T] != initial(A.vars[T]))
				to_encode -= T
				attributes += var_to_dmm(A.vars[T], T)

		// Remove useless info
		to_encode -= "type"
		if(length(to_encode))
			var/json_stuff = json_encode(to_encode)
			attributes += var_to_dmm(json_stuff, "map_json_data")

	if(length(attributes) == 0)
		return

	// Trim a trailing semicolon - `var_to_dmm` always appends a semicolon,
	// so the last one will be trailing.
	if(copytext(attributes_text, length(attributes_text) - 1, 0) == "; ")
		attributes_text = copytext(attributes_text, 1, length(attributes_text) - 1)

	attributes_text = "{[jointext(attributes,"; ")]}"
	return attributes_text

/datum/dmm_suite/proc/get_model_key(which, key_length)
	var/list/key = list()
	var/working_digit = which - 1
	for(var/digit_pos in key_length to 1 step -1)
		var/place_value = round/*floor*/(working_digit / (length(letter_digits) ** (digit_pos - 1)))
		working_digit -= place_value * (length(letter_digits) ** (digit_pos - 1))
		key += letter_digits[place_value + 1]

	return jointext(key,"")

/datum/dmm_suite/proc/var_to_dmm(attr, name)
	if(istext(attr))
		// dmm_encode will strip out characters that would be capable of disrupting
		// parsing - namely, quotes and curly braces
		return "[name] = \"[dmm_encode(attr)]\""
	else if(isnum(attr) || ispath(attr))
		return "[name] = [attr]"
	else if(isicon(attr) || isfile(attr))
		if(length("[attr]") == 0)
			// The DM map reader is unable to read files that have a '' file/icon entry
			return
		return "[name] = '[attr]'"
	else
		return ""

/*
* Returns a byond list that can be passed to the "deserialize" proc
* to bring a new instance of this atom to its original state
*
* If we want to store this info, we can pass it to `json_encode` or some other
* interface that suits our fancy, to make it into an easily-handled string
*/
/datum/proc/serialize()
	var/data = list("type" = "[type]")
	return data

/*
* This is given the byond list from above, to bring this atom to the state
* described in the list.
* This will be called after `New` but before `initialize`, so linking and stuff
* would probably be handled in `initialize`
*
* Also, this should only be called by `list_to_object` in persistence.dm - at least
* with current plans - that way it can actually initialize the type from the list
*/
/datum/proc/deserialize(list/data)
	return

/atom
	// This var isn't actually used for anything, but is present so that
	// DM's map reader doesn't forfeit on reading a JSON-serialized map
	var/map_json_data

// This is so specific atoms can override these, and ignore certain ones
/atom/proc/vars_to_save()
 	return list("color","dir","icon","icon_state","name","pixel_x","pixel_y")

/atom/proc/map_important_vars()
	// A list of important things to save in the map editor
 	return list("color","dir","icon","icon_state","layer","name","pixel_x","pixel_y")

/area/map_important_vars()
	// Keep the area default icons, to keep things nice and legible
	return list("name")

// No need to save any state of an area by default
/area/vars_to_save()
	return list("name")

/atom/serialize()
	var/list/data = ..()
	for(var/thing in vars_to_save())
		if(vars[thing] != initial(vars[thing]))
			data[thing] = vars[thing]
	return data


/atom/deserialize(list/data)
	for(var/thing in vars_to_save())
		if(thing in data)
			vars[thing] = data[thing]
	..()


/*
Whoops, forgot to put documentation here.
What this does, is take a JSON string produced by running
BYOND's native `json_encode` on a list from `serialize` above, and
turns that string into a new instance of that object.
You can also easily get an instance of this string by calling "Serialize Marked Datum"
in the "Debug" tab.
If you're clever, you can do neat things with SDQL and this, though be careful -
some objects, like humans, are dependent that certain extra things are defined
in their list
*/
/proc/json_to_object(json_data, loc)
	var/data = json_decode(json_data)
	return list_to_object(data, loc)

/proc/list_to_object(list/data, loc)
	if(!islist(data))
		throw EXCEPTION("You didn't give me a list, bucko")
	if(!("type" in data))
		throw EXCEPTION("No 'type' field in the data")
	var/path = text2path(data["type"])
	if(!path)
		throw EXCEPTION("Path not found: [path]")

	var/atom/movable/thing = new path(loc)
	thing.deserialize(data)
	return thing

/proc/dmm_encode(text)
	// First, go through and nix out any of our escape sequences so we don't leave ourselves open to some escape sequence attack
	// Some coder will probably despise me for this, years down the line

	var/list/repl_chars = list("#?qt;", "#?lbr;", "#?rbr;")
	for(var/char in repl_chars)
		var/index = findtext(text, char)
		var/keylength = length(char)
		while(index)
			log_runtime(EXCEPTION("Bad string given to dmm encoder! [text]"))
			// Replace w/ underscore to prevent "&#3&#123;4;" from cheesing the radar
			// Should probably also use canon text replacing procs
			text = copytext(text, 1, index) + "_" + copytext(text, index+keylength)
			index = findtext(text, char)

	// Then, replace characters as normal
	var/list/repl_chars_2 = list("\"" = "#?qt;", "{" = "#?lbr;", "}" = "#?rbr;")
	for(var/char in repl_chars_2)
		var/index = findtext(text, char)
		var/keylength = length(char)
		while(index)
			text = copytext(text, 1, index) + repl_chars_2[char] + copytext(text, index+keylength)
			index = findtext(text, char)
	return text

/datum/buildmode_mode/save
	key = "save"

	use_corner_selection = TRUE
	var/use_json = TRUE

/datum/buildmode_mode/save/show_help(client/user)
	to_chat(user, span_notice("БЕРИ И ВЫБИРАЙ ЗОНУ ЕБЛАН!"))

/datum/buildmode_mode/save/change_settings(client/user)
	use_json = (alert("Would you like to use json (Default is \"Yes\")?",,"Yes","No") == "Yes")

/datum/buildmode_mode/save/handle_selected_area(client/user, params)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	if(left_click)
		var/map_name = input(user, "Please select a name for your map", "Buildmode", "")
		if(map_name == "")
			return
		var/map_flags = 0
		if(use_json)
			map_flags = 32 // Magic number defined in `writer.dm` that I can't use directly
			// because #defines are for some reason our coding standard
		var/our_map = GLOB.maploader.save_map(cornerA, cornerB, map_name, map_flags)
		user << ftp(our_map) // send the map they've made! Or are stealing, whatever
		to_chat(user, "Map saving complete! [our_map]")
