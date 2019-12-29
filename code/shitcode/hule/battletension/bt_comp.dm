#define PRIKOL "prikol"
#define TECHNO "techno"
#define TOUHOU "touhou"
#define MORTAL "mortal"
#define NAZIST "nazist"

PROCESSING_SUBSYSTEM_DEF(btension)
	name = "Battle Tension"
	priority = 15
	flags = SS_NO_INIT
	wait = 25

/datum/component/battletension
	var/mob/living/owner

	var/tension = 0
	var/sound/bm

/datum/component/battletension/Initialize()
	START_PROCESSING(SSbtension, src)

	if(isliving(parent))
		owner = parent

/datum/component/battletension/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_BULLET_ACT, .proc/bulletact_react)
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/attackby_react)

/datum/component/battletension/UnregisterFromParent()
	UnregisterSignal(parent, list(	COMSIG_ATOM_BULLET_ACT,
									COMSIG_PARENT_ATTACKBY
									))

/datum/component/battletension/Destroy()
	stop_bm()

	STOP_PROCESSING(SSbtension, src)
	owner = null
	return ..()

/datum/component/battletension/process()
	if((!bm || !bm.file) && is_enabled())
		pick_sound()

	if(tesion <= 0)
		stop_bm()

	if(tension >= 0)
		tension--

	if(bm)
		bm.volume = tension
		bm.status = SOUND_UPDATE
		SEND_SOUND(owner, bm)

	switch(tension)
		if(0 to 30)
			tension--

		if(120 to INFINITY)
			tension = 80

/datum/component/battletension/proc/bulletact_react(datum/source, obj/projectile/P, def_zone)
	create_tension(P.damage)

	if(!P.firer || P.firer == owner)
		return

	var/datum/component/battletension/BT = P.firer.GetComponent(/datum/component/battletension)

	if(BT)
		BT.create_tension(P.damage)


/datum/component/battletension/proc/attackby_react(datum/source, obj/item/I, mob/user)
	create_tension(I.force * 1.2)

	if(!user || user == owner)
		return

	var/datum/component/battletension/BT = user.GetComponent(/datum/component/battletension)

	if(BT)
		BT.create_tension(I.force * 1.2)

/datum/component/battletension/proc/is_enabled()
	if(!owner || !owner.client || !owner.client.prefs.btprefsnew)
		return FALSE
	return TRUE

/datum/component/battletension/proc/create_tension(amount)
	if(!is_enabled())
		return

	amount = round(amount)

	if(tension)
		tension += amount
	else
		tension = amount

/datum/component/battletension/proc/stop_bm()
	if(bm)
		bm.volume = 0
		SEND_SOUND(owner, bm)
		qdel(bm)
		bm = null

/datum/component/battletension/proc/pick_sound(soundpath)
	stop_bm()

	var/sound/S

	if(soundpath)
		S = sound(soundpath)
	else
		var/list/soundlist = get_sound_list()
		if(soundlist && soundlist.len)
			S = sound(pick(soundlist))
		else
			return

	if(!S || !S.file)
		return

	S.repeat = 1
	S.channel = CHANNEL_BATTLETENSION
	S.falloff = 2
	S.wait = 0
	S.volume = 0
	S.status = 0

	bm = S
	SEND_SOUND(owner, bm)

/datum/component/battletension/proc/get_sound_list()
	if(!owner || !owner.client || !owner.client.prefs)
		return

	var/list/result = list()

	var/list/genres = owner.client.prefs.btprefsnew

	for(var/genre in genres)
		for(var/music in flist("[global.config.directory]/battle_music/[genre]"))
			result += "[global.config.directory]/battle_music/[genre]/[music]"
	return result

/client/verb/customize_battletension()
	set name = " #️⃣ Настроить Battle Tension"
	set desc = "Allows for advanced prikol immersion."
	set category = "Preferences"

	var/list/genres = list(PRIKOL, TECHNO, TOUHOU, MORTAL, NAZIST)
	var/settings

	if(prefs.btprefsnew)
		if(!islist(prefs.btprefsnew))
			prefs.btprefsnew = genres
			prefs.save_preferences()
		settings = prefs.btprefsnew
	else
		settings = genres

	var/list/menu = list()

	for(var/genre in genres)
		if(genre in settings)
			menu += genre + " ON"
		else
			menu += genre + " OFF"

	var/selected = input("BT Customization") as null|anything in menu
	if(!selected)
		return

	selected = splittext(selected, " ")[0]

	if(settings)
		settings -= selected
		to_chat(usr, "<span class='danger'>Больше не хочу [selected].</span>")
	else
		settings += selected
		to_chat(usr, "<span class='danger'>Теперь хочу [selected].</span>")

	prefs.btprefsnew = settings
	prefs.save_preferences()

	if(mob)
		var/datum/component/battletension/BT = mob.GetComponent(/datum/component/battletension)
		if(BT)
			BT.pick_sound()
