/// Checks if any mob's faction var initial value is not a list, which is not supported by the current code
/datum/unit_test/mob_faction

/datum/unit_test/mob_faction/Run()
	/// Right now taken from create_and_destroy
	var/list/ignored = list(
		/mob/living/carbon/human/combat_ai,
		/mob/living/carbon/human/combat_ai/magnum,
		/mob/living/carbon/human/combat_ai/pistol,
		/mob/living/carbon/human/combat_ai/shotgun,
		/mob/living/carbon/human/combat_ai/smg,
		/mob/living/carbon/human/combat_ai/sniper,
		/mob/living/carbon,
		/mob/dview,
		/mob/oranges_ear
	)
	ignored += typesof(/mob/camera/imaginary_friend)
	ignored += typesof(/mob/living/simple_animal/pet/gondola/gondolapod)
	ignored += typesof(/mob/living/silicon/robot/modules)
	ignored += typesof(/mob/living/silicon/ai)
	ignored += typesof(/mob/camera/ai_eye)
	ignored += typesof(/mob/living/simple_animal/hostile/bloodsucker)
	for (var/mob_type in typesof(/mob) - ignored)
		var/mob/mob_instance = allocate(mob_type)
		if(!islist(mob_instance.faction))
			TEST_FAIL("[mob_type] faction variable is not a list")
