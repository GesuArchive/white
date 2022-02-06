/datum/autowiki/donations
	page = "Template:Autowiki/Content/Donations"

/datum/autowiki/donations/generate()
	var/output = ""

	for(var/category in GLOB.donations_list)
		var/list/catsan = GLOB.donations_list[category]
		output += "\n\n" + include_template("Autowiki/DonationsEntry", list(
			"name" = escape_value(category),
			"items" = generate_items(catsan),
		))

	return output

/datum/autowiki/donations/proc/generate_items(list/catsan)
	var/output = ""

	for(var/item in 1 to catsan.len)
		var/datum/donate_info/dnt = catsan[item]

		var/filename = SANITIZE_FILENAME(escape_value(format_text(dnt.name)))

		output += "\n\n" + include_template("Autowiki/DonationsEntryItem", list(
			"name" = escape_value(dnt.name),
			"cost" = dnt.cost,
			"icon" = escape_value(filename),
		))

		var/icon/icon_to_upload = GetIconForProductWiki(dnt)

		if(icon_to_upload)
			upload_icon(icon_to_upload, filename)

		qdel(dnt)

	return output

/proc/GetIconForProductWiki(datum/donate_info/P)
	if(GLOB.donate_icon_cache[P.path_to])
		return GLOB.donate_icon_cache[P.path_to]
	GLOB.donate_icon_cache[P.path_to] = getFlatIcon(path2image(P.path_to), no_anim = TRUE)
	return GLOB.donate_icon_cache[P.path_to]
