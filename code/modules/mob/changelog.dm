GLOBAL_VAR_INIT(changelog_json, file2text("data/changelog.json"))

/datum/changelog

/datum/changelog/ui_state(mob/user)
	return GLOB.always_state

/datum/changelog/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/changelog/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Changelog")
		ui.open()

/datum/changelog/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if (..())
		return

/datum/changelog/ui_data(mob/user)
	var/list/data = list()
	data["all_changelog"] = json_decode(GLOB.changelog_json)
	return data
