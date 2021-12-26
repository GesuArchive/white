/obj/structure/flora/tree/gensokyo
	name = "дерево"
	desc = "Огромное! Да..."
	icon = 'white/valtos/icons/gensokyo/bigtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/gensokyo/Initialize()
	. = ..()
	icon_state = "tree_[rand(1, 8)]"

/datum/award/achievement/boss/reimu_kill
	name = "Убийца Рейму"
	desc = "Рейму готова."
	database_id = BOSS_MEDAL_REIMU

/datum/award/achievement/boss/reimu_crusher
	name = "Убийца Рейму крашером"
	desc = "Рейму готова."
	database_id = BOSS_MEDAL_REIMU_CRUSHER

/datum/award/score/reimu_score
	name = "Убито Рейму"
	desc = "Сколько же ты убил?"
	database_id = REIMU_SCORE
