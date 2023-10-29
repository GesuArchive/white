/obj/item/gun/energy/laser
	name = "лазерная винтовка"
	desc = "Основная лазерная пушка на основе энергии, которая запускает концентрированные лучи света, которые проходят через стекло и тонкий металл."
	icon_state = "laser"
	inhand_icon_state = "laser"
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron=2000)
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	ammo_x_offset = 1
	shaded_charge = 1

/obj/item/gun/energy/laser/practice
	name = "тренировочная лазерная винтовка"
	desc = "Модифицированная версия базовой лазерной пушки, эта стреляет менее концентрированными энергетическими зарядами, предназначенными для целевой практики."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/practice)
	clumsy_check = FALSE
	item_flags = NONE

/obj/item/gun/energy/laser/retro
	name ="ретро-лазерная пушка"
	icon_state = "retro"
	desc = "Старая модель основного лазерного оружия, более не используемая частной службой безопасности или вооруженными силами НаноТрейзен. Тем не менее, он все еще довольно смертоносен и прост в обслуживании, что делает его фаворитом среди пиратов и других преступников."
	ammo_x_offset = 3

/obj/item/gun/energy/laser/retro/old
	name ="лазерная пушка"
	icon_state = "retro"
	desc = "Лазерное ружье первого поколения, разработанное НаноТрейзен. Страдает от проблем с боеприпасами, но его уникальная способность заряжать боеприпасы без необходимости в заряднике помогает компенсировать это. Вы действительно надеетесь, что кто-то разработал лучшую лазерную пушку, пока вы были в крио."
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/old)
	ammo_x_offset = 3
	selfcharge = 1

/obj/item/gun/energy/laser/hellgun
	name = "лазерная пушка \"Адское пламя\""
	desc = "Реликвия, построенная до того, как НаноТрейзен начала устанавливать регуляторы на свое лазерное оружие. Этот образец лазерного оружия стал печально известным из-за ужасных ожоговых ран, которые он вызвал, и был тихо прекращен, как только это начало влиять на репутацию NT."
	icon_state = "hellgun"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/hellfire)

/obj/item/gun/energy/laser/captain
	name = "Антикварный лазерный пистолет"
	icon_state = "caplaser"
	w_class = WEIGHT_CLASS_NORMAL
	inhand_icon_state = null
	desc = "Антикварный лазерный пистолет, полностью выполненный с высочайшим качеством. Декорирован кожей ассистента и хромом. Всплески энергии пронизывают его насквозь. На пистолете есть изображение Космической Станции 13. А точнее взрывающейся Космической Станции 13."
	force = 10
	ammo_x_offset = 3
	selfcharge = 1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	ammo_type = list(/obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/laser/captain/scattershot
	name = "лазерная винтовка Scatter Shot"
	icon_state = "lasercannon"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "laser"
	desc = "Промышленная сверхмощная лазерная винтовка с модифицированной лазерной линзой, позволяющая рассеять выстрел в несколько меньших лазеров. Внутреннее ядро может заряжаться для теоретически бесконечного использования."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter, /obj/item/ammo_casing/energy/laser)
	shaded_charge = FALSE

/obj/item/gun/energy/laser/cyborg
	can_charge = FALSE
	desc = "Основанная на энергии лазерная пушка, которая получает энергию непосредственно от внутренней энергетической ячейки киборга. Так вот как выглядит свобода?"
	use_cyborg_cell = TRUE

/obj/item/gun/energy/laser/cyborg/make_jamming()
	return

/obj/item/gun/energy/laser/cyborg/emp_act()
	return

/obj/item/gun/energy/laser/scatter
	name = "энергетический дробовик"
	desc = "Лазерная пушка оснащена рефракционным набором, который расставляет болты."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter, /obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/laser/scatter/shotty
	name = "энергетический дробовик"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "cshotgun"
	inhand_icon_state = "shotgun"
	desc = "Боевой дробовик распотрошен и оснащен внутренней лазерной системой. Может переключаться между тазером и рассеянным выстрелом."
	shaded_charge = 0
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter/disabler, /obj/item/ammo_casing/energy/electrode)
	automatic_charge_overlays = FALSE

///Laser Cannon

/obj/item/gun/energy/lasercannon
	name = "ускоряющая лазерная пушка"
	desc = "Усовершенствованная лазерная пушка, которая наносит больше урона по мере удаления от цели."
	icon_state = "lasercannon"
	inhand_icon_state = "laser"
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/laser/accelerator)
	ammo_x_offset = 3

/obj/item/ammo_casing/energy/laser/accelerator
	projectile_type = /obj/projectile/beam/laser/accelerator
	select_name = "accelerator"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/projectile/beam/laser/accelerator
	name = "ускоренный лазер"
	icon_state = "scatterlaser"
	range = 255
	damage = 6

/obj/projectile/beam/laser/accelerator/Range()
	..()
	damage += 7
	transform *= 1 + ((damage/7) * 0.2)//20% larger per tile

///X-ray gun

/obj/item/gun/energy/xray
	name = "рентгеновская лазерная винтовка"
	desc = "Мощная лазерная пушка, способная излучать концентрированные рентгеновские заряды, которые проходят через множество мягких целей и более тяжелых материалов."
	icon_state = "xray"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/xray)
	ammo_x_offset = 3

/obj/item/gun/energy/xray/violence
	extra_damage = 15

////////Laser Tag////////////////////

/obj/item/gun/energy/laser/bluetag
	name = "лазертаг"
	icon_state = "bluetag"
	desc = "Ретро лазерный пистолет, модифицированный для стрельбы безобидными голубыми лучами света Звуковые эффекты включены!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag)
	item_flags = NONE
	clumsy_check = FALSE
	pin = /obj/item/firing_pin/tag/blue
	ammo_x_offset = 2
	selfcharge = TRUE

/obj/item/gun/energy/laser/bluetag/hitscan
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag/hitscan)

/obj/item/gun/energy/laser/redtag
	name = "лазертаг"
	icon_state = "redtag"
	desc = "Ретро лазерный пистолет, модифицированный для стрельбы безвредными лучами красного света. Звуковые эффекты включены!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag)
	item_flags = NONE
	clumsy_check = FALSE
	pin = /obj/item/firing_pin/tag/red
	ammo_x_offset = 2
	selfcharge = TRUE

/obj/item/gun/energy/laser/redtag/hitscan
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag/hitscan)

//Inferno and Cryo Pistols

/obj/item/gun/energy/laser/thermal //the common parent of these guns, it just shoots hard bullets, somoene might like that?
	name = "нанопистолет"
	desc = "Модифицированная версия термолучевого пистолета стреляющего списанными боевыми нанитами."
	icon_state = "infernopistol"
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/nanite)
	shaded_charge = TRUE
	ammo_x_offset = 1
	can_bayonet = TRUE
	knife_x_offset = 19
	knife_y_offset = 13
	w_class = WEIGHT_CLASS_NORMAL
	dual_wield_spread = 10 //as intended by the coders

/obj/item/gun/energy/laser/thermal/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS)

/obj/item/gun/energy/laser/thermal/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 9)

/obj/item/gun/energy/laser/thermal/inferno //the magma gun
	name = "пиролучевой пистолет"
	icon_state = "infernopistol"
	ammo_type = list(/obj/item/ammo_casing/energy/nanite/inferno)

/obj/item/gun/energy/laser/thermal/cryo //the ice gun
	name = "криолучевой пистолет"
	icon_state = "cryopistol"
	ammo_type = list(/obj/item/ammo_casing/energy/nanite/cryo)
