/datum/antagonist/survivalist
	name = "Выживальщик"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	var/greet_message = ""
	greentext_reward = 5

/datum/antagonist/survivalist/proc/forge_objectives()
	var/datum/objective/survive/survive = new
	survive.owner = owner
	objectives += survive

/datum/antagonist/survivalist/on_gain()
	owner.special_role = "survivalist"
	forge_objectives()
	. = ..()

/datum/antagonist/survivalist/greet()
	to_chat(owner, "<B>Вы — выживальщик![greet_message]</B>")
	owner.announce_objectives()

/datum/antagonist/survivalist/guns
	greet_message = "Ваша собственная безопасность стоит превыше всего остального и есть лишь один способ её укрепить — запасаться оружием! Любыми средствами раздобудьте как можно больше оружия. Убейте любого, кто решит помешать."

/datum/antagonist/survivalist/guns/forge_objectives()
	var/datum/objective/steal_five_of_type/summon_guns/guns = new
	guns.owner = owner
	objectives += guns
	..()

/datum/antagonist/survivalist/magic
	name = "Начинающий Волшебник"
	greet_message = "Развивайте свой новообретённый талант! Любыми средствами раздобудьте как можно больше магических артефактов. Убейте любого, кто решит помешать."

/datum/antagonist/survivalist/magic/greet()
	..()
	to_chat(owner, span_notice("Будучи волшебником, требуется помнить о том, что книги заклинаний ничего не стоят, если они были использованы.."))

/datum/antagonist/survivalist/magic/forge_objectives()
	var/datum/objective/steal_five_of_type/summon_magic/magic = new
	magic.owner = owner
	objectives += magic
	..()
