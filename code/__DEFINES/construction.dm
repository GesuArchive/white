/*ALL DEFINES RELATED TO CONSTRUCTION, CONSTRUCTING THINGS, OR CONSTRUCTED OBJECTS GO HERE*/

//Defines for construction states

//girder construction states
#define GIRDER_NORMAL 0
#define GIRDER_REINF_STRUTS 1
#define GIRDER_PLAST_STRUTS 1.5
#define GIRDER_REINF 2
#define GIRDER_PLAST 2.5
#define GIRDER_DISPLACED 3
#define GIRDER_DISASSEMBLED 4
#define GIRDER_TRAM 5

//rwall construction states
#define INTACT 0
#define SUPPORT_LINES 1
#define COVER 2
#define CUT_COVER 3
#define ANCHOR_BOLTS 4
#define SUPPORT_RODS 5
#define SHEATH 6

// Проклепанная стена rivet
#define RIVET_FULL 0
#define RIVET_HEAT 1
#define RIVET_BAR 2

// cwall construction states
#define COG_COVER 1
#define COG_EXPOSED 3

//window construction states
#define WINDOW_OUT_OF_FRAME 0
#define WINDOW_IN_FRAME 1
#define WINDOW_SCREWED_TO_FRAME 2

//reinforced window construction states
#define RWINDOW_FRAME_BOLTED 3
#define RWINDOW_BARS_CUT 4
#define RWINDOW_POPPED 5
#define RWINDOW_BOLTS_OUT 6
#define RWINDOW_BOLTS_HEATED 7
#define RWINDOW_SECURE 8

//airlock assembly construction states
#define AIRLOCK_ASSEMBLY_NEEDS_WIRES 0
#define AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS 1
#define AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER 2

// Сборка-разборка бронеставень
#define BLASTDOOR_NEEDS_WIRES 0
#define BLASTDOOR_NEEDS_ELECTRONICS 1
#define BLASTDOOR_FINISHED 2

//default_unfasten_wrench() return defines
#define CANT_UNFASTEN 0
#define FAILED_UNFASTEN 1
#define SUCCESSFUL_UNFASTEN 2

//ai core defines
#define EMPTY_CORE 0
#define CIRCUIT_CORE 1
#define SCREWED_CORE 2
#define CABLED_CORE 3
#define GLASS_CORE 4
#define AI_READY_CORE 5

//Construction defines for the pinion airlock
#define GEAR_SECURE 1
#define GEAR_LOOSE 2

//floodlights because apparently we use defines now
#define FLOODLIGHT_NEEDS_WIRES 0
#define FLOODLIGHT_NEEDS_LIGHTS 1
#define FLOODLIGHT_NEEDS_SECURING 2

// Stationary gas tanks
#define TANK_FRAME 0
#define TANK_PLATING_UNSECURED 1

//other construction-related things

//windows affected by Nar'Sie turn this color.
#define NARSIE_WINDOW_COLOUR "#7D1919"

// Defines related to the custom materials used on objects.
///The amount of materials you get from a sheet of mineral like iron/diamond/glass etc. 100 Units.
#define SHEET_MATERIAL_AMOUNT 100
///The amount of materials you get from half a sheet. Used in standard object quantities. 50 units.
#define HALF_SHEET_MATERIAL_AMOUNT (SHEET_MATERIAL_AMOUNT/2)
///The amount of materials used in the smallest of objects, like pens and screwdrivers. 10 units.
#define SMALL_MATERIAL_AMOUNT (HALF_SHEET_MATERIAL_AMOUNT/5)
///The amount of material that goes into a coin, which determines the value of the coin.
#define COIN_MATERIAL_AMOUNT (HALF_SHEET_MATERIAL_AMOUNT * 0.4)

//let's just pretend fulltile windows being children of border windows is fine
#define FULLTILE_WINDOW_DIR NORTHEAST

//The amount of materials you get from a sheet of mineral like iron/diamond/glass etc
#define MINERAL_MATERIAL_AMOUNT 2000
//The maximum size of a stack object.
#define MAX_STACK_SIZE 50
//maximum amount of cable in a coil
#define MAXCOIL 30

//tablecrafting defines
#define CAT_NONE
#define CAT_FOOD "Еда"
#define CAT_BREAD "Хлеб"
#define CAT_BURGER "Бургеры"
#define CAT_CAKE "Торты"
#define CAT_EGG "Еда на основе яйц"
#define CAT_LIZARD "Еда ящеров"
#define CAT_MEAT "Мясо"
#define CAT_SEAFOOD "Морепродукты"
#define CAT_MISCFOOD "Остальная еда"
#define CAT_MEXICAN "Мексиканская еда"
#define CAT_MOTH "Еда молей"
#define CAT_PASTRY "Выпечка"
#define CAT_PIE "Пироги"
#define CAT_PIZZA "Пицца"
#define CAT_SALAD "Салаты"
#define CAT_SANDWICH "Бутерброды"
#define CAT_SOUP "Супы"
#define CAT_SPAGHETTI "Спагетти"
#define CAT_ICE "Мороженное"
#define CAT_DRINK "Напитки"

//crafting defines
#define CAT_WEAPON_RANGED "Оружие дальнего боя"
#define CAT_WEAPON_MELEE "Оружие ближнего боя"
#define CAT_WEAPON_AMMO "Боеприпасы"
#define CAT_ROBOT "Робототехника"
#define CAT_MISC "Остальное"
#define CAT_CLOTHING "Одежда"
#define CAT_CHEMISTRY "Химия"
#define CAT_ATMOSPHERIC "Атмосфера"
#define CAT_STRUCTURE "Структуры"
#define CAT_TILES "Плитки"
#define CAT_WINDOWS "Окна"
#define CAT_DOORS "Двери"
#define CAT_FURNITURE "Мебель"
#define CAT_EQUIPMENT "Снаряжения"
#define CAT_CONTAINERS "Контейнеры"
#define CAT_ENTERTAINMENT "Развлечение"
#define CAT_TOOLS "Инструменты"
#define CAT_CULT "Кровавый культ"

// these aren't even used as bitflags so who even knows why they are treated like them
#define RCD_FLOORWALL 0
#define RCD_AIRLOCK 1
#define RCD_DECONSTRUCT 2
#define RCD_WINDOWGRILLE 3
#define RCD_MACHINE 4
#define RCD_COMPUTER 5
#define RCD_FURNISHING 6
#define RCD_CATWALK 7
#define RCD_FLOODLIGHT 8
#define RCD_WALLFRAME 9
#define RCD_REFLECTOR 10
#define RCD_GIRDER 11

#define RCD_UPGRADE_FRAMES (1<<0)
#define RCD_UPGRADE_SIMPLE_CIRCUITS (1<<1)
#define RCD_UPGRADE_SILO_LINK (1<<2)
#define RCD_UPGRADE_FURNISHING (1<<3)
#define RCD_UPGRADE_ANTI_INTERRUPT (1<<4)
#define RCD_UPGRADE_NO_FREQUENT_USE_COOLDOWN (1<<5)

#define RPD_UPGRADE_UNWRENCH (1<<0)

#define RCD_WINDOW_FULLTILE "полноразмерное"
#define RCD_WINDOW_DIRECTIONAL "направленное"
#define RCD_WINDOW_NORMAL "обычное стекло"
#define RCD_WINDOW_REINFORCED "армированное стекло"

#define RCD_MEMORY_WALL 1
#define RCD_MEMORY_WINDOWGRILLE 2

// How much faster to use the RCD when on a tile with memory
#define RCD_MEMORY_SPEED_BUFF 5

/// How much less resources the RCD uses when reconstructing
#define RCD_MEMORY_COST_BUFF 8
///If the machine is used/deleted in the crafting process. При компиле сбивается порядок и деф объявляется позже чем используется, так что осталю это сдесь
#define CRAFTING_MACHINERY_CONSUME 1
///If the machine is only "used" i.e. it checks to see if it's nearby and allows crafting, but doesn't delete it
#define CRAFTING_MACHINERY_USE 0
