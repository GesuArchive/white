#define DMM_SUITE_VERSION 2
#define DMM_IGNORE_AREAS 1
#define DMM_IGNORE_TURFS 2
#define DMM_IGNORE_OBJS 4
#define DMM_IGNORE_NPCS 8
#define DMM_IGNORE_PLAYERS 16
#define DMM_IGNORE_MOBS 24

/datum/dmm_suite/proc/text2list(splitString, delimiter)
	#ifdef DEBUG
	ASSERT(istext(splitString))
	ASSERT(istext(delimiter))
	ASSERT(delimiter)
	#endif
	var/delimiterLength = length(delimiter)
	var/pos = findtextEx(splitString, delimiter)
	var/start = 1
	. = list()
	while(pos > 0)
		. += copytext(splitString, start, pos)
		start = pos + delimiterLength
		pos = findtextEx(splitString, delimiter, start)
	. += copytext(splitString, start)

/datum/dmm_suite/proc/list2text(list/l, d = "")
	#ifdef DEBUG
	ASSERT(istype(l))
	#endif
	if(d)
		if(l.len <= 10)
			return "[(l.len >= 1) ? l[1] : ""][(l.len > 1) ? d : ""][(l.len >= 2) ? l[2] : ""][(l.len > 2) ? d : ""][(l.len >= 3) ? l[3] : ""][(l.len > 3) ? d : ""][(l.len >= 4) ? l[4] : ""][(l.len > 4) ? d : ""][(l.len >= 5) ? l[5] : ""][(l.len > 5) ? d : ""][(l.len >= 6) ? l[6] : ""][(l.len > 6) ? d : ""][(l.len >= 7) ? l[7] : ""][(l.len > 7) ? d : ""][(l.len >= 8) ? l[8] : ""][(l.len > 8) ? d : ""][(l.len >= 9) ? l[9] : ""][(l.len > 9) ? d : ""][(l.len >= 10) ? l[10] : ""][(l.len > 10) ? d : ""]"
		else if(l.len <= 20)
			var/list/remainder = l.Copy(11)
			return "[l[1]][d][l[2]][d][l[3]][d][l[4]][d][l[5]][d][l[6]][d][l[7]][d][l[8]][d][l[9]][d][l[10]][d][list2text(remainder, d)]"
		else if(l.len <= 40)
			var/list/remainder = l.Copy(21)
			return "[l[1]][d][l[2]][d][l[3]][d][l[4]][d][l[5]][d][l[6]][d][l[7]][d][l[8]][d][l[9]][d][l[10]][d][l[11]][d][l[12]][d][l[13]][d][l[14]][d][l[15]][d][l[16]][d][l[17]][d][l[18]][d][l[19]][d][l[20]][d][list2text(remainder, d)]"
		else if(l.len <= 80)
			var/list/remainder = l.Copy(41)
			return "[l[1]][d][l[2]][d][l[3]][d][l[4]][d][l[5]][d][l[6]][d][l[7]][d][l[8]][d][l[9]][d][l[10]][d][l[11]][d][l[12]][d][l[13]][d][l[14]][d][l[15]][d][l[16]][d][l[17]][d][l[18]][d][l[19]][d][l[20]][d][l[21]][d][l[22]][d][l[23]][d][l[24]][d][l[25]][d][l[26]][d][l[27]][d][l[28]][d][l[29]][d][l[30]][d][l[31]][d][l[32]][d][l[33]][d][l[34]][d][l[35]][d][l[36]][d][l[37]][d][l[38]][d][l[39]][d][l[40]][d][list2text(remainder, d)]"
		else if(l.len <= 160)
			var/list/remainder = l.Copy(81)
			return "[l[1]][d][l[2]][d][l[3]][d][l[4]][d][l[5]][d][l[6]][d][l[7]][d][l[8]][d][l[9]][d][l[10]][d][l[11]][d][l[12]][d][l[13]][d][l[14]][d][l[15]][d][l[16]][d][l[17]][d][l[18]][d][l[19]][d][l[20]][d][l[21]][d][l[22]][d][l[23]][d][l[24]][d][l[25]][d][l[26]][d][l[27]][d][l[28]][d][l[29]][d][l[30]][d][l[31]][d][l[32]][d][l[33]][d][l[34]][d][l[35]][d][l[36]][d][l[37]][d][l[38]][d][l[39]][d][l[40]][d][l[41]][d][l[42]][d][l[43]][d][l[44]][d][l[45]][d][l[46]][d][l[47]][d][l[48]][d][l[49]][d][l[50]][d][l[51]][d][l[52]][d][l[53]][d][l[54]][d][l[55]][d][l[56]][d][l[57]][d][l[58]][d][l[59]][d][l[60]][d][l[61]][d][l[62]][d][l[63]][d][l[64]][d][l[65]][d][l[66]][d][l[67]][d][l[68]][d][l[69]][d][l[70]][d][l[71]][d][l[72]][d][l[73]][d][l[74]][d][l[75]][d][l[76]][d][l[77]][d][l[78]][d][l[79]][d][l[80]][d][list2text(remainder, d)]"
		else
			var/list/remainder = l.Copy(161)
			return "[l[1]][d][l[2]][d][l[3]][d][l[4]][d][l[5]][d][l[6]][d][l[7]][d][l[8]][d][l[9]][d][l[10]][d][l[11]][d][l[12]][d][l[13]][d][l[14]][d][l[15]][d][l[16]][d][l[17]][d][l[18]][d][l[19]][d][l[20]][d][l[21]][d][l[22]][d][l[23]][d][l[24]][d][l[25]][d][l[26]][d][l[27]][d][l[28]][d][l[29]][d][l[30]][d][l[31]][d][l[32]][d][l[33]][d][l[34]][d][l[35]][d][l[36]][d][l[37]][d][l[38]][d][l[39]][d][l[40]][d][l[41]][d][l[42]][d][l[43]][d][l[44]][d][l[45]][d][l[46]][d][l[47]][d][l[48]][d][l[49]][d][l[50]][d][l[51]][d][l[52]][d][l[53]][d][l[54]][d][l[55]][d][l[56]][d][l[57]][d][l[58]][d][l[59]][d][l[60]][d][l[61]][d][l[62]][d][l[63]][d][l[64]][d][l[65]][d][l[66]][d][l[67]][d][l[68]][d][l[69]][d][l[70]][d][l[71]][d][l[72]][d][l[73]][d][l[74]][d][l[75]][d][l[76]][d][l[77]][d][l[78]][d][l[79]][d][l[80]][d][l[81]][d][l[82]][d][l[83]][d][l[84]][d][l[85]][d][l[86]][d][l[87]][d][l[88]][d][l[89]][d][l[90]][d][l[91]][d][l[92]][d][l[93]][d][l[94]][d][l[95]][d][l[96]][d][l[97]][d][l[98]][d][l[99]][d][l[100]][d][l[101]][d][l[102]][d][l[103]][d][l[104]][d][l[105]][d][l[106]][d][l[107]][d][l[108]][d][l[109]][d][l[110]][d][l[111]][d][l[112]][d][l[113]][d][l[114]][d][l[115]][d][l[116]][d][l[117]][d][l[118]][d][l[119]][d][l[120]][d][l[121]][d][l[122]][d][l[123]][d][l[124]][d][l[125]][d][l[126]][d][l[127]][d][l[128]][d][l[129]][d][l[130]][d][l[131]][d][l[132]][d][l[133]][d][l[134]][d][l[135]][d][l[136]][d][l[137]][d][l[138]][d][l[139]][d][l[140]][d][l[141]][d][l[142]][d][l[143]][d][l[144]][d][l[145]][d][l[146]][d][l[147]][d][l[148]][d][l[149]][d][l[150]][d][l[151]][d][l[152]][d][l[153]][d][l[154]][d][l[155]][d][l[156]][d][l[157]][d][l[158]][d][l[159]][d][l[160]][d][list2text(remainder, d)]"
	else
		if(l.len <= 10)
			return "[(l.len >= 1) ? l[1] : ""][(l.len >= 2) ? l[2] : ""][(l.len >= 3) ? l[3] : ""][(l.len >= 4) ? l[4] : ""][(l.len >= 5) ? l[5] : ""][(l.len >= 6) ? l[6] : ""][(l.len >= 7) ? l[7] : ""][(l.len >= 8) ? l[8] : ""][(l.len >= 9) ? l[9] : ""][(l.len >= 10) ? l[10] : ""]"
		else if(l.len <= 20)
			var/list/remainder = l.Copy(11)
			return "[l[1]][l[2]][l[3]][l[4]][l[5]][l[6]][l[7]][l[8]][l[9]][l[10]][list2text(remainder)]"
		else if(l.len <= 40)
			var/list/remainder = l.Copy(21)
			return "[l[1]][l[2]][l[3]][l[4]][l[5]][l[6]][l[7]][l[8]][l[9]][l[10]][l[11]][l[12]][l[13]][l[14]][l[15]][l[16]][l[17]][l[18]][l[19]][l[20]][list2text(remainder)]"
		else if(l.len <= 80)
			var/list/remainder = l.Copy(41)
			return "[l[1]][l[2]][l[3]][l[4]][l[5]][l[6]][l[7]][l[8]][l[9]][l[10]][l[11]][l[12]][l[13]][l[14]][l[15]][l[16]][l[17]][l[18]][l[19]][l[20]][l[21]][l[22]][l[23]][l[24]][l[25]][l[26]][l[27]][l[28]][l[29]][l[30]][l[31]][l[32]][l[33]][l[34]][l[35]][l[36]][l[37]][l[38]][l[39]][l[40]][list2text(remainder)]"
		else if(l.len <= 160)
			var/list/remainder = l.Copy(81)
			return "[l[1]][l[2]][l[3]][l[4]][l[5]][l[6]][l[7]][l[8]][l[9]][l[10]][l[11]][l[12]][l[13]][l[14]][l[15]][l[16]][l[17]][l[18]][l[19]][l[20]][l[21]][l[22]][l[23]][l[24]][l[25]][l[26]][l[27]][l[28]][l[29]][l[30]][l[31]][l[32]][l[33]][l[34]][l[35]][l[36]][l[37]][l[38]][l[39]][l[40]][l[41]][l[42]][l[43]][l[44]][l[45]][l[46]][l[47]][l[48]][l[49]][l[50]][l[51]][l[52]][l[53]][l[54]][l[55]][l[56]][l[57]][l[58]][l[59]][l[60]][l[61]][l[62]][l[63]][l[64]][l[65]][l[66]][l[67]][l[68]][l[69]][l[70]][l[71]][l[72]][l[73]][l[74]][l[75]][l[76]][l[77]][l[78]][l[79]][l[80]][list2text(remainder)]"
		else
			var/list/remainder = l.Copy(161)
			return "[l[1]][l[2]][l[3]][l[4]][l[5]][l[6]][l[7]][l[8]][l[9]][l[10]][l[11]][l[12]][l[13]][l[14]][l[15]][l[16]][l[17]][l[18]][l[19]][l[20]][l[21]][l[22]][l[23]][l[24]][l[25]][l[26]][l[27]][l[28]][l[29]][l[30]][l[31]][l[32]][l[33]][l[34]][l[35]][l[36]][l[37]][l[38]][l[39]][l[40]][l[41]][l[42]][l[43]][l[44]][l[45]][l[46]][l[47]][l[48]][l[49]][l[50]][l[51]][l[52]][l[53]][l[54]][l[55]][l[56]][l[57]][l[58]][l[59]][l[60]][l[61]][l[62]][l[63]][l[64]][l[65]][l[66]][l[67]][l[68]][l[69]][l[70]][l[71]][l[72]][l[73]][l[74]][l[75]][l[76]][l[77]][l[78]][l[79]][l[80]][l[81]][l[82]][l[83]][l[84]][l[85]][l[86]][l[87]][l[88]][l[89]][l[90]][l[91]][l[92]][l[93]][l[94]][l[95]][l[96]][l[97]][l[98]][l[99]][l[100]][l[101]][l[102]][l[103]][l[104]][l[105]][l[106]][l[107]][l[108]][l[109]][l[110]][l[111]][l[112]][l[113]][l[114]][l[115]][l[116]][l[117]][l[118]][l[119]][l[120]][l[121]][l[122]][l[123]][l[124]][l[125]][l[126]][l[127]][l[128]][l[129]][l[130]][l[131]][l[132]][l[133]][l[134]][l[135]][l[136]][l[137]][l[138]][l[139]][l[140]][l[141]][l[142]][l[143]][l[144]][l[145]][l[146]][l[147]][l[148]][l[149]][l[150]][l[151]][l[152]][l[153]][l[154]][l[155]][l[156]][l[157]][l[158]][l[159]][l[160]][list2text(remainder)]"

/datum/dmm_suite/proc/write_map(turf/turf1, turf/turf2, flags as num)
	//Check for valid turfs.
	if(!isturf(turf1) || !isturf(turf2))
		CRASH("Invalid arguments supplied to proc write_map, arguments were not turfs.")
	var/turf/lowCorner  = locate(min(turf1.x,turf2.x), min(turf1.y,turf2.y), min(turf1.z,turf2.z))
	var/turf/highCorner = locate(max(turf1.x,turf2.x), max(turf1.y,turf2.y), max(turf1.z,turf2.z))
	var/startZ = lowCorner.z
	var/startY = lowCorner.y
	var/startX = lowCorner.x
	var/endZ   = highCorner.z
	var/endY   = highCorner.y
	var/endX   = highCorner.x
	var/depth  = (endZ - startZ)+1 // Include first tile, x = 1
	var/height = (endY - startY)+1
	var/width  = (endX - startX)+1
	// Identify all unique grid cells
	// Store template number for each grid cells
	var/list/templates = list()
	var/list/templateBuffer = new(width*height*depth)
	for(var/posZ = 0 to depth-1)
		for(var/posY = 0 to height-1)
			for(var/posX = 0 to width-1)
				var/turf/saveTurf = locate(startX+posX, startY+posY, startZ+posZ)
				var/testTemplate = makeTemplate(saveTurf, flags)
				var/templateNumber = templates.Find(testTemplate)
				if(!templateNumber)
					templates.Add(testTemplate)
					templateNumber = templates.len
				var/compoundIndex = 1 + (posX) + (posY*width) + (posZ*width*height)
				templateBuffer[compoundIndex] = templateNumber
	// Compile List of Keys mapped to Models
	return writeDimensions(startX, startY, startZ, width, height, depth, templates, templateBuffer)

/datum/dmm_suite/proc/write_cube(startX as num, startY as num, startZ as num, width as num, height as num, depth as num, flags as num)
	// Ensure that cube is within boundries of current map
	if(
		min(startX, startY, startZ) < 1 || \
		startX + width -1 > world.maxx  || \
		startY + height-1 > world.maxy  || \
		startZ + depth -1 > world.maxz  || \
		startX > world.maxx				|| \
		startY > world.maxy				|| \
		startZ > world.maxz				   \
	) CRASH("Dimensions outside valid range")
	// Identify all unique grid cells
	// Store template number for each grid cells
	var/list/templates = list()
	var/list/templateBuffer = new(width*height*depth)
	for(var/posZ = 0 to depth-1)
		for(var/posY = 0 to height-1)
			for(var/posX = 0 to width-1)
				var/turf/saveTurf = locate(startX+posX, startY+posY, startZ+posZ)
				var/testTemplate = makeTemplate(saveTurf, flags)
				var/templateNumber = templates.Find(testTemplate)
				if(!templateNumber)
					templates.Add(testTemplate)
					templateNumber = templates.len
				var/compoundIndex = 1 + (posX) + (posY*width) + (posZ*width*height)
				templateBuffer[compoundIndex] = templateNumber
	// Compile List of Keys mapped to Models
	return writeDimensions(startX, startY, startZ, width, height, depth, templates, templateBuffer)

/datum/dmm_suite/proc/write_area(area/save_area, flags as num)
	// Cancel out if the area isn't on the map
	if(!(locate(/turf) in save_area.contents))
		return FALSE
	//
	var/startZ = save_area.z
	var/startY = save_area.y
	var/startX = save_area.x
	var/endZ = 0
	var/endY = 0
	var/endX = 0
	for(var/turf/containedTurf in save_area.contents)
		if(		containedTurf.z >   endZ)   endZ = containedTurf.z
		else if(containedTurf.z < startZ) startZ = containedTurf.z
		if( 	containedTurf.y >   endY)   endY = containedTurf.y
		else if(containedTurf.y < startY) startY = containedTurf.y
		if( 	containedTurf.x >   endX)   endX = containedTurf.x
		else if(containedTurf.x < startX) startX = containedTurf.x
	var/depth  = (endZ - startZ)+1 // Include first tile, x = 1
	var/height = (endY - startY)+1
	var/width  = (endX - startX)+1
	// Create empty cell model
	var/emptyCellModel = "[/turf/open/space/basic],[/area/space]"
	// Identify all unique grid cells
	// Store template number for each grid cells
	var/list/templates = list("-", emptyCellModel)
	var/emptyCellIndex = templates.Find(emptyCellModel) // Magic numbers already bit me here once. Don't be tempted!
	var/list/templateBuffer = new(width*height*depth)
	for(var/posZ = 0 to depth-1)
		for(var/posY = 0 to height-1)
			for(var/posX = 0 to width-1)
				var/turf/saveTurf = locate(startX+posX, startY+posY, startZ+posZ)
				// Skip out if turf isn't in save area
				if(saveTurf.loc != save_area)
					var/compoundIndex = 1 + (posX) + (posY*width) + (posZ*width*height)
					templateBuffer[compoundIndex] = emptyCellIndex
					continue
				//
				var/testTemplate = makeTemplate(saveTurf, flags)
				var/templateNumber = templates.Find(testTemplate)
				if(!templateNumber)
					templates.Add(testTemplate)
					templateNumber = templates.len
				var/compoundIndex = 1 + (posX) + (posY*width) + (posZ*width*height)
				templateBuffer[compoundIndex] = templateNumber
	templateBuffer[1] = 1
	// Compile List of Keys mapped to Models
	return writeDimensions(startX, startY, startZ, width, height, depth, templates, templateBuffer)

/datum/dmm_suite/proc/writeDimensions(startX, startY, startZ, width, height, depth, list/templates, list/templateBuffer)
	var/dmmText = ""
	// Compile List of Keys mapped to Models
	var/keyLength = round/*floor*/(
		1 + log(
			letterDigits.len, max(1, templates.len-1)
		)
	)
	var/list/keys[templates.len]
	for(var/keyPos = 1 to templates.len)
		keys[keyPos] = computeKeyIndex(keyPos, keyLength)
		dmmText += {""[keys[keyPos]]" = ([templates[keyPos]])\n"}
	// Compile Level Grid Text
	for(var/posZ = 0 to depth-1)
		if(posZ)
			dmmText += "\n"
		dmmText += "\n(1,1,[posZ+1]) = {\"\n"
		var/list/joinGrid = list() // Joining a list is faster than generating strings
		for(var/posY = height-1 to 0 step -1)
			var/list/joinLine = list()
			for(var/posX = 0 to width-1)
				var/compoundIndex = 1 + (posX) + (posY*width) + (posZ*width*height)
				var/keyNumber = templateBuffer[compoundIndex]
				var/tempKey = keys[keyNumber]
				joinLine.Add(tempKey)
				//dmmText += "[tempKey]"
				sleep(-1)
			joinGrid.Add(list2text(joinLine))
			sleep(-1)
		dmmText += {"[list2text(joinGrid, "\n")]\n\"}"}
		sleep(-1)
		return dmmText

/datum/dmm_suite/proc/makeTemplate(turf/model as turf, flags as num)
	// Add Obj Templates
	var/objTemplate = ""
	if(!(flags & DMM_IGNORE_OBJS))
		for(var/obj/O in model.contents)
			if(O.loc != model) continue
			objTemplate += "[O.type][checkAttributes(O)],"
	// Add Mob
	var/mobTemplate = ""
	for(var/mob/M in model.contents)
		if(M.loc != model) continue
		if(M.client)
			if(!(flags & DMM_IGNORE_PLAYERS))
				mobTemplate += "[M.type][checkAttributes(M)],"
		else
			if(!(flags & DMM_IGNORE_NPCS))
				mobTemplate += "[M.type][checkAttributes(M)],"
	// Add Turf Template
	var/turfTemplate = ""
	if(!(flags & DMM_IGNORE_TURFS))
		for(var/appearance in model.underlays)
			var/mutable_appearance/underlay = new(appearance)
			turfTemplate = "[/obj/effect/turf_decal][checkAttributes(underlay)],[turfTemplate]"
		turfTemplate += "[model.type][checkAttributes(model)],"
	else
		turfTemplate = "[/turf/open/space/basic],"
	// Add Area Template
	var/areaTemplate = ""
	if(!(flags & DMM_IGNORE_AREAS))
		var/area/mArea = model.loc
		areaTemplate = "[mArea.type][checkAttributes(mArea)]"
	else
		areaTemplate = "[/area/space]"
	//
	var/template = "[objTemplate][mobTemplate][turfTemplate][areaTemplate]"
	return template

/datum/dmm_suite/proc/checkAttributes(atom/A, underlay)
	var/attributesText = ""
	var/saving = FALSE
	for(var/V in A.vars)
		sleep(-1)
		// If the Variable isn't changed, or is marked as non-saving
		if(!issaved(A.vars[V]) || A.vars[V] == initial(A.vars[V]))
			continue
		// Format different types of values
		if(istext(A.vars[V])) // Text
			if(saving) attributesText += "; "
			attributesText += {"[V] = "[A.vars[V]]""}
		else if(isnum(A.vars[V]) || ispath(A.vars[V])) // Numbers & Type Paths
			if(saving) attributesText += "; "
			attributesText += {"[V] = [A.vars[V]]"}
		else if(isicon(A.vars[V]) || isfile(A.vars[V])) // Icons & Files
			var/filePath = "[A.vars[V]]"
			if(!length(filePath)) continue // Bail on dynamic icons
			if(saving) attributesText += "; "
			attributesText += {"[V] = '[A.vars[V]]'"}
		else // Otherwise, Bail
			continue
		// Add to Attributes
		saving = TRUE
	//
	if(!saving)
		return
	return "{[attributesText]}"

/datum/dmm_suite/proc/computeKeyIndex(keyIndex, keyLength)
	var/key = ""
	var/workingDigit = keyIndex-1
	for(var/digitPos = keyLength to 1 step -1)
		var/placeValue = round(workingDigit/(letterDigits.len**(digitPos-1)))
		workingDigit -= placeValue * (letterDigits.len**(digitPos-1))
		key += letterDigits[placeValue+1]
	return key

/datum/dmm_suite/var/list/letterDigits = list(
	"a","b","c","d","e",
	"f","g","h","i","j",
	"k","l","m","n","o",
	"p","q","r","s","t",
	"u","v","w","x","y",
	"z",
	"A","B","C","D","E",
	"F","G","H","I","J",
	"K","L","M","N","O",
	"P","Q","R","S","T",
	"U","V","W","X","Y",
	"Z"
	)

/client/proc/write_map(zlevel_to as num)
	set category = "Маппинг"
	set name = "? WRITE MAP"
	var/datum/dmm_suite/suite = new()
	to_chat(world, span_boldannounce("ВНИМАНИЕ! Начато сохранение мира. Это займёт примерно минуту."))
	var/map_text = suite.write_map(
		locate(1, 1, zlevel_to),
		locate(world.maxx, world.maxy, zlevel_to),
		DMM_IGNORE_PLAYERS
	)
	usr << browse("<head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'></head>	<pre>[map_text]</pre>", "window=assmap")
	to_chat(world, span_boldannounce("Мир сохранён, приятной игры!"))
