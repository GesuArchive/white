
// see code/module/crafting/table.dm

////////////////////////////////////////////////CAKE////////////////////////////////////////////////

/datum/crafting_recipe/food/carrotcake
	name = "Морковный торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/carrot = 2
	)
	result = /obj/item/food/cake/carrot
	category = CAT_CAKE

/datum/crafting_recipe/food/cheesecake
	name = "Сырный торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/cake/cheese
	category = CAT_CAKE

/datum/crafting_recipe/food/applecake
	name = "Яблочный торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/apple = 2
	)
	result = /obj/item/food/cake/apple
	category = CAT_CAKE

/datum/crafting_recipe/food/orangecake
	name = "Апельсиновый торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/orange = 2
	)
	result = /obj/item/food/cake/orange
	category = CAT_CAKE

/datum/crafting_recipe/food/limecake
	name = "Лаймовый торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/lime = 2
	)
	result = /obj/item/food/cake/lime
	category = CAT_CAKE

/datum/crafting_recipe/food/lemoncake
	name = "Лимонный торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/lemon = 2
	)
	result = /obj/item/food/cake/lemon
	category = CAT_CAKE

/datum/crafting_recipe/food/chocolatecake
	name = "Шоколадный торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/chocolatebar = 2
	)
	result = /obj/item/food/cake/chocolate
	category = CAT_CAKE

/datum/crafting_recipe/food/birthdaycake
	name = "Праздничный торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/candle = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/caramel = 2
	)
	result = /obj/item/food/cake/birthday
	category = CAT_CAKE

/datum/crafting_recipe/food/energycake
	name = "Энерго торт"
	reqs = list(
		/obj/item/food/cake/birthday = 1,
		/obj/item/melee/energy/sword = 1,
	)
	blacklist = list(/obj/item/food/cake/birthday/energy)
	result = /obj/item/food/cake/birthday/energy
	category = CAT_CAKE

/datum/crafting_recipe/food/braincake
	name = "Торт с мозгами"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/brain
	category = CAT_CAKE

/datum/crafting_recipe/food/slimecake
	name = "Слаймовый торт"
	reqs = list(
		/obj/item/slime_extract = 1,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/slimecake
	category = CAT_CAKE

/datum/crafting_recipe/food/pumpkinspicecake
	name = "Тыквенно-пряный торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/pumpkin = 2
	)
	result = /obj/item/food/cake/pumpkinspice
	category = CAT_CAKE

/datum/crafting_recipe/food/holycake
	name = "Торт \"Пища Ангелов\""
	reqs = list(
		/datum/reagent/water/holywater = 15,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/holy_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/poundcake
	name = "Фунтовый торт"
	reqs = list(
		/obj/item/food/cake/plain = 4
	)
	result = /obj/item/food/cake/pound_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/hardwarecake
	name = "Аппаратурный торт"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/circuitboard = 2,
		/datum/reagent/toxin/acid = 5
	)
	result = /obj/item/food/cake/hardware_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/bscccake
	name = "Шоколадный торт с ежевикой и клубникой"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/chocolatebar = 2,
		/obj/item/food/grown/berries = 5
	)
	result = /obj/item/food/cake/bscc
	category = CAT_CAKE

/datum/crafting_recipe/food/bscvcake
	name = "Ванильный торт с ежевикой и клубникой"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/berries = 5
	)
	result = /obj/item/food/cake/bsvc
	category = CAT_CAKE

/datum/crafting_recipe/food/clowncake
	name = "Клоунский торт"
	always_available = FALSE
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/sundae = 2,
		/obj/item/food/grown/banana = 5
	)
	result = /obj/item/food/cake/clown_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/vanillacake
	name = "Ванильный торт"
	always_available = FALSE
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/vanillapod = 2
	)
	result = /obj/item/food/cake/vanilla_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/trumpetcake
	name = "Торт космонавтов"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/trumpet = 2,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/berryjuice = 5
	)
	result = /obj/item/food/cake/trumpet
	category = CAT_CAKE


/datum/crafting_recipe/food/cak
	name = "Живой торт"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/organ/heart = 1,
		/obj/item/food/cake/birthday = 1,
		/obj/item/food/meat/slab = 3,
		/datum/reagent/blood = 30,
		/datum/reagent/consumable/sprinkles = 5,
		/datum/reagent/teslium = 1 //To shock the whole thing into life
	)
	result = /mob/living/simple_animal/pet/cat/cak
	category = CAT_CAKE //Cat! Haha, get it? CAT? GET IT? We get it - Love Felines
