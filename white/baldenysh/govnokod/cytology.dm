#define CELL_LINE_TABLE_SHVAINOKARAS "cell_line_shvainokaras_table"
#define CELL_LINE_TABLE_PIG "cell_line_pig_table"

/datum/micro_organism/cell_line/shvainokaras
	desc = "Химерические стволовые клетки цитоукраинского свинорыба"
	required_reagents = list(
						/datum/reagent/consumable/nutriment/protein,
						/datum/reagent/medicine/c2/synthflesh,
						/datum/reagent/consumable/nutriment)

	supplementary_reagents = list(
						/datum/reagent/consumable/cornoil = 4,
						/datum/reagent/toxin/carpotoxin = 2,
						/datum/reagent/consumable/cooking_oil = 2,
						/datum/reagent/consumable/nutriment/vitamin = 2)

	suppressive_reagents = list(
						/datum/reagent/toxin/bungotoxin = -6,
						/datum/reagent/oxygen = -3)

	virus_suspectibility = 1
	resulting_atoms = list(/mob/living/simple_animal/hostile/carp/ranged/chaos/hohol = 1)

/datum/micro_organism/cell_line/pig
	desc = "Sus stem cells"
	required_reagents = list(
						/datum/reagent/consumable/nutriment/protein,
						/datum/reagent/consumable/nutriment)

	supplementary_reagents = list(
						/datum/reagent/growthserum = 4,
						/datum/reagent/consumable/nutriment/vitamin = 2,
						/datum/reagent/consumable/rice = 2,
						/datum/reagent/consumable/flour = 1)

	suppressive_reagents = list(/datum/reagent/toxin = -2,
							/datum/reagent/toxin/carpotoxin = -5)

	virus_suspectibility = 1
	resulting_atoms = list(/mob/living/simple_animal/pet/dog/corgi/pig = 1)
