//Each lists stores ckeys for "Never for this round" option category

#define POLL_IGNORE_SENTIENCE_POTION "sentience_potion"
#define POLL_IGNORE_POSSESSED_BLADE "possessed_blade"
#define POLL_IGNORE_ALIEN_LARVA "alien_larva"
#define POLL_IGNORE_SYNDICATE "syndicate"
#define POLL_IGNORE_HOLOPARASITE "holoparasite"
#define POLL_IGNORE_POSIBRAIN "posibrain"
#define POLL_IGNORE_SPECTRAL_BLADE "spectral_blade"
#define POLL_IGNORE_CONSTRUCT "construct"
#define POLL_IGNORE_SPIDER "spider"
#define POLL_IGNORE_ASHWALKER "ashwalker"
#define POLL_IGNORE_GOLEM "golem"
#define POLL_IGNORE_SWARMER "swarmer"
#define POLL_IGNORE_DRONE "drone"
#define POLL_IGNORE_FUGITIVE "fugitive"
#define POLL_IGNORE_PYROSLIME "slime"
#define POLL_IGNORE_SHADE "shade"
#define POLL_IGNORE_IMAGINARYFRIEND "imaginary_friend"
#define POLL_IGNORE_SPLITPERSONALITY "split_personality"
#define POLL_IGNORE_CONTRACTOR_SUPPORT "contractor_support"
#define POLL_IGNORE_ACADEMY_WIZARD "academy_wizard"
#define POLL_IGNORE_CLOCKWORK "clockwork"
#define POLL_IGNORE_PAI "pai"


GLOBAL_LIST_INIT(poll_ignore_desc, list(
	POLL_IGNORE_SENTIENCE_POTION = "Зелье разумности",
	POLL_IGNORE_POSSESSED_BLADE = "Одержимый клинок",
	POLL_IGNORE_ALIEN_LARVA = "Личинка ксеноморфа",
	POLL_IGNORE_SYNDICATE = "Синдикат",
	POLL_IGNORE_HOLOPARASITE = "Голопаразит",
	POLL_IGNORE_POSIBRAIN = "Позитронный мозг",
	POLL_IGNORE_SPECTRAL_BLADE = "Спектральный меч",
	POLL_IGNORE_CONSTRUCT = "Констракт культа",
	POLL_IGNORE_SPIDER = "Пауки",
	POLL_IGNORE_ASHWALKER = "Пепельные яйца",
	POLL_IGNORE_GOLEM = "Големы",
	POLL_IGNORE_SWARMER = "Свармеры",
	POLL_IGNORE_DRONE = "Дроны",
	POLL_IGNORE_FUGITIVE = "Fugitive Hunter",
	POLL_IGNORE_PYROSLIME = "Слаймы",
	POLL_IGNORE_SHADE = "Духи",
	POLL_IGNORE_IMAGINARYFRIEND = "Воображаемый друг",
	POLL_IGNORE_SPLITPERSONALITY = "Раздвоение личности",
	POLL_IGNORE_CONTRACTOR_SUPPORT = "Помощник наёмника",
	POLL_IGNORE_ACADEMY_WIZARD = "Защитник академии магов",
	POLL_IGNORE_PAI = "Персональный ИИ"
))
GLOBAL_LIST_INIT(poll_ignore, init_poll_ignore())


/proc/init_poll_ignore()
	. = list()
	for (var/k in GLOB.poll_ignore_desc)
		.[k] = list()
