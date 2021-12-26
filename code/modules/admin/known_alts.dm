GLOBAL_DATUM_INIT(known_alts, /datum/known_alts, new)

/datum/known_alts
	var/list/cached_known_alts
	COOLDOWN_DECLARE(cache_cooldown)

/datum/known_alts/Topic(href, list/href_list)
	if (!check_rights(R_ADMIN))
		return

	if (!SSdbcore.Connect())
		to_chat(usr, span_warning("Couldn't connect to the database."))
		return

	var/datum/admins/holder = usr.client?.holder
	if (isnull(holder))
		return

	if (!holder.CheckAdminHref(href, href_list))
		return

	switch (href_list["action"])
		if ("add")
			var/ckey1 = input(usr, "Введите основной CKEY") as null|text
			if (!ckey1)
				return

			var/ckey2 = input(usr, "Введите CKEY мультиаккаунта") as null|text
			if (!ckey2)
				return

			ckey1 = ckey(ckey1)
			ckey2 = ckey(ckey2)

			var/datum/db_query/query_already_exists = SSdbcore.NewQuery({"
				SELECT id FROM [format_table_name("known_alts")]
				WHERE (ckey1 = :ckey1 AND ckey2 = :ckey2)
				OR (ckey1 = :ckey2 AND ckey2 = :ckey1)
			"}, list(
				"ckey1" = ckey1,
				"ckey2" = ckey2,
			))

			query_already_exists.warn_execute()

			if (query_already_exists.last_error)
				qdel(query_already_exists)
				return

			var/already_exists_row = query_already_exists.NextRow()
			qdel(query_already_exists)

			if (already_exists_row)
				alert(usr, "Эти уже есть в списке!")
				return

			var/datum/db_query/query_add_known_alt = SSdbcore.NewQuery({"
				INSERT INTO [format_table_name("known_alts")] (ckey1, ckey2, admin_ckey)
				VALUES (:ckey1, :ckey2, :admin_ckey)
			"}, list(
				"ckey1" = ckey1,
				"ckey2" = ckey2,
				"admin_ckey" = usr.ckey,
			))

			if (query_add_known_alt.warn_execute())
				var/message = "[key_name(usr)] добавляет новую связку мультиакков [ckey1] и [ckey2]."
				message_admins(message)
				log_admin_private(message)

				cached_known_alts = null
				load_known_alts()

			qdel(query_add_known_alt)
			show_panel(usr.client)

			if (!is_banned_from(ckey2, "Server"))
				var/ban_choice = alert("[ckey2] не имеет банов на сервере. Откроем банпанель?",,"Да", "Нет")
				if (ban_choice == "Да")
					holder.ban_panel(ckey2, role = "Server", duration = BAN_PANEL_PERMANENT)
		if ("delete")
			var/id = text2num(href_list["id"])
			if (!id)
				log_admin_private("[key_name(usr)] tried to delete an invalid known alt ID: [href_list["id"]]")
				return

			var/datum/db_query/query_known_alt_info = SSdbcore.NewQuery({"
				SELECT ckey1, ckey2 FROM [format_table_name("known_alts")]
				WHERE id = :id
			"}, list(
				"id" = id,
			))

			if (!query_known_alt_info.warn_execute())
				qdel(query_known_alt_info)
				return

			if (!query_known_alt_info.NextRow())
				alert("Не могу найти по данному айди: [id]")
				qdel(query_known_alt_info)
				return

			var/list/result = query_known_alt_info.item
			qdel(query_known_alt_info)

			if (alert("ТОЧНО БЛЯТЬ УДАЛЯЕМ СвЯЗЬ МЕЖДУ [result[1]] И [result[2]]?",,"ХУЯРЬ", "Нет") != "ХУЯРЬ")
				return

			var/datum/db_query/query_delete_known_alt = SSdbcore.NewQuery({"
				DELETE FROM [format_table_name("known_alts")]
				WHERE id = :id
			"}, list(
				"id" = id,
			))

			if (query_delete_known_alt.warn_execute())
				var/message = "[key_name(usr)] удаляет связь между мультиакками [result[1]] и [result[2]]."
				message_admins(message)
				log_admin_private(message)

				cached_known_alts = null
				load_known_alts()

			qdel(query_delete_known_alt)
			show_panel(usr.client)

/// Returns the list of known alts, will return an empty list if the DB could not be connected to.
/// This proc can block.
/datum/known_alts/proc/load_known_alts()
	if (!isnull(cached_known_alts) && !COOLDOWN_FINISHED(src, cache_cooldown))
		return cached_known_alts

	if (!SSdbcore.Connect())
		return cached_known_alts || list()

	var/datum/db_query/query_known_alts = SSdbcore.NewQuery("SELECT id, ckey1, ckey2, admin_ckey FROM [format_table_name("known_alts")] ORDER BY id DESC")
	query_known_alts.warn_execute()

	if (query_known_alts.last_error)
		qdel(query_known_alts)
		return cached_known_alts || list()

	cached_known_alts = list()

	while (query_known_alts.NextRow())
		cached_known_alts += list(list(
			query_known_alts.item[2],
			query_known_alts.item[3],
			query_known_alts.item[4],

			// The ID
			query_known_alts.item[1],
		))

	COOLDOWN_START(src, cache_cooldown, 10 SECONDS)
	qdel(query_known_alts)

	return cached_known_alts

/datum/known_alts/proc/show_panel(client/client)
	if (!check_rights_for(client, R_ADMIN))
		return

	if (!SSdbcore.Connect())
		to_chat(usr, span_warning("Couldn't connect to the database."))
		return

	var/list/known_alts_html = list()

	for (var/known_alt in load_known_alts())
		known_alts_html += "<a href='?src=[REF(src)];[HrefToken()];action=delete;id=[known_alt[4]]'>\[-\] Удалить</a> <b>[known_alt[1]]</b> мультиакк <b>[known_alt[2]]</b> (добавлен <b>[known_alt[3]]</b>)."

	var/html = {"
		<head>
			<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
			<title>Мультиакки</title>
		</head>

		<body>
			<p>Не стоит доверять этой информации...</p>

			<h2>Мультиакки:</h2> <a href='?src=[REF(src)];[HrefToken()];action=add'>\[+\] Добавить</a><hr>

			[known_alts_html.Join("<br />")]
		</body>
	"}

	client << browse(html, "window=known_alts;size=700x400")

/datum/admins/proc/known_alts_panel()
	set name = "Мультиакки"
	set category = "Адм"

	GLOB.known_alts.show_panel(usr.client)
