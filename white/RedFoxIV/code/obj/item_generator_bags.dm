/obj/item/item_generator
	name = "мешок"
	desc = "Внутри что-то точно должно быть."
	icon = 'white/RedFoxIV/icons/obj/bags.dmi'
	icon_state = "gray"
	w_class = WEIGHT_CLASS_BULKY
	var/charges = 100
	var/max_charges = 100
	var/recharge_time = 1 SECONDS
	var/self_charge = FALSE
	///if set to true, displays the precise amount of charges upon examining. If false, only displays if it has any charges or no charges at all.
	var/precise_display = TRUE

	///spawns items with a crutchy "bluespace" effect.
	var/bluespace_effect = FALSE

	///словоформа цифры 1 (пример: 1 (один) пидрила, 1 (один) еблан)
	var/word1 = "какой-то предмет"
	///словоформа цифры 2 (пример: 2 (две) пидрилы, 2 (два) еблана)
	var/word2 = "каких-то предмета"
	///словоформа цифры 5 (пример: 5 (пять) пидрил, 5 (пять) ебланов)
	var/word5 = "каких-то предметов"

	///Items that this bag is allowed to spawn.
	var/list/items = list(/obj/item/stack/sheet/mineral/diamond, /obj/item/stack/sheet/mineral/gold, /obj/item/stack/sheet/mineral/uranium, /obj/item/stack/sheet/mineral/wood, /obj/item/stack/sheet/iron, /obj/item/stack/sheet/mineral/silver, /obj/item/stack/sheet/mineral/titanium, /obj/item/stack/sheet/glass)
	var/timer

/*
//возможно будет хорошей идеей вывести этот прок в глобальные, но я хз.
//"прямой" "порт" отсюда, потому что я не хочу ломать голову над этим говном:
//http://www.seoded.ru/webmaster/sozdanie-saita/sklonenie-suschestvitelnykh-s-ciframi.html
/obj/item/item_generator/proc/incline(n)
	if(n % 100 > 4 && n % 100 < 20)
		return src.word2

	var/a = list(2,0,1,1,1,2)[min(n%10, 5)+1]
	switch(a)
		if(0)
			return src.word1
		if(1)
			return src.word2
		if(2)
			return src.word5
*/

///Returns an item path to spawn. Override this proc if you don't want to choose randomly from a list.
/obj/item/item_generator/proc/pick_item()
	//pulled directly from /obj/effect/loot_site_spawner code
	var/itemspawn = pick_weight(items)
	while(islist(itemspawn))
		itemspawn = pick_weight(itemspawn)
	if(ispath(itemspawn))
		return itemspawn

/obj/item/item_generator/examine()
	. = ..()
	if(precise_display)
		. += "<br>Внутри [charges] [getnoun(charges, word1, word2, word5)]."
	else
		. += "<br>Внутри [charges ? "что-то есть!" : "ничего нет."]"

/obj/item/item_generator/attack_hand(mob/user)
	// stitched from /datum/component/storage code, because i wanted similiar to belts behaviour when using
	// (click to open while in belt slot, drag in a hand slot to deequip, etc) but absolutely did not want
	// to fuck with the storage component.

	//ugly af, should probably find a better way of doing this.

	if(src.loc != user)
		return ..()

	if(!charges || charges < 0)
		to_chat(user, "<span class = 'alert'>Внутри ничего нет!</span>")
		return
	charges--
	if(self_charge)
		timer = addtimer(CALLBACK(src, PROC_REF(recharge)), recharge_time, TIMER_UNIQUE | TIMER_STOPPABLE | TIMER_LOOP)
		//TIMER_UNIQUE will keep only one timer active and does not allow overriding the timer
		//TIMER_STOPPABLE so we can deltimer() it
		//TIMER_LOOP so the loop is handled by the timer subsystem instead of just creating a timer after timer

	var/obj/item/item = try_spawn(user)
	src.add_fingerprint(user)
	playsound(src	, 'sound/items/pshoom.ogg', 5, TRUE, -5)
	playsound(src	, "rustle", 50, TRUE, -5)
	if(!item)
		if(item == FALSE)
			return
		to_chat(user, "<span class = 'notice'>You fail miserably while trying to fish something out of [name].</span>")
		return
	to_chat(user, "<span class = 'notice'>Я вытаскиваю [item.name] из мешка!</span>")
	user.put_in_hands(item)

	if(bluespace_effect)
		item.alpha = 180
		item.transform = item.transform.Scale(0.2)
		item.transform = item.transform.Turn(rand(-30,30))
		item.color = "#222fe4"
		animate(item, alpha = 255, color = initial(item.color), transform = initial(item.transform), time = 5)




/obj/item/item_generator/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()

	if(istype(over, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over
		usr.putItemFromInventoryInHandIfPossible(src, H.held_index)
		return
	src.add_fingerprint(usr)


/**Picks an item and tries to spawn it.Returns an atom that was spawned.
 * Return a non-path (i.e. null) if you want to cancel spawn and display the default "fuck you" message to the user
 * Return FALSE if you want to cancel spawn without any notifications to the player or you have your own notifications you'd like to make.
 * Doesn't really need to be overriden unless you want some special effect occur on spawning an item.
 **/
/obj/item/item_generator/proc/try_spawn(mob/user)
	var/itempath = pick_item()
	if(!ispath(itempath, /obj))
		return

	var/obj/item = new itempath(src.drop_location())
	if(istype(item, /obj/item)) //required because a some stuff in maintenance loottable is not an item and does not have a lot of item related stuff. (duh)
		return item
	else
		to_chat(user, "<span class = 'notice'>Из [skloname(src.name, RODITELNI)] что-то выпадает!</span>")
		return FALSE

/obj/item/item_generator/proc/recharge()
	if(!self_charge) //safeguard
		deltimer(timer) //don't care about passing null to deltimer, it just returns false immediately.
		return

	if(charges < max_charges)
		charges++
	if(charges >= max_charges) //second check to see if we have reached the max_charges after adding one charge.
		deltimer(timer) //if so, delete the timer
