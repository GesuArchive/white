


/obj/item/gun/ballistic/shotgun/sniper
	name = "Hunting rifle"
	desc = "A traditional hunting rifle with 4x scope and a four-shell capacity underneath."
	icon = 'white/pieceofcrap.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "tranqshotgun"
	inhand_icon_state = "sniper"
	w_class = WEIGHT_CLASS_BULKY
	force = 4
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot
	casing_ejector = FALSE
	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/ballistic/shotgun/sniper/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

/obj/item/ammo_casing/shotgun/dart/sleeping
	name = "shotgun dart"
	desc = "A dart for use in shotguns. Filled with tranquilizers."
	icon_state = "cshell"
	projectile_type = /obj/projectile/bullet/dart

/obj/item/ammo_casing/shotgun/dart/sleeping/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/sodium_thiopental, 20)

/obj/item/storage/box/sleeping
	name = "box of tranquilizer darts"
	desc = "A box full of darts, filled with tranquilizers."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "tranqshot"
	illustration = null

/obj/item/storage/box/sleeping/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/dart/sleeping(src)

/obj/item/book/ruchinese
	name = "Russian-chinese dictionary"
	desc = "Apply to the moths and flies."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "slovar"
	inhand_icon_state = "bible"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	force = 17
	block_chance = 70
	hitsound = 'white/fogmann/yebal.ogg'
	dat = {"<html><body>
	<img src=https://pp.userapi.com/c638421/v638421709/50c5d/RbBWfRq8b8Q.jpg>
	</body>
	</html>"}


/obj/item/book/ruchinese/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] бьет себя словарем по голове, кажется он чувствует себя не очень хорошо!"))
	return (BRUTELOSS)

/datum/uplink_item/role_restricted/ruchinese
	name = "Russian-chinese dictionary"
	desc = "Русско-китайский словарь, особо эффективен против моли и мух."
	item = /obj/item/book/ruchinese
	cost = 18
	restricted_roles = list(JOB_CHAPLAIN, JOB_CURATOR, JOB_ASSISTANT)

/area/commons/fitness/kachalka
	name = "Техтоннели: Качалка"

/obj/item/westposter
	name = "WORK HARDER"
	desc = "NOT SMARTER"
	icon = 'white/statue_w.dmi'
	icon_state = "OH"
	verb_say = "констатирует"
	density = 0
	anchored = 1
	pixel_x = -32

/obj/item/eastposter
	name = "WORK HARDER"
	desc = "NOT SMARTER"
	icon = 'white/statue_w.dmi'
	icon_state = "UH"
	verb_say = "констатирует"
	density = 0
	anchored = 1
	pixel_x = 32

//outfits
/datum/outfit/dag
	name = "dagestan"

	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/pants/black
	suit = /obj/item/clothing/suit/hawaiian
	shoes = /obj/item/clothing/shoes/sneakers/red
	head = /obj/item/clothing/head/fedora
	belt = /obj/item/nullrod/claymore/multiverse
	l_pocket = /obj/item/ammo_box/magazine/m9mm_aps
	r_pocket = /obj/item/ammo_box/magazine/m9mm_aps
	back = /obj/item/storage/backpack/duffelbag/drone
	backpack_contents = list(/obj/item/gun/ballistic/automatic/columbine = 1)

//fluff
/obj/item/storage/belt/chameleon/bomb

/obj/item/storage/belt/chameleon/bomb/PopulateContents()
	new /obj/item/transfer_valve(src)

/obj/item/storage/belt/chameleon/bomb/Initialize()
	. = ..()
	atom_storage.max_slots = 2
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.set_holdable(list(
		/obj/item/transfer_valve,
		/obj/item/assembly_holder
		))

/datum/uplink_item/device_tools/bombbelt
	name = "Bomb belt"
	desc = "Особый пояс для хранения и переноса бомб, возможно использование в качестве пояса шахида."
	item = /obj/item/storage/belt/chameleon/bomb
	cost = 10


/obj/item/clothing/accessory/medal/frog
	name = "Зеленый значок"
	desc = "Пахнет жабами."
	icon = 'white/pieceofcrap.dmi'
	worn_icon = 'white/pieceofcrap.dmi'
	icon_state = "frog"
	custom_materials = list(/datum/material/titanium=1)


/obj/item/banner/engineering/atmos
	name = "знамя Казахстана"
	desc = "Сшит из плазмы с вкраплениями слез девственниц."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "banner_atmos"
	job_loyalties = list(JOB_SCIENTIST, JOB_ATMOSPHERIC_TECHNICIAN)
	warcry = "<b>КАЗАХСТАН УГРОЖАЕТ ВАМ БОМБАРДИРОВКОЙ!!</b>"


/obj/item/banner/engineering/atmos/mundane
	inspiration_available = FALSE

/datum/crafting_recipe/atmos_banner
	name = "знамя Казахстана"
	result = /obj/item/banner/engineering/atmos/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/engineering/atmospheric_technician = 1)
	category = CAT_MISC

/obj/item/stack/tile/carpet/peaks
	name = "peaks carpet"
	singular_name = "peaks carpet"
	desc = "A piece of carpet. It is the same size as a floor tile."
	icon = 'icons/obj/tiles.dmi'
	icon_state = "tile-carpet"
	turf_type = /turf/open/floor/carpet
	resistance_flags = FLAMMABLE

/turf/open/floor/carpet/peaks
	icon = 'white/pieceofcrap.dmi'
	icon_state = "carp_tp"
	floor_tile = /obj/item/stack/tile/carpet/peaks
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null

/obj/structure/curtain/red
	name = "красный curtain"
	desc = "Contains less than 1% mercury."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "curtain-open"
	icon_type = "curtain"
	alpha = 255
	opaque_closed = TRUE

/obj/item/device/flashlight/slamp
	name = "stand lamp"
	desc = "Floor lamp in a minimalist style."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "slamp"
	inhand_icon_state = "slamp"
	density = 0
	force = 9
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	color = LIGHT_COLOR_YELLOW
	w_class = WEIGHT_CLASS_BULKY
	flags_1 = CONDUCT_1
	custom_materials = list()
	anchored = TRUE

/obj/structure/statue/sandstone/venus/afrodita
	name = "Afrodita"
	desc = "An ancient marble statue. The subject is depicted with a floor-length braid. By Jove, it's easily the most gorgeous depiction of a woman you've ever seen. The artist must truly be a master of his craft. Shame about the broken arm, though."
	icon = 'white/statue_w.dmi'
	icon_state = "venus"

/obj/structure/chair/comfy/arm
	name = "Armchair"
	desc = "It looks comfy.\n<span class='notice'>ПКМ to rotate it clockwise.</span>"
	icon = 'white/pieceofcrap.dmi'
	icon_state = "armchair"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstackamount = 2
	item_chair = null

/obj/structure/chair/comfy/arm/GetArmrest()
	return mutable_appearance('white/pieceofcrap.dmi', "comfychair_armrest")

/area/ruin/redroom
	name = "The Red Room "

/datum/map_template/ruin/space/redroom
 	id = "redroom"
 	suffix = "redroom.dmm"
 	name = "Red Room"

/obj/item/food/fishmeat/carp/dry/donbas
	name = "рыба из Дебальцево"
	desc = "Сушеная рыба с томатами. Самое то под водочку."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "roasted"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/toxin/carpotoxin = 3)
	tastes = list("рыба" = 1, "томаты" =1)
	foodtypes = MEAT

/obj/item/food/fishmeat/carp/dry
	name = "Сушеная рыба"
	desc = "Просто сушеная рыба. С пивком самое то."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "dry"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/carpotoxin = 1)
	tastes = list("рыба" = 1)
	foodtypes = MEAT

/datum/crafting_recipe/dryfish
	name = "Сушеная рыба"
	result =  /obj/item/food/fishmeat/carp/dry
	time = 80
	reqs = list(/obj/item/food/fishmeat/carp = 3,
				/datum/reagent/fuel = 5)
	category = CAT_MISC

/datum/crafting_recipe/dryfish/donbass
	name = "рыба из Дебальцево"
	result =  /obj/item/food/fishmeat/carp/dry/donbas
	time = 40
	reqs = list(/obj/item/food/fishmeat/carp/dry = 1,
				/datum/reagent/consumable/tomatojuice = 10,
				/obj/item/food/grown/tomato = 1)
	category = CAT_MISC

/obj/item/clothing/head/helmet/alt/ranger
	name = "шлем рейнджера НКР"
	desc = "Стандартный шлем Независимой Карабахской Республики. Защищает голову от ударов сухим лавашом."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "rangerhelm"
	worn_icon = 'white/pieceofcrap.dmi'
	icon_state = "rangerhelm"
	inhand_icon_state = "helmet"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)
	strip_delay = 80
	can_flashlight = FALSE

/obj/item/clothing/suit/armor/hos/ranger
	name = "Плащ рейнджера НКР"
	desc = "Классное пальто сшитое из шкур голиафа. Изготовлено по заказу Независимой Карабахской Республики"
	icon = 'white/pieceofcrap.dmi'
	icon_state = "ranger"
	worn_icon = 'white/pieceofcrap.dmi'
	inhand_icon_state = "greatcoat"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)
	strip_delay = 80

/datum/crafting_recipe/rangerhelm
	name = "шлем рейнджера НКР"
	result =  /obj/item/clothing/head/helmet/alt/ranger
	time = 80
	reqs = list(/obj/item/stack/sheet/plasteel = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_CLOTHING

/datum/crafting_recipe/ranger
	name = "Плащ рейнджера НКР"
	result =  /obj/item/clothing/suit/armor/hos/ranger
	time = 80
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/animalhide/goliath_hide = 3)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_CLOTHING

/datum/crafting_recipe/frog
	name = "????"
	result =  /obj/item/clothing/accessory/medal/frog
	time = 80
	reqs = list(/obj/item/stack/sheet/mineral/titanium = 1)
	tool_behaviors = list(TOOL_WELDER)
	category = CAT_MISC
