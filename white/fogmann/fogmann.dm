


/obj/item/gun/ballistic/shotgun/sniper
	name = "Hunting rifle"
	desc = "A traditional hunting rifle with 4x scope and a four-shell capacity underneath."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "tranqshotgun"
	inhand_icon_state = "sniper"
	w_class = WEIGHT_CLASS_BULKY
	force = 4
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot
	casing_ejector = FALSE
	weapon_weight = WEAPON_MEDIUM

/obj/item/ammo_casing/shotgun/dart/sleeping
	name = "shotgun dart"
	desc = "A dart for use in shotguns. Filled with tranquilizers."
	icon_state = "cshell"
	projectile_type = /obj/projectile/bullet/dart

/obj/item/ammo_casing/shotgun/dart/sleeping/Initialize()
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
	user.visible_message("<span class='suicide'>[user] бьет себя словарем по голове, кажется он чувствует себя хуево!</span>")
	var/delay_offset = 0
	for(var/mob/M in viewers(src, 7))
		var/mob/living/carbon/human/C = M
		if (ishuman(M))
			addtimer(CALLBACK(C, /mob/.proc/emote, "blyadiada"), delay_offset * 0.3)
			delay_offset++
	return (BRUTELOSS)

/datum/uplink_item/role_restricted/ruchinese
	name = "Russian-chinese dictionary"
	desc = "Русско-китайский словарь, особо эффективен против моли и мух."
	item = /obj/item/book/ruchinese
	cost = 18
	restricted_roles = list("Chaplain", "Curator", "Assistant")

/datum/emote/living/carbon/blyad
	key = "blyadiada"
	key_third_person = "blyads"
	message = "blyads."
	muzzle_ignore = FALSE
	hands_use_check = FALSE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/blyad/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			return 'white/fogmann/blyead.ogg'

/area/crew_quarters/fitness/kachalka
	name = "kachalka"

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
	l_pocket = /obj/item/ammo_box/magazine/m9mm
	r_pocket = /obj/item/ammo_box/magazine/m9mm
	back = /obj/item/storage/backpack/duffelbag/drone
	backpack_contents = list(/obj/item/gun/ballistic/automatic/m90/columbine)

//fluff
/obj/item/storage/belt/chameleon/bomb

/obj/item/storage/belt/chameleon/bomb/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/transfer_valve,
		/obj/item/assembly_holder
		))

/datum/uplink_item/device_tools/bombbelt
	name = "Bomb belt"
	desc = "Особый пояс для хранения и переноса бомб, возможно использование в качестве пояса шахида."
	item = /obj/item/storage/belt/chameleon/bomb
	cost = 8


/obj/item/clothing/accessory/medal/frog
	name = "Зеленый значок"
	desc = "Пахнет жабами."
	icon = 'white/pieceofcrap.dmi'
	worn_icon = 'white/pieceofcrap.dmi'
	icon_state = "frog"
	custom_materials = list(/datum/material/titanium=1)


/obj/item/banner/engineering/atmos
	name = "Kazakhstan banner"
	desc = "Сшит из плазмы с вкраплениями слез девственниц."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "banner_atmos"
	job_loyalties = list("Scientist", "Atmospheric Technician")
	warcry = "<b>КАЗАХСТАН УГРОЖАЕТ ВАМ БОМБАРДИРОВКОЙ!!</b>"


/obj/item/banner/engineering/atmos/mundane
	inspiration_available = FALSE

/datum/crafting_recipe/atmos_banner
	name = "Kazakhstan Banner"
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
	desc = "It looks comfy.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon = 'white/pieceofcrap.dmi'
	icon_state = "armchair"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	var/mutable_appearance/armresttp
	buildstackamount = 2
	item_chair = null

/obj/structure/chair/comfy/arm/Initialize()
	armresttp = mutable_appearance('white/pieceofcrap.dmi', "comfychair_armrest")
	armresttp.layer = ABOVE_MOB_LAYER
	return ..()

/obj/structure/chair/comfy/arm/Destroy()
	QDEL_NULL(armresttp)
	return ..()

/obj/structure/chair/comfy/arm/post_buckle_mob(mob/living/M)
	..()
	if(has_buckled_mobs())
		add_overlay(armresttp)
	else
		cut_overlay(armresttp)

/area/ruin/redroom
	name = "The Red Room "

/datum/map_template/ruin/space/redroom
 	id = "redroom"
 	suffix = "redroom.dmm"
 	name = "Red Room"

/obj/item/food/carpmeat/dry/donbas
	name = "Debaltsevo fish"
	desc = "Dryed fish with tomatoes. S vodoi v samiy raz."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "roasted"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/toxin/carpotoxin = 3)
	tastes = list("рыба" = 1, "томаты" =1)
	foodtypes = MEAT

/obj/item/food/carpmeat/dry
	name = "Dryed fish"
	desc = "Just dryed fish. S pivkom v samiy raz."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "dry"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/carpotoxin = 1)
	tastes = list("рыба" = 1)
	foodtypes = MEAT

/datum/crafting_recipe/dryfish
	name = "Dryed Fish"
	result =  /obj/item/food/carpmeat/dry
	time = 80
	reqs = list(/obj/item/food/carpmeat = 3,
				/datum/reagent/fuel = 5)
	category = CAT_MISC

/datum/crafting_recipe/dryfish/donbass
	name = "Debaltsevo Fish"
	result =  /obj/item/food/carpmeat/dry/donbas
	time = 40
	reqs = list(/obj/item/food/carpmeat/dry = 1,
				/datum/reagent/consumable/tomatojuice = 10,
				/obj/item/food/grown/tomato = 1)
	category = CAT_MISC

/obj/item/food/meat/slab/dach
	name = "dach meat"
	desc = "Tastes like... well you know..."
	foodtypes = RAW | MEAT | GROSS

/datum/supply_pack/organic/critter/dhund
	name = "Dachshund Crate"
	cost = 1000
	contains = list(/mob/living/simple_animal/pet/dog/dhund)
	crate_name = "dachshund crate"

/mob/living/simple_animal/pet/dog/dhund
	name = "\improper Dachshund"
	real_name = "Dachshund"
	desc = "It's a dachshund."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "dachshund"
	icon_living = "dachshund"
	icon_dead = "dachshund_dead"
	butcher_results = list(/obj/item/food/meat/slab/dach = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/shepherd
	name = "\improper Shepherd"
	real_name = "Shepherd"
	desc = "It's a Shepherd."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "shepherd"
	icon_living = "shepherd"
	icon_dead = "shepherd_dead"
	butcher_results = list(/obj/item/food/meat/slab/shepherd = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/jack
	name = "\improper Jack"
	real_name = "Jack russell terrier"
	desc = "It's a jack russell terrier."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "jack"
	icon_living = "jack"
	icon_dead = "jack_dead"
	butcher_results = list(/obj/item/food/meat/slab/jack = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/pug/chi
	name = "\improper Chi"
	real_name = "Chihuahua"
	desc = "It's a chihuahua."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "chi"
	icon_living = "chi"
	icon_dead = "chi_dead"
	butcher_results = list(/obj/item/food/meat/slab/chi = 1)
	gold_core_spawnable = 2

/obj/item/food/meat/slab/jack
	name = "jack meat"
	desc = "Tastes like... well you know..."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/chi
	name = "chihuahua meat"
	desc = "Tastes like... well you know..."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/shepherd
	name = "shepherd meat"
	desc = "Tastes like... well you know..."
	foodtypes = RAW | MEAT | GROSS

/datum/supply_pack/organic/critter/shepherd
	name = "German Shepherd"
	cost = 1000
	contains = list(/mob/living/simple_animal/pet/dog/shepherd)
	crate_name = "shepherd crate"

/datum/supply_pack/organic/critter/doggies
	name = "Doggies crate"
	cost = 1000
	contains = list(/mob/living/simple_animal/pet/dog/jack, /mob/living/simple_animal/pet/dog/pug/chi)
	crate_name = "doggies crate"

/obj/item/clothing/head/helmet/alt/ranger
	name = "шлем рейнджера НКР"
	desc = "Стандартный шлем Независимой Карабахской Республики. Защищает голову от ударов сухим лавашом."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "rangerhelm"
	worn_icon = 'white/pieceofcrap.dmi'
	icon_state = "rangerhelm"
	inhand_icon_state = "helmet"
	armor = list(MELEE = 40, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 5)
	strip_delay = 80

/obj/item/clothing/suit/armor/hos/ranger
	name = "Плащ рейнджера НКР"
	desc = "Классное пальто сшитое из шкур голиафа. Изготовлено по заказу Независимой Карабахской Республики"
	icon = 'white/pieceofcrap.dmi'
	icon_state = "ranger"
	worn_icon = 'white/pieceofcrap.dmi'
	inhand_icon_state = "greatcoat"
	strip_delay = 80

/datum/crafting_recipe/rangerhelm
	name = "шлем рейнджера НКР"
	result =  /obj/item/clothing/head/helmet/alt/ranger
	time = 80
	reqs = list(/obj/item/stack/sheet/plasteel = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 1)
	tools = list(TOOL_SCREWDRIVER)
	category = CAT_PRIMAL

/datum/crafting_recipe/ranger
	name = "Плащ рейнджера НКР"
	result =  /obj/item/clothing/suit/armor/hos/ranger
	time = 80
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/animalhide/goliath_hide = 3)
	tools = list(TOOL_SCREWDRIVER)
	category = CAT_PRIMAL

datum/crafting_recipe/frog
	name = "????"
	result =  /obj/item/clothing/accessory/medal/frog
	time = 80
	reqs = list(/obj/item/stack/sheet/mineral/titanium = 1)
	tools = list(TOOL_WELDER)
	category = CAT_MISC