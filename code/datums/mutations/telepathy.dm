/datum/mutation/human/telepathy
	name = "Телепатия"
	desc = "Редкая мутация, которая позволяет пользователю телепатически общаться с другими."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>Я слышу свой голос, эхом отдающийся в моей собственный голове!</span>"
	text_lose_indication = "<span class='notice'>Эхо моего голоса исчезло...</span>"
	difficulty = 12
	power_path = /datum/action/cooldown/spell/list_target/telepathy
	instability = 10
	energy_coeff = 1
