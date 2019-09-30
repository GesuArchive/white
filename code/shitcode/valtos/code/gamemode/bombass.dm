/area/awaymission/bombass
	name = "bombass"
	icon_state = "awaycontent6"
	requires_power = FALSE
	noteleport = TRUE
	has_gravity = TRUE
	mood_bonus = 150
	mood_message = "<span class='nicegreen'>СЕГОДНЯ Я УМРУ!\n</span>"

/obj/structure/closet/bombcloset/bombsquad
	name = "\improper BOMBSQUAD closet"
	anchored = TRUE

/obj/structure/closet/bombcloset/bombsquad/PopulateContents()
	..()
	new /obj/item/clothing/suit/bomb_suit(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/head/bomb_hood/bombsquad(src)

/obj/item/clothing/head/bomb_hood/bombsquad
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR


/obj/effect/landmark/start/bombsquad
	name = "Defender"
	icon_state = "Assistant"

/obj/effect/landmark/start/bombscmd
	name = "Defend Commander"
	icon_state = "Chaplain"

/datum/outfit/job/bombsquad
	name = "BombMeat uniform"

	jobtype = /datum/job/bombmeat
	id = /obj/item/card/id

/datum/job/bombmeat
	title = "Defender"
	faction = "Assault"

	total_positions = 32
	spawn_positions = 32
	current_positions = 0
	selection_color = "#ff0000"
	minimal_player_age = 0
	outfit = /datum/outfit/job/bombsquad


	display_order = JOB_DISPLAY_ORDER_DEFAULT


//////////////////////////////////////////////////////////////////////

/datum/game_mode/assault
	name = "assault"
	probability = 3
	report_type = "assault"
	required_players = 30
	maximum_players = -1
	required_enemies = 1
	recommended_enemies = 1
	antag_flag = ROLE_TRAITOR
	enemy_minimum_age = 0
	var/started = FALSE

	announce_span = "assault"
	announce_text = "Сегодня будет очень жарко."

/datum/game_mode/assault/pre_setup()
	SSjob.SetupOccupations("Assault")
	return 1

/datum/game_mode/assault/post_setup()
	load_new_z_level("_maps/RandomZLevels/bombass.dmm", "Assault Mission")
	. = ..()

/datum/game_mode/assault/process()
	if ((world.time-SSticker.round_start_time) > 18000 && !started)
		started = TRUE
		to_chat(world, "<span class='warning'>Вы ощущаете себя готовым к бою...</span>")

