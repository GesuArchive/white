/obj/item/cellphone
	name = "Мобилка"
	desc = "Алло, вам звонит Лёха."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "suspiciousphone"
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("звонит")
	var/ui_x = 264
	var/ui_y = 600

/obj/item/cellphone/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.always_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "Cellphone", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/item/cellphone/ui_data(mob/user)
	var/list/data = list()

	return data

/obj/item/cellphone/ui_act(action, params)
	if(..())
		return
