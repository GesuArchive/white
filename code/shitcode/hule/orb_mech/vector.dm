/datum/abVector
	var/x
	var/y

/datum/abVector/New(new_x, new_y)
	x = new_x
	y = new_y

///////////////// vsem priv mne len' ebatsya s overloadingom

/datum/abVector/proc/addVec(/datum/abVector/V)
	x += V.x
	y += V.y

/datum/abVector/proc/subVec(/datum/abVector/V)
	x -= V.x
	y -= V.y

/datum/abVector/proc/mulVec(/datum/abVector/V)
	x *= V.x
	y *= V.y

/datum/abVector/proc/divVec(/datum/abVector/V)
	if(V.x != 0)
		x /= V.x
	if(V.y != 0)
		y /= V.y

///////////////////

/datum/abVector/proc/addScal(xS, yS)
	x += xS
	y += yS

/datum/abVector/proc/subScal(xS, yS)
	x -= xS
	y -= yS

/datum/abVector/proc/mulScal(xS, yS)
	x *= xS
	y *= yS

/datum/abVector/proc/divScal(xS, yS)
	if(xS != 0)
		x /= xS
	if(yS != 0)
		y /= yS

//////////////////

/datum/abVector/proc/clone()
	return new /datum/abVector(x, y)

/datum/abVector/proc/magnitude()
	return sqrt(x * x + y * y)


