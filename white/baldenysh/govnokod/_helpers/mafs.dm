/proc/angle_diff(angle1, angle2)
	return (abs(angle1-angle2) + 180) % 360 - 180

/proc/polynomialRollingHash(str)
	var/p = 31
	var/n = SHORT_REAL_LIMIT//(1e9 + 9)
	var/a = 64//text2ascii("A") + 1
	var/power_of_p = 1
	. = 0
	for(var/i = 0; i < length(str); i++)
		. = (. + (text2ascii(str, i) - a) * power_of_p) % n
		power_of_p = (power_of_p * p) % n
