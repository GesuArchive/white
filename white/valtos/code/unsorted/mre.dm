/*
MRE Stuff
 */

/obj/item/storage/mre
	name = "ИРП, Набор #1"
	desc = "Запечатанный под вакуумом пакет с дневным запасом питательных веществ для взрослого, находящегося в тяжелых условиях. На упаковке нет видимой даты истечения срока годности."
	icon = 'white/valtos/icons/mre.dmi'
	icon_state = "mre"
	locked = TRUE
	var/open_sound = 'white/valtos/sounds/rip1.ogg'
	var/main_meal = /obj/item/storage/mrebag
	var/meal_desc = "Этот набор под номером #1. Внутри пицца с мясом!"
	var/list/meal_contents = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/pack/hotsauce,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/PopulateContents()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.allow_quick_empty = FALSE
	STR.rustle_sound = FALSE
	new main_meal(src)
	for(var/i in meal_contents)
		new i(src)

/obj/item/storage/mre/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'[meal_desc]</span>"

/obj/item/storage/mre/update_icon()
	if(!locked)
		icon_state = "[initial(icon_state)]1"
	. = ..()

/obj/item/storage/mre/attack_self(mob/user)
	open(user)
	. = ..()

/obj/item/storage/mre/proc/open(mob/user)
	if(locked)
		playsound(get_turf(src), open_sound, 50, TRUE)
		locked = FALSE
		to_chat(user, "<span class='notice'>Вскрываю упаковку. Приятный запах начинает исходить из неё.</span>")
		update_icon()

/obj/item/storage/mre/menu2
	name = "ИРП, Набор #2"
	meal_desc = "Этот набор под номером #2. Пицца маргарита."
	main_meal = /obj/item/storage/mrebag/menu2
	meal_contents = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/saltshaker,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/menu3
	name = "ИРП, Набор #3"
	meal_desc = "Этот набор под номером #3. Веганская пицца."
	main_meal = /obj/item/storage/mrebag/menu3
	meal_contents = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/peppermill,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/menu4
	name = "ИРП, Набор #4"
	meal_desc = "Этот набор под номером #4. Гамбургер."
	main_meal = /obj/item/storage/mrebag/menu4
	meal_contents = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/pack/astrotame,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/menu5
	name = "ИРП, Набор #5"
	meal_desc = "Этот набор под номером #5. Тако."
	main_meal = /obj/item/storage/mrebag/menu5
	meal_contents = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/pack/ketchup,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/menu6
	name = "ИРП, Набор #6"
	meal_desc = "Этот набор под номером #6. Хлеб с мясом."
	main_meal = /obj/item/storage/mrebag/menu6
	meal_contents = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/random/mre/sauce/sugarfree,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/menu7
	name = "ИРП, Набор #7"
	meal_desc = "Этот набор под номером #7. Салат."
	main_meal = /obj/item/storage/mrebag/menu7
	meal_contents = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/pack/astrotame,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/menu8
	name = "ИРП, Набор #8"
	meal_desc = " Этот набор под номером #8. Перец чили."
	main_meal = /obj/item/storage/mrebag/menu8
	meal_contents = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/pack/hotsauce,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/menu9
	name = "веганский ИРП"
	meal_desc = "Этот набор под номером #9. Варёный рис."
	icon_state = "vegmre"
	main_meal = /obj/item/storage/mrebag/menu9
	meal_contents = list(
		/obj/item/storage/mrebag/dessert/menu9,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/random/mre/spread/vegan,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/pack/astrotame,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/menu10
	name = "протеиновый ИРП"
	meal_desc = "Этот набор под номером #10. Протеины."
	icon_state = "meatmre"
	main_meal = /obj/item/storage/mrebag/menu10
	meal_contents = list(
		/obj/item/reagent_containers/food/snacks/butteredtoast,
		/obj/item/reagent_containers/food/condiment/pack/bbqsauce,
		/obj/random/mre/sauce/sugarfree,
		/obj/item/kitchen/fork/plastic
	)

/obj/item/storage/mre/random
	meal_desc = "Меню затёрто."
	main_meal = /obj/random/mre/main

/obj/item/storage/mrebag
	name = "основное блюдо"
	desc = "Запечатанный под вакуумом пакет, содержащий основное блюдо ИРП. Саморазогревается при открытии."
	icon = 'white/valtos/icons/mre.dmi'
	icon_state = "pouch_medium"
	w_class = WEIGHT_CLASS_SMALL
	var/open_sound = 'sound/effects/bubbles.ogg'
	var/list/meal_contents = list(/obj/item/reagent_containers/food/snacks/pizza/meat)

/obj/item/storage/mrebag/PopulateContents()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_SMALL
	for(var/i in meal_contents)
		new i(src)

/obj/item/storage/mrebag/update_icon()
	if(!locked)
		icon_state = "[initial(icon_state)]1"
	. = ..()

/obj/item/storage/mrebag/attack_self(mob/user)
	open(user)
	. = ..()

/obj/item/storage/mrebag/proc/open(mob/user)
	if(locked)
		playsound(get_turf(src), open_sound, 50, TRUE)
		locked = FALSE
		to_chat(user, "<span class='notice'>Вскрываю упаковку. Приятный запах начинает исходить из неё.</span>")
		update_icon()

/obj/item/storage/mrebag/menu2
	meal_contents = list(/obj/item/reagent_containers/food/snacks/pizza/margherita)

/obj/item/storage/mrebag/menu3
	meal_contents = list(/obj/item/reagent_containers/food/snacks/pizza/vegetable)

/obj/item/storage/mrebag/menu4
	meal_contents = list(/obj/item/food/burger)

/obj/item/storage/mrebag/menu5
	meal_contents = list(/obj/item/reagent_containers/food/snacks/taco)

/obj/item/storage/mrebag/menu6
	meal_contents = list(/obj/item/food/bread/meat)

/obj/item/storage/mrebag/menu7
	meal_contents = list(/obj/item/reagent_containers/food/snacks/salad)

/obj/item/storage/mrebag/menu8
	meal_contents = list(/obj/item/reagent_containers/food/snacks/soup/hotchili)

/obj/item/storage/mrebag/menu9
	meal_contents = list(/obj/item/reagent_containers/food/snacks/salad/boiledrice)

/obj/item/storage/mrebag/menu10
	meal_contents = list(/obj/item/reagent_containers/food/snacks/meatball)

/obj/item/storage/mrebag/dessert
	name = "десерт"
	desc = "Вакуумный пакет с десертом ИРП."
	icon_state = "pouch_small"
	open_sound = 'white/valtos/sounds/rip1.ogg'
	meal_contents = list(/obj/random/mre/dessert)

/obj/item/storage/mrebag/dessert/menu9
	meal_contents = list(/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit)

//Random MRE stuff

/obj/random/mre
	name = "random MRE"
	desc = "This is a random single MRE."
	icon = 'white/valtos/icons/mre.dmi'
	icon_state = "mre"

/obj/random/mre/proc/spawn_choices()
	return list()

/obj/random/mre/Initialize()
	..()
	var/to_create = pick(spawn_choices())
	new to_create(src)
	qdel(src)

/obj/random/mre/spawn_choices()
	return list(/obj/item/storage/mre,
				/obj/item/storage/mre/menu2,
				/obj/item/storage/mre/menu3,
				/obj/item/storage/mre/menu4,
				/obj/item/storage/mre/menu5,
				/obj/item/storage/mre/menu6,
				/obj/item/storage/mre/menu7,
				/obj/item/storage/mre/menu8,
				/obj/item/storage/mre/menu9,
				/obj/item/storage/mre/menu10)


/obj/random/mre/main
	name = "random MRE main course"
	desc = "This is a random main course for MREs."
	icon_state = "pouch_medium"

/obj/random/mre/main/spawn_choices()
	return list(/obj/item/storage/mrebag,
				/obj/item/storage/mrebag/menu2,
				/obj/item/storage/mrebag/menu3,
				/obj/item/storage/mrebag/menu4,
				/obj/item/storage/mrebag/menu5,
				/obj/item/storage/mrebag/menu6,
				/obj/item/storage/mrebag/menu7,
				/obj/item/storage/mrebag/menu8)

/obj/random/mre/dessert
	name = "random MRE dessert"
	desc = "This is a random dessert for MREs."
	icon_state = "pouch_medium"

/obj/random/mre/dessert/spawn_choices()
	return list(/obj/item/reagent_containers/food/snacks/candy,
				/obj/item/reagent_containers/food/snacks/hotdog,
				/obj/item/reagent_containers/food/snacks/donut,
				/obj/item/reagent_containers/food/snacks/honeybar,
				/obj/item/reagent_containers/food/snacks/chocolatebar,
				/obj/item/reagent_containers/food/snacks/cookie,
				/obj/item/reagent_containers/food/snacks/poppypretzel,
				/obj/item/reagent_containers/food/snacks/chewable/bubblegum)

/obj/random/mre/dessert/vegan
	name = "random vegan MRE dessert"
	desc = "This is a random vegan dessert for MREs."

/obj/random/mre/dessert/vegan/spawn_choices()
	return list(/obj/item/reagent_containers/food/snacks/candy,
				/obj/item/reagent_containers/food/snacks/chocolatebar,
				/obj/item/reagent_containers/food/snacks/honeybar,
				/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit)

/obj/random/mre/drink
	name = "random MRE drink"
	desc = "This is a random drink for MREs."
	icon_state = "packet_small"

/obj/random/mre/drink/spawn_choices()
	return list(/obj/item/reagent_containers/food/drinks/coffee,
				/obj/item/reagent_containers/food/drinks/mug/tea,
				/obj/item/reagent_containers/food/drinks/mug/coco,
				/obj/item/reagent_containers/food/drinks/sillycup/smallcarton,
				/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime,
				/obj/item/reagent_containers/food/drinks/waterbottle,
				/obj/item/reagent_containers/food/drinks/soda_cans/random)

/obj/random/mre/spread
	name = "random MRE spread"
	desc = "This is a random spread packet for MREs."
	icon_state = "packet_small"

/obj/random/mre/spread/spawn_choices()
	return list(/obj/item/reagent_containers/food/condiment/pack/astrotame,
				/obj/item/reagent_containers/food/condiment/pack/ketchup)

/obj/random/mre/spread/vegan
	name = "random vegan MRE spread"
	desc = "This is a random vegan spread packet for MREs"

/obj/random/mre/spread/vegan/spawn_choices()
	return list(/obj/item/reagent_containers/food/condiment/pack/astrotame)

/obj/random/mre/sauce
	name = "random MRE sauce"
	desc = "This is a random sauce packet for MREs."
	icon_state = "packet_small"

/obj/random/mre/sauce/spawn_choices()
	return list(/obj/item/reagent_containers/food/condiment/saltshaker,
				/obj/item/reagent_containers/food/condiment/peppermill,
				/obj/item/reagent_containers/food/condiment/sugar,
				/obj/item/reagent_containers/food/condiment/pack/hotsauce,
				/obj/item/reagent_containers/food/condiment/pack/ketchup,
				/obj/item/reagent_containers/food/condiment/pack/astrotame,
				/obj/item/reagent_containers/food/condiment/pack/bbqsauce)

/obj/random/mre/sauce/vegan/spawn_choices()
	return list(/obj/item/reagent_containers/food/condiment/saltshaker,
				/obj/item/reagent_containers/food/condiment/peppermill,
				/obj/item/reagent_containers/food/condiment/sugar,
				/obj/item/reagent_containers/food/condiment/pack/bbqsauce)

/obj/random/mre/sauce/sugarfree/spawn_choices()
	return list(/obj/item/reagent_containers/food/condiment/saltshaker,
				/obj/item/reagent_containers/food/condiment/peppermill,
				/obj/item/reagent_containers/food/condiment/pack/hotsauce,
				/obj/item/reagent_containers/food/condiment/pack/ketchup,
				/obj/item/reagent_containers/food/condiment/pack/astrotame,
				/obj/item/reagent_containers/food/condiment/pack/bbqsauce)
