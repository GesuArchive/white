// ROLE PREFERENCES
#define ROLE_BLOODSUCKER			"Bloodsucker"
#define ROLE_MONSTERHUNTER			"Monster Hunter"

// ANTAGS
#define ANTAG_DATUM_BLOODSUCKER			/datum/antagonist/bloodsucker
#define ANTAG_DATUM_VASSAL				/datum/antagonist/vassal
#define ANTAG_DATUM_HUNTER				/datum/antagonist/vamphunter

// TRAITS
#define TRAIT_COLDBLOODED		"coldblooded"	// Your body is literal room temperature. Does not make you immune to the temp.
#define TRAIT_NONATURALHEAL		"nonaturalheal"	// Only Admins can heal you. NOTHING else does it unless it's given the god tag.
#define TRAIT_NORUNNING			"norunning"		// You walk!
#define TRAIT_NOMARROW			"nomarrow"		// You don't make blood.
#define TRAIT_NOPULSE			"nopulse"		// You don't pump blood.

// HUD
//#define ANTAG_HUD_BLOODSUCKER		25  // MOVED TO atom_hud.dm, so we can get a conflict error and update if anything changes. // Check atom_hud.dm to see what the current top number is.

// BLOODSUCKER
#define BLOODSUCKER_LEVEL_TO_EMBRACE	3
#define BLOODSUCKER_FRENZY_TIME	25		// How long the vamp stays in frenzy.
#define BLOODSUCKER_FRENZY_OUT_TIME	300	// How long the vamp goes back into frenzy.
#define BLOODSUCKER_STARVE_VOLUME	5	// Amount of blood, below which a Vamp is at risk of frenzy.

// RECIPES
//#define CAT_STRUCTURE	"Structures"

// MARTIAL ARTS
#define MARTIALART_HUNTER "hunter-fu"

#define TIME_BLOODSUCKER_NIGHT	720 		// 12 minutes
#define TIME_BLOODSUCKER_DAY_WARN	90 		// 1.5 minutes
#define TIME_BLOODSUCKER_DAY_FINAL_WARN	25 	// 25 sec
#define TIME_BLOODSUCKER_DAY	60 			// 1.5 minutes // 10 is a second, 600 is a minute.
#define TIME_BLOODSUCKER_BURN_INTERVAL	40 	// 4 sec

#define HUNTER_SCAN_MIN_DISTANCE 8
#define HUNTER_SCAN_MAX_DISTANCE 35
#define HUNTER_SCAN_PING_TIME 20 //5s update time.

#define VASSAL_SCAN_MIN_DISTANCE 5
#define VASSAL_SCAN_MAX_DISTANCE 500
#define VASSAL_SCAN_PING_TIME 20 //2s update time.

