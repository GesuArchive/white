/datum/smithing_recipe
	var/name = ""
	var/result
	var/metal_type_need = "iron"
	var/max_resulting = 1

/datum/smithing_recipe/katanus
	name = "Катанус"
	result = /obj/item/blacksmith/katanus

/datum/smithing_recipe/zwei
	name = "Цвай"
	result = /obj/item/blacksmith/zwei

/datum/smithing_recipe/cep
	name = "Цеп"
	result = /obj/item/blacksmith/cep

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

/datum/smithing_recipe/kar98k
	name = "Винтовка Kar98k"
	result = /obj/item/blacksmith/gun_parts/kar98k

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
	name = "Корона"
	result = /obj/item/clothing/head/helmet/dwarf_crown
	metal_type_need = "none"
