/mob/living/silicon/ai/examine(mob/user)
	. = list("<span class='info'>Это же [icon2html(src, user)] <EM>[src]</EM>!<hr>")
	if (stat == DEAD)
		. += "<span class='deadsay'>Похоже он выключен полностью.</span>"
	else
		if (getBruteLoss())
			if (getBruteLoss() < 30)
				. += "<span class='warning'>Выглядит немного побитым.</span>\n"
			else
				. += "<span class='warning'><B>Выглядит сильно побитым!</B></span>\n"
		if (getFireLoss())
			if (getFireLoss() < 30)
				. += "<span class='warning'>Выглядит немного обугленным.</span>\n"
			else
				. += "<span class='warning'><B>Выглядит так, будто его прожарили в печи!</B></span>\n"
		if(deployed_shell)
			. += "Режим беспроводной сети активирован, судя по огоньку на одном из датчиков.\n"
		else if (!shunted && !client)
			. += "[src]Core.exe не отвечает! NTOS ищет решение проблемы...\n"
	. += "</span>"

	. += ..()
