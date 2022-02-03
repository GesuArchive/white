/datum/smithing_recipe
	var/name = ""
	var/result
	var/metal_type_need = "iron"
	var/max_resulting = 1

/datum/smithing_recipe/katanus
	name = "\[Заготовка\] Лезвие катануса"
	result = /obj/item/blacksmith/partial/katanus

/datum/smithing_recipe/zwei
	name = "\[Заготовка\] Лезвие цвая"
	result = /obj/item/blacksmith/partial/zwei

/datum/smithing_recipe/cep
	name = "\[Заготовка\] Шар с цепью"
	result = /obj/item/blacksmith/partial/cep

/datum/smithing_recipe/dwarfsord
	name = "\[Заготовка\] Лезвие прямого меча"
	result = /obj/item/blacksmith/partial/dwarfsord

/datum/smithing_recipe/dagger
	name = "Кинжал"
	result = /obj/item/blacksmith/dagger
	max_resulting = 3

/datum/smithing_recipe/pickaxe
	name = "Кирка"
	result = /obj/item/pickaxe

/datum/smithing_recipe/shovel
	name = "Лопата"
	result = /obj/item/shovel
	max_resulting = 2

/datum/smithing_recipe/smithing_hammer
	name = "Молот"
	result = /obj/item/blacksmith/smithing_hammer

/datum/smithing_recipe/tongs
	name = "Клещи"
	result = /obj/item/blacksmith/tongs
	max_resulting = 2

/datum/smithing_recipe/chisel
	name = "Стамеска (камень)"
	result = /obj/item/blacksmith/chisel
	max_resulting = 2

/datum/smithing_recipe/chisel_retard
	name = "Стамеска (скульптуры)"
	result = /obj/item/chisel
	max_resulting = 2

/datum/smithing_recipe/light_plate
	name = "Нагрудник"
	result = /obj/item/clothing/suit/armor/light_plate

/datum/smithing_recipe/heavy_plate
	name = "Латный доспех"
	result = /obj/item/clothing/suit/armor/heavy_plate

/datum/smithing_recipe/chainmail
	name = "Кольчуга"
	result = /obj/item/clothing/under/chainmail

/datum/smithing_recipe/plate_helmet
	name = "Шлем"
	result = /obj/item/clothing/head/helmet/plate_helmet
	max_resulting = 2

/datum/smithing_recipe/plate_gloves
	name = "Перчатки"
	result = /obj/item/clothing/gloves/plate_gloves
	max_resulting = 3

/datum/smithing_recipe/plate_boots
	name = "Ботинки"
	result = /obj/item/clothing/shoes/jackboots/plate_boots
	max_resulting = 3

/datum/smithing_recipe/torch_fixture
	name = "Скоба"
	result = /obj/item/blacksmith/torch_handle
	max_resulting = 5

/datum/smithing_recipe/shpatel
	name = "Мастерок"
	result = /obj/item/blacksmith/shpatel
	max_resulting = 2

/datum/smithing_recipe/scepter
	name = "Золотая цепочка"
	result = /obj/item/clothing/neck/necklace/dope
	metal_type_need = "gold"

/datum/smithing_recipe/scepter
	name = "Скипетр"
	result = /obj/item/blacksmith/scepter
	metal_type_need = "none"

/datum/smithing_recipe/crown
	name = "Пустая корона"
	result = /obj/item/blacksmith/partial/crown_empty
	metal_type_need = "gold"

/datum/smithing_recipe/scepter
	name = "Части скипетра"
	result = /obj/item/blacksmith/partial/scepter_part
	metal_type_need = "gold"

/datum/workbench_recipe
	var/name = "workbench_recipe"
	var/result
	var/list/reqs
	var/obj/primary

/datum/workbench_recipe/zwei
	name = "Цвай"
	result = /obj/item/blacksmith/zwei
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3, /obj/item/stack/sheet/leather = 2, /obj/item/blacksmith/partial/zwei=1)
	primary = /obj/item/blacksmith/partial/zwei

/datum/workbench_recipe/katanus
	name = "Катанус"
	result = /obj/item/blacksmith/katanus
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3, /obj/item/stack/sheet/leather = 2,/obj/item/blacksmith/partial/katanus=1)
	primary = /obj/item/blacksmith/partial/katanus

/datum/workbench_recipe/cep
	name = "Цеп"
	result = /obj/item/blacksmith/cep
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2, /obj/item/blacksmith/partial/cep=1)
	primary = /obj/item/blacksmith/partial/cep

/datum/workbench_recipe/sword
	name = "Прямой меч"
	result = /obj/item/blacksmith/dwarfsord
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2, /obj/item/stack/sheet/leather = 1, /obj/item/blacksmith/partial/dwarfsord=1)
	primary = /obj/item/blacksmith/partial/dwarfsord

/datum/workbench_recipe/crown
	name = "Королевская корона"
	result = /obj/item/clothing/head/helmet/dwarf_crown
	reqs = list(/obj/item/gem/cut/saphire = 3, /obj/item/blacksmith/partial/crown_empty = 1)
	primary = /obj/item/blacksmith/partial/crown_empty

/datum/workbench_recipe/scepter
	name = "Скипетр власти"
	result = /obj/item/blacksmith/scepter
	reqs = list(/obj/item/gem/cut/ruby = 1, /obj/item/blacksmith/partial/scepter_part = 1, /obj/item/scepter_shaft = 1)
	primary = /obj/item/blacksmith/partial/scepter_part

/datum/workbench_recipe/dagger_sneath
	name = "Ножны кинжала"
	result = /obj/item/storage/belt/dagger_sneath
	reqs = list(/obj/item/stack/sheet/leather = 3)
	primary = null
