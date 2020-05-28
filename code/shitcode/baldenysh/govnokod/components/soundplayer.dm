/datum/component/soundplayer

/datum/component/soundplayer/Initialize()
	if(!isatom(parent))
		qdel(src)
