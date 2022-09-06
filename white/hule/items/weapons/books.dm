/obj/item/book/killbook
	name = "Супер прикол"
	icon_state ="book"
	throw_speed = 1
	throw_range = 10
	author = "Forces beyond your comprehension"
	unique = 1
	title = "Сборник Приколов!"
	dat = null

/obj/item/book/killbook/Initialize(mapload)
	. = ..()
	icon_state = "book[rand(1,7)]"
	name = "Сборник [pick("приколов","анекдотов","юморесок")] [pick("от кодербаса", "от Нуждина", "про болоны", "про бимбы", "про ассистентов", "про вардена")]"

/obj/item/book/killbook/attack_self(mob/user)
	var/datum/asset/zdoh = get_asset_datum(/datum/asset/simple/white_mix)
	if(!dat)
		dat = "<html><img src=\"[SSassets.transport.get_asset_url("zdoh.png")]\" width=350px height=350px> <br>Список лохов:<br>"
	zdoh.send(user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.undergoing_cardiac_arrest() && H.can_heartattack())
			H.set_heartattack(TRUE)
			if(H.stat == CONSCIOUS)
				H.visible_message(span_danger("[H] здох! Ну и лох!"))
			dat += "[H.real_name]<br>"
	if(!(ishuman(user)))
		user.visible_message(span_danger("[user] здох! Ну и лох!"))
		user.forceMove(src)
		dat += "[user.name]<br>"
	..()

/datum/uplink_item/role_restricted/killbook
	name = "Very funny book"
	desc = "Сборник ну просто ОЧЕНЬ смешных приколов в количестве 1 шт."
	item = /obj/item/book/killbook
	cost = 1
	restricted_roles = list(JOB_CURATOR, JOB_ASSISTANT)
	surplus = 10
