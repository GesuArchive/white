//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = "Пиши то, что хочешь узнать. Можешь ничего не писать, тогда откроется главная страница."
	set category = null
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl)
		if(query)
			var/output = wikiurl + "/index.php?title=Special%3ASearch&profile=default&search=" + query
			src << link(output)
		else if (query != null)
			src << link(wikiurl)
	else
		to_chat(src, span_danger("The wiki URL is not set in the server configuration."))
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set category = null
	var/forumurl = CONFIG_GET(string/forumurl)
	if(forumurl)
		if(tgui_alert(src, "This will open the forum in your browser. Are you sure?",, list("Yes","No"))!="Yes")
			return
		src << link(forumurl)
	else
		to_chat(src, span_danger("The forum URL is not set in the server configuration."))
	return

/client/verb/donate()
	set name = "donate"
	set desc = "Задонатить, хех."
	set category = null
	src << link("https://hub.station13.ru/pp/")
	return

/client/verb/rules()
	set name = "rules"
	set desc = "Show Server Rules."
	set category = null
	var/rulesurl = CONFIG_GET(string/rulesurl)
	if(rulesurl)
		if(tgui_alert(src, "This will open the rules in your browser. Are you sure?",, list("Yes","No"))!="Yes")
			return
		src << link(rulesurl)
	else
		to_chat(src, span_danger("The rules URL is not set in the server configuration."))
	return

/client/verb/github()
	set name = "github"
	set desc = "Visit Github"
	set category = null
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		if(tgui_alert(src, "This will open the Github repository in your browser. Are you sure?",, list("Yes","No"))!="Yes")
			return
		src << link(githuburl)
	else
		to_chat(src, span_danger("The Github URL is not set in the server configuration."))
	return

/client/verb/reportissue()
	set name = "report-issue"
	set desc = "Report an issue"
	set category = null
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		var/message = "This will open the Github issue reporter in your browser. Are you sure?"
		if(GLOB.revdata.testmerge.len)
			message += "<br>The following experimental changes are active and are probably the cause of any new or sudden issues you may experience. If possible, please try to find a specific thread for your issue instead of posting to the general issue tracker:<br>"
			message += GLOB.revdata.GetTestMergeInfo(FALSE)
		// We still use tgalert here because some people were concerned that if someone wanted to report that tgui wasn't working
		// then the report issue button being tgui-based would be problematic.
		if(tgalert(src, message, "Report Issue","Yes","No")!="Yes")
			return

		// Keep a static version of the template to avoid reading file
		var/static/issue_template = file2text(".github/ISSUE_TEMPLATE/bug_report.md")

		// Get a local copy of the template for modification
		var/local_template = issue_template

		// Remove comment header
		var/content_start = findtext(local_template, "<")
		if(content_start)
			local_template = copytext(local_template, content_start)

		// Insert round
		if(GLOB.round_id)
			local_template = replacetext(local_template, "## Round ID:\n", "## Round ID:\n[GLOB.round_id]")

		// Insert testmerges
		if(GLOB.revdata.testmerge.len)
			var/list/all_tms = list()
			for(var/entry in GLOB.revdata.testmerge)
				var/datum/tgs_revision_information/test_merge/tm = entry
				all_tms += "- \[[tm.title]\]([githuburl]/pull/[tm.number])"
			var/all_tms_joined = all_tms.Join("\n") // for some reason this can't go in the []
			local_template = replacetext(local_template, "## Testmerges:\n", "## Testmerges:\n[all_tms_joined]")

		var/url_params = "Reporting client version: [byond_version].[byond_build]\n\n[local_template]"
		DIRECT_OUTPUT(src, link("[githuburl]/issues/new?body=[url_encode(url_params)]"))
	else
		to_chat(src, span_danger("The Github URL is not set in the server configuration."))
	return

/client/verb/changelog()
	set name = "📘 Последние изменения /tg/"
	set category = null
	var/datum/asset/simple/namespaced/changelog = get_asset_datum(/datum/asset/simple/namespaced/changelog)
	changelog.send(src)
	src << browse(changelog.get_htmlloader("changelog.html"), "window=changes;size=675x650")
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		winset(src, "infowindow.changelog", "font-style=;")
