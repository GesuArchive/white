
// see code/module/crafting/table.dm

////////////////////////////////////////////////SOUP////////////////////////////////////////////////

/datum/crafting_recipe/food/meatballsoup
	name = "Суп с фрикадельками"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/potato = 1
	)
	result = /obj/item/food/soup/meatball
	category = CAT_SOUP

/datum/crafting_recipe/food/vegetablesoup
	name = "Овощной суп"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/corn = 1,
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/potato = 1
	)
	result = /obj/item/food/soup/vegetable
	category = CAT_SOUP

/datum/crafting_recipe/food/nettlesoup
	name = "Суп из крапивы"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/nettle = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/boiledegg = 1
	)
	result = /obj/item/food/soup/nettle
	category = CAT_SOUP

/datum/crafting_recipe/food/wingfangchu
	name = "Суньвыньчу"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/food/meat/cutlet/xeno = 2
	)
	result = /obj/item/food/soup/wingfangchu
	category = CAT_SOUP

/datum/crafting_recipe/food/wishsoup
	name = "Суп желания"
	reqs = list(
		/datum/reagent/water = 20,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result= /obj/item/food/soup/wish
	category = CAT_SOUP

/datum/crafting_recipe/food/hotchili
	name = "Рагу из острого перца"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/soup/hotchili
	category = CAT_SOUP

/datum/crafting_recipe/food/coldchili
	name = "Рагу из ледяного чили"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/icepepper = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/soup/coldchili
	category = CAT_SOUP

/datum/crafting_recipe/food/clownchili
	name = "Чили кон карнивал"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/clothing/shoes/clown_shoes = 1
	)
	result = /obj/item/food/soup/clownchili
	category = CAT_SOUP

/datum/crafting_recipe/food/tomatosoup
	name = "Томатный суп"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/tomato = 2
	)
	result = /obj/item/food/soup/tomato
	category = CAT_SOUP

/datum/crafting_recipe/food/eyeballsoup
	name = "Суп с глазными яблоками"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/tomato = 2,
		/obj/item/organ/eyes = 1
	)
	result = /obj/item/food/soup/tomato/eyeball
	category = CAT_SOUP


/datum/crafting_recipe/food/milosoup
	name = "Мисосиру"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/soydope = 2,
		/obj/item/food/tofu = 2
	)
	result = /obj/item/food/soup/milo
	category = CAT_SOUP

/datum/crafting_recipe/food/bloodsoup
	name = "Кровавый суп"
	reqs = list(
		/datum/reagent/blood = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/tomato/blood = 2
	)
	result = /obj/item/food/soup/blood
	category = CAT_SOUP

/datum/crafting_recipe/food/slimesoup
	name = "Слаймовый суп"
	reqs = list(
			/datum/reagent/water = 10,
			/datum/reagent/toxin/slimejelly = 5,
			/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/slime
	category = CAT_SOUP

/datum/crafting_recipe/food/clownstears
	name = "Слезы клоуна"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/stack/sheet/mineral/bananium = 1
	)
	result = /obj/item/food/soup/clownstears
	category = CAT_SOUP

/datum/crafting_recipe/food/mysterysoup
	name = "Мистический суп"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/badrecipe = 1,
		/obj/item/food/tofu = 1,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/cheesewedge = 1,
	)
	result = /obj/item/food/soup/mystery
	category = CAT_SOUP

/datum/crafting_recipe/food/mushroomsoup
	name = "Грибной суп"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/water = 5,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/mushroom/chanterelle = 1
	)
	result = /obj/item/food/soup/mushroom
	category = CAT_SOUP

/datum/crafting_recipe/food/beetsoup
	name = "Борщ"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/whitebeet = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/soup/beet
	category = CAT_SOUP

/datum/crafting_recipe/food/stew
	name = "Стью"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/meat/cutlet = 3,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/mushroom = 1
	)
	result = /obj/item/food/soup/stew
	category = CAT_SOUP

/datum/crafting_recipe/food/spacylibertyduff
	name = "Наркотическая фригийская шняга"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 5,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/mushroom/libertycap = 3
	)
	result = /obj/item/food/soup/spacylibertyduff
	category = CAT_SOUP

/datum/crafting_recipe/food/amanitajelly
	name = "Мухоморное желе"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 5,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/mushroom/amanita = 3
	)
	result = /obj/item/food/soup/amanitajelly
	category = CAT_SOUP

/datum/crafting_recipe/food/sweetpotatosoup
	name = "Суп из сладкого картофеля"
	reqs = list(
		/datum/reagent/water = 10,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/potato/sweet = 2
	)
	result = /obj/item/food/soup/sweetpotato
	category = CAT_SOUP

/datum/crafting_recipe/food/redbeetsoup
	name = "Свекольник"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/redbeet = 1,
		/obj/item/food/grown/cabbage = 1
	)
	result = /obj/item/food/soup/beet/red
	category = CAT_SOUP

/datum/crafting_recipe/food/onionsoup
	name = "Французский луковый суп"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/cheesewedge = 1,
	)
	result = /obj/item/food/soup/onion
	category = CAT_SOUP

/datum/crafting_recipe/food/bisque
	name = "Суп-пюре"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/meat/crab = 1,
		/obj/item/food/salad/boiledrice = 1
	)
	result = /obj/item/food/soup/bisque
	category = CAT_SOUP

/datum/crafting_recipe/food/bungocurry
	name = "Бунго карри"
	reqs = list(
		/datum/reagent/water = 5,
		/datum/reagent/consumable/cream = 5,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/bungofruit = 1
	)
	result = /obj/item/food/soup/bungocurry
	category = CAT_SOUP

/datum/crafting_recipe/food/electron
	name = "Электризованный суп"
	reqs = list(
		/datum/reagent/water = 10,
		/datum/reagent/consumable/salt = 5,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/mushroom/jupitercup = 1
	)
	result = /obj/item/food/soup/electron
	category = CAT_SOUP

/datum/crafting_recipe/food/peasoup
	name = "Гороховый суп"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/food/grown/peas = 2,
		/obj/item/food/grown/parsnip = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/peasoup
	category = CAT_SOUP

/datum/crafting_recipe/food/oatmeal
	name = "Овсянка"
	reqs = list(
		/datum/reagent/consumable/milk = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/oat = 1
	)
	result = /obj/item/food/soup/oatmeal
	category = CAT_SOUP
