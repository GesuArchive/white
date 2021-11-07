/obj/item/camera/coom
	name = "CoomCamera™"
	icon_state = "coom"
	state_on = "coom"
	state_off = "coom_off"
	var/last_tags = ""
	var/gender_discrimination = TRUE
	var/no_requests = FALSE

/obj/item/camera/coom/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Gender discrimination: [gender_discrimination ? "ONLINE" : "STANDBY"]</span>"
	. += "<hr><span class='notice'>Last shot tags were: [last_tags]</span>"

/obj/item/camera/coom/printpicture(mob/user, datum/picture/picture)
	var/obj/item/photo/webpic/p = new(get_turf(src), picture)
	if(in_range(src, user)) //needed because of TK
		user.put_in_hands(p)
		pictures_left--
		to_chat(user, span_notice("[pictures_left] photos left."))
		if(default_picture_name)
			picture.picture_name = default_picture_name

		p.set_picture(picture, TRUE, TRUE)

	if(!picture.mobs_seen)
		return

	var/list/humans_seen = list()
	for(var/mob/living/carbon/human/H in picture.mobs_seen)
		humans_seen.Add(H)

	if(!humans_seen)
		return

	var/mob/living/carbon/human/main_tag_source = pick(humans_seen)

	last_tags = ""
	if(!main_tag_source)
		return

	if(gender_discrimination)
		var/list/rasstrelniy_spisok = list( "boy" = 0, "girl" = 0, "other" = 0)
		for(var/mob/living/carbon/human/H in humans_seen)
			if(H.gender == "male")
				rasstrelniy_spisok["boy"]++
			else if (H.gender == "female")
				main_tag_source = H
				rasstrelniy_spisok["girl"]++
			else
				rasstrelniy_spisok["other"]++
		for(var/gender in rasstrelniy_spisok)
			last_tags += rasstrelniy_spisok[gender] == 0 ? "" : (rasstrelniy_spisok[gender] > 1 ? "[rasstrelniy_spisok[gender]][gender]s" : "1[gender]") + "+"

	last_tags += "[human2tags(main_tag_source)]"

	if(no_requests)
		return

	p.tumbnail_src = pick(tags2pics(last_tags))
	p.original_src = replacetext(replacetext(p.tumbnail_src, "thumbnail_", ""), "thumbnails", "images")

	if(!p.tumbnail_src)
		return
	p.name = "cum-stained photo"

/obj/item/photo/webpic
	var/tumbnail_src
	var/original_src
	var/original = FALSE

/obj/item/photo/webpic/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>ПКМ to change mode.\nMode: [original ? "Original" : "Thumbnail"]</span>"

/obj/item/photo/webpic/AltClick(mob/user)
	original = !original
	to_chat(user, span_notice("Mode set to [original ? "Original" : "Thumbnail"]"))

/obj/item/photo/webpic/show(mob/user)
	if(!istype(picture) || !picture.picture_image || !tumbnail_src)
		to_chat(user, span_warning("[capitalize(src.name)] seems to be blank..."))
		return
	user << browse("<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><title>[name]</title></head>" \
		+ "<body style='width: auto;height: auto;overflow:hidden;margin:0;text-align:center;'>" \
		+ "<img src='[CORS_THING_REQUEST_LINK+url_encode(original ? original_src : tumbnail_src)]' style='width: 100%;height: 100%;-ms-interpolation-mode: bicubic'/>" \
		+ "[scribble ? "<br>Written on the back:<br><i>[scribble]</i>" : ""]"\
		+ "</body></html>", "window=photo_showing")
	onclose(user, "[name]")
