/atom/movable/screen/timelimit
	name = "ТАЙМЕР"
	screen_loc = "EAST-1,NORTH"
	maptext_width = 64
	maptext = "<span class='maptext' style='font-size:16px;font-family:\"Times New Roman\";color:#ff7777;'>3:00</span>"

/atom/movable/screen/timelimit/proc/update_info(textto)
	maptext = "<span class='maptext' style='font-size:16px;font-family:\"Times New Roman\";color:#ff7777;'>[textto]</span>"
