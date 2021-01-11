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
#define CHANNEL_TTS_AVAILABLE 1011
#define CHANNEL_BOOMBOX_AVAILABLE 800
#define CHANNEL_HIGHEST_AVAILABLE 780

///Default range of a sound.
#define SOUND_RANGE 17
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

#define GENERIC list(	  'sound/ambience/white/ambi2.ogg',\
						  'sound/ambience/white/ambi3.ogg',\
						  'sound/ambience/white/ambi4.ogg',\
						  'sound/ambience/white/ambi5.ogg',\
						  'sound/ambience/white/ambi6.ogg',\
					 	  'sound/ambience/white/ambi7.ogg',\
						  'sound/ambience/white/ambi8.ogg',\
						  'sound/ambience/white/ambi9.ogg',\
					 	  'sound/ambience/white/ambi10.ogg',\
						  'sound/ambience/white/ambi12.ogg',\
						  'sound/ambience/white/ambi13.ogg',\
						  'white/valtos/sounds/prison/amb8.ogg')

#define HOLY list(		  'sound/ambience/white/ambichurch1.ogg')

#define HIGHSEC list(	  'sound/ambience/white/ambidanger1.ogg',\
						  'sound/ambience/white/ambidanger2.ogg',\
						  'sound/ambience/white/ambidanger3.ogg')

#define RUINS list(		  'sound/ambience/white/ambidanger1.ogg',\
						  'sound/ambience/white/ambidanger2.ogg',\
						  'sound/ambience/white/ambi1.ogg',\
						  'sound/ambience/white/ambi11.ogg',\
						  'sound/ambience/white/ambi3.ogg')

#define ENGINEERING list( 'sound/ambience/white/ambieng1.ogg',\
						  'sound/ambience/white/ambidanger2.ogg')

#define MINING list(	  'sound/ambience/white/ambidanger1.ogg',\
						  'sound/ambience/white/ambidanger2.ogg',\
						  'sound/ambience/white/ambi12.ogg',\
						  'white/valtos/sounds/prison/amb6.ogg')

#define MEDICAL list(	  'sound/ambience/white/ambimed1.ogg',\
						  'sound/ambience/white/ambimed2.ogg')

#define SPOOKY list(	  'sound/ambience/white/ambimo1.ogg',\
						  'white/valtos/sounds/prison/amb7.ogg')

#define SPACE list(		  'sound/ambience/white/ambispace1.ogg',\
						  'sound/ambience/white/ambispace2.ogg',\
						  'sound/ambience/white/ambispace3.ogg',\
				   		  'sound/ambience/white/ambispace4.ogg') // Source - https://vk.com/wall-180293907_321

#define MAINTENANCE list( 'sound/ambience/white/ambimaint1.ogg',\
						  'sound/ambience/white/ambimaint2.ogg')

#define AWAY_MISSION list('sound/ambience/white/ambidanger2.ogg',\
						  'sound/ambience/white/ambidanger3.ogg',\
						  'sound/ambience/white/ambi12.ogg')

#define REEBE list(		  'sound/ambience/ambireebe1.ogg',\
						  'sound/ambience/ambireebe2.ogg',\
						  'sound/ambience/ambireebe3.ogg')

#define CREEPY_SOUNDS list('sound/effects/ghost.ogg',\
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

#define SOVIET_AMB list(   'white/valtos/sounds/prison/amb6.ogg',\
						   'white/valtos/sounds/prison/amb7.ogg',\
						   'white/valtos/sounds/prison/amb8.ogg')

#define SOVIET_AMB_CAVES list('white/valtos/sounds/prison/ambout1.ogg')

#define SCARLET_DAWN_AMBIENT list('white/valtos/sounds/dz/ambidawn.ogg')

#define GENERIC_AMBIGEN list('sound/ambience/ambigen1.ogg',\
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
						   'sound/ambience/ambigen15.ogg')

#define TURBOLIFT list(    'white/jhnazar/sound/effects/lift/elevatormusic.ogg',\
						   'white/jhnazar/sound/effects/turbolift/elevatormusic1.ogg',\
						   'white/jhnazar/sound/effects/turbolift/elevatormusic2.ogg')

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
