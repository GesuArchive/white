#define BSRPD_CAPAC_MAX 250
#define BSRPD_CAPAC_USE 1
#define BSRPD_CAPAC_NEW 125

/obj/item/pipe_dispenser/bluespace
	name = "Блюспейс-RPD"
	desc = "Пример, когда технологии позволяют не свариться в собственном соку при постройке очередного двигателя."
	icon = 'icons/obj/tools.dmi'
	icon_state = "bsrpd"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	inhand_icon_state = "bsrpd"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	custom_materials = null
	var/bs_capac = BSRPD_CAPAC_MAX
	var/bs_use = BSRPD_CAPAC_USE
	var/bs_prog = 0

/obj/item/pipe_dispenser/bluespace/attackby(obj/item/item, mob/user, param)
	if(istype(item, /obj/item/stack/sheet/bluespace_crystal))
		if(BSRPD_CAPAC_NEW > (BSRPD_CAPAC_MAX - bs_capac) || bs_use == 0)
			to_chat(user, span_warning("Не могу больше зарядить [src]!"))
			return
		item.use(1)
		to_chat(user, span_notice("Перезаряжаю блюспейс-конденсатор внутри [src]"))
		bs_capac += BSRPD_CAPAC_NEW
		return
	if(istype(item, /obj/item/assembly/signaler/anomaly/bluespace))
		if(bs_use)
			to_chat(user, span_notice("Вставляю [item] в [src]; теперь эта штука будет работать намного дольше!"))
			bs_use = 0
			qdel(item)
		else
			to_chat(user, span_warning("Куда заряжать [src] больше то!"))
		return
	return ..()

/obj/item/pipe_dispenser/bluespace/examine(mob/user)
	. = ..()
	if(user.Adjacent(src))
		. += "<hr>На данный момент имеет [bs_use == 0 ? "бесконечное количество" : bs_capac / bs_use] зарядов в остатке."
		if(bs_use != 0)
			. += "\nБлюспейс-ядро не установлено."
	else
		. += "<hr>Не могу разглядеть заряд отсюда."

/obj/item/pipe_dispenser/bluespace/afterattack(atom/target, mob/user, prox)
	if(prox) // If we are in proximity to the target, don't use charge and don't call this shitcode.
		return ..()
	if(bs_capac < (bs_use * (bs_prog + 1)))
		to_chat(user, span_warning("Ох, [src] не имеет заряда."))
		return FALSE
	bs_prog++ // So people can't just spam click and get more uses
	user.Beam(target, icon_state = "rped_upgrade", time = 1 SECONDS)
	if(pre_attack(target, user))
		bs_prog--
		bs_capac -= bs_use
		return TRUE
	bs_prog--
	return FALSE

#undef BSRPD_CAPAC_MAX
#undef BSRPD_CAPAC_USE
#undef BSRPD_CAPAC_NEW
