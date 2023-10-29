//max channel is 1024. Only go lower from here, because byond tends to pick the first availiable channel to play sounds on
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023
#define CHANNEL_VOX 1022
#define CHANNEL_JUKEBOX 1021
#define CHANNEL_JUSTICAR_ARK 1020
#define CHANNEL_HEARTBEAT 1019 //sound channel for heartbeats
#define CHANNEL_AMBIENCE 1018
#define CHANNEL_AMBIGEN 1017
#define CHANNEL_BUZZ 1016
#define CHANNEL_BICYCLE 1015
#define CHANNEL_CUSTOM_JUKEBOX 1014
#define CHANNEL_TTS_ANNOUNCER 1013
#define CHANNEL_BATTLETENSION 1012
#define CHANNEL_RUINATION_OST 1011
#define CHANNEL_VIOLENCE_MODE 1010
#define CHANNEL_HEV 1009
#define CHANNEL_BACKROOMS_HUM 1008
#define CHANNEL_MBOX 1007
#define CHANNEL_TTS_AVAILABLE 1006
#define CHANNEL_BOOMBOX_AVAILABLE 800
#define CHANNEL_WIND_AVAILABLE 780
#define CHANNEL_HIGHEST_AVAILABLE 770

///Default range of a sound.
#define SOUND_RANGE 17
#define MEDIUM_RANGE_SOUND_EXTRARANGE -5
///default extra range for sounds considered to be quieter
#define SHORT_RANGE_SOUND_EXTRARANGE -9
///The range deducted from sound range for things that are considered silent / sneaky
#define SILENCED_SOUND_EXTRARANGE -11
///Percentage of sound's range where no falloff is applied
#define SOUND_DEFAULT_FALLOFF_DISTANCE 1 //For a normal sound this would be 1 tile of no falloff
///The default exponent of sound falloff
#define SOUND_FALLOFF_EXPONENT 6

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

#define MAX_INSTRUMENT_CHANNELS (128 * 6)

#define SOUND_MINIMUM_PRESSURE 10


//Ambience types

#define GENERIC list(\
	'sound/ambience/white/ambi1.ogg',\
	'sound/ambience/white/ambi2.ogg',\
	'sound/ambience/white/ambi3.ogg',\
	'sound/ambience/white/ambi4.ogg',\
	'sound/ambience/white/ambi5.ogg',\
	'sound/ambience/white/ambi6.ogg',\
	'sound/ambience/white/ambi7.ogg',\
	'sound/ambience/white/ambi8.ogg',\
	'sound/ambience/white/ambi9.ogg',\
	'sound/ambience/white/ambi10.ogg',\
	'sound/ambience/white/ambi11.ogg',\
	'sound/ambience/white/ambi12.ogg',\
	'sound/ambience/white/ambi13.ogg',\
	'sound/ambience/white/ambi14.ogg',\
	'sound/ambience/white/ambi15.ogg',\
	'sound/ambience/white/ambi16.ogg')

#define HOLY list('sound/ambience/white/ambichurch1.ogg')

#define HIGHSEC list(\
	'sound/ambience/white/ambidanger1.ogg',\
	'sound/ambience/white/ambidanger2.ogg',\
	'sound/ambience/white/ambidanger3.ogg',\
	'sound/ambience/white/ambidanger4.ogg',\
	'sound/ambience/white/ambidanger5.ogg',\
	'sound/ambience/white/ambidanger6.ogg',\
	'sound/ambience/white/ambidanger7.ogg',\
	'sound/ambience/white/ambidanger8.ogg')

#define RUINS list(\
	'sound/ambience/white/ambidanger1.ogg',\
	'sound/ambience/white/ambidanger2.ogg',\
	'sound/ambience/white/ambi1.ogg',\
	'sound/ambience/white/ambi3.ogg')

#define ENGINEERING list(\
	'sound/ambience/white/ambieng1.ogg',\
	'sound/ambience/white/ambieng2.ogg',\
	'sound/ambience/white/ambieng3.ogg',\
	'sound/ambience/white/ambieng4.ogg',\
	'sound/ambience/white/ambieng5.ogg',\
	'sound/ambience/white/ambieng6.ogg',\
	'sound/ambience/white/ambieng7.ogg',\
	'sound/ambience/white/ambieng8.ogg')

#define MINING list(\
	'sound/ambience/white/ambimine1.ogg',\
	'sound/ambience/white/ambimine2.ogg',\
	'sound/ambience/white/ambimine3.ogg',\
	'sound/ambience/white/ambimine4.ogg',\
	'sound/ambience/white/ambimine5.ogg',\
	'sound/ambience/white/ambimine6.ogg',\
	'sound/ambience/white/ambimine7.ogg',\
	'sound/ambience/white/ambimine8.ogg')

#define MEDICAL list(\
	'sound/ambience/white/ambimed1.ogg',\
	'sound/ambience/white/ambimed2.ogg',\
	'sound/ambience/white/ambimed3.ogg')

#define SPOOKY list(\
	'sound/ambience/white/ambimo1.ogg',\
	'white/valtos/sounds/prison/amb7.ogg')

#define SPACE list(\
	'sound/ambience/white/ambispace1.ogg',\
	'sound/ambience/white/ambispace2.ogg',\
	'sound/ambience/white/ambispace3.ogg',\
	'sound/ambience/white/ambispace4.ogg',\
	'sound/ambience/white/ambispace5.ogg',\
	'sound/ambience/white/ambispace6.ogg',\
	'sound/ambience/white/ambispace7.ogg')

#define MAINTENANCE list(\
	'sound/ambience/white/ambimaint1.ogg',\
	'sound/ambience/white/ambimaint2.ogg',\
	'sound/ambience/white/ambimaint4.ogg',\
	'sound/ambience/white/ambimaint5.ogg',\
	'sound/ambience/white/ambimaint6.ogg',\
	'sound/ambience/white/ambimaint7.ogg')

#define AWAY_MISSION list(\
	'sound/ambience/white/ambidanger2.ogg',\
	'sound/ambience/white/ambidanger3.ogg')

#define YOHEI list('sound/ambience/white/ambiyohei.ogg')

#define REEBE list(\
	'sound/ambience/ambireebe1.ogg',\
	'sound/ambience/ambireebe2.ogg',\
	'sound/ambience/ambireebe3.ogg')


#define CREEPY_SOUNDS list(\
	'sound/effects/ghost.ogg',\
	'sound/effects/ghost2.ogg',\
	'sound/effects/heart_beat.ogg',\
	'sound/effects/screech.ogg',\
	'sound/hallucinations/behind_you1.ogg',\
	'sound/hallucinations/behind_you2.ogg',\
	'sound/hallucinations/far_noise.ogg',\
	'sound/hallucinations/growl1.ogg',\
	'sound/hallucinations/growl2.ogg',\
	'sound/hallucinations/growl3.ogg',\
	'sound/hallucinations/im_here1.ogg',\
	'sound/hallucinations/im_here2.ogg',\
	'sound/hallucinations/i_see_you1.ogg',\
	'sound/hallucinations/i_see_you2.ogg',\
	'sound/hallucinations/look_up1.ogg',\
	'sound/hallucinations/look_up2.ogg',\
	'sound/hallucinations/over_here1.ogg',\
	'sound/hallucinations/over_here2.ogg',\
	'sound/hallucinations/over_here3.ogg',\
	'sound/hallucinations/turn_around1.ogg',\
	'sound/hallucinations/turn_around2.ogg',\
	'sound/hallucinations/veryfar_noise.ogg',\
	'sound/hallucinations/wail.ogg')

#define SOVIET_AMB list(\
	'white/valtos/sounds/prison/amb6.ogg',\
	'white/valtos/sounds/prison/amb7.ogg',\
	'white/valtos/sounds/prison/amb8.ogg')

#define RANGERS_AMB list(\
	'white/valtos/sounds/rangers/1.ogg',\
	'white/valtos/sounds/rangers/2.ogg',\
	'white/valtos/sounds/rangers/3.ogg',\
	'white/valtos/sounds/rangers/4.ogg',\
	'white/valtos/sounds/rangers/5.ogg')

#define SOVIET_AMB_CAVES list('white/valtos/sounds/prison/ambout1.ogg')

#define SCARLET_DAWN_AMBIENT list('white/valtos/sounds/dz/ambidawn.ogg')

#define GENERIC_AMBIGEN list(\
	'sound/ambience/ambigen1.ogg',\
	'sound/ambience/ambigen3.ogg',\
	'sound/ambience/ambigen4.ogg',\
	'sound/ambience/ambigen5.ogg',\
	'sound/ambience/ambigen6.ogg',\
	'sound/ambience/ambigen7.ogg',\
	'sound/ambience/ambigen8.ogg',\
	'sound/ambience/ambigen9.ogg',\
	'sound/ambience/ambigen10.ogg',\
	'sound/ambience/ambigen11.ogg',\
	'sound/ambience/ambigen12.ogg',\
	'sound/ambience/ambigen14.ogg',\
	'sound/ambience/ambigen15.ogg',\
	'sound/ambience/ambigen16.ogg')

#define TURBOLIFT list(\
	'white/jhnazar/sound/effects/lift/elevatormusic.ogg',\
	'white/jhnazar/sound/effects/turbolift/elevatormusic1.ogg',\
	'white/jhnazar/sound/effects/turbolift/elevatormusic2.ogg')

#define FAR_EXPLOSION_SOUNDS list(\
	'white/valtos/sounds/farexplosion/1.ogg',\
	'white/valtos/sounds/farexplosion/2.ogg',\
	'white/valtos/sounds/farexplosion/3.ogg',\
	'white/valtos/sounds/farexplosion/4.ogg',\
	'white/valtos/sounds/farexplosion/5.ogg',\
	'white/valtos/sounds/farexplosion/6.ogg',\
	'white/valtos/sounds/farexplosion/7.ogg',\
	'white/valtos/sounds/farexplosion/8.ogg',\
	'white/valtos/sounds/farexplosion/9.ogg',\
	'sound/effects/explosionfar.ogg')

#define WATER_FLOW_MINI list(\
	'white/valtos/sounds/voda1.ogg',\
	'white/valtos/sounds/voda2.ogg',\
	'white/valtos/sounds/voda3.ogg',\
	'white/valtos/sounds/voda4.ogg',\
	'white/valtos/sounds/voda5.ogg')

#define RANDOM_DEEPH_SOUNDS list(\
	'white/valtos/sounds/lifeweb/deeph1.ogg',\
	'white/valtos/sounds/lifeweb/deeph2.ogg',\
	'white/valtos/sounds/lifeweb/deeph3.ogg',\
	'white/valtos/sounds/lifeweb/deeph4.ogg',\
	'white/valtos/sounds/lifeweb/deeph5.ogg',\
	'white/valtos/sounds/lifeweb/deeph6.ogg')

#define RANDOM_DREAM_SOUNDS list(\
	'white/valtos/sounds/lifeweb/dream1.ogg',\
	'white/valtos/sounds/lifeweb/dream2.ogg',\
	'white/valtos/sounds/lifeweb/dream3.ogg',\
	'white/valtos/sounds/lifeweb/dream4.ogg',\
	'white/valtos/sounds/lifeweb/dream5.ogg')

// how dumb i am
#define RANDOM_DREAMER_SOUNDS list(\
	'white/valtos/sounds/lifeweb/hall1.ogg',\
	'white/valtos/sounds/lifeweb/hall2.ogg',\
	'white/valtos/sounds/lifeweb/hall3.ogg',\
	'white/valtos/sounds/lifeweb/hall4.ogg',\
	'white/valtos/sounds/lifeweb/hall5.ogg',\
	'white/valtos/sounds/lifeweb/hall6.ogg',\
	'white/valtos/sounds/lifeweb/hall7.ogg',\
	'white/valtos/sounds/lifeweb/hall8.ogg',\
	'white/valtos/sounds/lifeweb/hall9.ogg',\
	'white/valtos/sounds/lifeweb/hall10.ogg',\
	'white/valtos/sounds/lifeweb/hall11.ogg',\
	'white/valtos/sounds/lifeweb/hall12.ogg',\
	'white/valtos/sounds/lifeweb/hall13.ogg',\
	'white/valtos/sounds/lifeweb/hall14.ogg',\
	'white/valtos/sounds/lifeweb/hall15.ogg',\
	'white/valtos/sounds/lifeweb/hall16.ogg',\
	'white/valtos/sounds/lifeweb/hall17.ogg',\
	'white/valtos/sounds/lifeweb/hall18.ogg',\
	'white/valtos/sounds/lifeweb/hall19.ogg',\
	'white/valtos/sounds/lifeweb/hall20.ogg',\
	'white/valtos/sounds/lifeweb/hall21.ogg',\
	'white/valtos/sounds/lifeweb/hall22.ogg')


#define INTERACTION_SOUND_RANGE_MODIFIER -3
#define EQUIP_SOUND_VOLUME 30
#define PICKUP_SOUND_VOLUME 15
#define DROP_SOUND_VOLUME 20
#define YEET_SOUND_VOLUME 90

#define AMBIENCE_GENERIC "generic"
#define AMBIENCE_HOLY "holy"
#define AMBIENCE_DANGER "danger"
#define AMBIENCE_RUINS "ruins"
#define AMBIENCE_ENGI "engi"
#define AMBIENCE_MINING "mining"
#define AMBIENCE_MEDICAL "med"
#define AMBIENCE_SPOOKY "spooky"
#define AMBIENCE_SPACE "space"
#define AMBIENCE_MAINT "maint"
#define AMBIENCE_AWAY "away"
#define AMBIENCE_REEBE "reebe" //unused
#define AMBIENCE_CREEPY "creepy" //not to be confused with spooky
#define AMBIENCE_TURBOLIFT "turbolift"
#define AMBIENCE_NONE "none"

//default byond sound environments
#define SOUND_ENVIRONMENT_NONE -1
#define SOUND_ENVIRONMENT_GENERIC 0
#define SOUND_ENVIRONMENT_PADDED_CELL 1
#define SOUND_ENVIRONMENT_ROOM 2
#define SOUND_ENVIRONMENT_BATHROOM 3
#define SOUND_ENVIRONMENT_LIVINGROOM 4
#define SOUND_ENVIRONMENT_STONEROOM 5
#define SOUND_ENVIRONMENT_AUDITORIUM 6
#define SOUND_ENVIRONMENT_CONCERT_HALL 7
#define SOUND_ENVIRONMENT_CAVE 8
#define SOUND_ENVIRONMENT_ARENA 9
#define SOUND_ENVIRONMENT_HANGAR 10
#define SOUND_ENVIRONMENT_CARPETED_HALLWAY 11
#define SOUND_ENVIRONMENT_HALLWAY 12
#define SOUND_ENVIRONMENT_STONE_CORRIDOR 13
#define SOUND_ENVIRONMENT_ALLEY 14
#define SOUND_ENVIRONMENT_FOREST 15
#define SOUND_ENVIRONMENT_CITY 16
#define SOUND_ENVIRONMENT_MOUNTAINS 17
#define SOUND_ENVIRONMENT_QUARRY 18
#define SOUND_ENVIRONMENT_PLAIN 19
#define SOUND_ENVIRONMENT_PARKING_LOT 20
#define SOUND_ENVIRONMENT_SEWER_PIPE 21
#define SOUND_ENVIRONMENT_UNDERWATER 22
#define SOUND_ENVIRONMENT_DRUGGED 23
#define SOUND_ENVIRONMENT_DIZZY 24
#define SOUND_ENVIRONMENT_PSYCHOTIC 25
//If we ever make custom ones add them here
#define SOUND_ENVIROMENT_PHASED list(1.8, 0.5, -1000, -4000, 0, 5, 0.1, 1, -15500, 0.007, 2000, 0.05, 0.25, 1, 1.18, 0.348, -5, 2000, 250, 0, 3, 100, 63)

//"sound areas": easy way of keeping different types of areas consistent.
#define SOUND_AREA_STANDARD_STATION SOUND_ENVIRONMENT_PARKING_LOT
#define SOUND_AREA_LARGE_ENCLOSED SOUND_ENVIRONMENT_QUARRY
#define SOUND_AREA_SMALL_ENCLOSED SOUND_ENVIRONMENT_BATHROOM
#define SOUND_AREA_TUNNEL_ENCLOSED SOUND_ENVIRONMENT_STONEROOM
#define SOUND_AREA_LARGE_SOFTFLOOR SOUND_ENVIRONMENT_CARPETED_HALLWAY
#define SOUND_AREA_MEDIUM_SOFTFLOOR SOUND_ENVIRONMENT_LIVINGROOM
#define SOUND_AREA_SMALL_SOFTFLOOR SOUND_ENVIRONMENT_ROOM
#define SOUND_AREA_ASTEROID SOUND_ENVIRONMENT_CAVE
#define SOUND_AREA_SPACE SOUND_ENVIRONMENT_UNDERWATER
#define SOUND_AREA_LAVALAND SOUND_ENVIRONMENT_MOUNTAINS
#define SOUND_AREA_ICEMOON SOUND_ENVIRONMENT_CAVE
#define SOUND_AREA_WOODFLOOR SOUND_ENVIRONMENT_CITY


///Announcer audio keys
#define ANNOUNCER_COMMANDREPORT "announcer_commandreport"
#define ANNOUNCER_AIMALF "announcer_aimalf"
#define ANNOUNCER_ALIENS "announcer_aliens"
#define ANNOUNCER_ANIMES "announcer_animes"
#define ANNOUNCER_GRANOMALIES "announcer_granomalies"
#define ANNOUNCER_INTERCEPT "announcer_intercept"
#define ANNOUNCER_IONSTORM "announcer_ionstorm"
#define ANNOUNCER_METEORS "announcer_meteors"
#define ANNOUNCER_OUTBREAK5 "announcer_outbreak5"
#define ANNOUNCER_OUTBREAK7 "announcer_outbreak7"
#define ANNOUNCER_POWEROFF "announcer_poweroff"
#define ANNOUNCER_POWERON "announcer_poweron"
#define ANNOUNCER_RADIATION "announcer_radiation"
#define ANNOUNCER_SHUTTLECALLED "announcer_shuttlecalled"
#define ANNOUNCER_SHUTTLEDOCK "announcer_shuttledock"
#define ANNOUNCER_SHUTTLERECALLED "announcer_shuttlerecalled"
#define ANNOUNCER_SPANOMALIES "announcer_spanomalies"
#define ANNOUNCER_WAR "announcer_war"

/// Global list of all of our announcer keys.
GLOBAL_LIST_INIT(announcer_keys, list(
	ANNOUNCER_COMMANDREPORT,
	ANNOUNCER_AIMALF,
	ANNOUNCER_ALIENS,
	ANNOUNCER_ANIMES,
	ANNOUNCER_GRANOMALIES,
	ANNOUNCER_INTERCEPT,
	ANNOUNCER_IONSTORM,
	ANNOUNCER_METEORS,
	ANNOUNCER_OUTBREAK5,
	ANNOUNCER_OUTBREAK7,
	ANNOUNCER_POWEROFF,
	ANNOUNCER_POWERON,
	ANNOUNCER_RADIATION,
	ANNOUNCER_SHUTTLECALLED,
	ANNOUNCER_SHUTTLEDOCK,
	ANNOUNCER_SHUTTLERECALLED,
	ANNOUNCER_SPANOMALIES,
	ANNOUNCER_WAR,
))

/// List of all of our sound keys.
#define SFX_BODYFALL "bodyfall"
#define SFX_BULLET_MISS "bullet_miss"
#define SFX_CAN_OPEN "can_open"
#define SFX_CLOWN_STEP "clown_step"
#define SFX_DESECRATION "desecration"
#define SFX_EXPLOSION "explosion"
#define SFX_EXPLOSION_CREAKING "explosion_creaking"
#define SFX_HISS "hiss"
#define SFX_HONKBOT_E "honkbot_e"
#define SFX_HULL_CREAKING "hull_creaking"
#define SFX_HYPERTORUS_CALM "hypertorus_calm"
#define SFX_HYPERTORUS_MELTING "hypertorus_melting"
#define SFX_IM_HERE "im_here"
#define SFX_LAW "law"
#define SFX_PAGE_TURN "page_turn"
#define SFX_PUNCH "punch"
#define SFX_REVOLVER_SPIN "revolver_spin"
#define SFX_RICOCHET "ricochet"
#define SFX_RUSTLE "rustle"
#define SFX_SHATTER "shatter"
#define SFX_SM_CALM "sm_calm"
#define SFX_SM_DELAM "sm_delam"
#define SFX_SPARKS "sparks"
#define SFX_SUIT_STEP "suit_step"
#define SFX_SWING_HIT "swing_hit"
#define SFX_TERMINAL_TYPE "terminal_type"
#define SFX_WARPSPEED "warpspeed"
#define SFX_CRUNCHY_BUSH_WHACK "crunchy_bush_whack"
#define SFX_TREE_CHOP "tree_chop"
#define SFX_ROCK_TAP "rock_tap"
