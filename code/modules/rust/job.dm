/datum/job/rust_enjoyer
	title = JOB_RUST_ENJOYER
	faction = "Rust"
	total_positions = 0
	spawn_positions = 0
	supervisors = "практически всем"
	selection_color = "#dddddd"
	outfit = /datum/outfit/job/rust_enjoyer
	antag_rep = 0

/datum/job/rust_enjoyer/override_latejoin_spawn(mob/living/carbon/human/H)
	H.forceMove(pick(get_area_turfs(SSrust_mode.main_area)))
	return TRUE
