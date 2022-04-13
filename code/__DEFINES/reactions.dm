//Defines used in atmos gas reactions. Used to be located in ..\modules\atmospherics\gasmixtures\reactions.dm, but were moved here because fusion added so fucking many.

//Plasma fire properties
#define OXYGEN_BURN_RATIO_BASE 1.4
#define PLASMA_BURN_RATE_DELTA 9
//Amount of heat released per mole of burnt carbon into the tile
#define FIRE_CARBON_ENERGY_RELEASED	100000
//Amount of heat released per mole of burnt hydrogen and/or tritium(hydrogen isotope)
#define FIRE_HYDROGEN_ENERGY_RELEASED 280000
//Amount of heat released per mole of burnt plasma into the tile
#define FIRE_PLASMA_ENERGY_RELEASED 3000000
//General assmos defines.
#define WATER_VAPOR_FREEZE 200
//freon reaction
#define FREON_BURN_RATE_DELTA 4
//amount of heat absorbed per mole of burnt freon in the tile
#define FIRE_FREON_ENERGY_RELEASED -300000

#define N2O_DECOMPOSITION_MIN_ENERGY 1400
#define N2O_DECOMPOSITION_ENERGY_RELEASED 200000

#define NITRYL_DECOMPOSITION_ENERGY 30000
#define NITRYL_FORMATION_ENERGY 100000
#define NITROUS_FORMATION_ENERGY 10000
// - Tritium:
/// What fraction of the oxygen content of the mix is used for the burn rate in an oxygen-poor mix.
#define TRITIUM_BURN_OXY_FACTOR 100
/// What fraction of the tritium content of the mix is used for the burn rate in an oxygen-rich mix.
#define TRITIUM_BURN_TRIT_FACTOR 10
// The neutrons gotta go somewhere. Completely arbitrary number.
#define TRITIUM_BURN_RADIOACTIVITY_FACTOR 50000
// minimum 0.01 moles trit or 10 moles oxygen to start producing rads
#define TRITIUM_MINIMUM_RADIATION_ENERGY 0.1
//! This is calculated to help prevent singlecap bombs(Overpowered tritium/oxygen single tank bombs)
#define MINIMUM_TRIT_OXYBURN_ENERGY 2000000
//hydrogen reaction
#define HYDROGEN_BURN_OXY_FACTOR 100
#define HYDROGEN_BURN_H2_FACTOR 10
//This is calculated to help prevent singlecap bombs(Overpowered hydrogen/oxygen single tank bombs)
#define MINIMUM_H2_OXYBURN_ENERGY 2000000
//metal hydrogen
#define METAL_HYDROGEN_MINIMUM_HEAT 1e7
#define METAL_HYDROGEN_MINIMUM_PRESSURE 1e7
#define METAL_HYDROGEN_FORMATION_ENERGY 20000000
#define SUPER_SATURATION_THRESHOLD 96
#define STIMULUM_HEAT_SCALE 100000
#define REACTION_OPPRESSION_THRESHOLD 5
#define NOBLIUM_FORMATION_ENERGY 2e9
//Research point amounts
#define NOBLIUM_RESEARCH_AMOUNT 1000
#define BZ_RESEARCH_SCALE 4
#define BZ_RESEARCH_MAX_AMOUNT 400
#define MIASMA_RESEARCH_AMOUNT 40
#define STIMULUM_RESEARCH_AMOUNT 50
//Plasma fusion properties
// Mole count required (tritium/plasma) to start a fusion reaction
#define FUSION_MOLE_THRESHOLD 250
#define FUSION_TRITIUM_CONVERSION_COEFFICIENT 0.002
#define INSTABILITY_GAS_POWER_FACTOR 3
#define FUSION_TRITIUM_MOLES_USED 1
#define PLASMA_BINDING_ENERGY 20000000
// changing it by 0.1 generally doubles or halves fusion temps
#define TOROID_CALCULATED_THRESHOLD 5.96
#define FUSION_TEMPERATURE_THRESHOLD 10000
#define PARTICLE_CHANCE_CONSTANT (-20000000)
#define FUSION_INSTABILITY_ENDOTHERMALITY 2
// Used to be Pi
#define FUSION_SCALE_DIVISOR 10
#define FUSION_MINIMAL_SCALE 50
// This number is probably the safest number to change
#define FUSION_SLOPE_DIVISOR 1250
// This number is probably the most dangerous number to change
#define FUSION_ENERGY_TRANSLATION_EXPONENT 1.25
// This number is responsible for orchestrating fusion temperatures
#define FUSION_BASE_TEMPSCALE 6
// If you decrease this by one, the fusion rads will *triple* and vice versa
#define FUSION_RAD_MIDPOINT 15
// This number is deceptively dangerous; sort of tied to TOROID_CALCULATED_THRESHOLD
#define FUSION_MIDDLE_ENERGY_REFERENCE 1e6
// Increase this to cull unrobust fusions faster
#define FUSION_BUFFER_DIVISOR 1
