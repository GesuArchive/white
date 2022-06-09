/obj/item/sensor_device
	name = "Монитор жизненных показателей экипажа"
	desc = "Позволяет наблюдать данные с датчиков жизнеобеспечения аналогично Консоли наблюдения за Экипажем."
	icon = 'icons/obj/device.dmi'
	icon_state = "scanner"
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	custom_price = PAYCHECK_MEDIUM * 5
	custom_premium_price = PAYCHECK_MEDIUM * 6

/obj/item/sensor_device/attack_self(mob/user)
	GLOB.crewmonitor.show(user,src) //Proc already exists, just had to call it
