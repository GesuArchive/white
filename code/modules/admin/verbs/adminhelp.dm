/client/var/adminhelptimerid = 0	//a timer id for returning the ahelp verb
/client/var/datum/admin_help/current_ticket	//the current ticket the (usually) not-admin client is dealing with

//
//TICKET MANAGER
//

GLOBAL_DATUM_INIT(ahelp_tickets, /datum/admin_help_tickets, new)

/datum/admin_help_tickets
	var/list/active_tickets = list()
	var/list/closed_tickets = list()
	var/list/resolved_tickets = list()

	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, AHELP_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, AHELP_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, AHELP_RESOLVED)

/datum/admin_help_tickets/Destroy()
	QDEL_LIST(active_tickets)
	QDEL_LIST(closed_tickets)
	QDEL_LIST(resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

/datum/admin_help_tickets/proc/TicketByID(id)
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/admin_help/AH = J
			if(AH.id == id)
				return J

/datum/admin_help_tickets/proc/TicketsByCKey(ckey)
	. = list()
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/admin_help/AH = J
			if(AH.initiator_ckey == ckey)
				. += AH

//private
/datum/admin_help_tickets/proc/ListInsert(datum/admin_help/new_ticket)
	var/list/ticket_list
	switch(new_ticket.state)
		if(AHELP_ACTIVE)
			ticket_list = active_tickets
		if(AHELP_CLOSED)
			ticket_list = closed_tickets
		if(AHELP_RESOLVED)
			ticket_list = resolved_tickets
		else
			CRASH("Invalid ticket state: [new_ticket.state]")
	var/num_closed = ticket_list.len
	if(num_closed)
		for(var/I in 1 to num_closed)
			var/datum/admin_help/AH = ticket_list[I]
			if(AH.id > new_ticket.id)
				ticket_list.Insert(I, new_ticket)
				return
	ticket_list += new_ticket

//opens the ticket listings for one of the 3 states
/datum/admin_help_tickets/proc/BrowseTickets(state)
	var/list/l2b
	var/title
	switch(state)
		if(AHELP_ACTIVE)
			l2b = active_tickets
			title = "Active Tickets"
		if(AHELP_CLOSED)
			l2b = closed_tickets
			title = "Closed Tickets"
		if(AHELP_RESOLVED)
			l2b = resolved_tickets
			title = "Resolved Tickets"
	if(!l2b)
		return
	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>[title]</title></head>")
	dat += "<A href='?_src_=holder;[HrefToken()];ahelp_tickets=[state]'>Refresh</A><br><br>"
	for(var/I in l2b)
		var/datum/admin_help/AH = I
		dat += "<span class='adminnotice'><span class='adminhelp'>Ticket #[AH.id]</span>: <A href='?_src_=holder;[HrefToken()];ahelp=[REF(AH)];ahelp_action=ticket'>[AH.initiator_key_name]: [AH.name]</A></span><br>"

	usr << browse(dat.Join(), "window=ahelp_list[state];size=600x480")

//Tickets statpanel
/datum/admin_help_tickets/proc/stat_entry()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/L = list()
	var/num_disconnected = 0
	L[++L.len] = list("Active Tickets:", "[astatclick.update("[active_tickets.len]")]", null, REF(astatclick))
	astatclick.update("[active_tickets.len]")
	for(var/I in active_tickets)
		var/datum/admin_help/AH = I
		if(AH.initiator)
			var/obj/effect/statclick/updated = AH.statclick.update()
			L[++L.len] = list("#[AH.id]. [AH.initiator_key_name]:", "[updated.name]", REF(AH))
		else
			++num_disconnected
	if(num_disconnected)
		L[++L.len] = list("Disconnected:", "[astatclick.update("[num_disconnected]")]", null, REF(astatclick))
	L[++L.len] = list("Closed Tickets:", "[cstatclick.update("[closed_tickets.len]")]", null, REF(cstatclick))
	L[++L.len] = list("Resolved Tickets:", "[rstatclick.update("[resolved_tickets.len]")]", null, REF(rstatclick))
	return L

//Reassociate still open ticket if one exists
/datum/admin_help_tickets/proc/ClientLogin(client/C)
	C.current_ticket = CKey2ActiveTicket(C.ckey)
	if(C.current_ticket)
		C.current_ticket.initiator = C
		C.current_ticket.AddInteraction("Client reconnected.")
		SSblackbox.LogAhelp(C.current_ticket.id, "Reconnected", "Client reconnected", C.ckey)

//Dissasociate ticket
/datum/admin_help_tickets/proc/ClientLogout(client/C)
	if(C.current_ticket)
		var/datum/admin_help/T = C.current_ticket
		T.AddInteraction("Client disconnected.")
		INVOKE_ASYNC(SSblackbox, TYPE_PROC_REF(/datum/controller/subsystem/blackbox, LogAhelp), T, "Disconnected", "Client disconnected", C.ckey)
		T.initiator = null

//Get a ticket given a ckey
/datum/admin_help_tickets/proc/CKey2ActiveTicket(ckey)
	for(var/I in active_tickets)
		var/datum/admin_help/AH = I
		if(AH.initiator_ckey == ckey)
			return AH

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/current_state

/obj/effect/statclick/ticket_list/New(loc, name, state)
	current_state = state
	..()

/obj/effect/statclick/ticket_list/Click()
	if (!usr.client?.holder)
		message_admins("[key_name_admin(usr)] non-holder clicked on a ticket list statclick! ([src])")
		log_game("[key_name(usr)] non-holder clicked on a ticket list statclick! ([src])")
		return

	GLOB.ahelp_tickets.BrowseTickets(current_state)

//called by admin topic
/obj/effect/statclick/ticket_list/proc/Action()
	Click()

//
//TICKET DATUM
//

/datum/admin_help
	var/id
	var/name
	var/state = AHELP_ACTIVE

	var/opened_at
	var/closed_at

	var/client/initiator //semi-misnomer, it's the person who ahelped/was bwoinked
	var/initiator_ckey
	var/initiator_key_name
	var/heard_by_no_admins = FALSE

	var/list/_interactions //use AddInteraction() or, preferably, admin_ticket_log()

	var/obj/effect/statclick/ahelp/statclick

	var/static/ticket_counter = 0

//call this on its own to create a ticket, don't manually assign current_ticket
//msg is the title of the ticket: usually the ahelp text
//is_bwoink is TRUE if this ticket was started by an admin PM
/datum/admin_help/New(msg, client/C, is_bwoink, urgent = FALSE)
	//clean the input msg
	msg = sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = copytext_char(msg, 1, 100)

	initiator = C
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_ticket) //This is not a bug
		initiator.current_ticket.AddInteraction("Ticket erroneously left open by code")
		initiator.current_ticket.Close()
	initiator.current_ticket = src

	TimeoutVerb()

	statclick = new(null, src)
	_interactions = list()

	if(is_bwoink)
		AddInteraction(span_blue("[key_name_admin(usr)] PM'd [LinkedReplyName()]"))
		message_admins(span_blue("Ticket [TicketHref("#[id]")] created"))
	else
		MessageNoRecipient(msg, urgent)
		send_message_to_discord(msg, urgent)
	GLOB.ahelp_tickets.active_tickets += src

/datum/admin_help/proc/send_message_to_discord(message, urgent = FALSE)
	var/message_to_send = message

	if(urgent)
		var/extra_message_to_send = "[message] - Requested an admin"
		var/extra_message = CONFIG_GET(string/urgent_ahelp_message)
		if(extra_message)
			extra_message_to_send += " ([extra_message])"
		to_chat(initiator, span_boldwarning("Notified admins to prioritize your ticket"))
		send2adminchat_webhook("RELAY: [initiator_ckey] | Ticket #[id]: [extra_message_to_send]")
	//send it to TGS if nobody is on and tell us how many were on
	var/admin_number_present = send2discord_adminless_only(initiator_ckey, "Ticket #[id]: [message_to_send]")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	if(admin_number_present <= 0)
		to_chat(initiator, span_notice("No active admins are online, your adminhelp was sent to admins who are available through IRC or Discord."))
		heard_by_no_admins = TRUE

/proc/send2adminchat_webhook(message)
	if(!CONFIG_GET(string/adminhelp_webhook_url))
		return
	var/message_content = replacetext(replacetext(message, "\proper", ""), "\improper", "")
	message_content = GLOB.has_discord_embeddable_links.Replace(replacetext(message, "`", ""), " ```$1``` ")
	var/list/webhook_info = list()
	webhook_info["content"] = message_content
	if(CONFIG_GET(string/adminhelp_webhook_name))
		webhook_info["username"] = CONFIG_GET(string/adminhelp_webhook_name)
	if(CONFIG_GET(string/adminhelp_webhook_pfp))
		webhook_info["avatar_url"] = CONFIG_GET(string/adminhelp_webhook_pfp)
	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, CONFIG_GET(string/adminhelp_webhook_url), json_encode(webhook_info), headers, "tmp/response.json")
	request.begin_async()

/datum/admin_help/Destroy()
	RemoveActive()
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	return ..()

/datum/admin_help/proc/AddInteraction(formatted_message)
	if(heard_by_no_admins && usr && usr.ckey != initiator_ckey)
		heard_by_no_admins = FALSE
		send2adminchat(initiator_ckey, "Ticket #[id]: Answered by [key_name(usr)]")
	_interactions += "[time_stamp()]: [formatted_message]"

//Removes the ahelp verb and returns it after 2 minutes
/datum/admin_help/proc/TimeoutVerb()
	remove_verb(initiator, /client/verb/adminhelp)
	initiator.adminhelptimerid = addtimer(CALLBACK(initiator, /client/proc/giveadminhelpverb), 1200, TIMER_STOPPABLE) //2 minute cooldown of admin helps

//private
/datum/admin_help/proc/FullMontyNobracket(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME_NOBRACKET(initiator.mob)
	if(state == AHELP_ACTIVE)
		. += ClosureLinksNobracket(ref_src)

/datum/admin_help/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	if(state == AHELP_ACTIVE)
		. += ClosureLinks(ref_src)

		if (CONFIG_GET(flag/popup_admin_pm))
			. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];adminpopup=[REF(initiator)]'>POPUP</A>)"

//private
/datum/admin_help/proc/ClosureLinksNobracket(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = " <A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reject'>REJT</A>"
	. += " <A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=icissue'>IC</A>"
	. += " <A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=close'>CLOSE</A>"
	. += " <A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=resolve'>RSLVE</A>"

//private
/datum/admin_help/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reject'>REJT</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=icissue'>IC</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=close'>CLOSE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=resolve'>RSLVE</A>)"

//private
/datum/admin_help/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reply'>[initiator_key_name]</A>"

//private
/datum/admin_help/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=[action]'>[msg]</A>"

//message from the initiator without a target, all admins will see this
//won't bug irc/discord
/datum/admin_help/proc/MessageNoRecipient(msg, urgent = FALSE)
	msg = html_decode(sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN)))
	var/ref_src = "[REF(src)]"
	//Message to be sent to all admins
	var/admin_msg = span_adminnotice(span_adminhelp("Тикет [TicketHref("#[id]", ref_src)]</span><b>: [LinkedReplyName(ref_src)] [FullMonty(ref_src)]:</b> <span class='linkify'>[keywords_lookup(msg)]"))

	AddInteraction(span_red("[LinkedReplyName(ref_src)]: [msg]"))
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [msg]")

	//send this msg to all admins
	for(var/client/X in GLOB.admins)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))
		window_flash(X, ignorepref = TRUE)
		to_chat(X,
			type = MESSAGE_TYPE_ADMINPM,
			html = admin_msg)

	//show it to the person adminhelping too
	to_chat(initiator,
		type = MESSAGE_TYPE_ADMINPM,
		html = span_adminnotice("Сообщение <b>администраторам</b>: <span class='linkify'>[msg]</span>") )
	SSblackbox.LogAhelp(id, "Ticket Opened", msg, null, initiator.ckey, urgent = urgent)

//Reopen a closed ticket
/datum/admin_help/proc/Reopen()
	if(state == AHELP_ACTIVE)
		to_chat(usr, span_warning("Запрос уже открыт."))
		return

	if(GLOB.ahelp_tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, span_warning("Этот пользователь уже имеет открытый тикет."))
		return

	statclick = new(null, src)
	GLOB.ahelp_tickets.active_tickets += src
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	switch(state)
		if(AHELP_CLOSED)
			SSblackbox.record_feedback("tally", "ahelp_stats", -1, "closed")
		if(AHELP_RESOLVED)
			SSblackbox.record_feedback("tally", "ahelp_stats", -1, "resolved")
	state = AHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.current_ticket = src

	AddInteraction("<font color='pink'>Reopened by [key_name_admin(usr)]</font>")
	var/msg = span_adminhelp("Ticket [TicketHref("#[id]")] reopened by [key_name_admin(usr)].")
	message_admins(msg)
	log_admin_private(msg)
	SSblackbox.LogAhelp(id, "Reopened", "Reopened by [usr.key]", usr.ckey)
	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "reopened")
	TicketPanel()	//can only be done from here, so refresh it

//private
/datum/admin_help/proc/RemoveActive()
	if(state != AHELP_ACTIVE)
		return
	closed_at = world.time
	QDEL_NULL(statclick)
	GLOB.ahelp_tickets.active_tickets -= src
	if(initiator && initiator.current_ticket == src)
		initiator.current_ticket = null

	SEND_SIGNAL(src, COMSIG_ADMIN_HELP_MADE_INACTIVE)

//Mark open ticket as closed/meme
/datum/admin_help/proc/Close(key_name = key_name_admin(usr), silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_CLOSED
	GLOB.ahelp_tickets.ListInsert(src)
	AddInteraction(span_red("Closed by [key_name]."))
	if(!silent)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "closed")
		var/msg = "Ticket [TicketHref("#[id]")] closed by [key_name]."
		message_admins(msg)
		SSblackbox.LogAhelp(id, "Closed", "Closed by [usr.key]", null, usr.ckey)
		log_admin_private(msg)

//Mark open ticket as resolved/legitimate, returns ahelp verb
/datum/admin_help/proc/Resolve(key_name = key_name_admin(usr), silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_RESOLVED
	GLOB.ahelp_tickets.ListInsert(src)

	addtimer(CALLBACK(initiator, /client/proc/giveadminhelpverb), 50)

	AddInteraction("<font color='green'>Resolved by [key_name].</font>")
	to_chat(initiator, "\n<span class='adminhelp'>Вопрос был разрешён администратором. Можете спрашивать ещё, при желании.</span>\n")
	if(!silent)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "resolved")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [key_name]"
		message_admins(msg)
		SSblackbox.LogAhelp(id, "Resolved", "Resolved by [usr.key]", null, usr.ckey)
		log_admin_private(msg)

//Close and return ahelp verb, use if ticket is incoherent
/datum/admin_help/proc/Reject(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	if(initiator)
		initiator.giveadminhelpverb()

		SEND_SOUND(initiator, sound('sound/effects/rejt.ogg'))

		to_chat(initiator, "<font color='red' size='4'><b>- Запрос отклонён! -</b></font>")
		to_chat(initiator, span_red("<b>Запрос отклонён.</b> Попробуй ещё раз."))
		to_chat(initiator, "Пожалуйста, успокойтесь. Администратор возможно не видел какие-либо события связанные с раундом, поэтому распишите проблему более подробно и также четко указывайте имена тех, о ком вы сообщаете.")

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "rejected")
	var/msg = "Ticket [TicketHref("#[id]")] rejected by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("Rejected by [key_name].")
	SSblackbox.LogAhelp(id, "Rejected", "Rejected by [usr.key]", null, usr.ckey)
	Close(silent = TRUE)

//Resolve ticket with IC Issue message
/datum/admin_help/proc/ICIssue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<font color='red' size='4'><b>- Отмечено как внутриигровая ситуация! -</b></font><br>"
	msg += span_red("Ваша проблема была определена администратором как внутриигровая ситуация и в настоящее время НЕ требует вмешательства администратора. Для дальнейшего решения вам следует использовать варианты, которые соответствуют ситуации в игре.")

	if(initiator)
		SEND_SOUND(initiator, sound('sound/effects/rejt.ogg'))
		to_chat(initiator, msg)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "IC")
	msg = "Ticket [TicketHref("#[id]")] marked as IC by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("Marked as IC issue by [key_name]")
	SSblackbox.LogAhelp(id, "IC Issue", "Marked as IC issue by [usr.key]", null,  usr.ckey)
	Resolve(silent = TRUE)

//Show the ticket panel
/datum/admin_help/proc/TicketPanel()
	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Тикет #[id]</title></head>")
	var/ref_src = "[REF(src)]"
	dat += "<b>Состояние: "
	switch(state)
		if(AHELP_ACTIVE)
			dat += span_red("ОТКРЫТ")
		if(AHELP_RESOLVED)
			dat += "<font color='green'>РАЗРЕШЁН</font>"
		if(AHELP_CLOSED)
			dat += "ЗАКРЫТ"
		else
			dat += "СЛОМАЛСЯ"
	dat += "</b>[FOURSPACES][TicketHref("Обновить", ref_src)][FOURSPACES][TicketHref("Изменить", ref_src, "retitle")]"
	if(state != AHELP_ACTIVE)
		dat += "[FOURSPACES][TicketHref("Переоткрыть", ref_src, "reopen")]"
	dat += "<br><br>Открыт в: [gameTimestamp(wtime = opened_at)] (Приблизительно [DisplayTimeText(world.time - opened_at)] назад)"
	if(closed_at)
		dat += "<br>Закрыт в: [gameTimestamp(wtime = closed_at)] (Приблизительно [DisplayTimeText(world.time - closed_at)] назад)"
	dat += "<br><br>"
	if(initiator)
		dat += "<b>Действия:</b> [FullMontyNobracket(ref_src)]<br>"
	else
		dat += "<b>ОТКЛЮЧИЛСЯ</b>[FOURSPACES][ClosureLinks(ref_src)]<br>"
	dat += "<br><b>Журнал:</b><br><br>"
	for(var/I in _interactions)
		dat += html_decode("[I]<br>")

	var/datum/browser/popup = new(usr, "ahelp[id]", "Тикет #[id]: [LinkedReplyName(ref_src)]", 620, 480)
	popup.set_content(dat.Join())
	popup.open()

/datum/admin_help/proc/Retitle()
	var/new_title = tgui_input_text(usr, "Enter a title for the ticket", "Rename Ticket", name)
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [TicketHref("#[id]")] titled [name] by [key_name_admin(usr)]"
		message_admins(msg)
		log_admin_private(msg)
	TicketPanel() //we have to be here to do this

//Forwarded action from admin/Topic
/datum/admin_help/proc/Action(action)
	testing("Ahelp action: [action]")
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("reopen")
			Reopen()

//
// TICKET STATCLICK
//

/obj/effect/statclick/ahelp
	var/datum/admin_help/ahelp_datum

/obj/effect/statclick/ahelp/Initialize(mapload, datum/admin_help/AH)
	ahelp_datum = AH
	. = ..()

/obj/effect/statclick/ahelp/update()
	return ..(ahelp_datum.name)

/obj/effect/statclick/ahelp/Click()
	if (!usr.client?.holder)
		message_admins("[key_name_admin(usr)] non-holder clicked on an ahelp statclick! ([src])")
		log_game("[key_name(usr)] non-holder clicked on an ahelp statclick! ([src])")
		return

	ahelp_datum.TicketPanel()

/obj/effect/statclick/ahelp/Destroy()
	ahelp_datum = null
	return ..()

//
// CLIENT PROCS
//

/client/proc/giveadminhelpverb()
	add_verb(src, /client/verb/adminhelp)
	deltimer(adminhelptimerid)
	adminhelptimerid = 0

GLOBAL_DATUM_INIT(admin_help_ui_handler, /datum/admin_help_ui_handler, new)

/datum/admin_help_ui_handler
	var/list/ahelp_cooldowns = list()

/datum/admin_help_ui_handler/ui_state(mob/user)
	return GLOB.always_state

/datum/admin_help_ui_handler/ui_data(mob/user)
	. = list()
	var/list/admins = get_admin_counts(R_BAN)
	.["adminCount"] = length(admins["present"])

/datum/admin_help_ui_handler/ui_static_data(mob/user)
	. = list()
	.["bannedFromUrgentAhelp"] = is_banned_from(user.ckey, "Urgent Adminhelp")
	.["urgentAhelpPromptMessage"] = CONFIG_GET(string/urgent_ahelp_user_prompt)
	var/webhook_url = CONFIG_GET(string/adminhelp_webhook_url)
	if(webhook_url)
		.["urgentAhelpEnabled"] = TRUE

/datum/admin_help_ui_handler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Adminhelp")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/admin_help_ui_handler/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/client/user_client = usr.client
	var/message = sanitize_text(trim(params["message"]))
	var/urgent = !!params["urgent"]
	var/list/admins = get_admin_counts(R_BAN)
	if(length(admins["present"]) != 0 || is_banned_from(user_client.ckey, "Urgent Adminhelp"))
		urgent = FALSE

	if(user_client.adminhelptimerid)
		return

	perform_adminhelp(user_client, message, urgent)
	ui.close()

/datum/admin_help_ui_handler/proc/perform_adminhelp(client/user_client, message, urgent)
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Пока нельзя..."))
		return

	if(!message)
		return

	//handle muting and automuting
	if(user_client.prefs.muted & MUTE_ADMINHELP)
		to_chat(user_client, span_danger("Ошибка незакрытого рта. Заткнитесь. Заткнитесь."))
		return
	if(user_client.handle_spam_prevention(message, MUTE_ADMINHELP))
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(urgent)
		if(!COOLDOWN_FINISHED(src, ahelp_cooldowns?[user_client.ckey]))
			urgent = FALSE // Prevent abuse
		else
			COOLDOWN_START(src, ahelp_cooldowns[user_client.ckey], CONFIG_GET(number/urgent_ahelp_cooldown) * (1 SECONDS))

	if(user_client.current_ticket)
		user_client.current_ticket.TimeoutVerb()
		if(urgent)
			var/sanitized_message = sanitize(copytext_char(message, 1, MAX_MESSAGE_LEN))
			user_client.current_ticket.send_message_to_discord(sanitized_message, urgent = TRUE)
		user_client.current_ticket.MessageNoRecipient(message, urgent)
		return

	new /datum/admin_help(message, user_client, FALSE, urgent)

/client/verb/no_tgui_adminhelp(message as message)
	set name = "NoTguiAdminhelp"
	set hidden = TRUE

	if(adminhelptimerid)
		return

	message = trim(message)

	GLOB.admin_help_ui_handler.perform_adminhelp(src, message, FALSE)

/client/verb/adminhelp()
	set category = "Адм"
	set name = "Помощь администратора"
	GLOB.admin_help_ui_handler.ui_interact(mob)
	to_chat(src, span_boldnotice("Окно помощи не открылось? <a href='?src=[REF(src)];tguiless_adminhelp=1'>Нажми сюда</a>"))

/client/proc/choosehelp()
	var/list/type = list()
	if(/client/verb/adminhelp in verbs)
		type += "Помощь администратора"
	else
		type += "Помощь администратора \[Недоступно\]"

	if(/client/verb/mentorhelp in verbs)
		type += "Помощь знатока"
	else
		type += "Помощь знатока \[Недоступно\]"

	var/selected_type = input("- Помощь администратора используется для жалоб о гриферах, нарушителях игровых правил и помощи с критическими игровыми багами.\
	\n\n- Помощь знатока используется для вопросов об игровых механиках и советах по игре.\
	\n\nВыберите опцию:", "Помощь", null, null) as null|anything in type

	if(selected_type == "Помощь администратора")
		adminhelp()

	if(selected_type == "Помощь знатока")
		mentorhelp()

//
// LOGGING
//

//Use this proc when an admin takes action that may be related to an open ticket on what
//what can be a client, ckey, or mob
/proc/admin_ticket_log(what, message)
	var/client/C
	var/mob/Mob = what
	if(istype(Mob))
		C = Mob.client
	else
		C = what
	if(istype(C) && C.current_ticket)
		C.current_ticket.AddInteraction(message)
		return C.current_ticket
	if(istext(what)) //ckey
		var/datum/admin_help/AH = GLOB.ahelp_tickets.CKey2ActiveTicket(what)
		if(AH)
			AH.AddInteraction(message)
			return AH

//
// HELPER PROCS
//

/proc/get_admin_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.admins)
		.["total"] += X
		if(requiredflags != NONE && !check_rights_for(X, requiredflags))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2discord_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts(requiredflags)
	var/list/activemins = adm["present"]
	. = activemins.len
	if(. <= 0)
		var/final = ""
		var/list/afkmins = adm["afk"]
		var/list/stealthmins = adm["stealth"]
		var/list/powerlessmins = adm["noflags"]
		var/list/allmins = adm["total"]
		if(!afkmins.len && !stealthmins.len && !powerlessmins.len)
			final = "[msg] - No admins online"
		else
			final = "[msg] - All admins stealthed\[[english_list(stealthmins)]\], AFK\[[english_list(afkmins)]\], or lacks +BAN\[[english_list(powerlessmins)]\]! Total: [allmins.len] "
		send2adminchat(source,final)
		send2otherserver(source,final)

/**
 * Sends a message to a set of cross-communications-enabled servers using world topic calls
 *
 * Arguments:
 * * source - Who sent this message
 * * msg - The message body
 * * type - The type of message, becomes the topic command under the hood
 * * target_servers - A collection of servers to send the message to, defined in config
 * * additional_data - An (optional) associated list of extra parameters and data to send with this world topic call
 */
/proc/send2otherserver(source, msg, type = "Ahelp", target_servers, list/additional_data = list())
	if(!CONFIG_GET(string/comms_key))
		debug_world_log("Server cross-comms message not sent for lack of configured key")
		return

	var/our_id = CONFIG_GET(string/cross_comms_name)
	additional_data["message_sender"] = source
	additional_data["message"] = msg
	additional_data["source"] = "([our_id])"
	additional_data += type

	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	for(var/I in servers)
		if(I == our_id) //No sending to ourselves
			continue
		if(target_servers && !(I in target_servers))
			continue
		world.send_cross_comms(I, additional_data)

/// Sends a message to a given cross comms server by name (by name for security).
/world/proc/send_cross_comms(server_name, list/message, auth = TRUE)
	set waitfor = FALSE
	if (auth)
		var/comms_key = CONFIG_GET(string/comms_key)
		if(!comms_key)
			debug_world_log("Server cross-comms message not sent for lack of configured key")
			return
		message["key"] = comms_key
	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	var/server_url = servers[server_name]
	if (!server_url)
		CRASH("Invalid cross comms config: [server_name]")
	world.Export("[server_url]?[list2params(message)]")

/proc/keywords_lookup(msg,external)

	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/adminhelp_ignored_words = list("неизвестный","мартышка","alien","я")

	//explode the input msg into a list
	var/list/msglist = splittext_char(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	var/founds = ""
	for(var/mob/M in GLOB.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)
			indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext_char(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = r_jobgen(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = r_jobgen(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = lowertext(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ии")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							var/is_antag = 0
							if(is_special_character(found))
								is_antag = 1
							founds += "Name: [found.name]([found.real_name]) Key: [found.key] Ckey: [found.ckey] [is_antag ? "(Antag)" : null] "
							msg += "[original_word]<font size='1' color='[is_antag ? "red" : "black"]'>(<A HREF='?_src_=holder;[HrefToken(TRUE)];adminmoreinfo=[REF(found)]'>?</A>|<A HREF='?_src_=holder;[HrefToken(TRUE)];adminplayerobservefollow=[REF(found)]'>F</A>)</font> "
							continue
		msg += "[original_word] "
	if(external)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg

/proc/get_mob_by_name(msg)
	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/ignored_words = list("неизвестный","the","a","an","of","мартышка","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext_char(msg, " ")

	//who might fit the shoe
	var/list/potential_hits = list()

	for(var/i in GLOB.mob_list)
		var/mob/M = i
		var/list/nameWords = list()
		if(!M.mind)
			continue

		for(var/string in splittext_char(lowertext(M.real_name), " "))
			if(!(string in ignored_words))
				nameWords += string
		for(var/string in splittext_char(lowertext(M.name), " "))
			if(!(string in ignored_words))
				nameWords += string

		for(var/string in nameWords)
			if(string in msglist)
				potential_hits += M
				break

	return potential_hits


/**
 * Checks a given message to see if any of the words contain an active admin's ckey with an @ before it
 *
 * Returns nothing if no pings are found, otherwise returns an associative list with ckey -> client
 * Also modifies msg to underline the pings, then stores them in the key [ADMINSAY_PING_UNDERLINE_NAME_INDEX] for returning
 *
 * Arguments:
 * * msg - the message being scanned
 */
/proc/check_admin_pings(msg)
	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")
	var/list/admins_to_ping = list()

	var/i = 0
	for(var/word in msglist)
		i++
		if(word && word[1] != "@")
			continue
		var/ckey_check = lowertext(copytext(word, 2))
		var/client/client_check = GLOB.directory[ckey_check]
		if(client_check?.holder)
			msglist[i] = "<u>[word]</u>"
			admins_to_ping[ckey_check] = client_check

	if(length(admins_to_ping))
		admins_to_ping[ADMINSAY_PING_UNDERLINE_NAME_INDEX] = jointext(msglist, " ") // without tuples, we must make do!
		return admins_to_ping
