/obj/item/organ/zombie_infection
	name = "некротическая опухоль"
	desc = "Отвратительная даже на вид, черная как смола и медленно растекающаяся в бесформенную лужу. Прозванная в народе гнойная слизь или же черная смерть. Ксенопаразит, медленно убивающий своего носителя и трансформирующий его в безмозглую и опасную тварь, преследуемую чудовищной жаждой плоти, крови и желанием распространить заразу дальше. И погодите... кажется она шевелится?"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_ZOMBIE
	icon_state = "blacktumor"
	var/causes_damage = TRUE
	var/datum/species/old_species = /datum/species/human
	var/datum/species/zombie_species = /datum/species/zombie/infectious
	var/living_transformation_time = 30
	var/converts_living = FALSE

	var/revive_time_min = 450
	var/revive_time_max = 700
	var/timer_id

/obj/item/organ/zombie_infection/Initialize(mapload)
	. = ..()
	if(iscarbon(loc))
		Insert(loc)
	GLOB.zombie_infection_list += src

/obj/item/organ/zombie_infection/Destroy()
	GLOB.zombie_infection_list -= src
	. = ..()

/obj/item/organ/zombie_infection/Insert(mob/living/carbon/M, special = 0)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/organ/zombie_infection/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	if(iszombie(M) && old_species && !QDELETED(M))
		M.set_species(old_species)
	if(timer_id)
		deltimer(timer_id)

/obj/item/organ/zombie_infection/on_find(mob/living/finder)
	to_chat(finder, "<span class='warning'>Внутри головы находится огромная, черная как смола опухоль, \
		распустившая свои метастазы, и как паутина, оплела мозг жертвы. Это выглядит очень мерзко и страшно...</span>")

/obj/item/organ/zombie_infection/process(delta_time)
	if(!owner)
		return
	if(!(src in owner.internal_organs))
		Remove(owner)
	if(owner.mob_biotypes & MOB_MINERAL)//does not process in inorganic things
		return
	if (causes_damage && !iszombie(owner) && owner.stat != DEAD)
		owner.adjustToxLoss(0.5 * delta_time)
		if(DT_PROB(5, delta_time))
			to_chat(owner, span_danger("Мне очень плохо... У меня болит голова, а во рту вкус мяса..."))
	if(timer_id)
		return
	if(owner.suiciding)
		return
	if(owner.stat != DEAD && !converts_living)
		return
	if(!owner.getorgan(/obj/item/organ/brain))
		return
	if(!iszombie(owner))
		to_chat(owner, "<span class='cultlarge'>Я чувствую как мое сердце не бьется... но... что-то не так... \
		я еще жив? Во рту вкус крови... Что значит жить? Хочу есть... Кто я? Так холодно... Я мертв? Нужно найти что то теплое... А что значит Я? Еда... \
		Какая разница... я хочу есть... Я ХОЧУ ЖРАТЬ!</span>")
	var/revive_time = rand(revive_time_min, revive_time_max)
	var/flags = TIMER_STOPPABLE
	timer_id = addtimer(CALLBACK(src, PROC_REF(zombify)), revive_time, flags)

/obj/item/organ/zombie_infection/proc/zombify()
	timer_id = null

	if(!converts_living && owner.stat != DEAD)
		return

	if(!iszombie(owner))
		old_species = owner.dna.species.type
		owner.set_species(zombie_species)

//	var/stand_up = (owner.stat == DEAD) || (owner.stat == UNCONSCIOUS)

	//Fully heal the zombie's damage the first time they rise
	owner.setToxLoss(0, 0)
	owner.setOxyLoss(0, 0)
	owner.heal_overall_damage(INFINITY, INFINITY, INFINITY, null, TRUE)

	if(!owner.revive(full_heal = FALSE, admin_revive = FALSE))
		return

	owner.grab_ghost()
	owner.visible_message(span_danger("[owner] внезапно дергается, открывает затянутые мутной пеленой глаза... В этом мертвом взгляде нет даже проблеска сознания, лишь только бесконечный голод...") , span_alien("Я-я-я хочу ЖРАААТЬ!"))
	playsound(owner.loc, 'sound/hallucinations/far_noise.ogg', 50, TRUE)
	owner.do_jitter_animation(living_transformation_time)
	owner.Stun(living_transformation_time)
	to_chat(owner, span_alertalien("Ты мертв! Но твоя \"не жизнь\" только начинается! Ты не помнишь ничего о происходящем, все эти люди вокруг теперь всего лишь еда! Твои мертвые товарищи тебе абсолютно не интересны и у тебя нет никакого желания нападать на них! Ты гоним лишь жаждой плоти, и даже смерть не остановит тебя!"))

/obj/item/organ/zombie_infection/nodamage
	causes_damage = FALSE
