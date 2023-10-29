

/obj/item/clothing/head/centhat
	name = "шапочка ЦентКома"
	icon_state = "centcom"
	desc = "Как прекрасно быть императором."
	inhand_icon_state = "that"
	flags_inv = 0
	armor = list(MELEE = 30, BULLET = 15, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	strip_delay = 80

/obj/item/clothing/head/spacepolice
	name = "кепка космической полиции"
	desc = "Синяя кепка для ежедневного патрулирования."
	icon_state = "policecap_families"
	inhand_icon_state = "policecap_families"

/obj/item/clothing/head/powdered_wig
	name = "напудренный парик"
	desc = "Пахнет стариной."
	icon_state = "pwig"
	inhand_icon_state = "pwig"

/obj/item/clothing/head/that
	name = "цилиндр"
	desc = "Кругленький."
	icon_state = "tophat"
	inhand_icon_state = "that"
	dog_fashion = /datum/dog_fashion/head
	throwforce = 1

/obj/item/clothing/head/canada
	name = "полосатый красный цилиндр"
	desc = "Пахнет как свежие дырки от бублика. / <i>Il sent comme des trous de beignets frais.</i>"
	icon_state = "canada"
	inhand_icon_state = "canada"

/obj/item/clothing/head/redcoat
	name = "красная шапочка"
	icon_state = "redcoat"
	desc = "<i>'Я думаю, это рыжий.'</i>"

/obj/item/clothing/head/mailman
	name = "шляпа почтальона"
	icon_state = "mailman"
	desc = "<i>'Вовремя!'</i> - головной убор почтальона."

/obj/item/clothing/head/plaguedoctorhat
	name = "шляпа чумного доктора"
	desc = "Когда-то их использовали чумные врачи. Они практически бесполезны."
	icon_state = "plaguedoctor"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)

/obj/item/clothing/head/hasturhood
	name = "капюшон Хастура"
	desc = "<I>Невероятно</I> стильный."
	icon_state = "hasturhood"
	flags_inv = HIDEHAIR
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/nursehat
	name = "шляпа медсестры"
	desc = "Позволяет быстро идентифицировать обученный медицинский персонал. Ну или проституток.	"
	icon_state = "nursehat"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/nurse

/obj/item/clothing/head/syndicatefake
	name = "чёрная реплика космошлема"
	icon_state = "syndicate-helm-black-red"
	inhand_icon_state = "syndicate-helm-black-red"
	desc = "Пластиковая копия космического шлема агента Синдиката. В этом вы будете выглядеть как настоящий убийственный агент Синдиката! Это игрушка, она не предназначена для использования в космосе!"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/cueball
	name = "бильярдный шлем"
	desc = "Большой, безликий белый шар, предназначенный для ношения на голове. Как ты вообще видишь из этого?"
	icon_state = "cueball"
	inhand_icon_state="cueball"
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/snowman
	name = "Голова Снеговика"
	desc = "Шар из белого пенопласта. Так празднично."
	icon_state = "snowman_h"
	inhand_icon_state = "snowman_h"
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/justice
	name = "шляпа правосудия"
	desc = "Борись за то, что праведно!"
	icon_state = "justicered"
	inhand_icon_state = "justicered"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEHAIR|HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/justice/blue
	icon_state = "justiceblue"
	inhand_icon_state = "justiceblue"

/obj/item/clothing/head/justice/yellow
	icon_state = "justiceyellow"
	inhand_icon_state = "justiceyellow"

/obj/item/clothing/head/justice/green
	icon_state = "justicegreen"
	inhand_icon_state = "justicegreen"

/obj/item/clothing/head/justice/pink
	icon_state = "justicepink"
	inhand_icon_state = "justicepink"

/obj/item/clothing/head/rabbitears
	name = "кроличьи уши"
	desc = "Ношение этих вещей делает вас бесполезным, и только полезно для вашей сексуальной привлекательности."
	icon_state = "bunny"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/rabbit

/obj/item/clothing/head/pirate
	name = "пиратская шляпа"
	desc = "Ярр."
	icon_state = "pirate"
	inhand_icon_state = "pirate"
	dog_fashion = /datum/dog_fashion/head/pirate

/obj/item/clothing/head/pirate
	var/datum/language/piratespeak/L = new

/obj/item/clothing/head/pirate/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_HEAD)
		user.grant_language(/datum/language/piratespeak/, TRUE, TRUE, LANGUAGE_HAT)
		to_chat(user, span_boldnotice("Вспоминаю как говорить, как пират!"))

/obj/item/clothing/head/pirate/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_HEAD) == src && !QDELETED(src)) //This can be called as a part of destroy
		user.remove_language(/datum/language/piratespeak/, TRUE, TRUE, LANGUAGE_HAT)
		to_chat(user, span_boldnotice("Забываю как говорить, как пират."))

/obj/item/clothing/head/pirate/armored
	armor = list(MELEE = 30, BULLET = 50, LASER = 30,ENERGY = 40, BOMB = 30, BIO = 30, RAD = 30, FIRE = 60, ACID = 75)
	strip_delay = 40
	equip_delay_other = 20

/obj/item/clothing/head/pirate/captain
	name = "шляпа капитана пиратов"
	icon_state = "hgpiratecap"
	inhand_icon_state = "hgpiratecap"

/obj/item/clothing/head/bandana
	name = "пиратская бандана"
	desc = "Ярр."
	icon_state = "bandana"
	inhand_icon_state = "bandana"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/bandana/armored
	armor = list(MELEE = 30, BULLET = 50, LASER = 30,ENERGY = 40, BOMB = 30, BIO = 30, RAD = 30, FIRE = 60, ACID = 75)
	strip_delay = 40
	equip_delay_other = 20

/obj/item/clothing/head/bowler
	name = "котелок"
	desc = "Джентльмен, элита на борту!"
	icon_state = "bowler"
	inhand_icon_state = "bowler"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/witchwig
	name = "ведьмин парик"
	desc = "Ииии~хихихихихи!"
	icon_state = "witch"
	inhand_icon_state = "witch"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/chicken
	name = "куриная голова"
	desc = "Кудах!"
	icon_state = "chickenhead"
	inhand_icon_state = "chickensuit"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/griffin
	name = "голова гриффона"
	desc = "Почему не «голова орла»? Кто знает."
	icon_state = "griffinhat"
	inhand_icon_state = "griffinhat"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/bearpelt
	name = "медвежья шкура"
	desc = "Чётко."
	icon_state = "bearpelt"
	inhand_icon_state = "bearpelt"

/obj/item/clothing/head/xenos
	name = "голова ксеноморфа"
	icon_state = "xenos"
	inhand_icon_state = "xenos_helm"
	desc = "Шлем из хитиновой шкуры ксеноса."
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/fedora
	name = "федора"
	icon_state = "fedora"
	inhand_icon_state = "fedora"
	desc = "Действительно классная шляпа, если ты бандит. Действительно хромая шляпа, если ты нет."

/obj/item/clothing/head/fedora/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/small/fedora)

/obj/item/clothing/head/fedora/white
	name = "белая федора"
	icon_state = "fedora_white"
	inhand_icon_state = "fedora_white"

/obj/item/clothing/head/fedora/beige
	name = "бежевая федора"
	icon_state = "fedora_beige"
	inhand_icon_state = "fedora_beige"

/obj/item/clothing/head/fedora/suicide_act(mob/user)
	if(user.gender == FEMALE)
		return 0
	var/mob/living/carbon/human/H = user
	user.visible_message(span_suicide("[user] надевает [src]! Выглядит будто [user.p_theyre()] пытается понравиться девушкам."))
	user.say("M'lady.", forced = "fedora suicide")
	sleep(10)
	H.facial_hairstyle = "Neckbeard"
	return(BRUTELOSS)

/obj/item/clothing/head/sombrero
	name = "сомбреро"
	icon_state = "sombrero"
	inhand_icon_state = "sombrero"
	desc = "Можно практически попробовать фиесту."
	flags_inv = HIDEHAIR

	dog_fashion = /datum/dog_fashion/head/sombrero

/obj/item/clothing/head/sombrero/green
	name = "зелёный сомбреро"
	icon_state = "greensombrero"
	inhand_icon_state = "greensombrero"
	desc = "Изящен, как танцующий кактус."
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS
	dog_fashion = null

/obj/item/clothing/head/sombrero/shamebrero
	name = "позорбреро"
	icon_state = "shamebrero"
	inhand_icon_state = "shamebrero"
	desc = "Как только он надет, он никогда не снимется."
	dog_fashion = null

/obj/item/clothing/head/sombrero/shamebrero/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, SHAMEBRERO_TRAIT)

/obj/item/clothing/head/flatcap
	name = "кепка"
	desc = "Рабочая мужская шапка."
	icon_state = "beret_flat"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#8F7654"
	inhand_icon_state = "detective"

/obj/item/clothing/head/hunter
	name = "шляпа охотника за головами"
	desc = "Никто не собирается обманывать палача в моем городе."
	icon_state = "cowboy"
	worn_icon_state = "hunter"
	inhand_icon_state = "hunter"
	armor = list(MELEE = 5, BULLET = 5, LASER = 5, ENERGY = 15, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/cowboy_hat_black
	name = "desperado hat"
	desc = "People with ropes around their necks don't always hang."
	icon_state = "cowboy_hat_black"
	inhand_icon_state = "cowboy_hat_black"

/obj/item/clothing/head/cowboy_hat_white
	name = "ten-gallon hat"
	desc = "There are two kinds of people in the world: those with guns and those that dig. You dig?"
	icon_state = "cowboy_hat_white"
	inhand_icon_state = "cowboy_hat_white"

/obj/item/clothing/head/cowboy_hat_grey
	name = "drifter hat"
	desc = "The hat for an assistant with no name."
	icon_state = "cowboy_hat_grey"
	inhand_icon_state = "cowboy_hat_grey"

/obj/item/clothing/head/cowboy_hat_red
	name = "deputy hat"
	desc = "Don't let the garish coloration fool you. This hat has seen some terrible things."
	icon_state = "cowboy_hat_red"
	inhand_icon_state = "cowboy_hat_red"

/obj/item/clothing/head/cowboy_hat_brown
	name = "sheriff hat"
	desc = "Reach for the skies, pardner."
	icon_state = "cowboy_hat_brown"
	inhand_icon_state = "cowboy_hat_brown"

/obj/item/clothing/head/cone
	desc = "Этот конус пытается вас о чем-то предупредить!"
	name = "предупреждающий конус"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cone"
	inhand_icon_state = "cone"
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("предупреждает", "предостерегает", "размазывает")
	attack_verb_simple = list("предупреждает", "предостерегает", "размазывает")
	resistance_flags = NONE
	dynamic_hair_suffix = ""

/obj/item/clothing/head/santa
	name = "шляпа санты"
	desc = "В первый день рождества мой работодатель подарил мне это!"
	icon_state = "santahatnorm"
	inhand_icon_state = "that"
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	dog_fashion = /datum/dog_fashion/head/santa

/obj/item/clothing/head/jester
	name = "шапка шута"
	desc = "Шапка с колокольчиками, чтобы добавить веселья в костюм."
	icon_state = "jester_hat"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/jester/alt
	icon_state = "jester2"

/obj/item/clothing/head/rice_hat
	name = "рисовая шляпа"
	desc = "Добро пожаловать на рисовые поля, ублюдок."
	icon_state = "rice_hat"

/obj/item/clothing/head/lizard
	name = "шляпа из ящерицы"
	desc = "Сколько ящериц умерло, чтобы сделать эту шляпу? Недостаточно."
	icon_state = "lizard"

/obj/item/clothing/head/papersack
	name = "бумажная шапка"
	desc = "Бумажный мешок с грубыми отверстиями для глаз. Полезно для сокрытия личности или безобразия."
	icon_state = "papersack"
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS|HIDESNOUT

/obj/item/clothing/head/papersack/smiley
	name = "бумажная шапка"
	desc = "Бумажный мешок с грубыми прорезями для глаз и схематичной улыбкой, нарисованной спереди. Совсем не жутко."
	icon_state = "papersack_smile"

/obj/item/clothing/head/crown
	name = "корона"
	desc = "Корона, подходящая для короля, может быть, для короля поменьше."
	icon_state = "crown"
	armor = list(MELEE = 15, BULLET = 0, LASER = 0,ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50, WOUND = 5)
	resistance_flags = FIRE_PROOF
	dynamic_hair_suffix = ""

/obj/item/clothing/head/crown/fancy
	name = "великолепная корона"
	desc = "Корона, которую носят только самые высшие императоры из <s>land</s> космоса."
	icon_state = "fancycrown"

/obj/item/clothing/head/scarecrow_hat
	name = "шляпа чучела"
	desc = "Простая соломенная шляпа."
	icon_state = "scarecrow_hat"

/obj/item/clothing/head/lobsterhat
	name = "пенная головка омара"
	desc = "Когда все пойдет не так, защита головы - лучший выбор."
	icon_state = "lobster_hat"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/drfreezehat
	name = "парик доктора заморозки"
	desc = "Классный парик для классных людей."
	icon_state = "drfreeze_hat"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/pharaoh
	name = "фараоновая шляпа"
	desc = "Ходи как египтянин."
	icon_state = "pharoah_hat"
	inhand_icon_state = "pharoah_hat"

/obj/item/clothing/head/nemes
	name = "головной убор Немеса"
	desc = "Щедрые космические гробницы не включены."
	icon_state = "nemes_headdress"

/obj/item/clothing/head/delinquent
	name = "шляпа делинквент"
	desc = "Грифер."
	icon_state = "delinquent"

/obj/item/clothing/head/frenchberet
	name = "французский берет"
	desc = "Качественный берет, наполненный ароматом курящих, парящих парижан. По какой-то причине вы чувствуете себя менее склонным к военному конфликту."
	icon_state = "beret"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/frenchberet/equipped(mob/M, slot)
	. = ..()
	if (slot == ITEM_SLOT_HEAD)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
		ADD_TRAIT(M, TRAIT_GARLIC_BREATH, type)
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)
		REMOVE_TRAIT(M, TRAIT_GARLIC_BREATH, type)

/obj/item/clothing/head/frenchberet/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)
	REMOVE_TRAIT(M, TRAIT_GARLIC_BREATH, type)

/obj/item/clothing/head/frenchberet/proc/handle_speech(datum/source, mob/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = " [message]"
		var/list/french_words = strings("french_replacement.json", "french")

		for(var/key in french_words)
			var/value = french_words[key]
			if(islist(value))
				value = pick(value)

			message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
			message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
			message = replacetextEx(message, " [key]", " [value]")

		if(prob(3))
			message += pick(" Honh honh honh!"," Honh!"," Zut Alors!")
	speech_args[SPEECH_MESSAGE] = trim(message)

/obj/item/clothing/head/clownmitre
	name = "Шляпа ХонкМатери"
	desc = "Прихожанам трудно увидеть банановую кожуру на полу, когда они смотрят на вашу славную вводную часть."
	icon_state = "clownmitre"

/obj/item/clothing/head/kippah
	name = "ермолка"
	desc = "Знак того, что вы следуете за еврейской Галахой. Держит голову покрытой, а душу внеправославной."
	icon_state = "kippah"

/obj/item/clothing/head/medievaljewhat
	name = "средневековая шляпа еврея"
	desc = "Глупо выглядящая шляпа, предназначенная для того, чтобы надевать на головы угнетенных религиозных меньшинств станции."
	icon_state = "medievaljewhat"

/obj/item/clothing/head/taqiyahwhite
	name = "белый арахчын"
	desc = "Внеочередной способ показать свою преданность Аллаху."
	icon_state = "taqiyahwhite"

/obj/item/clothing/head/taqiyahwhite/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/small)

/obj/item/clothing/head/taqiyahred
	name = "красный арахчын"
	desc = "Внеочередной способ показать свою преданность Аллаху."
	icon_state = "taqiyahred"

/obj/item/clothing/head/taqiyahred/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/small)

/obj/item/clothing/head/shrine_wig
	name = "парик святой девы"
	desc = "Очищайтесь стильно!"
	flags_inv = HIDEHAIR //bald
	icon_state = "shrine_wig"
	inhand_icon_state = "shrine_wig"
	clothing_flags = LARGE_WORN_ICON
	dynamic_hair_suffix = ""
	worn_y_offset = 1

/obj/item/clothing/head/intern
	name = "шляпа интерна"
	desc = "Ужасная смесь из шапочки и мягкого колпачка зеленого цвета ЦентКома. Требуется быть в отчаянии от власти над своими сверстниками, чтобы согласиться носить это."
	icon_state = "intern_hat"
	inhand_icon_state = "intern_hat"

/obj/item/clothing/head/coordinator
	name = "кепка организатора"
	desc = "Кепка организатора вечеринок, стильная!."
	icon_state = "capcap"
	inhand_icon_state = "that"
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

/obj/item/clothing/head/jackbros
	name = "морозная шапка"
	desc = "Хо-хо!"
	icon_state = "JackFrostHat"
	inhand_icon_state = "JackFrostHat"

/obj/item/clothing/head/weddingveil
	name = "свадебная вуаль"
	desc = "Белая прозрачная вуаль."
	icon_state = "weddingveil"
	inhand_icon_state = "weddingveil"

/obj/item/clothing/head/centcom_cap
	name = "шляпа офицера ЦентКома"
	icon_state = "centcom_cap"
	desc = "На шляпе есть какие-то мутные инициалы, которые уже невозможно прочитать."
	inhand_icon_state = "that"
	flags_inv = 0
	armor = list(MELEE = 30, BULLET = 15, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	strip_delay = (8 SECONDS)

/obj/item/clothing/head/rainbowbunchcrown
	name = "Радужная цветочная корона"
	desc = "Цветочная корона, сделанная из разноцветных цветов."
	dynamic_hair_suffix = ""
	attack_verb_continuous = list("коронует")
	attack_verb_simple = list("коронует")

/obj/item/clothing/head/rainbowbunchcrown/Initialize(mapload)
	. = ..()
	var/crown_type = rand(1,4)
	switch(crown_type)
		if(1)
			desc += " This one has red, yellow and white flowers."
			icon_state = "rainbow_bunch_crown_1"
		if(2)
			desc += " This one has blue, yellow, green and white flowers."
			icon_state = "rainbow_bunch_crown_2"
		if(3)
			desc += " This one has red, blue, purple and pink flowers."
			icon_state = "rainbow_bunch_crown_3"
		if(4)
			desc += " This one has yellow, green and white flowers."
			icon_state = "rainbow_bunch_crown_4"

/obj/item/clothing/head/sunflowercrown
	name = "Солнечная цветочная корона"
	desc = "Яркая цветочная корона из подсолнухов, которая обязательно скрасит любой день!"
	icon_state = "sunflower_crown"
	dynamic_hair_suffix = ""
	attack_verb_continuous = list("коронует")
	attack_verb_simple = list("коронует")

/obj/item/clothing/head/poppycrown
	name = "Алая цветочная корона"
	desc = "Цветочная корона, сделанная из гирлянды ярко-красных маков."
	icon_state = "poppy_crown"
	dynamic_hair_suffix = ""
	attack_verb_continuous = list("коронует")
	attack_verb_simple = list("коронует")

/obj/item/clothing/head/lilycrown
	name = "Невинная цветочная корона"
	desc = "Покрытая листьями цветочная корона украшенная большими белыми лилиями."
	icon_state = "lily_crown"
	dynamic_hair_suffix = ""
	attack_verb_continuous = list("коронует")
	attack_verb_simple = list("коронует")

/obj/item/clothing/head/ushanka/soviet
	name = "soviet ushanka"
	desc = "For the union!"
	icon_state = "sovietushankadown"
	inhand_icon_state = "sovietushankadown"

/obj/item/clothing/head/irs
	name = "internal revenue service cap"
	icon_state = "irs_hat"
	inhand_icon_state = "irs_hat"

/obj/item/clothing/head/pg
	name = "powder ganger beanie"
	icon_state = "pg_hat"
	inhand_icon_state = "pg_hat"

/obj/item/clothing/head/tmc
	name = "Lost M.C. bandana"
	icon_state = "tmc_hat"
	inhand_icon_state = "tmc_hat"

/obj/item/clothing/head/deckers
	name = "Decker headphones"
	icon_state = "decker_hat"
	inhand_icon_state = "decker_hat"

/obj/item/clothing/head/morningstar
	name = "Morningstar beret"
	icon_state = "morningstar_hat"
	inhand_icon_state = "morningstar_hat"

/obj/item/clothing/head/saints
	name = "Saints hat"
	icon_state = "saints_hat"
	inhand_icon_state = "saints_hat"

/obj/item/clothing/head/allies
	name = "allies helmet"
	icon_state = "allies_helmet"
	inhand_icon_state = "allies_helmet"

/obj/item/clothing/head/yuri
	name = "yuri initiate helmet"
	icon_state = "yuri_helmet"
	inhand_icon_state = "yuri_helmet"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/sybil_slickers
	name = "sybil slickers helmet"
	icon_state = "football_helmet_blue"
	inhand_icon_state = "football_helmet_blue"

/obj/item/clothing/head/basil_boys
	name = "basil boys helmet"
	icon_state = "football_helmet_red"
	inhand_icon_state = "football_helmet_red"

/obj/item/clothing/head/maidheadband
	name = "повязка на голову горничной"
	desc = "Прямо как в одном из тех китайских мультфильмов!"
	icon_state = "maid_headband"
