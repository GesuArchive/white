//Janitors!  Janitors, janitors, janitors!  -Sayu


//Conspicuously not-recent versions of suspicious cleanables

//This file was made not awful by Xhuis on September 13, 2016

//Making the station dirty, one tile at a time. Called by master controller's setup_objects

/turf/open/floor/proc/MakeDirty()
	// We start with a 1/3 chance of having this proc called by Initialize()

	if(!(flags_1 & CAN_BE_DIRTY_1))
		return

	if(locate(/obj/structure/grille) in contents)
		return

	var/area/A = get_area(src)

	if(A && !(A.flags_1 & CAN_BE_DIRTY_1))
		return

	if(prob(3))
		plating_fucked = TRUE
	else if(prob(30))
		floor_dents = TRUE

	var/static/list/high_dirt_areas = typecacheof(list(
		/area/science/test_area,
		/area/mine/production,
		/area/mine/living_quarters,
		/area/commons/vacant_room/office,
		/area/ruin/space
	))

	if(is_type_in_typecache(A, high_dirt_areas))
		new /obj/effect/decal/cleanable/dirt(src)
		return
	else if (prob(15))
		new /obj/effect/decal/cleanable/dirt(src)

	if(prob(33))
		return

	var/static/list/engine_dirt_areas = typecacheof(list(
		/area/engineering,
		/area/command/heads_quarters/ce,
		/area/science/robotics,
		/area/maintenance,
		/area/construction,
		/area/partyhard,
		/area/commons/vacant_room/commissary,
		/area/survivalpod
	))

	if(is_type_in_typecache(A, engine_dirt_areas))
		if(prob(3))
			new /obj/effect/decal/cleanable/blood/old(src)
		else
			switch (rand(1, 100))
				if(1 to 35)
					if(prob(4))
						new /obj/effect/decal/cleanable/robot_debris/old(src)
					else
						new /obj/effect/decal/cleanable/oil(src)
				if(35 to 96)
					new /obj/effect/decal/cleanable/dirt/dust(src)
				if(97 to 100)
					new /obj/effect/decal/cleanable/ants(src)
		return

	var/static/list/bathroom_dirt_areas = typecacheof(list(
		/area/commons/toilet,
		/area/awaymission/research/interior/bathroom
	))

	if(is_type_in_typecache(A, bathroom_dirt_areas))
		if(prob(40))
			if(prob(90))
				new /obj/effect/decal/cleanable/vomit/old(src)
			else
				new /obj/effect/decal/cleanable/blood/old(src)
		else if(prob(40))
			new /obj/effect/decal/cleanable/ants(src)
		return

	var/static/list/oily_areas = typecacheof(/area/cargo)
	if(is_type_in_typecache(A, oily_areas))
		if(prob(25))
			new /obj/effect/decal/cleanable/oil(src)
		return

	if(prob(35))
		return

	var/static/list/gib_covered_areas = typecacheof(list(
		/area/ai_monitored/turret_protected,
		/area/security,
		/area/command/heads_quarters/hos
	))

	if(is_type_in_typecache(A, gib_covered_areas))
		if(prob(20))
			if(prob(5))
				new /obj/effect/decal/cleanable/blood/gibs/old(src)
			else
				new /obj/effect/decal/cleanable/blood/old(src)
		return

	var/static/list/kitchen_dirt_areas = typecacheof(list(
		/area/service/kitchen,
		/area/service/cafeteria
	))

	if(is_type_in_typecache(A, kitchen_dirt_areas))
		if(prob(60))
			if(prob(50))
				new /obj/effect/decal/cleanable/food/egg_smudge(src)
			else
				new /obj/effect/decal/cleanable/food/flour(src)
		else if(prob(20))
			new /obj/effect/decal/cleanable/ants(src)
		return

	var/static/list/medical_dirt_areas = typecacheof(list(
		/area/medical,
		/area/command/heads_quarters/cmo
	))

	if(is_type_in_typecache(A, medical_dirt_areas))
		if(prob(66))
			if(prob(5))
				new /obj/effect/decal/cleanable/blood/gibs/old(src)
			else
				new /obj/effect/decal/cleanable/blood/old(src)
		else if(prob(30))
			if(istype(A, /area/medical/morgue))
				new /obj/item/ectoplasm(src)
			else
				new /obj/effect/decal/cleanable/vomit/old(src)
		return

	var/static/list/science_dirt_areas = typecacheof(list(
		/area/science,
		/area/command/heads_quarters/rd
	))

	if(is_type_in_typecache(A, science_dirt_areas))
		if(prob(20))
			new /obj/effect/decal/cleanable/greenglow/filled(src)
		return

	return TRUE
