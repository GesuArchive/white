/datum/fantasy_affix/cosmetic_prefixes
	placement = AFFIX_PREFIX
	alignment = AFFIX_GOOD | AFFIX_EVIL

	var/list/goodPrefixes
	var/list/badPrefixes

/datum/fantasy_affix/cosmetic_prefixes/New()
	goodPrefixes = list(
		"большой",
		"главный",
		"благословенный",
		"превосходный",
		"усиленный",
		"отточенный",
		"истинный",
		"славный",
		"крепкий",
		)
	badPrefixes = list(
		"меньший",
		"незначительный",
		"испорченный",
		"низший",
		"ослабленный",
		"ржавый",
		"неустойчивый",
		"трагический",
		"забитый",
		"проклятый",
		)

	weight = (length(goodPrefixes) + length(badPrefixes)) * 10

/datum/fantasy_affix/cosmetic_prefixes/apply(datum/component/fantasy/comp, newName)
	if(comp.quality > 0 || (comp.quality == 0 && prob(50)))
		return "[pick(goodPrefixes)] [newName]"
	else
		return "[pick(badPrefixes)] [newName]"

/datum/fantasy_affix/tactical
	placement = AFFIX_PREFIX
	alignment = AFFIX_GOOD
	weight = 1 // Very powerful, no one should have such power

/datum/fantasy_affix/tactical/apply(datum/component/fantasy/comp, newName)
	var/obj/item/master = comp.parent
	comp.appliedComponents += master.AddComponent(/datum/component/tactical)
	return "тактический [newName]"

/datum/fantasy_affix/pyromantic
	placement = AFFIX_PREFIX
	alignment = AFFIX_GOOD

/datum/fantasy_affix/pyromantic/apply(datum/component/fantasy/comp, newName)
	var/obj/item/master = comp.parent
	comp.appliedComponents += master.AddComponent(/datum/component/igniter, clamp(comp.quality, 1, 10))
	return "пиромантический [newName]"

/datum/fantasy_affix/vampiric
	placement = AFFIX_PREFIX
	alignment = AFFIX_GOOD
	weight = 5

/datum/fantasy_affix/vampiric/apply(datum/component/fantasy/comp, newName)
	var/obj/item/master = comp.parent
	comp.appliedComponents += master.AddComponent(/datum/component/lifesteal, comp.quality)
	return "вампирический [newName]"

/datum/fantasy_affix/beautiful
	placement = AFFIX_PREFIX
	alignment = AFFIX_GOOD

/datum/fantasy_affix/beautiful/apply(datum/component/fantasy/comp, newName)
	var/obj/item/master = comp.parent
	master.AddComponent(/datum/component/beauty, max(comp.quality, 1) * 250)
	return "[pick("эстетичный", "красивый", "великолепный", "симпатичный")] [newName]"

/datum/fantasy_affix/beautiful/remove(datum/component/fantasy/comp)
	var/obj/item/master = comp.parent
	master.AddComponent(/datum/component/beauty, -max(comp.quality, 1) * 250)

/datum/fantasy_affix/ugly
	placement = AFFIX_PREFIX
	alignment = AFFIX_EVIL

/datum/fantasy_affix/ugly/apply(datum/component/fantasy/comp, newName)
	var/obj/item/master = comp.parent
	master.AddComponent(/datum/component/beauty, min(comp.quality, -1) * 250)
	return "[pick("унылый", "уродливый", "гротескный", "отвратительный")] [newName]"

/datum/fantasy_affix/ugly/remove(datum/component/fantasy/comp)
	var/obj/item/master = comp.parent
	master.AddComponent(/datum/component/beauty, -min(comp.quality, -1) * 250)
