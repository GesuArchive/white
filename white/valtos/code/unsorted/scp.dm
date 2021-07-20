/obj/item/clothing/under/prison/dclass
	name = "комбинезон D-666"
	desc = "А что означает эта буква?"
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "d"
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = 0

/obj/item/clothing/under/prison/d/Initialize()
	..()
	name = "комбинезон D-[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"

/obj/effect/mob_spawn/human/prison/prisoner/dclass
	name = "шконка класса D"
	short_desc = "Роль заключённого."
	flavour_text = "Мне дали шанс искупить свою вину отправив в этот комплекс. Кстати, отправили меня сюда за "
	important_info = "Подчиняйтесь учёным."
	outfit = /datum/outfit/scp_prisoner_dclass
	assignedrole = "SCP: Class-D"

/obj/effect/mob_spawn/human/prison/prisoner/scientist
	name = "шконка научного сотрудника"
	short_desc = "Роль научного сотрудника лаборатории."
	flavour_text = "Мне дали шанс искупить свою вину отправив в этот комплекс следить за другими заключёнными. Где-то тут должна быть карта доступа. Кстати, отправили меня сюда за "
	important_info = "Используйте заключённых как пушечное мясо. Их хватит."
	outfit = /datum/outfit/scp_scientist
	assignedrole = "SCP: Scientist"

/datum/outfit/scp_prisoner_dclass
	name = "SCP: Prisoner D"
	uniform = /obj/item/clothing/under/prison/dclass
	shoes = /obj/item/clothing/shoes/sneakers/orange
	id = /obj/item/card/id/advanced/prisoner

	implants = list(/obj/item/implant/exile)

/datum/outfit/scp_scientist
	name = "SCP: Scientist"
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/sneakers/brown
	id = /obj/item/card/id/advanced/centcom/ert/security

	implants = list(/obj/item/implant/exile)

/obj/effect/mob_spawn/human/prison/prisoner/dclass/special(mob/living/L)
	var/list/klikuhi = list("Борзый", "Дохляк", "Академик", "Акула", "Базарило", "Бродяга", "Валет", "Воровайка", "Гнедой", \
	"Гребень", "Дельфин", "Дырявый", "Игловой", "Карась", "Каторжанин", "Лабух", "Мазурик", "Мокрушник", "Понтовитый", \
	"Ржавый", "Седой", "Сявка", "Темнила", "Чайка", "Чепушило", "Шакал", "Шерстяной", "Шмаровоз", "Шпилевой", "Олька", "Машка", \
	"Щипач", "Якорник", "Сладкий", "Семьянин", "Порученец", "Блатной", "Арап", "Артист", "Апельсин", "Афер", "Анимешник", \
	"Онанист", "Рэкетир")
	L.fully_replace_character_name(L.real_name, "[pick(klikuhi)]")

/obj/effect/mob_spawn/human/prison/prisoner/scientist/special(mob/living/L)
	var/list/imena = list("Петренко", "Гаврилов", "Смирнов", "Гмызенко", "Юлия", "Сафронов", "Павлов", "Пердюк", "Золотарев", \
	"Михалыч", "Попов", "Астоль", "Меместофель", "Шепард", "Шруман", "Залупов")
	L.fully_replace_character_name(L.real_name, "Профессор [pick(imena)]")
