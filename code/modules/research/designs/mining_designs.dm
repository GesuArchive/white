
/////////////////////////////////////////
/////////////////Mining//////////////////
/////////////////////////////////////////
/datum/design/cargo_express
	name = "Экспресс консоль снабжения"
	desc = "Благодаря новой орбитальной пушке Нано Трейзен все входящие посылки доставляются практически мгновенно. Стандартная зона сброса - отдел карго. Допустима смена зоны сброса посредством маяка производимого в консоли. Возможна модификация консоли посредством установки диска с ПО блюспейс телепортатора."
	id = "cargoexpress"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 1000)
	build_path = /obj/item/circuitboard/computer/cargo/express
	category = list("Шахтёрское оборудование", "Карго оборудование")
	sub_category = list("Доставка")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/bluespace_pod
	name = "Модернизация экспресс консоли снабжения"
	desc = "На этом диске содержится обновление встроенного ПО для экспресс консоли снабжения, позволяющее отказатся от опасных капсул доставки в пользу блюспейс телепортации."
	id = "bluespace_pod"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 1000)
	build_path = /obj/item/disk/cargo/bluespace_pod
	category = list("Шахтёрское оборудование", "Карго оборудование")
	sub_category = list("Доставка")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/drill
	name = "Шахтёрский бур"
	desc = "Тяжелая буровая установка для особо крепкой породы."
	id = "drill"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 1000)
	build_path = /obj/item/pickaxe/drill
	category = list("Шахтёрское оборудование", "Карго снаряжение")
	sub_category = list("Горнопромышленное снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/drill_diamond
	name = "Бур с алмазным напылением"
	desc = "Мой бур создан, чтобы пронзить небеса!"
	id = "drill_diamond"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 1000, /datum/material/diamond = 2000)
	build_path = /obj/item/pickaxe/drill/diamonddrill
	category = list("Шахтёрское оборудование", "Карго снаряжение")
	sub_category = list("Горнопромышленное снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/plasmacutter
	name = "Плазменный резак"
	desc = "Горный инструмент, способный выбрасывать концентрированные плазменные вспышки. Можно использовать его, чтобы отрезать конечности от ксеносов! Или, знаете, копать руду."
	id = "plasmacutter"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 500, /datum/material/plasma = 400)
	build_path = /obj/item/gun/energy/plasmacutter
	category = list("Шахтёрское оборудование", "Карго снаряжение")
	sub_category = list("Горнопромышленное снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/plasmacutter_adv
	name = "Продвинутый плазменный резак"
	desc = "Горный инструмент, способный выбрасывать концентрированные плазменные вспышки. Продвинутая модель с более экономным расходом заряда и повышенной скорострельностью."
	id = "plasmacutter_adv"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 1000, /datum/material/plasma = 2000, /datum/material/gold = 500)
	build_path = /obj/item/gun/energy/plasmacutter/adv
	category = list("Шахтёрское оборудование", "Карго снаряжение")
	sub_category = list("Горнопромышленное снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/jackhammer
	name = "Ультразвуковой пневмоперфоратор"
	desc = "Крошит породу в пыль высокочастотными звуковыми импульсами."
	id = "jackhammer"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 2000, /datum/material/silver = 2000, /datum/material/diamond = 6000)
	build_path = /obj/item/pickaxe/drill/jackhammer
	category = list("Шахтёрское оборудование", "Карго снаряжение")
	sub_category = list("Горнопромышленное снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/superresonator
	name = "Продвинутый резонатор"
	desc = "Модернизированная версия резонатора, которая может создавать больше полей одновременно, а также не имеет штрафа к урону при раннем разрыве резонансного поля. Продвинутая модель так же может устанавливать \"резонансные мины\", которые взрываются после того, как кто-то (или что-то) наступает на них."
	id = "superresonator"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1500, /datum/material/silver = 1000, /datum/material/uranium = 1000)
	build_path = /obj/item/resonator/upgraded
	category = list("Шахтёрское оборудование", "Карго снаряжение")
	sub_category = list("Горнопромышленное снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/trigger_guard_mod
	name = "Модифицированный курок"
	desc = "Позволяет существам, обычно неспособным стрелять из оружия, использовать оружие, при его установке."
	id = "triggermod"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1500, /datum/material/gold = 1500, /datum/material/uranium = 1000)
	build_path = /obj/item/borg/upgrade/modkit/trigger_guard
	category = list("Шахтёрское оборудование", "Карго снаряжение")
	sub_category = list("Модификации кинетического ускорителя")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/damage_mod
	name = "Увеличение урона"
	desc = "При установке увеличивает урон кинетического ускорителя на 10 единиц."
	id = "damagemod"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1500, /datum/material/gold = 1500, /datum/material/uranium = 1000)
	build_path = /obj/item/borg/upgrade/modkit/damage
	category = list("Шахтёрское оборудование", "Модули киборгов", "Карго снаряжение")
	sub_category = list("Модификации кинетического ускорителя")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/cooldown_mod
	name = "Ускорение перезарядки"
	desc = "Уменьшает время восстановления кинетического ускорителя. Не рассчитано на использование в шахтёрском минироботе."
	id = "cooldownmod"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1500, /datum/material/gold = 1500, /datum/material/uranium = 1000)
	build_path = /obj/item/borg/upgrade/modkit/cooldown
	category = list("Шахтёрское оборудование", "Модули киборгов", "Карго снаряжение")
	sub_category = list("Модификации кинетического ускорителя")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/range_mod
	name = "Увеличение дальнобойности"
	desc = "Увеличивает дальность поражения кинетического ускорителя при установке."
	id = "rangemod"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1500, /datum/material/gold = 1500, /datum/material/uranium = 1000)
	build_path = /obj/item/borg/upgrade/modkit/range
	category = list("Шахтёрское оборудование", "Модули киборгов", "Карго снаряжение")
	sub_category = list("Модификации кинетического ускорителя")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/hyperaccelerator
	name = "Горный взрыв"
	desc = "Позволяет кинетическому ускорителю разрушать камни в небольшом радиусе."
	id = "hypermod"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1500, /datum/material/silver = 2000, /datum/material/gold = 2000, /datum/material/diamond = 2000)
	build_path = /obj/item/borg/upgrade/modkit/aoe/turfs
	category = list("Шахтёрское оборудование", "Модули киборгов", "Карго снаряжение")
	sub_category = list("Модификации кинетического ускорителя")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/deepcore_drill
	name = "Бур глубокого погружения"
	desc = "Мощная машина, которая способна извлекать руду из недр планеты."
	id = "deepcore_drill"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/deepcore/drill
	category = list("Шахтёрское оборудование", "Карго оборудование")
	sub_category = list("Производство")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/deepcore_hopper
	name = "Блюспейс рудоприемник"
	desc = "Машина, предназначенная для приема руды от любых подключенных к ней буров глубокого погружения посредством блюспейс телепортации."
	id = "deepcore_hopper"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/deepcore/hopper
	category = list("Шахтёрское оборудование", "Карго оборудование")
	sub_category = list("Производство")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO
