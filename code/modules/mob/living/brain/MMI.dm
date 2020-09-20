/obj/item/mmi
	name = "\improper Man-Machine Interface"
	desc = "Мягкое сокращение Воина, MMI, скрывает истинный ужас этого чудовища, которое, тем не менее, стало стандартным для станций Нанотрейзен."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_off"
	w_class = WEIGHT_CLASS_NORMAL
	var/braintype = "Cyborg"
	var/obj/item/radio/radio = null //Let's give it a radio.
	var/mob/living/brain/brainmob = null //The current occupant.
	var/mob/living/silicon/robot = null //Appears unused.
	var/obj/vehicle/sealed/mecha = null //This does not appear to be used outside of reference in mecha.dm.
	var/obj/item/organ/brain/brain = null //The actual brain
	var/datum/ai_laws/laws = new()
	var/force_replace_ai_name = FALSE
	var/overrides_aicore_laws = FALSE // Whether the laws on the MMI, if any, override possible pre-existing laws loaded on the AI core.

/obj/item/mmi/update_icon_state()
	if(!brain)
		icon_state = "mmi_off"
	else if(istype(brain, /obj/item/organ/brain/alien))
		icon_state = "mmi_brain_alien"
	else
		icon_state = "mmi_brain"

/obj/item/mmi/update_overlays()
	. = ..()
	. += add_mmi_overlay()

/obj/item/mmi/proc/add_mmi_overlay()
	if(brainmob && brainmob.stat != DEAD)
		. += "mmi_alive"
	else if(brain)
		. += "mmi_dead"

/obj/item/mmi/Initialize()
	. = ..()
	radio = new(src) //Spawns a radio inside the MMI.
	radio.broadcasting = FALSE //researching radio mmis turned the robofabs into radios because this didnt start as 0.
	laws.set_laws_config()

/obj/item/mmi/attackby(obj/item/O, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(O, /obj/item/organ/brain)) //Time to stick a brain in it --NEO
		var/obj/item/organ/brain/newbrain = O
		if(brain)
			to_chat(user, "<span class='warning'>Здесь уже есть мозг в MMI!</span>")
			return
		if(!newbrain.brainmob)
			to_chat(user, "<span class='warning'>Я не уверены, откуда взялся этот мозг, но уверен, что это бесполезный мозг!</span>")
			return

		if(!user.transferItemToLoc(O, src))
			return
		var/mob/living/brain/B = newbrain.brainmob
		if(!B.key)
			B.notify_ghost_cloning("Кто-то воткнул мои мозги в MMI!", source = src)
		user.visible_message("<span class='notice'>[user] впихивает [newbrain] в [src].</span>", "<span class='notice'>Индикатор [src] начинает светиться, когда я впихиваю [newbrain].</span>")

		brainmob = newbrain.brainmob
		newbrain.brainmob = null
		brainmob.forceMove(src)
		brainmob.container = src
		var/fubar_brain = newbrain.suicided || brainmob.suiciding //brain is from a suicider
		if(!fubar_brain && !(newbrain.organ_flags & ORGAN_FAILING)) // the brain organ hasn't been beaten to death, nor was from a suicider.
			brainmob.set_stat(CONSCIOUS) //we manually revive the brain mob
			brainmob.remove_from_dead_mob_list()
			brainmob.add_to_alive_mob_list()
		else if(!fubar_brain && newbrain.organ_flags & ORGAN_FAILING) // the brain is damaged, but not from a suicider
			to_chat(user, "<span class='warning'>[src] жёлтым сигналом сообщает о том, что мозг повреждён.</span>")
			playsound(src, 'sound/machines/synth_no.ogg', 5, TRUE)
		else
			to_chat(user, "<span class='warning'>[src] красным сигналом сообщает о том, что стоит проверить мозг ещё раз.</span>")
			playsound(src, 'sound/machines/triple_beep.ogg', 5, TRUE)

		brainmob.reset_perspective()
		brain = newbrain
		brain.organ_flags |= ORGAN_FROZEN

		name = "[initial(name)]: [brainmob.real_name]"
		update_icon()
		if(istype(brain, /obj/item/organ/brain/alien))
			braintype = "Xenoborg" //HISS....Beep.
		else
			braintype = "Cyborg"

		SSblackbox.record_feedback("amount", "mmis_filled", 1)

		log_game("[key_name(user)] has put the brain of [key_name(brainmob)] into an MMI at [AREACOORD(src)]")

	else if(brainmob)
		O.attack(brainmob, user) //Oh noooeeeee
	else
		return ..()

/obj/item/mmi/attack_self(mob/user)
	if(!brain)
		radio.on = !radio.on
		to_chat(user, "<span class='notice'>[radio.on==1 ? "Включаю" : "Выключаю"] рацию [src].</span>")
	else
		eject_brain(user)
		update_icon()
		name = initial(name)
		to_chat(user, "<span class='notice'>Вытряхиваю мозги из [src] на пол с нежным сочным звуком.</span>")

/obj/item/mmi/proc/eject_brain(mob/user)
	brainmob.container = null //Reset brainmob mmi var.
	brainmob.forceMove(brain) //Throw mob into brain.
	brainmob.set_stat(DEAD)
	brainmob.emp_damage = 0
	brainmob.reset_perspective() //so the brainmob follows the brain organ instead of the mmi. And to update our vision
	brainmob.remove_from_alive_mob_list() //Get outta here
	brainmob.add_to_dead_mob_list()
	brain.brainmob = brainmob //Set the brain to use the brainmob
	log_game("[key_name(user)] has ejected the brain of [key_name(brainmob)] from an MMI at [AREACOORD(src)]")
	brainmob = null //Set mmi brainmob var to null
	if(user)
		user.put_in_hands(brain) //puts brain in the user's hand or otherwise drops it on the user's turf
	else
		brain.forceMove(get_turf(src))
	brain.organ_flags &= ~ORGAN_FROZEN
	brain = null //No more brain in here

/obj/item/mmi/proc/transfer_identity(mob/living/L) //Same deal as the regular brain proc. Used for human-->robot people.
	if(!brainmob)
		brainmob = new(src)
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	if(L.has_dna())
		var/mob/living/carbon/C = L
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
	brainmob.container = src

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/brain/newbrain = H.getorgan(/obj/item/organ/brain)
		newbrain.forceMove(src)
		brain = newbrain
	else if(!brain)
		brain = new(src)
		brain.name = "мозг [L.real_name]"
	brain.organ_flags |= ORGAN_FROZEN

	name = "[initial(name)]: [brainmob.real_name]"
	update_icon()
	if(istype(brain, /obj/item/organ/brain/alien))
		braintype = "Xenoborg" //HISS....Beep.
	else
		braintype = "Cyborg"

/obj/item/mmi/proc/replacement_ai_name()
	return brainmob.name

/obj/item/mmi/verb/Toggle_Listening()
	set name = "Переключить прослушивание"
	set desc = "Слушаем канал или нет."
	set category = "MMI"
	set src = usr.loc
	set popup_menu = FALSE

	if(brainmob.stat)
		to_chat(brainmob, "<span class='warning'>Не могу сделать это в таком состоянии!</span>")
	if(!radio.on)
		to_chat(brainmob, "<span class='warning'>Рацию то выключили!</span>")
		return

	radio.listening = !radio.listening
	to_chat(brainmob, "<span class='notice'>Прослушивание [radio.listening ? "теперь" : "больше не"] работает.</span>")

/obj/item/mmi/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!brainmob || iscyborg(loc))
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage = min(brainmob.emp_damage + rand(20,30), 30)
			if(2)
				brainmob.emp_damage = min(brainmob.emp_damage + rand(10,20), 30)
			if(3)
				brainmob.emp_damage = min(brainmob.emp_damage + rand(0,10), 30)
		brainmob.emote("alarm")

/obj/item/mmi/Destroy()
	if(iscyborg(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	if(brain)
		qdel(brain)
		brain = null
	if(mecha)
		mecha = null
	if(radio)
		qdel(radio)
		radio = null
	return ..()

/obj/item/mmi/deconstruct(disassembled = TRUE)
	if(brain)
		eject_brain()
	qdel(src)

/obj/item/mmi/examine(mob/user)
	. = ..()
	if(radio)
		. += "<hr><span class='notice'>Здесь есть переключатель рации и он в положении [radio.on ? "выкл" : "вкл"].[brain ? " Внутри находится [brain]." : null]</span>"
	if(brainmob)
		var/mob/living/brain/B = brainmob
		. += "<hr>"
		if(!B.key || !B.mind || B.stat == DEAD)
			. += "<span class='warning'>Мозг внутри [src] не в рабочем состоянии.</span>"
		else if(!B.client)
			. += "<span class='warning'>Мозг внутри [src] пока не работает. Возможно это временно!</span>"
		else
			. += "<span class='notice'>Мозг внутри [src] активен.</span>"

/obj/item/mmi/relaymove(mob/living/user, direction)
	return //so that the MMI won't get a warning about not being able to move if it tries to move

/obj/item/mmi/proc/brain_check(mob/user)
	var/mob/living/brain/B = brainmob
	if(!B)
		if(user)
			to_chat(user, "<span class='warning'>Внутри [src] нет мозга!</span>")
		return FALSE
	if(!B.key || !B.mind)
		if(user)
			to_chat(user, "<span class='warning'>Внутри [src] мозг никак не реагирует на запросы!</span>")
		return FALSE
	if(!B.client)
		if(user)
			to_chat(user, "<span class='warning'>Мозг внутри [src] не отвечает на запросы. Но принимает их.</span>")
		return FALSE
	if(B.suiciding || brain?.suicided)
		if(user)
			to_chat(user, "<span class='warning'>Мозг внутри [src] сообщает о том, что не хочет жить!</span>")
		return FALSE
	if(B.stat == DEAD)
		if(user)
			to_chat(user, "<span class='warning'>Мозг внутри [src] полностью мёртв!</span>")
		return FALSE
	if(brain?.organ_flags & ORGAN_FAILING)
		if(user)
			to_chat(user, "<span class='warning'>Мозг внутри [src] похож на кашу!</span>")
		return FALSE
	return TRUE

/obj/item/mmi/syndie
	name = "\improper Syndicate Man-Machine Interface"
	desc = "Собственный бренд Синдикатовского MMI. Он обеспечивает соблюдение законов, призванных помочь агентам Синдиката достичь своих целей в отношении киборгов и ИИ, созданных с его помощью."
	overrides_aicore_laws = TRUE

/obj/item/mmi/syndie/Initialize()
	. = ..()
	laws = new /datum/ai_laws/syndicate_override()
	radio.on = FALSE
