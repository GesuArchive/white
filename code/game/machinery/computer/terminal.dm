//Basic computer meant for basic detailing in ruins and away missions, NOT meant for the station
/obj/machinery/computer/terminal
	name = "терминал"
	desc = "Относительно низкотехнологичное решение для внутренних вычислений, внутренней сетевой почты и ведения журналов. Эта модель выглядит довольно старой."
	circuit = /obj/item/circuitboard/computer/terminal //Deconstruction still wipes contents but this is easier than smashing the console
	///Text that displays on top of the actual 'lore' funnies.
	var/upperinfo = "АВТОРСКОЕ ПРАВО 2487 ООО \"НАНОСОФТ\" - НЕ РАСПРОСТРАНЯТЬ"
	///Text this terminal contains, not dissimilar to paper. Unlike paper, players cannot add or edit existing info.
	var/content = list("Поздравляем с приобретением терминала от ООО \"НаноСофт\"! Дальнейшие инструкции по настройке доступны в руководстве пользователя. Для получения лицензии и регистрации обратитесь к лицензированному поставщику NanoSoft и представителю службы ремонта.")
	///The TGUI theme this console uses. Defaults to hackerman, a retro greeny pallete which should fit most terminals.
	var/tguitheme = "hackerman"

/obj/machinery/computer/terminal/ui_interact(mob/user, datum/tgui/ui)
	..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Terminal", name) //The paper tgui file scares me, so new type of UI
		ui.open()

/obj/machinery/computer/terminal/ui_static_data(mob/user)
	return list(
		"messages" = content,
		"uppertext" = upperinfo,
		"tguitheme" = tguitheme,
	)
