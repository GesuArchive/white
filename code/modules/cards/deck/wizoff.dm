//It's Wiz-Off, the wizard themed card game! It's modular too, in case you might want to make it Syndie, Sec and Clown themed or something stupid like that.
/obj/item/toy/cards/deck/wizoff
	name = "\improper Wiz-Off deck"
	desc = "A Wiz-Off deck. Fight an arcane battle for the fate of the universe: Draw 5! Play 5! Best of 5! A rules card is attached."
	cardgame_desc = "Wiz-Off game"
	icon_state = "deck_wizoff_full"
	deckstyle = "wizoff"
	is_standard_deck = FALSE

/obj/item/toy/cards/deck/wizoff/Initialize(mapload)
	. = ..()
	var/card_list = strings("wizoff.json", "wizard")
	cards += new /obj/item/toy/singlecard/wizoff_ruleset(src) // ruleset should be the top card
	for(var/card in card_list)
		cards += new /obj/item/toy/singlecard(src, card, src)

/obj/item/toy/singlecard/wizoff_ruleset
	desc = "A ruleset for the playing card game Wiz-Off."
	cardname = "Wizoff Ruleset"
	deckstyle = "black"
	has_unique_card_icons = FALSE
	icon_state = "singlecard_down_black"

/obj/item/toy/singlecard/wizoff_ruleset/examine(mob/living/carbon/human/user)
	. = ..()
	. += "<span class='notice'>Remember the rules of Wiz-Off!</span>"
	. += "<span class='info'>Each player draws 5 cards.</span>"
	. += "<span class='info'>There are five rounds. Each round, a player selects a card to play, and the winner is selected based on the following rules:</span>"
	. += "<span class='info'>Defensive beats Offensive!</span>"
	. += "<span class='info'>Offensive beats Utility!</span>"
	. += "<span class='info'>Utility beats Defensive!</span>"
	. += "<span class='info'>If both players play the same type of spell, the higher number wins!</span>"
	. += "<span class='info'>The player who wins the most of the 5 rounds wins the game!</span>"
	. += "<span class='notice'>Now get ready to battle for the fate of the universe: Wiz-Off!</span>"
