
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
	alpha = 255 //Mappers can also just set this to 255 if they want curtains that can't be seen through
	layer = SIGN_LAYER
	anchored = TRUE
	opacity = 0
	density = FALSE
	open = TRUE

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

/obj/item/reagent_containers/food/snacks/carpmeat/dry/donbas
	name = "Debaltsevo fish"
	desc = "Dryed fish with tomatoes. S vodoi v samiy raz."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "roasted"
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/toxin/carpotoxin = 3)
	bitesize = 2
	filling_color = "#000000"
	tastes = list("рыба" = 1, "томаты" =1)
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/carpmeat/dry
	name = "Dryed fish"
	desc = "Just dryed fish. S pivkom v samiy raz."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "dry"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/carpotoxin = 1)
	bitesize = 2
	filling_color = "#FA8072"
	tastes = list("рыба" = 1)
	foodtype = MEAT

/datum/crafting_recipe/dryfish
	name = "Dryed Fish"
	result =  /obj/item/reagent_containers/food/snacks/carpmeat/dry
	time = 80
	reqs = list(/obj/item/reagent_containers/food/snacks/carpmeat = 3,
				/datum/reagent/fuel = 5)
	category = CAT_MISC

/datum/crafting_recipe/dryfish/donbass
	name = "Debaltsevo Fish"
	result =  /obj/item/reagent_containers/food/snacks/carpmeat/dry/donbas
	time = 40
	reqs = list(/obj/item/reagent_containers/food/snacks/carpmeat/dry = 1,
				/datum/reagent/consumable/tomatojuice = 10,
				/obj/item/reagent_containers/food/snacks/grown/tomato = 1)
	category = CAT_MISC

/obj/item/reagent_containers/food/snacks/meat/slab/dach
	name = "dach meat"
	desc = "Tastes like... well you know..."
	foodtype = RAW | MEAT | GROSS

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
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/dach = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/shepherd
	name = "\improper Shepherd"
	real_name = "Shepherd"
	desc = "It's a Shepherd."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "shepherd"
	icon_living = "shepherd"
	icon_dead = "shepherd_dead"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/shepherd = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/jack
	name = "\improper Jack"
	real_name = "Jack russell terrier"
	desc = "It's a jack russell terrier."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "jack"
	icon_living = "jack"
	icon_dead = "jack_dead"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/jack = 3)
	gold_core_spawnable = 2

/mob/living/simple_animal/pet/dog/pug/chi
	name = "\improper Chi"
	real_name = "Chihuahua"
	desc = "It's a chihuahua."
	icon = 'white/pieceofcrap.dmi'
	icon_state = "chi"
	icon_living = "chi"
	icon_dead = "chi_dead"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/chi = 1)
	gold_core_spawnable = 2

/obj/item/reagent_containers/food/snacks/meat/slab/jack
	name = "jack meat"
	desc = "Tastes like... well you know..."
	foodtype = RAW | MEAT | GROSS

/obj/item/reagent_containers/food/snacks/meat/slab/chi
	name = "chihuahua meat"
	desc = "Tastes like... well you know..."
	foodtype = RAW | MEAT | GROSS

/obj/item/reagent_containers/food/snacks/meat/slab/shepherd
	name = "shepherd meat"
	desc = "Tastes like... well you know..."
	foodtype = RAW | MEAT | GROSS

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

//doggo sprites by Arkblader

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

/obj/item/clothing/accessory/medal/frog
	name = "Зеленый значок"
	desc = "Пахнет жабами."
	icon = 'white/pieceofcrap.dmi'
	worn_icon = 'white/pieceofcrap.dmi'
	icon_state = "frog"
	custom_materials = list(/datum/material/titanium=1)

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

//KAMA THE BULLET

/datum/martial_art/shaitanka
	name = "shaitanka mma movements"
	id = MARTIALART_DAGESTAN
	var/datum/action/taa/taa = new/datum/action/taa()
	var/datum/action/shaa/shaa = new/datum/action/shaa()
	var/datum/action/progib/progib = new/datum/action/progib()
	var/datum/action/uatknut/uatknut = new/datum/action/uatknut()

/datum/martial_art/shaitanka/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	switch(streak)
		if("taa")
			streak = ""
			taa(A,D)
			return TRUE
		if("shaa")
			streak = ""
			shaa(A,D)
			return TRUE
		if("progib")
			streak = ""
			progib(A,D)
			return TRUE
		if("uatknut")
			streak = ""
			uatknut(A,D)
			return TRUE
	return FALSE

/datum/action/uatknut
	name = "Уаткнуть (с захватом) - Уаткнуть очкушника в землю."
	button_icon_state = "wrassle_slam"

/datum/action/uatknut/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>Ты не можешь уаткнуть уже уоткнутого.</span>")
		return
	owner.visible_message("<span class='danger'>[owner] собирается кого-то уаткнуть!</span>", "<b><i>Твой следующий прием - уаткнуть.</i></b>")
	var/mob/living/carbon/human/H = owner
	H.mind.martial_art.streak = "uatknut"

/datum/action/progib
	name = "Прогиб (с захватом) - кинуть чмошь на прогиб."
	button_icon_state = "wrassle_throw"

/datum/action/progib/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>Ты не можешь кинуть на прогиб лежачего.</span>")
		return
	owner.visible_message("<span class='danger'>[owner] собирается кинуть неверного!</span>", "<b><i>Твой следующий прием - кинуть на прогиб.</i></b>")
	var/mob/living/carbon/human/H = owner
	H.mind.martial_art.streak = "progib"

/datum/action/taa
	name = "ТАА - Сейчас вы уебете кого-то макасином по лицу."
	button_icon_state = "wrassle_kick"

/datum/action/taa/Trigger()

	owner.visible_message("<span class='danger'>[owner] орет ТАА!</span>", "<b><i>Сейчас вы уебете кого-то макасином по лицу.</i></b>")
	var/mob/living/carbon/human/H = owner
	H.mind.martial_art.streak = "taa"

/datum/action/shaa
	name = "ШАА - дать чапалаха уцику."
	button_icon_state = "wrassle_strike"

/datum/action/shaa/Trigger()
	owner.visible_message("<span class='danger'>[owner] готов отвесить ЧАПАЛАХ!</span>", "<b><i>Твой следующий удар - ЧАПАЛАХ.</i></b>")
	var/mob/living/carbon/human/H = owner
	H.mind.martial_art.streak = "shaa"


/datum/martial_art/shaitanka/teach(mob/living/carbon/human/H,make_temporary=0)
	if(..())
		to_chat(H, "<span class='userdanger'>ПОСАДИ ВСЕХ НА БУТЫЛКУ!</span>")
		to_chat(H, "<span class='danger'>Наведи курсор на иконку, чтобы узнать о своих приемах.</span>")
		uatknut.Grant(H)
		progib.Grant(H)
		taa.Grant(H)
		shaa.Grant(H)

/datum/martial_art/shaitanka/on_remove(mob/living/carbon/human/H)
	to_chat(H, "<span class='userdanger'>Вы чувствуете вкус аромат коровьего навоза и бутылку в анальном проходе</span>")
	uatknut.Remove(H)
	progib.Remove(H)
	taa.Remove(H)
	shaa.Remove(H)

/datum/martial_art/shaitanka/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	log_combat(A, D, "punched with shaitanka")
	..()

/datum/martial_art/shaitanka/proc/progib(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	if(!A.pulling || A.pulling != D)
		to_chat(A, "<span class='warning'>Уазьми [D] iв захват!</span>")
		return
	D.forceMove(A.loc)
	D.setDir(get_dir(D, A))

	D.Stun(80)
	D.visible_message("<span class='danger'>[A] кидает на прогиб [D]!</span>", \
					"<span class='userdanger'>Вас кидает на прогиб [A]!</span>", "<span class='hear'>Ты слышишь звук трещащих костей!</span>", null, A)
	to_chat(A, "<span class='danger'>Ты кидаешь на прогиб [D]!</span>")
	A.emote("scream")


	for (var/i = 0, i < 3, i++)
		if (A && D)
			A.pixel_y += 3
			D.pixel_y += 3
			A.setDir(turn(A.dir, 1))
			D.setDir(turn(D.dir, 1))

			switch (A.dir)
				if (NORTH)
					D.pixel_x = A.pixel_x
				if (SOUTH)
					D.pixel_x = A.pixel_x
				if (EAST)
					D.pixel_x = A.pixel_x - 8
				if (WEST)
					D.pixel_x = A.pixel_x + 8

			if (get_dist(A, D) > 1)
				to_chat(A, "<span class='warning'>[D] слишком далеко!</span>")
				A.pixel_x = 0
				A.pixel_y = 0
				D.pixel_x = 0
				D.pixel_y = 0
				return

			if (!isturf(A.loc) || !isturf(D.loc))
				to_chat(A, "<span class='warning'>ты не можешь кинуть [D] здесь!</span>")
				A.pixel_x = 0
				A.pixel_y = 0
				D.pixel_x = 0
				D.pixel_y = 0
				return
		else
			if (A)
				A.pixel_x = 0
				A.pixel_y = 0
			if (D)
				D.pixel_x = 0
				D.pixel_y = 0
			return

		sleep(1)


		D.forceMove(A.loc)

		if (A && D)

			if (get_dist(A, D) > 1)
				to_chat(A, "<span class='warning'>[D] слишком далеко!</span>")
				return

			if (!isturf(A.loc) || !isturf(D.loc))
				to_chat(A, "<span class='warning'>ты не можешь кинуть [D] здесь!</span>")
				return

			A.setDir(turn(A.dir, 1))
			var/turf/T = get_step(A, A.dir)
			var/turf/S = D.loc
			if ((S && isturf(S) && S.Exit(D)) && (T && isturf(T) && T.Enter(A)))
				D.forceMove(T)
				D.setDir(get_dir(D, A))
			else
				return

			sleep(3 SECONDS)

	if (A && D)
		// These are necessary because of the sleep call.

		D.forceMove(A.loc) // Maybe this will help with the wallthrowing bug.

		D.visible_message("<span class='danger'>[A] кидает [D]!</span>", \
						"<span class='userdanger'>You're thrown by [A]!</span>", "<span class='hear'>You hear aggressive shuffling and a loud thud!</span>", null, A)
		to_chat(A, "<span class='danger'>Ты кинул [D]!</span>")
		playsound(A.loc, "swing_hit", 50, TRUE)
		var/turf/T = get_edge_target_turf(A, A.dir)
		if (T && isturf(T))
			if (!D.stat)
				D.emote("scream")
			D.throw_at(T, 10, 4, A, TRUE, TRUE, callback = CALLBACK(D, /mob/living/carbon/human.proc/Paralyze, 20))
	log_combat(A, D, "has thrown with progib")
	return

/datum/martial_art/shaitanka/proc/FlipAnimation(mob/living/carbon/human/D)
	set waitfor = FALSE
	if (D)
		animate(D, transform = matrix(180, MATRIX_ROTATE), time = 1, loop = 0)
	sleep(15)
	if (D)
		animate(D, transform = null, time = 1, loop = 0)

/datum/martial_art/shaitanka/proc/uatknut(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	if(!A.pulling || A.pulling != D)
		to_chat(A, "<span class='warning'>Тебе надо взять [D] в захват!</span>")
		return
	D.forceMove(A.loc)
	A.setDir(get_dir(A, D))
	D.setDir(get_dir(D, A))

	D.visible_message("<span class='danger'>[A] хватает [D] up!</span>", \
					"<span class='userdanger'>Вас втыкает [A]!</span>", "<span class='hear'>You hear aggressive shuffling!</span>", null, A)
	to_chat(A, "<span class='danger'>Ты воткнул [D]!</span>")


	for (var/i = 0, i < 3, i++)
		if (A && D)
			A.pixel_y += 3
			D.pixel_y += 3
			A.setDir(turn(A.dir, 180))
			D.setDir(turn(D.dir, 180))

			switch (A.dir)
				if (NORTH)
					D.pixel_x = A.pixel_x
				if (SOUTH)
					D.pixel_x = A.pixel_x
				if (EAST)
					D.pixel_x = A.pixel_x - 8
				if (WEST)
					D.pixel_x = A.pixel_x + 8

			if (get_dist(A, D) > 1)
				to_chat(A, "<span class='warning'>[D] слишком далеко!</span>")
				A.pixel_x = 0
				A.pixel_y = 0
				D.pixel_x = 0
				D.pixel_y = 0
				return

			if (!isturf(A.loc) || !isturf(D.loc))
				to_chat(A, "<span class='warning'>Ты не можешь воткнуть [D] здесь!</span>")
				A.pixel_x = 0
				A.pixel_y = 0
				D.pixel_x = 0
				D.pixel_y = 0
				return
		else
			if (A)
				A.pixel_x = 0
				A.pixel_y = 0
			if (D)
				D.pixel_x = 0
				D.pixel_y = 0
			return

		sleep(1)

	if (A && D)
		A.pixel_x = 0
		A.pixel_y = 0
		D.pixel_x = 0
		D.pixel_y = 0

		if (get_dist(A, D) > 1)
			to_chat(A, "<span class='warning'>[D] Слишком далеко!</span>")
			return

		if (!isturf(A.loc) || !isturf(D.loc))
			to_chat(A, "<span class='warning'>Ты не можешь воткнуть [D] здесь!</span>")
			return

		D.forceMove(A.loc)

		var/fluff = "воткнул"
		switch(pick(2,3))
			if (2)
				fluff = "[fluff] по яйца"
			if (3)
				fluff = "пиздец как [fluff]"

		D.visible_message("<span class='danger'>[A] [fluff] [D]!</span>", \
						"<span class='userdanger'>Ты [fluff]ут  [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
		to_chat(A, "<span class='danger'>Ты [fluff] [D]!</span>")
		playsound(A.loc, "swing_hit", 50, TRUE)
		if (!D.stat)
			D.emote("scream")
			D.Paralyze(40)

			switch(rand(1,3))
				if (2)
					D.adjustBruteLoss(rand(20,30))
				if (3)
					D.ex_act(EXPLODE_LIGHT)
				else
					D.adjustBruteLoss(rand(10,20))
		else
			D.ex_act(EXPLODE_LIGHT)

	else
		if (A)
			A.pixel_x = 0
			A.pixel_y = 0
		if (D)
			D.pixel_x = 0
			D.pixel_y = 0


	log_combat(A, D, "body-slammed")
	return

/datum/martial_art/shaitanka/proc/CheckStrikeTurf(mob/living/carbon/human/A, turf/T)
	if (A && (T && isturf(T) && get_dist(A, T) <= 1))
		A.forceMove(T)

/datum/martial_art/shaitanka/proc/taa(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	A.emote("flip")
	var/turf/T = get_turf(A)
	if (T && isturf(T) && D && isturf(D.loc))
		for (var/i = 0, i < 4, i++)
			A.setDir(turn(A.dir, 90))

		A.forceMove(D.loc)
		addtimer(CALLBACK(src, .proc/CheckStrikeTurf, A, T), 4)


		D.visible_message("<span class='danger'>[A] дал чапалах [D]!</span>", \
						"<span class='userdanger'>Ты получил чапалахом по лицу от [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
		to_chat(A, "<span class='danger'>Ты угаманил [D]!</span>")
		D.adjustBruteLoss(rand(10,20))
		playsound(A.loc, "white/fogmann/taa.ogg", 100, TRUE)
		D.Unconscious(20)
	log_combat(A, D, "headbutted")

/datum/martial_art/shaitanka/proc/shaa(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	A.emote("scream")
	A.setDir(turn(A.dir, 90))

	D.visible_message("<span class='danger'>[A] дает с вертухи [D]!</span>", \
					"<span class='userdanger'>Ты почуствовал вкус макасинов [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>Ты угаманил [D]!</span>")
	playsound(A.loc, "white/fogmann/shaa.ogg", 100, TRUE)
	D.adjustBruteLoss(rand(10,20))

	var/turf/T = get_edge_target_turf(A, get_dir(A, get_step_away(D, A)))
	if (T && isturf(T))
		D.Paralyze(20)
		D.throw_at(T, 3, 2)
	log_combat(A, D, "roundhouse-kicked")

/datum/martial_art/shaitanka/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	log_combat(A, D, "shaitanka-disarmed")
	..()

/datum/martial_art/shaitanka/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	if(A.pulling == D)
		return 1
	A.start_pulling(D)
	D.visible_message("<span class='danger'>[A] хватает [D] на болевой!</span>", \
					"<span class='userdanger'>[A] взял тебя на болевой!</span>", "<span class='hear'>You hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, A)
	to_chat(A, "<span class='danger'>Ты взял [D] на болевой!</span>")
	D.Stun(rand(60,100))
	log_combat(A, D, "cinched")
	return 1


/obj/item/clothing/mask/boroda
	name = "борода Дагестанца"
	desc = "говорят, без неё они - никто"
	icon = 'white/pieceofcrap.dmi'
	icon_state = "boroda"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	var/datum/martial_art/shaitanka/style = new

/obj/item/clothing/mask/boroda/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_MASK)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)
	return

/obj/item/clothing/mask/boroda/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_MASK) == src)
		style.remove(H)
	return

/obj/item/clothing/mask/boroda/curse
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/mask/boroda/curse/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)

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


