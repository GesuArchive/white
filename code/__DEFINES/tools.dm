// Tool types, if you add new ones please add them to /obj/item/debug/omnitool in code/game/objects/items/debug_items.dm
#define TOOL_CROWBAR "лом"
#define TOOL_MULTITOOL "мультитул"
#define TOOL_SCREWDRIVER "отвертка"
#define TOOL_WIRECUTTER "кусачки"
#define TOOL_WRENCH "гаечный ключ"
#define TOOL_WELDER "сварочный аппарат"
#define TOOL_ANALYZER "анализатор"
#define TOOL_MINING "кирка"
#define TOOL_SHOVEL "лопата"
#define TOOL_RETRACTOR "расширитель"
#define TOOL_HEMOSTAT "зажим"
#define TOOL_CAUTERY "прижигатель"
#define TOOL_DRILL "хирургическая дрель"
#define TOOL_SCALPEL "скальпель"
#define TOOL_SAW "циркулярная пила"
#define TOOL_BONESET "костоправ"
#define TOOL_KNIFE "нож"
#define TOOL_BLOODFILTER "фильтр крови"
#define TOOL_ROLLINGPIN "скалка"
/// Can be used to scrape rust off an any atom; which will result in the Rust Component being qdel'd
#define TOOL_RUSTSCRAPER "скребок ржавчины"

// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20

// tool_act chain flags

/// When a tooltype_act proc is successful
#define TOOL_ACT_TOOLTYPE_SUCCESS (1<<0)
/// When [COMSIG_ATOM_TOOL_ACT] blocks the act
#define TOOL_ACT_SIGNAL_BLOCKING (1<<1)

/// When [TOOL_ACT_TOOLTYPE_SUCCESS] or [TOOL_ACT_SIGNAL_BLOCKING] are set
#define TOOL_ACT_MELEE_CHAIN_BLOCKING (TOOL_ACT_TOOLTYPE_SUCCESS | TOOL_ACT_SIGNAL_BLOCKING)


//redfoks
#define TOOL_MECHCOMP "mechcomp"

#define MINING_TOOL_LIST list(\
	TOOL_MINING,\
	TOOL_SHOVEL\
)

#define ENGINEERING_TOOL_LIST list(\
	TOOL_CROWBAR,\
	TOOL_MULTITOOL,\
	TOOL_SCREWDRIVER,\
	TOOL_WIRECUTTER,\
	TOOL_WRENCH,\
	TOOL_WELDER,\
	TOOL_ANALYZER,\
	TOOL_MECHCOMP,\
	TOOL_RUSTSCRAPER\
)

#define SURGERY_TOOL_LIST list(\
	TOOL_RETRACTOR,\
	TOOL_HEMOSTAT,\
	TOOL_CAUTERY,\
	TOOL_WIRECUTTER,\
	TOOL_DRILL,\
	TOOL_SCALPEL,\
	TOOL_SAW,\
	TOOL_BONESET,\
	TOOL_KNIFE,\
	TOOL_BLOODFILTER\
)
