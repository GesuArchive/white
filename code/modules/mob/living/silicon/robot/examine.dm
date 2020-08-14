/mob/living/silicon/robot/examine(mob/user)
	. = list("<span class='info'>Это же [icon2html(src, user)] <EM>[src]</EM>!<hr>")
	if(desc)
		. += "[desc]<hr>"

	var/obj/act_module = get_active_held_item()
	if(act_module)
		. += "Он держит [icon2html(act_module, user)] [act_module].\n"
	. += status_effect_examines()
	if (getBruteLoss())
		if (getBruteLoss() < maxHealth*0.5)
			. += "<span class='warning'>Выглядит немного побитым.</span>\n"
		else
			. += "<span class='warning'><B>Выглядит сильно побитым!</B></span>\n"
	if (getFireLoss() || getToxLoss())
		var/overall_fireloss = getFireLoss() + getToxLoss()
		if (overall_fireloss < maxHealth * 0.5)
			. += "<span class='warning'>Выглядит немного обугленным.</span>\n"
		else
			. += "<span class='warning'><B>Выглядит так, будто его прожарили в печи!</B></span>\n"
	if (health < -maxHealth*0.5)
		. += "<span class='warning'>Выглядит полностью рабочим.</span>\n"
	if (fire_stacks < 0)
		. += "<span class='warning'>Он мокрый.</span>\n"
	else if (fire_stacks > 0)
		. += "<span class='warning'>Он в чём-то горючем.</span>\n"

	if(opened)
		. += "<hr><span class='warning'>Крышка открыта, батарейка [cell ? "на месте" : "не на месте"].</span>"
	else
		. += "<hr>Крышка закрыта[locked ? "" : " и похоже не заперта"]."

	if(cell && cell.charge <= 0)
		. += "<hr><span class='warning'>Индикатор зарядает мигает красным!</span>"

	switch(stat)
		if(CONSCIOUS)
			if(shell)
				. += "<hr>Похоже это [deployed ? "активная" : "пустая"] оболочка ИИ."
			else if(!client)
				. += "<hr>Он в режиме ожидания." //afk
		if(UNCONSCIOUS)
			. += "<hr><span class='warning'>Он не реагирует на движения.</span>"
		if(DEAD)
			. += "<hr><span class='deadsay'>Выглядит полностью уничтоженым. Похоже потребуется полный перезапуск.</span>"
	. += "</span>"

	. += ..()
