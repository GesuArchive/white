GLOBAL_LIST_INIT(bad_words, world.file2list("cfg/autoeban/bad_words.fackuobema"))

GLOBAL_LIST_INIT(exc_start, world.file2list("cfg/autoeban/exc_start.fackuobema"))
GLOBAL_LIST_INIT(exc_end, world.file2list("cfg/autoeban/exc_end.fackuobema"))
GLOBAL_LIST_INIT(exc_full, world.file2list("cfg/autoeban/exc_full.fackuobema"))

GLOBAL_LIST_INIT(neobuchaemie_debili, world.file2list("cfg/autoeban/debix_list.fackuobema"))

/proc/proverka_na_detey(var/msg, var/mob/target)
	if(!target.client)
		return
	msg = lowertext(msg)
	for(var/W in GLOB.bad_words)
		W = lowertext(W)
		if(findtext_char(msg, W) && isliving(target) && W != "")
			var/list/ML = splittext(msg, " ")

			if(W in GLOB.exc_start)
				for(var/WA in ML)
					if(findtext_char(WA, "[W]") < findtext_char(WA, regex("^[W]")))
						return

			if(W in GLOB.exc_end)
				for(var/WB in ML)
					if(findtext_char(WB, "[W]") > findtext_char(WB, regex("^[W]")))
						return

			if(W in GLOB.exc_full)
				for(var/WC in ML)
					if(findtext_char(WC, W) && (WC != W))
						return

			if(target.client)
				inc_metabalance(target, METACOIN_BADWORDS_REWARD, reason="[uppertext(W)]...")
				if(!ishuman(target))
					target.client.prefs.muted |= MUTE_IC

			message_admins("Дружок [target.ckey] насрал на ИС словом \"[W]\". ([ADMIN_COORDJMP(target)]) ([ADMIN_SMITE(target)])")

			//playsound(target.loc,'white/hule/SFX/rjach.ogg', 200, 7, pressure_affected = FALSE)

			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/obj/item/organ/O = H.getorganslot(ORGAN_SLOT_TONGUE)
				var/turf/T = get_turf(H)
				O.Remove(H)
				O.forceMove(T)
				var/atom/throw_target = get_edge_target_turf(O, H.dir)
				O.throw_at(throw_target, 3, 4, H)
				H.vomit(10, TRUE, TRUE, 4)
				GLOB.neobuchaemie_debili += target.ckey
			if(target.ckey in GLOB.neobuchaemie_debili && isliving(target))
				inc_metabalance(target, METACOIN_BADWORDS_REWARD * 10, reason="Необучаемый долбоёб...")
				var/mob/living/L = target
				L.gib(FALSE, FALSE, FALSE)

			return
