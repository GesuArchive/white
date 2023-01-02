GLOBAL_VAR_INIT(webhook_can_fire, 0)

/proc/webhook_send_roundstatus(status, extraData)
	var/list/query = list("status" = status)

	if(extraData)
		query.Add(extraData)

	webhook_send("roundstatus", query)

/proc/webhook_send_runtime(message) //when server logging gets fucked up, discord bot saves the day
	var/list/query = list("message" = message)
	webhook_send("runtimemessage", query)

/proc/webhook_send_asay(ckey, message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("asaymessage", query)

/proc/webhook_send_ooc(ckey, message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("oocmessage", query)

/proc/webhook_send_lobby(ckey, message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("lobbymessage", query)

/proc/webhook_send_me(ckey, message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("memessage", query)

/proc/webhook_send_ahelp(ckey, message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("ahelpmessage", query)

/proc/webhook_send_garbage(ckey, message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("garbage", query)

/proc/webhook_send_token(ckey, token)
	var/list/query = list("ckey" = ckey, "token" = token)
	webhook_send("token", query)

/proc/webhook_send_status_update(event, data)
	var/list/query = list("event" = event, "data" = data)
	webhook_send("status_update", query)

/proc/webhook_send(method, data)
	if (!GLOB.webhook_can_fire)
		return

	if (!CONFIG_GET(string/webhook_address_invst) || !CONFIG_GET(string/comms_key))
		return

	var/query = "[CONFIG_GET(string/webhook_address_invst)]?key=[CONFIG_GET(string/comms_key)]&method=[method]&data=[url_encode(json_encode(data))]"
	spawn(-1)
		world.Export(query)
