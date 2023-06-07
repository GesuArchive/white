// NOTE: All Targeted spells are Toggles! We just don't bother checking here.
/datum/action/bloodsucker/targeted
	power_flags = BP_AM_TOGGLE

	var/target_range = 99
	var/prefire_message = ""
	///Most powers happen the moment you click. Some, like Mesmerize, require time and shouldn't cost you if they fail.
	var/power_activates_immediately = TRUE
	///Is this power LOCKED due to being used?
	var/power_in_use = FALSE

/// Modify description to add notice that this is aimed.
/datum/action/bloodsucker/targeted/New(Target)
	desc += "<br>\[<i>Targeted Power</i>\]"
	. = ..()

/datum/action/bloodsucker/targeted/proc/InterceptClickOn(mob/living/caller, params, atom/click_target)
	return ClickWithPower(click_target)

/datum/action/bloodsucker/targeted/Trigger(trigger_flags, atom/target)
	if(active)
		if(target)
			// For automatic / mob handling
			return InterceptClickOn(owner, null, target)

		var/datum/action/bloodsucker/targeted/already_set = owner.click_intercept
		if(already_set == src)
			already_set.DeactivatePower()
			return FALSE

		else if(istype(already_set))
			already_set.DeactivatePower()

	if(!CheckCanPayCost(owner) || !CheckCanUse(owner))
		return FALSE

	owner.click_intercept = src

	ActivatePower()
	build_all_button_icons()
	// Create & Link Targeting Proc
	if(prefire_message != "")
		to_chat(owner, span_announce("[prefire_message]"))
	return TRUE

/datum/action/bloodsucker/targeted/DeactivatePower()
	if(power_flags & BP_AM_TOGGLE)
		UnregisterSignal(owner, COMSIG_LIVING_BIOLOGICAL_LIFE)
	active = FALSE
	owner.click_intercept = null
	build_all_button_icons()
//	..() // we don't want to pay cost here

/// Check if target is VALID (wall, turf, or character?)
/datum/action/bloodsucker/targeted/proc/CheckValidTarget(atom/target_atom)
	if(target_atom == owner)
		return FALSE
	return TRUE

/// Check if valid target meets conditions
/datum/action/bloodsucker/targeted/proc/CheckCanTarget(atom/target_atom)
	// Out of Range
	if(!(target_atom in view(target_range, owner)))
		if(target_range > 1) // Only warn for range if it's greater than 1. Brawn doesn't need to announce itself.
			to_chat(owner, "Target out of range.")
		return FALSE
	return istype(target_atom)

/// Click Target
/datum/action/bloodsucker/targeted/proc/ClickWithPower(atom/target_atom)
	// CANCEL RANGED TARGET check
	if(power_in_use || !CheckValidTarget(target_atom))
		return FALSE
	// Valid? (return true means DON'T cancel power!)
	if(!CheckCanPayCost() || !CheckCanUse(owner) || !CheckCanTarget(target_atom))
		return TRUE
	power_in_use = TRUE // Lock us into this ability until it successfully fires off. Otherwise, we pay the blood even if we fail.
	FireTargetedPower(target_atom) // We use this instead of ActivatePower(), which has no input
	// Skip this part so we can return TRUE right away.
	if(power_activates_immediately)
		PowerActivatedSuccessfully() // Mesmerize pays only after success.
	power_in_use = FALSE
	return TRUE

/// Like ActivatePower, but specific to Targeted (and takes an atom input). We don't use ActivatePower for targeted.
/datum/action/bloodsucker/targeted/proc/FireTargetedPower(atom/target_atom)
	log_combat(owner, target_atom, "used [name] on")

/// The power went off! We now pay the cost of the power.
/datum/action/bloodsucker/targeted/proc/PowerActivatedSuccessfully()
	PayCost()
	DeactivatePower()
	StartCooldown()	// Do AFTER UpdateIcon() inside of DeactivatePower. Otherwise icon just gets wiped.
