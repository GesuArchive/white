// Код для репорта багов прямо в гитхаб, чудеса?

GLOBAL_LIST_INIT(bug_downs, load_bug_downs())

/client/proc/add_bug_down()
	set name = "Запретить репортить"
	set category = "Особенное"

	if(!check_rights(R_PERMISSIONS))
		return

	var/keybug = input("retard", "delet") as text|null

	if(!keybug)
		return

	GLOB.bug_downs += ckey(keybug)

	var/json_file = file("data/bug_downs.json")
	var/list/file_data = GLOB.bug_downs

	message_admins("[key_name_admin(usr)] записывает в непригодных [keybug].")

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/proc/load_bug_downs()
	var/json_file = file("data/bug_downs.json")
	if(!fexists(json_file))
		return list()
	return list(json_decode(file2text(json_file)))

/client/verb/report_a_bug()
	set name = "Отрепортить баг"
	set category = "Особенное"

	if(ckey in GLOB.bug_downs)
		to_chat(src, span_notice("Отправлено!"))
		return

	var/message = input("Опишите вашу проблему. (минимум 140 символов, координаты, ваш сикей и ID раунда отправляются автоматически)", "Обнаружен баг?") as text|null

	if(!message || length_char(message) < 140)
		to_chat(src, span_warning("Минимум 140 символов!"))
		return

	var/message_header = input("Придумайте заголовок. (минимум 16 символов)", "Обнаружен баг!") as text|null

	if(!message_header || length_char(message_header) < 16)
		to_chat(src, span_warning("Минимум 16 символов!"))
		return

	var/list/what_we_should_say = list("title" = "\[BUG\] [message_header]", "body" = "[message]\nKey: [key]\nLoc: [AREACOORD(usr)]\nID: [GLOB.round_id]", "labels" = "🐛 баг")

	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, "https://api.github.com/repos/white/issues", json_encode(what_we_should_say), list("accept" = "application/vnd.github.v3+json", "Authorization" = "token [CONFIG_GET(string/github_auth_key)]"), null)
	request.begin_async()
	UNTIL(request.is_complete() || !src)
	if (!src)
		return
	var/datum/http_response/response = request.into_response()

	if(response.errored || response.status_code != 200)
		to_chat(src, span_warning("Что-то не отправилось! Просьба не репортить это."))
		message_admins("[key_name_admin(usr)] пытается отрепортить [what_we_should_say], но терпит поражение: [response.body]")
		return

	SSblackbox.record_feedback("amount", "bugs_send", 1) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	to_chat(src, span_notice("Успех!"))
	message_admins("[key_name_admin(usr)] отправляет в гитхаб сообщение [what_we_should_say].")

	remove_verb(usr, /client/verb/report_a_bug)
