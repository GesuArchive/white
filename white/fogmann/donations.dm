////////////////////////////////
//
// Donations. Reworked for /tg/ by valtos
//
////////////////////////////////

GLOBAL_LIST_INIT(donations_list, list(
	"Шапки" = list(
		new /datum/donate_info("Collectable Pete hat",		/obj/item/clothing/head/collectable/petehat, 	150),
		new /datum/donate_info("Collectable Xeno hat",		/obj/item/clothing/head/collectable/xenom,		110),
		new /datum/donate_info("Collectable Top hat",		/obj/item/clothing/head/collectable/tophat,		120),
		new /datum/donate_info("Collectable rabbit ears",	/obj/item/clothing/head/collectable/rabbitears,	120),
		new /datum/donate_info("Kitty Ears",				/obj/item/clothing/head/kitty/genuine,			10000),
		new /datum/donate_info("Ushanka",					/obj/item/clothing/head/ushanka,				200),
		new /datum/donate_info("Beret",						/obj/item/clothing/head/beret,					150),
		new /datum/donate_info("Witch Wig",					/obj/item/clothing/head/witchwig,				135),
		new /datum/donate_info("Marisa hat",				/obj/item/clothing/head/witchwig,				130),
		new /datum/donate_info("Cake-hat",					/obj/item/clothing/head/hardhat/cakehat,		100),
		new /datum/donate_info("Wizard hat",				/obj/item/clothing/head/wizard/fake,			100),
		new /datum/donate_info("Flat-cap",					/obj/item/clothing/head/flatcap,				120),
		new /datum/donate_info("Cardborg helment",			/obj/item/clothing/head/cardborg,				20),
		new /datum/donate_info("Bear pelt",					/obj/item/clothing/head/bearpelt,				175),
		new /datum/donate_info("Scarecrow Hat",				/obj/item/clothing/head/scarecrow_hat,			175),
		new /datum/donate_info("Arbiter Helmet",			/obj/item/clothing/head/helmet/arbiter,			175),
		new /datum/donate_info("Inquisitor Helmet",			/obj/item/clothing/head/helmet/arbiter/inquisitor,200),
		new /datum/donate_info("m35 Cap",					/obj/item/clothing/head/helmet/izanhelm,		120),
		new /datum/donate_info("m35 Elite Cap",				/obj/item/clothing/head/helmet/izanhelm/elite,	120),
		new /datum/donate_info("m35 Helmet",				/obj/item/clothing/head/helmet/izanhelm/helmet,	120),
		new /datum/donate_info("m35 Elite Helmet",			/obj/item/clothing/head/helmet/izanhelm/helmet/elite,120),
		new /datum/donate_info("Pickelhelm",				/obj/item/clothing/head/helmet/izanhelm/helmet/pickelhelm,200),
		new /datum/donate_info("Richard's Head",			/obj/item/clothing/head/helmet/richard,			250),
		new /datum/donate_info("Soviet Ushanka",			/obj/item/clothing/head/ushanka/soviet,			200),
		new /datum/donate_info("Internal Revenue Service Cap",/obj/item/clothing/head/irs,					200),
		new /datum/donate_info("Powder Ganger Beanie",		/obj/item/clothing/head/pg,						200),
		new /datum/donate_info("Lost M.C. Bandana",			/obj/item/clothing/head/tmc,					200),
		new /datum/donate_info("Decker Headphones",			/obj/item/clothing/head/deckers,				200),
		new /datum/donate_info("Morningstar Beret",			/obj/item/clothing/head/morningstar,			200),
		new /datum/donate_info("Saints Hat",				/obj/item/clothing/head/saints,					200),
		new /datum/donate_info("Allies Helmet",				/obj/item/clothing/head/allies,					200),
		new /datum/donate_info("Yuri Initiate Helmet",		/obj/item/clothing/head/yuri,					200),
		new /datum/donate_info("Sybil Slickers Helmet",		/obj/item/clothing/head/sybil_slickers,			200),
		new /datum/donate_info("Basil Boys Helmet",			/obj/item/clothing/head/basil_boys,				200),
	),
	"Маски" = list(
		new /datum/donate_info("Emotions Mask",				/obj/item/clothing/mask/joy,					200),
		new /datum/donate_info("Fake Moustache",			/obj/item/clothing/mask/fakemoustache,			100),
		new /datum/donate_info("Pig Mask",					/obj/item/clothing/mask/animal/pig,				150),
		new /datum/donate_info("Cow Mask",					/obj/item/clothing/mask/animal/cowmask,			150),
		new /datum/donate_info("Horse Head Mask",			/obj/item/clothing/mask/animal/horsehead,		150),
		new /datum/donate_info("Carp Mask",					/obj/item/clothing/mask/gas/carp,				150),
		new /datum/donate_info("Plague Doctor Mask",		/obj/item/clothing/mask/gas/plaguedoctor,		180),
		new /datum/donate_info("Monkey Mask",				/obj/item/clothing/mask/gas/monkeymask,			180),
		new /datum/donate_info("Owl Mask",					/obj/item/clothing/mask/gas/owl_mask,			180),
		new /datum/donate_info("Sack Mask",					/obj/item/clothing/mask/scarecrow,				180),
		new /datum/donate_info("Old Style Gas Mask",		/obj/item/clothing/mask/gas/izan,				200),
		new /datum/donate_info("German Gas Mask",			/obj/item/clothing/mask/gas/izan/german,		210),
		new /datum/donate_info("German Gas Mask Alt",		/obj/item/clothing/mask/gas/izan/german/alt,	200),
		new /datum/donate_info("Respirator Mask",			/obj/item/clothing/mask/gas/izan/respirator,	150),
		new /datum/donate_info("Balaclava",					/obj/item/clothing/mask/izanclava,				110),
		new /datum/donate_info("Swatclava",					/obj/item/clothing/mask/izanclava/swat,			120),
	),
	"Очки" = list(
		new /datum/donate_info("Eye patch",					/obj/item/clothing/glasses/eyepatch,			130),
		new /datum/donate_info("Orange glasses",			/obj/item/clothing/glasses/orange,				130),
		new /datum/donate_info("Heat goggles",				/obj/item/clothing/glasses/heat,				130),
		new /datum/donate_info("Cold goggles",				/obj/item/clothing/glasses/cold,				130),
		new /datum/donate_info("Red glasses",				/obj/item/clothing/glasses/red,					180),
		new /datum/donate_info("Geist Gazers",				/obj/item/clothing/glasses/geist_gazers,		250),
		new /datum/donate_info("Psych glasses",				/obj/item/clothing/glasses/psych,				250),
		new /datum/donate_info("O.S.I. Sunglasses",			/obj/item/clothing/glasses/osi,					130),
		new /datum/donate_info("Phantom Thief Mask",		/obj/item/clothing/glasses/phantom,				130),
	),
	"Личное" = list(
		new /datum/donate_info("Cane",						/obj/item/cane,									130),
		new /datum/donate_info("Zippo",						/obj/item/lighter,								130),
		new /datum/donate_info("Cigarette packet",			/obj/item/storage/fancy/cigarettes,				20),
		new /datum/donate_info("DromedaryCo packet",		/obj/item/storage/fancy/cigarettes/dromedaryco,	50),
		new /datum/donate_info("Premium Havanian Cigar",	/obj/item/clothing/mask/cigarette/cigar/havana,	130),
		new /datum/donate_info("E-Cigarette",				/obj/item/clothing/mask/vape,					150),
		new /datum/donate_info("Beer bottle",				/obj/item/reagent_containers/food/drinks/beer,	80),
		new /datum/donate_info("Captain flask",				/obj/item/reagent_containers/food/drinks/flask,	200),
		new /datum/donate_info("Waistcoat",					/obj/item/clothing/accessory/waistcoat,			85),
		new /datum/donate_info("Donut Box",					/obj/item/storage/fancy/donut_box,				450),
		new /datum/donate_info("Red Armband",				/obj/item/clothing/accessory/armband,			100),
	),
	"Обувь" = list(
		new /datum/donate_info("Clown Shoes",				/obj/item/clothing/shoes/clown_shoes,			120),
		new /datum/donate_info("Laceups Shoes",				/obj/item/clothing/shoes/laceup,				120),
		new /datum/donate_info("Wooden Sandals",			/obj/item/clothing/shoes/sandal,				80),
		new /datum/donate_info("Brown Shoes",				/obj/item/clothing/shoes/sneakers/brown,		120),
		new /datum/donate_info("Jackboots",					/obj/item/clothing/shoes/jackboots,				130),
		new /datum/donate_info("Arbiter Boots",				/obj/item/clothing/shoes/jackboots/arbiter,		150),
		new /datum/donate_info("Frosty Boots",				/obj/item/clothing/shoes/jackbros,				200),
		new /datum/donate_info("Swag Shoes",				/obj/item/clothing/shoes/swagshoes,				200),
		new /datum/donate_info("Phantom Shoes",				/obj/item/clothing/shoes/phantom,				200),
		new /datum/donate_info("Saints Sneakers",			/obj/item/clothing/shoes/saints,				200),
		new /datum/donate_info("Morningstar Boots",			/obj/item/clothing/shoes/morningstar,			200),
		new /datum/donate_info("Deckers Rollerskates",		/obj/item/clothing/shoes/deckers,				200),
		new /datum/donate_info("Sybil Slickers Shoes",		/obj/item/clothing/shoes/sybil_slickers,		200),
		new /datum/donate_info("Basil Boys Shoes",			/obj/item/clothing/shoes/basil_boys,			200),
	),
	"Костюмы" = list(
		new /datum/donate_info("Leather Coat",				/obj/item/clothing/suit/jacket/leather/overcoat,160),
		new /datum/donate_info("Pirate Coat",				/obj/item/clothing/suit/pirate,					120),
		new /datum/donate_info("Red poncho",				/obj/item/clothing/suit/poncho/red,				140),
		new /datum/donate_info("Green poncho",				/obj/item/clothing/suit/poncho/green,			150),
		new /datum/donate_info("Puffer jacket",				/obj/item/clothing/suit/jacket/puffer,			120),
		new /datum/donate_info("Winter coat",				/obj/item/clothing/suit/hooded/wintercoat,		130),
		new /datum/donate_info("Cardborg",					/obj/item/clothing/suit/cardborg,				50),
		new /datum/donate_info("Bulletproof Vest",			/obj/item/clothing/suit/armor/vest/izan,		100),
		new /datum/donate_info("Arbiter Vest",				/obj/item/clothing/suit/armor/vest/izan/arbiter,165),
		new /datum/donate_info("m35 Coat",					/obj/item/clothing/suit/armor/vest/izan/army_coat,120),
		new /datum/donate_info("m35 Elite Coat",			/obj/item/clothing/suit/armor/vest/izan/elite_army_coat,135),
		new /datum/donate_info("m35 Super Elite Coat",		/obj/item/clothing/suit/armor/vest/izan/super_elite_army_coat,165),
		new /datum/donate_info("Driscoll Poncho",			/obj/item/clothing/suit/costume/driscoll,		200),
		new /datum/donate_info("Internal Revenue Service Jacket",/obj/item/clothing/suit/costume/irs,		200),
		new /datum/donate_info("O.S.I. Body Armor",			/obj/item/clothing/suit/costume/osi,			200),
		new /datum/donate_info("Lost M.C. Cut",				/obj/item/clothing/suit/costume/tmc,			200),
		new /datum/donate_info("Powder Ganger Jacket",		/obj/item/clothing/suit/costume/pg,				200),
		new /datum/donate_info("Decker Hoodie",				/obj/item/clothing/suit/costume/deckers,		200),
		new /datum/donate_info("Morningstar Coat",			/obj/item/clothing/suit/costume/morningstar,	200),
		new /datum/donate_info("Third Street Saints Fur Coat",/obj/item/clothing/suit/costume/saints,		200),
		new /datum/donate_info("Phantom Thief Coat",		/obj/item/clothing/suit/costume/phantom,		200),
		new /datum/donate_info("Allies Body Armor",			/obj/item/clothing/suit/costume/allies,			200),
		new /datum/donate_info("Soviet Armored Coat",		/obj/item/clothing/suit/costume/soviet,			200),
		new /datum/donate_info("Yuri Initiate Coat",		/obj/item/clothing/suit/costume/yuri,			200),
		new /datum/donate_info("Sybil Slickers Protective Gear",/obj/item/clothing/suit/costume/sybil_slickers,200),
		new /datum/donate_info("Basil Boys Protective Gear",/obj/item/clothing/suit/costume/basil_boys,		200),
	),
	"Униформы" = list(
		new /datum/donate_info("Vice Policeman",			/obj/item/clothing/under/misc/vice_officer,		180),
		new /datum/donate_info("Pirate outfit",				/obj/item/clothing/under/costume/pirate,		130),
		new /datum/donate_info("Waiter outfit",				/obj/item/clothing/under/suit/waiter,			120),
		new /datum/donate_info("Black suit",				/obj/item/clothing/under/suit/black,			150),
		new /datum/donate_info("Central Command officer",	/obj/item/clothing/under/rank/centcom/officer,	390),
		new /datum/donate_info("Jeans",						/obj/item/clothing/under/pants/jeans,			160),
		new /datum/donate_info("Rainbow Suit",				/obj/item/clothing/under/color/rainbow,			130),
		new /datum/donate_info("Executive Skirt",			/obj/item/clothing/under/suit/black_really/skirt,130),
		new /datum/donate_info("Executive Suit",			/obj/item/clothing/under/suit/black_really,		130),
		new /datum/donate_info("Schoolgirl Uniform",		/obj/item/clothing/under/costume/schoolgirl,	130),
		new /datum/donate_info("Tacticool Turtleneck",		/obj/item/clothing/under/syndicate/tacticool,	130),
		new /datum/donate_info("Tacticool Skirtleneck",		/obj/item/clothing/under/syndicate/tacticool/skirt,130),
		new /datum/donate_info("Soviet Uniform",			/obj/item/clothing/under/costume/soviet,		130),
		new /datum/donate_info("Kilt",						/obj/item/clothing/under/costume/kilt,			100),
		new /datum/donate_info("Gladiator uniform",			/obj/item/clothing/under/costume/gladiator,		100),
		new /datum/donate_info("Assistant's formal uniform",/obj/item/clothing/under/misc/assistantformal,	100),
		new /datum/donate_info("Psychedelic jumpsuit",		/obj/item/clothing/under/misc/psyche,			220),
		new /datum/donate_info("m35 Jacket",				/obj/item/clothing/under/m35jacket,				120),
		new /datum/donate_info("m35 Officer Jacket",		/obj/item/clothing/under/m35jacket/officer,		130),
		new /datum/donate_info("m35 Elite Jacket",			/obj/item/clothing/under/m35jacket/elite,		125),
		new /datum/donate_info("m35 Super Elite Jacket",	/obj/item/clothing/under/m35jacket/elite/super,	125),
		new /datum/donate_info("Magistrate Uniform",		/obj/item/clothing/under/magistrate,			125),
		new /datum/donate_info("Arbiter Uniform",			/obj/item/clothing/under/arbiter,				125),
		new /datum/donate_info("Blue Galaxy Suit",			/obj/item/clothing/under/rank/civilian/lawyer/galaxy,225),
		new /datum/donate_info("Red Galaxy Suit",			/obj/item/clothing/under/rank/civilian/lawyer/galaxy/red,225),
		new /datum/donate_info("Jabroni Outfit",			/obj/item/clothing/under/costume/jabroni, 		100),
		new /datum/donate_info("Спортивный Костюм",			/obj/item/clothing/under/switer/tracksuit, 		228),
		new /datum/donate_info("Jack Bros Outfit",			/obj/item/clothing/under/costume/jackbros, 		200),
		new /datum/donate_info("Tojo Clan Pants",			/obj/item/clothing/under/costume/yakuza, 		200),
		new /datum/donate_info("Dutch's Suit",				/obj/item/clothing/under/costume/dutch, 		200),
		new /datum/donate_info("Internal Revenue Service Outfit",/obj/item/clothing/under/costume/irs, 		200),
		new /datum/donate_info("O.S.I. Jumpsuit",			/obj/item/clothing/under/costume/osi, 			200),
		new /datum/donate_info("Lost MC Clothing",			/obj/item/clothing/under/costume/tmc, 			200),
		new /datum/donate_info("Powder Ganger Prison Jumpsuit",	/obj/item/clothing/under/costume/pg, 		200),
		new /datum/donate_info("O'Driscoll Outfit",			/obj/item/clothing/under/costume/driscoll, 		200),
		new /datum/donate_info("Deckers Outfit",			/obj/item/clothing/under/costume/deckers, 		200),
		new /datum/donate_info("Morningstar Suit",			/obj/item/clothing/under/costume/morningstar, 	200),
		new /datum/donate_info("Saints Outfit",				/obj/item/clothing/under/costume/saints, 		200),
		new /datum/donate_info("Phantom Thief Outfit",		/obj/item/clothing/under/costume/phantom, 		200),
		new /datum/donate_info("Allies Tanktop",			/obj/item/clothing/under/costume/allies, 		200),
		new /datum/donate_info("Soviet Conscript Uniform",	/obj/item/clothing/under/costume/soviet_families,200),
		new /datum/donate_info("Yuri Initiate Jumpsuit",	/obj/item/clothing/under/costume/yuri, 			200),
		new /datum/donate_info("Sybil Slickers Uniform",	/obj/item/clothing/under/costume/sybil_slickers,200),
		new /datum/donate_info("Basil Boys Uniform",		/obj/item/clothing/under/costume/basil_boys, 	200),
	),
	"Перчатки" = list(
		new /datum/donate_info("White Gloves",				/obj/item/clothing/gloves/color/white,			100),
		new /datum/donate_info("Orange Gloves",				/obj/item/clothing/gloves/color/orange,			125),
		new /datum/donate_info("Red Gloves",				/obj/item/clothing/gloves/color/red,			125),
		new /datum/donate_info("Blue Gloves",				/obj/item/clothing/gloves/color/blue,			125),
		new /datum/donate_info("Purple Gloves",				/obj/item/clothing/gloves/color/purple,			125),
		new /datum/donate_info("Green Gloves",				/obj/item/clothing/gloves/color/green,			125),
		new /datum/donate_info("Grey Gloves",				/obj/item/clothing/gloves/color/grey,			125),
		new /datum/donate_info("Light Brown Gloves",		/obj/item/clothing/gloves/color/light_brown,	125),
		new /datum/donate_info("Brown Gloves",				/obj/item/clothing/gloves/color/brown,			125),
		new /datum/donate_info("Black Gloves",				/obj/item/clothing/gloves/color/black,			125),
		new /datum/donate_info("Rainbow Gloves",			/obj/item/clothing/gloves/color/rainbow,		150),
		new /datum/donate_info("Fingerless Gloves",			/obj/item/clothing/gloves/fingerless,			90),
		new /datum/donate_info("Boxing Gloves",				/obj/item/clothing/gloves/boxing,				50),
		new /datum/donate_info("Boxing Gloves",				/obj/item/clothing/gloves/boxing/green,			50),
		new /datum/donate_info("Boxing Gloves",				/obj/item/clothing/gloves/boxing/blue,			50),
		new /datum/donate_info("Boxing Gloves",				/obj/item/clothing/gloves/boxing/yellow,		50),
		new /datum/donate_info("Arbiter Gloves",			/obj/item/clothing/gloves/arbiter,				125),
		new /datum/donate_info("Undertaker Gloves",			/obj/item/clothing/gloves/arbiter/undertaker,	125),
	),
	"Плащи" = list(
		new /datum/donate_info("Cloak",						/obj/item/clothing/neck/cloak,					190),
		new /datum/donate_info("Cowl",						/obj/item/clothing/neck/cowl,					150),
		new /datum/donate_info("Blue Robe",					/obj/item/clothing/neck/cowl/robe,				500),
		new /datum/donate_info("Red Robe",					/obj/item/clothing/neck/cowl/robe/red,			500),
		new /datum/donate_info("Terran Robe",				/obj/item/clothing/neck/cowl/terran,			500),
		new /datum/donate_info("Terran Robe",				/obj/item/clothing/neck/cowl/terran/off,		500),
		new /datum/donate_info("Terran Robe",				/obj/item/clothing/neck/cowl/terran/comm,		500),
	),
	"Покрывала" = list(
		new /datum/donate_info("DIY Bedsheet",				/obj/item/bedsheet,								50),
		new /datum/donate_info("Blue Bedsheet",				/obj/item/bedsheet/blue,						75),
		new /datum/donate_info("Green Bedsheet",			/obj/item/bedsheet/green,						75),
		new /datum/donate_info("Grey Bedsheet",				/obj/item/bedsheet/grey,						75),
		new /datum/donate_info("Orange Bedsheet",			/obj/item/bedsheet/orange,						75),
		new /datum/donate_info("Purple Bedsheet",			/obj/item/bedsheet/purple,						75),
		new /datum/donate_info("Red Bedsheet",				/obj/item/bedsheet/red,							75),
		new /datum/donate_info("Yellow Bedsheet",			/obj/item/bedsheet/yellow,						75),
		new /datum/donate_info("Brown Bedsheet",			/obj/item/bedsheet/brown,						75),
		new /datum/donate_info("Black Bedsheet",			/obj/item/bedsheet/black,						75),
		new /datum/donate_info("Rainbow Bedsheet",			/obj/item/bedsheet/rainbow,						75),
		new /datum/donate_info("Patriot Bedsheet",			/obj/item/bedsheet/patriot,						100),
		new /datum/donate_info("CentCom Bedsheet",			/obj/item/bedsheet/centcom,						150),
		new /datum/donate_info("NanoTrasen Bedsheet",		/obj/item/bedsheet/nanotrasen,					150),
		new /datum/donate_info("Syndie Bedsheet",			/obj/item/bedsheet/syndie,						150),
		new /datum/donate_info("Cult Bedsheet",				/obj/item/bedsheet/cult,						200),
		new /datum/donate_info("Wizard Bedsheet",			/obj/item/bedsheet/wiz,							200),
		new /datum/donate_info("Ian Bedsheet",				/obj/item/bedsheet/ian,							200),
		new /datum/donate_info("CE Bedsheet",				/obj/item/bedsheet/ce,							100),
		new /datum/donate_info("QM Bedsheet",				/obj/item/bedsheet/qm,							100),
		new /datum/donate_info("RD Bedsheet",				/obj/item/bedsheet/rd,							100),
		new /datum/donate_info("CMO Bedsheet",				/obj/item/bedsheet/cmo,							100),
		new /datum/donate_info("HOS Bedsheet",				/obj/item/bedsheet/hos,							100),
		new /datum/donate_info("HOP Bedsheet",				/obj/item/bedsheet/hop,							100),
		new /datum/donate_info("Clown Bedsheet",			/obj/item/bedsheet/clown,						100),
		new /datum/donate_info("Mime Bedsheet",				/obj/item/bedsheet/mime,						100),
		new /datum/donate_info("Chaplain Bedsheet",			/obj/item/bedsheet/chaplain,					100),
		new /datum/donate_info("Captain Bedsheet",			/obj/item/bedsheet/captain,						150),
		new /datum/donate_info("Cosmos Bedsheet",			/obj/item/bedsheet/cosmos,						250),
	),
	"Игрушки" = list(
		new /datum/donate_info("Snappops",					/obj/item/storage/box/snappops,					90),
		new /datum/donate_info(JOB_AI,						/obj/item/toy/talking/ai,						90),
		new /datum/donate_info("Codex Gigas",				/obj/item/toy/talking/codex_gigas,				90),
		new /datum/donate_info("Sword",						/obj/item/toy/sword,							90),
		new /datum/donate_info("Crossbow",					/obj/item/gun/ballistic/shotgun/toy/crossbow,	90),
		new /datum/donate_info("Crayons",					/obj/item/storage/crayons,						90),
		new /datum/donate_info("Spinning Toy",				/obj/item/toy/spinningtoy,						90),
		new /datum/donate_info("Arrest",					/obj/item/toy/balloon/arrest,					90),
		new /datum/donate_info("Nuke",						/obj/item/toy/nuke,								90),
		new /datum/donate_info("Mini-meteor",				/obj/item/toy/minimeteor,						90),
		new /datum/donate_info("Red Button",				/obj/item/toy/redbutton,						90),
		new /datum/donate_info("Owl",						/obj/item/toy/talking/owl,						90),
		new /datum/donate_info("Griffin",					/obj/item/toy/talking/griffin,					90),
		new /datum/donate_info("Antag Token",				/obj/item/coin/antagtoken,						90),
		new /datum/donate_info("Toy Xeno",					/obj/item/toy/toy_xeno,							90),
		new /datum/donate_info("Handcuffs",					/obj/item/restraints/handcuffs/fake,			90),
		new /datum/donate_info("Eightball",					/obj/item/toy/eightball,						90),
		new /datum/donate_info("Toolbox",					/obj/item/toy/windup_toolbox,					90),
		new /datum/donate_info("Clock",						/obj/item/toy/clockwork_watch,					90),
		new /datum/donate_info("Dagger",					/obj/item/toy/toy_dagger,						90),
		new /datum/donate_info("E-Hand",					/obj/item/extendohand/acme,						90),
		new /datum/donate_info("Hot Potato",				/obj/item/hot_potato/harmless/toy,				90),
		new /datum/donate_info("Emag",						/obj/item/card/emagfake,						90),
		new /datum/donate_info("Goat",						/obj/item/toy/plush/goatplushie,				90),
		new /datum/donate_info("Moth",						/obj/item/toy/plush/moth,						90),
		new /datum/donate_info("Peacekeeper",				/obj/item/toy/plush/pkplush,					90),
		new /datum/donate_info("Radio",						/obj/item/toy/brokenradio,						90),
		new /datum/donate_info("Brain",						/obj/item/toy/braintoy,							90),
		new /datum/donate_info("Toy pistol",				/obj/item/toy/gun,								90),
		new /datum/donate_info("Toy dualsaber",				/obj/item/dualsaber/toy,						280),
		new /datum/donate_info("Toy katana",				/obj/item/toy/katana,							215),
		new /datum/donate_info("Rubber Duck",				/obj/item/bikehorn/rubberducky,					90),
		new /datum/donate_info("Champion Belt",				/obj/item/storage/belt/champion,				200),
		new /datum/donate_info("Марфумо",					/obj/item/toy/plush/marfumoplushie,				300),
		new /datum/donate_info("Асфумо",					/obj/item/toy/plush/asfumoplushie,				300),
		new /datum/donate_info("Цирфумо",					/obj/item/toy/plush/cirfumoplushie,				300),
	),
	"Специальное" = list(
		new /datum/donate_info("Santa Bag",					/obj/item/storage/backpack/santabag,			450),
		new /datum/donate_info("Bible",						/obj/item/storage/book/bible,					100),
		new /datum/donate_info("Checkers Kit",				/obj/item/checkers_kit,							150),
		new /datum/donate_info("Casino Cards",				/obj/item/toy/cards/deck/shitspawn_deck,		450),
		new /datum/donate_info("Jukebox",					/obj/machinery/turntable,						100),
		new /datum/donate_info("Boombox",					/obj/item/boombox,								150),
		new /datum/donate_info("Music Writer",				/obj/machinery/musicwriter,						450),
		new /datum/donate_info("TTS ears",					/obj/item/organ/ears/cat/tts,                   500),
		new /datum/donate_info("DIY Shuttle Kit",			/obj/item/storage/box/diy_shuttle,				500),
		new /datum/donate_info("Anonist Mask",				/obj/item/clothing/mask/gas/anonist,			100),
		new /datum/donate_info("Glitch Gun",				/obj/item/gun/magic/glitch,						300),
		new /datum/donate_info("CoomCamera™",				/obj/item/camera/coom,							300)
	)
))
GLOBAL_PROTECT(donations_list)

/datum/donate_info
	var/name
	var/path_to
	var/cost = 0
	var/special = null
	var/stock = 30

/datum/donate_info/New(name, path, cost, special = null, stock = 30)
	src.name = name
	src.path_to = path
	src.cost = cost
	src.special = special
	src.stock = stock

/client/verb/new_donates_panel()
	set name = "Панель благотворца"
	set category = "Особенное"


	if(!SSticker || SSticker.current_state < GAME_STATE_PLAYING)
		to_chat(src, span_warning("Не так быстро, игра ещё не началась!"))
		return

	if (!GLOB.donators[ckey]) //If it doesn't exist yet
		load_donator(ckey)

	var/datum/donator/D = GLOB.donators[ckey]
	if(D)
		D.ui_interact(src.mob)
	else
		D = GLOB.donators["FREEBIE"]
		if(!D)
			D = new /datum/donator("FREEBIE", 0)
	D.ui_interact(src.mob)

GLOBAL_LIST_EMPTY(donate_icon_cache)
GLOBAL_LIST_EMPTY(donators)
GLOBAL_PROTECT(donators)

#define DONATIONS_SPAWN_WINDOW 6000

/datum/donator
	var/ownerkey
	var/money = 0
	var/maxmoney = 0
	var/allowed_num_items = 20
	var/selected_cat
	var/compact_mode = FALSE

/datum/donator/New(ckey, cm)
	..()
	ownerkey = ckey
	money = cm
	maxmoney = cm
	GLOB.donators[ckey] = src

/datum/donator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DonationsMenu", "Панель Благотворца")
		ui.open()

/datum/donator/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/donator/ui_data(mob/user)
	var/list/data = list()
	data["money"] = money
	data["compactMode"] = compact_mode
	return data

/datum/donator/ui_static_data(mob/user)
	var/list/data = list()

	data["categories"] = list()
	for(var/category in GLOB.donations_list)
		var/list/catsan = GLOB.donations_list[category]
		var/list/cat = list(
			"name" = category,
			"items" = (category == selected_cat ? list() : null))
		for(var/item in 1 to catsan.len)
			var/datum/donate_info/I = catsan[item]
			cat["items"] += list(list(
				"name" = I.name,
				"cost" = I.cost,
				"icon" = GetIconForProduct(I),
				"ref" = REF(I),
			))
		data["categories"] += list(cat)

	return data

/datum/donator/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("buy")
			var/datum/donate_info/prize = locate(params["ref"])
			var/mob/living/carbon/human/user = usr

			if(!SSticker || SSticker.current_state < 3)
				to_chat(user,span_warning("Игра ещё не началась!"))
				return FALSE

			if((world.time-SSticker.round_start_time) > DONATIONS_SPAWN_WINDOW && !istype(get_area(user), /area/service/bar))
				to_chat(user,span_warning("Нужно быть в баре."))
				return FALSE

			if(istype(get_area(user), /area/violence))
				to_chat(user,span_warning("Поставки товаров СиндиЭкспресс в данную зону невозможны."))
				return FALSE

			if(prize.cost > money)
				to_chat(user,span_warning("Недостаточно баланса."))
				return FALSE

			if(!allowed_num_items)
				to_chat(user,span_warning("Достигли максимума. Ура."))
				return FALSE

			if(!user)
				to_chat(user,span_warning("Нужно быть живым."))
				return FALSE

			if(!ispath(prize.path_to))
				return FALSE

			if(user.stat)
				return FALSE

			if(prize.stock <= 0)
				to_chat(user,span_warning("Поставки <b>[prize.name]</b> закончились."))
				return FALSE

			if(prize.special)
				if (prize.special != user.ckey)
					to_chat(user,span_warning("Этот предмет предназначен для <b>[prize.special]</b>."))
					return FALSE

			prize.stock--

			podspawn(list(
				"target" = get_turf(user),
				"path" = /obj/structure/closet/supplypod/box,
				"spawn" = prize.path_to
			))

			to_chat(user, span_info("[capitalize(prize.name)] был создан!"))

			money -= prize.cost
			allowed_num_items--
			return TRUE
		if("select")
			selected_cat = params["category"]
			return TRUE
		if("compact_toggle")
			compact_mode = !compact_mode
			return TRUE

/datum/donator/proc/GetIconForProduct(datum/donate_info/P)
	if(GLOB.donate_icon_cache[P.path_to])
		return GLOB.donate_icon_cache[P.path_to]
	GLOB.donate_icon_cache[P.path_to] = icon2base64(getFlatIcon(path2image(P.path_to), no_anim = TRUE))
	return GLOB.donate_icon_cache[P.path_to]

GLOBAL_VAR_INIT(ohshitfuck, FALSE)
GLOBAL_PROTECT(ohshitfuck)

/proc/load_donator(ckey)
	if(!SSdbcore.IsConnected())
		return FALSE

	if(GLOB.ohshitfuck)
		new /datum/donator(ckey, 50000)
		return TRUE

	var/datum/db_query/query_donators = SSdbcore.NewQuery("SELECT round(sum) FROM donations WHERE byond=:ckey", list("ckey" = ckey))
	query_donators.Execute()
	while(query_donators.NextRow())
		var/money = round(text2num(query_donators.item[1]))
		new /datum/donator(ckey, money)
	qdel(query_donators)
	return TRUE

/proc/check_donations(ckey)
	if (!GLOB.donators[ckey]) //If it doesn't exist yet
		return FALSE
	var/datum/donator/D = GLOB.donators[ckey]
	if(D)
		return D.maxmoney
	return FALSE

/proc/check_donations_avail(ckey)
	if (!GLOB.donators[ckey])
		return FALSE
	var/datum/donator/D = GLOB.donators[ckey]
	if(D)
		return D.money
	return FALSE

/proc/get_donator(ckey)
	if (!GLOB.donators[ckey])
		return FALSE
	var/datum/donator/D = GLOB.donators[ckey]
	if(D)
		return D
	return null

/client/proc/manage_some_donations()
	set name = "Manage Some Donations"
	set category = "Дбг"

	if(!check_rights_for(src, R_SECURED))
		return

	var/which_one = tgui_input_list(src, "ОООХ", "ОБОЖАЮ ЧЛЕН В ЖОПЕ ПО УТРАМ", list("race", "tails", "phoenix", "boosty"))

	if(!which_one)
		return

	var/list/lte_nuclear_war = GLOB.donators_list[which_one]

	var/fuckoboingo = tgui_input_list(src, "HOLY", "RETARD", sort_list(lte_nuclear_war)|"ADD SOMEONE")

	if(!fuckoboingo)
		return

	if(fuckoboingo == "ADD SOMEONE")
		if(which_one == "boosty")
			var/boosty_sub = tgui_input_text(src, "Sample: ckey", "some small ass")
			if(!boosty_sub)
				return

			LAZYADD(lte_nuclear_war, boosty_sub)
			message_admins("[key_name_admin(src)] добавляет [boosty_sub] в подписчики на Boosty.")
		else
			var/motherlover = tgui_input_text(src, "Separator is - \n Sample: ckey-id", "some big ass")

			if(!motherlover)
				return

			var/list/fucktorio = splittext_char(motherlover, "-")

			if(!length(fucktorio?[1]) || !length(fucktorio?[2]))
				return

			if(which_one == "phoenix")
				if(lte_nuclear_war[ckey(fucktorio[1])])
					lte_nuclear_war[ckey(fucktorio[1])] = fucktorio[2]
				else
					LAZYADDASSOC(lte_nuclear_war, ckey(fucktorio[1]), text2num(fucktorio[2]))
				message_admins("[key_name_admin(src)] устанавливает [fucktorio[1]] количество перерождений на [fucktorio[2]].")
			else
				if(fucktorio[2] == "all")
					var/list/roles_to_add = list("fly", "felinid", "moth", "ipc", "plasmaman", "lizard", "android", "ethereal", "pigman")
					for(var/role in roles_to_add)
						LAZYADDASSOCLIST(lte_nuclear_war, ckey(fucktorio[1]), role)
					message_admins("[key_name_admin(src)] открывает [fucktorio[1]] доступ к [english_list(roles_to_add)].")
				else
					LAZYADDASSOCLIST(lte_nuclear_war, ckey(fucktorio[1]), fucktorio[2])
					message_admins("[key_name_admin(src)] открывает [fucktorio[1]] доступ к [fucktorio[2]].")
	else
		if(which_one != "phoenix" && which_one != "boosty")
			var/list/temp_list = list()
			for(var/fucker in lte_nuclear_war)
				if(fucker != fuckoboingo)
					continue
				temp_list += lte_nuclear_war[fucker]
			var/fuckate = tgui_input_list(src, "AHH", "DIGGER", sort_list(temp_list))
			if(!fuckate)
				return
			LAZYREMOVEASSOC(lte_nuclear_war, fuckoboingo, fuckate)
			message_admins("[key_name_admin(src)] удаляет у [fuckoboingo] доступ к [fuckate].")
		else
			LAZYREMOVE(lte_nuclear_war, fuckoboingo)
			message_admins("[key_name_admin(src)] удаляет у [fuckoboingo] доступ к [which_one].")

	GLOB.donators_list[which_one] = lte_nuclear_war
	save_donations(which_one)

/proc/load_donations(which_one)
	var/json_file = file("data/donations/[which_one].json")
	if(!fexists(json_file))
		return
	return json_decode(file2text(json_file))

/proc/save_donations(which_one)
	if(IsAdminAdvancedProcCall())
		message_admins("[key_name_admin(usr)] попытался потрогать мои драгоценные донаты.")
		return

	var/json_file = file("data/donations/[which_one].json")

	fdel(json_file)

	WRITE_FILE(json_file, json_encode(GLOB.donators_list[which_one]))

GLOBAL_LIST_INIT(donators_list, list(
	"race" = load_donations("race"),
	"tails" = load_donations("tails"),
	"phoenix" = load_donations("phoenix"),
	"boosty" = load_donations("boosty")
))

GLOBAL_PROTECT(donators_list)
