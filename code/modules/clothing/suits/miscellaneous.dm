/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

/*
 * Lasertag
 */
/obj/item/clothing/suit/bluetag
	name = "синяя броня лазер-тэга"
	desc = "Кусок пластиковой брони. У него есть датчики, которые реагируют на красный свет." //Lasers are concentrated light
	icon_state = "bluetag"
	inhand_icon_state = "bluetag"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/gun/energy/laser/bluetag)
	resistance_flags = NONE

/obj/item/clothing/suit/redtag
	name = "красная броня лазер-тэга"
	desc = "Кусок пластиковой брони. У него есть датчики, которые реагируют на синий свет."
	icon_state = "redtag"
	inhand_icon_state = "redtag"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/gun/energy/laser/redtag)
	resistance_flags = NONE

/*
 * Costume
 */
/obj/item/clothing/suit/hooded/flashsuit
	name = "флэшкостюм"
	desc = "Чего ты ожидал?"
	icon_state = "flashsuit"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	hoodtype = /obj/item/clothing/head/hooded/flashsuit

/obj/item/clothing/head/hooded/flashsuit
	name = "кнопка флэшки"
	desc = "Вы научитесь бояться вспышки."
	icon_state = "flashsuit"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACIALHAIR|HIDEFACE|HIDEMASK|HIDESNOUT

/obj/item/clothing/suit/pirate
	name = "пиратское пальто"
	desc = "Йарр."
	icon_state = "pirate"
	inhand_icon_state = "pirate"
	allowed = list(/obj/item/melee/energy/sword/pirate, /obj/item/clothing/glasses/eyepatch, /obj/item/reagent_containers/food/drinks/bottle/rum)
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/pirate/armored
	armor = list(MELEE = 30, BULLET = 50, LASER = 30,ENERGY = 40, BOMB = 30, BIO = 30, RAD = 30, FIRE = 60, ACID = 75)
	strip_delay = 40
	equip_delay_other = 20

/obj/item/clothing/suit/pirate/captain
	name = "пиратское пальто капитана"
	desc = "Йарр."
	icon_state = "hgpirate"
	inhand_icon_state = "hgpirate"

/obj/item/clothing/suit/pirate/captain/armored
	armor = list(MELEE = 30, BULLET = 50, LASER = 30,ENERGY = 40, BOMB = 30, BIO = 30, RAD = 30, FIRE = 60, ACID = 75)
	strip_delay = 40
	equip_delay_other = 20


/obj/item/clothing/suit/cyborg_suit
	name = "костюм киборга"
	desc = "Костюм для костюма киборга."
	icon_state = "death"
	inhand_icon_state = "death"
	flags_1 = CONDUCT_1
	fire_resist = T0C+5200
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/judgerobe
	name = "одежда судьи"
	desc = "Халат, командующий властью."
	icon_state = "judge"
	inhand_icon_state = "judge"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/storage/fancy/cigarettes, /obj/item/stack/spacecash)
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/apron/overalls
	name = "комбинезон"
	desc = "Комплект джинсовых комбинезонов."
	icon_state = "overalls"
	inhand_icon_state = "overalls"
	body_parts_covered = CHEST|GROIN|LEGS
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/apron/purple_bartender
	name = "фиолетовый фартук бармена"
	desc = "Модный фиолетовый фартук для стильного человека."
	icon_state = "purplebartenderapron"
	inhand_icon_state = "purplebartenderapron"
	body_parts_covered = CHEST|GROIN|LEGS

/obj/item/clothing/suit/syndicatefake
	name = "черно-красная реплика скафандра синдиката"
	icon_state = "syndicate-black-red"
	inhand_icon_state = "syndicate-black-red"
	desc = "Пластиковая копия скафандра Синдиката. В нем вы будете выглядеть как настоящий синдикатовский убийца! Это игрушка, она не предназначена для использования в космосе!"
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	resistance_flags = NONE

/obj/item/clothing/suit/hastur
	name = "\improper Роба Хастура"
	desc = "Не предназначена для ношения людьми."
	icon_state = "hastur"
	inhand_icon_state = "hastur"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/imperium_monk
	name = "\improper Костюм имперского монаха"
	desc = "А ТЫ убил ксеноморфа сегодня?"
	icon_state = "imperium_monk"
	inhand_icon_state = "imperium_monk"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/storage/book/bible, /obj/item/nullrod, /obj/item/reagent_containers/food/drinks/bottle/holywater, /obj/item/storage/fancy/candle_box, /obj/item/candle, /obj/item/tank/internals/emergency_oxygen)


/obj/item/clothing/suit/chickensuit
	name = "куриный костюм"
	desc = "Костюм, сделанный давно древней империей KFC."
	icon_state = "chickensuit"
	inhand_icon_state = "chickensuit"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/monkeysuit
	name = "костюм обезьяны"
	desc = "Костюм, который выглядит как примат."
	icon_state = "monkeysuit"
	inhand_icon_state = "monkeysuit"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/toggle/owlwings
	name = "плащ совы"
	desc = "Мягкий коричневый плащ из синтетических перьев. Мягкий на ощупь, стильный и 2-метровый размах крыльев, который сводит женщин с ума."
	icon_state = "owl_wings"
	inhand_icon_state = "owl_wings"
	togglename = "wings"
	body_parts_covered = ARMS|CHEST

/obj/item/clothing/suit/toggle/owlwings/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/toggle/owlwings/griffinwings
	name = "плащ-грифон"
	desc = "Шикарный белый плащ из синтетических перьев. Мягкий на ощупь, стильный и 2-метровый размах крыльев, который сведет ваших пленных с ума."
	icon_state = "griffin_wings"
	inhand_icon_state = "griffin_wings"

/obj/item/clothing/suit/cardborg
	name = "костюм кардборга"
	desc = "Обычная картонная коробка с прорезанными по бокам отверстиями."
	icon_state = "cardborg"
	inhand_icon_state = "cardborg"
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEJUMPSUIT
	dog_fashion = /datum/dog_fashion/back

/obj/item/clothing/suit/cardborg/equipped(mob/living/user, slot)
	..()
	if(slot == ITEM_SLOT_OCLOTHING)
		disguise(user)

/obj/item/clothing/suit/cardborg/dropped(mob/living/user)
	..()
	user.remove_alt_appearance("standard_borg_disguise")

/obj/item/clothing/suit/cardborg/proc/disguise(mob/living/carbon/human/H, obj/item/clothing/head/cardborg/borghead)
	if(istype(H))
		if(!borghead)
			borghead = H.head
		if(istype(borghead, /obj/item/clothing/head/cardborg)) //why is this done this way? because equipped() is called BEFORE THE ITEM IS IN THE SLOT WHYYYY
			var/image/I = image(icon = 'icons/mob/robots.dmi' , icon_state = "robot", loc = H)
			I.override = 1
			I.add_overlay(mutable_appearance('icons/mob/robots.dmi', "robot_e")) //gotta look realistic
			add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "standard_borg_disguise", I) //you look like a robot to robots! (including yourself because you're totally a robot)


/obj/item/clothing/suit/snowman
	name = "наряд снеговика"
	desc = "Две белые сферы покрыты белым блеском. Это сезон."
	icon_state = "snowman"
	inhand_icon_state = "snowman"
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/poncho
	name = "пончо"
	desc = "Ваше классическое нерасистское пончо."
	icon_state = "classicponcho"
	inhand_icon_state = "classicponcho"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/poncho/green
	name = "зелёный пончо"
	desc = "Ваше классическое нерасистское пончо. Этот зеленый."
	icon_state = "greenponcho"
	inhand_icon_state = "greenponcho"

/obj/item/clothing/suit/poncho/red
	name = "красный пончо"
	desc = "Ваше классическое нерасистское пончо. Этот красный."
	icon_state = "redponcho"
	inhand_icon_state = "redponcho"

/obj/item/clothing/suit/poncho/ponchoshame
	name = "пончо стыда"
	desc = "Вы вынуждены жить на своем постыдном действии как поддельный мексиканец, вы и ваше пончо стали неразлучными. В прямом смысле."
	icon_state = "ponchoshame"
	inhand_icon_state = "ponchoshame"

/obj/item/clothing/suit/poncho/ponchoshame/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, SHAMEBRERO_TRAIT)

/obj/item/clothing/suit/whitedress
	name = "белое платье"
	desc = "Модное белое платье."
	icon_state = "white_dress"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET
	flags_inv = HIDEJUMPSUIT|HIDESHOES

/obj/item/clothing/suit/hooded/carp_costume
	name = "костюм карпа"
	desc = "Костюм из «синтетических» карповых чешуек. Он пахнет."
	icon_state = "carp_casual"
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT	//Space carp like space, so you should too
	allowed = list(/obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/gun/ballistic/rifle/boltaction/harpoon)
	hoodtype = /obj/item/clothing/head/hooded/carp_hood

/obj/item/clothing/head/hooded/carp_hood
	name = "карповый капюшон"
	desc = "Капюшон, прикрепленный к карповому костюму."
	icon_state = "carp_casual"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/head/hooded/carp_hood/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == ITEM_SLOT_HEAD)
		user.faction |= "carp"

/obj/item/clothing/head/hooded/carp_hood/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		user.faction -= "carp"

/obj/item/clothing/suit/hooded/ian_costume	//It's Ian, rub his bell- oh god what happened to his inside parts?
	name = "костюм корги"
	desc = "Костюм, который выглядит, как будто кто-то сделал похожий на человека корги, он не гарантирует трения живота."
	icon_state = "ian"
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	//cold_protection = CHEST|GROIN|ARMS
	//min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	allowed = list()
	hoodtype = /obj/item/clothing/head/hooded/ian_hood
	dog_fashion = /datum/dog_fashion/back

/obj/item/clothing/head/hooded/ian_hood
	name = "капюшон корги"
	desc = "Капюшон, похожий на голову корги, не гарантирует получение собачьего печенья."
	icon_state = "ian"
	body_parts_covered = HEAD
	//cold_protection = HEAD
	//min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/suit/hooded/bee_costume // It's Hip!
	name = "костюм пчелы"
	desc = "Стань настоящей королевой!"
	icon_state = "bee"
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	clothing_flags = THICKMATERIAL
	hoodtype = /obj/item/clothing/head/hooded/bee_hood

/obj/item/clothing/head/hooded/bee_hood
	name = "пчелиный капюшон"
	desc = "Капюшон, прикрепляемый к костюму пчелы."
	icon_state = "bee"
	body_parts_covered = HEAD
	clothing_flags = THICKMATERIAL
	flags_inv = HIDEHAIR|HIDEEARS
	dynamic_hair_suffix = ""

/obj/item/clothing/suit/hooded/bloated_human	//OH MY GOD WHAT HAVE YOU DONE!?!?!?
	name = "раздутый человеческий костюм"
	desc = "Ужасно раздутый костюм из человеческой кожи."
	icon_state = "lingspacesuit"
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list()
	actions_types = list(/datum/action/item_action/toggle_human_head)
	hoodtype = /obj/item/clothing/head/hooded/human_head
	species_exception = list(/datum/species/golem) //Finally, flesh


/obj/item/clothing/head/hooded/human_head
	name = "раздутая человеческая голова"
	desc = "Ужасно раздутая и несоответствующая человеческая голова."
	icon_state = "lingspacehelmet"
	body_parts_covered = HEAD
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/suit/security/officer/russian
	name = "Русская офицерская куртка"
	desc = "Эта куртка предназначена для тех особых случаев, когда русский офицер не обязан носить свои доспехи."
	icon_state = "officertanjacket"
	inhand_icon_state = "officertanjacket"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/shrine_maiden
	name = "наряд мико"
	desc = "Заставляет вас хотеть уничтожить некоторых проблемных ёкаев."
	icon_state = "shrine_maiden"
	inhand_icon_state = "shrine_maiden"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/*
 * Misc
 */

/obj/item/clothing/suit/straight_jacket
	name = "смирительная рубашка"
	desc = "Костюм, который полностью сдерживает владельца. Изготовлено Antyphun Corp." //Straight jacket is antifun
	icon_state = "straight_jacket"
	inhand_icon_state = "straight_jacket"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = DANGEROUS_OBJECT
	equip_delay_self = 5 SECONDS
	strip_delay = 60
	breakouttime = 3 MINUTES
	slowdown = 4
	var/mob/straight_user

/obj/item/clothing/suit/straight_jacket/equipped(mob/user, slot)
	. = ..()
	if(!straight_user)
		straight_user = user

	RegisterSignal(straight_user, COMSIG_MOVABLE_MOVED, PROC_REF(check_trip))

/obj/item/clothing/suit/straight_jacket/dropped()
	. = ..()
	if(straight_user)
		UnregisterSignal(straight_user, COMSIG_MOVABLE_MOVED)
		straight_user = null

/obj/item/clothing/suit/straight_jacket/Destroy()
	straight_user = null
	return ..()

/obj/item/clothing/suit/straight_jacket/proc/check_trip()
	var/mob/living/carbon/human/H = straight_user
	if(!istype(H) || H.wear_suit != src || H.IsKnockdown() || H.buckled)
		return

	if(prob(25))
		H.Paralyze(5)
		H.Knockdown(10)
		H.visible_message(span_danger("[H] спотыкается и падает!") , span_userdanger("Спотыкаюсь и падаю!"))

/obj/item/clothing/suit/ianshirt
	name = "изношенная рубашка"
	desc = "Изношенная, любопытно удобная футболка с изображением Яна. Вы бы не зашли так далеко, чтобы сказать, что вы чувствуете, что вас обнимают, когда вы его носите, но это довольно близко. Хорошо для сна."
	icon_state = "ianshirt"
	inhand_icon_state = "ianshirt"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/nerdshirt
	name = "рубашка геймера"
	desc = "Мешковатая рубашка со старинным игровым персонажем Phanic the Weasel. Зачем кому-то носить это?"
	icon_state = "nerdshirt"
	inhand_icon_state = "nerdshirt"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/vapeshirt //wearing this is asking to get beat.
	name = "рубашка вейпа нейшена"
	desc = "Дешевая белая футболка с большой липкой \"VN\" спереди, с какой стати вы носите это?"
	icon_state = "vapeshirt"
	inhand_icon_state = "vapeshirt"

/obj/item/clothing/suit/striped_sweater
	name = "полосатый свитер"
	desc = "Напоминает вам кого-то, но вы просто не можете положить на это палец ..."
	icon_state = "waldo_shirt"
	inhand_icon_state = "waldo_shirt"

/obj/item/clothing/suit/jacket
	name = "куртка бомбер"
	desc = "Авиаторы не включены."
	icon_state = "bomberjacket"
	inhand_icon_state = "brownjsuit"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/radio)
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/jacket/sweater
	name = "sweater jacket"
	desc = "A sweater jacket."
	icon_state = "sweater"
	worn_icon = 'icons/mob/clothing/suits/jacket.dmi'
	greyscale_config = /datum/greyscale_config/sweater
	greyscale_config_worn = /datum/greyscale_config/sweater_worn
	greyscale_colors = "#414344"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/jacket/oversized
	name = "куртка оверсайз"
	desc = "Черная куртка, которая выглядит слишком большой для вас."
	icon_state = "jacket_oversized"
	worn_icon = 'icons/mob/clothing/suits/jacket.dmi'
	greyscale_config = /datum/greyscale_config/jacket_oversized
	greyscale_config_worn = /datum/greyscale_config/jacket_oversized_worn
	greyscale_colors = "#414344"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/jacket/fancy
	name = "fancy fur coat"
	desc = "Rated 10 out of 10 in Cosmo for best coat brand."
	icon_state = "fancy_coat"
	worn_icon = 'icons/mob/clothing/suits/jacket.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	greyscale_config = /datum/greyscale_config/fancy_coat
	greyscale_config_worn = /datum/greyscale_config/fancy_coat_worn
	greyscale_colors = "#EDE3DC#414344"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/jacket/leather
	name = "кожаный пиджак"
	desc = "Помпадур не включен."
	icon_state = "leatherjacket"
	inhand_icon_state = "hostrench"
	resistance_flags = NONE
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/gun/ballistic/automatic/pistol, /obj/item/gun/ballistic/revolver, /obj/item/gun/ballistic/revolver/detective, /obj/item/radio)
	species_exception = list(/datum/species/golem/bone) //bad to the bone

/obj/item/clothing/suit/jacket/leather/overcoat
	name = "кожаное пальто"
	desc = "Чертовски тонкая шерсть."
	icon_state = "leathercoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/suit/jacket/puffer
	name = "пуховик"
	desc = "Толстая куртка с резиновой, водостойкой оболочкой."
	icon_state = "pufferjacket"
	inhand_icon_state = "hostrench"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 50, RAD = 0, FIRE = 0, ACID = 0)
	species_exception = list(/datum/species/golem/bone)

/obj/item/clothing/suit/jacket/puffer/vest
	name = "жилет"
	desc = "Толстый жилет с резиновой, водостойкой оболочкой."
	icon_state = "puffervest"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 30, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/jacket/miljacket
	name = "военная куртка"
	desc = "Холщовая куртка в стиле классической американской военной одежды. Прочная на ощупь и весьма комфортная при ношении."
	icon_state = "militaryjacket"
	inhand_icon_state = "militaryjacket"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/gun/ballistic/automatic/pistol, /obj/item/gun/ballistic/revolver, /obj/item/radio)

/obj/item/clothing/suit/jacket/letterman
	name = "куртка леттерман"
	desc = "Классическая коричневая куртка-леттерман. Хорошая вещь."
	icon_state = "letterman"
	inhand_icon_state = "letterman"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/jacket/letterman_red
	name = "красная куртка леттерман"
	desc = "Куртка леттерман нездорово-красного цвета. Радикально."
	icon_state = "letterman_red"
	inhand_icon_state = "letterman_red"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/jacket/letterman_syndie
	name = "кроваво-красная куртка леттерман"
	desc = "Странно, на спине у этой куртки есть большая S."
	icon_state = "letterman_s"
	inhand_icon_state = "letterman_s"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/jacket/letterman_nanotrasen
	name = "синяя куртка леттерман"
	desc = "Синяя курта леттерман с зачетной буквой N на спине. На бирке сказано что её сшили в Космическом Китае."
	icon_state = "letterman_n"
	inhand_icon_state = "letterman_n"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/dracula
	name = "пальто дракулы"
	desc = "Похоже, это относится к очень старому фильму."
	icon_state = "draculacoat"
	inhand_icon_state = "draculacoat"

/obj/item/clothing/suit/drfreeze_coat
	name = "лабораторный халат доктора Фриз"
	desc = "Лабораторный халат, наполненный силой функции заморозки."
	icon_state = "drfreeze_coat"
	inhand_icon_state = "drfreeze_coat"

/obj/item/clothing/suit/gothcoat
	name = "готическое пальто"
	desc = "Идеально подходит для тех, кто хочет прогуляться за углом бара."
	icon_state = "gothcoat"
	inhand_icon_state = "gothcoat"

/obj/item/clothing/suit/xenos
	name = "костюм ксеноса"
	desc = "Костюм из хитиновой шкуры пришельцев."
	icon_state = "xenos"
	inhand_icon_state = "xenos_helm"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/clothing/mask/facehugger/toy)

/obj/item/clothing/suit/nemes
	name = "туника фараона"
	desc = "Щедрая космическая гробница в комплект не входит."
	icon_state = "pharoah"
	inhand_icon_state = "pharoah"
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/caution
	name = "знак мокрого пола"
	desc = "Внимание! Мокрый пол!"
	icon_state = "caution"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|GROIN
	attack_verb_continuous = list("предупреждает", "предостерегает", "размазывает")
	attack_verb_simple = list("предупреждает", "предостерегает", "размазывает")
	armor = list(MELEE = 5, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/changshan_red
	name = "красный чаншань"
	desc = "Шелковая рубашка с великолепной вышивкой."
	icon_state = "changshan_red"
	inhand_icon_state = "changshan_red"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/suit/changshan_blue
	name = "синий чаншань"
	desc = "Шелковая рубашка с великолепной вышивкой."
	icon_state = "changshan_blue"
	inhand_icon_state = "changshan_blue"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/suit/cheongsam_red
	name = "красное ципао"
	desc = "Шелковое платье с великолепной вышивкой."
	icon_state = "cheongsam_red"
	inhand_icon_state = "cheongsam_red"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/suit/cheongsam_blue
	name = "синее ципао"
	desc = "Шелковое платье с великолепной вышивкой."
	icon_state = "cheongsam_blue"
	inhand_icon_state = "cheongsam_blue"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/head/hooded/ablative
	name = "аблативный капюшон"
	desc = "Штука, которая защитит от лазеров, но не от пуль."
	icon_state = "ablativehood"
	flags_inv = HIDEHAIR|HIDEEARS
	armor = list(MELEE = 20, BULLET = 20, LASER = 80, ENERGY = 80, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	strip_delay = 30
	var/hit_reflect_chance = 50

/obj/item/clothing/head/hooded/ablative/equipped(mob/living/carbon/human/user, slot)
	..()
	to_chat(user, "Включено тактическое зрение.")
	ADD_TRAIT(user, TRAIT_SECURITY_HUD, HELMET_TRAIT)
	var/datum/atom_hud/H = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	H.show_to(user)

/obj/item/clothing/head/hooded/ablative/dropped(mob/living/carbon/human/user)
	..()
	to_chat(user, "Тактическое зрение отключено.")
	REMOVE_TRAIT(user, TRAIT_SECURITY_HUD, HELMET_TRAIT)
	var/datum/atom_hud/H = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	H.hide_from(user)

/obj/item/clothing/head/hooded/ablative/IsReflect(def_zone)
	if(def_zone != BODY_ZONE_HEAD) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/hooded/ablative
	name = "экспериментальный аблативный плащ"
	desc = "Экспериментальный плащ, специально созданный для отражения и поглощения лазерных и дезактивирующих ударов. Однако не ожидайте, что он так много сделает против топора или дробовика."
	icon_state = "ablativecoat"
	inhand_icon_state = "ablativecoat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list(MELEE = 20, BULLET = 20, LASER = 80, ENERGY = 80, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	hoodtype = /obj/item/clothing/head/hooded/ablative
	strip_delay = 30
	equip_delay_other = 40
	var/hit_reflect_chance = 50

/obj/item/clothing/suit/hooded/ablative/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/hooded/ablative/IsReflect(def_zone)
	if(!(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/bronze
	name = "латунный костюм"
	desc = "Большой строгий костюм из латуни, который не защищает и выглядит очень не модно. Отлично."
	icon = 'icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_cuirass_old"
	armor = list(MELEE = 5, BULLET = 0, LASER = -5, ENERGY = -15, BOMB = 10, BIO = 0, RAD = 0, FIRE = 20, ACID = 20)

/obj/item/clothing/suit/ghost_sheet
	name = "саван неприкаянного"
	desc = "Лучшее в мире привидение - дикое, но симпатичное."
	icon_state = "ghost_sheet"
	inhand_icon_state = "ghost_sheet"
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	flags_inv = HIDEGLOVES|HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	alternate_worn_layer = UNDER_HEAD_LAYER
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/ghost_sheet/spooky
	name = "жуткое приведение"
	desc = "Очевидно, просто простыня, но может примерить?"
	user_vars_to_edit = list("name" = "Жуткий Призрак", "real_name" = "Жуткий Призрак" , "incorporeal_move" = INCORPOREAL_MOVE_BASIC, "appearance_flags" = KEEP_TOGETHER|TILE_BOUND, "alpha" = 150)
	alternate_worn_layer = ABOVE_BODY_FRONT_LAYER //so the bedsheet goes over everything but fire

/obj/item/clothing/suit/toggle/suspenders/blue
	name = "синие подтяжки"
	desc = "Символ тяжелого труда и грязных работ."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "suspenders_blue"

/obj/item/clothing/suit/toggle/suspenders/gray
	name = "серые подтяжки"
	desc = "Символ тяжелого труда и грязных работ."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "suspenders_gray"

/obj/item/clothing/suit/hooded/mysticrobe
	name = "мантия"
	desc = "Ношение этого заставляет вас чувствовать себя более сонастроенным с природой вселенной... а также немного более безответственным."
	icon_state = "mysticrobe"
	inhand_icon_state = "mysticrobe"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/spellbook, /obj/item/storage/book/bible)
	flags_inv = HIDEJUMPSUIT
	hoodtype = /obj/item/clothing/head/hooded/mysticrobe

/obj/item/clothing/head/hooded/mysticrobe
	name = "капюшон мистика"
	desc = "Баланс реальности подсказывает порядок."
	icon_state = "mystichood"
	inhand_icon_state = "mystichood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACIALHAIR|HIDEFACE|HIDEMASK

/obj/item/clothing/suit/coordinator
	name = "куртка организатора"
	desc = "Куртка для организатора вечеринок, стильная!."
	icon_state = "capformal"
	inhand_icon_state = "capspacesuit"
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

/obj/item/clothing/suit/hawaiian
	name = "гавайская рубашка"
	desc = "Клевая рубашка для отдыха на пляже."
	icon_state = "hawaiian_blue"
	inhand_icon_state = "hawaiian_blue"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/costume/football_armor
	name = "football protective gear"
	desc = "Given to members of the football team!"
	icon_state = "football_armor"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	greyscale_config = /datum/greyscale_config/football_armor
	greyscale_config_worn = /datum/greyscale_config/football_armor_worn
	greyscale_colors = "#D74722"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/yakuza
	name = "куртка клана донченг"
	desc = "Куртка бешеного пса."
	icon_state = "MajimaJacket"
	inhand_icon_state = "MajimaJacket"
	body_parts_covered = ARMS

/obj/item/clothing/suit/dutch
	name = "голландская куртка"
	desc = "Для длинных ночей на пляже в Таити."
	icon_state = "DutchJacket"
	inhand_icon_state = "DutchJacket"
	body_parts_covered = ARMS


/obj/item/clothing/suit/costume/driscoll
	name = "driscoll poncho"
	desc = "Keeping you warm in the harsh cold of space."
	icon_state = "driscoll_suit"
	inhand_icon_state = "driscoll_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/irs
	name = "internal revenue service jacket"
	desc = "I'm crazy enough to take on The Owl, but the IRS? Nooo thank you!"
	icon_state = "irs_suit"
	inhand_icon_state = "irs_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/osi
	name = "\improper O.S.I. body armor"
	desc = "You're beyond good and evil, super man. You work for the government. And you're a tool, boy, a tool! Built for a single purpose by the United States of shut your third fucking damn eye for a fucking reason! You can't teach a hammer to love nails, son. That dog don't hunt!"
	icon_state = "osi_suit"
	inhand_icon_state = "osi_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/tmc
	name = "\improper Lost M.C. cut"
	desc = "Making sure everyone knows you're in the best biker gang this side of Alderney."
	icon_state = "tmc_suit"
	inhand_icon_state = "tmc_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/pg
	name = "powder ganger jacket"
	desc = "Remind Security of their mistakes in giving prisoners blasting charges."
	icon_state = "pg_suit"
	inhand_icon_state = "pg_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/deckers
	name = "decker hoodie"
	desc = "Based? Based on what?"
	icon_state = "decker_suit"
	inhand_icon_state = "decker_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/morningstar
	name = "morningstar coat"
	desc = "This coat costs more than you've ever made in your entire life."
	icon_state = "morningstar_suit"
	inhand_icon_state = "morningstar_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/saints
	name = "Third Street Saints fur coat"
	desc = "Rated 10 out of 10 in Cosmo for best coat brand."
	icon_state = "saints_suit"
	inhand_icon_state = "saints_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/phantom
	name = "phantom thief coat"
	desc = "Your foes will never see you coming in this stealthy yet stylish getup."
	icon_state = "phantom_suit"
	inhand_icon_state = "phantom_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/allies
	name = "allies body armor"
	desc = "How 'bout some action!? Sponsored by DonkSoft Co. for historical reenactment of the Third World War!"
	icon_state = "allies_armor"
	inhand_icon_state = "allies_armor"
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/costume/soviet
	name = "советское бронированное пальто"
	desc = "Conscript reporting! Sponsored by DonkSoft Co. for historical reenactment of the Third World War!"
	icon_state = "soviet_suit"
	inhand_icon_state = "soviet_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/yuri
	name = "yuri initiate coat"
	desc = "Yuri is master! Sponsored by DonkSoft Co. for historical reenactment of the Third World War!"
	icon_state = "yuri_coat"
	inhand_icon_state = "yuri_coat"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/costume/sybil_slickers
	name = "sybil slickers protective gear"
	desc = "Given to members of the Sybil Slickers football team!"
	icon_state = "football_armor_blue"
	inhand_icon_state = "football_armor_blue"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/basil_boys
	name = "basil boys protective gear"
	desc = "Given to members of the Basil Boys football team!"
	icon_state = "football_armor_red"
	inhand_icon_state = "football_armor_red"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
