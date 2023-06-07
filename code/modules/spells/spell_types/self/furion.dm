
/datum/action/cooldown/spell/furion
	name = "Забрать шекели"
	desc = "У глупых гоев."
	button_icon_state = "ultimate"
	sound = 'white/valtos/sounds/fcast.ogg'
	button_icon = 'white/valtos/icons/actions.dmi'

	school = SCHOOL_TRANSMUTATION

	cooldown_time = 60 SECONDS
	cooldown_reduction_per_rank = 10 SECONDS

/datum/action/cooldown/spell/furion/cast(atom/cast_on)
	. = ..()
	var/total_cash_looted = 0
	var/atom/lastloc = cast_on
	for(var/B in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/A = SSeconomy.bank_accounts_by_id[B]
		if(A.account_balance < 10)
			continue
		var/credits_drawed = round(A.account_balance / 2)
		A._adjust_money(-credits_drawed)
		for(var/obj/BC in A.bank_cards)
			var/mob/card_holder = recursive_loc_check(BC, /mob)
			if(ismob(card_holder))
				playsound(get_turf(card_holder), 'white/valtos/sounds/fhit.ogg', 75, TRUE)
				card_holder.Beam(lastloc, icon_state="lichbeam", time = 20)
				lastloc = card_holder
				to_chat(card_holder, span_warning("<b>Федерация волшебников:</b> С аккаунта было списано [credits_drawed] кредит[get_num_string(credits_drawed)]. Приятной смены!"))
		total_cash_looted += credits_drawed
		sleep(5)
	lastloc.Beam(cast_on, icon_state="lichbeam", time = 20)
	var/obj/item/holochip/holochip = new (cast_on.drop_location(), total_cash_looted)
	if(ishuman(cast_on))
		var/mob/living/carbon/human/H = cast_on
		H.put_in_hands(holochip)
	to_chat(cast_on, span_notice("Удалось собрать с проклятых гоев целых [total_cash_looted] кредит[get_num_string(total_cash_looted)]!"))
