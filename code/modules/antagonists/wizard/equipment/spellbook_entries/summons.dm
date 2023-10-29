// Ritual spells which affect the station at large
/// How much threat we need to let these rituals happen on dynamic
#define MINIMUM_THREAT_FOR_RITUALS 100

/datum/spellbook_entry/summon/ghosts
	name = "Призыв Призраков"
	desc = "Напугайте команду, заставив их увидеть души мёртвый. \
		Имейте в виду, призраки капризны и иногда мстительны, \
		а некоторые будут использовать свои невероятно незначительные способности, чтобы напакостить вам."
	cost = 0

/datum/spellbook_entry/summon/ghosts/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book)
	summon_ghosts(user)
	playsound(get_turf(user), 'sound/effects/ghost2.ogg', 50, TRUE)
	return ..()

/datum/spellbook_entry/summon/guns
	name = "Призыв Оружия"
	desc = "Что может пойти не так, если вооружить команду сумасшедших, которые только и ждут повода, чтобы убить тебя? \
		Есть хороший шанс, что они сначала перестреляют друг друга."

/datum/spellbook_entry/summon/guns/can_be_purchased()
	// Must be config enabled
	return !CONFIG_GET(flag/no_summon_guns)

/datum/spellbook_entry/summon/guns/buy_spell(mob/living/carbon/human/user,obj/item/spellbook/book)
	summon_guns(user, 10)
	playsound(get_turf(user), 'sound/magic/castsummon.ogg', 50, TRUE)
	return ..()

/datum/spellbook_entry/summon/magic
	name = "Призыв Магии"
	desc = "Поделитесь чудесами магии с командой и покажите им \
			почему нельзя доверить её всей станции одновременно."

/datum/spellbook_entry/summon/magic/can_be_purchased()
	// Must be config enabled
	return !CONFIG_GET(flag/no_summon_magic)

/datum/spellbook_entry/summon/magic/buy_spell(mob/living/carbon/human/user,obj/item/spellbook/book)
	summon_magic(user, 10)
	playsound(get_turf(user), 'sound/magic/castsummon.ogg', 50, TRUE)
	return ..()

/datum/spellbook_entry/summon/events
	name = "Горизонт событий"
	desc = "Немного подтолкните закон Мерфи и замените все события на \
		особые волшебные, которые приведут всех в замешательство. \
		Многократное использование увеличивает частоту событий."
	cost = 2
	limit = 5 // Each purchase can intensify it.

/datum/spellbook_entry/summon/events/can_be_purchased()
	// Also, must be config enabled
	return !CONFIG_GET(flag/no_summon_events)

/datum/spellbook_entry/summon/events/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book)
	summon_events(user)
	playsound(get_turf(user), 'sound/magic/castsummon.ogg', 50, TRUE)
	return ..()

/datum/spellbook_entry/summon/curse_of_madness
	name = "Проклятие Безумия"
	desc = "Проклинает станцию, искажая сознание всех, кто на ней находится, вызывая длительные травмы. Предупреждение: Это заклинание может так же повлиять и на вас, если не произнести его из вашей обители."
	cost = 4

/datum/spellbook_entry/summon/curse_of_madness/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book)
	var/message = tgui_input_text(user, "Шепните шокирующее откровение, чтобы довести своих жертв до безумия.", "Шепот безумия")
	if(!message)
		return FALSE
	curse_of_madness(user, message)
	playsound(user, 'sound/magic/mandswap.ogg', 50, TRUE)
	return ..()

#undef MINIMUM_THREAT_FOR_RITUALS
