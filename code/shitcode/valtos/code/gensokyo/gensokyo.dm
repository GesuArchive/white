/obj/structure/flora/tree/gensokyo
	name = "дерево"
	desc = "Огромное! Да..."
	icon = 'code/shitcode/valtos/icons/gensokyo/bigtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/gensokyo/Initialize()
	. = ..()
	icon_state = "tree_[rand(1, 8)]"
