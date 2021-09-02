/obj/structure/chess
	anchored = FALSE
	density = FALSE
	icon = 'icons/obj/chess.dmi'
	icon_state = "white_pawn"
	name = "\improper Вероятно, Белая Пешка"
	desc = "Это странно. Пожалуйста, сообщите администрации, как вам удалось получить родительскую шахматную фигуру. Спасибо!"
	max_integrity = 100

/obj/structure/chess/wrench_act(mob/user, obj/item/tool)
	to_chat(user, span_notice("Начинаю разбирать шахматную фигуру."))
	if(!do_after(user, 0.5 SECONDS, target = src))
		return TRUE
	var/obj/item/stack/sheet/iron/metal_sheets = new (drop_location(), 2)
	metal_sheets.add_fingerprint(user)
	tool.play_tool_sound(src)
	qdel(src)
	return TRUE

/obj/structure/chess/whitepawn
	name = "\improper Белая Пешка"
	desc = "Белая пешка. Вас обвинят в мошенничестве при взятии фигуры слабого En Passant."
	icon_state = "white_pawn"

/obj/structure/chess/whiterook
	name = "\improper Белая Ладья"
	desc = "Белая ладья. Также известная как башня. Может перемещаться на любое количество клеток по прямой. У неё есть особый ход, называемый рокировкой."
	icon_state = "white_rook"

/obj/structure/chess/whiteknight
	name = "\improper Белый Конь"
	desc = "Белый конь. Он может перепрыгивать через другие фигуры, двигается буквой Г."
	icon_state = "white_knight"

/obj/structure/chess/whitebishop
	name = "\improper Белый Слон"
	desc = "Белый слон. Он может перемещаться на любое количество клеток по диагонали."
	icon_state = "white_bishop"

/obj/structure/chess/whitequeen
	name = "\improper Белый Ферзь"
	desc = "Белый ферзь. Он может перемещаться на любое количество клеток по диагонали, горизонтали и вертикали."
	icon_state = "white_queen"

/obj/structure/chess/whiteking
	name = "\improper Белый Король"
	desc = "Белый король. Он может перемещаться на одну клетку в любом направлении."
	icon_state = "white_king"

/obj/structure/chess/blackpawn
	name = "\improper Чёрная Пешка"
	desc = "Чёрная пешка. Вас обвинят в мошенничестве при взятии фигуры слабого En Passant."
	icon_state = "black_pawn"

/obj/structure/chess/blackrook
	name = "\improper Чёрная Ладья"
	desc = "Чёрная ладья. Также известная как башня. Может перемещаться на любое количество клеток по прямой. У неё есть особый ход, называемый рокировкой."
	icon_state = "black_rook"

/obj/structure/chess/blackknight
	name = "\improper Чёрный Конь"
	desc = "Чёрный конь. Он может перепрыгивать через другие фигуры, двигается буквой Г"
	icon_state = "black_knight"

/obj/structure/chess/blackbishop
	name = "\improper Чёрный Слон"
	desc = "Чёрный слон. Он может перемещаться на любое количество клеток по диагонали."
	icon_state = "black_bishop"

/obj/structure/chess/blackqueen
	name = "\improper Чёрный Ферзь"
	desc = "Чёрный ферзь. Он может перемещаться на любое количество клеток по диагонали, горизонтали и вертикали."
	icon_state = "black_queen"

/obj/structure/chess/blackking
	name = "\improper Чёрный Король"
	desc = "Чёрный король. Он может перемещаться на одну клетку в любом направлении."
	icon_state = "black_king"
