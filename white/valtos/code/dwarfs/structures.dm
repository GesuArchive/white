/obj/structure/gemcutter
	name = "стол ювелира"
	desc = "У дворфов нет имени Александр в списке имен"
	icon = 'white/valtos/icons/dwarfs/objects.dmi'
	icon_state = "gemcutter_off"
	anchored = TRUE
	density = TRUE
	layer = TABLE_LAYER
	var/busy = FALSE

/obj/structure/gemcutter/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/gem) && !istype(I, /obj/item/gem/cut))
		icon_state = "gemcutter_on"
		if(busy)
			to_chat(user, "<span class='notice'>Сейчас занято.</span>")
			return
		busy = TRUE
		if(!do_after(user, 15 SECONDS, target = src))
			busy = FALSE
			icon_state = "gemcutter_off"
			return
		busy = FALSE
		var/obj/item/gem/G = I
		new G.cut_type(loc)
		to_chat(user, "<span class='notice'>Обрабатываю [G] на [src]</span>")
		qdel(G)
		icon_state = "gemcutter_off"
	else
		..()

/obj/structure/workbench
	name = "верстак"
	desc = "Почти майнкрафт"
	icon = 'white/valtos/icons/dwarfs/workbench.dmi'
	icon_state = "workbench"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	var/list/inventory = list()
	var/datum/workbench_recipe/recipe
	var/ready = FALSE
	var/busy = FALSE

/obj/structure/workbench/Initialize()
	. = ..()
	var/turf/T = locate(x+1,y,z)
	T.density = TRUE

/obj/structure/workbench/Destroy()
	var/turf/T = locate(x+1,y,z)
	if(istype(T, /turf/open))
		T.density = FALSE
	..()

/obj/structure/workbench/attack_hand(mob/user)
	. = ..()
	if(busy)
		to_chat(user, "<span class='notice'>Сейчас занято.</span>")
		return
	if(recipe && inventory.len && !ready)
		var/answer = tgui_alert(user, "Отменить нынешнюю сборку?", "Верстак", list("Да", "Нет"))
		if(answer == "Нет" || !answer)
			return
		for(var/I in inventory)
			var/atom/movable/M = I
			M.forceMove(drop_location())
		qdel(recipe)
		recipe = null
		inventory.Cut()
		to_chat(user, "<span class='notice'>Отменяю сборку [recipe].</span>")
		return
	if(ready)
		busy = TRUE
		if(!do_after(user, 10 SECONDS, target = src))
			busy = FALSE
			return
		busy = FALSE
		playsound(src, 'white/valtos/sounds/anvil_hit.ogg', 70, TRUE)
		var/obj/O = new recipe.result(loc)
		if(istype(get_primary(), /obj/item/blacksmith/partial))
			var/obj/item/blacksmith/partial/P = get_primary()
			O.force = P.real_force
			O.name = "[P.grade][O.name][P.grade]"
		to_chat(user, "<span class='notice'>Собираю [O].</span>")
		qdel(recipe)
		inventory.Cut()
		recipe = null
		ready = FALSE
		return
	var/list/recipes = list()
	var/list/recipe_names = list()
	for(var/t in typesof(/datum/workbench_recipe))
		var/datum/workbench_recipe/r = new t
		if(isstrictlytype(r, /datum/workbench_recipe))
			continue
		recipes[r.name] = r
		recipe_names+=r.name
	var/answer = tgui_input_list(user, "Что собираем?", "Верстак", recipe_names)
	if(!answer)
		return
	recipe = recipes[answer]
	to_chat(user, "<span class='notice'>Выбираю [recipe.name] для сборки.</span>")

/obj/structure/workbench/examine(mob/user)
	. = ..()
	if(recipe)
		.+="<hr>Собирается [recipe.name]."
		var/text = "Требуется"
		for(var/S in recipe.reqs)
			var/obj/item/stack/I = new S()
			var/r = recipe.reqs[I.type] - amount(I)
			var/govno = r ? "[r]":""
			if(r)
				text+="<br>[I.name]: [govno]"
			qdel(I)
		if(text!="Требуется")
			.+="<hr>[text]"
		else
			.+="<hr>[recipe.name] готов к сборке."
	else
		.+="<hr>Верстак пустой!"

/obj/structure/workbench/proc/amount(obj/item/I)
	. = 0
	for(var/obj/O in inventory)
		if(istype(O, I.type))
			.+=1

/obj/structure/workbench/proc/is_required(obj/item/I)
	. = FALSE
	for(var/O in recipe.reqs)
		var/obj/item/R = new O()
		if(istype(I, R.type))
			. = TRUE
		qdel(R)

/obj/structure/workbench/proc/get_primary()
	. = null
	for(var/obj/I in inventory)
		if(istype(I, recipe.primary))
			. = I

/obj/structure/workbench/proc/check_ready()
	var/r = TRUE
	for(var/S in recipe.reqs)
		var/obj/item/It = new S
		if((recipe.reqs[It.type] - amount(It)) > 0)
			r = FALSE
			break
	ready = r
	return r

/obj/structure/workbench/attacked_by(obj/item/I, mob/living/user)
	if(!recipe)
		..()
		return
	if(is_required(I))
		if((recipe.reqs[I.type]-amount(I))>0)
			if(istype(I, /obj/item/stack))
				var/obj/item/stack/S = I
				I = new S.type()
				S.amount-=1
				if(S.amount<1)
					qdel(S)
			user.transferItemToLoc(I, src)
			inventory+=I
			visible_message("<span class='notice'>[user] кладет [I] на [src].</span>","<span class='notice'>Кладу [I] на [src].</span>")
			check_ready()
		else
			to_chat(user, "<span class='notice'>В [src] больше не влазит.</span>")
	else
		..()

/obj/structure/dwarf_altar
	name = "Алтарь"
	desc = "Руны оо мм ммм."
	icon = 'white/valtos/icons/dwarfs/altar.dmi'
	icon_state = "altar_inactive"
	density = TRUE
	anchored = TRUE
	layer = FLY_LAYER
	var/busy = FALSE
	var/active = FALSE
	var/resources = 0
	var/list/available_rituals = list(/datum/ritual/summon_dwarf,/datum/ritual/summon_seeds,/datum/ritual/summon_frog,/datum/ritual/summon_tools)
	var/list/allowed_resources = list(/obj/item/blacksmith/ingot/gold=25,
									/obj/item/gem/cut/diamond=50,
									/obj/item/gem/cut/ruby=40,
									/obj/item/gem/cut/saphire=30,
									)

/obj/structure/dwarf_altar/Initialize()
	. = ..()
	set_light(1)

/obj/structure/dwarf_altar/proc/activate()
	icon_state = "altar_active"

/obj/structure/dwarf_altar/attack_ghost(mob/user)
	summon_dwarf(user)

/obj/structure/dwarf_altar/proc/summon_dwarf(mob/user)
	if(!active)
		return FALSE
	var/dwarf_ask = alert("Стать дворфом?", "КОПАТЬ?", "Да", "Нет")
	if(dwarf_ask == "Нет" || !src || QDELETED(src) || QDELETED(user))
		return FALSE
	if(!active)
		to_chat(user, "<span class='warning'>Уже занято!</span>")
		return FALSE
	var/mob/living/carbon/human/D = new /mob/living/carbon/human(loc)
	D.set_species(/datum/species/dwarf)
	D.equipOutfit(/datum/outfit/dwarf)
	D.key = user.key
	D.mind.assigned_role = "Dwarf"
	active = FALSE
	to_chat(D, "<span class='big bold'>Я ебучий карлик в невероятно диких условиях.</span>")
	deactivate()

/obj/structure/dwarf_altar/proc/deactivate()
	icon_state = "altar_inactive"

/obj/structure/dwarf_altar/attackby(obj/item/I, mob/living/user, params)
	if((I.type in allowed_resources))
		to_chat(user, "<span class='notice'>Жертвую [I.name]</span>")
		resources+=allowed_resources[I.type]
		qdel(I)
	else if(istype(I, /obj/item/damaz))
		var/obj/item/damaz/D = I
		if(!D.can_use(user))
			return
		ui_interact(user)
	else
		..()

/obj/structure/dwarf_altar/attack_hand(mob/user)
	if(ishuman(user) && !isdwarf(user))
		if(!active)
			to_chat(user, "<span class='warning'>Алтарь не готов!</span>")
			return
		var/mob/living/carbon/human/M = user
		var/dwarf_ask = alert(M, "Стать дворфом?", "КОПАТЬ?", "Да", "Нет")
		if(dwarf_ask == "Нет" || !src || QDELETED(src) || QDELETED(M))
			return FALSE
		if(!active)
			to_chat(M, "<span class='warning'>Не повезло!</span>")
			return FALSE
		M.set_species(/datum/species/dwarf)
		M.unequip_everything()
		M.equipOutfit(/datum/outfit/dwarf)
		active = FALSE
		to_chat(M, "<span class='notice'>Становлюсь дворфом.</span>")

/obj/structure/dwarf_altar/proc/perform_rite(rite, mob/user)
	var/datum/ritual/R = new rite
	if(busy)
		return
	busy = TRUE
	to_chat(user, "<span class='notice'>Начинаю ритуал</span>")
	activate()
	if(!do_after(user, 3 SECONDS, target = src))
		busy = FALSE
		deactivate()
		return
	switch(initial(R.true_name))
		if("dwarf")
			active = TRUE
			notify_ghosts("Новый дворф готов.", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Спавн дворфа доступен.")
		if("seeds")
			for(var/seed in list(/obj/item/seeds/plump, /obj/item/seeds/tower))
				for(var/i in 1 to 2)
					new seed(loc)
		if("frog")
			//spawn frog here?
		if("tools")
			for(var/tool in list(/obj/item/blacksmith/smithing_hammer, /obj/item/blacksmith/tongs))
				new tool(loc)
	busy = FALSE
	to_chat(user, "<span class='notice'>Заканчиваю ритуал</span>")
	deactivate()
	qdel(R)

/obj/structure/dwarf_altar/proc/generate_rituals()
	var/list/rituals = list()
	for(var/rt in available_rituals)
		var/list/rite = list()
		var/datum/ritual/R = rt
		rite["name"] = initial(R.name)
		rite["cost"] = initial(R.cost)
		rite["desc"] = initial(R.desc)
		rite["path"] = R
		rituals+=list(rite)
	return rituals

/obj/structure/dwarf_altar/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "DwarfAltar")
    ui.open()

/obj/structure/dwarf_altar/ui_data(mob/user)
	var/list/data = list()
	var/list/rituals = generate_rituals()
	data["favor"] = resources
	data["rituals"] = rituals
	return data

/obj/structure/dwarf_altar/ui_act(action, params)
	. = ..()
	var/cost = params["cost"]
	if(cost>resources)
		to_chat(usr, "<span class='warning'>Не хватает ресурсов!</span>")
		return
	resources-=cost
	perform_rite(params["path"], usr)
	update_icon()
