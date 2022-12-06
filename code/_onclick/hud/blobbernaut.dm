/datum/hud/living/blobbernaut/New(mob/living/owner)
	. = ..()

	blobpwrdisplay = new /atom/movable/screen/healths/blob/overmind()
	blobpwrdisplay.screen_loc = retro_hud ? UI_BLOBBERNAUT_OVERMIND_HEALTH_RETRO : UI_BLOBBERNAUT_OVERMIND_HEALTH
	blobpwrdisplay.hud = src
	infodisplay += blobpwrdisplay
