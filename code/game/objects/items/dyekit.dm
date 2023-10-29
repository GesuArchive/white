/obj/item/dyespray
	name = "краска для волос"
	desc = "Можно покрасить волосы во всякие цвета."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/dyespray.dmi'
	icon_state = "dyespray"

/obj/item/dyespray/attack_self(mob/user)
	dye(user, user)

/obj/item/dyespray/pre_attack(atom/target, mob/living/user, params)
	dye(target, user)
	return ..()

/**
 * Applies a gradient and a gradient color to a mob.
 *
 * Arguments:
 * * target - The mob who we will apply the gradient and gradient color to.
 */

/obj/item/dyespray/proc/dye(mob/target, mob/user)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/human_target = target
	var/beard_or_hair = tgui_input_list(user, "Что будем красить?", "Краска", list("Волосы", "Бороду"))
	if(!beard_or_hair || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE))
		return

	var/list/choices = beard_or_hair == "Волосы" ? GLOB.hair_gradients_list : GLOB.facial_hair_gradients_list
	var/new_grad_style = tgui_input_list(user, "Выберем шаблон:", "Краска", choices)
	if(!new_grad_style || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE))
		return

	var/new_grad_color = input(user, "Выберем цвет:", "Краска",human_target.grad_color) as color|null
	if(!new_grad_color || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE) || !user.CanReach(target))
		return

	to_chat(user, span_notice("Начинаю красить [lowertext(beard_or_hair)]..."))
	if(!do_after(user, 3 SECONDS, target))
		return
	var/gradient_key = beard_or_hair == "Волосы" ? GRADIENT_HAIR_KEY : GRADIENT_FACIAL_HAIR_KEY
	LAZYSETLEN(human_target.grad_style, GRADIENTS_LEN)
	LAZYSETLEN(human_target.grad_color, GRADIENTS_LEN)
	human_target.grad_style[gradient_key] = new_grad_style
	human_target.grad_color[gradient_key] = sanitize_hexcolor(new_grad_color)
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 5)
	human_target.update_hair()
