/obj/item/reagent_containers/dropper
	name = "пипетка"
	desc = "Пипетка, вместимостью до 5 единиц."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dropper0"
	worn_icon_state = "pen"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1, 2, 3, 4, 5)
	volume = 5
	reagent_flags = TRANSPARENT
	custom_price = PAYCHECK_MEDIUM

/obj/item/reagent_containers/dropper/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(!target.reagents)
		return

	if(reagents.total_volume > 0)
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='notice'>[target] заполнена.</span>")
			return

		if(!target.is_injectable(user))
			to_chat(user, "<span class='warning'>Не могу переместить реагенты в [target]!</span>")
			return

		var/trans = 0
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)

		if(ismob(target))
			if(ishuman(target))
				var/mob/living/carbon/human/victim = target

				var/obj/item/safe_thing = victim.is_eyes_covered()

				if(safe_thing)
					if(!safe_thing.reagents)
						safe_thing.create_reagents(100)

					trans = reagents.trans_to(safe_thing, amount_per_transfer_from_this, transfered_by = user, methods = TOUCH)

					target.visible_message("<span class='danger'>[user] пытается капнуть чем-то в глаза [target], но у него не выходит!</span>", \
											"<span class='userdanger'>[user] пытается капнуть чем-то в мои глаза, но у него не выходит!</span>")

					to_chat(user, "<span class='notice'>Я перенес [trans] единиц раствора.</span>")
					update_icon()
					return
			else if(isalien(target)) //hiss-hiss has no eyes!
				to_chat(target, "<span class='danger'>Похоже, у [target] нет глаз!</span>")
				return

			target.visible_message("<span class='danger'>[user] закапал что-то в глаза [target]!</span>", \
									"<span class='userdanger'>[user] закапал что-то в мои глаза!</span>")

			reagents.expose(target, TOUCH, fraction)
			var/mob/M = target
			var/R
			if(reagents)
				for(var/datum/reagent/A in src.reagents.reagent_list)
					R += "[A] ([num2text(A.volume)]),"

			log_combat(user, M, "squirted", R)

		trans = src.reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, "<span class='notice'>Я перенес [trans] единиц раствора.</span>")
		update_icon()

	else

		if(!target.is_drawable(user, FALSE)) //No drawing from mobs here
			to_chat(user, "<span class='warning'>Я не могу напрямую извлечь реагенты из [target]!</span>")
			return

		if(!target.reagents.total_volume)
			to_chat(user, "<span class='warning'>[target] пуста!</span>")
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)

		to_chat(user, "<span class='notice'>Я наполняю [src] [trans] единицами раствора.</span>")

		update_icon()

/obj/item/reagent_containers/dropper/update_overlays()
	. = ..()
	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "dropper")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		. += filling
