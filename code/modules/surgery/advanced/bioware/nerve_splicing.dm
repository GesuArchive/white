/datum/surgery/advanced/bioware/nerve_splicing
	name = "Модифицирование: Сращивание Нервов"
	desc = "Хирургическая процедура при которой нервы пациента сращиваются, что увеличивает сопротивление оглушению."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/splice_nerves,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)
	bioware_target = BIOWARE_NERVES

/datum/surgery_step/splice_nerves
	name = "сращивание нервов"
	accept_hand = TRUE
	time = 155

/datum/surgery_step/splice_nerves/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю соединять между собой нервы [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начал соединять между собой нервы [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начал работать с нервной системой [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/splice_nerves/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Успешно срастил нервную систему [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] успешно переплел нервную систему [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] закончил работать с нервной системой [skloname(target.name, RODITELNI, target.gender)]."))
	new /datum/bioware/spliced_nerves(target)
	return ..()

/datum/bioware/spliced_nerves
	name = "Сращенные нервы"
	desc = "Нервы соединены друг с другом по нескольку раз, значительно снижая эффективность оглущающих эффектов."
	mod_type = BIOWARE_NERVES

/datum/bioware/spliced_nerves/on_gain()
	..()
	owner.physiology.stun_mod *= 0.5

/datum/bioware/spliced_nerves/on_lose()
	..()
	owner.physiology.stun_mod *= 2
