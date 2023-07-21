// Embedded signaller used in anomalies.
/obj/item/assembly/signaler/anomaly
	name = "ядро аномалии"
	desc = "Нейтрализованное ядро аномалии. Вероятно, это было бы ценно для исследований."
	icon_state = "anomaly_core"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	resistance_flags = FIRE_PROOF
	var/anomaly_type = /obj/effect/anomaly

/obj/item/assembly/signaler/anomaly/receive_signal(datum/signal/signal)
	if(!signal)
		return FALSE
	if(signal.data["code"] != code)
		return FALSE
	if(suicider)
		manual_suicide(suicider)
	for(var/obj/effect/anomaly/A in get_turf(src))
		A.anomalyNeutralize()
	return TRUE

/obj/item/assembly/signaler/anomaly/manual_suicide(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] [src] is reacting to the radio signal, warping [user.ru_ego()] body!"))
	user.set_suicide(TRUE)
	user.suicide_log()
	user.gib()

/obj/item/assembly/signaler/anomaly/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_ANALYZER)
		to_chat(user, span_notice("Анализ... [src] стабилизированное поле колеблется по частоте [format_frequency(frequency)], код [code]."))
	return ..()

//Anomaly cores
/obj/item/assembly/signaler/anomaly/pyro
	name = "ядро пирокластерной аномалии"
	desc = "Нейтрализованное ядро пирокластической аномалии. Оно теплое на ощупь. Вероятно, это было бы ценно для исследований."
	icon_state = "pyro_core"
	anomaly_type = /obj/effect/anomaly/pyro

/obj/item/assembly/signaler/anomaly/grav
	name = "ядро гравитационной аномалии"
	desc = "Нейтрализованное ядро гравитационной аномалии. На ощупь оно гораздо тяжелее, чем выглядит. Вероятно, это было бы ценно для исследований."
	icon_state = "grav_core"
	anomaly_type = /obj/effect/anomaly/grav

/obj/item/assembly/signaler/anomaly/flux
	name = "ядро электромагнитной аномалии"
	desc = "Нейтрализованное ядро электромагнитной аномалии. Прикосновение к нему вызывает покалывание на коже. Вероятно, это было бы ценно для исследований."
	icon_state = "flux_core"
	anomaly_type = /obj/effect/anomaly/flux

/obj/item/assembly/signaler/anomaly/bluespace
	name = "ядро блюспейс аномалии"
	desc = "Нейтрализованное ядро блюспейс аномалии. Оно то появляется, то исчезает из поля зрения. Вероятно, это было бы ценно для исследований."
	icon_state = "anomaly_core"
	anomaly_type = /obj/effect/anomaly/bluespace

/obj/item/assembly/signaler/anomaly/vortex
	name = "ядро вихревой аномалии"
	desc = "Нейтрализованное ядро вихревой аномалии. Оно не может оставаться на месте, как будто на него действует какая-то невидимая сила. Вероятно, это было бы ценно для исследований."
	icon_state = "vortex_core"
	anomaly_type = /obj/effect/anomaly/bhole

/obj/item/assembly/signaler/anomaly/bioscrambler
	name = "ядро биоконверсионной аномалии"
	desc = "Нейтрализованное ядро биоконверсионной аномалии. Оно извивается, как будто движется. Вероятно, это было бы ценно для исследований."
	icon_state = "bioscrambler_core"
	anomaly_type = /obj/effect/anomaly/bioscrambler
/obj/item/assembly/signaler/anomaly/hallucination
	name = "ядро галюциногенной аномалии"
	desc = "Нейтрализованное ядро галюциногенной аномалии. Кажется, что оно движется, но, вероятно, это ваше воображение. Вероятно, это было бы ценно для исследований."
	icon_state = "hallucination_core"
	anomaly_type = /obj/effect/anomaly/hallucination

/obj/item/assembly/signaler/anomaly/dimensional
	name = "ядро пространственной аномалии"
	desc = "Нейтрализованное ядро пространственной аномалии. Объекты, отражающиеся на его поверхности, выглядят не совсем правильно. Вероятно, это было бы ценно для исследований."
	icon_state = "dimensional_core"
	anomaly_type = /obj/effect/anomaly/dimensional
