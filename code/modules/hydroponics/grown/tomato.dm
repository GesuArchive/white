// Tomato
/obj/item/seeds/tomato
	name = "Пачка семян помидора"
	desc = "Эти семена вырастают в помидорку."
	icon_state = "seed-tomato"
	species = "tomato"
	plantname = "Tomato Plants"
	product = /obj/item/food/grown/tomato
	maturation = 8
	instability = 25
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "tomato-grow"
	icon_dead = "tomato-dead"
	genes = list(/datum/plant_gene/trait/squash, /datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/tomato/blue, /obj/item/seeds/tomato/blood, /obj/item/seeds/tomato/killer)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	graft_gene = /datum/plant_gene/trait/squash

/obj/item/food/grown/tomato
	seed = /obj/item/seeds/tomato
	name = "Помидор"
	desc = "Какое ужасное выступление! Дайте мне помидор!"
	icon_state = "tomato"
	splat_type = /obj/effect/decal/cleanable/food/tomato_smudge
	bite_consumption_mod = 2
	foodtypes = FRUIT
	grind_results = list(/datum/reagent/consumable/ketchup = 0)
	juice_results = list(/datum/reagent/consumable/tomatojuice = 0)
	distill_reagent = /datum/reagent/consumable/enzyme

// Blood Tomato
/obj/item/seeds/tomato/blood
	name = "Пачка семян кровавого помидора"
	desc = "Эти семена вырастут в кровавый помидор."
	icon_state = "seed-bloodtomato"
	species = "bloodtomato"
	plantname = "Blood-Tomato Plants"
	product = /obj/item/food/grown/tomato/blood
	mutatelist = list()
	reagents_add = list(/datum/reagent/blood = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = 20

/obj/item/food/grown/tomato/blood
	seed = /obj/item/seeds/tomato/blood
	name = "Кровавый помидор"
	desc = "Такие жидкие... Кровавые... Так завораживает!"
	icon_state = "bloodtomato"
	splat_type = /obj/effect/gibspawner/generic
	foodtypes = FRUIT | GROSS
	grind_results = list(/datum/reagent/consumable/ketchup = 0, /datum/reagent/blood = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/bloody_mary

// Blue Tomato
/obj/item/seeds/tomato/blue
	name = "Пачка семян синего помидора"
	desc = "Эти семена вырастают в синий помидор."
	icon_state = "seed-bluetomato"
	species = "bluetomato"
	plantname = "Blue-Tomato Plants"
	product = /obj/item/food/grown/tomato/blue
	yield = 2
	icon_grow = "bluetomato-grow"
	mutatelist = list(/obj/item/seeds/tomato/blue/bluespace)
	genes = list(/datum/plant_gene/trait/slip, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/lube = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = 20
	graft_gene = /datum/plant_gene/trait/slip

/obj/item/food/grown/tomato/blue
	seed = /obj/item/seeds/tomato/blue
	name = "Синий помидор"
	desc = "Почему он синий? Ему холодно?"
	icon_state = "bluetomato"
	splat_type = /obj/effect/decal/cleanable/oil
	distill_reagent = /datum/reagent/consumable/laughter

// Bluespace Tomato
/obj/item/seeds/tomato/blue/bluespace
	name = "Пачка семян блюспейс помидора"
	desc = "Эти семена вырастают в магические помидорки."
	icon_state = "seed-bluespacetomato"
	species = "bluespacetomato"
	plantname = "Bluespace Tomato Plants"
	product = /obj/item/food/grown/tomato/blue/bluespace
	yield = 2
	mutatelist = list()
	genes = list(/datum/plant_gene/trait/squash, /datum/plant_gene/trait/slip, /datum/plant_gene/trait/teleport, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/lube = 0.2, /datum/reagent/bluespace = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = 50
	graft_gene = /datum/plant_gene/trait/teleport

/obj/item/food/grown/tomato/blue/bluespace
	seed = /obj/item/seeds/tomato/blue/bluespace
	name = "Блюспейс помидор"
	desc = "Настолько скользкий, что заставит тебя пролететь сквозь пространственное время."
	icon_state = "bluespacetomato"
	distill_reagent = null
	wine_power = 80

/obj/item/food/grown/tomato/blue/bluespace/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	AddElement(/datum/element/plant_backfire, /obj/item/food/grown/tomato/blue/bluespace.proc/splat_user, extra_genes = list(/datum/plant_gene/trait/squash))

/*
 * Splat our tomato on our user. Called from [/datum/element/plant_backfire]
 *
 * user - the mob handling the bluespace tomato
 */
/obj/item/food/grown/tomato/blue/bluespace/proc/splat_user(mob/living/carbon/user)
	if(prob(50))
		to_chat(user, span_danger("[src] slips out of your hand!"))
		attack_self(user)

// Killer Tomato
/obj/item/seeds/tomato/killer
	name = "Пачка семян томата-убийцы"
	desc = "Эти семена вырастут в томатов-убийц."
	icon_state = "seed-killertomato"
	species = "killertomato"
	plantname = "Killer-Tomato Plants"
	product = /obj/item/food/grown/tomato/killer
	yield = 2
	genes = list(/datum/plant_gene/trait/squash)
	growthstages = 2
	icon_grow = "killertomato-grow"
	icon_harvest = "killertomato-harvest"
	icon_dead = "killertomato-dead"
	mutatelist = list()
	rarity = 30

/obj/item/food/grown/tomato/killer
	seed = /obj/item/seeds/tomato/killer
	name = "Томат-убийца"
	desc = "Ужасный актёр, дайте поми... АААААААААААААА, МОИ НОГИ!!!"
	icon_state = "killertomato"
	var/awakening = 0
	distill_reagent = /datum/reagent/consumable/ethanol/demonsblood

/obj/item/food/grown/tomato/killer/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	AddElement(/datum/element/plant_backfire, /obj/item/food/grown/tomato/killer.proc/early_awaken, extra_genes = list(/datum/plant_gene/trait/squash))

/obj/item/food/grown/tomato/killer/attack(mob/M, mob/user, def_zone)
	if(awakening)
		to_chat(user, span_warning("Помидор дёргается и виляет, не давая его съесть."))
		return
	..()

/obj/item/food/grown/tomato/killer/attack_self(mob/user)
	if(awakening || isspaceturf(user.loc))
		return
	to_chat(user, span_notice("Пробуждаю томата-убийцу..."))
	begin_awaken(3 SECONDS)
	log_game("[key_name(user)] awakened a killer tomato at [AREACOORD(user)].")

/*
 * Begin the process of awakening the killer tomato.
 *
 * awaken_time - the time, in seconds, it will take for the tomato to spawn.
 */
/obj/item/food/grown/tomato/killer/proc/begin_awaken(awaken_time)
	awakening = TRUE
	addtimer(CALLBACK(src, .proc/awaken), awaken_time)

/*
 * Actually awaken the killer tomato, spawning the killer tomato mob.
 */
/obj/item/food/grown/tomato/killer/proc/awaken()
	if(QDELETED(src))
		return
	var/mob/living/simple_animal/hostile/killertomato/K = new /mob/living/simple_animal/hostile/killertomato(get_turf(src.loc))
	K.maxHealth += round(seed.endurance / 3)
	K.melee_damage_lower += round(seed.potency / 10)
	K.melee_damage_upper += round(seed.potency / 10)
	K.move_to_delay -= round(seed.production / 50)
	K.health = K.maxHealth
	K.visible_message(span_notice("Томат-убийца дико рычит и внезапно пробуждается."))
	qdel(src)

/*
 * Wakes up our tomato early. Called from [/datum/element/plant_backfire]
 *
 * user - the mob handling the killer tomato
 */
/obj/item/food/grown/tomato/killer/proc/early_awaken(mob/living/carbon/user)
	if(!awakening && prob(25))
		to_chat(user, span_danger("[src] begins to growl and shake!"))
		begin_awaken(1 SECONDS)
