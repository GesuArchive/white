///AI Upgrades


//Malf Picker
/obj/item/malf_upgrade
	name = "модернизация боевого ПО для ИИ"
	desc = "Крайне незаконное, крайне опасное обновление для ИИ, значительно расширяющее их функционал, а также добавляет возможность взламывать АПЦ.<br> Это обновление не перезаписывает никаких действующих законов и должно быть загружено непосредственно в активное ядро ИИ."
	icon = 'icons/obj/module.dmi'
	icon_state = "datadisk3"


/obj/item/malf_upgrade/pre_attack(atom/A, mob/living/user, proximity)
	if(!proximity)
		return ..()
	if(!isAI(A))
		return ..()
	var/mob/living/silicon/ai/AI = A
	if(AI.malf_picker)
		AI.malf_picker.processing_time += 50
		to_chat(AI, span_userdanger("[user] has attempted to upgrade you with combat software that you already possess. You gain 50 points to spend on Malfunction Modules instead."))
	else
		to_chat(AI, span_userdanger("[user] has upgraded you with combat software!"))
		to_chat(AI, span_userdanger("Your current laws and objectives remain unchanged.")) //this unlocks malf powers, but does not give the license to plasma flood
		AI.add_malf_picker()
		AI.hack_software = TRUE
		log_game("[key_name(user)] has upgraded [key_name(AI)] with a [src].")
		message_admins("[ADMIN_LOOKUPFLW(user)] has upgraded [ADMIN_LOOKUPFLW(AI)] with a [src].")
	to_chat(user, span_notice("You upgrade [AI]. [src] is consumed in the process."))
	qdel(src)
	return TRUE


//Lipreading
/obj/item/surveillance_upgrade
	name = "модернизация ПО камер для ИИ"
	desc = "Нелегальный программный пакет, который позволит ИИ \"слышать\" со своих камер с помощью чтения по губам и скрытым микрофонам."
	icon = 'icons/obj/module.dmi'
	icon_state = "datadisk3"

/obj/item/surveillance_upgrade/pre_attack(atom/A, mob/living/user, proximity)
	if(!proximity)
		return ..()
	if(!isAI(A))
		return ..()
	var/mob/living/silicon/ai/AI = A
	if(AI.eyeobj)
		AI.eyeobj.relay_speech = TRUE
		to_chat(AI, span_userdanger("[user] has upgraded you with surveillance software!"))
		to_chat(AI, "Via a combination of hidden microphones and lip reading software, you are able to use your cameras to listen in on conversations.")
	to_chat(user, span_notice("You upgrade [AI]. [src] is consumed in the process."))
	log_game("[key_name(user)] has upgraded [key_name(AI)] with a [src].")
	message_admins("[ADMIN_LOOKUPFLW(user)] has upgraded [ADMIN_LOOKUPFLW(AI)] with a [src].")
	qdel(src)
	return TRUE
