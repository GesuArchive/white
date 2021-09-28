/datum/crafting_recipe/food/wah_soup
	name = "Imperium soup"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/potato = 1,
		/datum/reagent/water = 20,
		/datum/reagent/consumable/salt = 10,
		/datum/reagent/consumable/blackpepper = 10
	)
	result = /obj/item/food/soup/imperium
	subcategory = CAT_SOUP

/obj/item/food/soup/imperium
	name = "Imperium soup"
	desc = "FOR IMPERIUM!"
	icon_state = "wishsoup"
	food_reagents = list(/datum/reagent/water = 20, /datum/reagent/consumable/nutriment/vitamin = 20, /datum/reagent/consumable/nutriment = 50, /datum/reagent/medicine/omnizine = 15, /datum/reagent/medicine/ephedrine = 25, /datum/reagent/medicine/morphine = 30)
