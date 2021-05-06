/obj/item/stack/cannonball
	name = "пушечные ядра"
	desc = "Куча тяжелых ядер из пластали. Артиллерия космической эры!"
	icon_state = "cannonballs"
	max_amount = 14
	singular_name = "cannonball"
	merge_type = /obj/item/stack/cannonball
	throwforce = 10
	flags_1 = CONDUCT_1
	custom_materials = list(/datum/material/alloy/plasteel=MINERAL_MATERIAL_AMOUNT)
	resistance_flags = FIRE_PROOF
	throw_speed = 5
	throw_range = 3
	///the type of projectile this type of cannonball item turns into.
	var/obj/projectile/projectile_type = /obj/projectile/bullet/cannonball

/obj/item/stack/cannonball/update_icon_state()
	if(amount == 1)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_[min(amount, 14)]"


/obj/item/stack/cannonball/fourteen
	amount = 14

/obj/item/stack/cannonball/shellball
	name = "разрывные снаряды"
	singular_name = "explosive shellball"
	desc = "Пушечное ядро с анти-материальными и зенитными снарядами. Отлично справляется с стенами, создавая проходы."
	color = "#FF0000"
	merge_type = /obj/item/stack/cannonball/shellball
	projectile_type = /obj/projectile/bullet/cannonball/explosive

/obj/item/stack/cannonball/shellball/seven
	amount = 7

/obj/item/stack/cannonball/shellball/fourteen
	amount = 14

/obj/item/stack/cannonball/emp
	name = "ЭМИ снаряды"
	singular_name = "malfunction shot"
	icon_state = "emp_cannonballs"
	desc = "Снаряд внутри которого две камеры, которые объединяются при ударе, создавая химический электромагнитный импульс. Что все это значит? Кто знает. Современное пиратство действительно лишилось души с этими новомодными девайсами."
	max_amount = 4
	merge_type = /obj/item/stack/cannonball/emp
	projectile_type = /obj/projectile/bullet/cannonball/emp

/obj/item/stack/cannonball/the_big_one
	name = "\"Здоровяк\""
	singular_name = "\"The Biggest One\""
	desc = "Безумное количество взрывчатки в огромном пушечном ядре. Последнее пушечное ядро, которое вы выстрелите в бою, в основном потому, что после этого стрелять будет не в кого.."
	max_amount = 5
	icon_state = "biggest_cannonballs"
	merge_type = /obj/item/stack/cannonball/the_big_one
	projectile_type = /obj/projectile/bullet/cannonball/biggest_one

/obj/item/stack/cannonball/the_big_one/five
	amount = 5
