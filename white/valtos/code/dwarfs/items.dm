/obj/item/gem
	name = "необработанный гем"
	desc = "Крутой"
	w_class = WEIGHT_CLASS_TINY
	icon = 'white/rashcat/icons/dwarfs/objects/gems.dmi'
	var/cut_type = /obj/item/gem/cut
	var/scan_state
	var/max_amount = 3

/obj/item/gem/Initialize()
	. = ..()
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/gem/cut

/obj/item/gem/diamond
	name = "необработанный алмаз"
	desc = "Алмаз. Необработанный"
	icon_state = "diamond_uncut"
	cut_type = /obj/item/gem/cut/diamond
	scan_state = "diamond"
	max_amount = 2

/obj/item/gem/cut/diamond
	name = "алмаз"
	desc = "Алмаз"
	icon_state = "diamond"

/obj/item/gem/ruby
	name = "необработанный рубин"
	desc = "По нему видно что в таком виде не годится даже на палку"
	icon_state = "ruby_uncut"
	cut_type = /obj/item/gem/cut/ruby
	scan_state = "ruby"

/obj/item/gem/cut/ruby
	name = "рубин"
	desc = "Так и просит ебани меня на палку братан"
	icon_state = "ruby"

/obj/item/gem/saphire
	name = "необработанный сапфир"
	desc = "Такой камень не подошел бы королю"
	icon_state = "saphire_uncut"
	cut_type = /obj/item/gem/cut/saphire
	scan_state = "saphire"

/obj/item/gem/cut/saphire
	name = "сапфир"
	icon_state = "saphire"
	desc = "Такой камень подошел бы королю."

/obj/item/damaz
	name = "Дамаз Крон"
	desc = "Обидно."
	icon = 'white/rashcat/icons/dwarfs/objects/tools.dmi'
	icon_state = "damaz"

/obj/item/damaz/proc/can_use(mob/user)
	var/allowed = isdwarf(user)
	if(!allowed)
		to_chat(user, span_warning("Ты не достоин!"))
	return allowed
