//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "Вики"
	set desc = "Пиши то, что хочешь узнать. Можешь ничего не писать, тогда откроется главная страница."
	set category = "Особенное"
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

/client/verb/rules()
	set name = "Правила"
	set desc = "Show Server Rules."
	set category = "Особенное"
	var/rulesurl = CONFIG_GET(string/rulesurl)
	if(rulesurl)
		if(tgui_alert(src, "This will open the rules in your browser. Are you sure?",, list("Yes","No"))!="Yes")
			return
		src << link(rulesurl)
	else
		to_chat(src, span_danger("The rules URL is not set in the server configuration."))
	return

/client/verb/github()
	set name = "GitHub"
	set desc = "Visit Github"
	set category = "Особенное"
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		if(tgui_alert(src, "This will open the Github repository in your browser. Are you sure?",, list("Yes","No"))!="Yes")
			return
		src << link(githuburl)
	else
		to_chat(src, span_danger("The Github URL is not set in the server configuration."))
	return
