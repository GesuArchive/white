// Smooth HUD updates, but low priority
PROCESSING_SUBSYSTEM_DEF(huds)
	name = "HUD updates"
	wait = 1
	priority = FIRE_PRIORITY_NPC
	stat_tag = "HUDs"
