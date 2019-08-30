/datum/round_event_control/meteor_wave/major_dust
	name = "Major Space Dust"
	typepath = /datum/round_event/meteor_wave/major_dust
	weight = 8

/datum/round_event/meteor_wave/major_dust
	wave_name = "space dust"

/datum/round_event/meteor_wave/major_dust/announce(fake)
	var/reason = pick(
		"—танци€ проходит сквозь облако мусора, ожидаетс€ незначительное повреждение внешнего оборудовани€ и кострукций.",
		"ѕодразделение супероружи€ Ќанотрейзена проводит испытани€ нового прототипа [pick("метафизической","ониксовой","взрывной","супер-коллизионной","реактивной")] \
		[pick("пушки","артиллерии","бо€рки","крейсерной обшивки","\[REDACTED\]")], \
		ожидаетс€ небольшой мусор.",
		"—оседн€€ станци€ бросает в вас камни. (¬озможно, они устали от ваших сообщений.)")
	priority_announce(pick(reason), "ќпасность столкновени€")
