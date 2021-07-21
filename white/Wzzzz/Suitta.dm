//obj/item/clothing/suit



/obj/item/clothing/suit/imperium_monk/german
	icon_state = "imperium_monk"
	inhand_icon_state = "imperium_monk"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	flags_inv = HIDEHAIR|HIDEEARS|256
	visor_flags_inv = HIDEHAIR|HIDEEARS|256
	armor = list("melee" = 30, "bullet" = 10, "laser" = 20,"energy" = 30, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 10)

/obj/item/clothing/suit/wizrobe/psyamp
	icon_state = "psyamp"
	actions_types = list(/obj/effect/proc_holder/spell/targeted/projectile/magic_missile)
	flags_inv = NONE
	inhand_icon_state = "psyamp"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	clothing_flags = STOPSPRESSUREDAMAGE
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	resistance_flags = NONE|ACID_PROOF|INDESTRUCTIBLE|UNACIDABLE
	armor = list("melee" = 500, "bullet" = 500, "laser" = 500,"energy" = 500, "bomb" = 500, "bio" = 500, "rad" = 500, "fire" = 0, "acid" = 500)

/obj/item/clothing/suit/radiation/german
	icon_state = "rad"
	inhand_icon_state = "rad"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/radiation/germanold
	icon_state = "rad_old"
	inhand_icon_state = "rad_old"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/hazardvest/green
	icon_state = "hazard_g"
	inhand_icon_state = "hazard_g"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/hazardvest/white
	icon_state = "hazard_w"
	inhand_icon_state = "hazard_w"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/hazardvest/blue
	icon_state = "hazard_b"
	inhand_icon_state = "hazard_b"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/sweater
	name = "sweater"
	desc = "Comfortable and warm"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sweater"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	heat_protection = CHEST|GROIN
	cold_protection = 200
	min_cold_protection_temperature = 60
	inhand_icon_state = "sweater"

/obj/item/clothing/suit/nttunic
	name = "NT tunic"
	desc = "Do you weared tunic early?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "nttunic"
	inhand_icon_state = "nttunic"

/obj/item/clothing/suit/nttunic/black
	icon_state = "nttunicblack"
	inhand_icon_state = "nttunicblack"

/obj/item/clothing/suit/boring
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'

/obj/item/clothing/suit/boring/thawb
	desc = "What is thawb?"
	name = "thawb"
	icon_state = "thawb"
	inhand_icon_state = "thawb"

/obj/item/clothing/suit/boring/sherwani
	desc = "Sherwani"
	name = "sherwani"
	icon_state = "sherwani"
	inhand_icon_state = "sherwani"

/obj/item/clothing/suit/boring/qipao
	desc = "Qipao"
	name = "qipao"
	icon_state = "qipao"
	inhand_icon_state = "qipao"

/obj/item/clothing/suit/boring/ubacblack
	desc = "Ubac"
	name = "ubac"
	icon_state = "ubacblack"
	inhand_icon_state = "ubacblack"
	body_parts_covered = CHEST|GROIN
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/boring/ubactan
	desc = "Ubac"
	name = "ubac"
	icon_state = "ubactan"
	inhand_icon_state = "ubactan"
	body_parts_covered = CHEST|GROIN
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/boring/ubacgreen
	desc = "ubacgreen"
	name = "ubacgreen"
	body_parts_covered = CHEST|GROIN
	icon_state = "ubacgreen"
	inhand_icon_state = "ubacgreen"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/boring/dashiki
	desc = "What is dashiki?"
	name = "dashiki"
	icon_state = "dashiki"
	inhand_icon_state = "dashiki"

/obj/item/clothing/suit/boring/dashiki/red
	icon_state = "dashikired"
	inhand_icon_state = "dashikired"

/obj/item/clothing/suit/boring/dashiki/blue
	icon_state = "dashikiblue"
	inhand_icon_state = "dashikiblue"

/obj/item/clothing/suit/gentlecoat
	icon_state = "gentlecoat"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "gentlecoat"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/leather_jacket
	name = "leather jacket"
	desc = "Leather jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "leather_jacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "leather_jacket"

/obj/item/clothing/suit/mbill
	name = "jacket"
	desc = "Jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "mbill"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "mbill"

/obj/item/clothing/suit/towel
	name = "towel"
	desc = "Space, war and you with towel"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "towel"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "towel"

/obj/item/clothing/suit/suitjacket_purp
	name = "jacket purple"
	desc = "Like Gulman?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "suitjacket_purp"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "suitjacket_purp"

/obj/item/clothing/suit/surgical
	name = "surgical vest"
	desc = "For true surgery"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "surgical"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "surgical"

/obj/item/clothing/suit/mantle_unathi
	name = "mantle"
	desc = "Something old or wild"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "mantle_unathi"
	body_parts_covered = CHEST
	inhand_icon_state = "mantle_unathi"

/obj/item/clothing/suit/robe_unathi
	name = "robe"
	desc = "Low technologies"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "robe_unathi"
	body_parts_covered = CHEST|GROIN
	inhand_icon_state = "robe_unathi"

/obj/item/clothing/suit/forensics_blue
	name = "forensics jacket"
	desc = "Wow, real forensics?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "forensics_blue"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "forensics_blue"

/obj/item/clothing/suit/forensics_red
	name = "forensics jacket"
	desc = "Wow, real forensics?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "forensics_red"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "forensics_red"

/obj/item/clothing/suit/blueponcho
	desc = "Blue poncho"
	name = "blue poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blueponcho"
	inhand_icon_state = "blueponcho"

/obj/item/clothing/suit/purpleponcho
	desc = "Purple poncho"
	name = "purple poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "purpleponcho"
	inhand_icon_state = "purpleponcho"

/obj/item/clothing/suit/secponcho
	desc = "Security poncho"
	name = "secutiry poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "secponcho"
	inhand_icon_state = "secponcho"

/obj/item/clothing/suit/medponcho
	desc = "Medical poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	name = "medical poncho"
	icon_state = "medponcho"
	inhand_icon_state = "medponcho"

/obj/item/clothing/suit/engiponcho
	desc = "Engineer poncho"
	name = "engineer poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "engiponcho"
	inhand_icon_state = "engiponcho"

/obj/item/clothing/suit/cargoponcho
	desc = "Cargo poncho"
	name = "cargo poncho"
	icon_state = "cargoponcho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	inhand_icon_state = "cargoponcho"

/obj/item/clothing/suit/sciponcho
	desc = "Science poncho"
	name = "science poncho"
	icon_state = "sciponcho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	inhand_icon_state = "sciponcho"

/obj/item/clothing/suit/pvest
	desc = "Vest"
	name = "vest"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "pvest"
	inhand_icon_state = "pvest"

/obj/item/clothing/suit/blackservice
	name = "blackservice jacket"
	desc = "Blackservice"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blackservice"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "blackservice"

/obj/item/clothing/suit/blackservice/crew
	icon_state = "blackservice_crew"
	inhand_icon_state = "blackservice_crew"

/obj/item/clothing/suit/blackservice/med
	icon_state = "blackservice_med"
	inhand_icon_state = "blackservice_med"

/obj/item/clothing/suit/blackservice/medcom
	icon_state = "blackservice_medcom"
	inhand_icon_state = "blackservice_medcom"

/obj/item/clothing/suit/blackservice/eng
	icon_state = "blackservice_eng"
	inhand_icon_state = "blackservice_eng"

/obj/item/clothing/suit/blackservice/engcom
	icon_state = "pvest_engcom"
	inhand_icon_state = "pvest_engcom"

/obj/item/clothing/suit/blackservice/sup
	icon_state = "blackservice_sup"
	inhand_icon_state = "blackservice_sup"

/obj/item/clothing/suit/blackservice/sec
	icon_state = "blackservice_sec"
	inhand_icon_state = "blackservice_sec"

/obj/item/clothing/suit/blackservice/seccom
	icon_state = "blackservice_seccom"
	inhand_icon_state = "blackservice_seccom"

/obj/item/clothing/suit/blackservice/com
	icon_state = "blackservice_com"
	inhand_icon_state = "blackservice_com"

/obj/item/clothing/suit/greenservice
	name = "greenservice jacket"
	desc = "Greenservice"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 20)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "greenservice"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "greenservice"

/obj/item/clothing/suit/greenservice/med
	icon_state = "greenservice_med"
	inhand_icon_state = "greenservice_med"

/obj/item/clothing/suit/greenservice/medcom
	icon_state = "greenservice_medcom"
	inhand_icon_state = "greenservice_medcom"

/obj/item/clothing/suit/greenservice/eng
	icon_state = "greenservice_eng"
	inhand_icon_state = "greenservice_eng"

/obj/item/clothing/suit/greenservice/engcom
	icon_state = "greenservice_engcom"
	inhand_icon_state = "greenservice_engcom"

/obj/item/clothing/suit/greenservice/sup
	icon_state = "greenservice_sup"
	inhand_icon_state = "greenservice_sup"

/obj/item/clothing/suit/greenservice/sec
	icon_state = "greenservice_sec"

/obj/item/clothing/suit/sciponcho_heph
	desc = "Poncho for area of knowledge"
	name = "scientist poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sciponcho_heph"
	inhand_icon_state = "sciponcho_heph"

/obj/item/clothing/suit/sciponcho_zeng
	desc = "Poncho for area of knowledge"
	name = "scientist poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sciponcho_zeng"
	inhand_icon_state = "sciponcho_zeng"

/obj/item/clothing/suit/sciponcho
	desc = "Poncho for area of knowledge"
	name = "scientist poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sciponcho"
	inhand_icon_state = "sciponcho"

/obj/item/clothing/suit/sciponcho_nt
	desc = "Poncho for area of knowledge"
	name = "scientist poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sciponcho_nt"
	inhand_icon_state = "sciponcho_nt"

/obj/item/clothing/suit/militaryjacket
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 15, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 20)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/service_co_coat
	name = "service jacket"
	desc = "Jacket for scientists."
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 50, "rad" = 10, "fire" = 30, "acid" = 40)
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/militaryjacket/desert
	name = "desert jacket"
	desc = "Desert military jacket"
	icon_state = "desertmiljacket"
	inhand_icon_state = "desertmiljacket"

/obj/item/clothing/suit/militaryjacket/sec
	name = "security jacket"
	desc = "Security military jacket"
	icon_state = "secmiljacket"
	inhand_icon_state = "secmiljacket"

/obj/item/clothing/suit/militaryjacket/navy
	name = "navy jacket"
	desc = "Navy military jacket"
	icon_state = "navymiljacket"
	inhand_icon_state = "navymiljacket"

/obj/item/clothing/suit/greymiljacket
	name = "grey jacket"
	desc = "Grey military jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 25, "bullet" = 15, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 20)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "greymiljacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "greymiljacket"

/obj/item/clothing/suit/hooded/wintercoat/science/zeng
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience_zeng"
	inhand_icon_state = "coatscience_zeng"

/obj/item/clothing/suit/hooded/wintercoat/science/heph
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience_heph"
	inhand_icon_state = "coatscience_heph"

/obj/item/clothing/suit/hooded/wintercoat/science/dais
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience_dais"
	inhand_icon_state = "coatscience_dais"

/obj/item/clothing/suit/hooded/wintercoat/science/alt
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience1"
	inhand_icon_state = "coatscience1"

/obj/item/clothing/suit/hooded/wintercoat/science/nt
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience_nt"
	inhand_icon_state = "coatscience_nt"

/obj/item/clothing/suit/m_dress
	name = "jacket"
	desc = "Just jacket"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "m_dress"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "m_dress"

/obj/item/clothing/suit/m_dress_int
	name = "jacket"
	desc = "Just jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon_state = "m_dress_int"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "m_dress_int"

/obj/item/clothing/suit/m_service
	name = "jacket"
	desc = "Just jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon_state = "m_service"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "m_service"

/obj/item/clothing/suit/m_service_int
	name = "jacket"
	desc = "Just jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon_state = "m_service_int"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "m_service_int"

/obj/item/clothing/suit/infsuit
	name = "jacket"
	desc = "Just jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon_state = "infsuit"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "infsuit"

	inhand_icon_state = "greenservice_sec"

/obj/item/clothing/suit/greenservice/seccom
	icon_state = "greenservice_seccom"
	inhand_icon_state = "greenservice_seccom"

/obj/item/clothing/suit/greenservice/com
	icon_state = "greenservice_com"
	inhand_icon_state = "greenservice_com"

/obj/item/clothing/suit/greydress
	name = "greydress jacket"
	desc = "Greydress"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "greydress"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "greydress"

/obj/item/clothing/suit/greydress/com
	icon_state = "greydress_com"
	inhand_icon_state = "greydress_com"

/obj/item/clothing/suit/blackdress
	name = "blackdress jacket"
	desc = "Blackdress"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blackdress"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "blackdress"

/obj/item/clothing/suit/doctor_vest
	name = "doctor vest"
	desc = "For doctor"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "doctor_vest"
	body_parts_covered = CHEST
	inhand_icon_state = "doctor_vest"

/obj/item/clothing/suit/blackdress/com
	icon_state = "blackdress_com"
	inhand_icon_state = "blackdress_com"

/obj/item/clothing/suit/fire/atmos/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "atmos_firesuitg"
	inhand_icon_state = "atmos_firesuitg"

/obj/item/clothing/suit/fire/atmos/black
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "atmos_firesuitb"
	inhand_icon_state = "atmos_firesuitb"

/obj/item/clothing/suit/fire/firefighter
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/fire/firefighter/grey
	icon_state = "firesuitg"
	inhand_icon_state = "firesuitg"

/obj/item/clothing/suit/fire/firefighter/black
	icon_state = "firesuitb"
	inhand_icon_state = "firesuitb"

/obj/item/clothing/suit/hospitalgown
	name = "hospital vest"
	desc = "Hospital going down..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "hospitalgown"
	inhand_icon_state = "hospitalgown"
	body_parts_covered = CHEST

/obj/item/clothing/suit/infdress
	name = "dress"
	desc = "infdress.png"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "infdress"
	inhand_icon_state = "infdress"
	body_parts_covered = CHEST|GROIN|LEGS

/obj/item/clothing/suit/chaplainsuit/holidaypriest
	name = "oracle suit"
	desc = "You're space oracle..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "star_oracle"
	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF|UNACIDABLE|LAVA_PROOF|INDESTRUCTIBLE
	inhand_icon_state = "star_oracle"
	armor = list("melee" = 50, "bullet" = 50, "laser" = 40, "energy" = 40, "bomb" = 40, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 50, "magic" = 100)

/obj/item/clothing/suit/hazmat
	name = "hazmat suit"
	desc = "Suit for hazard environments."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "hazmat_yellow"
	siemens_coefficient = 0.5
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "hazmat_yellow"
	armor = list("melee" = 10, "bullet" = 5, "laser" = 10, "energy" = 10, "bomb" = 15, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 90)
	dynamic_hair_suffix = ""

/obj/item/clothing/suit/hazmat/white
	inhand_icon_state = "hazmat_white"
	icon_state = "hazmat_white"

/obj/item/clothing/suit/hazmat/cmo
	inhand_icon_state = "hazmat_cmo"
	icon_state = "hazmat_cmo"

/obj/item/clothing/suit/hazmat/cyan
	inhand_icon_state = "hazmat_cyan"
	icon_state = "hazmat_cyan"

/obj/item/clothing/suit/pirate
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "piratejacket1"
	inhand_icon_state = "piratejacket1"

/obj/item/clothing/suit/pirate/alt
	icon_state = "piratejacket5"
	inhand_icon_state = "piratejacket5"

/obj/item/clothing/suit/pirate/jacket
	icon_state = "piratejacket4"
	inhand_icon_state = "piratejacket4"

/obj/item/clothing/suit/pirate/jacket/alt
	icon_state = "piratejacket3"
	inhand_icon_state = "piratejacket3"

/obj/item/clothing/suit/pirate/officer
	desc = "Between soldier and captain."

/obj/item/clothing/suit/pirate/officer/british
	name = "british officer coat"
	icon_state = "british_officer"
	inhand_icon_state = "british_officer"

/obj/item/clothing/suit/pirate/officer/portuguese
	name = "portuguese officer coat"
	icon_state = "portuguese_officer"
	inhand_icon_state = "portuguese_officer"

/obj/item/clothing/suit/pirate/officer/dutch
	name = "dutch officer coat"
	icon_state = "dutch_officer"
	inhand_icon_state = "dutch_officer"

/obj/item/clothing/suit/pirate/officer/french
	name = "french officer coat"
	icon_state = "french_officer"
	inhand_icon_state = "french_officer"

/obj/item/clothing/suit/pirate/officer/spanish
	name = "british officer coat"
	icon_state = "spanish_officer"
	inhand_icon_state = "spanish_officer"

/obj/item/clothing/suit/pirate/captain
	desc = "Valuable like captain's skills."

/obj/item/clothing/suit/pirate/captain/british
	icon_state = "british_captain"
	inhand_icon_state = "british_captain"

/obj/item/clothing/suit/pirate/captain/portuguese
	icon_state = "portuguese_captain"
	inhand_icon_state = "portuguese_captain"

/obj/item/clothing/suit/pirate/captain/spanish
	icon_state = "spanish_captain"
	inhand_icon_state = "spanish_captain"

/obj/item/clothing/suit/pirate/captain/french
	icon_state = "french_captain"
	inhand_icon_state = "french_captain"

/obj/item/clothing/suit/pirate/captain/dutch
	icon_state = "dutch_captain"
	inhand_icon_state = "dutch_captain"

/obj/item/clothing/suit/pirate/army
	body_parts_covered = NONE|CHEST|ARMS
	name = "british army jacket"
	desc = "War with fashion instead protection."
	inhand_icon_state = "british_army"
	icon_state = "british_army"
	cold_protection = NONE|CHEST|ARMS
	heat_protection = NONE|CHEST|ARMS

/obj/item/clothing/suit/pirate/army/dutch
	name = "dutch army jacket"
	inhand_icon_state = "dutch_army"
	icon_state = "dutch_army"

/obj/item/clothing/suit/pirate/army/portuguese
	name = "portuguese army jacket"
	inhand_icon_state = "portuguese_army"
	icon_state = "portuguese_army"

/obj/item/clothing/suit/pirate/army/french
	name = "french army jacket"
	inhand_icon_state = "french_army"
	icon_state = "french_army"

/obj/item/clothing/suit/pirate/civ_jacket
	name = "jacket"
	desc = "Looks good, costs small."
	inhand_icon_state = "civ_jacket"
	icon_state = "civ_jacket"

/obj/item/clothing/suit/wizrobe/battlemage
	icon_state = "battlemage"
	inhand_icon_state = "battlemage"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	slowdown = 0.7
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	resistance_flags = NONE|ACID_PROOF|INDESTRUCTIBLE|UNACIDABLE|FIRE_PROOF|FREEZE_PROOF|LAVA_PROOF
	armor = list("melee" = 80, "bullet" = 60, "laser" = 70,"energy" = 80, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "magic" = 75)

/obj/item/clothing/suit/bio_suit/scientist/alt
	icon_state = "bio_scientist"
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon = 'white/Wzzzz/pirha.dmi'

/obj/item/storage/backpack/drip
	name = "Drip"
	desc = "Wuooow!"
	icon_state = "drip"
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon = 'white/Wzzzz/pirha.dmi'
	max_integrity = 1.#INF
	obj_integrity = 1.#INF
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_ICLOTHING|ITEM_SLOT_OCLOTHING