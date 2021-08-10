/datum/computer_file/program/surgmaster
	filename = "SurgMaster"
	filedesc = "SurgMaster"
	extended_desc = "Эта программа позволяет проводить комплексные операции в полевых условиях. Находится на стадии разработки и превратит ваш девайс в кирпич при запуске. Зато работает!"
	requires_ntnet = TRUE
	transfer_access = ACCESS_MEDICAL
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_LAPTOP
	program_icon = "stethoscope"
	size = 12
	tgui_id = "валера зделай тгхуй блин штоб отображались хирургии тут или чет такое, мне пиздец впадлу это говно трогать"
	var/list/advanced_surgeries = list()

/datum/computer_file/program/surgmaster/tap(atom/A, mob/living/user)
	if(istype(A, /obj/item/disk/surgery))
		to_chat(user, "<span class='notice'>Загружаю хирургические протоколы из [A] в [filename].</span>")
		var/obj/item/disk/surgery/D = A
		if(do_after(user, 10, target = A))
			advanced_surgeries |= D.surgeries
			return TRUE
	if(istype(A, /obj/machinery/computer/operating))
		to_chat(user, "<span class='notice'>Копирую хирургические протоколы из [A] в [filename].</span>")
		var/obj/machinery/computer/operating/OC = A
		if(do_after(user, 10, target = A))
			advanced_surgeries |= OC.advanced_surgeries
			return TRUE

/datum/computer_file/program/surgmaster/proc/can_start_surgery(surgtype, replacedby) //мб приколы с дисками впилить потом
	if(replacedby in advanced_surgeries)
		return FALSE
	if(surgtype in advanced_surgeries)
		return TRUE

/datum/computer_file/program/surgmaster/clone()
	var/datum/computer_file/program/surgmaster/temp = ..()
	temp.advanced_surgeries = advanced_surgeries
	return temp

/datum/computer_file/program/surgmaster/ui_act(action, params)
	. = ..()
	if(.)
		return

/datum/computer_file/program/surgmaster/ui_data(mob/user)
	var/list/data = get_header_data()
	return data
