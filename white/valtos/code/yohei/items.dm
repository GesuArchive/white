/obj/item/clothing/under/syndicate/yohei
	name = "униформа йохея"
	desc = "Удобная и практичная одежда для самой грязной работы."
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	inhand_icon_state = "bl_suit"
	can_adjust = FALSE
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/clothing/under/syndicate/yohei/blue
	desc = "Удобная и практичная одежда для самой грязной работы. Эта синяя."
	icon_state = "yohei_blue"
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 25, RAD = 10, FIRE = 75, ACID = 90)

/obj/item/clothing/under/syndicate/yohei/red
	desc = "Удобная и практичная одежда для самой грязной работы. Эта красная."
	icon_state = "yohei_red"
	armor = list(MELEE = 15, BULLET = 15, LASER = 15, ENERGY = 15, BOMB = 15, BIO = 10, RAD = 10, FIRE = 60, ACID = 50)

/obj/item/clothing/under/syndicate/yohei/yellow
	desc = "Удобная и практичная одежда для самой грязной работы. Эта жёлтая."
	icon_state = "yohei_yellow"
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 25, BOMB = 25, BIO = 10, RAD = 25, FIRE = 75, ACID = 75)

/obj/item/clothing/under/syndicate/yohei/green
	desc = "Удобная и практичная одежда для самой грязной работы. Эта зелёная."
	icon_state = "yohei_green"
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 50, BIO = 10, RAD = 10, FIRE = 90, ACID = 50)

/obj/item/clothing/mask/breath/yohei
	name = "маска йохея"
	desc = "Обтягивающая и плотно сидящая маска, которая может быть подключена к источнику воздуха."
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH | MASKCOVERSEYES | PEPPERPROOF
	visor_flags_cover = MASKCOVERSMOUTH | MASKCOVERSEYES | PEPPERPROOF
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/mask.dmi'
	icon = 'white/valtos/icons/clothing/masks.dmi'
	inhand_icon_state = "sechailer"
	equip_delay_other = 50
	armor = list(MELEE = 25, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/clothing/shoes/jackboots/yohei
	name = "сапоги йохея"
	desc = "Модные ботинки, которые обычно носят наёмники."
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/shoe.dmi'
	icon = 'white/valtos/icons/clothing/shoes.dmi'
	equip_delay_other = 60
	armor = list(MELEE = 25, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/clothing/gloves/combat/yohei
	name = "перчатки йохея"
	desc = "Образец того как NanoTrasen не доверяет своим работникам. Защищают неплохо от всего"
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/glove.dmi'
	icon = 'white/valtos/icons/clothing/gloves.dmi'
	inhand_icon_state = "blackgloves"
	armor = list(MELEE = 25, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/clothing/suit/hooded/yohei
	name = "плащ йохея"
	desc = "Весьма дорогостоящее многофункциональное оборудование... А вот это просто плащ."
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	inhand_icon_state = "coatwinter"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	heat_protection = CHEST|GROIN|ARMS|LEGS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	armor = list(MELEE = 25, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)
	hoodtype = /obj/item/clothing/head/hooded/yohei
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/gun, /obj/item/pickaxe, /obj/item/cat_hook, /obj/item/storage/belt)
	var/blessed = FALSE

/obj/item/clothing/suit/hooded/yohei/Initialize(mapload)
	. = ..()
	create_storage(type = /datum/storage/pockets)
	atom_storage.max_slots = 3
	atom_storage.max_total_storage = 5
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL

/obj/item/clothing/suit/hooded/yohei/ToggleHood()
	. = ..()
	if(!blessed)
		return

	if(suittoggled)
		icon_state = "yohei_white_t"
	else
		icon_state = "yohei_white"

	var/mob/living/carbon/human/H = loc
	H?.update_inv_wear_suit()

/obj/item/clothing/suit/hooded/yohei/RemoveHood()
	. = ..()
	if(!blessed)
		return

	if(suittoggled)
		icon_state = "yohei_white_t"
	else
		icon_state = "yohei_white"

	var/mob/living/carbon/human/H = loc
	H?.update_inv_wear_suit()

/obj/item/clothing/head/hooded/yohei
	name = "капюшон йохея"
	desc = "Не даст башке замёрзнуть и защитит от большинства угроз."
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	flags_inv = HIDEHAIR|HIDEEARS|HIDEEYES
	armor = list(MELEE = 25, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/shadowcloak/yohei
	name = "генератор маскировки"
	desc = "Делает невидимым на непродолжительное время. Заряжается в темноте."
	icon = 'white/valtos/icons/clothing/belts.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	icon_state = "cloak"
	inhand_icon_state = "assaultbelt"
	worn_icon_state = "cloak"
	charge = 200
	max_charge = 200

/obj/item/shadowcloak/yohei/process(delta_time)
	var/turf/T = get_turf(src)
	if(on)
		var/lumcount = T.get_lumcount()
		if(lumcount > 0.3)
			charge = max(0, charge - 25 * delta_time)//Quick decrease in light
		else
			charge = min(max_charge, charge + 30 * delta_time) //Charge in the dark
		animate(user, alpha = clamp(255 - charge, 0, 255), time = 10)

/obj/item/gun/ballistic/automatic/pistol/fallout/yohei9mm
	name = "высокоточный пистолет"
	desc = "Пистолет малой мощности и несбывшихся надежд. Возможно последний экземпляр."
	icon_state = "gosling"
	inhand_icon_state = "devil"
	mag_type = /obj/item/ammo_box/magazine/fallout/m9mm
	fire_sound = 'white/valtos/sounds/fallout/gunsounds/9mm/9mm2.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	fire_delay = 4
	extra_damage = 10
	extra_penetration = 10
	legacy_icon_handler = FALSE

#define MODE_PAINKILLER "болеутоляющее"
#define MODE_OXYLOSS "кислородное голодание"
#define MODE_TOXDUMP "токсины"
#define MODE_FRACTURE "травмы"
#define MODE_BLOOD_INJECTOR "вливание крови"

/obj/item/pamk
	name = "ПАМК"
	desc = "Полевой Автоматический Медицинский Комплект. Инструкция сообщает: воткните в конечность и она исцелится."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "pamk_100"
	w_class = WEIGHT_CLASS_SMALL
	var/charge_left = 100
	var/current_mode = MODE_PAINKILLER

/obj/item/pamk/update_icon()
	. = ..()
	switch(charge_left)
		if(0)
			icon_state = "pamk_0"
		if(1 to 25)
			icon_state = "pamk_25"
		if(26 to 50)
			icon_state = "pamk_50"
		if(51 to 75)
			icon_state = "pamk_75"
		if(76 to 100)
			icon_state = "pamk_100"

/obj/item/pamk/proc/use_charge(amount)
	if(amount > charge_left)
		return FALSE
	charge_left -= amount
	playsound(get_turf(src), 'white/valtos/sounds/pamk_use.ogg', 80)
	update_icon()
	return TRUE

/obj/item/pamk/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'><b>ЗАРЯД:</b></span> [charge_left]/100.</span>"
	. += span_notice("\n<b>РЕЖИМ:</b></span> [uppertext(current_mode)].")

/obj/item/pamk/attack_self(mob/user)
	. = ..()
	var/new_mode
	switch(current_mode)
		if(MODE_PAINKILLER)
			new_mode = MODE_OXYLOSS
		if(MODE_OXYLOSS)
			new_mode = MODE_TOXDUMP
		if(MODE_TOXDUMP)
			new_mode = MODE_FRACTURE
		if(MODE_FRACTURE)
			new_mode = MODE_BLOOD_INJECTOR
		if(MODE_BLOOD_INJECTOR)
			new_mode = MODE_PAINKILLER
	current_mode = new_mode
	playsound(get_turf(src), 'white/valtos/sounds/pamk_mode.ogg', 80)
	to_chat(user, span_notice("<b>РЕЖИМ:</b></span> [uppertext(current_mode)]."))

/obj/item/pamk/attack(mob/living/M, mob/user)
	. = ..()
	try_heal(M, user)

/obj/item/pamk/proc/try_heal(mob/living/M, mob/user)
	var/obj/item/bodypart/limb = M.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, span_notice("А куда колоть то?!"))
		return
	switch(current_mode)
		if(MODE_PAINKILLER)
			if(M.getBruteLoss() > 10 || M.getFireLoss() > 10)
				if(use_charge(10))
					M.heal_overall_damage(25, 25)
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Не обнаружено повреждений, либо они незначительны."))
		if(MODE_OXYLOSS)
			if(M.getOxyLoss() > 5)
				if(use_charge(10))
					M.setOxyLoss(0)
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Уровень кислорода в норме."))
		if(MODE_TOXDUMP)
			if(M.getToxLoss() > 5)
				if(use_charge(20))
					M.setToxLoss(0)
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Токсины отсутствуют."))
		if(MODE_FRACTURE)
			if(limb?.wounds?.len)
				if(use_charge(20))
					for(var/thing in limb.wounds)
						var/datum/wound/W = thing
						W.remove_wound()
					to_chat(user, span_notice("Успешно исправили все переломы и вывихи в этой конечности."))
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Не обнаружено травм в этой конечности."))
		if(MODE_BLOOD_INJECTOR)
			if(M.blood_volume <= initial(M.blood_volume) - 50)
				if(use_charge(30))
					M.restore_blood()
					to_chat(user, span_notice("Кровь восстановлена."))
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, "<span class='warning'>Уровень крови в пределах нормы.</span>")
	user.changeNext_move(4 SECONDS) // ебало йохея представили?


#undef MODE_PAINKILLER
#undef MODE_OXYLOSS
#undef MODE_TOXDUMP
#undef MODE_FRACTURE
#undef MODE_BLOOD_INJECTOR

/obj/item/card/id/yohei
	name = "странная карточка"
	desc = "Что это такое?"
	icon_state = "yohei"
	assignment = "Yohei"
	registered_age = 666
	access = list(ACCESS_YOHEI, ACCESS_MAINT_TUNNELS)
	var/datum/mind/assigned_to
	var/assigned_by

/obj/item/card/id/yohei/Initialize(mapload)
	. = ..()
	var/datum/bank_account/bank_account = new /datum/bank_account(name)
	registered_account = bank_account
	registered_account.adjust_money(12000)

/obj/item/card/id/yohei/update_label()
	if(assigned_by)
		name = "Наёмный рабочий ([assigned_by])"
	else
		name = "[uppertext(copytext_char(md5("[rand(1, 10)][name]"), 1, 4))]-[rand(100000, 999999)]"

/obj/item/card/id/yohei/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_YOHEI))
		var/obj/lab_monitor/yohei/LM = GLOB.yohei_main_controller
		if(LM)
			LM.internal_radio.talk_into(LM, "ВНИМАНИЕ: [user.name] пытался провернуть аферу с наймом внутри фирмы. Сломайте ему колени.", FREQ_YOHEI)
	if(!isidcard(W) || istype(W, /obj/item/card/id/yohei))
		return

	if(assigned_by || assigned_to.special_role)
		to_chat(user, span_danger("Уже кем-то нанят, какая жалость."))
		return

	if(assigned_to && user?.mind != assigned_to)
		var/mob/living/carbon/human/H = assigned_to.current
		if(!H || H?.stat)
			to_chat(user, span_danger("Не обнаружен дееспособный Йохей..."))
			return

		var/obj/item/clothing/under/syndicate/yohei/YU = H.get_item_by_slot(ITEM_SLOT_ICLOTHING)
		var/obj/item/clothing/suit/hooded/yohei/YS = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		var/obj/item/clothing/head/hooded/yohei/YH = H.get_item_by_slot(ITEM_SLOT_HEAD)
		var/obj/item/clothing/shoes/jackboots/yohei/YF = H.get_item_by_slot(ITEM_SLOT_FEET)
		if(!istype(YS) || !istype(YH) || !istype(YU) || !istype(YF))
			to_chat(user, span_danger("Йохей должен быть в своих униформе, ботинках, плаще и с капюшоном на голове."))
			return

		YS.icon_state = "yohei_white"
		YS.blessed = TRUE
		YH.icon_state = "yohei_white"
		YU.icon_state = "yohei_white"
		YF.icon_state = "yohei_white"

		H.update_inv_w_uniform()
		H.update_inv_wear_suit()
		H.update_inv_head()
		H.update_inv_shoes()

		var/obj/item/card/id/ID = W
		if(ID.registered_name)
			assigned_by = ID.registered_name
			assigned_to.special_role = "yohei"
			var/datum/antagonist/yohei/V = new
			V.protected_guy = user.mind
			assigned_to.add_antag_datum(V)
			to_chat(user, span_notice("Успешно нанимаю [assigned_to.name]. Теперь меня точно защитят."))
			update_label()
			GLOB.data_core.manifest_inject(H)
			var/obj/item/card/id/IA = W
			LAZYADD(ID.access, IA.access)
			var/obj/lab_monitor/yohei/LM = GLOB.yohei_main_controller
			if(LM)
				LM.internal_radio.set_frequency(FREQ_SECURITY)
				LM.internal_radio.talk_into(LM, "ВНИМАНИЕ: Один из наших наёмников по имени [assigned_to.name] был нанят членом вашего экипажа. Досье на него было передано вам. Пожалуйста, обращайтесь с ним бережно, иначе мы применим штрафы согласно пунктам договора о взаимном сотрудничестве 3.1.5 и 4.12.1.", FREQ_SECURITY)
				LM.internal_radio.set_frequency(FREQ_YOHEI)
		else
			to_chat(user, span_danger("Карта неисправна. Самоутилизация активирована."))
			qdel(W)

/obj/item/book/yohei_codex
	name = "Буклет корпоративной этики"
	desc = "Важный информационный буклет."
	author = "ERROR404NOTFOUND"
	title = "Кодекс Йохея"
	icon_state = "stealthmanual"
	dat = {"<!DOCTYPE html>
	<html>
	<style>
	body
	{
		background-image: url("https://cdn.discordapp.com/attachments/892139729066270740/997608933009145946/yohei.jpg");
	}
	font
	{
		font-family: Courier New;
	}

	.main
	{
		color: #CCCFCF;
	}

	.red
	{
		color: #F76E6E;
	}
	</style></head>
	<body><font class="main">

    <center><h1>Йохейский устав: редакция Y corp</h1></center>
    <i>«Ты профессионал. Даже если всё идет вниз по наклонной, веди себя как профессионал.»</i>
    <br> — Рекрутер Y corp.
    <ul>
      <li><font class="red">Массовый геноцид ведет к терминации базового контракта.</font> Исключение - индивиды, непосредственно препятствующие выполнению контракта в момент его исполнения.</li>
      <li><font class="red">Крупные акты террора и саботажа</font> сильно дискредитируют корпорацию Y. Мы не Синдикат. При выполнении базовых контрактов соблюдайте указания ниже.</li>
      <ul>
        <li>По возможности избегайте мощных <font color="#FFC964">взрывов</font>, саботажа <font color="E498FF">сингулярности</font> и дестабилизации <font color="FCFFA4">суперматерии.</font></li>
        <li>Корабль очень важен для корпорации Y. Исключите на нем хранение вещей, которые могут привлечь внимание третьих лиц.</li>
        <li>В этот список попадают <font color="93F19C">диск ядерной аутентификации</font>, <font color="979797">черный ящик</font>, <font color="9AC5FF">ручной телепортер</font> и прочие предметы из категории высокого риска.</li>
        <li>При наличии таких предметов их необходимо <font class="red">ОБЯЗАТЕЛЬНО сбросить при возвращении на базу.</font></li>
        <li>Если наши аудиторы заметят подобные предметы, то к вам применят санкции. А мы - <font class="red">уволим вас</font> по статье.</li>
      </ul>
      <li>Последствия выполнения базовых контрактов не ваша забота.</li>
      <li>Начиная работать частно по протоколу 'WhiteHat' ваше участие в базовых контрактах запрещено.</li>
      <li>Старайся выполнить все прихоти нанимателя, кто платит, тот и заказывает музыку.</li>
    </ul>

    <center><h1>Рекомендации по кодексу Йохея</h1></center>
    <i>«Никто не смеет прострелить мне жопу и уйти безнаказанным»</i>
    <br> — Неизвестный наемник.
    <ul>
      <li>Наемник всегда готов отправиться куда угодно и встретить любую опасность.</li>
      <li>Никаких друзей, никаких врагов. Только союзники и противники.</li>
      <li>Всегда будь вежлив с клиентом.</li>
      <li>Наемник никогда не жалуется.</li>
      <li>Наемник не имеет привязанностей.</li>
      <li>Меняй распорядок. Пробуй разные способы, если прошлый не удался. Даже неудачный опыт приносит пользу.</li>
      <li>Никогда не привлекай к себе лишнего внимания.</li>
      <li>Не говори больше нужного.</li>
      <li>Будь вежлив всегда. Особенно с врагами.</li>
      <li>Дипломатия режет лучше ножа.</li>
      <li>Делай то, чего боишься больше всего, и обретешь храбрость.</li>
      <li>Воображение — главное оружие воина.</li>
      <li>Наемник никогда не отвлекается на общую картину. Мелочи играют главную роль.</li>
      <li>Никогда не говори всю правду, торгуясь.</li>
      <li>Услуга — это инвестиция.</li>
      <li>Деньги — это сила.</li>
      <li>Будь осторожен в любой ситуации.</li>
      <li>Если ты должен умереть, умирай не напрастно.</li>
    </ul>
    <b>Следуя данному кодексу Вы в полном праве можете называть себя Йохеем.</b> Наверное.
<br><small><small>Корпорация Y является частью холдинга «Алый Раcсвет»</small></small><br>
<p align="right">Все права защищены. ©</p>

	</font></body>"}

/obj/item/cat_hook
	name = "кошкокрюк"
	desc = "Элегантный инструмент для внезапного прониковения и исчезновения. Достаточно лишь понять куда им можно выстрелить."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "cat_hook"
	inhand_icon_state = "smg10mm"
	worn_icon_state = "gun"
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BELT

/obj/item/cat_hook/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(.)
		return

	if(!target || !user)
		return

	if(!proximity_flag)
		return

	if(!HAS_TRAIT(user, TRAIT_YOHEI))
		if(!do_after(user, 1 SECONDS, target = user))
			return
		user.visible_message(span_warning("[user] стреляет себе в ногу!"),
			span_userdanger("Успешно стреляю себе в ногу..."))
		var/mob/living/carbon/human/thinky = user
		thinky.apply_damage(30, BRUTE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), wound_bonus = CANT_WOUND)
		playsound(get_turf(user), 'white/valtos/sounds/cathit.ogg', 60)
		return

	if(!isturf(target))
		return

	var/turf/T = target
	var/turf/picked
	if(isopenspace(T))
		T = SSmapping.get_turf_below(get_turf(T))

	if(!isspaceturf(T))
		to_chat(user, span_danger("Не получится здесь. Нужен космос."))
		return

	if(!do_after(user, 5 SECONDS, target = T, interaction_key = DOAFTER_SOURCE_HOOK_TARGETTING))
		return

	if(is_station_level(T.z))
		picked = get_turf(pick(GLOB.yohei_beacons))
		to_chat(user, span_notice("Успешно нацеливаюсь на наш корабль..."))
	else
		picked = get_turf(pick(GLOB.xeno_spawn))
		to_chat(user, span_notice("Успешно нацеливаюсь на станцию..."))

	if(!do_after(user, 1 SECONDS, target = T, interaction_key = DOAFTER_SOURCE_HOOK_PRE_SHOOTING))
		return

	to_chat(user, span_notice("Произвожу выстрел..."))
	playsound(get_turf(user), 'white/valtos/sounds/catlaunch.ogg', 90)
	if(!do_after(user, 10 SECONDS, target = T, interaction_key = DOAFTER_SOURCE_HOOK_SHOOTING))
		return

	if(!prob(75))
		to_chat(user, span_reallybig("МИМО!"))
		return

	to_chat(user, span_reallybig("ЕСТЬ!"))
	playsound(get_turf(user), 'white/valtos/sounds/cathit.ogg', 60)
	if(do_after(user, 5 SECONDS, target = T, interaction_key = DOAFTER_SOURCE_HOOK_PULLING))
		var/mob/living/carbon/human/H = user
		H.zMove(target = picked, z_move_flags = ZMOVE_CHECK_PULLEDBY|ZMOVE_ALLOW_BUCKLED|ZMOVE_INCLUDE_PULLED)
		H.adjustStaminaLoss(100)
		to_chat(user, span_notice("Вот я и на месте!"))
	return

/obj/item/defibrillator/compact/loaded/yohei
	combat = TRUE
	safety = FALSE
