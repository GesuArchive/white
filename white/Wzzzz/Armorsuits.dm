//obj/item/clothing/suit/armor



/obj/item/clothing/suit/armor/vest/bulletproofsuit
	name = "bulletproof armour"
	desc = "Better bulletproof suit."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "bulletproof"
	siemens_coefficient = 0.7
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "bulletproof"
	armor = list("melee" = 42, "bullet" = 75, "laser" = 42,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 30)

/obj/item/clothing/suit/armor/vest/bulletproofsuit/vest
	name = "bulletproof vest"
	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "bulletproofvest"
	inhand_icon_state = "bulletproofvest"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 40, "bullet" = 80, "laser" = 20,"energy" = 0, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 30)

/obj/item/clothing/suit/bomb_suit/german
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "bombsuitsec"
	inhand_icon_state = "bombsuitsec"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 50, "bullet" = 50, "laser" = 20,"energy" = 10, "bomb" = 100, "bio" = 40, "rad" = 0, "fire" = 80, "acid" = 50)

/obj/item/clothing/suit/bomb_suit/german/bombsuitsecold
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "bombsuitsecold"
	inhand_icon_state = "bombsuitsecold"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 50, "bullet" = 50, "laser" = 20,"energy" = 10, "bomb" = 100, "bio" = 40, "rad" = 0, "fire" = 80, "acid" = 50)

/obj/item/clothing/suit/armor/hos/german
	icon_state = "hosg"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "hosg"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/armor/vest/swat_german
	name = "swat suit"
	desc = "Good suit for battles versus revolution or criminals."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "swatold"
	siemens_coefficient = 0.6
	inhand_icon_state = "swatold"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 50, "bullet" = 50, "laser" = 40,"energy" = 10, "bomb" = 70, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50)

/obj/item/clothing/suit/armor/vest/riot_german
	name = "swat suit"
	desc = "Good suit for battles versus revolution or criminals."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "riotold"
	siemens_coefficient = 0.7
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "riotold"
	armor = list("melee" = 75, "bullet" = 33, "laser" = 50,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 40)

/obj/item/clothing/suit/armor/vest/swatarmor_german
	name = "swat armor"
	desc = "Armor for swat and swat operations."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "swatarmor"
	siemens_coefficient = 0.5
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "swatarmor"
	armor = list("melee" = 60, "bullet" = 60, "laser" = 60,"energy" = 40, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 40)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/swatarmor

/obj/item/clothing/suit/armor/hos/trenchcoat/jensen
	name = "jensen trenchcoat"
	desc = "You never asked for anything that stylish."
	icon_state = "jensencoat"
	inhand_icon_state = "jensencoat"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/armor/vest/armorsec
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "armorsec"
	inhand_icon_state = "armorsec"

/obj/item/clothing/suit/armor/vest/german
	name = "armored vest"
	desc = "Protection."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 35, "bullet" = 35, "laser" = 30, "energy" = 40, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)
	icon_state = "kvest"
	inhand_icon_state = "kvest"
	body_parts_covered = CHEST

/obj/item/clothing/suit/armor/vest/german/mercwebvest
	icon_state = "mercwebvest"
	armor = list("melee" = 50, "bullet" = 40, "laser" = 35, "energy" = 50, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 60)
	inhand_icon_state = "mercwebvest"
	body_parts_covered = CHEST|LEGS
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/webvest

/obj/item/clothing/suit/armor/vest/german/webvest
	armor = list("melee" = 40, "bullet" = 40, "laser" = 35, "energy" = 40, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)
	icon_state = "webvest"
	inhand_icon_state = "webvest"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/webvest

/obj/item/clothing/suit/armor/vest/german/ntvest
	icon_state = "ntvest"
	inhand_icon_state = "ntvest"

/obj/item/clothing/suit/armor/vest/german/detvest
	icon_state = "detvest"
	inhand_icon_state = "detvest"

/obj/item/clothing/suit/armor/vest/german/solvest
	icon_state = "solvest"
	inhand_icon_state = "solvest"

/obj/item/clothing/suit/armor/vest/german/pcrcvest
	icon_state = "pcrcvest"
	inhand_icon_state = "pcrcvest"

/obj/item/clothing/suit/armor/vest/german/webvest/secwebvest
	icon_state = "secwebvest"
	inhand_icon_state = "secwebvest"

/obj/item/clothing/suit/armor/vest/german/webvest/comwebvest
	icon_state = "comwebvest"
	inhand_icon_state = "comwebvest"

/obj/item/clothing/suit/armor/vest/german/webvest/ntwebvest
	icon_state = "ntwebvest"
	inhand_icon_state = "ntwebvest"

/obj/item/clothing/suit/armor/vest/german/webvest/solwebvest
	icon_state = "solwebvest"
	inhand_icon_state = "solwebvest"

/obj/item/clothing/suit/armor/vest/german/webvest/pcrcwebvest
	icon_state = "pcrcwebvest"
	inhand_icon_state = "pcrcwebvest"

/obj/item/clothing/suit/armor/vest/german/ertarmor
	name = "ert armor"
	desc = "Usually ert use another protection, but that too exist."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 40, "energy" = 30, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 75, "acid" = 75)
	body_parts_covered = CHEST

/obj/item/clothing/suit/armor/vest/german/ertarmor/cmd
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ertarmor_cmd"
	inhand_icon_state = "ertarmor_cmd"

/obj/item/clothing/suit/armor/vest/german/ertarmor/med
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ertarmor_med"
	inhand_icon_state = "ertarmor_med"

/obj/item/clothing/suit/armor/vest/german/ertarmor/sec
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ertarmor_sec"
	inhand_icon_state = "ertarmor_esc"

/obj/item/clothing/suit/armor/vest/german/ertarmor/eng
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ertarmor_eng"
	inhand_icon_state = "ertarmor_eng"

/obj/item/clothing/suit/armor/vest/brig_phys_vest
	name = "psychologist vest"
	desc = "Looks like for security, but not fully, perhabs."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "brig_phys_vest"
	inhand_icon_state = "brig_phys_vest"
	body_parts_covered = CHEST
	armor = list("melee" = 15, "bullet" = 15, "laser" = 10,"energy" = 0, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 20, "acid" = 20)

/obj/item/clothing/suit/armor/vest/paramedic_vest
	name = "paramedic vest"
	desc = "Special vest for paramedics."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "paramedic_vest"
	inhand_icon_state = "paramedic_vest"
	body_parts_covered = CHEST
	armor = list("melee" = 15, "bullet" = 15, "laser" = 10,"energy" = 0, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 20, "acid" = 20)

/obj/item/clothing/suit/armor/riot/knight/heavy
	name = "heavy knight suit"
	desc = "A suit of semi-flexible polycarbonate body armor with heavy padding to protect against melee attacks. Helps the wearer resist shoving in close quarters."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "knight_grey"
	inhand_icon_state = "knight_grey"
	armor = list("melee" = 80, "bullet" = 75, "laser" = 40, "energy" = 25, "bomb" = 60, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 80)
	slowdown = 0.7

/obj/item/clothing/suit/armor/changeling
	icon = 'white/Wzzzz/clothing/suits.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list("melee" = 50, "bullet" = 60, "laser" = 20, "energy" = 15, "bomb" = 60, "bio" = 100, "rad" = 0, "fire" = 50, "acid" = 70)

/obj/item/clothing/suit/armor/vest/alt/blueshield
	name = "blueshield armor vest"
	desc = "Armor vest for forces of Blushield."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blueshield_old"
	armor = list("melee" = 35, "bullet" = 35, "laser" = 35, "energy" = 15, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50)
	inhand_icon_state = "blueshield_old"

/obj/item/clothing/suit/armor/vest/blueshield
	name = "blueshield armor vest"
	desc = "Armor vest for forces of Blushield."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blueshield"
	armor = list("melee" = 35, "bullet" = 35, "laser" = 35, "energy" = 15, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50)
	inhand_icon_state = "blueshield"

/obj/item/clothing/suit/armor/vest/leather/tailcoat
	name = "tail coat"
	desc = "Stylish armored coat."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "tailcoat"
	armor = list("melee" = 20, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 15)
	inhand_icon_state = "tailcoat"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/tailcoat

/obj/item/clothing/suit/armor/vest/leather/ladiesvictoriancoat
	name = "victorian coat"
	desc = "Stylish victorian coat."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ladiesvictoriancoat"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 5, "energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 5)
	inhand_icon_state = "ladiesvictoriancoat"

/obj/item/clothing/suit/armor/vest/leather/ladiesredvictoriancoat
	name = "victorian coat"
	desc = "Stylish victorian coat."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ladiesredvictoriancoat"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 5, "energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 5)
	inhand_icon_state = "ladiesredvictoriancoat"

/obj/item/clothing/suit/armor/vest/german/webvest/m_vest
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "m_vest"
	inhand_icon_state = "m_vest"
	name = "medical vest"
	desc = "Special vest for medics"

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/blackgrey
	icon = 'white/Wzzzz/pirha.dmi'
	inhand_icon_state = "syndievestbg"
	icon_state = "syndievestbg"
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/black
	icon = 'white/Wzzzz/pirha.dmi'
	inhand_icon_state = "syndievestg"
	icon_state = "syndievestg"
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/dark
	icon = 'white/Wzzzz/pirha.dmi'
	inhand_icon_state = "syndievestb"
	icon_state = "syndievestb"
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/armor/vest/warden/alt/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "warden_jacketg"
	inhand_icon_state = "warden_jacketg"

/obj/item/clothing/suit/armor/vest/warden/alt/black
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "warden_jacketb"
	inhand_icon_state = "warden_jacketb"

/obj/item/clothing/suit/armor/vest/warden/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "warden_altg"
	inhand_icon_state = "warden_altg"

/obj/item/clothing/suit/armor/vest/warden/black
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "warden_altb"
	inhand_icon_state = "warden_altb"

/obj/item/clothing/suit/armor/vest/leather/tailcoat/black
	icon_state = "tailcoatb"
	inhand_icon_state = "tailcoatb"

/obj/item/clothing/suit/armor/vest/leather/ladiesvictoriancoat/grey
	icon_state = "ladiesvictoriancoatg"
	inhand_icon_state = "ladiesvictoriancoatg"

/obj/item/clothing/suit/armor/vest/leather/ladiesvictoriancoat/black
	icon_state = "ladiesvictoriancoatb"
	inhand_icon_state = "ladiesvictoriancoatb"

/obj/item/clothing/suit/armor/riot
	name = "champion armor"
	desc = "You're champion..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "champarmor"
	inhand_icon_state = "champarmor"
	armor = list("melee" = 50, "bullet" = 50, "laser" = 20, "energy" = 10, "bomb" = 50, "bio" = 100, "rad" = 0, "fire" = 70, "acid" = 60)

/obj/item/clothing/suit/armor/riot/knight/champion
	name = "champion armor"
	desc = "You're space champion..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "star_champion"
	inhand_icon_state = "star_champion"
	armor = list("melee" = 60, "bullet" = 40, "laser" = 10, "energy" = 10, "bomb" = 50, "bio" = 100, "rad" = 0, "fire" = 70, "acid" = 60)

/obj/item/clothing/suit/armor/vest/german/mercwebvest/grey
	icon_state = "mercwebvestg"
	inhand_icon_state = "mercwebvestg"

/obj/item/clothing/suit/armor/vest/swatarmor_german/grey
	icon_state = "swatarmorg"
	inhand_icon_state = "swatarmorg"

/obj/item/clothing/suit/armor/vest/swatarmor_german/black
	icon_state = "swatarmorb"
	inhand_icon_state = "swatarmorb"

/obj/item/clothing/suit/armor/tac_hazmat
	name = "tactical hazmat suit"
	desc = "Armor for battle in hazard ."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "tac_hazmat"
	siemens_coefficient = 0.5
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "tac_hazmat"
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDENECK|HIDEJUMPSUIT
	visor_flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDENECK|HIDEJUMPSUIT
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50, "energy" = 30, "bomb" = 45, "bio" = 100, "rad" = 0, "fire" = 75, "acid" = 60)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/tac_hazmat

/obj/item/clothing/suit/armor/tac_hazmat/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/armor/bone
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "bonearmor"
	inhand_icon_state = "bonearmor"

/obj/item/clothing/suit/armor
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'

/obj/item/clothing/suit/armor/hauberk
	icon_state = "hauberk"
	inhand_icon_state = "hauberk"
	name = "hauberk"
	desc = "Cover your body by steel."
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 15)
	body_parts_covered = NONE|CHEST|HANDS|LEGS|GROIN
	cold_protection = NONE|CHEST|HANDS|LEGS|GROIN
	heat_protection = NONE|CHEST|HANDS|LEGS|GROIN

/obj/item/clothing/suit/armor/riot/knight
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "knight_simple1"
	inhand_icon_state = "knight_simple1"

/obj/item/clothing/suit/armor/vest
	body_parts_covered = NONE|CHEST
	cold_protection = NONE|CHEST
	heat_protection = NONE|CHEST
	desc = "Chest protection."

/obj/item/clothing/suit/armor/vest/leather
	icon_state = "leather_chestplate"
	inhand_icon_state = "leather_chestplate"
	name = "leather chestplate"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 5,"energy" = 3, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 15)

/obj/item/clothing/suit/armor/vest/leather/alt
	icon_state = "leather_armor2"
	inhand_icon_state = "leather_armor2"
	name = "leather chestplate"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 5,"energy" = 3, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 15)

/obj/item/clothing/suit/armor/vest/bronze
	icon_state = "bronze_chestplate"
	inhand_icon_state = "bronze_chestplate"
	name = "bronze chestplate"
	armor = list("melee" = 25, "bullet" = 17, "laser" = 10,"energy" = 7, "bomb" = 23, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 20)

/obj/item/clothing/suit/armor/vest/iron
	icon_state = "iron_chestplate"
	inhand_icon_state = "iron_chestplate"
	name = "iron chestplate"
	armor = list("melee" = 27, "bullet" = 20, "laser" = 15,"energy" = 8, "bomb" = 27, "bio" = 0, "rad" = 0, "fire" = 23, "acid" = 22)

/obj/item/clothing/suit/armor/vest/chain
	icon_state = "chainmailx"
	inhand_icon_state = "chainmailx"
	name = "chainmail"
	armor = list("melee" = 25, "bullet" = 20, "laser" = 20,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 15)

/obj/item/clothing/suit/armor/vest/iron/a
	icon_state = "iron_chestplater"
	inhand_icon_state = "iron_chestplater"

/obj/item/clothing/suit/armor/vest/iron/b
	icon_state = "iron_chestplateb"
	inhand_icon_state = "iron_chestplateb"

/obj/item/clothing/suit/armor/vest/iron/c
	icon_state = "iron_chestplatec"
	inhand_icon_state = "iron_chestplatec"

/obj/item/clothing/suit/armor/plate/crusader
	armor = list("melee" = 80, "bullet" = 65, "laser" = 100,"energy" = 100, "bomb" = 75, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)

/obj/item/clothing/suit/armor/opvest
	name = "armored vest"
	desc = "It provides some armor and some storage. Not really the best at either though."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "opvest"
	armor = list("melee" = 40, "bullet" = 35, "laser" = 40,"energy" = 35, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 30)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/opvest

/obj/item/clothing/suit/armor/vest/arbiter
	icon_state = "arbiter"

/obj/item/clothing/suit/armor/vest/m35
	icon_state = "army_coat"
	armor = list("melee" = 40, "bullet" = 50, "laser" = 40,"energy" = 35, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	heat_protection = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/armor/vest/m35/black
	icon_state = "elite_army_coat"
	armor = list("melee" = 40, "bullet" = 50, "laser" = 40,"energy" = 35, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'

/obj/item/clothing/suit/armor/vest/m35/officer
	icon_state = "super_elite_army_coat"
	armor = list("melee" = 50, "bullet" = 55, "laser" = 45,"energy" = 35, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 40)
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'