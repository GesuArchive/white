//traits with no real impact that can be taken freely
//MAKE SURE THESE DO NOT MAJORLY IMPACT GAMEPLAY. those should be positive or negative traits.

/datum/quirk/no_taste
	name = "Агевзия"
	desc = "Вы потеряли свои вкусовые рецепторы и не можете почувствовать вкус какой-либо еды! Но токсичная пища всё-равно будет отравлять вас."
	value = 0
	mob_trait = TRAIT_AGEUSIA
	gain_text = "<span class='notice'>Вы больше не чувствуете вкус еды!</span>"
	lose_text = "<span class='notice'>Теперь вы можете почувствовать вкус еды!</span>"
	medical_record_text = "Пациент страдает от агавзии и неспособен чувствовать вкус еды или жидкости."

/datum/quirk/vegetarian
	name = "Вегетарианец"
	desc = "Вы находите идею есть мясо физически и морально отталкивающим."
	value = 0
	gain_text = "<span class='notice'>Вы находите идею есть мясо физически и морально отталкивающим.</span>"
	lose_text = "<span class='notice'>Вы чувствуете, что перестали быть вегетарианцем..</span>"
	medical_record_text = "Пациент сообщает о вегетарианской диете.."

/datum/quirk/vegetarian/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food &= ~MEAT
	species.disliked_food |= MEAT

/datum/quirk/vegetarian/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		if(initial(species.liked_food) & MEAT)
			species.liked_food |= MEAT
		if(!initial(species.disliked_food) & MEAT)
			species.disliked_food &= ~MEAT

/datum/quirk/pineapple_liker
	name = "Любитель ананасов"
	desc = "Вы очень сильно любите ананасы. Вы никогда ими не наедитесь!"  
	value = 0
	gain_text = "<span class='notice'>Вы чувствуете, что испытываете сильную тягу к ананасам..</span>"
	lose_text = "<span class='notice'>Ваша любовь к ананасам медленно угасает..</span>"
	medical_record_text = "Пациент демонстрирует патологическую любовь к ананасу."

/datum/quirk/pineapple_liker/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food |= PINEAPPLE

/datum/quirk/pineapple_liker/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.liked_food &= ~PINEAPPLE

/datum/quirk/pineapple_hater
	name = "Отвращение к ананасам"
	desc = "Вы ненавидите ананасы. Серьёзно, кто, чёрт возьми, в здравом уме скажет, что они вкусные? И какой психопат посмел бы положить это в ПИЦЦУ?!"
	value = 0
	gain_text = "<span class='notice'>Вы думаете над тем, какой кусок идиота любит ананасы...</span>" 
	lose_text = "<span class='notice'>Ваша ненависть к ананасам медленнно угасает...</span>"
	medical_record_text = "Пациент считает, что ананасы отвратительны."

/datum/quirk/pineapple_hater/add() 
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.disliked_food |= PINEAPPLE

/datum/quirk/pineapple_hater/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.disliked_food &= ~PINEAPPLE

/datum/quirk/deviant_tastes
	name = "Девиантные вкусы"
	desc = "Вы не любите ту еду, которое большинство предпочитает употреблять. Тем не менее, вы любите то, что не любят они."
	value = 0
	gain_text = "<span class='notice'>У вас возникает жажда съесть что-нибудь странное на вкус.</span>"
	lose_text = "<span class='notice'>Вам хочется поесть нормальную еду.</span>"
	medical_record_text = "Пациент демонстрирует необычные предпочтения к еде."

/datum/quirk/deviant_tastes/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	var/liked = species.liked_food
	species.liked_food = species.disliked_food
	species.disliked_food = liked

/datum/quirk/deviant_tastes/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.liked_food = initial(species.liked_food)
		species.disliked_food = initial(species.disliked_food)

/datum/quirk/monochromatic
	name = "Монохромия"
	desc = "Вы не можете различать цвета и видите весь мир в черно-белых тонах."
	value = 0
	medical_record_text = "У пациента было обнаружено нарушение цветового зрения."

/datum/quirk/monochromatic/add()
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_add()
	if(quirk_holder.mind.assigned_role == "Detective")
		to_chat(quirk_holder, "<span class='boldannounce'>Ммм. На этой станции нет ничего чистого. Это всё оттенки серого...</span>")
		quirk_holder.playsound_local(quirk_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	if(quirk_holder)
		quirk_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/phobia
	name = "Фобия"
	desc = "Ты чего-то боишься."
	value = 0
	medical_record_text = "Пациент чего-то очень сильно боится."

/datum/quirk/phobia/post_add()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(new /datum/brain_trauma/mild/phobia(H.client.prefs.phobia), TRAUMA_RESILIENCE_ABSOLUTE)
	
/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		H.cure_trauma_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE)
