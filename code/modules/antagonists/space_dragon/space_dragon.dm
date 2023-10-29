/datum/antagonist/space_dragon
	name = "Космический Дракон"
	roundend_category = "space dragons"
	antagpanel_category = "Space Dragon"
	job_rank = ROLE_SPACE_DRAGON
	show_in_antagpanel = TRUE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	var/list/datum/mind/carp = list()
	greentext_reward = 35

/datum/antagonist/space_dragon/greet()
	to_chat(owner, "<b>Мы движемся через бесконечное время и пространство. Мы не помним откуда мы пришли и не знаем куда мы пойдем. Весь космос принадлежит нам.\n\
					В этом пустом вакууме наш вид был высшим хищником и не было почти ничего, способного потягаться с нами.\n\
					Но сейчас мы обнаружили чужаков, нарушивших наши границы, покусившихся на наши притязания и готовых биться с нашими клыками своей невообразимой магией. Их логова подобны фонарям, мерцающим в глубине космоса.\n\
					Сегодня мы погасим один из них.</b>")
	to_chat(owner, span_boldwarning("У вас есть пять минут для того чтобы найти безопасное место для размещения первого разрыва. Если вы не уложитесь в это время, то вы вернетесь в то место, откуда пришли."))
	owner.announce_objectives()
	SEND_SOUND(owner.current, sound('sound/magic/demon_attack1.ogg'))

/datum/antagonist/space_dragon/proc/forge_objectives()
	var/datum/objective/summon_carp/summon = new()
	summon.dragon = src
	objectives += summon

/datum/antagonist/space_dragon/on_gain()
	forge_objectives()
	. = ..()

/datum/objective/summon_carp
	var/datum/antagonist/space_dragon/dragon
	explanation_text = "Summon and protect the rifts to flood the station with carp."

/datum/antagonist/space_dragon/roundend_report()
	var/list/parts = list()
	var/datum/objective/summon_carp/S = locate() in objectives
	if(S.check_completion())
		parts += "<span class='redtext big'>[name] добился успеха! Пространство станции было возвращено космическим карпом!</span>"
	parts += printplayer(owner)
	var/objectives_complete = TRUE
	if(objectives.len)
		parts += printobjectives(objectives)
		for(var/datum/objective/objective in objectives)
			if(!objective.check_completion())
				objectives_complete = FALSE
				break
	if(objectives_complete)
		parts += "<span class='greentext big'>[name] преуспел!</span>"
	else
		parts += "<span class='redtext big'>[name] провалил задачу!</span>"
	parts += span_header("[name] помогли:")
	parts += printplayerlist(carp)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
