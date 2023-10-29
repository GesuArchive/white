/*
//////////////////////////////////////
Viral adaptation

	Moderate stealth boost.
	Major Increases to resistance.
	Reduces stage speed.
	No change to transmission
	Critical Level.

BONUS
	Extremely useful for buffing viruses

//////////////////////////////////////
*/
/datum/symptom/viraladaptation
	name = "Вирусная самоадаптация"
	desc = "Вирус имитирует функцию нормальных клеток организма, его становится труднее обнаружить и уничтожить, но его скорость замедляется."
	stealth = 3
	resistance = 5
	stage_speed = -3
	transmittable = 0
	level = 3

/*
//////////////////////////////////////
Viral evolution

	Moderate stealth reductopn.
	Major decreases to resistance.
	increases stage speed.
	increase to transmission
	Critical Level.

BONUS
	Extremely useful for buffing viruses

//////////////////////////////////////
*/
/datum/symptom/viralevolution
	name = "Ускорение вирусной эволюции"
	desc = "Вирус быстро приспосабливается к максимально быстрому распространению как снаружи, так и внутри хозяина. Это, однако, облегчает обнаружение вируса и снижает его способность бороться с лекарством."
	stealth = -2
	resistance = -3
	stage_speed = 5
	transmittable = 3
	level = 3
