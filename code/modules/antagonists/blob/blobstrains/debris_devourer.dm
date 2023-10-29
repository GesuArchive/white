#define DEBRIS_DENSITY (length(core.contents) / (length(overmind.blobs_legit) * 0.25)) // items per blob

// Accumulates junk liberally
/datum/blobstrain/debris_devourer
	name = "Пожиратель мусора"
	description = "запустит скопившиеся обломки в цели."
	analyzerdescdamage = "Наносит средний грубый урон и может цепляться за оружие ближнего боя."
	analyzerdesceffect = "Пожирает незакрепленные предметы, оставленные на станции, и выпускает их при атаке или нападении."
	color = "#8B1000"
	complementary_color = "#00558B"
	blobbernaut_message = "лупит"
	message = "Масса лупит меня"


/datum/blobstrain/debris_devourer/attack_living(mob/living/L, list/nearby_blobs)
	send_message(L)
	for (var/obj/structure/blob/blob in nearby_blobs)
		debris_attack(L, blob)

/datum/blobstrain/debris_devourer/on_sporedeath(mob/living/spore)
	var/obj/structure/blob/special/core/core = overmind.blob_core
	for(var/i in 1 to 3)
		var/obj/item/I = pick(core.contents)
		if (I && !QDELETED(I))
			I.forceMove(get_turf(spore))
			I.throw_at(get_edge_target_turf(spore,pick(GLOB.alldirs)), 6, 5, spore, TRUE, FALSE, null, 3)

/datum/blobstrain/debris_devourer/expand_reaction(obj/structure/blob/B, obj/structure/blob/newB, turf/T, mob/camera/blob/O, coefficient = 1) //when the blob expands, do this
	for (var/obj/item/I in T)
		I.forceMove(overmind.blob_core)

/datum/blobstrain/debris_devourer/proc/debris_attack(mob/living/L, source)
	var/obj/structure/blob/special/core/core = overmind.blob_core
	if (prob(40 * DEBRIS_DENSITY)) // Pretend the items are spread through the blob and its mobs and not in the core.
		var/obj/item/I = pick(core.contents)
		if (I && !QDELETED(I))
			I.forceMove(get_turf(source))
			I.throw_at(L, 6, 5, overmind, TRUE, FALSE, null, 3)

/datum/blobstrain/debris_devourer/blobbernaut_attack(mob/living/L, mob/living/blobbernaut) // When this blob's blobbernaut attacks people
	debris_attack(L,blobbernaut)

/datum/blobstrain/debris_devourer/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag, coefficient = 1) //when the blob takes damage, do this
	var/obj/structure/blob/special/core/core = overmind.blob_core
	return round(max((coefficient*damage)-min(coefficient*DEBRIS_DENSITY, 10), 0)) // reduce damage taken by items per blob, up to 10

/datum/blobstrain/debris_devourer/examine(mob/user)
	. = ..()
	. += "<hr>"
	var/obj/structure/blob/special/core/core = overmind.blob_core
	if (isobserver(user))
		. += span_notice("Поглощенный мусор в настоящее время снижает входящий урон на [round(max(min(DEBRIS_DENSITY, 10),0))]")
	else
		switch (round(max(min(DEBRIS_DENSITY, 10),0)))
			if (0)
				. += span_notice("В настоящее время недостаточно поглощенного мусора, чтобы уменьшить урон.")
			if (1 to 3)
				. += span_notice("Поглощенный мусор в настоящее время снижает входящий урон на очень небольшую величину.")  // these roughly correspond with force description strings
			if (4 to 7)
				. += span_notice("Поглощенный мусор в настоящее время снижает входящий урон на небольшую величину.")
			if (8 to 10)
				. += span_notice("Поглощенный мусор в настоящее время снижает входящий урон на средний уровень.")

#undef DEBRIS_DENSITY
