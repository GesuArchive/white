/obj/item/circular_saw/folding
	name = "Раскладная пила"
	desc = "Elder surgical tool. Sometimes doing strange things"
	icon = 'white/Gargule/icons.dmi'
	icon_state = "saw"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'//fix that later
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'//that too
	hitsound = 'sound/weapons/stab1.ogg'
	force = 10//
	toolspeed = 1.25
	throwforce = 5//
	custom_materials = list(/datum/material/iron=10000)//
	var/folded = 0

/obj/item/circular_saw/folding/attack_self(user)
	if(!folded)
		folded = 1
		force = 0
		hitsound = null
		icon_state = "saw_folded"
		w_class = WEIGHT_CLASS_SMALL
		to_chat(user, "You fold your saw")
	else
		folded = 0
		force = initial(force)
		hitsound = initial(hitsound)
		icon_state = "saw"
		w_class = initial(w_class)
		to_chat(user, "You retract blade of your saw. Looks dangerous")

/obj/item/circular_saw/folding/attack(mob/living/M, mob/living/carbon/human/H)
	if(folded)
		H.dropItemToGround(src, TRUE)//drop saw
		to_chat(H, "You tried to saw with folded blade, but just drop your tool")
	else
		return ..()

/obj/item/circular_saw/folding/attackby(obj/item/autosurgeon/I, mob/user, params)
	if(I.uses>-1)
		I.uses -= 1+I.uses
		I.icon = 'white/Gargule/icons.dmi'
		I.icon_state = "thing"
		I.name = "strange thing"
		I.desc = "This thing is very strange. Who knows, what it can do?"
		to_chat(user, "Strange thing happens")
	else
		to_chat(user, "Strange thing already happened")
		return ..()
