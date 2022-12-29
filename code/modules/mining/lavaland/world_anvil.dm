/obj/structure/world_anvil
	name = "наковальня миров"
	desc = "Наковальня, связанная посредством магмовых жил с ядром Лаваленда. Для начала работы необходим Гибтонит. Тот, кто использовал это последним, создавал что-то мощное."
	icon = 'icons/obj/lavaland/anvil.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	pass_flags = LETPASSTHROW
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/forge_charges = 0
	var/list/placed_objects = list()

	var/list/allowed = list(
		/obj/item/gun/energy/kinetic_accelerator,
		/obj/item/gun/energy/plasmacutter/adv,
		/obj/item/magmite,
		/obj/item/gibtonite
		)

/obj/structure/world_anvil/Initialize(mapload)
	. = ..()
	AddComponent(/datum/element/climbable)

/obj/structure/world_anvil/update_icon()
	. = ..()
	icon_state = forge_charges > 0 ? "anvil_a" : "anvil"
	if(forge_charges > 0)
		set_light(4,1,LIGHT_COLOR_ORANGE)
	else
		set_light(0)

/obj/structure/world_anvil/examine(mob/user)
	. = ..()
	. += "<hr>Она может выдать ещё [forge_charges] заряд[forge_charges != 1 ? "" : "ов"]."

/obj/structure/world_anvil/attackby(obj/item/I, mob/living/user, params)
	if(!(LAZYFIND(allowed, I.type)))
		to_chat(user, span_danger("Нет смысла помещать это на наковальню!"))
		return
	if(istype(I,/obj/item/gibtonite))
		var/obj/item/gibtonite/placed_ore = I
		forge_charges = forge_charges + placed_ore.quality
		to_chat(user,"Ставлю гибтонит на наковальню и наблюдаю, как Гибтонит тает на ней. Наковальня миров теперь сможет поработать ещё [forge_charges] раз[forge_charges > 1 ? "" : "а"].")
		qdel(placed_ore)
		update_icon()
	else //put everything else except gibtonite on the forge
		if(user.transferItemToLoc(I, src))
			vis_contents += I
			placed_objects += I
			RegisterSignal(I, COMSIG_MOVABLE_MOVED, PROC_REF(ItemMoved), TRUE)

/obj/structure/world_anvil/proc/ItemMoved(obj/item/I, atom/OldLoc, Dir, Forced)
	SIGNAL_HANDLER

	vis_contents -= I
	placed_objects -= I
	UnregisterSignal(I, COMSIG_MOVABLE_MOVED)

/obj/structure/world_anvil/attack_hand(mob/user)
	if(!LAZYLEN(placed_objects))
		to_chat(user,"Нужно разместить кусок плазменного магмита и кинетический ускоритель или продвинутый плазменный резак на наковальне!")
		return ..()
	if(forge_charges <= 0)
		to_chat(user,"Наковальня недостаточно нагрета, чтобы можно было её использовать!")
		return ..()
	var/magmite_amount = 0
	var/used_magmite = 0
	for(var/obj/item/magmite/placed_magmite in placed_objects)
		magmite_amount++
	if(magmite_amount <= 0)
		to_chat(user,"На наковальне нет ни одного плазменного магмита!")
		return ..()
	for(var/obj/item/I in placed_objects)
		if(istype(I,/obj/item/gun/energy/kinetic_accelerator) && forge_charges && used_magmite < magmite_amount)
			var/obj/item/gun/energy/kinetic_accelerator/gun = I
			if(gun.max_mod_capacity != 100)
				to_chat(user,"Это не базовый кинетический ускоритель!")
				break
			if(gun.bayonet)
				gun.remove_gun_attachment(item_to_remove = gun.bayonet)
			for(var/obj/item/borg/upgrade/modkit/kit in gun.modkits)
				kit.uninstall(gun)
			var/obj/item/gun/energy/kinetic_accelerator/mega/newgun = new(get_turf(src))
			newgun.throw_at(user, 7, 7)
			ItemMoved(gun)
			qdel(gun)
			forge_charges--
			used_magmite++
			to_chat(user,"Беспокойные усики обертывают кинетический ускоритель, потребляя плазменный магмит, образуя мега кинетический ускоритель.")
		if(istype(I,/obj/item/gun/energy/plasmacutter/adv) && forge_charges && used_magmite < magmite_amount)
			var/obj/item/gun/energy/plasmacutter/adv/gun = I
			if(gun.name != "продвинутый плазменный резак")
				to_chat(user,"Это не продвинутый плазменный резак!")
				break
			var/obj/item/gun/energy/plasmacutter/adv/mega/newgun = new(get_turf(src))
			newgun.throw_at(user, 7, 7)
			ItemMoved(gun)
			qdel(gun)
			forge_charges--
			used_magmite++
			to_chat(user,"Резкие усики обернуты вокруг плазменного резака, потребляя плазменный магмит, образуя мега-резак.")
	//time to clean up all the magmite we used
	for(var/obj/item/magmite in placed_objects)
		if(used_magmite)
			used_magmite--
			ItemMoved(magmite)
			qdel(magmite)
	update_icon()
	if(!forge_charges)
		to_chat(user,"Наковальня охлаждается.")
