/datum/syndicate_contract
	var/id = 0
	var/status = CONTRACT_STATUS_INACTIVE
	var/datum/objective/contract/contract = new()
	var/target_rank
	var/ransom = 0
	var/payout_type
	var/wanted_message

	var/list/victim_belongings = list()

/datum/syndicate_contract/New(contract_owner, blacklist, type=CONTRACT_PAYOUT_SMALL)
	contract.owner = contract_owner
	payout_type = type

	generate(blacklist)

/datum/syndicate_contract/proc/generate(blacklist)
	contract.find_target(null, blacklist)

	var/datum/data/record/record
	if (contract.target)
		record = find_record("name", contract.target.name, GLOB.data_core.general)

	if (record)
		target_rank = record.fields["rank"]
	else
		target_rank = "Неизвестный"

	if (payout_type == CONTRACT_PAYOUT_LARGE)
		contract.payout_bonus = rand(9,13)
	else if (payout_type == CONTRACT_PAYOUT_MEDIUM)
		contract.payout_bonus = rand(6,8)
	else
		contract.payout_bonus = rand(2,4)

	contract.payout = rand(0, 2)
	contract.generate_dropoff()

	ransom = 100 * rand(18, 45)

	var/base = pick_list(WANTED_FILE, "basemessage")
	var/verb_string = pick_list(WANTED_FILE, "verb")
	var/noun = pick_list_weighted(WANTED_FILE, "noun")
	var/location = pick_list_weighted(WANTED_FILE, "location")
	wanted_message = "[base] [verb_string] [noun] [location]."

/datum/syndicate_contract/proc/handle_extraction(mob/living/user)
	if (contract.target && contract.dropoff_check(user, contract.target.current))

		var/turf/free_location = find_obstruction_free_location(3, user, contract.dropoff)

		if (free_location)
			// We've got a valid location, launch.
			launch_extraction_pod(free_location)
			return TRUE

	return FALSE

// Launch the pod to collect our victim.
/datum/syndicate_contract/proc/launch_extraction_pod(turf/empty_pod_turf)
	var/obj/structure/closet/supplypod/extractionpod/empty_pod = new()

	RegisterSignal(empty_pod, COMSIG_ATOM_ENTERED, .proc/enter_check)

	empty_pod.stay_after_drop = TRUE
	empty_pod.reversing = TRUE
	empty_pod.explosionSize = list(0,0,0,1)
	empty_pod.leavingSound = 'sound/effects/podwoosh.ogg'

	new /obj/effect/pod_landingzone(empty_pod_turf, empty_pod)

/datum/syndicate_contract/proc/enter_check(datum/source, sent_mob)
	if (istype(source, /obj/structure/closet/supplypod/extractionpod))
		if (isliving(sent_mob))
			var/mob/living/M = sent_mob
			var/datum/antagonist/traitor/traitor_data = contract.owner.has_antag_datum(/datum/antagonist/traitor)

			if (M == contract.target.current)
				traitor_data.contractor_hub.contract_TC_to_redeem += contract.payout
				traitor_data.contractor_hub.contracts_completed += 1

				if (M.stat != DEAD)
					traitor_data.contractor_hub.contract_TC_to_redeem += contract.payout_bonus

				status = CONTRACT_STATUS_COMPLETE

				if (traitor_data.contractor_hub.current_contract == src)
					traitor_data.contractor_hub.current_contract = null

				traitor_data.contractor_hub.contract_rep += 2
			else
				status = CONTRACT_STATUS_ABORTED // Sending a target that wasn't even yours is as good as just aborting it

				if (traitor_data.contractor_hub.current_contract == src)
					traitor_data.contractor_hub.current_contract = null

			if (iscarbon(M))
				for(var/obj/item/W in M)
					if (ishuman(M))
						var/mob/living/carbon/human/H = M
						if(W == H.w_uniform)
							continue //So all they're left with are shoes and uniform.
						if(W == H.shoes)
							continue


					M.transferItemToLoc(W)
					victim_belongings.Add(W)

			var/obj/structure/closet/supplypod/extractionpod/pod = source

			// Handle the pod returning
			pod.startExitSequence(pod)

			if (ishuman(M))
				var/mob/living/carbon/human/target = M

				// After we remove items, at least give them what they need to live.
				target.dna.species.give_important_for_life(target)

			// After pod is sent we start the victim narrative/heal.
			handleVictimExperience(M)

			// This is slightly delayed because of the sleep calls above to handle the narrative.
			// We don't want to tell the station instantly.
			var/points_to_check
			var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_STA)
			if(D)
				points_to_check = D.account_balance
			if(points_to_check >= ransom)
				D.adjust_money(-ransom)
			else
				D.adjust_money(-points_to_check)

			priority_announce("Один из членов экипажа был захвачена конкурирующей организацией - нам нужно заплатить выкуп, чтобы вернуть их. \
							В соответствии с политикой мы взяли часть средств станции, чтобы компенсировать общую стоимость.", null, null, null, "Защита Активов Нанотрейзен")

			sleep(30)

			// Pay contractor their portion of ransom
			if (status == CONTRACT_STATUS_COMPLETE)
				var/obj/item/card/id/C = contract.owner.current?.get_idcard(TRUE)

				if(C?.registered_account)
					C.registered_account.adjust_money(ransom * 0.35)

					C.registered_account.bank_card_talk("Мы обработали выкуп, агент. Вот ваша доля в размере [C.registered_account.account_balance] кредит[get_num_string(C.registered_account.account_balance)].", TRUE)

// They're off to holding - handle the return timer and give some text about what's going on.
/datum/syndicate_contract/proc/handleVictimExperience(mob/living/M)
	// Ship 'em back - dead or alive, 4 minutes wait.
	// Even if they weren't the target, we're still treating them the same.
	addtimer(CALLBACK(src, .proc/returnVictim, M), (60 * 10) * 4)

	if (M.stat != DEAD)
		// Heal them up - gets them out of crit/soft crit. If omnizine is removed in the future, this needs to be replaced with a
		// method of healing them, consequence free, to a reasonable amount of health.
		M.reagents.add_reagent(/datum/reagent/medicine/omnizine, 20)

		M.flash_act()
		M.add_confusion(10)
		M.blur_eyes(5)
		to_chat(M, span_warning("Ощущаю себя странно..."))
		sleep(60)
		to_chat(M, span_warning("Эта капсула сделала что-то со мной..."))
		M.Dizzy(35)
		sleep(65)
		to_chat(M, span_warning("Моя голова разрывается... Похоже мозг хочет вырваться из моей головы!"))
		M.flash_act()
		M.add_confusion(20)
		M.blur_eyes(3)
		sleep(30)
		to_chat(M, span_warning("Моя голова разрывается..."))
		sleep(100)
		M.flash_act()
		M.Unconscious(200)
		to_chat(M, "<span class='reallybig hypnophrase'>Миллион голосов эхом звучит в голове... <i>\"В вашем уме много ценных секретов - \
					мы благодарим вас за предоставление их нам. Ваша стоимость исчерпана, и вы будете возвращены обратно на свою станцию. Нам всегда платят, \
					так что это только вопрос времени, когда мы отправим вас обратно...\"</i></span>")
		M.blur_eyes(10)
		M.Dizzy(15)
		M.add_confusion(20)

// We're returning the victim
/datum/syndicate_contract/proc/returnVictim(mob/living/M)
	var/list/possible_drop_loc = list()

	for (var/turf/possible_drop in contract.dropoff.contents)
		if (!isspaceturf(possible_drop) && !isclosedturf(possible_drop))
			if (!possible_drop.is_blocked_turf())
				possible_drop_loc.Add(possible_drop)

	if (possible_drop_loc.len > 0)
		var/pod_rand_loc = rand(1, possible_drop_loc.len)

		var/obj/structure/closet/supplypod/return_pod = new()
		return_pod.bluespace = TRUE
		return_pod.explosionSize = list(0,0,0,0)
		return_pod.style = STYLE_SYNDICATE

		do_sparks(8, FALSE, M)
		M.visible_message(span_notice("<b>[M]</b> исчезает..."))

		for(var/obj/item/W in M)
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				if(W == H.w_uniform)
					continue //So all they're left with are shoes and uniform.
				if(W == H.shoes)
					continue
			M.dropItemToGround(W)

		for(var/obj/item/W in victim_belongings)
			W.forceMove(return_pod)

		M.forceMove(return_pod)

		M.flash_act()
		M.blur_eyes(30)
		M.Dizzy(35)
		M.add_confusion(20)

		new /obj/effect/pod_landingzone(possible_drop_loc[pod_rand_loc], return_pod)
	else
		to_chat(M, "<span class='reallybig hypnophrase'>Миллион голосов эхом звучит в голове... <i>\"Кажется, капсула, на которой вы сюда прибыли \
					не в состоянии найти подходящее место для отправки вас назад... Вы умрете здесь вместо отправки.\"</i></span>")
		if (iscarbon(M))
			var/mob/living/carbon/C = M
			if (C.can_heartattack())
				C.set_heartattack(TRUE)
