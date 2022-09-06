/obj/item/stamp
	name = "печать \"ОДОБРЕНО\""
	desc = "Печать для штамповки важных документов."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "stamp-ok"
	inhand_icon_state = "stamp"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=60)
	pressure_resistance = 2
	attack_verb_continuous = list("штампует")
	attack_verb_simple = list("штампует")

/obj/item/stamp/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] ставит печать 'МЁРТВ' на своём лбу, а затем быстро падает замертво."))
	return (OXYLOSS)

/obj/item/stamp/qm
	name = "печать квартирмейстера"
	icon_state = "stamp-qm"
	dye_color = DYE_QM

/obj/item/stamp/law
	name = "печать адвоката"
	icon_state = "stamp-law"
	dye_color = DYE_LAW

/obj/item/stamp/captain
	name = "печать капитана"
	icon_state = "stamp-cap"
	dye_color = DYE_CAPTAIN

/obj/item/stamp/hop
	name = "печать главы персонала"
	icon_state = "stamp-hop"
	dye_color = DYE_HOP

/obj/item/stamp/hos
	name = "печать начальника охраны"
	icon_state = "stamp-hos"
	dye_color = DYE_HOS

/obj/item/stamp/ce
	name = "печать главного инженера"
	icon_state = "stamp-ce"
	dye_color = DYE_CE

/obj/item/stamp/rd
	name = "печать директора по исследованиям"
	icon_state = "stamp-rd"
	dye_color = DYE_RD

/obj/item/stamp/cmo
	name = "печать главного врача"
	icon_state = "stamp-cmo"
	dye_color = DYE_CMO

/obj/item/stamp/denied
	name = "печать \"ОТКАЗАНО\""
	icon_state = "stamp-deny"
	dye_color = DYE_REDCOAT

/obj/item/stamp/clown
	name = "печать клоуна"
	icon_state = "stamp-clown"
	dye_color = DYE_CLOWN

/obj/item/stamp/mime
	name = "печать мима"
	icon_state = "stamp-mime"
	dye_color = DYE_MIME

/obj/item/stamp/chap
	name = "печать священника"
	icon_state = "stamp-chap"
	dye_color = DYE_CHAP

/obj/item/stamp/centcom
	name = "печать центрального командования"
	icon_state = "stamp-centcom"
	dye_color = DYE_CENTCOM

/obj/item/stamp/syndicate
	name = "печать синдиката"
	icon_state = "stamp-syndicate"
	dye_color = DYE_SYNDICATE

/obj/item/stamp/attack_paw(mob/user)
	return attack_hand(user)
