
//Academy Areas

/area/awaymission/academy
	name = "Астероиды академии"
	icon_state = "away"
	requires_power = FALSE

/area/awaymission/academy/headmaster
	name = "Переднее крыло Академии"
	icon_state = "away1"

/area/awaymission/academy/classrooms
	name = "Крыло аудиторий Академии"
	icon_state = "away2"

/area/awaymission/academy/academyaft
	name = "Крыло стыковки кораблей Академии"
	icon_state = "away3"

/area/awaymission/academy/academygate
	name = "Врата Академии"
	icon_state = "away4"

/area/awaymission/academy/academycellar
	name = "Подвал Академии"
	icon_state = "away4"

/area/awaymission/academy/academyengine
	name = "Двигатель Академии"
	icon_state = "away4"

//Academy Items

/obj/item/paper/fluff/awaymissions/academy/console_maint
	name = "Обслуживание консоли"
	info = "We're upgrading to the latest mainframes for our consoles, the shipment should be in before spring break is over!"

/obj/item/paper/fluff/awaymissions/academy/class/automotive
	name = "Починка автоматики для чайников"

/obj/item/paper/fluff/awaymissions/academy/class/pyromancy
	name = "Пиромантия от А до Я"

/obj/item/paper/fluff/awaymissions/academy/class/biology
	name = "Биолаборатория"

/obj/item/paper/fluff/awaymissions/academy/grade/aplus
	name = "Промежуточный экзамен по призыванию"
	info = "Grade: A+ Educator's Notes: Excellent form."

/obj/item/paper/fluff/awaymissions/academy/grade/bminus
	name = "Промежуточный экзамен по призыванию"
	info = "Grade: B- Educator's Notes: Keep applying yourself, you're showing improvement."

/obj/item/paper/fluff/awaymissions/academy/grade/dminus
	name = "Промежуточный экзамен по призыванию"
	info = "Grade: D- Educator's Notes: SEE ME AFTER CLASS."

/obj/item/paper/fluff/awaymissions/academy/grade/failure
	name = "Оценка по пиромантии"
	info = "Current Grade: F. Educator's Notes: No improvement shown despite multiple private lessons.  Suggest additional tutelage."

/// The immobile, close pulling singularity seen in the academy away mission
/obj/singularity/academy
	move_self = FALSE

/obj/singularity/academy/Initialize(mapload)
	. = ..()

	var/datum/component/singularity/singularity = singularity_component.resolve()
	singularity?.grav_pull = 1

/obj/singularity/academy/process(delta_time)
	if(DT_PROB(0.5, delta_time))
		mezzer()

/obj/item/clothing/glasses/meson/truesight
	name = "Монокль Истинного Зрения"
	desc = "Я вижу ВСЕ!"
	icon_state = "monocle"
	inhand_icon_state = "headset"


/obj/structure/academy_wizard_spawner
	name = "Система Защиты Академии"
	desc = "Сделано \"Отречением.\""
	icon = 'icons/obj/cult.dmi'
	icon_state = "forge"
	anchored = TRUE
	max_integrity = 200
	var/mob/living/current_wizard = null
	var/next_check = 0
	var/cooldown = 600
	var/faction = ROLE_WIZARD
	var/braindead_check = 0

/obj/structure/academy_wizard_spawner/New()
	START_PROCESSING(SSobj, src)

/obj/structure/academy_wizard_spawner/Destroy()
	if(!broken)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/academy_wizard_spawner/process()
	if(next_check < world.time)
		if(!current_wizard)
			for(var/mob/living/L in GLOB.player_list)
				if(L.z == src.z && L.stat != DEAD && !(faction in L.faction))
					summon_wizard()
					break
		else
			if(current_wizard.stat == DEAD)
				current_wizard = null
				summon_wizard()
			if(!current_wizard.client)
				if(!braindead_check)
					braindead_check = 1
				else
					braindead_check = 0
					give_control()
		next_check = world.time + cooldown

/obj/structure/academy_wizard_spawner/proc/give_control()
	set waitfor = FALSE

	if(!current_wizard)
		return
	var/list/mob/dead/observer/candidates = poll_candidates_for_mob("Do you want to play as Wizard Academy Defender?", ROLE_WIZARD, null, 50, current_wizard, POLL_IGNORE_ACADEMY_WIZARD)

	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		message_admins("[ADMIN_LOOKUPFLW(C)] was spawned as Wizard Academy Defender")
		current_wizard.ghostize() // on the off chance braindead defender gets back in
		current_wizard.key = C.key

/obj/structure/academy_wizard_spawner/proc/summon_wizard()
	var/turf/T = src.loc
	var/mob/living/carbon/human/wizbody = new(T)
	wizbody.fully_replace_character_name(wizbody.real_name, "Academy Teacher")
	wizbody.mind_initialize()
	var/datum/mind/wizmind = wizbody.mind
	wizmind.special_role = "Academy Defender"
	wizmind.add_antag_datum(/datum/antagonist/wizard/academy)
	current_wizard = wizbody

	give_control()

/obj/structure/academy_wizard_spawner/deconstruct(disassembled = TRUE)
	if(!broken)
		broken = 1
		visible_message(span_warning("[capitalize(src.name)] ломается!"))
		icon_state = "forge_off"
		STOP_PROCESSING(SSobj, src)

/datum/outfit/wizard/academy
	name = "Маг Академии"
	r_pocket = null
	r_hand = null
	suit = /obj/item/clothing/suit/wizrobe/red
	head = /obj/item/clothing/head/wizard/red
	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/item/dice/d20/fate
	name = "\improper Кубик Судьбы"
	desc = "Кубик с двадцатью сторонами. Чувствую неестественную энергию, исходящую от него. Использовать на свой страх и риск."
	icon_state = "d20"
	sides = 20
	microwave_riggable = FALSE
	var/reusable = TRUE
	var/used = FALSE
	/// So you can't roll the die 20 times in a second and stack a bunch of effects that might conflict
	COOLDOWN_DECLARE(roll_cd)

/obj/item/dice/d20/fate/one_use
	reusable = FALSE

/obj/item/dice/d20/fate/cursed
	name = "Проклятый Кубик Судьбы"
	desc = "Кубик с двадцатью сторонами. Кидать такой будет ОЧЕНЬ плохой идеей."
	color = "#00BB00"

	rigged = DICE_TOTALLY_RIGGED
	rigged_value = 1

/obj/item/dice/d20/fate/cursed/one_use
	reusable = FALSE

/obj/item/dice/d20/fate/stealth
	name = "д20"
	desc = "Кубик с двадцатью сторонами. Желательно кидать в ГМа."

/obj/item/dice/d20/fate/stealth/one_use
	reusable = FALSE

/obj/item/dice/d20/fate/stealth/cursed
	rigged = DICE_TOTALLY_RIGGED
	rigged_value = 1

/obj/item/dice/d20/fate/stealth/cursed/one_use
	reusable = FALSE

/obj/item/dice/d20/fate/diceroll(mob/user)
	if(!COOLDOWN_FINISHED(src, roll_cd))
		to_chat(user, span_warning("Подожди, [src] еще не оправился после твоего предыдущего броска!"))
		return

	. = ..()
	if(used)
		return

	if(!ishuman(user) || !user.mind || (user.mind in SSticker.mode.wizards))
		to_chat(user, span_warning("Чувствую что магия кубика доступна только обычным людям!"))
		return

	if(!reusable)
		used = TRUE

	var/turf/T = get_turf(src)
	T.visible_message(span_userdanger("[src] тихонько мерцает."))

	addtimer(CALLBACK(src, PROC_REF(effect), user, .), 1 SECONDS)
	COOLDOWN_START(src, roll_cd, 2.5 SECONDS)

/obj/item/dice/d20/fate/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user) || !user.mind || (user.mind in SSticker.mode.wizards))
		to_chat(user, span_warning("Чувствую что магия кубика доступна только обычным людям! Лучше перестать его трогать."))
		user.dropItemToGround(src)


/obj/item/dice/d20/fate/proc/effect(mob/living/carbon/human/user,roll)
	var/turf/T = get_turf(src)
	switch(roll)
		if(1)
			//Dust
			T.visible_message(span_userdanger("[user] рассыпается в прах!"))
			user.dust()
		if(2)
			//Death
			T.visible_message(span_userdanger("[user] падает замертво!"))
			user.death()
		if(3)
			//Swarm of creatures
			T.visible_message(span_userdanger("Рой монстров окружает [user]!"))
			for(var/direction in GLOB.alldirs)
				new /mob/living/simple_animal/hostile/netherworld(get_step(get_turf(user),direction))
		if(4)
			//Destroy Equipment
			T.visible_message(span_userdanger("Все, что было на [user] вдруг исчезает!"))
			for(var/obj/item/I in user)
				if(istype(I, /obj/item/implant))
					continue
				qdel(I)
		if(5)
			//Monkeying
			T.visible_message(span_userdanger("[user] превращается в обезьяну!"))
			user.monkeyize()
		if(6)
			//Cut speed
			T.visible_message(span_userdanger("[user] двигается медленнее!"))
			user.add_movespeed_modifier(/datum/movespeed_modifier/die_of_fate)
		if(7)
			//Throw
			T.visible_message(span_userdanger("Невидимая сила бросает [user]!"))
			user.Stun(60)
			user.adjustBruteLoss(50)
			var/throw_dir = pick(GLOB.cardinals)
			var/atom/throw_target = get_edge_target_turf(user, throw_dir)
			user.throw_at(throw_target, 200, 4)
		if(8)
			//Fuel tank Explosion
			T.visible_message(span_userdanger("Реальность взрывается вокруг [user]!"))
			explosion(get_turf(user), devastation_range = -1, light_impact_range = 2, flame_range = 2, explosion_cause = src)
		if(9)
			//Cold
			var/datum/disease/D = new /datum/disease/cold()
			T.visible_message(span_userdanger("[user] чувствует себя как-то нехорошо!"))
			user.ForceContractDisease(D, FALSE, TRUE)
		if(10)
			//Nothing
			T.visible_message(span_userdanger("Ничего не происходит."))
		if(11)
			//Cookie
			T.visible_message(span_userdanger("Из воздуха материализуется печенька!"))
			var/obj/item/food/cookie/C = new(drop_location())
			do_smoke(0, drop_location())
			C.name = "Cookie of Fate"
		if(12)
			//Healing
			T.visible_message(span_userdanger("[user] выглядит очень здоровым!"))
			user.revive(full_heal = TRUE, admin_revive = TRUE)
		if(13)
			//Mad Dosh
			T.visible_message(span_userdanger("Mad dosh shoots out of [src]!"))
			var/turf/Start = get_turf(src)
			for(var/direction in GLOB.alldirs)
				var/turf/dirturf = get_step(Start,direction)
				if(rand(0,1))
					new /obj/item/stack/spacecash/c100(dirturf)
				else
					var/obj/item/storage/bag/money/M = new(dirturf)
					for(var/i in 1 to rand(5,50))
						new /obj/item/coin/gold(M)
		if(14)
			//Free Gun
			T.visible_message(span_userdanger("An impressive gun appears!"))
			do_smoke(0, drop_location())
			new /obj/item/gun/ballistic/revolver/mateba(drop_location())
		if(15)
			//Random One-use spellbook
			T.visible_message(span_userdanger("A magical looking book drops to the floor!"))
			do_smoke(0, drop_location())
			new /obj/item/book/granter/action/spell/random(drop_location())
		if(16)
			//Servant & Servant Summon
			T.visible_message(span_userdanger("A Dice Servant appears in a cloud of smoke!"))
			do_smoke(0, drop_location())

			var/datum/action/cooldown/spell/conjure/bee/bee_spell = new(user.mind)
			bee_spell.Grant(user)

		if(17)
			//Tator Kit
			T.visible_message(span_userdanger("A suspicious box appears!"))
			new /obj/item/storage/box/syndicate/bundle_a(drop_location())
			do_smoke(0, drop_location())
		if(18)
			//Captain ID
			T.visible_message(span_userdanger("A golden identification card appears!"))
			new /obj/item/card/id/advanced/gold/captains_spare(drop_location())
			do_smoke(0, drop_location())
		if(19)
			//Instrinct Resistance
			T.visible_message(span_userdanger("[user] looks very robust!"))
			user.physiology.brute_mod *= 0.5
			user.physiology.burn_mod *= 0.5

		if(20)
			//Free wizard!
			T.visible_message(span_userdanger("Magic flows out of [src] and into [user]!"))
			user.mind.make_Wizard()

/datum/outfit/butler
	name = "Butler"
	uniform = /obj/item/clothing/under/suit/black_really
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/bowler
	glasses = /obj/item/clothing/glasses/monocle
	gloves = /obj/item/clothing/gloves/color/white

/obj/structure/ladder/unbreakable/rune
	name = "\improper Teleportation Rune"
	desc = "Could lead anywhere."
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	color = rgb(0,0,255)

/obj/structure/ladder/unbreakable/rune/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_blocker)

/obj/structure/ladder/unbreakable/rune/use(mob/user, going_up = TRUE)
	if(!IS_WIZARD(user))
		..()
