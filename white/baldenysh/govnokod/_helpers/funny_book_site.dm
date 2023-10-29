//porn is funny i swear

#define CORS_THING_REQUEST_LINK "https://api.allorigins.win/raw?url="
#define FUNNY_BOOK_SITE_REQUEST_LINK_URI_ENCODED "https%3A//gelbooru.com/index.php%3Fpage%3Dpost%26s%3Dlist%26tags%3D"

#define FUNNY_BOOK_SITE_HAIR_COLOR_TAGS list(\
		"#0FFFFF" = "Aqua_hair",\
		"#000000" = "Black_hair",\
		"#FAF0BE" = "Blonde_hair",\
		"#0000FF" = "Blue_hair",\
		"#964B00" = "Brown_hair",\
		"#B5651D" = "Light_brown_hair",\
		"#00ff00" = "Green_hair",\
		"#808080" = "Grey_hair",\
		"#FFA500" = "Orange_hair",\
		"#FFC0CB" = "Pink_hair",\
		"#800080" = "Purple_hair",\
		"#E6E6FA" = "Lavender_hair",\
		"#FF0000" = "Red_hair",\
		"#C0C0C0" = "Silver_hair",\
		"#FFFFFF" = "White_hair"\
	)

#define FUNNY_BOOK_SITE_EYE_COLOR_TAGS list(\
		"#0FFFFF" = "Aqua_eyes",\
		"#000000" = "Black_eyes",\
		"#0000FF" = "Blue_eyes",\
		"#964B00" = "Brown_eyes",\
		"#FFBF00" = "Amber_eyes",\
		"#B5651D" = "Light_Brown_eyes",\
		"#D4AF37" = "Gold_eyes",\
		"#00ff00" = "Green_eyes",\
		"#808080" = "Grey_eyes",\
		"#8E7618" = "Hazel_eyes",\
		"#FFA500" = "Orange_eyes",\
		"#FFC0CB" = "Pink_eyes",\
		"#800080" = "Purple_eyes",\
		"#E6E6FA" = "Lavender_eyes",\
		"#FF0000" = "Red_eyes",\
		"#B03060" = "Maroon_eyes",\
		"#C0C0C0" = "Silver_eyes",\
		"#FFFFFF" = "White_eyes",\
		"#FFFF00" = "Yellow_eyes"\
	)

 //эту фегню надо дальше допиливать, но я заебался и вообще похуй, по итогу прикол почти никому не зашел
/proc/human2tags(mob/living/carbon/human/H)
	var/hairHex = findtext(H.hair_color, "#") ? H.hair_color :"#[H.hair_color]"
	var/eyeHex = findtext(H.eye_color_left, "#") ? H.eye_color_left :"#[H.eye_color_left]"
	return "[hairColor2tag(hairHex)]+[eyeColor2tag(eyeHex)]"

/proc/hairColor2tag(hairColor)
	return FUNNY_BOOK_SITE_HAIR_COLOR_TAGS[closest_color(hairColor, FUNNY_BOOK_SITE_HAIR_COLOR_TAGS)]

/proc/eyeColor2tag(eyeColor)
	return FUNNY_BOOK_SITE_EYE_COLOR_TAGS[closest_color(eyeColor, FUNNY_BOOK_SITE_EYE_COLOR_TAGS)]

/proc/tags2pics(tags_string)
	var/container = get_list_of_strings_enclosed(get_html_doc_string("[CORS_THING_REQUEST_LINK][FUNNY_BOOK_SITE_REQUEST_LINK_URI_ENCODED][tags_string]"),\
		 "<div class=\"thumbnail-container\">","</div>")[1]
	return get_list_of_strings_enclosed(container, "src=\"", "\"")
