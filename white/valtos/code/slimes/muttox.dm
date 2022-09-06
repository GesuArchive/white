/datum/reagent/mutationtoxin/random
	name = "Unstable Mutation Toxin"
	description = "Страшно стать плазмаменом?"
	color = "#13BC9E"

/datum/reagent/mutationtoxin/random/on_mob_life(mob/living/carbon/human/H)
	if(ishuman(H))

		var/list/pickable_races = list()
		for(var/speciestype in subtypesof(/datum/species))
			var/datum/species/S = speciestype
			if(initial(S.changesource_flags) & MIRROR_MAGIC)
				pickable_races += initial(S.id)
		pickable_races = sort_list(pickable_races)

		to_chat(H, span_warning("ПРЕВРАЩАЮСЬ!"))
		var/species_type = pick(pickable_races)
		H.set_species(species_type)
		holder.del_reagent(type)
		return TRUE
	return ..()
