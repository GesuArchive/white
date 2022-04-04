//These clothing for blueshift map.
//I'm too lazy to sort this shit, maybe tomorrow, lol.

//uniforms
/obj/item/clothing/under/misc/greyshirt
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "серая рубашка"
	desc = "Простая серая рубашка и черные брюки - гораздо более грубый вариант по сравнению с комбинезоном."
	icon_state = "greyshirt"

/obj/item/clothing/under/misc/cargo_long
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "длинный комбинезон карготехника"
	desc = "Для тех, кто предпочитает защищать свои ноги, а не демонстрировать их.."
	icon_state = "cargo_long"
	can_adjust = TRUE

/obj/item/clothing/under/misc/mechanic
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "комбинезон механика"
	desc = "Старомодный комбинезон с различными карманами и петлями для ремней."
	icon_state = "mechanic"

/obj/item/clothing/under/dress/littleblack
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "короткое чёрное платье"
	desc = "Очень короткое черное платье, для тех, у кого нет стыда."
	icon_state = "littleblackdress_s"
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/dress/pinktutu
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "розовая балетная юбка"
	desc = "Пушистая розовая балетная юбка."
	icon_state = "pinktutu_s"
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/pants/jeanripped
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "рваные джинсы"
	desc = "Если ты носишь это, ты беден или бунтарь."
	icon_state = "jean_ripped"

/obj/item/clothing/under/pants/jeanshort
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "джинсовые шорты"
	desc = "На самом деле это просто джинсы, разрезанные пополам"
	icon_state = "jean_shorts"

/obj/item/clothing/under/pants/denimskirt
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "джинсовая юбка"
	desc = "На самом деле это просто вырезанная дырка в штанине."
	icon_state = "denim_skirt"

/obj/item/clothing/under/pants/chaps
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "чёрные чапсы"
	body_parts_covered = LEGS
	desc = "Й-и-иха!"
	icon_state = "chaps"

/obj/item/clothing/under/pants/yoga
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "штаны для йоги"
	desc = "Удобно!"
	icon_state = "yoga_pants"

/obj/item/clothing/under/pants/blackshorts
	name = "чёрные рваные шорты"
	desc = "Никто никогда не узнает, сделали ли вы это случайно или специально, но выглядит это хорошо.."
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	icon_state = "rippedshorts_black"

/obj/item/clothing/under/sweater
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "кремовый свитер"
	desc = "Зачем менять стиль на комфорт? Теперь вы можете ходить в стиле 'коммандос' на юге и быть уютным на севере."
	icon_state = "bb_turtle"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = TRUE

/obj/item/clothing/under/sweater/black
	name = "чёрный свитер"
	icon_state = "bb_turtleblk"

/obj/item/clothing/under/sweater/purple
	name = "фиолетовый свитер"
	icon_state = "bb_turtlepur"

/obj/item/clothing/under/sweater/green
	name = "зеленый свитер"
	icon_state = "bb_turtlegrn"

/obj/item/clothing/under/sweater/red
	name = "красный свитер"
	icon_state = "bb_turtlered"

/obj/item/clothing/under/sweater/blue
	name = "синий свитер"
	icon_state = "bb_turtleblu"

/obj/item/clothing/under/utility
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "утилитарная униформа"
	desc = "Утилитарная форма, которую носят члены экипажа гражданского ранга."
	icon_state = "util_gen"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS
	can_adjust = FALSE

/obj/item/clothing/under/utility/syndicate
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40) //Same stats as the tactical turtleneck.
	has_sensor = NO_SENSORS

/obj/item/clothing/under/utility/eng
	name = "утилитарная униформа инженера"
	desc = "Утилитарная форма, которую носит инженерно-технический персонал."
	icon_state = "util_eng"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 60, ACID = 20) //Same stats as default engineering jumpsuit

/obj/item/clothing/under/utility/eng/syndicate
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40) //Same stats as the tactical turtleneck.
	has_sensor = NO_SENSORS //"Who is this SYNDICATE OPERATIVE on sensors?"

/obj/item/clothing/under/utility/med
	name = "утилитарная униформа доктора"
	desc = "Утилитарная форма, носимая медицинскими докторами."
	icon_state = "util_med"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 0, ACID = 0) //Same stats as default medical jumpsuit

/obj/item/clothing/under/utility/med/syndicate
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40) //Same stats as the tactical turtleneck.
	has_sensor = NO_SENSORS

/obj/item/clothing/under/utility/sci
	name = "утилитарная униформа ученого"
	desc = "Утилитарная форма, которую носит персонал РнД."
	icon_state = "util_sci"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 10, BIO = 0, FIRE = 0, ACID = 0) //Same stats as default science jumpsuit

/obj/item/clothing/under/utility/sci/syndicate
	desc = "Утилитарная форма, которую носят учёные."
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40) //Same stats as the tactical turtleneck.
	has_sensor = NO_SENSORS

/obj/item/clothing/under/utility/cargo
	name = "утилитарная униформа карготехника"
	desc = "Утилитарная униформа, которую носят службы снабжения и доставки."
	icon_state = "util_cargo"

/obj/item/clothing/under/utility/cargo/syndicate
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40) //Same stats as the tactical turtleneck.
	has_sensor = NO_SENSORS

/obj/item/clothing/under/utility/cargo/gorka
	name = "горка карготехника"
	desc = "Модная горка, которую носят службы снабжения и доставки."
	icon_state = "gorka_cargo"

/obj/item/clothing/under/utility/cargo/turtleneck
	name = "водолазка карготехника"
	desc = "Облегающий свитер-водолазка, который носят сотрудники служб снабжения и доставки."
	icon_state = "turtleneck_cargo"

/obj/item/clothing/under/utility/cargo/gorka/head
	name = "горка квартирмейстера"
	desc = "Модная горка, который носит начальник отдела снабжения и доставки, о чем свидетельствует причудливый серебряный значок."
	icon_state = "gorka_qm"

/obj/item/clothing/under/utility/cargo/turtleneck/head
	name = "водолазка квартирмейстера"
	desc = "Облегающий свитер-водолазка, который носит начальник отдела снабжения и доставки, о чем свидетельствует модный серебряный значок."
	icon_state = "turtleneck_qm"

/obj/item/clothing/under/utility/sec
	name = "утилитарная униформа охраны"
	desc = "Утилитарная форма, носимая составом СБ."
	icon_state = "util_sec"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 30, ACID = 30, WOUND = 10) //Same stats as default security jumpsuit

/obj/item/clothing/under/utility/sec/old	//Oldsec (Red)
	icon_state = "util_sec_old"

/obj/item/clothing/under/utility/sec/old/syndicate
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40) //Same stats as the tactical turtleneck.
	has_sensor = NO_SENSORS

/obj/item/clothing/under/utility/com
	name = "командная утилитарная униформа"
	desc = "Утилитарная униформа, носимая главами отделов."
	icon_state = "util_com"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0, WOUND = 15) //Same stats as default captain uniform

/obj/item/clothing/under/utility/com/syndicate
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40) //Same stats as the tactical turtleneck.
	has_sensor = NO_SENSORS

/obj/item/clothing/under/utility/robo_sleek
	name = "гладкий комбинезон робототехников"
	desc = "Элегантная версия униформы робототехника, дополненная научно-фантастическими полосками."
	icon_state = "robosleek"

/obj/item/clothing/under/utility/para_red
	name = "утилитарная униформа парамедика"
	desc = "Она изготовлена из специального волокна, обеспечивающего незначительную защиту от биологических опасностей. Она украшена красными полосами и медицинскими символами, обозначающими, что ее владелец является специалистом по оказанию первой помощи."
	icon_state = "pmedred"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 0, ACID = 0) //Same stats as the paramedic uniform

/obj/item/clothing/under/utility/haz_green
	name = "защитная утилитарная униформа"
	desc = "Униформа с дополнительной защитой от газовых и химических опасностей, ценой меньшей огневой и радиационной защиты."
	icon_state = "hazard_green"
	can_adjust = TRUE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 20, ACID = 60)
	resistance_flags = ACID_PROOF

/obj/item/clothing/under/utility/haz_white
	name = "защитная униформа парамедика"
	desc = "Форма EMT, используемая для оказания первой помощи в ситуациях, связанных с газовой и/или химической опасностью. На этикетке написано: \"Не предназначена для длительного воздействия\"."
	icon_state = "hazard_white"
	can_adjust = TRUE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 10, ACID = 50) //Worse stats than the proper hazard uniform
	resistance_flags = ACID_PROOF

////suits

/obj/item/clothing/suit/modern_winter
	icon = 'white/rebolution228/icons/unsorted/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/suit.dmi'
	name = "современное зимнее пальто"
	desc = "Удобное современное зимнее пальто."
	icon_state = "modern_winter"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT


/obj/item/clothing/suit/gorka/supply
	icon = 'white/rebolution228/icons/unsorted/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/suit.dmi'
	name = "горка"
	desc = "Облегающая куртка. Эта куртка сочетается с цветами отдела карго."
	icon_state = "gorka_jacket_supply"
////gloves

/obj/item/clothing/gloves/ring
	icon = 'white/rebolution228/icons/unsorted/clothing/ring.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/hands.dmi'
	name = "золотое кольцо"
	desc = "Маленькое золотое кольцо, размером с палец.."
	gender = NEUTER
	w_class = WEIGHT_CLASS_TINY
	icon_state = "ringgold"
	inhand_icon_state = "gring"
	worn_icon_state = "gring"
	body_parts_covered = 0
	strip_delay = 4 SECONDS
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/ring/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("\[user] is putting the [src] in [user.p_their()] mouth! It looks like [user] is trying to choke on the [src]!"))
	return OXYLOSS


/obj/item/clothing/gloves/ring/diamond
	name = "бриллиантовое кольцо"
	desc = "Дорогое кольцо, усыпанное бриллиантом. Культуры использовали эти кольца в ухаживании на протяжении тысячелетий."
	icon_state = "ringdiamond"
	inhand_icon_state = "dring"
	worn_icon_state = "dring"

/obj/item/clothing/gloves/ring/diamond/attack_self(mob/user)
	user.visible_message(span_warning("\The [user] gets down on one knee, presenting \the [src]."),span_warning("You get down on one knee, presenting \the [src]."))

/obj/item/clothing/gloves/ring/silver
	name = "серебряное кольцо"
	desc = "Маленькое серебряное кольцо, размером с палец."
	icon_state = "ringsilver"
	inhand_icon_state = "sring"
	worn_icon_state = "sring"


///shoes

/obj/item/clothing/shoes/wraps
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	name = "позолоченные обмотки для ног"
	desc = "Накладки на лодыжки. Эти имеют золотой рисунок."
	icon_state = "gildedcuffs"
	body_parts_covered = FALSE

/obj/item/clothing/shoes/wraps/silver
	name = "серебряные обмотки для ног"
	desc = "Накладки на лодыжки. Не из настоящего серебра."
	icon_state = "silvergildedcuffs"

/obj/item/clothing/shoes/wraps/red
	name = "красные обмотки для ног"
	desc = "Накладки на лодыжки. Покажите свой стиль с этим блестящим красным цветом!"
	icon_state = "redcuffs"

/obj/item/clothing/shoes/wraps/blue
	name = "синие обмотки для ног"
	desc = "Покрытие лодыжек. Повесь десять, брат."
	icon_state = "bluecuffs"

/obj/item/clothing/shoes/cowboyboots
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	name = "ковбойские сапоги"
	desc = "Стандартная пара коричневых ковбойских сапог."
	icon_state = "cowboyboots"

/obj/item/clothing/shoes/cowboyboots/black
	name = "чёрные ковбойские сапоги"
	desc = "Пара черных ковбойских сапог, на которых легко образовались потертости."
	icon_state = "cowboyboots_black"

/obj/item/clothing/shoes/high_heels
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	name = "высокие каблуки"
	desc = "Модная пара туфель на высоком каблуке. Не сильно компенсирует ваш рост ниже среднего.."
	icon_state = "heels"

/obj/item/clothing/shoes/discoshoes
	name = "зелёные туфли из змеиной кожи"
	desc = "Возможно, с годами они немного утратили свой блеск, но эти зеленые туфли из крокодиловой кожи идеально вам подходят."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "lizardskin_shoes"

/obj/item/clothing/shoes/kimshoes
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	name = "аэростатические ботинки"
	desc = "Коричневые сапоги, чопорные и правильные, готовые отправиться в путь, чтобы снять тело с дерева."
	icon_state = "aerostatic_boots"


/obj/item/clothing/shoes/jungleboots
	name = "джунглевые сапоги"
	desc = "Возьми меня в свой рай, я хочу увидеть джунгли. Коричневая пара ботинок."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "jungle"
	inhand_icon_state = "jackboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	strip_delay = 30
	equip_delay_other = 50
	resistance_flags = NONE
	permeability_coefficient = 0.05 //Thick soles, and covers the ankle
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	can_be_tied = TRUE //SKYRAT EDIT

/obj/item/clothing/shoes/jackboots/black
	name = "черные сапоги"
	desc = "Боевые ботинки охраны NanoTrasen для боевых сценариев или боевых ситуаций. Все время в бою. Они полностью черные."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "blackjack"

/obj/item/clothing/shoes/sports
	name = "спортивные кроссовки"
	desc = "Обувь для спортивных людей. Гиганты Чарльтона играют с титанами Ипсвича, благодаря чему они оба кажутся нормального размера.."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "sportshoe"

/obj/item/clothing/shoes/jackboots/thigh
	name = "длинные сапоги"
	desc = "Черные, длинные кожаные сапоги."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "thighboots"

/obj/item/clothing/shoes/jackboots/knee
	name = "сапоги до колена"
	desc = "Черные кожаные сапоги до колена."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "kneeboots"

/obj/item/clothing/shoes/jackboots/timbs
	name = "модные сапоги"
	desc = "Обычные модные сапоги."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "timbs"

/obj/item/clothing/shoes/winterboots/christmas
	name = "красные новогодние ботинки"
	desc = "Пара пушистых красных рождественских сапог!"
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "christmasbootsr"

/obj/item/clothing/shoes/winterboots/christmas/green
	name = "зелёные рождественские сапоги"
	desc = "Пара пушистых зеленых рождественских сапог!"
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "christmasbootsg"
