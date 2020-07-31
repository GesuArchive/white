/obj/item/implanter
	name = "имплантер"
	desc = "Стерильный автоматический инъектор имплантов."
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "implanter0"
	inhand_icon_state = "syringe_0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=600, /datum/material/glass=200)
	var/obj/item/implant/imp = null
	var/imp_type = null


/obj/item/implanter/update_icon_state()
	if(imp)
		icon_state = "implanter1"
	else
		icon_state = "implanter0"


/obj/item/implanter/attack(mob/living/M, mob/user)
	if(!istype(M))
		return
	if(user && imp)
		if(M != user)
			M.visible_message("<span class='warning'><b>[user]</b> пытается проимплантировать <b>[M]</b>.</span>")

		var/turf/T = get_turf(M)
		if(T && (M == user || do_mob(user, M, 50)))
			if(src && imp)
				if(imp.implant(M, user))
					if (M == user)
						to_chat(user, "<span class='notice'>ЧИПИРУЮ СЕБЯ!</span>")
					else
						M.visible_message("<span class='notice'><b>[user]</b> имплантирует <b>[M]</b>.</span>", "<span class='notice'><b>[user]</b> имплантирует меня.</span>")
					imp = null
					update_icon()
				else
					to_chat(user, "<span class='warning'><b>[src]</b> проваливает попытку ЧИПИЗАЦИИ <b>[M]</b>.</span>")

/obj/item/implanter/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, "<span class='notice'>Махаю ручкой перед <b>[W]</b>!</span>")
			return
		var/t = stripped_input(user, "Что же мы напишем?", name, null)
		if(user.get_active_held_item() != W)
			return
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(t)
			name = "имплантер ([t])"
		else
			name = "имплантер"
	else
		return ..()

/obj/item/implanter/Initialize(mapload)
	. = ..()
	if(imp_type)
		imp = new imp_type(src)
	update_icon()
