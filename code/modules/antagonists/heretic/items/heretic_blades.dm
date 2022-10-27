
/obj/item/melee/sickly_blade
	name = "\improper sickly blade"
	desc = "A sickly green crescent blade, decorated with an ornamental eye. You feel like you're being watched..."
	icon = 'icons/obj/eldritch.dmi'
	icon_state = "eldritch_blade"
	inhand_icon_state = "eldritch_blade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	flags_1 = CONDUCT_1
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_NORMAL
	force = 17
	throwforce = 10
	hitsound = 'sound/weapons/stab1.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "rends")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "rend")
	var/after_use_message = ""

/obj/item/melee/sickly_blade/attack(mob/living/M, mob/living/user)
	if(!IS_HERETIC_OR_MONSTER(user))
		to_chat(user, span_danger("You feel a pulse of alien intellect lash out at your mind!"))
		var/mob/living/carbon/human/human_user = user
		human_user.AdjustParalyzed(5 SECONDS)
		return TRUE

	return ..()

/obj/item/melee/sickly_blade/attack_self(mob/user)
	var/turf/safe_turf = find_safe_turf(zlevels = z, extended_safety_checks = TRUE)
	if(IS_HERETIC_OR_MONSTER(user))
		if(do_teleport(user, safe_turf, channel = TELEPORT_CHANNEL_MAGIC))
			to_chat(user, span_warning("As you shatter [src], you feel a gust of energy flow through your body. [after_use_message]"))
		else
			to_chat(user, span_warning("You shatter [src], but your plea goes unanswered."))
	else
		to_chat(user,span_warning("You shatter [src]."))
	playsound(src, SFX_SHATTER, 70, TRUE) //copied from the code for smashing a glass sheet onto the ground to turn it into a shard
	qdel(src)

/obj/item/melee/sickly_blade/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!isliving(target))
		return

	if(proximity_flag)
		SEND_SIGNAL(user, COMSIG_HERETIC_BLADE_ATTACK, target, src)
	else
		SEND_SIGNAL(user, COMSIG_HERETIC_RANGED_BLADE_ATTACK, target, src)

/obj/item/melee/sickly_blade/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user))
		return

	. += span_notice("You can shatter the blade to teleport to a random, (mostly) safe location by <b>activating it in-hand</b>.")

// Path of Rust's blade
/obj/item/melee/sickly_blade/rust
	name = "\improper rusted blade"
	desc = "This crescent blade is decrepit, wasting to rust. \
		Yet still it bites, ripping flesh and bone with jagged, rotten teeth."
	icon_state = "rust_blade"
	inhand_icon_state = "rust_blade"
	after_use_message = "The Rusted Hills hear your call..."

// Path of Ash's blade
/obj/item/melee/sickly_blade/ash
	name = "пепельный клинок"
	desc = "Расплавленный и незавершённый кусок металла, на котором виднеются пепел и шлак. \
		Незаконченный, он желает стать чем-то большим, срезая ломти мяса своим тупым лезвием и наполняя их пеплом."
	icon_state = "ash_blade"
	inhand_icon_state = "ash_blade"
	after_use_message = "Ночной Страж услышал ваш зов..."

// Path of Flesh's blade
/obj/item/melee/sickly_blade/flesh
	name = "кровавый клинок"
	desc = "Плотоядное существо в виде серповидного клинка. \
		Будьте осторожны, ведь оно готово поделиться своими страданиями с каждой своей жертвой."
	icon_state = "flesh_blade"
	inhand_icon_state = "flesh_blade"
	after_use_message = "Маршал услышал ваш зов..."

// Path of Void's blade
/obj/item/melee/sickly_blade/void
	name = "\improper void blade"
	desc = "Devoid of any substance, this blade reflects nothingness. \
		It is a real depiction of purity, and chaos that ensues after its implementation."
	icon_state = "void_blade"
	inhand_icon_state = "void_blade"
	after_use_message = "The Aristocrat hears your call..."

// Path of the Blade's... blade
// Opting for /dark (darkened blade) instead of /blade to avoid "sickly_blade/blade".
/obj/item/melee/sickly_blade/dark
	name = "затемнённый клинок"
	desc = "Величественно сияющий серповидный клинок, изготовленный из блестящего серебра. Слепая ярость сочится изнутри."
	icon_state = "dark_blade"
	inhand_icon_state = "dark_blade"
	after_use_message = "Полковник услышал ваш зов..."
