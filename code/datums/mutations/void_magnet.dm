/datum/mutation/human/void
	name = "Слияние с пустотой"
	desc = "Редкий геном, способный преодолеть законы эвклидового пространства и укрыть носителя за завесой мрачной и холодной пустоты мертвого космоса."
	quality = MINOR_NEGATIVE //upsides and downsides
	text_gain_indication = span_notice("Я ощущаю невероятную взгляд чего-то древнего и бесконечно огромного.")
	instability = 10
	power_path = /datum/action/cooldown/spell/void
	energy_coeff = 1
	synchronizer_coeff = 1

/datum/mutation/human/void/on_life(delta_time, times_fired)
	// Move this onto the spell itself at some point?
	var/datum/action/cooldown/spell/void/curse = locate(power_path) in owner
	if(!curse)
		remove()
		return

	if(!curse.is_valid_target(owner))
		return

	//very rare, but enough to annoy you hopefully. + 0.5 probability for every 10 points lost in stability
	if(DT_PROB((0.25 + ((100 - dna.stability) / 40)) * GET_MUTATION_SYNCHRONIZER(src), delta_time))
		curse.cast(owner)

/datum/action/cooldown/spell/void
	name = "Зов пустоты" //magic the gathering joke here
	desc = "Редкий геном, способный преодолеть законы эвклидового пространства и укрыть носителя за завесой мрачной и холодной пустоты мертвого космоса. Пустота непредсказуема и иногда сама может посетить вас..."
	button_icon_state = "void_magnet"

	school = SCHOOL_EVOCATION
	cooldown_time = 1 MINUTES

	invocation = "Есть только пустота..."
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	antimagic_flags = NONE

/datum/action/cooldown/spell/void/is_valid_target(atom/cast_on)
	return isturf(cast_on.loc)

/datum/action/cooldown/spell/void/cast(atom/cast_on)
	. = ..()
	new /obj/effect/immortality_talisman/void(get_turf(cast_on), cast_on)
