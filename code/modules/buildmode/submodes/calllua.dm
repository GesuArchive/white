/datum/buildmode_mode/call_lua
	key = "call_lua"

	var/static/list/saved_state = list() // налеплено поверх чтобы было

	var/datum/lua_state/state
	

/datum/buildmode_mode/call_lua/New(datum/buildmode/BM)
	. = ..()
	

	if(!check_rights_for(BM.holder, R_DEBUG))
		to_chat(BM.holder, span_red("Warning, +DEBUG required to use this build mode. You will not be able to call any function."))
		return
	
	if(saved_state[BM.holder.ckey])
		state = saved_state[BM.holder.ckey]
	
	if(state)
		state.call_function("bm_enable", BM.holder)

/datum/buildmode_mode/call_lua/Destroy()
	if(state)
		state.call_function("bm_disable", BM.holder)
	. = ..()

/datum/buildmode_mode/call_lua/show_help(client/c)

	to_chat(c, span_notice("***********************************************************"))
	if(!check_rights_for(c, R_DEBUG))
		to_chat(c, span_red("Warning, +DEBUG required to use this build mode. You will not be able to call any lua function."))
		to_chat(c, span_notice("*********************************************************** "))
		return
	to_chat(c, span_notice("Right mouse button on the buildmode button to select a lua state from existing ones."))
	to_chat(c, span_notice("Different modifier key combinations call different functions. They all get clicked atom and your client as arguments."))
	to_chat(c, span_notice("The lua functions for the you can define:"))
	to_chat(c, span_notice("	CtrlAltShift\[Left/Middle/Right]Click(atom, client, dir, params)"))
	to_chat(c, span_notice("		Add/remove the modifier keys from the function name to bind it to a certain"))
	to_chat(c, span_notice("		combination <i><u>but do not change their order.</u></i>"))
	to_chat(c, span_notice("		e.g. CtrlShiftLeftClick(), AltShiftMiddleClick(), CtrlRightClick(), AltMiddleClick(), etc."))
	to_chat(c, span_notice("	show_help(client)"))
	to_chat(c, span_notice("		Should return an html string which will be displayed below."))
	to_chat(c, span_notice("	bm_enable(client)"))
	to_chat(c, span_notice("		Called when you enter this build mode."))
	to_chat(c, span_notice("	bm_disable(client)"))
	to_chat(c, span_notice("		Called when you close buildmode or select another mode."))
	to_chat(c, span_notice("Return a string before sleeping/yielding to display it in chat. If returning a list, every entry will be displayed at a new line."))
	to_chat(c, span_notice("Keep in mind that if a function is not defined, it will still be called. (unsuccessfully) This shouldn't be a problem though."))
	to_chat(c, span_notice("Your selected lua state is saved when you exit buildmode until the end of the round!"))
	to_chat(c, span_notice("***********************************************************  "))

	var/custom_help = state.call_function_return_first("show_help", c)
	
	to_chat(c, "Help for current state ([state.name]):")
	if(custom_help)
		to_chat(c, custom_help)
	else
		to_chat(c, span_notice("None!"))
	to_chat(c, span_notice("***********************************************************   "))
	
/datum/buildmode_mode/call_lua/change_settings(client/c)
	if(!check_rights_for(c, R_DEBUG))
		to_chat(c, span_red("Access denied, +DEBUG required to use this build mode."))
		return

	if(SSlua.states.len)
		state = tgui_input_list(c, "Select a lua state:", "Build-a-buildmode", SSlua.states)
		saved_state[c.ckey] = state
		return
	
	var/result = tgui_alert(c, "No lua states exist! Would you like to open the lua editor to create one?", "Build-a-buildmode", list("Heck yeah", "Heck yeah"))
	if(result)
		c.open_lua_editor()






/datum/buildmode_mode/call_lua/handle_click(client/c, params, obj/object)
	if(!check_rights_for(c, R_DEBUG))
		to_chat(c, span_red("+DEBUG required to use this build mode. No function has been called."))
		return
	if(!state)
		to_chat(c, span_red("No lua state selected!"))
		return

	var/list/p = params2list(params)
	
	var/right_click = p.Find("right")
	var/middle_click = p.Find("middle")

	var/ctrl = p.Find("ctrl")
	var/alt = p.Find("alt")
	var/shift = p.Find("shift")
	
	var/list/index = list()
	if(ctrl)
		index.Add("Ctrl")
	if(alt)
		index.Add("Alt")
	if(shift)
		index.Add("Shift")

	if(right_click)
		index.Add("Right")
	else if (middle_click)
		index.Add("Middle")
	else
		index.Add("Left")
	
	var/func_name = "[jointext(index, "")]Click"
	log_admin("Build Mode: [key_name(c)] ([COORD(c.mob)]) called LUA function [func_name]([object.name]) from state [state.name]. [object.name] was at [COORD(object)]")
	var/ret = state.call_function(func_name, object, c, BM.build_dir, p)
	if(ret["status"] == "errored" || ret["status"] == "bad return") //error handling just in case
		to_chat(c, span_red("[func_name]() returned an error: [ret["param"]]"))
	else
		if(ret["param"])
			to_chat(c, jointext(ret["param"], "<br>"))
	
