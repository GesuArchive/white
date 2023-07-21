/obj/item/clothing/gloves/color
	dying_key = DYE_REGISTRY_GLOVES
	desc = "Пара обычных, ничем не выделяющихся перчаток."

/obj/item/clothing/gloves/color/chief_engineer
	name = "продвинутые изоляционные перчатки"
	desc = "Резиновые перчатки с прекрасной электро- и теплоизоляцией. Настолько тонкие, что я едва чувствую их."
	icon_state = "ce_insuls"
	inhand_icon_state = "lgloves"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT

/obj/item/clothing/gloves/color/yellow
	name = "резиновые перчатки"
	desc = "Эти перчатки защитят пользователя от поражения электрическим током. Очень толстые, пострелять с такими не получится."
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	siemens_coefficient = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	resistance_flags = NONE
	custom_price = PAYCHECK_MEDIUM * 10
	custom_premium_price = PAYCHECK_COMMAND * 6
	cut_type = /obj/item/clothing/gloves/cut
	clothing_traits = list(TRAIT_CHUNKYFINGERS)

/obj/item/toy/sprayoncan
	name = "распылитель изолирующего спрея"
	desc = "Какая главная проблема встала сегодня перед нашей станцией?"
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "sprayoncan"

/obj/item/toy/sprayoncan/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(iscarbon(target) && proximity)
		var/mob/living/carbon/C = target
		var/mob/living/carbon/U = user
		var/success = C.equip_to_slot_if_possible(new /obj/item/clothing/gloves/color/yellow/sprayon, ITEM_SLOT_GLOVES, qdel_on_fail = TRUE, disable_warning = TRUE)
		if(success)
			if(C == user)
				C.visible_message(span_notice("[U] распылил на руки блестящую резину!"))
			else
				C.visible_message(span_warning("[U] распылил на руки [C] блестяшую резину!"))
		else
			C.visible_message(span_warning("Резина не прилипла к рукам [C]!"))

/obj/item/clothing/gloves/color/yellow/sprayon
	desc = "И как ты собираешься их снять, умник?"
	name = "перчатки из изолирующего спрея"
	icon_state = "sprayon"
	inhand_icon_state = "sprayon"
	item_flags = DROPDEL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	resistance_flags = ACID_PROOF
	var/charges_remaining = 10

/obj/item/clothing/gloves/color/yellow/sprayon/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)

/obj/item/clothing/gloves/color/yellow/sprayon/equipped(mob/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SHOCK_PREVENTED, PROC_REF(use_charge))
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(use_charge))

/obj/item/clothing/gloves/color/yellow/sprayon/proc/use_charge()
	SIGNAL_HANDLER

	charges_remaining--
	if(charges_remaining <= 0)
		var/turf/location = get_turf(src)
		location.visible_message(span_warning("[src] рассыпается в пыль.")) // прямо как мои сны после перевода
		qdel(src)

/obj/item/clothing/gloves/color/fyellow                             //Cheap Chinese Crap
	desc = "Эти перчатки являются дешевыми подделками желанных перчаток. Что может пойти не так?"
	name = "бюджетные резиновые перчатки"
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in Initialize()
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	resistance_flags = NONE
	cut_type = /obj/item/clothing/gloves/cut

/obj/item/clothing/gloves/color/fyellow/Initialize(mapload)
	. = ..()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)

/obj/item/clothing/gloves/color/fyellow/old
	desc = "Эти потрёпанные временем перчатки <i>возможно</i> защитят пользователя от поражения электрическим током. Только один способ проверить, так ли это..."
	name = "старенькие резиновые перчатки"

/obj/item/clothing/gloves/color/fyellow/old/Initialize(mapload)
	. = ..()
	siemens_coefficient = pick(0,0,0,0.5,0.5,0.5,0.75)

/obj/item/clothing/gloves/cut
	desc = "Эти перчатки защитили бы от поражения электрическим током, если бы один умник не отрезал у них пальцы."
	name = "резиновые перчатки без пальцев"
	icon_state = "yellowcut"
	inhand_icon_state = "ygloves"
	transfer_prints = TRUE

/obj/item/clothing/gloves/cut/heirloom
	desc = "Старые перчатки, которые твой великий дед украл в инженерном отсеке много лун назад. Их потрепало за последнее время."

/obj/item/clothing/gloves/color/black
	name = "чёрные перчатки"
	desc = "Огнеупорные перчатки."
	icon_state = "black"
	inhand_icon_state = "blackgloves"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	cut_type = /obj/item/clothing/gloves/fingerless

/obj/item/clothing/gloves/color/orange
	name = "оранжевые перчатки"
	icon_state = "orange"
	inhand_icon_state = "orangegloves"

/obj/item/clothing/gloves/color/red
	name = "красные перчатки"
	icon_state = "red"
	inhand_icon_state = "redgloves"


/obj/item/clothing/gloves/color/red/insulated
	name = "резиновые перчатки"
	desc = "Эти перчатки защитят пользователя от поражения электрическим током."
	siemens_coefficient = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	resistance_flags = NONE

/obj/item/clothing/gloves/color/rainbow
	name = "радужные перчатки"
	icon_state = "rainbow"
	inhand_icon_state = "rainbowgloves"

/obj/item/clothing/gloves/color/blue
	name = "синие перчатки"
	icon_state = "blue"
	inhand_icon_state = "bluegloves"

/obj/item/clothing/gloves/color/purple
	name = "фиолетовые перчатки"
	icon_state = "purple"
	inhand_icon_state = "purplegloves"

/obj/item/clothing/gloves/color/green
	name = "зелёные перчатки"
	icon_state = "green"
	inhand_icon_state = "greengloves"

/obj/item/clothing/gloves/color/grey
	name = "серые перчатки"
	icon_state = "gray"
	inhand_icon_state = "graygloves"

/obj/item/clothing/gloves/color/light_brown
	name = "светло-коричневые перчатки"
	icon_state = "lightbrown"
	inhand_icon_state = "lightbrowngloves"

/obj/item/clothing/gloves/color/brown
	name = "коричневые перчатки"
	icon_state = "brown"
	inhand_icon_state = "browngloves"

/obj/item/clothing/gloves/color/captain
	desc = "Царственно-синие перчатки с красивой золотой отделкой, алмазным противоударным покрытием и встроенным тепловым барьером. Шикарно."
	name = "капитанские перчатки"
	icon_state = "captain"
	inhand_icon_state = "egloves"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 60
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, RAD = 0, FIRE = 70, ACID = 50)

/obj/item/clothing/gloves/color/latex
	name = "латексные перчатки"
	desc = "Дешевые стерильные перчатки из латекса. Передают парамедицинские знания пользователю через бюджетные наночипы."
	icon_state = "latex"
	inhand_icon_state = "latex"
	siemens_coefficient = 0.3
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	clothing_traits = list(TRAIT_QUICK_CARRY)
	transfer_prints = TRUE
	resistance_flags = NONE

/obj/item/clothing/gloves/color/latex/nitrile
	name = "нитриловые перчатки"
	desc = "Дорогие стерильные перчатки из нитрила. Передаёт через наночипы знания, эквивалентные нескольким годам обучения в передовой медицинской академии."
	icon_state = "nitrile"
	inhand_icon_state = "nitrilegloves"
	clothing_traits = list(TRAIT_QUICKER_CARRY, TRAIT_FASTMED)
	transfer_prints = FALSE

/obj/item/clothing/gloves/color/infiltrator
	name = "перчатки лазутчика"
	desc = "Заточенные под боевые столкновения перчатки для \"добровольно-принудительной передислокации\" людей. Передают носителю полезный в быту навык похищения людей."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	siemens_coefficient = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 70, FIRE = 0, ACID = 0)
	clothing_traits = list(TRAIT_QUICKER_CARRY)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	transfer_prints = FALSE

/obj/item/clothing/gloves/color/latex/engineering
	name = "перчатки мастера"
	desc = "Высокотехнологичные инженерные перчатки. Корректируют движения пользователя посредством наночипов с заложенными программами для инженерных работ. Защищают от ударов током и высоких температур."
	icon = 'icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_gauntlets"
	inhand_icon_state = "clockwork_gauntlets"
	siemens_coefficient = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	clothing_traits = list(TRAIT_QUICK_BUILD)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	custom_materials = list(/datum/material/iron=2000, /datum/material/silver=1500, /datum/material/gold = 1000)

/obj/item/clothing/gloves/color/white
	name = "белые перчатки"
	desc = "Выглядят довольно причудливо."
	icon_state = "white"
	inhand_icon_state = "wgloves"
	custom_price = PAYCHECK_MINIMAL

/obj/item/clothing/gloves/color/white/Initialize(mapload)
	. = ..()
	desc = "Выглядят довольно причудливо. [prob(30) ? "Смотря на них, у меня появляется такое чувство, будто я что-то забыл. [prob(50)?"Что-то очень, очень важное...":""]" : "" ]"

/obj/effect/spawner/lootdrop/gloves
	name = "случайные перчатки"
	desc = "Эти перчатки должны быть случайного цвета." //Нахуй описание спавнеру?
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "random_gloves"
	loot = list(
		/obj/item/clothing/gloves/color/orange = 1,
		/obj/item/clothing/gloves/color/red = 1,
		/obj/item/clothing/gloves/color/blue = 1,
		/obj/item/clothing/gloves/color/purple = 1,
		/obj/item/clothing/gloves/color/green = 1,
		/obj/item/clothing/gloves/color/grey = 1,
		/obj/item/clothing/gloves/color/light_brown = 1,
		/obj/item/clothing/gloves/color/brown = 1,
		/obj/item/clothing/gloves/color/white = 1,
		/obj/item/clothing/gloves/color/rainbow = 1)

/obj/item/clothing/gloves/kim
	name = "aerostatic gloves"
	desc = "Breathable red gloves for expert handling of a pen and notebook."
	icon_state = "aerostatic_gloves"
	inhand_icon_state = "aerostatic_gloves"

/obj/item/clothing/gloves/maid
	name = "нарукавники служанки"
	desc = "Нарукавники цилиндрического вида, миленько."
	icon_state = "maid_arms"
	worn_icon_state = "maid_arms"
