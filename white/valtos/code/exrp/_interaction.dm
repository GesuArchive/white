GLOBAL_LIST_EMPTY(interactions)

/proc/make_interactions(interaction)
	if(!GLOB.interactions.len)
		for(var/itype in typesof(/datum/interaction)-/datum/interaction)
			var/datum/interaction/I = new itype()
			GLOB.interactions[I.command] = I

/mob/proc/list_interaction_attributes()
	var/dat = ""
	if(ishuman(src))
		dat += "...имеет руки."
	if(dat != "")
		dat += "<br>"
	dat += "...имеет рот, который [mouth_is_free() ? "не прикрыт" : "прикрыт"]."
	return dat

/datum/interaction
	var/command = "interact"
	var/description = "Interact with them."
	var/simple_message = null
	var/simple_style = "danger"
	var/write_log_user = "tested"
	var/write_log_target = "was tested by"

	var/interaction_sound = null
	var/interaction_sound_age_pitch = 1

	var/max_distance = 1
	var/require_user_mouth
	var/require_user_hands
	var/require_target_mouth
	var/require_target_hands
	var/needs_physical_contact

	var/cooldaun = 0

	var/user_not_tired
	var/target_not_tired

	var/require_user_naked
	var/require_target_naked

	var/require_user_dancer
	var/require_user_dancor
	var/require_user_danceress

	var/require_target_dancer
	var/require_target_dancor
	var/require_target_danceress

	var/user_dancing_cost
	var/target_dancing_cost

/datum/interaction/proc/evaluate_user(mob/user, silent = TRUE)
	if(require_user_mouth && !user.mouth_is_free())
		if(!silent)
			to_chat(user, "<span class = 'warning'>Мой рот прикрыт.</span>")
		return FALSE
	if(require_user_hands && !ishuman(user))
		if(!silent)
			to_chat(user, "<span class = 'warning'>У меня нет рук.</span>")
		return FALSE
	if(user_not_tired && user.dancing_period)
		if(!silent)
			to_chat(user, span_warning("Всё еще не хочу после прошлого раза."))
		return FALSE
	if(require_user_naked && !user.is_literally_ready_to_dance())
		if(!silent)
			to_chat(user, "<span class = 'warning'>Вам мешает одежда.</span>")
		return FALSE
	if(require_user_dancer && user.gender == FEMALE)
		if(!silent)
			to_chat(user, "<span class = 'warning'>У вас нет огурца.</span>")
		return FALSE
	if(require_user_danceress && user.gender == MALE)
		if(!silent)
			to_chat(user, "<span class = 'warning'>У вас нет пельмешка.</span>")
		return FALSE
	return TRUE

/datum/interaction/proc/evaluate_target(mob/user, mob/target, silent = TRUE)
	if(require_target_mouth && !target.mouth_is_free())
		if(!silent)
			to_chat(user, "<span class = 'warning'>Рот <b>[target.name]</b> прикрыт.</span>")
		return FALSE
	if(require_target_hands && !ishuman(target))
		if(!silent)
			to_chat(user, "<span class = 'warning'>У <b>[target.name]</b> нет рук.</span>")
		return FALSE
	if(target_not_tired && target.dancing_period)
		if(!silent)
			to_chat(user, span_warning("Вашей цели не хочется."))
		return FALSE
	if(require_target_naked && !target.is_literally_ready_to_dance())
		if(!silent)
			to_chat(user, "<span class = 'warning'>Цели мешает одежда.</span>")
		return FALSE
	if(require_target_dancer && target.gender == FEMALE)
		if(!silent)
			to_chat(user, "<span class = 'warning'>У цели нет огурца.</span>")
		return FALSE
	if(require_target_danceress && target.gender == MALE)
		if(!silent)
			to_chat(user, "<span class = 'warning'>У цели нет пельмешка.</span>")
		return FALSE
	return TRUE

/datum/interaction/proc/get_action_link_for(mob/user, mob/target)
	return "<a href='?src=\ref[src];action=1;action_user=\ref[user];action_target=\ref[target]'>[description]</a><br>"

/datum/interaction/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["action"])
		do_action(locate(href_list["action_user"]), locate(href_list["action_target"]))
		return TRUE
	return FALSE

/datum/interaction/proc/do_action(mob/user, mob/target)
	if(cooldaun)
		return
	if(get_dist(user, target) > max_distance)
		to_chat(user, span_warning("<b>[target.name]</b> слишком далеко."))
		return
	if(needs_physical_contact && !(user.Adjacent(target) && target.Adjacent(user)))
		to_chat(user, span_warning("Не могу добраться до <b>[target.name]</b>."))
		return
	if(!evaluate_user(user, silent=0))
		return
	if(!evaluate_target(user, target, silent=0))
		return
	if(user.stat != CONSCIOUS)
		return
	if(!check_rights_for(user.client, R_ADMIN) && !check_whitelist_exrp(user.ckey))
		return

	cooldaun = 3

	display_interaction(user, target)

	post_interaction(user, target)

	if(write_log_user)
		log_exrp("([key_name(src)]) [user.real_name] [write_log_user] [target]")
		SSblackbox.record_feedback("tally", "dance_actions", 1, write_log_user)
	if(write_log_target)
		log_exrp("([key_name(src)]) [user.real_name] [write_log_target] [target]")

/datum/interaction/proc/display_interaction(mob/user, mob/target)
	if(simple_message)
		var/use_message = replacetext(simple_message, "USER", "<b>[user]</b>")
		use_message = replacetext(use_message, "TARGET", "<b>[target]</b>")
		user.visible_message("<span class='[simple_style] purple'>[capitalize(use_message)]</span>")

/datum/interaction/proc/post_interaction(mob/user, mob/target)
	spawn(1)
		cooldaun = 0
	if(user_dancing_cost)
		user.dancing_period += user_dancing_cost
	if(target_dancing_cost)
		target.dancing_period += target_dancing_cost
