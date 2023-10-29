/proc/path2image(atomType)
	if(!ispath(atomType, /atom))
		stack_trace("В path2image подан неверный аргумент")
		return
	var/atom/A = atomType
	if(initial(A.greyscale_config) && initial(A.greyscale_colors))
		return image(icon = SSgreyscale.GetColoredIconByType(initial(A.greyscale_config), initial(A.greyscale_colors)), icon_state = initial(A.icon_state))
	return image(icon = initial(A.icon), icon_state = initial(A.icon_state))
