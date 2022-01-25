/client/proc/mentor_follow(mob/living/M)
	if(!is_mentor())
		return
	var/orbiting = TRUE
	if(!isobserver(usr))
		mentor_datum.following = M
		usr.reset_perspective(M)
		add_verb(src,/client/proc/mentor_unfollow)
		to_chat(usr, "<span class='info'>Нажми <a href='?_src_=mentor;mentor_unfollow=1;[MentorHrefToken(TRUE)]'>\"СЮДА\"</a>, чтобы перестать следить за [key_name(M)].</span>")
		orbiting = FALSE
	else
		var/mob/dead/observer/O = usr
		O.ManualFollow(M)
	to_chat(GLOB.admins, "<span class='mentor'><span class='prefix'>ЗНАТОК:</span> <EM>[key_name(usr)]</EM> теперь [orbiting ? "кружит вокруг" : "следит за"] <EM>[key_name(M)][key_name(M)][orbiting ? " как призрак" : ""].</span>")
	log_mentor("[key_name(usr)] [orbiting ? "is now orbiting" : "began following"][key_name(M)][orbiting ? " as a ghost" : ""].")

/client/proc/mentor_unfollow()
	set category = "Знаток"
	set name = "Перестать следить"
	set desc = "Stop following the followed."

	if(!is_mentor())
		return
	usr.reset_perspective()
	remove_verb(src,/client/proc/mentor_unfollow)
	to_chat(GLOB.admins, "<span class='mentor'><span class='prefix'>ЗНАТОК:</span> <EM>[key_name(usr)]</EM> больше не следит за <EM>[key_name(mentor_datum.following)].</span>")
	log_mentor("[key_name(usr)] stopped following [key_name(mentor_datum.following)].")
	mentor_datum.following = null
