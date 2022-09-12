// Offensive wizard spells
/datum/spellbook_entry/fireball
	name = "Огненный шар"
	desc = "Запускает взрывной огненный шар в цель. Наскучил всем волшебникам и обитателям станции."
	spell_type = /datum/action/cooldown/spell/pointed/projectile/fireball
	category = "Offensive"

/datum/spellbook_entry/spell_cards
	name = "Магические карты"
	desc = "Пылающие горячие скорострельные самонаводящиеся карты. Отправляйте своих врагов в царство смерти с их мистической силой!"
	spell_type = /datum/action/cooldown/spell/pointed/projectile/spell_cards
	category = "Offensive"

/datum/spellbook_entry/rod_form
	name = "Форма стержня"
	desc = "Примите форму недвижимого стержня, уничтожающего все на вашем пути. Многократное пизучение этого заклинания также увеличит урон от стержня и дальность его перемещения."
	spell_type = /datum/action/cooldown/spell/rod_form
	category = "Offensive"

/datum/spellbook_entry/disintegrate
	name = "Уничтожить"
	desc = "Заряжает вашу руку нечестивой энергией, жесточайше взрывающей жертву изнутри при касании."
	spell_type = /datum/action/cooldown/spell/touch/smite
	category = "Offensive"

/datum/spellbook_entry/blind
	name = "Слепота"
	desc = "Временно ослепляет выбранную цель."
	spell_type = /datum/action/cooldown/spell/pointed/blind
	category = "Offensive"
	cost = 1

/datum/spellbook_entry/mutate
	name = "Мутация"
	desc = "Заставляет вас превратиться в халка и на короткое время получить лазерное зрение."
	spell_type = /datum/action/cooldown/spell/apply_mutations/mutate
	category = "Offensive"

/datum/spellbook_entry/fleshtostone
	name = "Обращение в камень"
	desc = "Заряжает вашу руку силой, превращающей жертв в неподвижные статуи на длительный период времени."
	spell_type = /datum/action/cooldown/spell/touch/flesh_to_stone
	category = "Offensive"

/datum/spellbook_entry/teslablast
	name = "Выстрел теслы"
	desc = "Зарядите молнию теслы и выпустите ее в случайную ближайшую цель! Вы можете свободно передвигаться, пока он заряжается. Молния прыгает между целями и может сбить их с ног."
	spell_type = /datum/action/cooldown/spell/tesla
	category = "Offensive"

/datum/spellbook_entry/lightningbolt
	name = "Удар молнии"
	desc = "Стреляйте молнией в своих врагов! Он будет прыгать между целями, но не сможет сбить их с ног."
	spell_type = /datum/action/cooldown/spell/pointed/projectile/lightningbolt
	category = "Offensive"
	cost = 1

/datum/spellbook_entry/infinite_guns
	name = "Малый Призыв Оружия"
	desc = "Кому нужна перезарядка, если у вас есть бесконечное количество пушек? Вызывает нескончаемый поток винтовок с затвором, которые наносят небольшой урон, но сбивают цели с ног. Для использования требуются обе свободные руки. Изучение данного заклинания блокирует изучение 'Мистический шквал'."
	spell_type = /datum/action/cooldown/spell/conjure_item/infinite_guns/gun
	category = "Offensive"
	cost = 3
	no_coexistance_typecache = list(/datum/action/cooldown/spell/conjure_item/infinite_guns/arcane_barrage)

/datum/spellbook_entry/arcane_barrage
	name = "Мистический шквал"
	desc = "Обрушьте поток мистической энергии на своих врагов с помощью этого мощного заклинания. Наносит гораздо больше урона, чем 'Слабый Призыв Оружия', но не сбивает цели с ног. Для использования требуются свободные обе руки. Изучение этого заклинания делает вас неспособным выучить 'Малый Призыв Оружия'."
	spell_type = /datum/action/cooldown/spell/conjure_item/infinite_guns/arcane_barrage
	category = "Offensive"
	cost = 3
	no_coexistance_typecache = list(/datum/action/cooldown/spell/conjure_item/infinite_guns/gun)

/datum/spellbook_entry/barnyard
	name = "Проклятие Скотного двора"
	desc = "Это заклинание обрекает несчастную душу на обладание речью и чертами лица скотного двора."
	spell_type = /datum/action/cooldown/spell/pointed/barnyardcurse
	category = "Offensive"

/datum/spellbook_entry/item/staffchaos
	name = "Посох Хаоса"
	desc = "Капризный инструмент, который может использовать все виды магии без какой-либо системы или причины. Не рекомендуется использовать его на людях, которые вам небезразличны."
	item_path = /obj/item/gun/magic/staff/chaos
	category = "Offensive"

/datum/spellbook_entry/item/staffchange
	name = "Посох Перемен"
	desc = "Артефакт, который испускает разряды сверкающей энергии, которые заставляют саму форму цели изменятся во что-то иное."
	item_path = /obj/item/gun/magic/staff/change
	category = "Offensive"

/datum/spellbook_entry/item/mjolnir
	name = "Мьёльнир"
	desc = "Могучий молот, взятый взаймы у Тора, Бога Грома. Он сотрясается от едва сдерживаемой энергии."
	item_path = /obj/item/mjollnir
	category = "Offensive"

/datum/spellbook_entry/item/singularity_hammer
	name = "Молот Сингулярности"
	desc = "Молот, который создает чрезвычайно мощное поле притяжения в месте удара, притягивая все, что находится поблизости, к месту удара."
	item_path = /obj/item/singularityhammer
	category = "Offensive"

/datum/spellbook_entry/item/spellblade
	name = "Магический Меч"
	desc = "Меч, способный стрелять энергетическими разрядами, которые неплохо отрывают конечности."
	item_path = /obj/item/gun/magic/staff/spellblade
	category = "Offensive"

/datum/spellbook_entry/item/highfrequencyblade
	name = "Высокочастотное Лезвие"
	desc = "Невероятно быстрый зачарованный клинок, резонирующий на достаточно высокой частоте, чтобы разрезать что угодно."
	item_path = /obj/item/vibro_weapon
	category = "Offensive"
	cost = 3

/datum/spellbook_entry/furion
	name = "Еврейский гнев"
	desc = "Отбирает у проклятых гоев половину всех денег на картах."
	spell_type = /datum/action/cooldown/spell/furion
	category = "Offensive"

/datum/spellbook_entry/midas
	name = "Мидас"
	desc = "Превращает руку мага в Мидас, который способен превращать живых существ в золото."
	spell_type = /datum/action/cooldown/spell/touch/flesh_to_stone/midas
	category = "Offensive"
