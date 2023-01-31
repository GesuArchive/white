
//BeanieStation13 Redux

//Plus a bobble hat, lets be inclusive!!

/obj/item/clothing/head/beanie //Default is white, this is meant to be seen
	name = "белая шапочка"
	desc = "Стильная шапочка. Идеальный зимний аксессуар для тех, кто ценит моду, и для тех, кто просто не может справиться с холодным ветерком на голове."
	icon_state = "beanie"
	icon_preview = 'icons/obj/previews.dmi'
	icon_state_preview = "beanie_cloth"
	custom_price = PAYCHECK_ASSISTANT * 1.2
	greyscale_colors = "#EEEEEE#EEEEEE"
	greyscale_config = /datum/greyscale_config/beanie
	greyscale_config_worn = /datum/greyscale_config/beanie_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/beanie/black
	name = "чёрная шапочка"
	greyscale_colors = "#4A4A4B#4A4A4B"

/obj/item/clothing/head/beanie/red
	name = "красная шапочка"
	greyscale_colors = "#D91414#D91414"

/obj/item/clothing/head/beanie/green
	name = "зелёная шапочка"
	greyscale_colors = "#5C9E54#5C9E54"

/obj/item/clothing/head/beanie/darkblue
	name = "тёмно-синяя шапочка"
	greyscale_colors = "#1E85BC#1E85BC"

/obj/item/clothing/head/beanie/purple
	name = "фиолетовая шапочка"
	greyscale_colors = "#9557C5#9557C5"

/obj/item/clothing/head/beanie/yellow
	name = "жёлтая шапочка"
	greyscale_colors = "#E0C14F#E0C14F"

/obj/item/clothing/head/beanie/orange
	name = "оранжевая шапочка"
	greyscale_colors = "#C67A4B#C67A4B"

/obj/item/clothing/head/beanie/cyan
	name = "голубая шапочка"
	greyscale_colors = "#54A3CE#54A3CE"

//Striped Beanies have unique sprites

/obj/item/clothing/head/beanie/christmas
	name = "рождественская шапочка"
	greyscale_colors = "#038000#960000"

/obj/item/clothing/head/beanie/striped
	name = "полосатая шапочка"
	icon_state = "beaniestriped"

/obj/item/clothing/head/beanie/stripedred
	name = "красная полосатая шапочка"
	icon_state = "beaniestripedred"

/obj/item/clothing/head/beanie/stripedblue
	name = "синяя полосатая шапочка"
	icon_state = "beaniestripedblue"

/obj/item/clothing/head/beanie/stripedgreen
	name = "зелёная полосатая шапочка"
	icon_state = "beaniestripedgreen"

/obj/item/clothing/head/beanie/durathread
	name = "дюратканевая шапочка"
	desc = "Шапочка из дюраткани, эластичные волокна которой обеспечивают определенную защиту владельца."
	greyscale_colors = "#8291A1#8291A1"
	icon_preview = 'icons/obj/previews.dmi'
	icon_state_preview = "beanie_durathread"
	armor = list(MELEE = 15, BULLET = 5, LASER = 15, ENERGY = 25, BOMB = 10, BIO = 0, RAD = 0, FIRE = 30, ACID = 5)

/obj/item/clothing/head/waldo
	name = "красная полосатая качающаяся шапка"
	desc = "Если вы собрались в кругосветное путешествие вам понадобится защита от холода."
	icon_state = "waldo_hat"

/obj/item/clothing/head/rasta
	name = "расташляпа"
	desc = "Идеально подходит для засовывания дредов в эти дреды."
	icon_state = "beanierasta"

//No dog fashion sprites yet :(  poor Ian can't be dope like the rest of us yet
