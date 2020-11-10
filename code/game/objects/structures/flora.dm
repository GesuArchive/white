/obj/structure/flora
	resistance_flags = FLAMMABLE
	max_integrity = 150
	anchored = TRUE

//trees
/obj/structure/flora/tree
	name = "дерево"
	desc = "Огромное дерево."
	density = TRUE
	pixel_x = -16
	layer = FLY_LAYER
	var/log_amount = 10

/obj/structure/flora/tree/attackby(obj/item/W, mob/user, params)
	if(log_amount && (!(flags_1 & NODECONSTRUCT_1)))
		if(W.get_sharpness() && W.force > 0)
			if(W.hitsound)
				playsound(get_turf(src), W.hitsound, 100, FALSE, FALSE)
			user.visible_message("<span class='notice'>[user] начинает срубать [src] при помощи [W].</span>","<span class='notice'>Начинаю срубать [src] используя [W].</span>", "<span class='hear'>Слышу звуки работы с деревом.</span>")
			if(do_after(user, 1000/W.force, target = src)) //5 seconds with 20 force, 8 seconds with a hatchet, 20 seconds with a shard.
				user.visible_message("<span class='notice'>[user] срубает [src] используя [W].</span>","<span class='notice'>Срубаю [src] используя [W].</span>", "<span class='hear'>Слышу громкий звук падения дерева.</span>")
				playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 100 , FALSE, FALSE)
				user.log_message("cut down [src] at [AREACOORD(src)]", LOG_ATTACK)
				for(var/i=1 to log_amount)
					new /obj/item/grown/log/tree(get_turf(src))
				var/obj/structure/flora/stump/S = new(loc)
				S.name = "пенёк [sklonenie(name, VINITELNI, gender)]"
				qdel(src)
	else
		return ..()

/obj/structure/flora/stump
	name = "пень"
	desc = "Это является нашим обещанием экипажу и самой станции срубить как можно больше деревьев." //running naked through the trees
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "tree_stump"
	density = FALSE
	pixel_x = -16

/obj/structure/flora/tree/pine
	name = "сосна"
	desc = "Хвойная сосна."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	var/list/icon_states = list("pine_1", "pine_2", "pine_3")

/obj/structure/flora/tree/pine/Initialize()
	. = ..()

	if(islist(icon_states?.len))
		icon_state = pick(icon_states)

/obj/structure/flora/tree/pine/xmas
	name = "рождественская ёлка"
	desc = "Дивно украшенная елка."
	icon_state = "pine_c"
	icon_states = null
	flags_1 = NODECONSTRUCT_1 //protected by the christmas spirit

/obj/structure/flora/tree/pine/xmas/presents
	icon_state = "pinepresents"
	desc = "Дивно украшенная елка. Есть подарки!"
	var/gift_type = /obj/item/a_gift/anything
	var/unlimited = FALSE
	var/static/list/took_presents //shared between all xmas trees

/obj/structure/flora/tree/pine/xmas/presents/Initialize()
	. = ..()
	if(!took_presents)
		took_presents = list()

/obj/structure/flora/tree/pine/xmas/presents/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!user.ckey)
		return

	if(took_presents[user.ckey] && !unlimited)
		to_chat(user, "<span class='warning'>Здесь нет подарков для меня...</span>")
		return
	to_chat(user, "<span class='warning'>После небольшого осмотра нахожу подарок с моим именем на нем!</span>")

	if(!unlimited)
		took_presents[user.ckey] = TRUE

	var/obj/item/G = new gift_type(src)
	user.put_in_hands(G)

/obj/structure/flora/tree/pine/xmas/presents/unlimited
	desc = "Чудесно украшенная елка. У него бесконечный запас подарков!"
	unlimited = TRUE

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	desc = "Мертвое дерево. Как оно умерло, вы не знаете."
	icon_state = "tree_1"

/obj/structure/flora/tree/palm
	icon = 'icons/misc/beach2.dmi'
	desc = "Дерево прямо из тропиков."
	icon_state = "palm1"

/obj/structure/flora/tree/palm/Initialize()
	. = ..()
	icon_state = pick("palm1","palm2")
	pixel_x = 0

/obj/structure/festivus
	name = "festivus pole"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "festivus_pole"
	desc = "Во время прошлогодних подвигов директор по исследованиям смог погрузить эту неподвижную удочку в сеялку."

/obj/structure/festivus/anchored
	name = "суплексированный стержень"
	desc = "Настоящий подвиг силы, почти такой же, как в прошлом году."
	icon_state = "anchored_rod"
	anchored = TRUE

/obj/structure/flora/tree/dead/Initialize()
	icon_state = "tree_[rand(1, 6)]"
	. = ..()

/obj/structure/flora/tree/jungle
	name = "дерево"
	icon_state = "tree"
	desc = "Это серьезно мешает обзору джунглей."
	icon = 'icons/obj/flora/jungletrees.dmi'
	pixel_x = -48
	pixel_y = -20

/obj/structure/flora/tree/jungle/Initialize()
	icon_state = "[icon_state][rand(1, 6)]"
	. = ..()

/obj/structure/flora/tree/jungle/small
	pixel_y = 0
	pixel_x = -32
	icon = 'icons/obj/flora/jungletreesmall.dmi'

//grass
/obj/structure/flora/grass
	name = "трава"
	desc = "Кусочек заросшей травы."
	icon = 'icons/obj/flora/snowflora.dmi'
	gender = PLURAL	//"this is grass" not "this is a grass"

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/Initialize()
	icon_state = "snowgrass[rand(1, 3)]bb"
	. = ..()


/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/Initialize()
	icon_state = "snowgrass[rand(1, 3)]gb"
	. = ..()

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/Initialize()
	icon_state = "snowgrassall[rand(1, 3)]"
	. = ..()


//bushes
/obj/structure/flora/bush
	name = "куст"
	desc = "Какой-то кустарник."
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	anchored = TRUE

/obj/structure/flora/bush/Initialize()
	icon_state = "snowbush[rand(1, 6)]"
	. = ..()

//newbushes

/obj/structure/flora/ausbushes
	name = "куст"
	desc = "Какое-то растение."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"

/obj/structure/flora/ausbushes/Initialize()
	if(icon_state == "firstbush_1")
		icon_state = "firstbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/Initialize()
	icon_state = "reedbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/Initialize()
	icon_state = "leafybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/Initialize()
	icon_state = "palebush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/Initialize()
	icon_state = "stalkybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/Initialize()
	icon_state = "grassybush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/Initialize()
	icon_state = "fernybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/Initialize()
	icon_state = "sunnybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/Initialize()
	icon_state = "genericbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/Initialize()
	icon_state = "pointybush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/Initialize()
	icon_state = "lavendergrass_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/Initialize()
	icon_state = "ywflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/Initialize()
	icon_state = "brflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/Initialize()
	icon_state = "ppflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/Initialize()
	icon_state = "sparsegrass_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/Initialize()
	icon_state = "fullgrass_[rand(1, 3)]"
	. = ..()

/obj/item/kirbyplants
	name = "растение в горшке"
	icon = 'icons/obj/flora/plants.dmi'
	icon_state = "plant-01"
	desc = "Немного природы в горшке."
	layer = BELOW_MOB_LAYER
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 13
	throw_speed = 2
	throw_range = 4

	/// Can this plant be trimmed by someone with TRAIT_BONSAI
	var/trimmable = TRUE
	var/list/static/random_plant_states

/obj/item/kirbyplants/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/tactical)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=10, force_wielded=10)
	INVOKE_ASYNC(src, /datum.proc/_AddComponent, list(/datum/component/beauty, 500))

/obj/item/kirbyplants/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(trimmable && HAS_TRAIT(user,TRAIT_BONSAI) && isturf(loc) && I.get_sharpness())
		to_chat(user,"<span class='notice'>Начинаю стричь [src].</span>")
		if(do_after(user,3 SECONDS,target=src))
			to_chat(user,"<span class='notice'>Стригу [src].</span>")
			change_visual()

/// Cycle basic plant visuals
/obj/item/kirbyplants/proc/change_visual()
	if(!random_plant_states)
		generate_states()
	var/current = random_plant_states.Find(icon_state)
	var/next = WRAP(current+1,1,length(random_plant_states))
	icon_state = random_plant_states[next]

/obj/item/kirbyplants/random
	icon = 'icons/obj/flora/_flora.dmi'
	icon_state = "random_plant"

/obj/item/kirbyplants/random/Initialize()
	. = ..()
	icon = 'icons/obj/flora/plants.dmi'
	if(!random_plant_states)
		generate_states()
	icon_state = pick(random_plant_states)

/obj/item/kirbyplants/proc/generate_states()
	random_plant_states = list()
	for(var/i in 1 to 25)
		var/number
		if(i < 10)
			number = "0[i]"
		else
			number = "[i]"
		random_plant_states += "plant-[number]"
	random_plant_states += "applebush"


/obj/item/kirbyplants/dead
	name = "любимое растение научного руководителя"
	desc = "Подарок от ботанического коллектива, подаренный после переназначения научного сотрудника. На нем есть бирка с надписью \"Вы все вернетесь, слышите? \" \n Выглядит не очень здоровым..."
	icon_state = "plant-25"
	trimmable = FALSE

/obj/item/kirbyplants/photosynthetic
	name = "фотосинтетическое растение в горшке"
	desc = "Биолюминесцентное растение."
	icon_state = "plant-09"
	light_color = COLOR_BRIGHT_BLUE
	light_range = 3

/obj/item/kirbyplants/fullysynthetic
	name = "растение в горшке из пластика"
	desc = "Поддельное, дешевое, пластиковое дерево. Идеально подходит для людей, которые убивают каждое растение, к которому прикасаются."
	icon_state = "plant-26"
	custom_materials = (list(/datum/material/plastic = 8000))
	trimmable = FALSE

/obj/item/kirbyplants/fullysynthetic/Initialize()
	. = ..()
	icon_state = "plant-[rand(26, 29)]"

/obj/item/kirbyplants/potty
	name = "Potty the Potted Plant"
	desc = "Секретный агент работал в баре станции, чтобы защитить мистический торт."
	icon_state = "potty"
	trimmable = FALSE

//a rock is flora according to where the icon file is
//and now these defines

/obj/structure/flora/rock
	icon_state = "basalt"
	name = "камень"
	desc = "Вулканическая скала. Пионеры ездили на этих младенцах на мили."
	icon = 'icons/obj/flora/rocks.dmi'
	resistance_flags = FIRE_PROOF
	density = TRUE
	/// Itemstack that is dropped when a rock is mined with a pickaxe
	var/obj/item/stack/mineResult = /obj/item/stack/ore/glass/basalt
	/// Amount of the itemstack to drop
	var/mineAmount = 20

/obj/structure/flora/rock/Initialize()
	. = ..()
	icon_state = "[icon_state][rand(1,3)]"

/obj/structure/flora/rock/Destroy()
	if(mineResult && mineAmount)
		new mineResult(loc, mineAmount)
	. = ..()

/obj/structure/flora/rock/attackby(obj/item/W, mob/user, params)
	if(!mineResult || W.tool_behaviour != TOOL_MINING)
		return ..()
	if(flags_1 & NODECONSTRUCT_1)
		return ..()
	to_chat(user, "<span class='notice'>Начинаю копать...</span>")
	if(W.use_tool(src, user, 40, volume=50))
		to_chat(user, "<span class='notice'>Заканчиваю копать камень.</span>")
		SSblackbox.record_feedback("tally", "pick_used_mining", 1, W.type)
		qdel(src)

/obj/structure/flora/rock/pile
	icon_state = "lavarocks"
	desc = "Куча камней."

//Jungle grass

/obj/structure/flora/grass/jungle
	name = "трава джунглей"
	desc = "Густая чужеродная флора."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa"


/obj/structure/flora/grass/jungle/Initialize()
	icon_state = "[icon_state][rand(1, 5)]"
	. = ..()

/obj/structure/flora/grass/jungle/b
	icon_state = "grassb"

//Jungle rocks

/obj/structure/flora/rock/jungle
	icon_state = "rock"
	desc = "Куча камней."
	icon = 'icons/obj/flora/jungleflora.dmi'
	density = FALSE

/obj/structure/flora/rock/jungle/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)][rand(1,5)]"


//Jungle bushes

/obj/structure/flora/junglebush
	name = "куст"
	desc = "Дикое растение, которое растет в джунглях."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "busha"

/obj/structure/flora/junglebush/Initialize()
	icon_state = "[icon_state][rand(1, 3)]"
	. = ..()

/obj/structure/flora/junglebush/b
	icon_state = "bushb"

/obj/structure/flora/junglebush/c
	icon_state = "bushc"

/obj/structure/flora/junglebush/large
	icon_state = "bush"
	icon = 'icons/obj/flora/largejungleflora.dmi'
	pixel_x = -16
	pixel_y = -12
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/rock/pile/largejungle
	name = "камни"
	icon_state = "rocks"
	icon = 'icons/obj/flora/largejungleflora.dmi'
	density = FALSE
	pixel_x = -16
	pixel_y = -16

/obj/structure/flora/rock/pile/largejungle/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)][rand(1,3)]"

