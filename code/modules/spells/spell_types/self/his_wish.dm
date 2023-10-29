/datum/action/cooldown/spell/basic_heal/his_wish
	name = "Воззвать к Всевышнему"
	desc = "Позволяет забыть о боли на момент."
	spell_requirements = NONE
	cooldown_time = 60 SECONDS
	invocation = "﷽!"
	invocation_type = INVOCATION_SHOUT
	sound = 'white/valtos/sounds/Alah.ogg'
	button_icon_state = "spacetime"

/datum/action/cooldown/spell/basic_heal/his_wish/cast(mob/living/carbon/human/cast_on)
	. = ..()
	cast_on.adjustBruteLoss(-50)
	cast_on.adjustFireLoss(-50)
	cast_on.adjustOxyLoss(-50)
	cast_on.adjustStaminaLoss(-50)
	cast_on.adjustToxLoss(-50)
	cast_on.set_handcuffed(null)
	cast_on.update_handcuffed()
