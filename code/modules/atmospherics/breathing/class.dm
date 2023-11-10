// Breathing classes are, yes, just a list of gases, associated with numbers.
// But they're very simple: pluoxium's status as O2 * 8 is represented here,
// with a single line of code, no hardcoding and special-casing across the codebase.
// Not only that, but they're very general: you could have a negative value
// to simulate asphyxiants, e.g. if I add krypton it could go into the oxygen
// breathing class at -7, simulating krypton narcosis.

#define BREATH_OXY		/datum/breathing_class/oxygen
#define BREATH_PLASMA	/datum/breathing_class/plasma

/datum/breathing_class
	var/list/gases = null
	var/list/products = null
	var/danger_reagent = null
	var/low_alert_category = "not_enough_oxy"
	var/low_alert_datum =  /atom/movable/screen/alert/not_enough_oxy
	var/high_alert_category = "too_much_oxy"
	var/high_alert_datum =  /atom/movable/screen/alert/too_much_oxy

/datum/breathing_class/proc/get_effective_pp(datum/gas_mixture/breath)
	var/mol = 0
	for(var/gas in gases)
		mol += breath.get_moles(gas) * gases[gas]
	return (mol/breath.total_moles()) * breath.return_pressure()

/datum/breathing_class/oxygen
	gases = list(
		/datum/gas/oxygen = 1,
		/datum/gas/pluoxium = 8,
		/datum/gas/carbon_dioxide = -0.7, // CO2 isn't actually toxic, just an asphyxiant
	)
	products = list(
		/datum/gas/carbon_dioxide = 1,
	)

/datum/breathing_class/plasma
	gases = list(
		/datum/gas/plasma = 1
	)
	products = list(
		/datum/gas/carbon_dioxide = 1
	)
	low_alert_category = "not_enough_tox"
	low_alert_datum = /atom/movable/screen/alert/not_enough_tox
	high_alert_category = "too_much_tox"
	high_alert_datum = /atom/movable/screen/alert/too_much_tox