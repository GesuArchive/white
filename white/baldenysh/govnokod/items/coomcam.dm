#define CORS_THING_REQUEST_LINK "https://api.allorigins.win/raw?url="
#define FUNNY_BOOK_SITE_REQUEST_LINK_URI_ENCODED "https%3A//gelbooru.com/index.php%3Fpage%3Dpost%26s%3Dlist%26tags%3D"

/obj/item/camera/coom
	name = "CoomCamera™"
	var/last_tags = ""

/obj/item/camera/coom/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Last shot tags were: [last_tags]</span>"

/obj/item/camera/coom/printpicture(mob/user, datum/picture/picture)
	var/obj/item/photo/webpic/p = new(get_turf(src), picture)
	if(in_range(src, user)) //needed because of TK
		user.put_in_hands(p)
		pictures_left--
		to_chat(user, "<span class='notice'>[pictures_left] photos left.</span>")
		var/customise = "No"
		if(can_customise)
			customise = alert(user, "Do you want to customize the photo?", "Customization", "Yes", "No")
		if(customise == "Yes")
			var/name1 = stripped_input(user, "Set a name for this photo, or leave blank. 32 characters max.", "Name", max_length = 32)
			var/desc1 = stripped_input(user, "Set a description to add to photo, or leave blank. 128 characters max.", "Caption", max_length = 128)
			var/caption = stripped_input(user, "Set a caption for this photo, or leave blank. 256 characters max.", "Caption", max_length = 256)
			if(name1)
				picture.picture_name = name1
			if(desc1)
				picture.picture_desc = "[desc1] - [picture.picture_desc]"
			if(caption)
				picture.caption = caption
		else
			if(default_picture_name)
				picture.picture_name = default_picture_name

		p.set_picture(picture, TRUE, TRUE)

	if(!picture.mobs_seen)
		return

	var/mob/living/carbon/human/tag_source = pick(picture.mobs_seen)
	/*
	var/maleCount = 0
	var/femaleCount = 0
	var/otherCount = 0


	for(var/mob/living/carbon/human/H in picture.mobs_seen)
		if(H.gender == MALE)
			maleCount++
		else if (H.gender == FEMALE)
			tag_source = H
			femaleCount++
		else
			otherCount++
	*/
	if(!tag_source)
		last_tags = ""
		return

	p.thumbnailSrc = pick(picsByTags(human2Tags(tag_source)))
	p.originalSrc = replacetext(replacetext(p.thumbnailSrc, "thumbnail_", ""), "thumbnails", "images")

	if(!p.thumbnailSrc)
		return
	p.name = "cum-stained photo"

/obj/item/photo/webpic
	var/thumbnailSrc
	var/originalSrc
	var/original = FALSE

/obj/item/photo/webpic/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Alt-click to change mode.\nMode: [original ? "Original" : "Thumbnail"]</span>"

/obj/item/photo/webpic/AltClick(mob/user)
	original = !original
	to_chat(user, "<span class='notice'>Mode set to [original ? "Original" : "Thumbnail"]</span>")

/obj/item/photo/webpic/show(mob/user)
	if(!istype(picture) || !picture.picture_image || !thumbnailSrc)
		to_chat(user, "<span class='warning'>[capitalize(src.name)] seems to be blank...</span>")
		return
	user << browse("<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><title>[name]</title></head>" \
		+ "<body style='width: auto;height: auto;overflow:hidden;margin:0;text-align:center;'>" \
		+ "<img src='[CORS_THING_REQUEST_LINK+url_encode(original ? originalSrc : thumbnailSrc)]' style='width: 100%;height: 100%;-ms-interpolation-mode: bicubic'/>" \
		+ "[scribble ? "<br>Written on the back:<br><i>[scribble]</i>" : ""]"\
		+ "</body></html>", "window=photo_showing")
	onclose(user, "[name]")

/obj/item/camera/coom/proc/human2Tags(mob/living/carbon/human/H) //эту фегню надо дальше допиливать, но я заебался, пойду окучивать картошку.........
	var/hairHex = findtext(H.hair_color, "#") ? H.hair_color :"#[H.hair_color]"
	var/eyeHex = findtext(H.eye_color, "#") ? H.eye_color :"#[H.eye_color]"
	last_tags = "[hairColor2Tag(hairHex)]+[eyeColor2Tag(eyeHex)]"
	return last_tags

/proc/hairColor2Tag(hairColor)
	var/list/hairTags = list(
		"#0FFFFF" = "Aqua_hair",
		"#000000" = "Black_hair",
		"#FAF0BE" = "Blonde_hair",
		"#0000FF" = "Blue_hair",
		"#964B00" = "Brown_hair",
		"#B5651D" = "Light_brown_hair",
		"#00ff00" = "Green_hair",
		"#808080" = "Grey_hair",
		"#FFA500" = "Orange_hair",
		"#FFC0CB" = "Pink_hair",
		"#800080" = "Purple_hair",
		"#E6E6FA" = "Lavender_hair",
		"#FF0000" = "Red_hair",
		"#C0C0C0" = "Silver_hair",
		"#FFFFFF" = "White_hair"
	)
	return hairTags[getClosestColorFromVariants(hairColor, hairTags)]

/proc/eyeColor2Tag(eyeColor)
	var/list/eyeTags = list(
		"#0FFFFF" = "Aqua_eyes",
		"#000000" = "Black_eyes",
		"#0000FF" = "Blue_eyes",
		"#964B00" = "Brown_eyes",
		"#FFBF00" = "Amber_eyes",
		"#B5651D" = "Light_Brown_eyes",
		"#D4AF37" = "Gold_eyes",
		"#00ff00" = "Green_eyes",
		"#808080" = "Grey_eyes",
		"#8E7618" = "Hazel_eyes",
		"#FFA500" = "Orange_eyes",
		"#FFC0CB" = "Pink_eyes",
		"#800080" = "Purple_eyes",
		"#E6E6FA" = "Lavender_eyes",
		"#FF0000" = "Red_eyes",
		"#B03060" = "Maroon_eyes",
		"#C0C0C0" = "Silver_eyes",
		"#FFFFFF" = "White_eyes",
		"#FFFF00" = "Yellow_eyes"
	)
	return eyeTags[getClosestColorFromVariants(eyeColor, eyeTags)]

/proc/getClosestColorFromVariants(target, list/variants) //saturation и value тоже надо впилить штоб учитывало...............
	var/minDist = 9999
	var/minDistColorCode
	var/targetHue = rgb2num(target, COLORSPACE_HSV)[1]
	for(var/variant in variants)
		var/curDist = getHueDistance(targetHue, rgb2num(variant, COLORSPACE_HSV)[1])
		if(curDist < minDist)
			minDist = curDist
			minDistColorCode = variant
	return minDistColorCode

/proc/getHueDistance(hue1, hue2)
	var/d = abs(hue1 - hue2)
	return d > 180 ? 360 - d : d

/proc/picsByTags(tags_string)
	var/container = getListOfEnclosedStrings(getFunnyDoc(tags_string), "<div class=\"thumbnail-container\">","</div>")[1]
	return getListOfEnclosedStrings(container, "src=\"", "\"")

/proc/getFunnyDoc(tags_string)
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CORS_THING_REQUEST_LINK][FUNNY_BOOK_SITE_REQUEST_LINK_URI_ENCODED][tags_string]", "", "", null)
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()
	if(response.errored || response.status_code != 200)
		return "<body><div class=\"thumbnail-container\"><img src=\"aaaaaaaaa\"></img></div><body>" //put some pic src here
	return html_decode(response.body)

/proc/getListOfEnclosedStrings(string, start_string, end_string)
	var/list/res = new()
	var/ptrpos = 1
	while(findtext(string, start_string, ptrpos))
		var/s = findtext(string, start_string, ptrpos)
		var/e = findtext(string, end_string, s+length(start_string))
		res.Add(copytext(string, s+length(start_string), e))
		ptrpos = e
	return res

