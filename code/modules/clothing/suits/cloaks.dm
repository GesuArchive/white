//Cloaks. No, not THAT kind of cloak.

/obj/item/clothing/neck/cloak
	name = "коричневый плащ"
	desc = "Плащ, который можно носить на шее."
	icon = 'icons/obj/clothing/cloaks.dmi'
	icon_state = "qmcloak"
	inhand_icon_state = "qmcloak"
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESUITSTORAGE

/obj/item/clothing/neck/cloak/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is strangling [user.ru_na()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
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

/obj/item/clothing/neck/cloak/hop
	name = "плащ главы персонала"
	desc = "Носится начальником отдела кадров. Слабо пахнет бюрократией."
	icon_state = "hopcloak"

/obj/item/clothing/neck/cloak/hop
	name = "плащ главы персонала"
	desc = "Носится начальником отдела кадров. Слабо пахнет бюрократией."
	icon_state = "hopcloak"

/obj/item/clothing/neck/cloak/cape
	name = "admiral's cape"
	desc = "A sizable green cape with gold connects."
	icon_state = "admiralcape"
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESUITSTORAGE

/obj/item/clothing/neck/cloak/cape/grand
	name = "grand admiral's cape"
	desc = "A sizable white cape with gold connects."
	icon_state = "grand_admiral"

/obj/item/clothing/suit/hooded/cloak/goliath
	name = "плащ голиафа"
	icon_state = "goliath_cloak"
	desc = "Прочный практичный плащ из многочисленных кусков монстров, он востребован среди ссыльных и отшельников."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/pickaxe, /obj/item/spear, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife/combat/bone, /obj/item/kitchen/knife/combat/survival)
	armor = list(MELEE = 35, BULLET = 10, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 60, ACID = 60) //a fair alternative to bone armor, requiring alternative materials and gaining a suit slot
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/head/hooded/cloakhood/goliath
	name = "капюшон плаща голиафа"
	icon_state = "golhood"
	desc = "Защитный и скрывающий капюшон."
	armor = list(MELEE = 35, BULLET = 10, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 60, ACID = 60)
	clothing_flags = SNUG_FIT
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	transparent_protection = HIDEMASK

/obj/item/clothing/suit/hooded/cloak/drake
	name = "доспехи дракона"
	icon_state = "dragon"
	desc = "Костюм доспехов из остатков пепельного дракона."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator, /obj/item/pickaxe, /obj/item/spear)
	armor = list(MELEE = 65, BULLET = 15, LASER = 40, ENERGY = 40, BOMB = 70, BIO = 60, RAD = 50, FIRE = 100, ACID = 100)
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
	armor = list(MELEE = 65, BULLET = 15, LASER = 40, ENERGY = 40, BOMB = 70, BIO = 60, RAD = 50, FIRE = 100, ACID = 100)
	clothing_flags = SNUG_FIT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/hooded/cloak/godslayer
	name = "godslayer armour"
	icon_state = "godslayer"
	desc = "A suit of armour fashioned from the remnants of a knight's armor, and parts of a wendigo."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator, /obj/item/pickaxe, /obj/item/spear)
	armor = list(MELEE = 50, BULLET = 25, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 50, RAD = 100, FIRE = 100, ACID = 100)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/godslayer
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF | FREEZE_PROOF
	transparent_protection = HIDEGLOVES|HIDESUITSTORAGE|HIDEJUMPSUIT|HIDESHOES
	/// Amount to heal when the effect is triggered
	var/heal_amount = 500
	/// Time until the effect can take place again
	var/effect_cooldown_time = 10 MINUTES
	/// Current cooldown for the effect
	COOLDOWN_DECLARE(effect_cooldown)
	var/static/list/damage_heal_order = list(BRUTE, BURN, OXY)

/obj/item/clothing/head/hooded/cloakhood/godslayer
	name = "godslayer helm"
	icon_state = "godslayer"
	desc = "The horns and skull of a wendigo, held together by the remaining icey energy of a demonic miner."
	armor = list(MELEE = 50, BULLET = 25, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 50, RAD = 100, FIRE = 100, ACID = 100)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	flash_protect = FLASH_PROTECTION_WELDER
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = FIRE_PROOF | ACID_PROOF | FREEZE_PROOF

/obj/item/clothing/suit/hooded/cloak/godslayer/examine(mob/user)
	. = ..()
	if(loc == user && !COOLDOWN_FINISHED(src, effect_cooldown))
		. += "You feel like the revival effect will be able to occur again in [COOLDOWN_TIMELEFT(src, effect_cooldown) / 10] seconds."

/obj/item/clothing/suit/hooded/cloak/godslayer/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_OCLOTHING)
		RegisterSignal(user, COMSIG_MOB_STATCHANGE, PROC_REF(resurrect))
		return
	UnregisterSignal(user, COMSIG_MOB_STATCHANGE)

/obj/item/clothing/suit/hooded/cloak/godslayer/dropped(mob/user)
	..()
	UnregisterSignal(user, COMSIG_MOB_STATCHANGE)

/obj/item/clothing/suit/hooded/cloak/godslayer/proc/resurrect(mob/living/carbon/user, new_stat)
	SIGNAL_HANDLER
	if(new_stat > CONSCIOUS && new_stat < DEAD && COOLDOWN_FINISHED(src, effect_cooldown))
		user.heal_ordered_damage(heal_amount, damage_heal_order)
		user.visible_message(span_notice("[user] suddenly revives, as their armor swirls with demonic energy!"), span_notice("You suddenly feel invigorated!"))
		playsound(user.loc, 'sound/magic/clockwork/ratvar_attack.ogg', 50)
		COOLDOWN_START(src, effect_cooldown, effect_cooldown_time)

/obj/item/clothing/neck/cloak/skill_reward
	var/associated_skill_path = /datum/skill
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE

/obj/item/clothing/neck/cloak/skill_reward/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Ощущаю сильную ауру окружающую этот плащ. Предполагаю, что им может владеть только кто-то по настоящему опытный.</span>"

/obj/item/clothing/neck/cloak/skill_reward/proc/check_wearable(mob/user)
	return user.mind?.get_skill_level(associated_skill_path) < SKILL_LEVEL_LEGENDARY

/obj/item/clothing/neck/cloak/skill_reward/proc/unworthy_unequip(mob/user)
	to_chat(user, "<span class = 'notice'>Чую что я полностью и абсолютно не готов даже прикоснуться к <b>[src.name]</b>.</span>")
	var/hand_index = user.get_held_index_of_item(src)
	if (hand_index)
		user.dropItemToGround(src, TRUE)
	return FALSE

/obj/item/clothing/neck/cloak/skill_reward/equipped(mob/user, slot)
	if (check_wearable(user))
		unworthy_unequip(user)
	return ..()

/obj/item/clothing/neck/cloak/skill_reward/attack_hand(mob/user)
	if (check_wearable(user))
		unworthy_unequip(user)
	return ..()

/obj/item/clothing/neck/cloak/skill_reward/gaming
	name = "плащ легендарного геймера"
	desc = "Его носят только самые скилловые професиональные геймеры станции. Этот легендарный плащ можно получить только достигнув истинного геймерского просветления. Этот статусный символ представляет удивительную мощь сосредоточенности, решимости и чистой силы воли. То, чего казуальные геймеры никогда не поймут."
	icon_state = "gamercloak"
	associated_skill_path = /datum/skill/gaming

/obj/item/clothing/neck/cloak/skill_reward/cleaning
	name = "плащ легендарного уборщика"
	desc = "Его носят только самые скилловые хранители чистоты. Этот легендарный плащ можно получить только достигнув истинного уборочного просветления. Этот статусный символ представляет существо, не только хорошо обученное борьбе с грязью, а готовое использовать целиком свой арсенал чистящих средств для того чтобы целиком стереть это жалкое грязевое пятно с лица станции."
	icon_state = "cleanercloak"
	associated_skill_path = /datum/skill/cleaning

/obj/item/clothing/neck/cloak/skill_reward/mining
	name = "плащ легендарного шахтера"
	desc = "Его носят только самые скилловые Шахтеры. Этот легендарный плащ можно получить только достигнув истинного минерального просветления. Этот статусный символ представляет существо, которое забыло про камни больше, чем большинств шахтеров когда-либо узнает. Существо, которое сдвинуло горы и заполнило долины."
	icon_state = "minercloak"
	associated_skill_path = /datum/skill/mining

/obj/item/clothing/neck/cloak/skill_reward/playing
	name = "плащ легендарного ветерана"
	desc = "Его носят только мудрейшие из сотрудников. Этот легендарный плащ можно получить только заключив трудовой договор с NanoTrasen на срок более <b>пяти тысяч часов</b>. Этот статусный символ представляет существо, которое лучше вас почти во всех измеримых областях, только и всего."
	icon_state = "playercloak"

/obj/item/clothing/neck/cloak/skill_reward/playing/check_wearable(mob/user)
	return user.client?.get_exp_living(TRUE) >= PLAYTIME_VETERAN

/obj/item/clothing/neck/cloak/skill_reward/medic
	name = "плащ легендарного врача"
	desc = "Если вы увидите обладателя этого плаща, то будьте уверены - вы в надежных руках. Настоящий бог от медицины, способный реанимировать даже мумию прохлаждающуюся в саркофаге с позапрошлого тысячелетия."
	icon_state = "healercloak"
	associated_skill_path = /datum/skill/surgery
