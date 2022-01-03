/obj/item/organ/kidneys
	name = "почки"
	desc = "Пахнут неприятно."
	icon_state = "kidneys"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_KIDNEYS

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = span_info("Ноющая боль появляется и исчезает в боку...")
	high_threshold_passed = span_warning("Что-то в боку болит, и боль не утихает. Хочется в туалет.")
	now_fixed = span_info("В боку перестаёт болеть.")
	high_threshold_cleared = span_info("Боль в боку утихла и больше не хочется в туалет.")

	food_reagents = list(/datum/reagent/consumable/nutriment/organ_tissue = 5)

	var/metabolism_efficiency = 0.03
	var/operated = FALSE

	reagent_vol = 300

/obj/item/organ/kidneys/Initialize()
	. = ..()
	//None edible organs do not get a reagent holder by default
	if(!reagents)
		create_reagents(reagent_vol, REAGENT_HOLDER_ALIVE)
	else
		reagents.flags |= REAGENT_HOLDER_ALIVE

/obj/item/organ/kidneys/on_life(delta_time, times_fired)
	. = ..()
	var/mob/living/carbon/human/body = owner
	var/datum/reagent/uri = locate(/datum/reagent/toxin/urine) in reagents.reagent_list

	if(uri?.volume > reagent_vol)
		body.try_pee(TRUE)

	if(body?.hydration <= 5)
		applyOrganDamage(0.1)

	if(body?.hydration)
		body.hydration -= delta_time * metabolism_efficiency
		reagents.add_reagent(/datum/reagent/toxin/urine, delta_time * metabolism_efficiency)

	if(damage < low_threshold)
		return

	if(damage > high_threshold && DT_PROB(0.5 * damage, delta_time))
		to_chat(body, span_warning("В боку болит и больше не выходит сдерживаться!"))
		body.try_pee(TRUE)

/obj/item/organ/kidneys/get_availability(datum/species/S)
	return !(NOKIDNEYS in S.inherent_traits)

/obj/item/organ/kidneys/fly
	desc = "Почернели от ракетного топлива. Ну ксеносы, ну тупые!"
	icon_state = "kidneys-x"

/obj/item/organ/kidneys/cybernetic
	name = "базовые кибернетические почки"
	icon_state = "kidneys-c"
	desc = "Базовое устройство, имитирующее функции человеческих почек."
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5
	var/emp_vulnerability = 80
	metabolism_efficiency = 0.05

/obj/item/organ/kidneys/cybernetic/tier2
	name = "кибернетические почки"
	icon_state = "kidneys-c-u"
	desc = "Усовершенствованное устройство, превосходящее функции человеческих почек."
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	emp_vulnerability = 40
	metabolism_efficiency = 0.02

/obj/item/organ/kidneys/cybernetic/tier3
	name = "продвинутые кибернетические почки"
	icon_state = "kidneys-c-u2"
	desc = "Эта версия кибернетических почек имеет огромный внутренний запас."
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	emp_vulnerability = 20
	metabolism_efficiency = 0.01

/obj/item/organ/kidneys/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown))
		owner.try_pee(TRUE)
		COOLDOWN_START(src, severe_cooldown, 10 SECONDS)
	if(prob(emp_vulnerability/severity))
		organ_flags |= ORGAN_SYNTHETIC_EMP

/obj/effect/decal/cleanable/urine
	name = "лужа мочи"
	desc = "Выглядит не вкусно."
	icon_state = "urine"
	density = 0
	layer = 3
	icon = 'white/valtos/icons/exrp/smetanka.dmi'
	anchored = 1

/datum/emote/living/pee
	key = "pee"
	ru_name = "намочить"
	key_third_person = "pees on the floor"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/pee/run_emote(mob/living/user, params)
	. = ..()
	if(.)
		user.try_pee()
