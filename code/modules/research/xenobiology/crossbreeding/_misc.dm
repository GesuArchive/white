/*
Slimecrossing Items
	General items added by the slimecrossing system.
	Collected here for clarity.
*/

//Rewind camera - I'm already Burning Sepia
/obj/item/camera/rewind
	name = "старинная камера"
	desc = "Говорят, что фотография это момент, остановленный во времени."
	pictures_left = 1
	pictures_max = 1
	can_customise = FALSE
	default_picture_name = "A nostalgic picture"
	var/used = FALSE

/datum/saved_bodypart
	var/obj/item/bodypart/old_part
	var/bodypart_type
	var/brute_dam
	var/burn_dam
	var/stamina_dam

/datum/saved_bodypart/New(obj/item/bodypart/part)
	old_part = part
	bodypart_type = part.type
	brute_dam = part.brute_dam
	burn_dam = part.burn_dam
	stamina_dam = part.stamina_dam

/mob/living/carbon/proc/apply_saved_bodyparts(list/datum/saved_bodypart/parts)
	var/list/dont_chop = list()
	for(var/zone in parts)
		var/datum/saved_bodypart/saved_part = parts[zone]
		var/obj/item/bodypart/already = get_bodypart(zone)
		if(QDELETED(saved_part.old_part))
			saved_part.old_part = new saved_part.bodypart_type
		if(!already || already != saved_part.old_part)
			saved_part.old_part.replace_limb(src, TRUE)
		saved_part.old_part.heal_damage(INFINITY, INFINITY, INFINITY, null, FALSE)
		saved_part.old_part.receive_damage(saved_part.brute_dam, saved_part.burn_dam, saved_part.stamina_dam, wound_bonus=CANT_WOUND)
		dont_chop[zone] = TRUE
	for(var/_part in bodyparts)
		var/obj/item/bodypart/part = _part
		if(dont_chop[part.body_zone])
			continue
		part.drop_limb(TRUE)

/mob/living/carbon/proc/save_bodyparts()
	var/list/datum/saved_bodypart/ret = list()
	for(var/_part in bodyparts)
		var/obj/item/bodypart/part = _part
		var/datum/saved_bodypart/saved_part = new(part)

		ret[part.body_zone] = saved_part
	return ret

/obj/item/camera/rewind/afterattack(atom/target, mob/user, flag)
	if(!on || !pictures_left || !isturf(target.loc))
		return
	if(!used)//selfie time
		if(user == target)
			to_chat(user, "<span class=notice>Делаю селфи!</span>")
		else
			to_chat(user, "<span class=notice>Сфоткался с [target]!</span>")
			to_chat(target, "<span class=notice>[user] сфоткался с тобой!</span>")
		to_chat(target, "<span class=notice>Запомню этот миг навсегда!</span>")

		used = TRUE
		target.AddComponent(/datum/component/dejavu, 2)
	. = ..()



//Timefreeze camera - Old Burning Sepia result. Kept in case admins want to spawn it
/obj/item/camera/timefreeze
	name = "старинная камера"
	desc = "Говорят, что фотография похожа на момент, остановленный во времени."
	pictures_left = 1
	pictures_max = 1
	var/used = FALSE

/obj/item/camera/timefreeze/afterattack(atom/target, mob/user, flag)
	if(!on || !pictures_left || !isturf(target.loc))
		return
	if(!used) //refilling the film does not refill the timestop
		new /obj/effect/timestop(get_turf(target), 2, 50, list(user))
		used = TRUE
		desc = "Эта камера видала лучшие дни."
	. = ..()

//Hypercharged slime cell - Charged Yellow
/obj/item/stock_parts/cell/high/slime_hypercharged
	name = "сверхзаряженное ядро ??слизи"
	desc = "Заряженный экстракт желтой слизи, наполненный плазмой. К этому больно прикасаться."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "yellow slime extract"
	rating = 7
	custom_materials = null
	maxcharge = 50000
	chargerate = 2500

//Barrier cube - Chilling Grey
/obj/item/barriercube
	name = "барьерный куб"
	desc = "Сжатый куб слизи. Когда выжимается, вырастает до огромных размеров!"
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "barriercube"
	w_class = WEIGHT_CLASS_TINY

/obj/item/barriercube/attack_self(mob/user)
	if(locate(/obj/structure/barricade/slime) in get_turf(loc))
		to_chat(user, span_warning("Нельзя разместить более одного барьера в одном месте!"))
		return
	to_chat(user, span_notice("Сжимаю [src]."))
	var/obj/B = new /obj/structure/barricade/slime(get_turf(loc))
	B.visible_message(span_warning("[capitalize(src.name)] внезапно разрастается в огромный желейный барьер!"))
	qdel(src)

//Slime barricade - Chilling Grey
/obj/structure/barricade/slime
	name = "желейный барьер"
	desc = "Огромный кусок серой слизи. В нём могут застрять пули."
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "slimebarrier"
	proj_pass_rate = 40
	max_integrity = 60

//Melting Gel Wall - Chilling Metal
/obj/effect/forcefield/slimewall
	name = "затвердевший гель"
	desc = "Масса затвердевшей слизи - совершенно непроницаемая, но она тает!"
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "slimebarrier_thick"
	can_atmos_pass = ATMOS_PASS_NO
	opacity = TRUE
	timeleft = 100

//Rainbow barrier - Chilling Rainbow
/obj/effect/forcefield/slimewall/rainbow
	name = "радужный барьер"
	desc = "Несмотря на призывы других, вам, вероятно, не стоит пробовать это."
	icon_state = "rainbowbarrier"

//Ice stasis block - Chilling Dark Blue
/obj/structure/ice_stasis
	name = "глыба льда"
	desc = "Массивная глыба льда. Можно увидеть что-то похожее на человека внутри."
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "frozen"
	density = TRUE
	max_integrity = 100
	armor = list(MELEE = 30, BULLET = 50, LASER = -50, ENERGY = -50, BOMB = 0, BIO = 100, RAD = 100, FIRE = -80, ACID = 30)

/obj/structure/ice_stasis/Initialize(mapload)
	. = ..()
	playsound(src, 'sound/magic/ethereal_exit.ogg', 50, TRUE)

/obj/structure/ice_stasis/Destroy()
	for(var/atom/movable/M in contents)
		M.forceMove(loc)
	playsound(src, 'sound/effects/glassbr3.ogg', 50, TRUE)
	return ..()

//Gold capture device - Chilling Gold
/obj/item/capturedevice
	name = "золотое устройство захвата"
	desc = "Устройство яйцевидной формы использующее технологию блюспейс. Используется для хранения нечеловеческих существ. Не может поймать их всех - помещается только одно существо."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "capturedevice"

/obj/item/capturedevice/attack(mob/living/M, mob/user)
	if(length(contents))
		to_chat(user, span_warning("Внутри устройства уже что-то есть."))
		return
	if(!isanimal(M))
		to_chat(user, span_warning("Устройство захвата работает только на простых существ."))
		return
	if(M.mind)
		to_chat(user, span_notice("Предлагаю устройство [M]."))
		if(tgui_alert(M, "Would you like to enter [user]'s capture device?", "Gold Capture Device", list("Yes", "No")) == "Yes")
			if(user.canUseTopic(src, BE_CLOSE) && user.canUseTopic(M, BE_CLOSE))
				to_chat(user, span_notice("Помещаю [M] в устройство захвата."))
				to_chat(M, span_notice("Мир вокруг тебя искривляется и внезапно ты оказываешься в бесконечной пустоте с летающим окном наружу перед тобой."))
				store(M, user)
			else
				to_chat(user, span_warning("Был слишком далеко от [M]."))
				to_chat(M, span_warning("Был слишком далеко от [user]."))
		else
			to_chat(user, span_warning("[M] отказался заходить в устройство."))
			return
	else
		if(istype(M, /mob/living/simple_animal/hostile) && !("neutral" in M.faction))
			to_chat(user, span_warning("Это существо слишком агрессивное, чтобы быть пойманным."))
			return
	to_chat(user, span_notice("Поместил [M] в устройство захвата."))
	store(M)

/obj/item/capturedevice/attack_self(mob/user)
	if(contents.len)
		to_chat(user, span_notice("Открыл устройство захвата!"))
		release()
	else
		to_chat(user, span_warning("Устройство пустое..."))

/obj/item/capturedevice/proc/store(mob/living/M)
	M.forceMove(src)

/obj/item/capturedevice/proc/release()
	for(var/atom/movable/M in contents)
		M.forceMove(get_turf(loc))
