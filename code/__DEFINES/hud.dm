//HUD styles.  Index order defines how they are cycled in F12.
/// Standard hud
#define HUD_STYLE_STANDARD 1
/// Reduced hud (just hands and intent switcher)
#define HUD_STYLE_REDUCED 2
/// No hud (for screenshots)
#define HUD_STYLE_NOHUD 3

/// Used in show_hud(); Please ensure this is the same as the maximum index.
#define HUD_VERSIONS 3

// Consider these images/atoms as part of the UI/HUD (apart of the appearance_flags)
/// Used for progress bars and chat messages
#define APPEARANCE_UI_IGNORE_ALPHA (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|RESET_ALPHA|PIXEL_SCALE)
/// Used for HUD objects
#define APPEARANCE_UI (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE)

/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	In addition, the keywords TOP, BOTTOM, RIGHT, LEFT and CENTER can be used to represent their respective
	screen borders. TOP-1, for example, is the row just below the upper edge. Useful if you want your
	UI to scale with screen size.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

/proc/ui_hand_position(i) //values based on old hand ui positions (CENTER:-/+16,BOTTOM:5)
	var/x_off = -(!(i % 2))
	var/y_off = round((i-1) / 2)
	return"CENTER+[x_off]:16,BOTTOM+[y_off]:5"

/proc/ui_equip_position(mob/M)
	var/y_off = round((M.held_items.len-1) / 2) //values based on old equip ui position (CENTER: +/-16,BOTTOM+1:5)
	return "CENTER:-16,BOTTOM+[y_off+1]:5"

/proc/ui_swaphand_position(mob/M, which = 1) //values based on old swaphand ui positions (CENTER: +/-16,BOTTOM+1:5)
	var/x_off = which == 1 ? -1 : 0
	var/y_off = round((M.held_items.len-1) / 2)
	return "CENTER+[x_off]:16,BOTTOM+[y_off+1]:5"

//Lower left, persistent menu
#define ui_inventory "LEFT:6,BOTTOM:5"

//Middle left indicators
#define ui_lingchemdisplay "LEFT,CENTER-1:15"
#define ui_lingstingdisplay "LEFT:6,CENTER-3:11"

//Lower center, persistent menu
#define ui_sstore1 "LEFT+2:10,BOTTOM:5"
#define ui_id "CENTER-4:12,BOTTOM:5"
#define ui_belt "CENTER-3:14,BOTTOM:5"
#define ui_back "CENTER-2:14,BOTTOM:5"
#define ui_storage1 "CENTER+1:18,BOTTOM:5"
#define ui_storage2 "CENTER+2:20,BOTTOM:5"
#define ui_combo "CENTER+4:24,BOTTOM+1:7" //combo meter for martial arts

//Lower right, persistent menu
#define ui_above_movement "RIGHT-2:26,BOTTOM+1:7"
#define ui_above_intent "hud:LEFT,BOTTOM+1:26"
#define UI_PULL "hud:LEFT,BOTTOM+1:26"
#define UI_REST "hud:LEFT,BOTTOM+1:19"
#define UI_RESIST "hud:LEFT,BOTTOM+1:12"
#define UI_THROW "hud:LEFT,BOTTOM+1:5"
#define UI_DROP "hud:LEFT,BOTTOM+1:-2"
#define ui_movi "hud:LEFT,TOP-9:16"
#define ui_acti "hud:LEFT,BOTTOM"
#define ui_zonesel "hud:LEFT,TOP"
#define ui_acti_alt "RIGHT-1:28,BOTTOM:5"	//alternative intent switcher for when the interface is hidden (F12)
#define ui_crafting	"RIGHT-4:22,BOTTOM:5"
#define ui_building "RIGHT-4:22,BOTTOM:21"
#define ui_language_menu "RIGHT-4:6,BOTTOM:21"
#define ui_skill_menu "RIGHT-4:22,BOTTOM:5"

//Upper-middle right (alerts)
#define ui_alert1 "hud:LEFT,TOP-2"
#define ui_alert2 "hud:LEFT,TOP-3"
#define ui_alert3 "hud:LEFT,TOP-4"
#define ui_alert4 "hud:LEFT,TOP-5"

//Middle right (status indicators)
#define ui_healthdoll "hud:LEFT,TOP-10"
#define ui_stamina "hud:LEFT,TOP-7"
#define ui_health "hud:LEFT,TOP-7"
#define ui_blob_health "hud:LEFT,TOP-1"
#define ui_mood "hud:LEFT,TOP-6"
#define ui_spacesuit "hud:LEFT,TOP-6:26"
#define ui_fixeye "hud:LEFT,TOP-9"
#define ui_relative_temp "hud:LEFT,BOTTOM+2:1"

//Pop-up inventory
#define ui_shoes "LEFT+1:8,BOTTOM:5"
#define ui_iclothing "LEFT:6,BOTTOM+1:7"
#define ui_oclothing "LEFT+1:8,BOTTOM+1:7"
#define ui_gloves "LEFT+2:10,BOTTOM+1:7"
#define ui_glasses "LEFT:6,BOTTOM+3:11"
#define ui_mask "LEFT+1:8,BOTTOM+2:9"
#define ui_ears "LEFT+2:10,BOTTOM+2:9"
#define ui_neck "LEFT:6,BOTTOM+2:9"
#define ui_head "LEFT+1:8,BOTTOM+3:11"

//Generic living
#define ui_living_pull "hud:LEFT,BOTTOM"
#define ui_living_healthdoll "hud:LEFT,TOP-10"

//Monkeys
#define ui_monkey_head "CENTER-5:13,BOTTOM:5"
#define ui_monkey_mask "CENTER-4:14,BOTTOM:5"
#define ui_monkey_neck "CENTER-3:15,BOTTOM:5"
#define ui_monkey_back "CENTER-2:16,BOTTOM:5"

//Drones
#define ui_drone_drop "CENTER+1:18,BOTTOM:5"
#define ui_drone_pull "CENTER+2:2,BOTTOM:5"
#define ui_drone_storage "CENTER-2:14,BOTTOM:5"
#define ui_drone_head "CENTER-3:14,BOTTOM:5"

//Cyborgs
#define ui_borg_health "hud:LEFT:-3,TOP-8"
#define ui_borg_pull "hud:LEFT,TOP-6"
#define ui_borg_radio "hud:LEFT,BOTTOM+1"
#define ui_borg_intents "hud:LEFT,BOTTOM"
#define ui_borg_lamp "hud:LEFT,TOP-7"
#define ui_borg_tablet "hud:LEFT,BOTTOM+2"
#define ui_inv1 "CENTER-2:16,BOTTOM:5"
#define ui_inv2 "CENTER-1:16,BOTTOM:5"
#define ui_inv3 "CENTER:16,BOTTOM:5"
#define ui_borg_module "CENTER+1:16,BOTTOM:5"
#define ui_borg_store "CENTER+2:16,BOTTOM:5"
#define ui_borg_camera "hud:LEFT,BOTTOM+6"
#define ui_borg_alerts "hud:LEFT,BOTTOM+5"
#define ui_borg_language_menu "hud:LEFT:16,BOTTOM+3:16"

//Aliens
#define ui_alien_health "hud:LEFT,BOTTOM+7"
#define ui_alienplasmadisplay "hud:LEFT,TOP-6"
#define ui_alien_queen_finder "hud:LEFT,TOP-7"
#define ui_alien_storage_r "hud:LEFT,BOTTOM+6"
#define ui_alien_language_menu "hud:LEFT:16,BOTTOM+3:16"

//Constructs
#define ui_construct_pull "RIGHT,CENTER-2:15"
#define ui_construct_health "RIGHT,CENTER:15"

// AI
#define ui_ai_core "hud:LEFT,TOP"
#define ui_ai_camera_list "hud:LEFT,TOP-1"
#define ui_ai_track_with_camera "hud:LEFT,TOP-2"
#define ui_ai_camera_light "hud:LEFT,TOP-3"
#define ui_ai_crew_monitor "hud:LEFT,TOP-4"
#define ui_ai_crew_manifest "hud:LEFT,TOP-5"
#define ui_ai_alerts "hud:LEFT,TOP-6"
#define ui_ai_announcement "hud:LEFT,TOP-7"
#define ui_ai_shuttle "hud:LEFT,TOP-8"
#define ui_ai_state_laws "hud:LEFT,TOP-9"
#define ui_ai_mod_int "hud:LEFT,TOP-10"
#define ui_ai_take_picture "hud:LEFT,TOP-11"
#define ui_ai_view_images "hud:LEFT,TOP-12"
#define ui_ai_sensor "hud:LEFT,TOP-13"
#define ui_ai_multicam "hud:LEFT,TOP-14"
#define ui_ai_add_multicam "hud:LEFT,TOP-15"
#define ui_ai_language_menu "RIGHT:10,BOTTOM:4"

// pAI
#define ui_pai_software "hud:LEFT,TOP"
#define ui_pai_shell "hud:LEFT,TOP-1"
#define ui_pai_chassis "hud:LEFT,TOP-2"
#define ui_pai_rest "hud:LEFT,TOP-3"
#define ui_pai_light "hud:LEFT,TOP-4"
#define ui_pai_newscaster "hud:LEFT,TOP-5"
#define ui_pai_host_monitor "hud:LEFT,TOP-6"
#define ui_pai_crew_manifest "hud:LEFT,TOP-7"
#define ui_pai_state_laws "hud:LEFT,TOP-8"
#define ui_pai_mod_int "hud:LEFT,TOP-9"
#define ui_pai_internal_gps "hud:LEFT,TOP-10"
#define ui_pai_take_picture "hud:LEFT,TOP-13"
#define ui_pai_view_images "hud:LEFT,TOP-14"
#define ui_pai_radio "hud:LEFT,TOP-15"
#define ui_pai_language_menu "hud:LEFT:16,TOP-11"
#define ui_pai_navigate_menu "hud:LEFT:16,TOP-12:16"

//Ghosts
#define ui_ghost_jumptomob "hud:LEFT,BOTTOM"
#define ui_ghost_orbit "hud:LEFT,BOTTOM+1"
#define ui_ghost_reenter_corpse "hud:LEFT,BOTTOM+2"
#define ui_ghost_teleport "hud:LEFT,BOTTOM+3"
#define ui_ghost_language_menu "hud:LEFT,BOTTOM+4:16"
#define ui_ghost_pai "hud:LEFT:-16,BOTTOM+4:16"
#define ui_ghost_spawners "hud:LEFT,BOTTOM+5"
#define ui_ghost_minigames "hud:LEFT,BOTTOM+6"

//1:1 HUD layout stuff
#define UI_BOXCRAFT "hud:LEFT:16,BOTTOM+3:16"
#define UI_BOXAREA "hud:LEFT:16,BOTTOM+4:16"
#define UI_BOXLANG "hud:LEFT,BOTTOM+4:16"
#define UI_MULTIZ_UP "hud:LEFT,BOTTOM+4"
#define UI_MULTIZ_UP_AI "RIGHT:10,BOTTOM+1:12"
#define UI_MULTIZ_DOWN "hud:LEFT,BOTTOM+3:16"
#define UI_MULTIZ_DOWN_OBSERVER "hud:LEFT:16,BOTTOM+4"
#define UI_MULTIZ_DOWN_AI "RIGHT:10,BOTTOM:24"
#define UI_EMOTES "hud:LEFT:16,BOTTOM+4"
#define UI_SKILLS "hud:LEFT,BOTTOM+3"

//Blobbernauts
#define ui_blobbernaut_overmind_health "hud:LEFT,BOTTOM"

//Families
#define ui_wanted_lvl "TOP,11"

//Ammo HUD
#define ui_ammocounter "CENTER+3:18,BOTTOM:5"

//Ruination
#define ui_station_height "BOTTOM, RIGHT"

// Defines relating to action button positions

/// Whatever the base action datum thinks is best
#define SCRN_OBJ_DEFAULT "default"
/// Floating somewhere on the hud, not in any predefined place
#define SCRN_OBJ_FLOATING "floating"
/// In the list of buttons stored at the top of the screen
#define SCRN_OBJ_IN_LIST "list"

///Inserted first in the list
#define SCRN_OBJ_INSERT_FIRST "first"

// Plane group keys, used to group swaths of plane masters that need to appear in subwindows
/// The primary group, holds everything on the main window
#define PLANE_GROUP_MAIN "main"
/// A secondary group, used when a client views a generic window
#define PLANE_GROUP_POPUP_WINDOW(screen) "popup-[REF(screen)]"

/// The filter name for the hover outline
#define HOVER_OUTLINE_FILTER "hover_outline"
