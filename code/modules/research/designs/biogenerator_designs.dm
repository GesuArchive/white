///////////////////////////////////
///////Biogenerator Designs ///////
///////////////////////////////////

/datum/design/milk
	name = "Космическое молоко"
	desc = "Это молоко."
	id = "milk"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 100)
	build_path = /obj/item/reagent_containers/food/condiment/milk
	category = list("initial","Еда")

/datum/design/soymilk
	name = "Соевое молоко"
	desc = "Это соевое молоко."
	id = "soymilk"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 100 )
	build_path = /obj/item/reagent_containers/food/condiment/soymilk
	category = list("initial","Еда")

/datum/design/black_pepper
	name = "Перечница"
	desc = "Используется для придания блюду перчинки."
	id = "black_pepper"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 50)
	build_path = /obj/item/reagent_containers/food/condiment/peppermill
	category = list("initial","Еда")

/datum/design/enzyme
	name = "Универсальный фермент"
	desc = "Используется при приготовлении различных блюд."
	id = "enzyme"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 150)
	build_path = /obj/item/reagent_containers/food/condiment/enzyme
	category = list("initial","Еда")

/datum/design/flour
	name = "Мука"
	desc = "Хорошо подходит для выпечки!"
	id = "flour_sack"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 150)
	build_path = /obj/item/reagent_containers/food/condiment/flour
	category = list("initial","Еда")

/datum/design/ethanol
	name = "Этанол 10 единиц"
	desc = "Известный алкоголь с множеством применений."
	id = "ethanol"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 30)
	make_reagents = list(/datum/reagent/consumable/ethanol = 10)
	category = list("initial","Еда")

/datum/design/cream
	name = "Сливки 10 единиц"
	desc = "Жирные сливки, изготовленные из натурального молока. Почему бы тебе не смешать это со скотчем, а?"
	id = "cream"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 30)
	make_reagents = list(/datum/reagent/consumable/cream = 10)
	category = list("initial","Еда")

/datum/design/strange_seed
	name = "Пачка странных семян"
	desc = "Такие же странные, как и их название. Стрёмно."
	id = "strange_seed"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 5000)
	build_path = /obj/item/seeds/random
	category = list("initial","Разное")

/datum/design/monkey_cube
	name = "Обезьяний кубик"
	desc = "Просто добавь воды!"
	id = "mcube"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 250)
	build_path = /obj/item/food/monkeycube
	category = list("initial","Еда")

/datum/design/ez_nut
	name = "E-Z-Nutrient"
	desc = "Содержит электролиты. Это то, чего жаждут растения."
	id = "ez_nut"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 10)
	make_reagents = list(/datum/reagent/plantnutriment/eznutriment = 25)
	category = list("initial","Химикаты")

/datum/design/l4z_nut
	name = "Left 4 Zed 25 единиц"
	desc = "Нестабильные удобрения, из-за которой растения мутируют чаще, чем обычно."
	id = "l4z_nut"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 20)
	make_reagents = list(/datum/reagent/plantnutriment/left4zednutriment = 25)
	category = list("initial","Химикаты")

/datum/design/rh_nut
	name = "Надежный Урожай 25 единиц"
	desc = "Очень мощное удобрение, которое замедляет мутацию растений."
	id = "rh_nut"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 25)
	make_reagents = list(/datum/reagent/plantnutriment/robustharvestnutriment = 25)
	category = list("initial","Химикаты")

/datum/design/end_gro
	name = "Эндуро-рост 25 единиц"
	desc = "Специализированная подкормка, которая уменьшает количество продукта и их потенциал, но повышает выносливость растений."
	id = "end_gro"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 30)
	make_reagents = list(/datum/reagent/plantnutriment/endurogrow = 25)
	category = list("initial","Химикаты")

/datum/design/liq_earth
	name = "Жидкая Встряска 25 единиц"
	desc = "Специализированная подкормка, которая увеличивает скорость роста растения, но также ухудшает его восприимчивость к сорнякам."
	id = "liq_earth"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 30)
	make_reagents = list(/datum/reagent/plantnutriment/liquidearthquake = 25)
	category = list("initial","Химикаты")

/datum/design/weed_killer
	name = "Гербицид против сорняков 25 единиц"
	desc = "Опасный токсин для выведения сорняков. Не употреблять внутрь!"
	id = "weed_killer"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 50)
	make_reagents = list(/datum/reagent/toxin/plantbgone/weedkiller = 25)
	category = list("initial","Химикаты")

/datum/design/pest_spray
	name = "Пестицид против паразитов 25 единиц"
	desc = "Опасный токсин для убийства насекомых. Не употреблять внутрь!"
	id = "pest_spray"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 50)
	make_reagents = list(/datum/reagent/toxin/pestkiller = 25)
	category = list("initial","Химикаты")

/datum/design/org_pest_spray
	name = "Пестицид мягкого действия 25 единиц"
	desc = "Органическая смесь, используемая для убийства насекомых с более мягкими последствиями. Не употреблять внутрь!"
	id = "org_pest_spray"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 80)
	make_reagents = list(/datum/reagent/toxin/pestkiller/organic = 25)
	category = list("initial","Химикаты")

/datum/design/cloth
	name = "Ткань"
	desc = "Это хлопок? Лен? Джинса? Мешковина? Канва? Не могу сказать."
	id = "cloth"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 50)
	build_path = /obj/item/stack/sheet/cloth
	category = list("initial","Органика")

/datum/design/cardboard
	name = "Картон"
	desc = "Большие листы картона, выглядят как плоские коробки."
	id = "cardboard"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 25)
	build_path = /obj/item/stack/sheet/cardboard
	category = list("initial","Органика")

/datum/design/rolling_paper_pack
	name = "Упаковка папиросной бумаги"
	desc = "Тонкий лист бумаги, используемый для приготовления сигаретных изделий."
	id = "rolling_paper_pack"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 50)
	build_path = /obj/item/storage/fancy/rollingpapers
	category = list("initial","Органика")

/datum/design/leather
	name = "Кожа"
	desc = "Побочный продукт разведения животных."
	id = "leather"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 150)
	build_path = /obj/item/stack/sheet/leather
	category = list("initial","Органика")

/datum/design/secbelt
	name = "Пояс офицера"
	desc = "Может хранить наручники, флэшки, но не преступников."
	id = "secbelt"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 300)
	build_path = /obj/item/storage/belt/security
	category = list("initial","Органика")

/datum/design/medbelt
	name = "Медицинский пояс"
	desc = "Может хранить различные медицинские штуки."
	id = "medbel"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 300)
	build_path = /obj/item/storage/belt/medical
	category = list("initial","Органика")

/datum/design/janibelt
	name = "Убор-пояс"
	desc = "На ремне хранится большинство принадлежностей для уборки."
	id = "janibelt"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 300)
	build_path = /obj/item/storage/belt/janitor
	category = list("initial","Органика")

/datum/design/plantbelt
	name = "Ботанический пояс"
	desc = "Пояс, используемый для хранения большинства принадлежностей для гидропоники. Удивительно, но не зеленый."
	id = "plantbelt"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 300)
	build_path = /obj/item/storage/belt/plant
	category = list("initial","Органика")

/datum/design/s_holster
	name = "Пистолетная кобура"
	desc = "Довольно простая, но все равно классно выглядящая кобура, в которую можно поместить пистолет."
	id = "s_holster"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 400)
	build_path = /obj/item/storage/belt/holster
	category = list("initial","Органика")

/datum/design/rice_hat
	name = "Рисовая шляпа"
	desc = "Добро пожаловать на рисовые поля, ублюдок."
	id = "rice_hat"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass= 300)
	build_path = /obj/item/clothing/head/rice_hat
	category = list("initial","Органика")
