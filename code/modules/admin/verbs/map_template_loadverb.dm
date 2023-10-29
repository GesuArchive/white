/client/proc/map_template_load()
	set category = "Дбг.Маппинг"
	set name = "Map template - Place"

	var/datum/map_template/template

	var/map = tgui_input_list(src, "Choose a Map Template to place at your CURRENT LOCATION", "Place Map Template", sort_list(SSmapping.map_templates))
	if(!map)
		return
	template = SSmapping.map_templates[map]

	var/turf/T = get_turf(mob)
	if(!T)
		return

	var/list/preview = list()
	//for(var/S in template.get_affected_turfs(T,centered = TRUE))
	var/center
	var/centeralert = tgui_alert(usr,"Center Template.","Template Centering",list("Yes","No"))
	switch(centeralert)
		if("Yes")
			center = TRUE
		if("No")
			center = FALSE
		else
			return
	for(var/turf/place_on as anything in template.get_affected_turfs(T,centered = center))
		var/image/item = image('icons/turf/overlays.dmi', place_on,"greenOverlay")
		SET_PLANE(item, ABOVE_LIGHTING_PLANE, place_on)
		preview += item
	images += preview

	if(tgui_alert(usr,"Confirm location.","Template Confirm",list("Yes","No")) == "Yes")
		if(template.load(T, centered = center))
			var/affected = template.get_affected_turfs(T, centered = center)
			for(var/AT in affected)
				for(var/obj/docking_port/mobile/P in AT)
					if(istype(P, /obj/docking_port/mobile))
						template.post_load(P)
						break

			message_admins(span_adminnotice("[key_name_admin(src)] has placed a map template ([template.name]) at [ADMIN_COORDJMP(T)]"))
		else
			to_chat(src, "Failed to place map")
	images -= preview

/client/proc/map_template_upload()
	set category = "Дбг.Маппинг"
	set name = "Map Template - Upload"

	var/map = input(src, "Choose a Map Template to upload to template storage","Upload Map Template") as null|file
	if(!map)
		return
	if(copytext("[map]", -4) != ".dmm")//4 == length(".dmm")
		to_chat(src, span_warning("Filename must end in '.dmm': [map]"))
		return
	var/datum/map_template/M
	var/type
	switch(tgui_alert(usr, "What kind of map is this?", "Map type", list("Normal", "Shuttle", "Cancel")))
		if("Normal")
			type = "Normal"
			M = new /datum/map_template(map, "[map]", TRUE)
		if("Shuttle")
			type = "Shuttle"
			M = new /datum/map_template/shuttle(map, "[map]", TRUE)
		else
			return
	if(!M.cached_map)
		to_chat(src, span_warning("Map template '[map]' failed to parse properly."))
		return

	var/datum/map_report/report = M.cached_map.check_for_errors()
	var/report_link
	if(report)
		report.show_to(src)
		report_link = " - <a href='?src=[REF(report)];[HrefToken(TRUE)];show=1'>validation report</a>"
		to_chat(src, span_warning("Map template '[map]' <a href='?src=[REF(report)];[HrefToken()];show=1'>failed validation</a>."))
		if(report.loadable)
			var/response = tgui_alert(usr, "The map failed validation, would you like to load it anyways?", "Map Errors", list("Cancel", "Upload Anyways"))
			if(response != "Upload Anyways")
				return
		else
			tgui_alert(usr, "The map failed validation and cannot be loaded.", "Map Errors", list("Oh Darn"))
			return

	switch(type)
		if("Normal")
			SSmapping.map_templates[M.name] = M
		if("Shuttle")
			var/datum/map_template/shuttle/S = M
			SSmapping.shuttle_templates[S.shuttle_id] = S

	message_admins(span_adminnotice("[key_name_admin(src)] has uploaded a map template '[map]' ([M.width]x[M.height])[report_link]."))
	to_chat(src, span_notice("Map template '[map]' ready to place ([M.width]x[M.height])"))
