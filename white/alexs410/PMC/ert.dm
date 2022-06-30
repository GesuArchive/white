//Я забил на это болт и пока ничего не делаю. Код не в игре.
/obj/item/storage/belt/medipenal/pmc

/obj/item/storage/belt/medipenal/pmc/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/rvv(src)
	new /obj/item/reagent_containers/hypospray/medipen/zagustin(src)
	if(prob(50))
		new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	if(prob(50))
		new /obj/item/reagent_containers/hypospray/medipen/oxandrolone(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)

/obj/item/clothing/shoes/combat/knife //А почему нет ботинка сразу с ножиком?

/obj/item/clothing/shoes/combat/knife/Initialize()
	. = ..()
	new /obj/item/kitchen/knife/combat(src)

/obj/item/gun/energy/laser/smg
	name = "лазерный ПП"
	desc = "Боевой лазерный пистолет-пулемет. К удивлению, на нем есть резьба для глушителя."
	icon_state = "scattershot" //temp
	cell_type = /obj/item/stock_parts/cell/upgraded
	can_suppress = TRUE //ТАКТИКУЛЬНЫЙ ЛАЗЕРНЫЙ ГЛУШИТЕЛЬ
	ammo_type = list(/obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/laser/smg/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.3 SECONDS)

/obj/item/gun/energy/laser/smg/selfcharge
	name = "Шершень"
	desc = "Данная модель обладает меньшей батареей, но заряжается сама от реактора шизотипичного парадокса. Есть крайне малая вероятность возникновения ПИЗДЕЦА при стрельбе, но это всего лишь слухи"
	cell_type = /obj/item/stock_parts/cell/pulse/pistol //28 Выстрелов
	selfcharge = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun) //Так надо

/obj/item/gun/energy/laser/smg/selfcharge/shoot_live_shot(mob/living/user, pointblank, atom/pbtarget, message)
	if(prob(0.1))
		if(prob(50))
			user.visible_message(span_danger("[src] в руках [user] разрывается снопом искр."))
			to_chat(user,span_warning("[src] загорается в моих руках. Мама... "))
			explosion(explosion(src, 1, 2, 4, 0))
		else
			var/turf/T = get_turf(src)
			SSblackbox.record_feedback("tally", "smg fatally jammed", 1, type)
			var/obj/singularity/S = new /obj/singularity(T)
			transfer_fingerprints_to(S)
			user.visible_message(span_danger("[user] целиком засасывается в [src]."))
			to_chat(user,span_warning("Куда меня засасываеееее..."))
			qdel(user)
		qdel(src)
		return
	. = ..()
