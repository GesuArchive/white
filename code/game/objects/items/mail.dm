/// Mail is tamper-evident and unresealable, postmarked by CentCom for an individual recepient.
/obj/item/mail
	name = "Посылка"
	gender = NEUTER
	desc = "Посылка с официальным почтовым штемпелем и защитой от несанкционированного вскрытия, регулируемая Центральным Командованием и сделанная из высококачественных материалов."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail_small"
	inhand_icon_state = "paper"
	worn_icon_state = "paper"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound =  'sound/items/handling/paper_pickup.ogg'
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	/// Destination tagging for the mail sorter.
	var/sort_tag = 0
	/// Who this mail is for and who can open it.
	var/datum/weakref/recipient
	/// How many goodies this mail contains.
	var/goodie_count = 1
	/// Goodies which can be given to anyone. The base weight for cash is 56. For there to be a 50/50 chance of getting a department item, they need 56 weight as well.
	var/list/generic_goodies = list(
		/obj/item/stack/spacecash/c1 = 100,
		/obj/item/stack/spacecash/c10 = 90,
		/obj/item/stack/spacecash/c100 = 55,
		/obj/item/stack/spacecash/c200 = 15,
		/obj/item/stack/spacecash/c500 = 5,
		/obj/item/stack/spacecash/c1000 = 1,
	)
	// Overlays (pure fluff)
	/// Does the letter have the postmark overlay?
	var/postmarked = TRUE
	/// Does the letter have a stamp overlay?
	var/stamped = TRUE
	/// List of all stamp overlays on the letter.
	var/list/stamps = list()
	/// Maximum number of stamps on the letter.
	var/stamp_max = 1
	/// Physical offset of stamps on the object. X direction.
	var/stamp_offset_x = 0
	/// Physical offset of stamps on the object. Y direction.
	var/stamp_offset_y = 2

	///mail will have the color of the department the recipient is in.
	var/static/list/department_colors

/obj/item/mail/envelope
	name = "Посылка"
	icon_state = "mail_large"
	goodie_count = 2
	stamp_max = 2
	stamp_offset_y = 5

/obj/item/mail/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))
	AddElement(/datum/element/item_scaling, 0.75, 1)
	if(isnull(department_colors))
		department_colors = list(
			ACCOUNT_CIV = COLOR_WHITE,
			ACCOUNT_ENG = COLOR_PALE_ORANGE,
			ACCOUNT_SCI = COLOR_PALE_PURPLE_GRAY,
			ACCOUNT_MED = COLOR_PALE_BLUE_GRAY,
			ACCOUNT_SRV = COLOR_PALE_GREEN_GRAY,
			ACCOUNT_CAR = COLOR_BEIGE,
			ACCOUNT_SEC = COLOR_PALE_RED_GRAY,
		)

	// Icons
	// Add some random stamps.
	if(stamped == TRUE)
		var/stamp_count = rand(1, stamp_max)
		for(var/i = 1, i <= stamp_count, i++)
			stamps += list("stamp_[rand(2, 6)]")
	update_icon()

/obj/item/mail/update_overlays()
	. = ..()
	var/bonus_stamp_offset = 0
	for(var/stamp in stamps)
		var/image/stamp_image = image(
			icon = icon,
			icon_state = stamp,
			pixel_x = stamp_offset_x,
			pixel_y = stamp_offset_y + bonus_stamp_offset
		)
		stamp_image.appearance_flags |= RESET_COLOR
		add_overlay(stamp_image)
		bonus_stamp_offset -= 5

	if(postmarked == TRUE)
		var/image/postmark_image = image(
			icon = icon,
			icon_state = "postmark",
			pixel_x = stamp_offset_x + rand(-3, 1),
			pixel_y = stamp_offset_y + rand(bonus_stamp_offset + 3, 1)
		)
		postmark_image.appearance_flags |= RESET_COLOR
		add_overlay(postmark_image)

/obj/item/mail/attackby(obj/item/W, mob/user, params)
	// Destination tagging
	if(istype(W, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/destination_tag = W

		if(sort_tag != destination_tag.currTag)
			var/tag = uppertext(GLOB.TAGGERLOCATIONS[destination_tag.currTag])
			to_chat(user, span_notice("*[tag]*"))
			sort_tag = destination_tag.currTag
			playsound(loc, 'sound/machines/twobeep_high.ogg', 100, TRUE)

/obj/item/mail/attack_self(mob/user)
	if(recipient && user != recipient)
		to_chat(user, span_notice("Эта почта защищена слишком мудрым защитным механизмом! Не хотелось бы <em>потерять голову</em>!"))
		return

	to_chat(user, span_notice("Начинаю вскрывать посылку..."))
	if(!do_after(user, 1.5 SECONDS, target = user))
		return
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	if(contents.len)
		var/obj/item/paper/fluff/junkmail_generic/J = locate(/obj/item/paper/fluff/junkmail_generic) in src
		if(J)
			J.generate_info()
		user.put_in_hands(contents[1])
	playsound(loc, 'sound/items/poster_ripped.ogg', 50, TRUE)
	qdel(src)

/obj/item/mail/examine_more(mob/user)
	. = ..()
	var/list/msg = list(span_notice("<i>Замечаю почтовый штемпель на лицевой стороне письма...</i>"))
	if(recipient)
		msg += "\t<span class='info'>Сертифицированная NanoTrasen посылка для [recipient].</span>"
	else
		msg += "\t<span class='info'>Сертифицированная посылка для [GLOB.station_name].</span>"
	msg += "\t<span class='info'>Для распространения вручную или через метки назначения с использованием сертифицированной системы мусоропровода NanoTrasen.</span>"
	return msg

/// Accepts a mob to initialize goodies for a piece of mail.
/obj/item/mail/proc/initialize_for_recipient(mob/new_recipient)
	recipient = new_recipient
	name = "[initial(name)] для [new_recipient.real_name] ([new_recipient.job])"
	var/list/goodies = generic_goodies

	var/datum/job/this_job = SSjob.name_occupations[new_recipient.job]
	if(this_job)
		if(this_job.paycheck_department && department_colors[this_job.paycheck_department])
			color = department_colors[this_job.paycheck_department]
		var/list/job_goodies = this_job.get_mail_goodies()
		if(LAZYLEN(job_goodies))
			// certain roles and jobs (prisoner) do not receive generic gifts.
			if(this_job.exclusive_mail_goodies)
				goodies = job_goodies
			else
				goodies += job_goodies

	for(var/iterator = 0, iterator < goodie_count, iterator++)
		var/target_good = pick_weight(goodies)
		if(ispath(target_good, /datum/reagent))
			var/obj/item/reagent_containers/target_container = new /obj/item/reagent_containers/glass/bottle(src)
			target_container.reagents.add_reagent(target_good, target_container.volume)
			target_container.name = "[target_container.reagents.reagent_list[1].name] бутылка"
			new_recipient.log_message("[key_name(new_recipient)] received reagent container [target_container.name] in the mail ([target_good])", LOG_GAME)
		else
			var/atom/movable/target_atom = new target_good(src)
			new_recipient.log_message("[key_name(new_recipient)] received [target_atom.name] in the mail ([target_good])", LOG_GAME)

	return TRUE

/// Alternate setup, just complete garbage inside and anyone can open
/obj/item/mail/proc/junk_mail()

	var/obj/junk = /obj/item/paper/fluff/junkmail_generic
	var/special_name = FALSE

	if(prob(25))
		special_name = TRUE
		junk = pick(list(/obj/item/paper/pamphlet/gateway, /obj/item/paper/pamphlet/violent_video_games, /obj/effect/decal/cleanable/ash))
		if(prob(1))
			junk = /obj/item/paper/fluff/junkmail_redpill

	var/list/junk_names = list(
		/obj/item/paper/pamphlet/gateway = "[initial(name)] для [pick(GLOB.adjectives)] приключенцев",
		/obj/item/paper/pamphlet/violent_video_games = "[initial(name)] за правду об аркадных автоматах, которую центком не хочет слышать",
		/obj/item/paper/fluff/junkmail_redpill = "[initial(name)] для [pick(GLOB.adjectives)] работяг NanoTrasen",
		/obj/effect/decal/cleanable/ash = "[initial(name)] с НЕВЕРОЯТНО ВАЖНЫМ АРТЕФАКТОМ - ДОСТАВИТЬ В НАУЧНЫЙ ОТДЕЛ. ОЧЕНЬ ХРУПКОЕ СОДЕРЖИМОЕ.",
	)

	color = pick(department_colors) //eh, who gives a shit.
	name = special_name ? junk_names[junk] : "ВАЖНО! [capitalize(initial(name))]"

	junk = new junk(src)
	return TRUE

/obj/item/mail/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	SIGNAL_HANDLER
	if(!hasmob)
		disposal_holder.destinationTag = sort_tag

/// Subtype that's always junkmail
/obj/item/mail/junkmail/Initialize(mapload)
	. = ..()
	junk_mail()

/// Crate for mail from CentCom.
/obj/structure/closet/crate/mail
	name = "почтовый ящик"
	desc = "Сертифицированный почтовый ящик от ЦК."
	icon_state = "mail"
	lid_icon_state = "maillid"
	lid_x = -26
	lid_y = 2

/// Crate for mail that automatically generates a lot of mail. Usually only normal mail, but on lowpop it may end up just being junk.
/obj/structure/closet/crate/mail/full
	name = "переполненный почтовый ящик"
	desc = "Сертифицированный почтовый ящик от ЦК. Чет ему плохо."

/obj/structure/closet/crate/mail/update_icon_state()
	. = ..()
	if(opened)
		icon_state = "[initial(icon_state)]open"
		if(locate(/obj/item/mail) in src)
			icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]sealed"

/obj/structure/closet/crate/mail/full/Initialize(mapload)
	. = ..()
	var/list/mail_recipients = list()
	for(var/mob/living/carbon/human/alive in GLOB.player_list)
		if(alive.stat != DEAD)
			mail_recipients += alive
	if(!LAZYLEN(mail_recipients))
		return
	for(var/iterator in 1 to storage_capacity)
		var/obj/item/mail/new_mail
		if(prob(FULL_CRATE_LETTER_ODDS))
			new_mail = new /obj/item/mail(src)
		else
			new_mail = new /obj/item/mail/envelope(src)
		var/mob/living/carbon/human/mail_to
		mail_to = pick(mail_recipients)
		if(mail_to)
			new_mail.initialize_for_recipient(mail_to)
			mail_recipients -= mail_to //Once picked, the mail crate will need a new recipient.
		else
			new_mail.junk_mail()


/// Mailbag.
/obj/item/storage/bag/mail
	name = "мешок с почтой"
	desc = "Сумка для писем, конвертов и других почтовых отправлений."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mailbag"
	worn_icon_state = "mailbag"
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/mail/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 42
	atom_storage.max_slots = 21
	atom_storage.numerical_stacking = FALSE
	atom_storage.set_holdable(list(
		/obj/item/mail,
		/obj/item/delivery/small,
		/obj/item/paper
	))

/obj/item/paper/fluff/junkmail_redpill
	name = "свёрток"
	icon_state = "scrap"
	var/nuclear_option_odds = 100//0.1

/obj/item/paper/fluff/junkmail_redpill/Initialize(mapload)
	. = ..()
	if(!prob(nuclear_option_odds)) // 1 in 1000 chance of getting 2 random nuke code characters.
		info = "<i>Тебе пора выходить из симуляции. Не забудь числа, они помогут тебе вспомнить:</i> '[rand(0,9)][rand(0,9)][rand(0,9)]...'"
		return
	var/code = random_nukecode()
	for(var/obj/machinery/nuclearbomb/selfdestruct/self_destruct in GLOB.nuke_list)
		self_destruct.r_code = code
	message_admins("Through junkmail, the self-destruct code was set to \"[code]\".")
	info = "<i>Тебе пора выходить из симуляции. Не забудь числа, они помогут тебе вспомнить настоящий код от взрыва бомбы:</i> '[code[rand(1,5)]][code[rand(1,5)]]...'"

/obj/item/paper/fluff/junkmail_redpill/true //admin letter enabling players to brute force their way through the nuke code if they're so inclined.
	nuclear_option_odds = 100

/obj/item/paper/fluff/junkmail_generic
	name = "важный документ"
	icon_state = "paper_words"

/obj/item/paper/fluff/junkmail_generic/proc/generate_info()
	if(!info)
		var/anek = get_random_anek()
		info = anek?["content"] ? parsemarkdown(anek["content"]) : pick(GLOB.junkmail_messages)

// bash.im is dead at this moment
/proc/get_random_anek()
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, "http://rzhunemogu.ru/RandJSON.aspx?CType=1", "", "", null)
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()

	if(response.errored || response.status_code != 200)
		return FALSE

	if (response.body)
		return json_decode(response.body)
	return FALSE
