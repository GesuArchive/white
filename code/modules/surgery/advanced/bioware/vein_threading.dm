/datum/surgery/advanced/bioware/vein_threading
	name = "Переплетение вен"
	desc = "Хирургическая процедура, которая значительно снижает количество теряемой крови при ранениях."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/thread_veins,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)
	bioware_target = BIOWARE_CIRCULATION

/datum/surgery_step/thread_veins
	name = "Переплетение вен"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/thread_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю переплетать кровеносную систему [target].</span>",
		"<span class='notice'>[user] начал переплетать кровеносную систему [target].</span>",
		"<span class='notice'>[user] начал работать над кровеносной системой [target].</span>")

/datum/surgery_step/thread_veins/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>Я сплел кровеносную систему [target] в прочную сеть!</span>",
		"<span class='notice'>[user] сплел кровеносную систему [target] в прочную сеть!</span>",
		"<span class='notice'>[user] закончил работать над кровеносной системой [target].</span>")
	new /datum/bioware/threaded_veins(target)
	return ..()

/datum/bioware/threaded_veins
	name = "Переплетенные вены"
	desc = "Система кровообращения сплетена в сеть, значительно снижающую количество теряемой при ранениях крови."
	mod_type = BIOWARE_CIRCULATION

/datum/bioware/threaded_veins/on_gain()
	..()
	owner.physiology.bleed_mod *= 0.25

/datum/bioware/threaded_veins/on_lose()
	..()
	owner.physiology.bleed_mod *= 4
