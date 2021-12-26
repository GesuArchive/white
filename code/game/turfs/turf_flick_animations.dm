//Requires either a target/location or both
//Requires a_icon holding the animation
//Requires either a_icon_state of the animation or the flick_anim
//Does not require sleeptime, specifies for how long the animation should be allowed to exist before returning to pool
//Does not require animation direction, but you can specify
//Does not require a name
/proc/anim(turf/location as turf, target as mob|obj, a_icon, a_icon_state as text, flick_anim as text, sleeptime = 0, direction as num, name as text, lay as num, offX as num, offY as num, col as text, alph as num, plane as num, trans, invis)
//This proc throws up either an icon or an animation for a specified amount of time.
//The variables should be apparent enough.
	if(!location && target)
		location = get_turf(target)
	if(location && !target)
		target = location
	if(!location && !target)
		return
	var/obj/effect/overlay/animation = new /obj/effect/overlay(location)
	if(name)
		animation.name = name
	if(direction)
		animation.dir = direction
	if(alph)
		animation.alpha = alph
	if(invis)
		animation.invisibility = invis
	animation.icon = a_icon
	animation.animate_movement = 0
	animation.mouse_opacity = 0
	if(!lay)
		animation.layer = target:layer+1
	else
		animation.layer = lay
	if(target && istype(target,/atom))
		if(!plane)
			animation.plane = target:plane
		else
			animation.plane = plane
	if(offX)
		animation.pixel_x = offX
	if(offY)
		animation.pixel_y = offY
	if(col)
		animation.color = col
	if(trans)
		animation.transform = trans
	if(a_icon_state)
		animation.icon_state = a_icon_state
	else
		animation.icon_state = "blank"
		flick(flick_anim, animation)

	spawn(max(sleeptime, 15))
		qdel(animation)

	return animation
