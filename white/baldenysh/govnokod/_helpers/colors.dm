/proc/closest_color(target, list/variants) //saturation и value тоже надо впилить штоб учитывало...............
	var/minDist = 9999
	var/minDistColorCode
	var/targetHue = rgb2num(target, COLORSPACE_HSV)[1]
	for(var/variant in variants)
		var/curDist = hue_distance(targetHue, rgb2num(variant, COLORSPACE_HSV)[1])
		if(curDist < minDist)
			minDist = curDist
			minDistColorCode = variant
	return minDistColorCode

/proc/hue_distance(hue1, hue2)
	var/d = abs(hue1 - hue2)
	return d > 180 ? 360 - d : d
