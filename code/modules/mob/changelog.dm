GLOBAL_VAR_INIT(changelog_json, file2text("data/changelog.json"))

/datum/changelog

/datum/changelog/ui_state(mob/user)
	return GLOB.always_state

/datum/changelog/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Changelog")
		ui.open()

/datum/changelog/ui_static_data(mob/user)
	var/list/data = list()
	data["all_changelog"] = GLOB.changelog_json ? json_decode(GLOB.changelog_json) : list()
	return data
