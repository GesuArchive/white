/obj/structure/flora/rock/boulder
	name = "валун"
	desc = "Пахнет чудесно."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "boulder1"
	randomize_icon = FALSE

/obj/structure/flora/rock/boulder/Destroy()
	. = ..()
	for(var/obj/structure/flora/rock/boulder/B in orange(2))
		if(mineResult && mineAmount)
			new mineResult(B.loc, mineAmount)
		qdel(B)

/obj/structure/madman_computer
	name = "компьютер"
	desc = "Выглядит незавершённым."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "madman"

/obj/structure/madman_computer/attack_hand(mob/user)
	. = ..()
	flick("madman_say", src)
	say(pick("Вы чё, тупые, бля?", \
			"За смешнявки буду кидать в дурку. Вы были предупреждены.", \
			"Когда именно - не скажу и говорить не буду.", \
			"Лан, ребята, это катастрофа.", \
			"ЖДЁМ, НАДЕЕМСЯ, ВЕРИМ. Новый хост в процессе тестового прогона.", \
			"Переносу - быть.", \
			"Вы вылетите отсюда так быстро, как и прилетели.", \
			"Я поясню ситуацию немного."))
