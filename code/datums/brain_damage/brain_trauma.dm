//Brain Traumas are the new actual brain damage. Brain damage itself acts as a way to acquire traumas: every time brain damage is dealt, there's a chance of receiving a trauma.
//This chance gets higher the higher the mob's brainloss is. Removing traumas is a separate thing from removing brain damage: you can get restored to full brain operativity,
// but keep the quirks, until repaired by neurine, surgery, lobotomy or magic; depending on the resilience
// of the trauma.

/datum/brain_trauma
	var/name = "Травма мозга"
	var/desc = "Травма, вызванная повреждением головного мозга, которая вызывает проблемы у пациента."
	var/scan_desc = "общая черепно-мозговая травма" //description when detected by a health scanner
	var/mob/living/carbon/owner //the poor bastard
	var/obj/item/organ/brain/brain //the poor bastard's brain
	var/gain_text = span_notice("Вы чувствуете себя травмированным.")
	var/lose_text = span_notice("Вы больше не чувствуете себя травмированным.")
	var/can_gain = TRUE
	var/random_gain = TRUE //can this be gained through random traumas?
	var/resilience = TRAUMA_RESILIENCE_BASIC //how hard is this to cure?

/datum/brain_trauma/Destroy()
	if(brain?.traumas)
		brain.traumas -= src
	if(owner)
		on_lose()
	brain = null
	owner = null
	return ..()

//Called on life ticks
/datum/brain_trauma/proc/on_life(delta_time, times_fired)
	return

//Called on death
/datum/brain_trauma/proc/on_death()
	return

//Called when given to a mob
/datum/brain_trauma/proc/on_gain()
	to_chat(owner, gain_text)
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))
	owner.psih_hud_set_status()

//Called when removed from a mob
/datum/brain_trauma/proc/on_lose(silent)
	if(!silent)
		to_chat(owner, lose_text)
	UnregisterSignal(owner, COMSIG_MOB_SAY)
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	owner.psih_hud_set_status()

//Called when hearing a spoken message
/datum/brain_trauma/proc/handle_hearing(datum/source, list/hearing_args)
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)

//Called when speaking
/datum/brain_trauma/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOB_SAY)
