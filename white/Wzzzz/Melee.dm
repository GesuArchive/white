/obj/item/melee/sabre/marine
	name = "marine sword"
	desc = "A curved sword issued to german marines"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "marinesword"
	inhand_icon_state = "marinesword"
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/belt.dmi'
	slot_flags = ITEM_SLOT_BELT
	flags_1 = CONDUCT_1
	force = 20
	throwforce = 7
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 30
	armour_penetration = 25
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/rapierhit.ogg'
	custom_materials = list(/datum/material/iron = 500)

/obj/item/melee/sabre/officer
	name = "officer sword"
	desc = "A curved sword issued to german officers"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "officersword"
	inhand_icon_state = "officersword"
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/belt.dmi'
	slot_flags = ITEM_SLOT_BELT
	flags_1 = CONDUCT_1
	force = 20
	throwforce = 7
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 30
	armour_penetration = 20
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/rapierhit.ogg'
	custom_materials = list(/datum/material/iron = 500)

/obj/item/melee/sabre/marineofficer
	name = "marine officer sword"
	desc = "A curved sword issued to german marine officers"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "marineofficersword"
	inhand_icon_state = "marineofficersword"
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/belt.dmi'
	slot_flags = ITEM_SLOT_BELT
	flags_1 = CONDUCT_1
	force = 28
	throwforce = 7
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 45
	armour_penetration = 15
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/rapierhit.ogg'
	custom_materials = list(/datum/material/iron = 500)

/obj/item/melee/sabre/pettyofficer
	name = "pettyofficer sword"
	desc = "A curved sword issued to german petty officers"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "pettyofficersword"
	inhand_icon_state = "pettyofficersword"
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/belt.dmi'
	slot_flags = ITEM_SLOT_BELT
	flags_1 = CONDUCT_1
	force = 25
	throwforce = 7
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 50
	armour_penetration = 20
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/rapierhit.ogg'
	custom_materials = list(/datum/material/iron = 500)

/obj/item/melee/sabre/german
	name = "german sabre"
	desc = "A good weapon in melee battle"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "sabre"
	inhand_icon_state = "sabre"
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/belt.dmi'
	slot_flags = ITEM_SLOT_BELT
	flags_1 = CONDUCT_1
	force = 30
	throwforce = 5
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 65
	armour_penetration = 35
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/rapierhit.ogg'
	custom_materials = list(/datum/material/iron = 500)

/obj/item/melee/classic_baton/german // здесь был реба и я официально заявляю что я ебал зергиверги в очко
	name = "резиновая дубинка"
	desc = "Резиновая палка 'ПР-60' с поперечной рукояткой, классический инвентарь служб охраны и символ демократии, выполненная из резиновой смеси. Используется для обездвиживания различных криминальных элементов."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "baton"
	cooldown = 20
	inhand_icon_state = "baton"
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/belt.dmi'
	worn_icon_state = "baton"
	slot_flags = ITEM_SLOT_BELT

/obj/item/melee/club
	icon_state = "club"
	inhand_icon_state = "club"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	name = "club"
	desc = "Heavy strong club from somewhere"
	w_class = WEIGHT_CLASS_BULKY
	force = 25
	throwforce = 3
	throw_speed = 2
	armour_penetration = 30
	custom_materials = list(/datum/material/iron=2000)

/obj/item/kitchen/knife/german
	name = "combat knife"
	desc = "A german military combat knife."
	embedding = list("embedded_pain_multiplier" = 2, "embed_chance" = 50, "embedded_fall_chance" = 5, "embedded_ignore_throwspeed_threshold" = TRUE)
	force = 20
	icon_state = "knife"
	inhand_icon_state = "knife"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	throwforce = 15
	bayonet = TRUE
	custom_price = 0

/obj/item/melee/baton/loaded/german
	desc = "A german stun baton."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/belt.dmi'

/obj/item/kitchen/knife/butcher/machete
	name = "machete"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "machete"
	inhand_icon_state = "machete"
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/belt.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 23
	throwforce = 10
	block_chance = 30
	armour_penetration = 15
	sharpness = 5
	custom_materials = list(/datum/material/iron = 550)

/obj/item/melee/cultblade
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_BACK

/obj/item/melee/cultblade/great
	force = 75
	throwforce = 40
	block_chance = 70

/obj/item/kitchen/knife/butcher/gladius
	name = "gladius"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	icon_state = "gladius"
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_BACK
	force = 16
	throwforce = 10
	block_chance = 25
	armour_penetration = 10
	sharpness = 4
	inhand_icon_state = "gladius"
	worn_icon_state = "gladius"

/obj/item/shield/riot/buckler/med
	name = "roman buckler"
	desc = "Roman little shield."
	icon_state = "roman_buckler"
	inhand_icon_state = "roman_buckler"
	worn_icon_state = "roman_buckler"
	slot_flags = ITEM_SLOT_BACK
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/back.dmi'
	block_chance = 40
	force = 7

/obj/item/shield/riot/buckler/med/blue
	name = "blue buckler"
	desc = "Blue..."
	icon_state = "blue_buckler"
	inhand_icon_state = "blue_buckler"
	worn_icon_state = "blue_buckler"

/obj/item/shield/riot/buckler/med/red
	name = "red buckler"
	desc = "Red..."
	icon_state = "red_buckler"
	inhand_icon_state = "red_buckler"
	worn_icon_state = "red_buckler"

/obj/item/shield/riot/buckler/med/templar
	name = "templar shield"
	desc = "God's protection"
	icon_state = "shield_templar"
	inhand_icon_state = "shield_templar"
	worn_icon_state = "shield_templar"
	block_chance = 60
	obj_integrity = 250
	max_integrity = 250
	force = 10

/obj/item/shield/riot/buckler/med/steel
	name = "steel shield"
	desc = "Rough material, rough protection"
	icon_state = "steel_shield"
	inhand_icon_state = "steel_shield"
	worn_icon_state = "steel_shield"
	obj_integrity = 150
	max_integrity = 150
	force = 10

/obj/item/medwep
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/back.dmi'

/obj/item/medwep/pilum
	name = "pilum"
	desc = "Weak to fight, strong to throw."
	icon_state = "pilum"
	force = 10
	throw_speed = 3
	throwforce = 23
	block_chance = 10
	sharpness = 1
	throw_range = 10
	embedding = list("embedded_fall_chance" = 0,
	"embedded_fall_pain_multiplier" = 9,
	"embedded_impact_pain_multiplier" = 2,
	"embedded_pain_chance" = 30,
	"embedded_pain_multiplier" = 3,
	"embedded_unsafe_removal_pain_multiplier" = 7,
	"embedded_unsafe_removal_time" = 60,
	"embed_chance" = 90,
	"embedded_ignore_throwspeed_threshold" = TRUE)
	slot_flags = ITEM_SLOT_BACK
	var/missed = TRUE
	sharpness = SHARP_POINTY

obj/item/medwep/pilum/embedded(atom/target)
	if(isbodypart(target))
		missed = FALSE

/obj/item/medwep/halberd
	name = "halberd"
	desc = "Spear and axe in one."
	icon_state = "halberd"
	force = 9
	throw_speed = 2
	throwforce = 10
	block_chance = 30
	sharpness = 3
	throw_range = 3
	embedding = list("embedded_fall_chance" = 20,
	"embedded_fall_pain_multiplier" = 1,
	"embedded_impact_pain_multiplier" = 3,
	"embedded_pain_chance" = 80,
	"embedded_pain_multiplier" = 5,
	"embedded_unsafe_removal_pain_multiplier" = 6,
	"embedded_unsafe_removal_time" = 20,
	"embed_chance" = 10,
	"embedded_ignore_throwspeed_threshold" = TRUE)
	slot_flags = ITEM_SLOT_BACK
	var/wielded = FALSE
	w_class = WEIGHT_CLASS_HUGE

/obj/item/medwep/halberd/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed,  force_wielded=20, require_twohands=TRUE)

/obj/item/medwep/pike
	name = "pike"
	desc = "Spear."
	icon_state = "pike"
	force = 15
	throw_speed = 2
	throwforce = 12
	block_chance = 15
	sharpness = 2
	throw_range = 6
	embedding = list("embedded_fall_chance" = 10,
	"embedded_fall_pain_multiplier" = 4,
	"embedded_impact_pain_multiplier" = 3,
	"embedded_pain_chance" = 10,
	"embedded_pain_multiplier" = 2,
	"embedded_unsafe_removal_pain_multiplier" = 7,
	"embedded_unsafe_removal_time" = 30,
	"embed_chance" = 65,
	"embedded_ignore_throwspeed_threshold" = TRUE)
	slot_flags = ITEM_SLOT_BACK

/obj/item/medwep/rake
	name = "rake"
	desc = "Rake."
	icon_state = "rake"
	force = 12
	throw_speed = 2
	throwforce = 12
	block_chance = 8
	sharpness = 0
	throw_range = 5
	embedding = list("embedded_fall_chance" = 10,
	"embedded_fall_pain_multiplier" = 3,
	"embedded_impact_pain_multiplier" = 4,
	"embedded_pain_chance" = 25,
	"embedded_pain_multiplier" = 3,
	"embedded_unsafe_removal_pain_multiplier" = 6,
	"embedded_unsafe_removal_time" = 30,
	"embed_chance" = 35,
	"embedded_ignore_throwspeed_threshold" = TRUE)
	slot_flags = ITEM_SLOT_BACK

/obj/item/kitchen/knife
	embedding = list("embedded_fall_chance" = 10,
	"embedded_fall_pain_multiplier" = 3,
	"embedded_impact_pain_multiplier" = 4,
	"embedded_pain_chance" = 25,
	"embedded_pain_multiplier" = 3,
	"embedded_unsafe_removal_pain_multiplier" = 6,
	"embedded_unsafe_removal_time" = 30,
	"embed_chance" = 35,
	"embedded_ignore_throwspeed_threshold" = TRUE)