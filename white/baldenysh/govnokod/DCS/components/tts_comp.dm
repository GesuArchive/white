/*
/proc/prikolize(msg)
	msg = trim(msg, maxchars)
	if(tts_speaker)
		owner.tts(msg, tts_speaker, freq = frequency)
	else
		var/speaker_to_use = pick("glados", "sentrybot") // plural go fuck
		switch(owner.gender)
			if(MALE)
				speaker_to_use = "papa"
			if(FEMALE)
				speaker_to_use = "charlotte"
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			frequency = 32000 - (H.age * 200)
		if(HAS_TRAIT(owner, TRAIT_CLUMSY) || isfelinid(owner))
			frequency *= 1.5
		owner.tts(msg, speaker_to_use, freq = frequency)
*/
