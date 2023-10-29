/**
 * Returns the HTML for the status UI for this song datum.
 */
/datum/song/proc/instrument_status_ui()
	. = list()
	. += "<div class='statusDisplay'>"
	. += "<b><a href='?src=[REF(src)];switchinstrument=1'>Текущий инструмент</a>:</b> "
	if(!using_instrument)
		. += "<span class='danger'>Не выбран инструмент!</span><br>"
	else
		. += "[using_instrument.name]<br>"
	. += "Настройки воспроизведения:<br>"
	if(can_noteshift)
		. += "<a href='?src=[REF(src)];setnoteshift=1'>Сдвиг ноты</a>: [note_shift] клавиш / [round(note_shift / 12, 0.01)] октав<br>"
	var/smt
	var/modetext = ""
	switch(sustain_mode)
		if(SUSTAIN_LINEAR)
			smt = "Линейный"
			modetext = "<a href='?src=[REF(src)];setlinearfalloff=1'>Скорость Затухания Ноты</a>: [sustain_linear_duration / 10] секунд<br>"
		if(SUSTAIN_EXPONENTIAL)
			smt = "Экспоненциальный"
			modetext = "<a href='?src=[REF(src)];setexpfalloff=1'>Экспоненциальный Коэффициент спада</a>: [sustain_exponential_dropoff]% на 0.1 секунды<br>"
	. += "<a href='?src=[REF(src)];setsustainmode=1'>Метод затухания ноты</a>: [smt]<br>"
	. += modetext
	. += using_instrument?.ready()? "Статус: <span class='good'>Готов</span><br>" : "Статус: <span class='bad'>!Ошибка определения инструмента!</span><br>"
	. += "Тип инструмента: [legacy? "Традиционный" : "Синтезированный"]<br>"
	. += "<a href='?src=[REF(src)];setvolume=1'>Громкость</a>: [volume]<br>"
	. += "<a href='?src=[REF(src)];setdropoffvolume=1'>Порог Снижения Громкости</a>: [sustain_dropoff_volume]<br>"
	. += "<a href='?src=[REF(src)];togglesustainhold=1'>Бесконечно воспроизводить последнюю удерживаемую ноту</a>: [full_sustain_held_note? "Да" : "Нет"].<br>"
	. += "</div>"

/datum/song/ui_interact(mob/user)
	var/list/dat = list()

	dat += instrument_status_ui()

	if(lines.len > 0)
		dat += "<H3>Воспроизведение</H3>"
		if(!playing)
			dat += "<A href='?src=[REF(src)];play=1'>Играть</A> <SPAN CLASS='linkOn'>Остановить</SPAN><BR><BR>"
			dat += "Повторов: "
			dat += repeat > 0 ? "<A href='?src=[REF(src)];repeat=-10'>-</A><A href='?src=[REF(src)];repeat=-1'>-</A>" : span_linkoff("-</SPAN><SPAN CLASS='linkOff'>-")
			dat += " [repeat] раз/раза "
			dat += repeat < max_repeats ? "<A href='?src=[REF(src)];repeat=1'>+</A><A href='?src=[REF(src)];repeat=10'>+</A>" : span_linkoff("+</SPAN><SPAN CLASS='linkOff'>+")
			dat += "<BR>"
		else
			dat += "<SPAN CLASS='linkOn'>Играть</SPAN> <A href='?src=[REF(src)];stop=1'>Остановить</A><BR>"
			dat += "Осталось повторов: <B>[repeat]</B><BR>"
	if(!editing)
		dat += "<BR><B><A href='?src=[REF(src)];edit=2'>Показать редактор</A></B><BR>"
	else
		dat += "<H3>Редактор</H3>"
		dat += "<B><A href='?src=[REF(src)];edit=1'>Свернуть редактор</A></B>"
		dat += " <A href='?src=[REF(src)];newsong=1'>Создать новую песню</A>"
		dat += " <A href='?src=[REF(src)];import=1'>Импортировать песню</A><BR><BR>"
		var/bpm = round(600 / tempo)
		dat += "Темп: <A href='?src=[REF(src)];tempo=[world.tick_lag]'>-</A> [bpm] BPM <A href='?src=[REF(src)];tempo=-[world.tick_lag]'>+</A><BR><BR>"
		var/linecount = 0
		for(var/line in lines)
			linecount += 1
			dat += "Строка [linecount]: <A href='?src=[REF(src)];modifyline=[linecount]'>Edit</A> <A href='?src=[REF(src)];deleteline=[linecount]'>X</A> [line]<BR>"
		dat += "<A href='?src=[REF(src)];newline=1'>Add Line</A><BR><BR>"
		if(help)
			dat += "<B><A href='?src=[REF(src)];help=1'>Hide Help</A></B><BR>"
			dat += {"
					Строки - серии аккордов, разделенные запятыми (,), каждая с нотами, разделёнными дефисами (-). <br>
					Каждая нота в аккорде будет воспроизводиться вместе, а аккорд будет синхронизирован по темпу. <br>
					<br>
					Ноты воспроизводятся по названию ноты и, при необходимости, по имени и/или номеру октавы.<br>
					По умолчанию каждая нота является естественной и находится в 3-ей октаве. Определение в противном случае запоминается для каждой ноты.<br>
					Пример: <i>C,D,E,F,G,A,B</i> будут играть До мажор (C major).<br>
					После постановки ноты, она будет запоминаться: <i>C,C4,C,C3</i> is <i>C3,C4,C4,C3</i><br>
					Аккорды можно воспроизводить, просто разделяя каждую ноту дефисом: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					Пауза может быть обозначена пустым аккордом: <i>C,E,,C,G</i><br>
					Чтобы воспоизвести аккорд через другой промежуток времени, завершите его с помощью /x, где длина аккорда будет равна длине<br>
					определяется темпом / x: <i>C,G/2,E/4</i><br>
					Пример: <i>E-E4/4,F#/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Строки могут содержать до [MUSIC_MAXLINECHARS] символов.<br>
					Песня может содержать до [MUSIC_MAXLINES] строк.<br>
					"}
		else
			dat += "<B><A href='?src=[REF(src)];help=2'>Показать помощь</A></B><BR>"

	var/datum/browser/popup = new(user, "instrument", parent?.name || "instrument", 700, 500)
	popup.set_content(dat.Join(""))
	popup.open()

/**
 * Parses a song the user has input into lines and stores them.
 */
/datum/song/proc/ParseSong(new_song)
	set waitfor = FALSE
	//split into lines
	lines = islist(new_song) ? new_song : splittext(new_song, "\n")
	if(lines.len)
		var/bpm_string = "BPM: "
		if(findtext(lines[1], bpm_string, 1, length(bpm_string) + 1))
			var/divisor = text2num(copytext(lines[1], length(bpm_string) + 1)) || 120 // default
			tempo = sanitize_tempo(BPM_TO_TEMPO_SETTING(divisor))
			lines.Cut(1, 2)
		else
			tempo = sanitize_tempo(5) // default 120 BPM
		if(lines.len > MUSIC_MAXLINES)
			to_chat(usr, "Слишком много строк!")
			lines.Cut(MUSIC_MAXLINES + 1)
		var/linenum = 1
		for(var/l in lines)
			if(length_char(l) > MUSIC_MAXLINECHARS)
				to_chat(usr, "Строка [linenum] слишком длинная!")
				lines.Remove(l)
			else
				linenum++
		updateDialog(usr)		// make sure updates when complete

/datum/song/Topic(href, href_list)
	if(!usr.canUseTopic(parent, TRUE, FALSE, FALSE, FALSE))
		usr << browse(null, "window=instrument")
		usr.unset_machine()
		return

	parent.add_fingerprint(usr)

	if(href_list["newsong"])
		lines = new()
		tempo = sanitize_tempo(5) // default 120 BPM
		name = ""

	else if(href_list["import"])
		var/t = ""
		do
			t = html_encode(input(usr, "Пожалуйста вставьте песню целиком:", text("[]", name), t)  as message)
			if(!in_range(parent, usr))
				return

			if(length_char(t) >= MUSIC_MAXLINES * MUSIC_MAXLINECHARS)
				var/cont = tgui_input_list(usr, "Ваше сообщение слишком длинное! Хотели бы вы продолжить его редактирование?", "", list("yes", "no"), "yes")
				if(cont == "no")
					break
		while(length_char(t) > MUSIC_MAXLINES * MUSIC_MAXLINECHARS)
		ParseSong(t)

	else if(href_list["help"])
		help = text2num(href_list["help"]) - 1

	else if(href_list["edit"])
		editing = text2num(href_list["edit"]) - 1

	if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
		set_repeats(repeat + text2num(href_list["repeat"]))

	else if(href_list["tempo"])
		tempo = sanitize_tempo(tempo + text2num(href_list["tempo"]))

	else if(href_list["play"])
		INVOKE_ASYNC(src, PROC_REF(start_playing), usr)

	else if(href_list["newline"])
		var/newline = html_encode(input("Введите строку: ", parent.name) as text|null)
		if(!newline || !in_range(parent, usr))
			return
		if(lines.len > MUSIC_MAXLINES)
			return
		if(length(newline) > MUSIC_MAXLINECHARS)
			newline = copytext(newline, 1, MUSIC_MAXLINECHARS)
		lines.Add(newline)

	else if(href_list["deleteline"])
		var/num = round(text2num(href_list["deleteline"]))
		if(num > lines.len || num < 1)
			return
		lines.Cut(num, num+1)

	else if(href_list["modifyline"])
		var/num = round(text2num(href_list["modifyline"]),1)
		var/content = stripped_input(usr, "Введите строку: ", parent.name, lines[num], MUSIC_MAXLINECHARS)
		if(!content || !in_range(parent, usr))
			return
		if(num > lines.len || num < 1)
			return
		lines[num] = content

	else if(href_list["stop"])
		stop_playing()

	else if(href_list["setlinearfalloff"])
		var/amount = input(usr, "Установить линйную скорость затухания нот в секундах", "Линейное время затухание нот") as null|num
		if(!isnull(amount))
			set_linear_falloff_duration(amount)

	else if(href_list["setexpfalloff"])
		var/amount = input(usr, "Установить экспоненциальный коэффициент затухания нот", "Экспонициальный коэффициент затухания нот") as null|num
		if(!isnull(amount))
			set_exponential_drop_rate(amount)

	else if(href_list["setvolume"])
		var/amount = input(usr, "Установить громкость", "Громкость") as null|num
		if(!isnull(amount))
			set_volume(amount)

	else if(href_list["setdropoffvolume"])
		var/amount = input(usr, "Set dropoff threshold", "Dropoff Threshold Volume") as null|num
		if(!isnull(amount))
			set_dropoff_volume(amount)

	else if(href_list["switchinstrument"])
		if(!length(allowed_instrument_ids))
			return
		else if(length(allowed_instrument_ids) == 1)
			set_instrument(allowed_instrument_ids[1])
			return
		var/list/categories = list()
		for(var/i in allowed_instrument_ids)
			var/datum/instrument/I = SSinstruments.get_instrument(i)
			if(I)
				LAZYSET(categories[I.category || "ERROR CATEGORY"], I.name, I.id)
		var/cat = tgui_input_list(usr, "Выбрать категорию", "Категории инструментов", categories)
		if(!cat)
			return
		var/list/instruments = categories[cat]
		var/choice = tgui_input_list(usr, "Выбрать инструмент", "Выбор инструмента", instruments)
		if(!choice)
			return
		choice = instruments[choice]		//get id
		if(choice)
			set_instrument(choice)

	else if(href_list["setnoteshift"])
		var/amount = input(usr, "Установить сдвиг нот", "Сдвиг нот") as null|num
		if(!isnull(amount))
			note_shift = clamp(amount, note_shift_min, note_shift_max)

	else if(href_list["setsustainmode"])
		var/choice = tgui_input_list(usr, "Выбрать метод затухания нот", "Метод затухания нот", SSinstruments.note_sustain_modes)
		if(choice)
			sustain_mode = SSinstruments.note_sustain_modes[choice]

	else if(href_list["togglesustainhold"])
		full_sustain_held_note = !full_sustain_held_note

	updateDialog()
