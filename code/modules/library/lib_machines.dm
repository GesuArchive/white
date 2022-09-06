/* Library Machines
 *
 * Contains:
 *		Borrowbook datum
 *		Library Public Computer
 *		Cachedbook datum
 *		Library Computer
 *		Library Scanner
 *		Book Binder
 */



/*
 * Library Public Computer
 */
/obj/machinery/computer/libraryconsole
	name = "консоль для посетителей библиотеки"
	desc = "Выписанные книги ДОЛЖНЫ быть возвращены вовремя."
	icon_state = "oldcomp"
	icon_screen = "library"
	icon_keyboard = "no_keyboard"
	circuit = /obj/item/circuitboard/computer/libraryconsole
	var/screenstate = 0
	var/title
	var/category = "Any"
	var/author
	var/search_page = 0
	COOLDOWN_DECLARE(library_visitor_topic_cooldown)

/obj/machinery/computer/libraryconsole/ui_interact(mob/user)
	. = ..()
	var/list/dat = list() // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	switch(screenstate)
		if(0)
			dat += "<h2>Search Settings</h2><br>"
			dat += "<A href='?src=[REF(src)];settitle=1'>Filter by Title: [title]</A><BR>"
			dat += "<A href='?src=[REF(src)];setcategory=1'>Filter by Category: [category]</A><BR>"
			dat += "<A href='?src=[REF(src)];setauthor=1'>Filter by Author: [author]</A><BR>"
			dat += "<A href='?src=[REF(src)];search=1'>\[Start Search\]</A><BR>"
		if(1)
			if (!SSdbcore.Connect())
				dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font><BR>"
			else if(QDELETED(user))
				return
			else
				dat += "<table>"
				dat += "<tr><td>AUTHOR</td><td>TITLE</td><td>CATEGORY</td><td>SS<sup>13</sup>BN</td></tr>"
				var/SQLsearch = "isnull(deleted) AND "
				if(category == "Any")
					SQLsearch += "author LIKE '%[author]%' AND title LIKE '%[title]%'"
				else
					SQLsearch += "author LIKE '%[author]%' AND title LIKE '%[title]%' AND category='[category]'"
				var/bookcount = 0
				var/booksperpage = 20
				var/datum/db_query/query_library_count_books = SSdbcore.NewQuery({"
					SELECT COUNT(id) FROM [format_table_name("library")]
					WHERE isnull(deleted)
						AND author LIKE CONCAT('%',:author,'%')
						AND title LIKE CONCAT('%',:title,'%')
						AND (:category = 'Any' OR category = :category)
				"}, list("author" = author, "title" = title, "category" = category))
				if(!query_library_count_books.warn_execute())
					qdel(query_library_count_books)
					return
				if(query_library_count_books.NextRow())
					bookcount = text2num(query_library_count_books.item[1])
				qdel(query_library_count_books)
				if(bookcount > booksperpage)
					dat += "<b>Page: </b>"
					var/pagecount = 1
					var/list/pagelist = list()
					while(bookcount > 0)
						pagelist += "<a href='?src=[REF(src)];bookpagecount=[pagecount - 1]'>[pagecount == search_page + 1 ? "<b>\[[pagecount]\]</b>" : "\[[pagecount]\]"]</a>"
						bookcount -= booksperpage
						pagecount++
					dat += pagelist.Join(" | ")
				search_page = text2num(search_page)
				var/datum/db_query/query_library_list_books = SSdbcore.NewQuery({"
					SELECT author, title, category, id
					FROM [format_table_name("library")]
					WHERE isnull(deleted)
						AND author LIKE CONCAT('%',:author,'%')
						AND title LIKE CONCAT('%',:title,'%')
						AND (:category = 'Any' OR category = :category)
					LIMIT :skip, :take
				"}, list("author" = author, "title" = title, "category" = category, "skip" = booksperpage * search_page, "take" = booksperpage))
				if(!query_library_list_books.Execute())
					dat += "<font color=red><b>ERROR</b>: Unable to retrieve book listings. Please contact your system administrator for assistance.</font><BR>"
				else
					while(query_library_list_books.NextRow())
						var/author = query_library_list_books.item[1]
						var/title = query_library_list_books.item[2]
						var/category = query_library_list_books.item[3]
						var/id = query_library_list_books.item[4]
						dat += "<tr><td>[author]</td><td>[title]</td><td>[category]</td><td>[id]</td></tr>"
				qdel(query_library_list_books)
				if(QDELETED(user))
					return
				dat += "</table><BR>"
			dat += "<A href='?src=[REF(src)];back=1'>\[Go Back\]</A><BR>"
	var/datum/browser/popup = new(user, "publiclibrary", name, 600, 400)
	popup.set_content(jointext(dat, ""))
	popup.open()

/obj/machinery/computer/libraryconsole/Topic(href, href_list)
	if(!COOLDOWN_FINISHED(src, library_visitor_topic_cooldown))
		return
	COOLDOWN_START(src, library_visitor_topic_cooldown, 1 SECONDS)
	. = ..()
	if(.)
		usr << browse(null, "window=publiclibrary")
		onclose(usr, "publiclibrary")
		return

	if(href_list["settitle"])
		var/newtitle = tgui_input_text(usr, "Enter a title to search for:")
		if(newtitle)
			title = sanitize(newtitle)
		else
			title = null
	if(href_list["setcategory"])
		var/newcategory = tgui_input_list(usr, "Choose a category to search for:",, list("Any", "Fiction", "Non-Fiction", "Adult", "Reference", "Religion"))
		if(newcategory)
			category = sanitize(newcategory)
		else
			category = "Any"
	if(href_list["setauthor"])
		var/newauthor = tgui_input_text(usr, "Enter an author to search for:")
		if(newauthor)
			author = sanitize(newauthor)
		else
			author = null
	if(href_list["search"])
		screenstate = 1

	if(href_list["bookpagecount"])
		search_page = text2num(href_list["bookpagecount"])

	if(href_list["back"])
		screenstate = 0

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/*
 * Borrowbook datum
 */
/datum/borrowbook // Datum used to keep track of who has borrowed what when and for how long.
	var/bookname
	var/mobname
	var/getdate
	var/duedate

#define PRINTER_COOLDOWN 60

/*
 * Library Computer
 * After 860 days, it's finally a buildable computer.
 */
// TODO: Make this an actual /obj/machinery/computer that can be crafted from circuit boards and such
// It is August 22nd, 2012... This TODO has already been here for months.. I wonder how long it'll last before someone does something about it.
// It's December 25th, 2014, and this is STILL here, and it's STILL relevant. Kill me
/obj/machinery/computer/bookmanagement
	name = "консоль управления библиотекой"
	desc = "Командная консоль библиотекаря."
	verb_say = "бипает"
	verb_ask = "бипает"
	verb_exclaim = "бипает"
	pass_flags = PASSTABLE

	icon_state = "oldcomp"
	icon_screen = "library"
	icon_keyboard = "no_keyboard"
	circuit = /obj/item/circuitboard/computer/libraryconsole

	var/screenstate = 0 // 0 - Main Menu, 1 - Inventory, 2 - Checked Out, 3 - Check Out a Book

	var/arcanecheckout = 0
	var/buffer_book
	var/buffer_mob
	var/upload_category = "Fiction"
	var/list/checkouts = list()
	var/list/inventory = list()
	var/checkoutperiod = 5 // In minutes
	var/obj/machinery/libraryscanner/scanner // Book scanner that will be used when uploading books to the Archive
	var/page = 1	//current page of the external archives
	var/printer_cooldown = 0
	COOLDOWN_DECLARE(library_console_topic_cooldown)

/obj/machinery/computer/bookmanagement/Initialize(mapload)
	. = ..()
	if(circuit)
		circuit.name = "Консоль управления библиотекой (Оборудование)"
		circuit.build_path = /obj/machinery/computer/bookmanagement

/obj/machinery/computer/bookmanagement/ui_interact(mob/user)
	. = ..()
	var/dat = "" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	switch(screenstate)
		if(0)
			// Main Menu
			dat += "<A href='?src=[REF(src)];switchscreen=1'>1. Просмотреть общий инвентарь</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=2'>2. Просмотреть проверенный инвентарь</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=3'>3. Проверить книгу</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=4'>4. Подключиться к внешнему архиву</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=5'>5. Загрузить новую работу в архив</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=6'>6. Загрузить отсканированный заголовок в новостник</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=7'>7. Напечатать корпоративные материалы</A><BR>"
			if(obj_flags & EMAGGED)
				dat += "<A href='?src=[REF(src)];switchscreen=8'>8. Получить доступ к хранилищу Запретных знаний</A><BR>"
			if(src.arcanecheckout)
				print_forbidden_lore(user)
				src.arcanecheckout = 0
		if(1)
			// Inventory
			dat += "<H3>Инвентарь</H3><BR>"
			for(var/obj/item/book/b in inventory)
				dat += "[b.name] <A href='?src=[REF(src)];delbook=[REF(b)]'>(Удалить)</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=0'>(Вернуться в главное меню)</A><BR>"
		if(2)
			// Checked Out
			dat += "<h3>Проверенные книги</h3><BR>"
			for(var/datum/borrowbook/b in checkouts)
				var/timetaken = world.time - b.getdate
				timetaken /= 600
				timetaken = round(timetaken)
				var/timedue = b.duedate - world.time
				timedue /= 600
				if(timedue <= 0)
					timedue = "<font color=red><b>(ПРОСРОЧЕНО)</b> [timedue]</font>"
				else
					timedue = round(timedue)
				dat += "\"[b.bookname]\", Проверено на: [b.mobname]<BR>--- Взято: [timetaken] минут назад, Просрочка: через [timedue] минут<BR>"
				dat += "<A href='?src=[REF(src)];checkin=[REF(b)]'>(Регистрация)</A><BR><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=0'>(Вернуться в главное меню)</A><BR>"
		if(3)
			// Check Out a Book
			dat += "<h3>Проверить книгу</h3><BR>"
			dat += "Книга: [src.buffer_book] "
			dat += "<A href='?src=[REF(src)];editbook=1'>\[Edit\]</A><BR>"
			dat += "Писатель: [src.buffer_mob] "
			dat += "<A href='?src=[REF(src)];editmob=1'>\[Edit\]</A><BR>"
			dat += "Дата выписки : [world.time/600]<BR>"
			dat += "Срок просрочки: [(world.time + checkoutperiod)/600]<BR>"
			dat += "(Checkout Period: [checkoutperiod] minutes) (<A href='?src=[REF(src)];increasetime=1'>+</A>/<A href='?src=[REF(src)];decreasetime=1'>-</A>)"
			dat += "<A href='?src=[REF(src)];checkout=1'>(Подтвердить)</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=0'>(Вернуться в главное меню)</A><BR>"
		if(4)
			dat += "<h3>External Archive</h3>"
			if(!SSdbcore.Connect())
				dat += "<font color=red><b>ОШИБКА</b>: Невозможно связаться с внешним архивом. Обратитесь за помощью к своему системному администратору.</font>"
			else
				var/booksperpage = 50
				var/pagecount
				var/datum/db_query/query_library_count_books = SSdbcore.NewQuery("SELECT COUNT(id) FROM [format_table_name("library")] WHERE isnull(deleted)")
				if(!query_library_count_books.Execute())
					qdel(query_library_count_books)
					return
				if(query_library_count_books.NextRow())
					pagecount = CEILING(text2num(query_library_count_books.item[1]) / booksperpage, 1)
				qdel(query_library_count_books)
				var/list/booklist = list()
				var/datum/db_query/query_library_get_books = SSdbcore.NewQuery({"
					SELECT id, author, title, category
					FROM [format_table_name("library")]
					WHERE isnull(deleted)
					LIMIT :skip, :take
				"}, list("skip" = booksperpage * (page - 1), "take" = booksperpage))
				if(!query_library_get_books.Execute())
					qdel(query_library_get_books)
					return
				while(query_library_get_books.NextRow())
					booklist += "<tr><td>[query_library_get_books.item[2]]</td><td>[query_library_get_books.item[3]]</td><td>[query_library_get_books.item[4]]</td><td><A href='?src=[REF(src)];targetid=[query_library_get_books.item[1]]'>\[Order\]</A></td></tr>\n"
				dat += "<A href='?src=[REF(src)];orderbyid=1'>(Order book by SS<sup>13</sup>BN)</A><BR><BR>"
				dat += "<table>"
				dat += "<tr><td>АВТОР</td><td>ЗАГОЛОВОК</td><td>КАТЕГОРИЯ</td><td></td></tr>"
				dat += jointext(booklist, "")
				dat += "<tr><td><A href='?src=[REF(src)];page=[max(1,page-1)]'>&lt;&lt;&lt;&lt;</A></td> <td></td> <td></td> <td><span style='text-align:right'><A href='?src=[REF(src)];page=[min(pagecount,page+1)]'>&gt;&gt;&gt;&gt;</A></span></td></tr>"
				dat += "</table>"
				qdel(query_library_get_books)
			dat += "<BR><A href='?src=[REF(src)];switchscreen=0'>(Вернуться в главное меню)</A><BR>"
		if(5)
			dat += "<H3>Загрузить новую работу</H3>"
			if(!scanner)
				scanner = findscanner(9)
			if(!scanner)
				dat += "<FONT color=red>Сканер не обнаружен в радиусе действия беспроводной сети.</FONT><BR>"
			else if(!scanner.cache)
				dat += "<FONT color=red>Данные в памяти сканера не найдены.</FONT><BR>"
			else
				dat += "<TT>Данные помечены для загрузки...</TT><BR>"
				dat += "<TT>Заголовок: </TT>[scanner.cache.name]<BR>"
				if(!scanner.cache.author)
					scanner.cache.author = "Аноним"
				dat += "<TT>Автор: </TT><A href='?src=[REF(src)];setauthor=1'>[scanner.cache.author]</A><BR>"
				dat += "<TT>Категория: </TT><A href='?src=[REF(src)];setcategory=1'>[upload_category]</A><BR>"
				dat += "<A href='?src=[REF(src)];upload=1'>\[Upload\]</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=0'>(Вернуться в главное меню)</A><BR>"
		if(6)
			dat += "<h3>Загрузить работу в новостник</h3>"
			if(!scanner)
				scanner = findscanner(9)
			if(!scanner)
				dat += "<FONT color=red>Сканер не обнаружен в радиусе действия беспроводной сети.</FONT><BR>"
			else if(!scanner.cache)
				dat += "<FONT color=red>Данные в памяти сканера не найдены.</FONT><BR>"
			else
				dat += "<TT>Загрузить [scanner.cache.name] в новостники станции?</TT>"
				dat += "<A href='?src=[REF(src)];newspost=1'>\[Post\]</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=0'>(Вернуться в главное меню)</A><BR>"
		if(7)
			dat += "<h3>NTGanda(tm) Универсальный модуль печати</h3>"
			dat += "Что бы вы хотели напечатать?<BR>"
			dat += "<A href='?src=[REF(src)];printbible=1'>\[Bible\]</A><BR>"
			dat += "<A href='?src=[REF(src)];printposter=1'>\[Poster\]</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=0'>(Вернуться в главное меню)</A><BR>"
		if(8)
			dat += "<h3>Доступ к хранилищу запретных знаний v 1.3</h3>"
			dat += "Вы абсолютно уверены, что хотите продолжить? EldritchRelics Inc. не несет никакой ответственности за потерю рассудка в результате этого действия.<p>"
			dat += "<A href='?src=[REF(src)];arccheckout=1'>Да.</A><BR>"
			dat += "<A href='?src=[REF(src)];switchscreen=0'>Нет.</A><BR>"

	var/datum/browser/popup = new(user, "library", name, 600, 400)
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/bookmanagement/proc/findscanner(viewrange)
	for(var/obj/machinery/libraryscanner/S in range(viewrange, get_turf(src)))
		return S
	return null

/obj/machinery/computer/bookmanagement/proc/print_forbidden_lore(mob/user)
	new /obj/item/melee/cultblade/dagger(get_turf(src))
	to_chat(user, span_warning("Ваш рассудок едва выдерживает секунды, проведенные в окне просмотра хранилища. Единственное, что напоминает вам об этом, когда вы прекращаете просмотр, - это зловещий кинжал, лежащий на столе. Вы даже не помните, откуда он взялся..."))
	user.visible_message(span_warning("[user] на несколько мгновений смотрит на пустой экран, [user.ru_ego()] выражение лица застыло от страха.") , 2)

/obj/machinery/computer/bookmanagement/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = W
		scanner.computer = src
		to_chat(user, span_notice("[scanner] связанная машина была установлена на [src]."))
		audible_message(span_hear("[capitalize(src.name)] издает низкий, короткий сигнал."))
	else
		return ..()

/obj/machinery/computer/bookmanagement/emag_act(mob/user)
	if(density && !(obj_flags & EMAGGED))
		obj_flags |= EMAGGED

/obj/machinery/computer/bookmanagement/Topic(href, href_list)
	if(!COOLDOWN_FINISHED(src, library_console_topic_cooldown))
		return
	COOLDOWN_START(src, library_console_topic_cooldown, 1 SECONDS)
	if(..())
		usr << browse(null, "window=library")
		onclose(usr, "library")
		return
	if(href_list["page"] && screenstate == 4)
		page = text2num(href_list["page"])
	if(href_list["switchscreen"])
		switch(href_list["switchscreen"])
			if("0")
				screenstate = 0
			if("1")
				screenstate = 1
			if("2")
				screenstate = 2
			if("3")
				screenstate = 3
			if("4")
				screenstate = 4
			if("5")
				screenstate = 5
			if("6")
				screenstate = 6
			if("7")
				screenstate = 7
			if("8")
				screenstate = 8
	if(href_list["arccheckout"])
		if(obj_flags & EMAGGED)
			src.arcanecheckout = 1
		src.screenstate = 0
	if(href_list["increasetime"])
		checkoutperiod += 1
	if(href_list["decreasetime"])
		checkoutperiod -= 1
		if(checkoutperiod < 1)
			checkoutperiod = 1
	if(href_list["editbook"])
		buffer_book = stripped_input(usr, "Введите название книги:", max_length = 45)
	if(href_list["editmob"])
		buffer_mob = stripped_input(usr, "Введите имя получателя:", max_length = MAX_NAME_LEN)
	if(href_list["checkout"])
		var/datum/borrowbook/b = new /datum/borrowbook
		b.bookname = sanitize(buffer_book)
		b.mobname = sanitize(buffer_mob)
		b.getdate = world.time
		b.duedate = world.time + (checkoutperiod * 600)
		checkouts.Add(b)
	if(href_list["checkin"])
		var/datum/borrowbook/b = locate(href_list["checkin"]) in checkouts
		if(b && istype(b))
			checkouts.Remove(b)
	if(href_list["delbook"])
		var/obj/item/book/b = locate(href_list["delbook"]) in inventory
		if(b && istype(b))
			inventory.Remove(b)
	if(href_list["setauthor"])
		var/newauthor = stripped_input(usr, "Введите имя автора: ", max_length = 45)
		if(newauthor)
			scanner.cache.author = newauthor
	if(href_list["setcategory"])
		var/newcategory = tgui_input_list(usr, "Выберите категорию: ",, list("Fiction", "Non-Fiction", "Adult", "Reference", "Religion","Technical"))
		if(newcategory)
			upload_category = newcategory
	if(href_list["upload"])
		if(scanner)
			if(scanner.cache)
				var/choice = tgui_alert(usr, "Вы уверены, что хотите загрузить эту работу в архив?",, list("Confirm", "Abort"))
				if(choice == "Confirm")
					if (!SSdbcore.Connect())
						tgui_alert(usr,"ОШИБКА: Соединение с архивом разорвано.")
					else
						var/msg = "[key_name(usr)] has uploaded the book titled [scanner.cache.name], [length(scanner.cache.dat)] signs"
						var/datum/db_query/query_library_upload = SSdbcore.NewQuery({"
							INSERT INTO [format_table_name("library")] (author, title, content, category, ckey, datetime, round_id_created)
							VALUES (:author, :title, :content, :category, :ckey, Now(), :round_id)
						"}, list("title" = scanner.cache.name, "author" = scanner.cache.author, "content" = scanner.cache.dat, "category" = upload_category, "ckey" = usr.ckey, "round_id" = GLOB.round_id))
						if(!query_library_upload.Execute())
							qdel(query_library_upload)
							tgui_alert(usr,"Возникла ошибка базы данных при загрузке в архив.")
							return
						else
							log_game(msg)
							qdel(query_library_upload)
							tgui_alert(usr,"Загрузка завершена. Загруженная работа будет недоступно для печати в течение короткого периода времени.")
	if(href_list["newspost"])
		if(!GLOB.news_network)
			tgui_alert(usr,"ОШИБКА: На станции не найдено ни одного новостника.")
		var/channelexists = 0
		for(var/datum/feed_channel/FC in GLOB.news_network.network_channels)
			if(FC.channel_name == "Nanotrasen Book Club")
				channelexists = 1
				break
		if(!channelexists)
			GLOB.news_network.create_feed_channel("Nanotrasen Book Club", "Library", "The official station book club!", null)
		GLOB.news_network.submit_article(scanner.cache.dat, "[scanner.cache.name]", "Nanotrasen Book Club", null)
		tgui_alert(usr,"Загрузка завершена. Ваша работа теперь доступен для новостных лент станций.")
	if(href_list["orderbyid"])
		if(printer_cooldown > world.time)
			say("Принтер недоступен. Пожалуйста, подождите некоторое время перед попыткой печати.")
		else
			var/orderid = input("Enter your order:") as num|null
			if(orderid)
				if(isnum(orderid) && ISINTEGER(orderid))
					href_list["targetid"] = num2text(orderid)

	if(href_list["targetid"])
		var/id = href_list["targetid"]
		if (!SSdbcore.Connect())
			tgui_alert(usr,"ОШИБКА: Соединение с архивом разорвано.")
		if(printer_cooldown > world.time)
			say("Принтер недоступен. Пожалуйста, подождите некоторое время перед попыткой печати.")
		else
			var/datum/db_query/query_library_print = SSdbcore.NewQuery(
				"SELECT * FROM [format_table_name("library")] WHERE id=:id AND isnull(deleted)",
				list("id" = id)
			)
			if(!query_library_print.Execute())
				qdel(query_library_print)
				say("ОШИБКА ПРИНТЕРА! Не удалось распечатать документ (0x0000000F)")
				return
			printer_cooldown = world.time + PRINTER_COOLDOWN
			while(query_library_print.NextRow())
				var/author = query_library_print.item[2]
				var/title = query_library_print.item[3]
				var/content = query_library_print.item[4]
				if(!QDELETED(src))
					var/obj/item/book/B = new(get_turf(src))
					B.name = "Book: [title]"
					B.title = title
					B.author = author
					B.dat = content
					B.icon_state = "book[rand(1,8)]"
					visible_message(span_notice("[capitalize(src.name)] принтер гудит, выпуская полностью переплетенную книгу. Как он это сделал?"))
				break
			qdel(query_library_print)
	if(href_list["printbible"])
		if(printer_cooldown < world.time)
			var/obj/item/storage/book/bible/B = new /obj/item/storage/book/bible(src.loc)
			if(GLOB.bible_icon_state && GLOB.bible_inhand_icon_state)
				B.icon_state = GLOB.bible_icon_state
				B.inhand_icon_state = GLOB.bible_inhand_icon_state
				B.name = GLOB.bible_name
				B.deity_name = GLOB.deity
			printer_cooldown = world.time + PRINTER_COOLDOWN
		else
			say("Принтер в настоящее время недоступен, пожалуйста, подождите немного.")
	if(href_list["printposter"])
		if(printer_cooldown < world.time)
			new /obj/item/poster/random_official(src.loc)
			printer_cooldown = world.time + PRINTER_COOLDOWN
		else
			say("Принтер в настоящее время недоступен, пожалуйста, подождите немного.")
	add_fingerprint(usr)
	updateUsrDialog()

/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "сканер управления интерфейсом"
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	desc = "Служит для сканирования вещей."
	density = TRUE
	var/obj/item/book/cache		// Last scanned book

/obj/machinery/libraryscanner/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/book))
		if(!user.transferItemToLoc(O, src))
			return
	else
		return ..()

/obj/machinery/libraryscanner/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	var/dat = "" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	if(cache)
		dat += "<FONT color=#005500>Данные сохранены в памяти.</FONT><BR>"
	else
		dat += "Нет данных, сохраненных в памяти.<BR>"
	dat += "<A href='?src=[REF(src)];scan=1'>\[Scan\]</A>"
	if(cache)
		dat += "       <A href='?src=[REF(src)];clear=1'>\[Clear Memory\]</A><BR><BR><A href='?src=[REF(src)];eject=1'>\[Remove Book\]</A>"
	else
		dat += "<BR>"
	var/datum/browser/popup = new(user, "scanner", name, 600, 400)
	popup.set_content(dat)
	popup.open()

/obj/machinery/libraryscanner/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=scanner")
		onclose(usr, "scanner")
		return

	if(href_list["scan"])
		for(var/obj/item/book/B in contents)
			cache = B
			break
	if(href_list["clear"])
		cache = null
	if(href_list["eject"])
		for(var/obj/item/book/B in contents)
			B.forceMove(drop_location())
	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "книжный переплётчик"
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	desc = "Предназначен только для скрепления бумажных изделий."
	density = TRUE
	var/busy = FALSE

/obj/machinery/bookbinder/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/paper))
		bind_book(user, O)
	else if(default_unfasten_wrench(user, O))
		return 1
	else
		return ..()

/obj/machinery/bookbinder/proc/bind_book(mob/user, obj/item/paper/P)
	if(machine_stat)
		return
	if(busy)
		to_chat(user, span_warning("Переплетчик занят. Пожалуйста, подождите завершения предыдущей операции."))
		return
	if(!user.transferItemToLoc(P, src))
		return
	user.visible_message(span_notice("[user] загружает немного бумаги в [src].") , span_notice("Загружаю немного бумаги в [src]."))
	audible_message(span_hear("[capitalize(src.name)] начинает шуметь, разогревая свои печатные барабаны."))
	busy = TRUE
	sleep(rand(200,400))
	busy = FALSE
	if(P)
		if(!machine_stat)
			visible_message(span_notice("[capitalize(src.name)] жужжит, печатая и создавая новую книгу."))
			var/obj/item/book/B = new(src.loc)
			B.dat = P.info
			B.name = "Работа #" + "[rand(100, 999)]"
			B.icon_state = "book[rand(1,7)]"
			qdel(P)
		else
			P.forceMove(drop_location())
