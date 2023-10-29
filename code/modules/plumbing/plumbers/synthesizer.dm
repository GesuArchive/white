///A single machine that produces a single chem. Can be placed in unison with others through plumbing to create chemical factories
/obj/machinery/plumbing/synthesizer
	name = "chemical synthesizer"
	desc = "Produces a single chemical at a given volume. Must be plumbed. Most effective when working in unison with other chemical synthesizers, heaters and filters."

	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 2

	icon_state = "synthesizer"
	icon = 'icons/obj/plumbing/plumbers.dmi'

	///Amount we produce for every process. Ideally keep under 5 since thats currently the standard duct capacity
	var/amount = 1
	///I track them here because I have no idea how I'd make tgui loop like that
	var/static/list/possible_amounts = list(0,1,2,3,4,5)
	///The reagent we are producing. We are a typepath, but are also typecast because there's several occations where we need to use initial.
	var/datum/reagent/reagent_id = null
	///straight up copied from chem dispenser. Being a subtype would be extremely tedious and making it global would restrict potential subtypes using different dispensable_reagents
	var/list/dispensable_reagents = list(
		/datum/reagent/aluminium,
		/datum/reagent/bromine,
		/datum/reagent/carbon,
		/datum/reagent/chlorine,
		/datum/reagent/copper,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/fluorine,
		/datum/reagent/hydrogen,
		/datum/reagent/iodine,
		/datum/reagent/iron,
		/datum/reagent/lithium,
		/datum/reagent/mercury,
		/datum/reagent/nitrogen,
		/datum/reagent/oxygen,
		/datum/reagent/phosphorus,
		/datum/reagent/potassium,
		/datum/reagent/uranium/radium,
		/datum/reagent/silicon,
		/datum/reagent/sodium,
		/datum/reagent/stable_plasma,
		/datum/reagent/consumable/sugar,
		/datum/reagent/sulfur,
		/datum/reagent/toxin/acid,
		/datum/reagent/water,
		/datum/reagent/fuel,
	)
	//for mechcomp input stuff
	var/glue = "&"

/obj/machinery/plumbing/synthesizer/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply, bolt, layer)
	//lololol
	AddComponent(/datum/component/mechanics_holder)

	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Chemical to dispense", "mechcomp_update_chems")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set Glue", "set_glue")

/obj/machinery/plumbing/synthesizer/process(delta_time)
	if(machine_stat & NOPOWER || !reagent_id || !amount)
		return
	if(reagents.total_volume >= amount*delta_time*0.5) //otherwise we get leftovers, and we need this to be precise
		return
	reagents.add_reagent(reagent_id, amount*delta_time*0.5)
	use_power(active_power_usage * amount * delta_time * 0.5)

/obj/machinery/plumbing/synthesizer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemSynthesizer", name)
		ui.open()

/obj/machinery/plumbing/synthesizer/ui_data(mob/user)
	var/list/data = list()

	var/is_hallucinating = user.hallucinating()
	var/list/chemicals = list()

	for(var/A in dispensable_reagents)
		var/datum/reagent/R = GLOB.chemical_reagents_list[A]
		if(R)
			var/chemname = R.name
			if(is_hallucinating && prob(5))
				chemname = "[pick_list_replacements("hallucination.json", "chemicals")]"
			chemicals.Add(list(list("title" = chemname, "id" = lowertext(R.name))))
	data["chemicals"] = chemicals
	data["amount"] = amount
	data["possible_amounts"] = possible_amounts

	data["current_reagent"] = lowertext(initial(reagent_id.name))
	return data

/obj/machinery/plumbing/synthesizer/ui_act(action, params)
	. = ..()
	if(.)
		return
	. = TRUE
	switch(action)
		if("amount")
			var/new_amount = text2num(params["target"])
			if(new_amount in possible_amounts)
				amount = new_amount
				. = TRUE
		if("select")
			var/new_reagent = GLOB.name2reagent[params["reagent"]]
			if(new_reagent in dispensable_reagents)
				reagent_id = new_reagent
				. = TRUE
	update_icon()
	reagents.clear_reagents()

/obj/machinery/plumbing/synthesizer/update_overlays()
	. = ..()
	var/mutable_appearance/r_overlay = mutable_appearance(icon, "[icon_state]_overlay")
	if(reagent_id)
		r_overlay.color = initial(reagent_id.color)
	else
		r_overlay.color = "#FFFFFF"
	. += r_overlay

/obj/machinery/plumbing/synthesizer/proc/mechcomp_update_chems(datum/mechcompMessage/msg)
	var/err = 0
	var/list/signal = splittext(msg.signal, glue)

	if(length(signal) == 0 || length(signal) > 2)
		say("Invalid signal syntax! Proper signal syntax is: \[CHEM_NAME]&\[DISPENSE_AMOUNT(from 0 to 5 inclusive!)].")
		return


	//the following code is ugly af, so i am going to comment it because ladder ifs (like these) kinda suck ass.
	if(length(signal == 1))
		//only the chemical or amount has been passed, let's figure out which one.
		var/t2n = text2num(signal[1])
		//is it a number?
		if(!isnull(t2n))
			//oh, it's a number!
			if(t2n in possible_amounts)
				amount = t2n
			else
				//wait, it's an invalid number!
				err = 2
		else
			//it's not a number, therefore it must be a reagent name.
			var/new_chem =  GLOB.name2reagent[signal[1]]
			if(new_chem in dispensable_reagents)
				reagent_id = new_chem
			else
				//that chemical doesn't exist. Too bad!
				err = 2

	else
		//this part only executes if there are 2 parts in the signal, separated by a ";".
		var/new_reagent = get_chem_id(signal[1])
		if(new_reagent in dispensable_reagents)
			reagent_id = new_reagent
		else
			err += 2

		var/new_amount = text2num(signal[2])
		if(new_amount in possible_amounts)
			amount = new_amount
		else
			err += 1

	if(err)
		say("Invalid [err == 1 ? "chemical name!" : "[err == 2 ? "dispense amount!" : "chemical name and dispense amount!" ]" ] Proper signal syntax is: \[CHEM_NAME]&\[DISPENSE_AMOUNT(from 0 to 5 inclusive!)].")

/obj/machinery/plumbing/synthesizer/proc/set_glue(obj/item/I, mob/user)
	var/input = tgui_input_text(usr, "Set glue to what? Glue is used to \"glue\" lists together into a single string. Default glue for most cases is \"&\", but you can use another one if you want to use lists of lists. You can even use multiple symbols as glue! Make sure the list you pass to [src.name] uses the same glue!", "Glue", glue)
	if(!isnull(input))
		glue = input
		to_chat(user, span_notice("You set [src.name]'s glue to \"[glue]\""))
