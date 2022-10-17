/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(cat)
	category = cat
	..()

/proc/populate_gear_list()
	//create a list of gear datums to sort
	var/list/used_ids = list()
	for(var/geartype in subtypesof(/datum/gear))
		var/datum/gear/G = geartype

		var/use_name = initial(G.display_name)
		var/use_id = initial(G.id)
		if(!use_id) //Not set, generate fallback
			use_id = md5(use_name)
		var/use_category = initial(G.sort_category)

		if(G == initial(G.subtype_path))
			continue

		if(!use_name)
			//WARNING("Loadout - Missing display name: [G]")
			continue
		if(use_id in used_ids)
			WARNING("Loadout - ID Already Exists: [G], with ID:[use_id], Conflicts with: [used_ids[use_id]]")
			continue
		if(!initial(G.cost))
			WARNING("Loadout - Missing cost: [G]")
			continue
		if(!initial(G.path) && (use_category != "OOC" && use_category != "Роли")) //OOC category does not contain actual items
			WARNING("Loadout - Missing path definition: [G]")
			continue

		if(!GLOB.loadout_categories[use_category])
			GLOB.loadout_categories[use_category] = new /datum/loadout_category(use_category)
		used_ids[use_id] = G
		var/datum/loadout_category/LC = GLOB.loadout_categories[use_category]
		GLOB.gear_datums[use_id] = new geartype
		LC.gear[use_id] = GLOB.gear_datums[use_id]

	GLOB.loadout_categories = sort_assoc(GLOB.loadout_categories)
	for(var/loadout_category in GLOB.loadout_categories)
		var/datum/loadout_category/LC = GLOB.loadout_categories[loadout_category]
		LC.gear = sort_assoc(LC.gear)
	return TRUE

/datum/gear
	var/display_name       //Name. Should be unique.
	var/id                 //ID string. MUST be unique.
	var/description        //Description of this gear. If left blank will default to the description of the pathed item.
	var/path               //Path to item.
	var/cost = INFINITY           //Number of metacoins
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/list/species_blacklist //Stop certain species from receiving this gear
	var/list/species_whitelist //Only allow certain species to receive this gear
	var/sort_category = "Основное"
	var/subtype_path = /datum/gear //for skipping organizational subtypes (optional)
	var/icon_base64 = null

/datum/gear/New()
	..()
	id = md5(display_name)
	if(!description)
		var/obj/O = path
		description = initial(O.desc)

/datum/gear/proc/purchase(var/client/C) //Called when the gear is first purchased
	return TRUE

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(npath, nlocation)
	path = npath
	location = nlocation

/datum/gear/proc/spawn_item(location, metadata)
	var/datum/gear_data/gd = new(path, location)
	if(gd?.path)
		var/item = new gd.path(gd.location)
		return item
	return null

// Convinience proc.  Collects crap that fails to equip either onto the mob's back, or drops it.
// Used in job equipping so shit doesn't pile up at the start loc.
/mob/living/carbon/human/proc/equip_or_collect(var/obj/item/W, var/slot)
	if(W && W?.mob_can_equip(src, null, slot, TRUE, TRUE))
		//Mob can equip.  Equip it.
		equip_to_slot_or_del(W, slot)
	else
		//Mob can't equip it.  Put it in a bag B.
		// Do I have a backpack?
		var/obj/item/storage/B
		if(istype(back,/obj/item/storage))
			//Mob is wearing backpack
			B = back
		else
			//not wearing backpack.  Check if player holding box
			if(!is_holding_item_of_type(/obj/item/storage/box)) //If not holding box, give box
				B = new /obj/item/storage/box(null) // Null in case of failed equip.
				if(!put_in_hands(B))
					return // box could not be placed in players hands.  I don't know what to do here...
			//Now, B represents a container we can insert W into.
			if(!atom_storage.attempt_insert(W, usr, override = TRUE))
				qdel(B)
			return B

/datum/gear/proc/get_base64_icon_html()
	if(icon_base64)
		return "<img class='icon icon-misc' src='data:image/png;base64,[icon_base64]'>"
	icon_base64 = icon2base64(getFlatIcon(path2image(path), no_anim = TRUE))
	return "<img class='icon icon-misc' src='data:image/png;base64,[icon_base64]'>"
