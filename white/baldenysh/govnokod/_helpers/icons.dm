/proc/atomType2Image(atomType)
	if(!ispath(atomType, /atom))
		stack_trace("В atomType2Image подан неверный аргумент")
		return
	var/atom/A = atomType
	if(initial(A.greyscale_config) && initial(A.greyscale_colors))
		return image(icon = SSgreyscale.GetColoredIconByType(initial(A.greyscale_config), initial(A.greyscale_colors)), icon_state = initial(A.icon_state))
	return image(icon = initial(A.icon), icon_state = initial(A.icon_state))
