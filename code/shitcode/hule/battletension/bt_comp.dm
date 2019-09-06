PROCESSING_SUBSYSTEM_DEF(btension)
	name = "Battle Tension"
	priority = 15
	flags = SS_NO_INIT
	wait = 10

/datum/component/battletension
	var/mob/living/owner

	var/tension = 0
	var/sound/bm

/datum/component/battletension/Initialize()
	START_PROCESSING(SSbtension, src)

	if(isliving(parent))
		owner = parent
		pick_sound()

/datum/component/battletension/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_BULLET_ACT, .proc/bulletact_react)
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/attackby_react)

/datum/component/battletension/UnregisterFromParent()
	UnregisterSignal(parent, list(	COMSIG_ATOM_BULLET_ACT,
									COMSIG_PARENT_ATTACKBY
									))

/datum/component/battletension/Destroy()
	if(bm)
		bm.volume = 0
		bm.status = SOUND_STREAM|SOUND_UPDATE
		SEND_SOUND(owner, bm)

	STOP_PROCESSING(SSbtension, src)
	owner = null
	return ..()

/datum/component/battletension/process()
	if(tension < 0 || !bm || !bm.file)
		return

	bm.volume = tension
	bm.status = SOUND_STREAM|SOUND_UPDATE
	SEND_SOUND(owner, bm)

	switch(tension)
		if(0 to 30)
			tension--

		if(80 to INFINITY)
			tension = 80

	if(tension > 0)
		tension--
		if(tension <= 0)
			bm.volume = 0
			SEND_SOUND(owner, bm)
			qdel(bm)
			bm = null
			pick_sound()

/datum/component/battletension/proc/bulletact_react(datum/source, obj/item/projectile/P, def_zone)
	to_chat(owner, "<span class='warning'>bulletact msg</span>")
	to_chat(P.firer, "<span class='warning'>bulletact firer msg</span>")
	create_tension(P.damage)

	if(!P.firer)
		return

	var/datum/component/battletension/BT = P.firer.GetComponent(/datum/component/battletension)

	if(BT)
		BT.create_tension(P.damage)


/datum/component/battletension/proc/attackby_react(datum/source, obj/item/I, mob/user)
	create_tension(I.force * 1.2)

	if(!user)
		return

	var/datum/component/battletension/BT = user.GetComponent(/datum/component/battletension)

	if(BT)
		BT.create_tension(I.force * 1.2)

/datum/component/battletension/proc/create_tension(amount)
	if(tension)
		tension += amount
	else
		tension = amount

/datum/component/battletension/proc/pick_sound()
	var/sound/S = sound("code/shitcode/hule/battletension/bm/" + pick(list("digitalonslaught.ogg", "03 NARC.ogg")))
	if(!S || !S.file)
		return
	S.repeat = 1
	S.channel = 1015
	S.falloff = 2
	S.wait = 0
	S.volume = 0
	S.status = SOUND_STREAM

	bm = S
	SEND_SOUND(owner, bm)