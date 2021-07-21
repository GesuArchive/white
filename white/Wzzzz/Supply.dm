//Хранилища



/obj/item/storage/toolbox/ammo/Kar98

/obj/item/storage/toolbox/ammo/Kar98/PopulateContents()
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)

/obj/item/storage/toolbox/ammo/STG

/obj/item/storage/toolbox/ammo/STG/PopulateContents()
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)

/obj/item/storage/toolbox/ammo/MP40

/obj/item/storage/toolbox/ammo/MP40/PopulateContents()
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)

/obj/item/storage/toolbox/ammo/G43

/obj/item/storage/toolbox/ammo/G43/PopulateContents()
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)

/obj/item/storage/toolbox/ammo/FG42

/obj/item/storage/toolbox/ammo/FG42/PopulateContents()
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)

/obj/item/storage/toolbox/ammo/AK47

/obj/item/storage/toolbox/ammo/AK47/PopulateContents()
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)

/obj/item/storage/toolbox/ammo/WT550

/obj/item/storage/toolbox/ammo/WT550/PopulateContents()
	new /obj/item/ammo_box/magazine/wt550m9/mc9mmt(src)
	new /obj/item/ammo_box/magazine/wt550m9/mc9mmt(src)
	new /obj/item/ammo_box/magazine/wt550m9/mc9mmt(src)
	new /obj/item/ammo_box/magazine/wt550m9/mc9mmt(src)
	new /obj/item/ammo_box/magazine/wt550m9/mc9mmt(src)
	new /obj/item/ammo_box/magazine/wt550m9/mc9mmt(src)
	new /obj/item/ammo_box/magazine/wt550m9/mc9mmt(src)

/datum/supply_pack/security/armory/carbine_single
	name = "Assault Carbine Single-Pack"
	desc = "Contains one Assault Carbine. Requires Armory access to open."
	cost = 650
	contains = list(/obj/item/gun/ballistic/automatic/carbine)
	goody = TRUE

/datum/supply_pack/security/armory/carbine
	name = "Assault Carbine Crate"
	desc = "Contains two Assault Carbines. Requires Armory access to open."
	cost = 1210
	contains = list(/obj/item/gun/ballistic/automatic/carbine,
					/obj/item/gun/ballistic/automatic/carbine)
	crate_name = "auto rifle crate"

/datum/supply_pack/security/armory/carbineammo
	name = "Assault Carbine Ammo Crate"
	desc = "Contains four 25-round magazine for the Assault Carbine. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 400
	contains = list(/obj/item/ammo_box/magazine/carbine,
					/obj/item/ammo_box/magazine/carbine,
					/obj/item/ammo_box/magazine/carbine,
					/obj/item/ammo_box/magazine/carbine)

/datum/supply_pack/security/armory/carbineammo_single
	name = "Assault Carbine Ammo Single-Pack"
	desc = "Contains a 25-round magazine for the Assault Carbine. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 125
	contains = list(/obj/item/ammo_box/magazine/carbine)
	goody = TRUE

/datum/supply_pack/security/armory/secalthard
	name = "Adv. Security Hardsuit Crate"
	desc = "Contains a Advanced Security Hardsuit. Requires Armory access to open."
	cost = 750
	contains = list(/obj/item/clothing/suit/space/hardsuit/rig_secb)

/datum/supply_pack/security/trau_s
	name = "Traumatic Pistol Single-Pack"
	desc = "Contains a single traumatic pistol. Requires Armory access to open."
	cost = 90
	contains = list(/obj/item/gun/ballistic/automatic/pistol/traumatic)

/datum/supply_pack/security/trau
	name = "Traumatic Pistol Crate"
	desc = "Contains a two traumatic pistols. Requires Armory access to open."
	cost = 150
	contains = list(/obj/item/gun/ballistic/automatic/pistol/traumatic,
					/obj/item/gun/ballistic/automatic/pistol/traumatic)

/datum/supply_pack/security/trau_a_s
	name = "Traumatic Pistol Ammo Single-Pack"
	desc = "Contains a 8-round magazine for traumatic pistol. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 25
	contains = list(/obj/item/ammo_box/magazine/traumatic)

/datum/supply_pack/security/trau_a
	name = "Traumatic Pistol Ammo Crate"
	desc = "Contains a 8-round magazine for traumatic pistol. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 60
	contains = list(/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic)

/datum/supply_pack/security/armory/mak_s
	name = "Makarov Pistol Single-Pack"
	desc = "Contains a single makarov pistol. Requires Armory access to open."
	cost = 200
	contains = list(/obj/item/gun/ballistic/automatic/pistol/makarov)

/datum/supply_pack/security/armory/mak
	name = "Makarov Pistol Crate"
	desc = "Contains a two makarov pistols. Requires Armory access to open."
	cost = 350
	contains = list(/obj/item/gun/ballistic/automatic/pistol/makarov,
					/obj/item/gun/ballistic/automatic/pistol/makarov)

/datum/supply_pack/security/armory/mak_a_s
	name = "Pistol 9mm Ammo Single-Pack"
	desc = "Contains a 15-round magazine for 9mm pistol. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 70
	contains = list(/obj/item/ammo_box/magazine/m9mm)

/datum/supply_pack/security/armory/mak_a
	name = "Pistol 9mm Ammo Crate"
	desc = "Contains a 15-round magazine for 9mm pistols. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 160
	contains = list(/obj/item/ammo_box/magazine/m9mm,
					/obj/item/ammo_box/magazine/m9mm,
					/obj/item/ammo_box/magazine/m9mm,
					/obj/item/ammo_box/magazine/m9mm)

/datum/supply_pack/security/armory/webvests
	name = "Advanced Vest Crate"
	desc = "Contains a two vest with pockets and bit more protection than usual vests. Requires Armory access to open."
	cost = 150
	contains = list(/obj/item/clothing/suit/armor/opvest,
					/obj/item/clothing/suit/armor/opvest)

/datum/supply_pack/medical/hardsuit
	name = "Medical Hardsuit Crate"
	desc = "Contains a medical hardsuit. Requires CMO access to open."
	cost = 350
	contains = list(/obj/item/clothing/suit/space/hardsuit/syndi/elite/medical_rig)

/datum/supply_pack/medical/pills
	name = "Universal Pill Bottle Crate"
	desc = "Contains 3 pill bottles with 2 epinephrine pills and 5 instabitaluri patches each of pill bottles. Requires CMO access to open."
	cost = 55
	contains = list(/obj/item/storage/pill_bottle/soldier,
					/obj/item/storage/pill_bottle/soldier,
					/obj/item/storage/pill_bottle/soldier)

/obj/item/storage/pill_bottle/soldier

/obj/item/storage/pill_bottle/soldier/PopulateContents()
	new /obj/item/reagent_containers/pill/epinephrine(src)
	new /obj/item/reagent_containers/pill/epinephrine(src)
	new /obj/item/reagent_containers/medigel/synthflesh(src)
	new /obj/item/reagent_containers/medigel/synthflesh(src)
	new /obj/item/reagent_containers/medigel/synthflesh(src)
	new /obj/item/reagent_containers/medigel/synthflesh(src)
	new /obj/item/reagent_containers/medigel/synthflesh(src)

/obj/item/storage/belt/military/army/n762

/obj/item/storage/belt/military/army/n762/PopulateContents()
	new /obj/item/ammo_box/a762	(src)
	new /obj/item/ammo_box/a762	(src)
	new /obj/item/gun/ballistic/automatic/pistol/aps(src)
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/grenade/flashbang	(src)
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/storage/pill_bottle/soldier(src)

/obj/item/storage/belt/military/army/range

/obj/item/storage/belt/military/army/range/PopulateContents()
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/reagent_containers/hypospray/medipen/survival(src)
	new /obj/item/grenade/syndieminibomb/concussion(src)
	new /obj/item/grenade/syndieminibomb/concussion(src)

/obj/item/storage/belt/military/assault/m556

/obj/item/storage/belt/military/assault/m556/PopulateContents()
	new /obj/item/ammo_box/magazine/m556(src)
	new /obj/item/ammo_box/magazine/m556(src)
	new /obj/item/ammo_box/magazine/m556(src)
	new /obj/item/ammo_box/a40mm(src)
	new /obj/item/gun/ballistic/automatic/pistol(src)
	new /obj/item/suppressor(src)

/obj/item/storage/belt/military/assault/gerMP40

/obj/item/storage/belt/military/assault/gerMP40/PopulateContents()
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mauser/battle(src)
	new /obj/item/grenade/frag(src)

/obj/item/storage/belt/military/assault/bull4

/obj/item/storage/belt/military/assault/bull4/PopulateContents()
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/ammo_box/magazine/m10mm/hp(src)
	new /obj/item/ammo_box/magazine/m10mm/ap(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g(src)

/obj/item/storage/belt/military/assault/c20r4

/obj/item/storage/belt/military/assault/c20r4/PopulateContents()
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/m10mm/hp(src)
	new /obj/item/ammo_box/magazine/m10mm/ap(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/grenade/syndieminibomb(src)

/obj/item/storage/belt/military/assault/p5

/obj/item/storage/belt/military/assault/p5/PopulateContents()
	new /obj/item/ammo_box/a357(src)
	new /obj/item/ammo_box/a357(src)
	new /obj/item/ammo_box/magazine/m10mm/hp(src)
	new /obj/item/ammo_box/magazine/m10mm/ap(src)
	new /obj/item/ammo_box/magazine/m10mm/fire(src)
	new /obj/item/grenade/syndieminibomb(src)

/obj/item/storage/belt/military/assault/m5

/obj/item/storage/belt/military/assault/m5/PopulateContents()
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/ammo_box/magazine/m10mm/hp(src)
	new /obj/item/ammo_box/magazine/m10mm/ap(src)
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/grenade/syndieminibomb(src)
	new /obj/item/grenade/syndieminibomb(src)

/obj/item/storage/belt/military/vest/terr5

/obj/item/storage/belt/military/vest/terr5/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/survival(src)
	new /obj/item/reagent_containers/hypospray/medipen/survival(src)
	new /obj/item/grenade/frag(src)
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/grenade/chem_grenade/incendiary(src)
	new /obj/item/grenade/chem_grenade/incendiary(src)
	new /obj/item/grenade/chem_grenade/incendiary(src)

/obj/item/storage/belt/military/assault/terr1

/obj/item/storage/belt/military/assault/terr1/PopulateContents()
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/grenade/frag(src)

/obj/item/storage/belt/military/assault/terr2

/obj/item/storage/belt/military/assault/terr2/PopulateContents()
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/grenade/smokebomb(src)
	new /obj/item/grenade/frag(src)
	new /obj/item/grenade/frag(src)

/obj/item/storage/belt/military/assault/STG

/obj/item/storage/belt/military/assault/STG/PopulateContents()
	new /obj/item/ammo_box/a357(src)
	new /obj/item/ammo_box/a357(src)
	new /obj/item/ammo_box/magazine/m10mm/hp(src)
	new /obj/item/ammo_box/magazine/m10mm/ap(src)
	new /obj/item/ammo_box/magazine/m10mm/fire(src)
	new /obj/item/grenade/syndieminibomb(src)