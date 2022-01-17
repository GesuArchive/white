/mob/living/simple_animal/ascendant_shadowling
	name = "ascendant shadowling"
	desc = "HOLY SHIT RUN THE FUCK AWAY- <span class='shadowling'>RAAAAAAA!</span>"
	icon = 'white/valtos/icons/sling.dmi'
	icon_state = "shadowling_ascended"
	icon_living = "shadowling_ascended"
	verb_say = "телепатически гремит"
	verb_ask = "телепатически гремит"
	verb_exclaim = "телепатически гремит"
	verb_yell = "телепатически гремит"
	force_threshold = INFINITY //Can't die by normal means
	health = 9999
	maxHealth = 9999
	speed = 0
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	see_invisible = SEE_INVISIBLE_OBSERVER
	harm_intent_damage = 0
	melee_damage_lower = 160 //Was 60, buffed
	melee_damage_upper = 160
	attack_verb_continuous = "rends"
	attack_verb_simple = "rend"
	attack_sound = 'sound/weapons/slash.ogg'
	minbodytemp = 0
	maxbodytemp = INFINITY
	environment_smash = 3
	faction = list("faithless")
	speech_span = SPAN_REALLYBIG //screw it someone else can figure out how to put both SPAN_YELL and SPAN_REALLYBIG on a speech_span later

/mob/living/simple_animal/ascendant_shadowling/Initialize()
	. = ..()
	LoadComponent(/datum/component/walk)

/mob/living/simple_animal/ascendant_shadowling/Process_Spacemove(movement_dir = 0)
	return TRUE //copypasta from carp code

/mob/living/simple_animal/ascendant_shadowling/ex_act(severity)
	return FALSE //You think an ascendant can be hurt by bombs? HA

/mob/living/simple_animal/ascendant_shadowling/singularity_act()
	to_chat(src, "<span class='shadowling>NO NO NO AAAAAAAAAAAAAAAAAAA-</span>")
	to_chat(world, span_shadowling("<b>\"<font size=6>NO!</font> <font size=5>I will</font> <font size=4>not be.... destroyed</font> <font size=3>by a....</font> <font size=2>AAAAAAA-</font>\""))
	for(var/X in GLOB.alive_mob_list)
		var/mob/M = X
		to_chat(M, span_notice("<i><b>You feel a woosh as newly released energy temporarily distorts space itself...</b></i>"))
		SEND_SOUND(M, sound('sound/hallucinations/wail.ogg'))
	. = ..()
