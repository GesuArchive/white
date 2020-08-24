/client/proc/raspidoars()
	set name = " ? Raspidoars"
	set category = "Дбг"

	var/turf/where = get_turf(mob)

	if(!where)
		return

	var/rss = input("Raspidoars range (Tiles):") as num

	for(var/atom/A in spiral_range(rss, where))
		if(isturf(A) || isobj(A) || ismob(A))
			playsound(where, 'white/valtos/sounds/bluntcreep.ogg', 100, TRUE, rss)
			var/matrix/M = A.transform
			M.Scale(rand(1, 2), rand(1, 2))
			M.Translate(rand(-2, 2), rand(-2, 2))
			M.Turn(rand(0, 90))
			A.color = "#[random_short_color()]"
			animate(A, color = color_matrix_rotate_hue(rand(0, 360)), time = rand(200, 500), easing = CIRCULAR_EASING, flags = ANIMATION_PARALLEL)
			animate(A, transform = M, time = rand(200, 1000), flags = ANIMATION_PARALLEL)
			sleep(rand(1, 10))
