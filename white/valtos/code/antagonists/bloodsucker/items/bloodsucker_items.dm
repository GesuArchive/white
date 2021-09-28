


// For blood packs, etc. that need new functions for when they're used.


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// RECIPES: When crafting objects in craft.dm, we now record who made the item.
///atom/movable
//	var/mob/crafter // Who made me? (via Craft skill)  Used by Bloodsucker crypt furniture to know who gets to use the buildings.


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//   BLOOD BAGS! Add ability to drank em


/obj/item/reagent_containers/blood/attack(mob/M, mob/user, def_zone)

	if(user.a_intent == INTENT_HELP && reagents.total_volume > 0)
		if (user != M)
			user.visible_message(span_userdanger("[user] forces [M] to drink from the [src].") , \
							  	span_notice("You put the [src] up to [M] mouth."))
			if (!do_mob(user, M, 50))
				return
		else
			if (!do_mob(user, M, 10))
				return
			user.visible_message(span_notice("[user] puts the [src] up to their mouth.") , \
		  		span_notice("You take a sip from the [src]."))

		// Safety: In case you spam clicked the blood bag on yourself, and it is now empty (below will divide by zero)
		if (reagents.total_volume <= 0)
			return

		// Taken from drinks.dm //
		var/gulp_size = 5
		var/fraction = min(gulp_size / reagents.total_volume, 1)
		//checkLiked(fraction, M) // Blood isn't food, sorry.
		reagents.expose(M, INGEST, fraction)
		reagents.trans_to(M, gulp_size)
		playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)

	..()


