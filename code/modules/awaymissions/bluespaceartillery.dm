

/obj/machinery/artillerycontrol
	var/reload = 120
	var/reload_cooldown = 120
	var/explosiondev = 3
	var/explosionmed = 6
	var/explosionlight = 12
	name = "Интерфейс блюспейс артиллерии"
	icon_state = "control_boxp1"
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	density = TRUE

/obj/machinery/artillerycontrol/process(delta_time)
	if(reload < reload_cooldown)
		reload += delta_time

/obj/structure/artilleryplaceholder
	name = "Артиллерия"
	icon = 'icons/obj/machines/artillery.dmi'
	anchored = TRUE
	density = TRUE

/obj/structure/artilleryplaceholder/decorative
	density = FALSE

/obj/machinery/artillerycontrol/ui_interact(mob/user)
	. = ..()
	var/dat = "<B>Bluespace Artillery Control:</B><BR>"
	dat += "Locked on<BR>"
	dat += "<B>Charge progress: [reload]/[reload_cooldown]:</B><BR>"
	dat += "<A href='byond://?src=[REF(src)];fire=1'>Open Fire</A><BR>"
	dat += "Запуск оружия авторизирован <br>Командованием Флота NanoTrasen<br><br>Помните, дружественный огонь будет стоить вам контракта и жизни.<HR>"
	user << browse(dat, "window=scroll")
	onclose(user, "scroll")

/obj/machinery/artillerycontrol/Topic(href, href_list)
	if(..())
		return
	var/A
	A = tgui_input_list(usr, "Area to bombard", "Open Fire", GLOB.teleportlocs, A)
	var/area/thearea = GLOB.teleportlocs[A]
	if(usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return
	if(reload < reload_cooldown)
		return
	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)) || issilicon(usr))
		priority_announce("Обнаружен выстрел из блюспейс-артиллерии. Приготовьтесь к удару.")
		message_admins("[ADMIN_LOOKUPFLW(usr)] has launched an artillery strike.")
		var/list/L = list()
		for(var/turf/T in get_area_turfs(thearea.type))
			L+=T
		var/loc = pick(L)
		explosion(loc, explosiondev, explosionmed, explosionlight, explosion_cause = src)
		reload = 0
