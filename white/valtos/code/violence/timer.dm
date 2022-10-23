/atom/movable/screen/timelimit
	name = "ТАЙМЕР"
	screen_loc = "RIGHT-2:24,NORTH"
	maptext_width = 128
	maptext = "<span class='maptext' style='font-size:16px;font-family:\"Retroville NC\";color:#ff7777;'>3:00</span>"

/atom/movable/screen/timelimit/proc/update_info(textto)
	maptext = "<span class='maptext' style='font-size:16px;font-family:\"Retroville NC\";color:#ff7777;'>[textto]</span>"
