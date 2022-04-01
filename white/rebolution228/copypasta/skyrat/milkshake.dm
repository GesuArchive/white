/datum/reagent/consumable/milkshake
	name = "Молочный коктейль"
	description = "Вкусное, замороженное лакомство!"
	color = "#ede9dd" //237, 233, 221
	taste_description = "насыщенное мороженое"
	glass_icon_state = "milkshake"
	glass_name = "пластиковый стаканчик с молочным коктейлем"
	glass_desc = "Приводит всех мальчишек во двор."

/datum/reagent/consumable/milkshake_strawberry
	name = "Клубничный коктейль"
	description = "Вкусное, фруктовое угощение!"
	color = "#e39c91" //227, 156, 145
	taste_description = "клубника и мороженое"
	glass_icon_state = "milkshake_strawberry"
	glass_name = "пластиковый стаканчик с клубичным коктейлем"
	glass_desc = "Лучше всего делиться с друзьями."

/datum/reagent/consumable/milkshake_chocolate
	name = "Шоколадный коктейль"
	description = "Небесный шоколадный эликсир."
	color = "#997755" // 153,119,85
	taste_description = "насыщенный шоколад"
	glass_icon_state = "milkshake_chocolate"
	glass_name = "пластиковый стаканчик с шоколадным молочным коктейлемe"
	glass_desc = "Напоминает кого-то, как ни странно."

/datum/chemical_reaction/drink/milkshake
	results = list(/datum.reagent/consumable/milkshake = 5)
	required_reagents = list(/datum/reagent/consumable/milk = 1, /datum/reagent/consumable/ice = 2, /datum/reagent/consumable/cream = 2)

/datum/chemical_reaction/drink/milkshake_chocolate
	results = list(/datum.reagent/consumable/milkshake_chocolate = 5)
	required_reagents = list(/datum/reagent/consumable/coco = 1, /datum.reagent/consumable/milkshake = 2, /datum/reagent/consumable/cream = 2)

/datum/chemical_reaction/drink/milkshake_strawberry
	results = list(/datum.reagent/consumable/milkshake_strawberry = 5)
	required_reagents = list(/datum/reagent/consumable/berryjuice = 1, /datum/reagent/consumable/ice = 2, /datum/reagent/consumable/cream = 2)

