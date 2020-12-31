/area/shuttle/turbolift //Only use subtypes of this area
	requires_power = FALSE //no APCS in the lifts please
	ambientsounds = list('white/jhnazar/sound/effects/turbolift/elevatormusic.ogg')

/area/shuttle/turbolift/shaft //What the shuttle leaves behind
	name = "Шахта лифта"
	requires_power = TRUE
	ambientsounds = MAINTENANCE

/area/shuttle/turbolift/primary
	name = "Первый лифт"

/area/shuttle/turbolift/secondary
	name = "Второй лифт"

/area/shuttle/turbolift/tertiary
	name = "Третий лифт"

/area/shuttle/turbolift/quaternary
	name = "Четвёртый лифт"

/area/shuttle/turbolift/quinary
	name = "Пятый лифт"

/area/shuttle/turbolift/senary
	name = "Шестой лифт"

/area/shuttle/turbolift/septenary
	name = "Седьмой лифт"

/area/shuttle/turbolift/octonary
	name = "Восьмой лифт"

/area/shuttle/turbolift/nonary
	name = "Девятый лифт"

/area/shuttle/turbolift/denary //If you need more than 10 elevators what are you doing?
	name = "Десятый лифт"
