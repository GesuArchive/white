#define SIN_ACEDIA "апатия"
#define SIN_GLUTTONY "голод"
#define SIN_GREED "жадность"
#define SIN_SLOTH "лень"
#define SIN_WRATH "гнев"
#define SIN_ENVY "зависть"
#define SIN_PRIDE "гордыня"

/datum/antagonist/sintouched
	name = "грешник"
	roundend_category = "sintouched"
	antagpanel_category = "Devil"
	antag_hud_name = "sintouched"
	var/sin
	greentext_reward = 5

	var/static/list/sins = list(SIN_ACEDIA,SIN_GLUTTONY,SIN_GREED,SIN_SLOTH,SIN_WRATH,SIN_ENVY,SIN_PRIDE)

/datum/antagonist/sintouched/New()
	. = ..()
	sin = pick(sins)

/datum/antagonist/sintouched/proc/forge_objectives()
	var/datum/objective/sintouched/O
	switch(sin)//traditional seven deadly sins... except lust.
		if(SIN_ACEDIA)
			O = new /datum/objective/sintouched/acedia
		if(SIN_GLUTTONY)
			O = new /datum/objective/sintouched/gluttony
		if(SIN_GREED)
			O = new /datum/objective/sintouched/greed
		if(SIN_SLOTH)
			O = new /datum/objective/sintouched/sloth
		if(SIN_WRATH)
			O = new /datum/objective/sintouched/wrath
		if(SIN_ENVY)
			O = new /datum/objective/sintouched/envy
		if(SIN_PRIDE)
			O = new /datum/objective/sintouched/pride
	objectives += O

/datum/antagonist/sintouched/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/sintouched/greet()
	owner.announce_objectives()

/datum/antagonist/sintouched/roundend_report()
	return printplayer(owner)

/datum/antagonist/sintouched/admin_add(datum/mind/new_owner,mob/admin)
	var/choices = sins + "Случайно"
	var/chosen_sin = tgui_input_list(admin, "Какой вид?", "Вид греха", sort_list(choices))
	if(!chosen_sin)
		return
	if(chosen_sin in sins)
		sin = chosen_sin
	. = ..()

#undef SIN_ACEDIA
#undef SIN_ENVY
#undef SIN_GLUTTONY
#undef SIN_GREED
#undef SIN_PRIDE
#undef SIN_SLOTH
#undef SIN_WRATH
