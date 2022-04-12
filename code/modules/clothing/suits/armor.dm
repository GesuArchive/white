/obj/item/clothing/suit/armor
	allowed = null
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	var/full_armor_flag = FALSE		//	Используется исключительно для проверки на возможность модернизации
	var/disassembly_flag = FALSE	//	Проверка на возможность разборки при помощи инструментов
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate/plasteel)
	if(!allowed)
		allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/armor/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/datum/component/armor_plate/plasteel/ap = GetComponent(/datum/component/armor_plate/plasteel)
		if(ap?.amount)
			var/mutable_appearance/armor_overlay = mutable_appearance('icons/mob/clothing/suit.dmi', "armor_plasteel_[ap.amount]")
			. += armor_overlay

/obj/item/clothing/suit/armor/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/full_armor_upgrade))
		if(!full_armor_flag)
			full_armor_flag = TRUE
			playsound(user, 'sound/items/equip/toolbelt_equip.ogg', 70, TRUE)
			to_chat(user, span_notice("Прикрепляю дополнительные элементы защиты рук и ног к [src]."))
			body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
			cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
			heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
			qdel(W)
		else
			to_chat(user, span_warning("Данная броня уже усилена дополнительными элементами защиты рук и ног."))

	if(W.tool_behaviour == TOOL_SCREWDRIVER)

		var/datum/component/armor_plate/plasteel/ap = GetComponent(/datum/component/armor_plate/plasteel)
		if(ap?.amount)
			to_chat(user, span_notice("Извлекаю внешние бронепластины..."))
			playsound(user, 'sound/items/screwdriver.ogg',70, TRUE)
			if(!do_after(user, 5 SECONDS, src))
				return TRUE
			playsound(user, 'sound/items/handling/toolbelt_pickup.ogg', 70, TRUE)
			for(var/i in 1 to ap.amount)
				new /obj/item/stack/sheet/plasteel_armor_plate(src.drop_location())
			ap.amount = 0

		if(disassembly_flag)
			if(istype(src, /obj/item/clothing/suit/armor/bulletproof))
				to_chat(user, span_notice("Извлекаю дополнительную бронепластину и перераспределяю оставшиеся по стандартной схеме..."))
				playsound(user, 'sound/items/screwdriver.ogg', 70, TRUE)
				if(!do_after(user, 5 SECONDS, src))
					return TRUE
				playsound(user, 'sound/items/handling/crowbar_drop.ogg', 70, TRUE)
				new /obj/item/clothing/suit/armor/vest(src.drop_location())
				new /obj/item/stack/sheet/plasteel_armor_plate(src.drop_location())
				qdel(src)
				return

			if(istype(src, /obj/item/clothing/suit/armor/riot))
				to_chat(user, span_notice("Снимаю дополнительные слои дюраткани и перераспределяю бронепластины по стандартной схеме..."))
				playsound(user, 'sound/items/screwdriver.ogg', 70, TRUE)
				if(!do_after(user, 5 SECONDS, src))
					return TRUE
				playsound(user, 'sound/items/handling/cloth_pickup.ogg', 70, TRUE)
				new /obj/item/stack/sheet/durathread/six(src.drop_location())
				new /obj/item/stack/sheet/plasteel_armor_plate(src.drop_location())
				qdel(src)
				return

			if(istype(src, /obj/item/clothing/suit/armor/vest/old))
				to_chat(user, span_notice("Извлекаю заклепки и расслабляю шнуровку..."))
				playsound(user, 'sound/items/screwdriver.ogg', 70, TRUE)
				if(!do_after(user, 5 SECONDS, src))
					return TRUE
				playsound(user, 'sound/items/handling/cloth_pickup.ogg', 70, TRUE)
				to_chat(user, span_warning("Стоило мне отковырять пару заклепок и бронежилет развалился на части!"))
				new /obj/item/stack/sheet/durathread/ten(src.drop_location())
				new /obj/item/stack/sheet/plasteel_armor_plate(src.drop_location())
				new /obj/item/stack/sheet/plasteel_armor_plate(src.drop_location())
				qdel(src)
				return

			if(istype(src, /obj/item/clothing/suit/armor/vest))
				to_chat(user, span_notice("Извлекаю заклепки и расслабляю шнуровку..."))
				playsound(user, 'sound/items/screwdriver.ogg', 70, TRUE)
				if(!do_after(user, 5 SECONDS, src))
					return TRUE
				playsound(user, 'sound/items/handling/cloth_pickup.ogg', 70, TRUE)
				new /obj/item/armor_disassembly(src.drop_location())
				qdel(src)
				return

/obj/item/clothing/suit/armor/examine(mob/user)
	. = ..()
	if(disassembly_flag)
		. += "<hr><span class='notice'>Замечаю заклепки, я думаю их можно вытащить при помощи <b>отвертки</b>.</span>"

/obj/item/clothing/suit/armor/vest
	name = "бронежилет"
	desc = "Тонкий бронированный жилет Тип I, обеспечивающий достойную защиту от большинства видов повреждений."
	icon_state = "armoralt"
	inhand_icon_state = "armoralt"
	blood_overlay_type = "armor"
	dog_fashion = /datum/dog_fashion/back
	disassembly_flag = TRUE

/obj/item/clothing/suit/armor/vest/alt
	desc = "Бронированный жилет Тип I, обеспечивающий достойную защиту от большинства видов повреждений."
	icon_state = "armor"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/vest/marine
	name = "tactical armor vest"
	desc = "A set of the finest mass produced, stamped plasteel armor plates, containing an environmental protection unit for all-condition door kicking."
	icon_state = "marine_command"
	inhand_icon_state = "armor"
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 50, BULLET = 50, LASER = 30, ENERGY = 25, BOMB = 50, BIO = 100, FIRE = 40, ACID = 50, WOUND = 20)
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	full_armor_flag	= TRUE
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/vest/marine/security
	name = "large tactical armor vest"
	icon_state = "marine_security"

/obj/item/clothing/suit/armor/vest/marine/engineer
	name = "tactical utility armor vest"
	icon_state = "marine_engineer"

/obj/item/clothing/suit/armor/vest/marine/medic
	name = "tactical medic's armor vest"
	icon_state = "marine_medic"

/obj/item/clothing/suit/armor/vest/old
	name = "старый бронежилет"
	desc = "Бронежилет Тип I старого поколения. Ввиду использования старых технологий создания бронежилета, является менее маневрененным для перемещения."
	icon = 'white/rebolution228/icons/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/suits_mob.dmi'
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 15, BIO = 0, RAD = 0, FIRE = 30, ACID = 10, WOUND = 5)
	icon_state = "armor_old"
	inhand_icon_state = "armor"
	slowdown = 0.4

/obj/item/clothing/suit/armor/vest/blueshirt
	name = "большой бронежилет"
	desc = "Большой, но удобный кусок брони, защищающий вас от некоторых угроз."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	custom_premium_price = PAYCHECK_HARD

/obj/item/clothing/suit/armor/vest/cuirass
	name = "cuirass"
	desc = "A lighter plate armor used to still keep out those pesky arrows, while retaining the ability to move."
	icon_state = "cuirass"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/hos
	name = "бронепальто"
	desc = "Великолепное пальто, усиленное специальным сплавом для дополнительной защиты и стиля для тех, кто командует присутствием."
	icon_state = "hos"
	inhand_icon_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 70, ACID = 90, WOUND = 10)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	full_armor_flag	= TRUE
	disassembly_flag = FALSE
	strip_delay = 80

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "бронированный плащ"
	desc = "Тренч, усиленный специальным легким кевларом. Воплощение тактической штатской одежды."
	icon_state = "hostrench"
	inhand_icon_state = "hostrench"
	flags_inv = 0
	strip_delay = 80

/obj/item/clothing/suit/armor/vest/warden
	name = "куртка надзирателя"
	desc = "Темно-синяя бронированная куртка с синими плечевыми надписями и надписью «Warden» на одном из нагрудных карманов."
	icon_state = "warden_alt"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	strip_delay = 70
	resistance_flags = FLAMMABLE
	dog_fashion = null
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "бронежилет надзирателя"
	desc = "Красный пиджак с серебряными бортиками и бронепластинами сверху."
	icon_state = "warden_jacket"

/obj/item/clothing/suit/armor/vest/leather
	name = "защитное пальто"
	desc = "Кожаное пальто в легкой броне предназначалось как повседневная одежда для высокопоставленных офицеров. Несет герб Безопасности NanoTrasen."
	icon_state = "leathercoat-sec"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	full_armor_flag	= TRUE
	dog_fashion = null
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/vest/leather/noname
	desc = "Кожаное пальто в легкой броне. Элегантно и практично." //временный костыль-подпорка для сноса говна зерги.
/obj/item/clothing/suit/armor/vest/capcarapace
	name = "капитанский панцирь"
	desc = "Огнеупорный бронированный нагрудник, усиленный керамическими пластинами и пластиковыми полтронами, для обеспечения дополнительной защиты, при этом обеспечивая максимальную мобильность и гибкость. Выпускается только для лучших станций, хотя это действительно раздражает соски."
	icon_state = "capcarapace"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 50, BOMB = 25, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)
	dog_fashion = null
	resistance_flags = FIRE_PROOF
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	name = "жилет капитана синдиката"
	desc = "Зловеще выглядящий жилет из усовершенствованной брони, надетый на черно-красную огнезащитную куртку. Золотой воротник и плечи означают, что это принадлежит высокопоставленному чиновнику синдиката."
	icon_state = "syndievest"

/obj/item/clothing/suit/toggle/captains_parade
	name = "парадная куртка капитана"
	desc = "Когда бронежилет недостаточно моден."
	icon_state = "capformal"
	inhand_icon_state = "capspacesuit"
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 50, BOMB = 25, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)
	togglename = "buttons"

/obj/item/clothing/suit/toggle/captains_parade/Initialize()
	. = ..()
	allowed = GLOB.security_wintercoat_allowed

/obj/item/clothing/suit/armor/riot
	name = "костюм анти-бунт"
	desc = "Костюм из полугибкого поликарбонатных бронепластин с плотной набивкой для защиты от атак ближнего боя. Помогает владельцу сопротивляться толканию в тесных помещениях."
	icon_state = "riot"
	inhand_icon_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	full_armor_flag	= TRUE
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80, WOUND = 20)
	clothing_flags = BLOCKS_SHOVE_KNOCKDOWN
	strip_delay = 80
	equip_delay_other = 60
	disassembly_flag = TRUE

/obj/item/clothing/suit/armor/bone
	name = "костяная броня"
	desc = "Броневая пластина племени, созданная из кости животных."
	icon_state = "bonearmor"
	inhand_icon_state = "bonearmor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 35, BULLET = 25, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	full_armor_flag	= TRUE
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/bulletproof
	name = "пуленепробиваемая броня"
	desc = "Тяжелый пуленепробиваемый жилет Тип III, который в меньшей степени защищает владельца от традиционного снарядного оружия и взрывчатых веществ."
	icon_state = "bulletproof"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 15, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 20)
	strip_delay = 70
	equip_delay_other = 50
	disassembly_flag = TRUE

/obj/item/clothing/suit/armor/laserproof
	name = "отражательный жилет"
	desc = "Жилет, который отлично защищает владельца от энергетических снарядов, а также иногда отражает их."
	icon_state = "armor_reflec"
	inhand_icon_state = "armor_reflec"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	full_armor_flag	= TRUE
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	armor = list(MELEE = 10, BULLET = 10, LASER = 60, ENERGY = 60, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/hit_reflect_chance = 50
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/laserproof/IsReflect(def_zone)
	if(!(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/armor/vest/det_suit
	name = "бронежилет детектива"
	desc = "Бронежилет с детективным значком на нем."
	icon_state = "detective-armor"
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/det_suit/Initialize()
	. = ..()
	allowed = GLOB.detective_vest_allowed

/obj/item/clothing/suit/armor/vest/infiltrator
	name = "жилет лазутчика"
	desc = "Жилет, изготовленный из крайне гибких материалов, которые легко поглощают удары."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	armor = list(MELEE = 40, BULLET = 40, LASER = 30, ENERGY = 40, BOMB = 70, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	strip_delay = 80
	disassembly_flag = FALSE

//All of the armor below is mostly unused

/obj/item/clothing/suit/armor/centcom
	name = "броня ЦентКома"
	desc = "Костюм, который защищает от некоторых повреждений."
	icon_state = "centcom"
	inhand_icon_state = "centcom"
	w_class = WEIGHT_CLASS_BULKY
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	full_armor_flag	= TRUE
	allowed = list(/obj/item/gun/energy, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	clothing_flags = THICKMATERIAL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/heavy
	name = "тяжелая броня"
	desc = "Тяжело бронированный костюм, который защищает от среднего вреда."
	icon_state = "heavy"
	inhand_icon_state = "swat_suit"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.9
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	full_armor_flag	= TRUE
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	full_armor_flag	= TRUE
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/tdome/red
	name = "костюм купола грома"
	desc = "Красноватая броня."
	icon_state = "tdred"
	inhand_icon_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "костюм купола грома"
	desc = "Блевотная броня."	//classy.
	icon_state = "tdgreen"
	inhand_icon_state = "tdgreen"


/obj/item/clothing/suit/armor/riot/knight
	name = "латный доспех"
	desc = "Классический костюм броней, очень эффективен при остановке атак ближнего боя."
	icon_state = "knight_green"
	inhand_icon_state = "knight_green"
	allowed = list(/obj/item/nullrod, /obj/item/claymore, /obj/item/banner, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)

/obj/item/clothing/suit/armor/riot/knight/yellow
	icon_state = "knight_yellow"
	inhand_icon_state = "knight_yellow"

/obj/item/clothing/suit/armor/riot/knight/blue
	icon_state = "knight_blue"
	inhand_icon_state = "knight_blue"

/obj/item/clothing/suit/armor/riot/knight/red
	icon_state = "knight_red"
	inhand_icon_state = "knight_red"

/obj/item/clothing/suit/armor/riot/knight/greyscale
	name = "рыцарский доспех"
	desc = "Классический костюм доспехов, который может быть изготовлен из разных материалов."
	icon_state = "knight_greyscale"
	inhand_icon_state = "knight_greyscale"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	armor = list(MELEE = 35, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 40, ACID = 40, WOUND = 15)

/obj/item/clothing/suit/armor/vest/durathread
	name = "дюратканевый бронежилет"
	desc = "Жилет из прочной нити с полосками кожи, выступающих в качестве баллистических пластин."
	icon_state = "durathread"
	inhand_icon_state = "durathread"
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 200
	resistance_flags = FLAMMABLE
	armor = list(MELEE = 20, BULLET = 10, LASER = 30, ENERGY = 40, BOMB = 15, BIO = 0, RAD = 0, FIRE = 40, ACID = 50)
	disassembly_flag = FALSE

/obj/item/clothing/suit/armor/vest/russian
	name = "русский жилет"
	desc = "Пуленепробиваемый жилет с лесным камуфляжем. Хорошо что тут куча лесов, чтобы в них прятаться, не так ли?"
	icon_state = "rus_armor"
	inhand_icon_state = "rus_armor"
	armor = list(MELEE = 25, BULLET = 30, LASER = 0, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 20, FIRE = 20, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/vest/russian_coat
	name = "русское боевое пальто"
	desc = "Используется в экстремально холодных фронтах, изготовлено из реальных медведей."
	icon_state = "rus_coat"
	inhand_icon_state = "rus_coat"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	full_armor_flag	= TRUE
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 50, RAD = 20, FIRE = -10, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/elder_atmosian
	name = "Древняя Атмосианская броня"
	desc = "Превосходная броня, сделанная из самых прочных и редких доступных человеку материалов."
	icon_state = "h2armor"
	inhand_icon_state = "h2armor"
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	armor = list(MELEE = 15, BULLET = 10, LASER = 30, ENERGY = 30, BOMB = 10, BIO = 10, RAD = 20, FIRE = 65, ACID = 40, WOUND = 15)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	full_armor_flag	= TRUE
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/toggle/armor/vest/centcom_formal
	name = "пальто офицера ЦентКома"
	desc = "Отлично подходит для суицидальных миссий!"
	icon_state = "centcom_formal"
	inhand_icon_state = "centcom"
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(MELEE = 35, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 35, BIO = 10, RAD = 10, FIRE = 10, ACID = 60)
	togglename = "buttons"

/obj/item/clothing/suit/toggle/armor/vest/centcom_formal/Initialize()
	. = ..()
	allowed = GLOB.security_wintercoat_allowed

/obj/item/clothing/suit/toggle/armor/hos/hos_formal
	name = "парадное пальто Начальника Охраны"
	desc = "Когда бронежилет недостаточно модный."
	icon_state = "hosformal"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 70, ACID = 90, WOUND = 10)
	togglename = "buttons"

/obj/item/clothing/suit/toggle/armor/hos/hos_formal/Initialize()
	. = ..()
	allowed = GLOB.security_wintercoat_allowed
