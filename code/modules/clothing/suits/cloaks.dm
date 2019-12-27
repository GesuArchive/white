//Cloaks. No, not THAT kind of cloak.

/obj/item/clothing/neck/cloak
	name = "коричневый плащ"
	desc = "Это плащ, который можно носить на шее."
	icon = 'icons/obj/clothing/cloaks.dmi'
	icon_state = "qmcloak"
	item_state = "qmcloak"
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESUITSTORAGE

/obj/item/clothing/neck/cloak/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is strangling [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return(OXYLOSS)

/obj/item/clothing/neck/cloak/hos
	name = "плащ главы службы безопасности"
	desc = "Носит Секуристан, управляя станцией железным кулаком."
	icon_state = "hoscloak"

/obj/item/clothing/neck/cloak/qm
	name = "плащ завхоза"
	desc = "Носит Каргония, снабжая станцию необходимыми инструментами для выживания."

/obj/item/clothing/neck/cloak/cmo
	name = "плащ главного врача"
	desc = "Носимые Медитопией, доблестные мужчины и женщины держат эпидемию в страхе."
	icon_state = "cmocloak"

/obj/item/clothing/neck/cloak/ce
	name = "плащ старшего инженера"
	desc = "Носит Энджитопия, обладатели неограниченной власти."
	icon_state = "cecloak"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/cloak/rd
	name = "плащ научного руководителя"
	desc = "Носят Сайенсия, тауматурги и исследователи вселенной."
	icon_state = "rdcloak"

/obj/item/clothing/neck/cloak/cap
	name = "плащ капитана"
	desc = "Носится командиром Космической Станции 13."
	icon_state = "capcloak"

/obj/item/clothing/neck/cloak/hop
	name = "плащ главы персонала"
	desc = "Носится начальником отдела кадров. Слабо пахнет бюрократией."
	icon_state = "hopcloak"

/obj/item/clothing/suit/hooded/cloak/goliath
	name = "плащ голиафа"
	icon_state = "goliath_cloak"
	desc = "Прочный практичный плащ из многочисленных кусков монстров, он востребован среди ссыльных и отшельников."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/pickaxe, /obj/item/twohanded/spear, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife/combat/bone, /obj/item/kitchen/knife/combat/survival)
	armor = list("melee" = 35, "bullet" = 10, "laser" = 25, "energy" = 35, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 60) //a fair alternative to bone armor, requiring alternative materials and gaining a suit slot
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/head/hooded/cloakhood/goliath
	name = "капюшон плаща голиафа"
	icon_state = "golhood"
	desc = "Защитный и скрывающий капюшон."
	armor = list("melee" = 35, "bullet" = 10, "laser" = 25, "energy" = 35, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 60)
	clothing_flags = SNUG_FIT
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	transparent_protection = HIDEMASK

/obj/item/clothing/suit/hooded/cloak/drake
	name = "доспехи дракона"
	icon_state = "dragon"
	desc = "Костюм доспехов из остатков пепельного дракона."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator, /obj/item/pickaxe, /obj/item/twohanded/spear)
	armor = list("melee" = 70, "bullet" = 30, "laser" = 50, "energy" = 50, "bomb" = 70, "bio" = 60, "rad" = 50, "fire" = 100, "acid" = 100)
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/drake
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	transparent_protection = HIDEGLOVES|HIDESUITSTORAGE|HIDEJUMPSUIT|HIDESHOES

/obj/item/clothing/head/hooded/cloakhood/drake
	name = "голова дракона"
	icon_state = "dragon"
	desc = "Череп дракона."
	armor = list("melee" = 70, "bullet" = 30, "laser" = 50, "energy" = 50, "bomb" = 70, "bio" = 60, "rad" = 50, "fire" = 100, "acid" = 100)
	clothing_flags = SNUG_FIT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
