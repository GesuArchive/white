/*
 * Job related
 */

//Botanist
/obj/item/clothing/suit/apron
	name = "фартук"
	desc = "Стандартный синий фартук."
	icon_state = "apron"
	inhand_icon_state = "apron"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	allowed = list(/obj/item/reagent_containers/spray/plantbgone, /obj/item/plant_analyzer, /obj/item/seeds, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/beaker, /obj/item/cultivator, /obj/item/reagent_containers/spray/pestspray, /obj/item/hatchet, /obj/item/storage/bag/plants, /obj/item/graft, /obj/item/secateurs, /obj/item/geneshears, /obj/item/watertank)
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/apron/waders
	name = "болотники садовода"
	desc = "Пара тяжелых кожаных болотников, идеально защищающие вашу мягкую кожу от брызг, земли и шипов."
	icon_state = "hort_waders"
	inhand_icon_state = "hort_waders"
	body_parts_covered = CHEST|GROIN|LEGS
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 0, ACID = 0)

//Captain
/obj/item/clothing/suit/captunic
	name = "парадная туника капитана"
	desc = "Носит капитан, чтобы показать свой класс."
	icon_state = "captunic"
	inhand_icon_state = "bio_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	allowed = list(/obj/item/disk, /obj/item/stamp, /obj/item/reagent_containers/food/drinks/flask, /obj/item/melee, /obj/item/storage/lockbox/medal, /obj/item/assembly/flash/handheld, /obj/item/storage/box/matches, /obj/item/lighter, /obj/item/clothing/mask/cigarette, /obj/item/storage/fancy/cigarettes, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)

//Chef
/obj/item/clothing/suit/toggle/chef
	name = "фартук шеф-повара"
	desc = "Фартук-куртка от шеф-повара высшего класса."
	icon_state = "chef"
	inhand_icon_state = "chef"
	gas_transfer_coefficient = 0.9
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 0, ACID = 0)
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(/obj/item/kitchen, /obj/item/storage/bag/tray)
	togglename = "sleeves"
	species_exception = list(/datum/species/golem)

//Cook
/obj/item/clothing/suit/apron/chef
	name = "фартук повара"
	desc = "Стандартный, унылый, белый передник повара."
	icon_state = "apronchef"
	inhand_icon_state = "apronchef"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	allowed = list(/obj/item/kitchen, /obj/item/storage/bag/tray)

//Detective
/obj/item/clothing/suit/det_suit
	name = "плащ"
	desc = "Многоцелевой плащ 18-го века. Тот, кто носит это, значит что он серьёзный бизнесмен."
	icon_state = "detective"
	inhand_icon_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list(MELEE = 25, BULLET = 10, LASER = 25, ENERGY = 35, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 45)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/det_suit/Initialize(mapload)
	. = ..()
	allowed = GLOB.detective_vest_allowed

/obj/item/clothing/suit/det_suit/grey
	name = "нуарный плащ"
	desc = "Серый плащ из сваренного вкрутую частного детектива."
	icon_state = "greydet"
	inhand_icon_state = "greydet"

/obj/item/clothing/suit/det_suit/noir
	name = "нуарное пальто"
	desc = "Серый пиджак частного детектива."
	icon_state = "detsuit"
	inhand_icon_state = "detsuit"

/obj/item/clothing/suit/det_suit/kim
	name = "aerostatic bomber jacket"
	desc = "A jacket once worn by the revolutionary air brigades during the Antecentennial Revolution. There are quite a few pockets on the inside, mostly for storing notebooks and compasses."
	icon_state = "aerostatic_bomber_jacket"
	inhand_icon_state = "aerostatic_bomber_jacket"

/obj/item/clothing/suit/det_suit/disco
	name = "disco ass blazer"
	desc = "Looks like someone skinned this blazer off some long extinct disco-animal. It has an enigmatic white rectangle on the back and the right sleeve."
	icon_state = "jamrock_blazer"
	inhand_icon_state = "jamrock_blazer"

//Engineering
/obj/item/clothing/suit/hazardvest
	name = "спасательный жилет"
	desc = "Жилет повышенной видимости, используемый в рабочих зонах."
	icon_state = "hazard"
	inhand_icon_state = "hazard"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/watertank, /obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/t_scanner, /obj/item/radio, /obj/item/storage/bag/construction, /obj/item/tank/jetpack)
	resistance_flags = NONE
	species_exception = list(/datum/species/golem)

//janitor
/obj/item/clothing/suit/hazardvest/janitor
	name = "куртка уборщика"
	desc = "Куртка немного защищающая владельца от различных угроз."
	icon_state = "hazard_janitor"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 70, RAD = 50, FIRE = 30, ACID = 70)

//Lawyer
/obj/item/clothing/suit/toggle/lawyer
	name = "синий пиджак"
	desc = "Яркий."
	icon_state = "suitjacket_blue"
	inhand_icon_state = "suitjacket_blue"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	togglename = "buttons"
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/toggle/lawyer/purple
	name = "фиолетовый пиджак"
	desc = "Фетишист."
	icon_state = "suitjacket_purp"
	inhand_icon_state = "suitjacket_purp"

/obj/item/clothing/suit/toggle/lawyer/black
	name = "чёрный пиджак"
	desc = "Профессиональный."
	icon_state = "suitjacket_black"
	inhand_icon_state = "ro_suit"


//Mime
/obj/item/clothing/suit/toggle/suspenders
	name = "подтяжки"
	desc = "Они приостанавливают иллюзию игры мима."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "suspenders"
	worn_icon_state = "suspenders"
	blood_overlay_type = "armor" //it's the less thing that I can put here
	togglename = "straps"
	species_exception = list(/datum/species/golem)

//Security
/obj/item/clothing/suit/security/officer
	name = "куртка охранника"
	desc = "Эта куртка предназначена для тех особых случаев, когда сотруднику службы безопасности не требуется носить свои доспехи."
	icon_state = "officerbluejacket"
	inhand_icon_state = "officerbluejacket"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/security/warden
	name = "куртка надзирателя"
	desc = "Идеально подходит для надзирателя, который хочет оставить впечатление стиля у тех, кто посещает бриг."
	icon_state = "wardenbluejacket"
	inhand_icon_state = "wardenbluejacket"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/security/hos
	name = "куртка начальника охраны"
	desc = "Этот предмет одежды был специально разработан для утверждения высшей власти."
	icon_state = "hosbluejacket"
	inhand_icon_state = "hosbluejacket"
	body_parts_covered = CHEST|ARMS

//Surgeon
/obj/item/clothing/suit/apron/surgical
	name = "хирургический фартук"
	desc = "Стерильный синий хирургический фартук."
	icon_state = "surgical"
	allowed = list(/obj/item/scalpel, /obj/item/surgical_drapes, /obj/item/cautery, /obj/item/hemostat, /obj/item/retractor)

//Curator
/obj/item/clothing/suit/curator
	name = "пальто охотника за сокровищами"
	desc = "И модная, и слегка бронированная, эта куртка любима охотниками за сокровищами всей галактики."
	icon_state = "curator"
	inhand_icon_state = "curator"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(/obj/item/tank/internals, /obj/item/melee/curator_whip, /obj/item/storage/bag/books)
	armor = list(MELEE = 25, BULLET = 10, LASER = 25, ENERGY = 35, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 45)
	cold_protection = CHEST|ARMS
	heat_protection = CHEST|ARMS


//Robotocist

/obj/item/clothing/suit/hooded/techpriest
	name = "одежда техножреца"
	desc = "Для тех, кто ДЕЙСТВИТЕЛЬНО любит свои тостеры."
	icon_state = "techpriest"
	inhand_icon_state = "techpriest"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/techpriest

/obj/item/clothing/head/hooded/techpriest
	name = "капюшон техножреца"
	desc = "Капюшон для тех, кто ДЕЙСТВИТЕЛЬНО любит свои тостеры."
	icon_state = "techpriesthood"
	inhand_icon_state = "techpriesthood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS
