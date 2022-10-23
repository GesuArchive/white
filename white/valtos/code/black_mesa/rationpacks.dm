/obj/item/food/mre_course
	name = "странный сухпаёк"
	desc = "Прямиком из кодербуса."
	icon = 'white/valtos/icons/black_mesa/courses.dmi'
	icon_state = "main_course"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	tastes = list("crayon powder" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mre_course/main
	name = "ИРП: Основное блюдо"
	desc = "Основной военный рацион, предназначенный для сухопутных войск. Этот содержит клубнику, шоколад и ваниллин."
	tastes = list("strawberry" = 1, "vanilla" = 1, "chocolate" = 1)

/obj/item/food/mre_course/main/beans
	name = "ИРП: Основное блюдо - фасоль и свинина"
	desc = "Основной военный рацион, предназначенный для сухопутных войск. Этот содержит свинину с фасолью, политую томатным соусом."
	tastes = list("beans" = 1, "pork" = 1, "tomato sauce" = 1)
	foodtypes = MEAT | VEGETABLES

/obj/item/food/mre_course/main/macaroni
	name = "ИРП: Основное блюдо - макароны с сыром"
	desc = "Основной военный рацион, предназначенный для сухопутных войск. Этот содержит предварительно отваренные макароны, покрытые сыром."
	tastes = list("cold macaroni" = 1, "bland cheese" = 1)
	foodtypes = DAIRY | GRAIN

/obj/item/food/mre_course/main/rice
	name = "ИРП: Основное блюдо - говядина с рисом"
	desc = "Основной военный рацион, предназначенный для сухопутных войск. Этот содержит содержит рис с говядиной, политый соусом."
	tastes = list("dense rice" = 1, "bits of beef" = 1, "gravy" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/mre_course/side
	name = "ИРП: Второе блюдо"
	desc = "Второстепенный военный рацион, предназначенный для сухопутных войск. Этот содержит воздух."
	icon_state = "side_dish"

/obj/item/food/mre_course/side/bread
	name = "ИРП: Второе блюдо - кукурузный хлеб"
	desc = "Второстепенный военный рацион, предназначенный для сухопутных войск. Этот содержит кукурузный хлеб."
	tastes = list("cornbread" = 1)
	foodtypes = GRAIN

/obj/item/food/mre_course/side/pie
	name = "ИРП: Второе блюдо - мясной пирог"
	desc = "Второстепенный военный рацион, предназначенный для сухопутных войск. Этот содержит мясной пирог."
	tastes = list("pie dough" = 1, "ground meat" = 1, "Texas" = 1)
	foodtypes = MEAT | GRAIN

/obj/item/food/mre_course/side/chicken
	name = "ИРП: Второе блюдо - курица с соусом"
	desc = "Второстепенный военный рацион, предназначенный для сухопутных войск. Этот содержит какое-то неопределенно похожее на курицу мясо, покрытое соусом."
	tastes = list("bits of chicken meat" = 1, "sweet and sour sauce" = 1, "salt" = 1)
	foodtypes = MEAT | FRIED

/obj/item/food/mre_course/dessert
	name = "ИРП: Десерт"
	desc = "Десертный военный рацион, предназначенный для сухопутных войск. Этот содержит воздух."
	icon_state = "dessert"

/obj/item/food/mre_course/dessert/cookie
	name = "ИРП: Десерт - печенье"
	desc = "Десертный военный рацион, предназначенный для сухопутных войск. Этот содержит большое печенье."
	tastes = list("dryness" = 1, "hard cookie" = 1, "chocolate chip" = 1)
	foodtypes = GRAIN | SUGAR

/obj/item/food/mre_course/dessert/cake
	name = "ИРП: Десерт - яблочный пирог"
	desc = "Десертный военный рацион, предназначенный для сухопутных войск. Этот содержит яблочный пирог."
	tastes = list("apple" = 1, "moist cake" = 1, "sugar" = 1)
	foodtypes = GRAIN | SUGAR | FRUIT

/obj/item/food/mre_course/dessert/chocolate
	name = "ИРП: Десерт - тёмный шоколад"
	desc = "Десертный военный рацион, предназначенный для сухопутных войск. Этот содержит тёмный шоколад."
	tastes = list("vanilla" = 1, "artificial chocolate" = 1, "chemicals" = 1)
	foodtypes = JUNKFOOD | SUGAR

/obj/item/storage/box/hecu_rations
	name = "упаковка с ИРП"
	desc = "Содержит в себе сухпайки на случай если вы проголодались во время военной операции."
	icon = 'white/valtos/icons/black_mesa/mre_hecu.dmi'
	icon_state = "mre_package"
	illustration = null

/obj/item/storage/box/hecu_rations/Initialize()
	. = ..()
	atom_storage.max_slots = 5

/obj/item/storage/box/hecu_rations/PopulateContents()
	var/main_course = pick(/obj/item/food/mre_course/main/beans, /obj/item/food/mre_course/main/macaroni, /obj/item/food/mre_course/main/rice)
	var/side_dish = pick(/obj/item/food/mre_course/side/bread, /obj/item/food/mre_course/side/pie, /obj/item/food/mre_course/side/chicken)
	var/dessert = pick(/obj/item/food/mre_course/dessert/cookie, /obj/item/food/mre_course/dessert/cake, /obj/item/food/mre_course/dessert/chocolate)
	new main_course(src)
	new side_dish(src)
	new dessert(src)
	new /obj/item/storage/box/gum(src)
	new /obj/item/food/spacers_sidekick(src)
