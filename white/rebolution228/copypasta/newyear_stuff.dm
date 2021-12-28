///////////////////////////////// Items

// Podarochki ept

/obj/item/storage/box/festive/cartonbox
	name = "картонный подарок с конфетами"
	desc = "Сладкий новогодний подарок с разными видами сладостями, который обычно дарят детям. На упаковке виднеется Дед Мороз с голубо-прозрачным посохом, а выше надпись \"С НОВЫМ ГОДОМ!\""
	icon = 'white/rebolution228/icons/newyear_festive.dmi'
	icon_state = "podarok1"

/obj/item/storage/box/festive/cartonbox/alt
	name = "картонный подарок с конфетами"
	desc = "Сладкий новогодний подарок с разными видами сладостями, который обычно дарят детям. На упаковке виднеется Дед Мороз и надпись вокруг него разноцветными буквами \"СЛАДКИХ ПРАЗДНИКОВ! ПОЧТА ДЕДА МОРОЗА\""
	icon_state = "podarok3"

/obj/item/storage/box/festive/cartonbox/meshok
	name = "мешочек с конфетами"
	desc = "Мешочек конфет с разными видами сладостями, который обычно дарят детям. На мешке можно увидеть улыбающегося Деда Мороза на санях, который тащит подарки. Вас наполняет это новогодним настроением."
	icon_state = "podarok2"

/obj/item/storage/box/festive/cartonbox/PopulateContents()
	for(var/i in 1 to 7)
		var/createsweeties = pick(/obj/item/food/candy/bar,
							  /obj/item/food/candycone,
							  /obj/item/food/candy,
							  /obj/item/food/chocolatebar,
							  /obj/item/food/chocolatebunny,
							  /obj/item/food/chocolateegg,
							  /obj/item/food/tinychocolate,
							  /obj/item/food/chococoin,
							  /obj/item/food/candiedapple,
							  /obj/item/food/cookie/sugar,
							  /obj/item/food/honeybar,
							  /obj/item/food/chewable/lollipop,
							  /obj/item/food/chewable/gumball,
							  /obj/item/food/moth_cheese_cakes,
							  /obj/item/food/cakeslice/mothmallow)
		new createsweeties(src)
// Misc candies

/obj/item/trash/candy/bar
	name = "мусорный фантик"
	icon = 'white/rebolution228/icons/newyear_festive.dmi'
	icon_state = "bar_trash"

/obj/item/food/candy/bar
	name = "шоколадный батончик"
	desc = "Простой шоколадный батончик с орешками, ничего особенного."
	icon = 'white/rebolution228/icons/newyear_festive.dmi'
	icon_state = "bar"
	trash_type = /obj/item/trash/candy/bar
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/sugar = 3)
	junkiness = 25
	tastes = list("шоколад" = 2, "орехи" = 4)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/candycone
	name = "карамельная трость"
	desc = "Обычный вкусный леденец с привкусом мяты. В иностранном мире является традиционной конфетой."
	icon = 'white/rebolution228/icons/newyear_festive.dmi'
	icon_state = "cane" 
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sugar = 2)
	tastes = list("леденец" = 1, "мята" = 2)
	foodtypes = SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/candycone/Initialize()
	. = ..()
	icon_state = "cane[rand(1,3)]"
