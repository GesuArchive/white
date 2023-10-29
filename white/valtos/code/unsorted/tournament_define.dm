
// Для турниров

/client/proc/toggle_tournament_rules()
	set name = "ПЕРЕКЛЮЧИТЬ РЕЖИМ ТУРНИРА"
	set category = "Особенное"

	GLOB.is_tournament_rules = !GLOB.is_tournament_rules

	if(GLOB.is_tournament_rules)
		for(var/turf/open/floor/dz/fuck in world)
			var/matrix/M = matrix()
			M.Translate(0, rand(-7, 7))
			animate(fuck, transform = M, time = rand(15, 35), loop = -1, easing = SINE_EASING)
			animate(transform = null, time = rand(15, 35), easing = SINE_EASING)

		for(var/mob/M in GLOB.player_list)
			M.hud_used.update_parallax_pref(M)
			SEND_SOUND(M, sound('white/valtos/sounds/impact.ogg'))

		if(SSticker.current_state == GAME_STATE_PREGAME)
			for(var/mob/dead/new_player/player in GLOB.player_list)
				to_chat(player, "<span class=greenannounce>Ты призрак. Скоро предоставят возможность вступить в схватку.</span>")
				player.ready = FALSE
				player.make_me_an_observer(TRUE)
			SSticker.start_immediately = TRUE

	to_chat(world, "\n\n<span class='revenbignotice'><center>Турнирный режим теперь <b>[GLOB.is_tournament_rules ? "ВКЛЮЧЕН" : "ОТКЛЮЧЕН"]</b>.</center></span>\n\n")
	message_admins("[ADMIN_LOOKUPFLW(usr)] переключает режимммм турнира в положение [GLOB.is_tournament_rules ? "ВКЛ" : "ВЫКЛ"].")
	log_admin("[key_name(usr)] переключает режимммм турнира в положение [GLOB.is_tournament_rules ? "ВКЛ" : "ВЫКЛ"].")

// Турнирные предметы

/obj/item/storage/toolbox/tournament
	name = "турбокс"
	desc = "Урон от удара и броска 15."
	force = 15
	throwforce = 15

/obj/item/extinguisher/tournament
	name = "огнетуршитель"
	desc = "Урон от удара и броска 10."
	throwforce = 10
	force = 10
	can_explode = FALSE

/obj/item/extinguisher/tournament/babah
	name = "огнетуршитель-БАБАХ"
	desc = "Урон от удара и броска 10. Может бабахнуть."
	can_explode = TRUE

/obj/item/stack/tile/plasteel/tournament
	name = "турплитка"
	desc = "Урон от удара 6. От броска 10."
	force = 6
	throwforce = 10
	amount = 50

/obj/item/tank/internals/oxygen/red/tournament
	name = "турбаллон"
	desc = "Урон от удара и броска 10."

/turf/open/floor/plasteel/tournament
	var/time_to_die = 3 // 3 секунды

/turf/open/floor/plasteel/tournament/Initialize(mapload)
	. = ..()
	spawn(time_to_die SECONDS)
		ChangeTurf(/turf/open/lava/smooth)

// Аутфиты

/datum/outfit/whiterobust
	name = "Робаст"

/datum/outfit/whiterobust/ass
	name = "Ассистуха"

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/outfit/whiterobust/ass/monkey
	name = "Манкификация - Красный"
	mask = /obj/item/clothing/mask/gas/monkeymask/monkeyize
	uniform = null

/datum/outfit/whiterobust/ass/monkey/green
	name = "Манкификация - Зеленый"
	mask = /obj/item/clothing/mask/gas/monkeymask/monkeyize/green


/obj/item/clothing/mask/gas/monkeymask/monkeyize
	color = "#ff0000"
	flags_cover = 0

/obj/item/clothing/mask/gas/monkeymask/monkeyize/green
	color = "#00c814"

/obj/item/clothing/mask/gas/monkeymask/monkeyize/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!istype(user))
		return
	user.monkeyize()

/datum/outfit/whiterobust/ass/box
	name = "Ассистуха + Тулбокс"

	r_hand = /obj/item/storage/toolbox/tournament

/datum/outfit/whiterobust/ass/crowbar
	name = "Ассистуха + Плиточки"

	r_hand = /obj/item/stack/tile/plasteel/tournament
	r_pocket = /obj/item/crowbar

/datum/outfit/whiterobust/ass/m4nd4
	name = "Ассистуха + Еблострел"

	r_hand = /obj/item/gun/ballistic/rifle/boltaction/ptr
	r_pocket = /obj/item/ammo_box/a15mm

/datum/outfit/whiterobust/ass/gatling
	name = "Ассистуха + Гатлинг"

	back = /obj/item/minigunpack

/datum/outfit/whiterobust/ass/makarov
	name = "Ассистуха + Макаров"

	head = /obj/item/clothing/head/helmet/alt
	suit = /obj/item/clothing/suit/armor/bulletproof

	r_hand = /obj/item/gun/ballistic/automatic/pistol
	back = /obj/item/storage/backpack

	backpack_contents = list(/obj/item/ammo_box/magazine/m9mm = 5)

/datum/outfit/whiterobust/ass/bat
	name = "Ассистуха + Бита"

	r_hand = /obj/item/melee/baseball_bat
	l_hand = /obj/item/shield/riot/buckler

	back = /obj/item/storage/backpack

	backpack_contents = list(/obj/item/crowbar = 1)

/datum/outfit/whiterobust/ass/revolver
	name = "Ассистуха + Револьвер"

	r_hand = /obj/item/gun/ballistic/revolver

/datum/outfit/whiterobust/ass/ballon
	name = "Ассистуха + Баллон"

	r_hand = /obj/item/tank/internals/oxygen/red/tournament

/datum/outfit/whiterobust/ass/exting
	name = "Ассистуха + Огнетушитель"

	r_hand = /obj/item/extinguisher/tournament

/datum/outfit/whiterobust/ass/exting/babah
	name = "Ассистуха + Огнетушитель-БАБАХ"

	r_hand = /obj/item/extinguisher/tournament/babah

/datum/outfit/whiterobust/ass/ctf
	name = "CTF+"

	suit = /obj/item/clothing/suit/space/hardsuit/shielded/ctf
	toggle_helmet = FALSE
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	l_pocket = /obj/item/ammo_box/magazine/recharge/ctf
	r_pocket = /obj/item/ammo_box/magazine/recharge/ctf
	r_hand = /obj/item/gun/ballistic/automatic/laser/ctf

/client/proc/clicker_panel()
	set name = "Панель кликеров"
	set category = "Особенное"

	new /datum/clicker_panel(usr)

/datum/clicker_panel/New(user)
	ui_interact(user)

/datum/clicker_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ClickerPanel")
		ui.open()

/datum/clicker_panel/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/clicker_panel/ui_data(mob/user)

	var/list/data = list()

	for(var/client/C in GLOB.clients)
		if(C && C.key && C.clicklimiter)
			data["clickers"] += list(list("id" = C.key, "cps" = C.clicklimiter[SECOND_COUNT], "cpm" = C.clicklimiter[MINUTE_COUNT]))

	return data

