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
		return

/datum/buildmode_mode/call_lua/Destroy()
	. = ..()

/datum/buildmode_mode/call_lua/show_help(client/c)

	to_chat(c, span_notice("***********************************************************"))
	if(!check_rights_for(c, R_DEBUG))
		to_chat(c, span_red("Warning, +DEBUG required to use this build mode. You will not be able to call any lua function."))
		to_chat(c, span_notice("*********************************************************** "))
	to_chat(c, span_notice("Right mouse button on the buildmode button to select a lua state from existing ones."))
	to_chat(c, span_notice("The lua functions you can define:"))
	to_chat(c, span_notice("	LeftClick(atom)"))
	to_chat(c, span_notice("	MiddleClick(atom)"))
	to_chat(c, span_notice("	RightClick(atom)"))	
	to_chat(c, span_notice("	AltLeftClick(atom)"))
	to_chat(c, span_notice("	AltMiddleClick(atom)"))
	to_chat(c, span_notice("	AltRightClick(atom)"))
	to_chat(c, span_notice("	CtrlLeftClick(atom)"))
	to_chat(c, span_notice("	CtrlMiddleClick(atom)"))
	to_chat(c, span_notice("	CtrlRightClick(atom)"))
	to_chat(c, span_notice("	CtrlAltLeftClick(atom)"))
	to_chat(c, span_notice("	CtrlAltMiddleClick(atom)"))
	to_chat(c, span_notice("	CtrlAltRightClick(atom)"))
	to_chat(c, span_notice("Keep in mind that if a function is not defined, it will still be called (unsuccessfully)"))
	to_chat(c, span_notice("***********************************************************  "))
	to_chat(c, span_notice("Your selected lua state is saved when you exit buildmode until the end of the round!"))
	to_chat(c, span_notice("***********************************************************   "))


/datum/buildmode_mode/call_lua/change_settings(client/c)
	if(!check_rights_for(BM.holder, R_DEBUG))
		to_chat(BM.holder, span_red("Access denied, +DEBUG required to use this build mode."))
		return

	if(SSlua.states.len)
		state = tgui_input_list(usr, "Select a lua state:", "Build-a-buildmode", SSlua.states)
		saved_state[c.ckey] = state
		return
	
	var/result = tgui_alert(usr, "No lua states exist! Would you like to open the lua editor to create one?", "Build-a-buildmode", list("Heck yeah", "Heck yeah"))
	if(result)
		c.open_lua_editor()






/datum/buildmode_mode/call_lua/handle_click(client/c, params, obj/object)
	if(!check_rights_for(BM.holder, R_DEBUG))
		to_chat(BM.holder, span_red("+DEBUG required to use this build mode. No function has been called."))
		return
	if(!state)
		to_chat(BM.holder, span_red("No lua state selected!"))
		return

	var/list/p = params2list(params)
	
	var/right_click = p.Find("right")
	var/middle_click = p.Find("middle")
	
	var/alt = p.Find("alt")
	var/ctrl = p.Find("ctrl")
	
	var/list/index = list()
	if(ctrl)
		index.Add("Ctrl")

	if(alt)
		index.Add("Alt")

	if(right_click)
		index.Add("Right")
	else if (middle_click)
		index.Add("Middle")
	else
		index.Add("Left")
	
	var/func_name = "[jointext(index, "")]Click"
	log_admin("Build Mode: [key_name(c)] ([COORD(c.mob)]) called LUA function [func_name]([object.name]) from state [state.name]. [object.name] was at [COORD(object)]")
	state.call_function(func_name, object)
