/// Gives the target bad luck, optionally permanently
/datum/smite/bad_luck
	name = "Bad Luck"

	/// Should the target know they've received bad luck?
	var/silent

	/// Is this permanent?
	var/permanent

/datum/smite/bad_luck/configure(client/user)
	silent = tgui_alert(user, "Do you want to apply the omen with a player notification?", "Notify Player?", list("Notify", "Silent")) == "Silent"
	permanent = tgui_alert(user, "Would you like this to be permanent or removed automatically after the first accident?", "Permanent?", list("Permanent", "Temporary")) == "Permanent"

/datum/smite/bad_luck/effect(client/user, mob/living/target)
	. = ..()
	if (permanent)
		message_admins("Перманентная неудача, скорее всего юзер сдохнет нахуй")
		log_admin("Перманентная неудача, скорее всего юзер сдохнет нахуй")
	target.AddComponent(/datum/component/omen, silent, null, permanent)
