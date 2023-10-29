/obj/item/storage/mre
	name = "ИРП-4"
	desc = "Запечатанный под вакуумом пакет с дневным запасом питательных веществ для взрослого, находящегося в тяжелых условиях. На упаковке нет видимой даты истечения срока годности."
	icon = 'white/valtos/icons/mre.dmi'
	icon_state = "mre"
	var/open_sound = 'white/valtos/sounds/rip1.ogg'
	var/list/meal_contents = list(
		/obj/item/storage/mrebag,
		/obj/item/storage/mrebag,
		/obj/item/storage/mrebag/dessert,
		/obj/item/food/breadslice/meat,
		/obj/item/reagent_containers/food/drinks/soda_cans/random,
		/obj/item/reagent_containers/food/condiment/pack/hotsauce)

/obj/item/storage/mre/PopulateContents()
	. = ..()
	atom_storage.max_slots = 6
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.allow_quick_empty = FALSE
	atom_storage.rustle_sound = FALSE
	atom_storage.locked = TRUE
	for(var/i in meal_contents)
		new i(src)

/obj/item/storage/mre/update_icon()
	if(!atom_storage.locked)
		icon_state = "[initial(icon_state)]1"
	. = ..()

/obj/item/storage/mre/attack_self(mob/user)
	open(user)
	. = ..()

/obj/item/storage/mre/proc/open(mob/user)
	if(atom_storage.locked)
		playsound(get_turf(src), open_sound, 50, TRUE)
		atom_storage.locked = FALSE
		to_chat(user, span_notice("Вскрываю упаковку. Приятный запах начинает исходить из неё."))
		update_icon()

/obj/item/storage/mre/vegan
	name = "ИРП-6"
	icon_state = "vegmre"
	meal_contents = list(
		/obj/item/storage/mrebag/vegan,
		/obj/item/storage/mrebag/vegan,
		/obj/item/storage/mrebag/dessert,
		/obj/item/food/breadslice/tofu,
		/obj/item/reagent_containers/food/drinks/waterbottle,
		/obj/item/reagent_containers/food/drinks/soda_cans/random)

/obj/item/storage/mre/protein
	name = "ИРП-47"
	icon_state = "meatmre"
	meal_contents = list(
		/obj/item/storage/mrebag/protein,
		/obj/item/storage/mrebag/protein,
		/obj/item/storage/mrebag/dessert,
		/obj/item/food/grilled_cheese_sandwich,
		/obj/item/reagent_containers/food/condiment/pack/bbqsauce,
		/obj/item/reagent_containers/food/drinks/soda_cans/random)

/obj/item/storage/mrebag
	name = "основное блюдо (пицца)"
	desc = "Запечатанный под вакуумом пакет, содержащий основное блюдо ИРП. Саморазогревается при открытии."
	icon = 'white/valtos/icons/mre.dmi'
	icon_state = "pouch_medium"
	w_class = WEIGHT_CLASS_SMALL
	var/open_sound = 'sound/effects/bubbles.ogg'

/obj/item/storage/mrebag/proc/generate_main_meal()
	var/obj/item/main_meal = pick(subtypesof(/obj/item/food/pizzaslice))
	new main_meal(src)

/obj/item/storage/mrebag/vegan
	name = "основное блюдо (салат)"

/obj/item/storage/mrebag/vegan/generate_main_meal()
	var/obj/item/main_meal = pick(subtypesof(/obj/item/food/salad))
	new main_meal(src)

/obj/item/storage/mrebag/protein
	name = "основное блюдо (бургер)"

/obj/item/storage/mrebag/protein/generate_main_meal()
	var/obj/item/main_meal = pick(subtypesof(/obj/item/food/burger))
	new main_meal(src)

/obj/item/storage/mrebag/PopulateContents()
	. = ..()
	atom_storage.max_slots = 1
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.locked = TRUE
	generate_main_meal()

/obj/item/storage/mrebag/update_icon()
	if(!atom_storage.locked)
		icon_state = "[initial(icon_state)]1"
	. = ..()

/obj/item/storage/mrebag/attack_self(mob/user)
	open(user)
	. = ..()

/obj/item/storage/mrebag/proc/open(mob/user)
	if(atom_storage.locked)
		playsound(get_turf(src), open_sound, 50, TRUE)
		atom_storage.locked = FALSE
		to_chat(user, span_notice("Вскрываю упаковку. Приятный запах начинает исходить из неё."))
		update_icon()

/obj/item/storage/mrebag/dessert
	name = "десерт"
	desc = "Вакуумный пакет с десертом ИРП."
	icon_state = "pouch_small"
	open_sound = 'white/valtos/sounds/rip1.ogg'

/obj/item/storage/mrebag/dessert/PopulateContents()
	atom_storage.max_slots = 1
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.allow_quick_empty = FALSE
	atom_storage.rustle_sound = FALSE
	atom_storage.locked = TRUE
	var/obj/item/picked_content = pick(subtypesof(/obj/item/food/donut))
	new picked_content(src)
