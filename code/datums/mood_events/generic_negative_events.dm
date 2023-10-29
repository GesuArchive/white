/datum/mood_event/handcuffed
	description = "<span class='warning'>Кажется мои выходки кто-то заметил.</span>\n"
	mood_change = -5

/datum/mood_event/broken_vow //Used for when mimes break their vow of silence
	description = "<span class='boldwarning'>Моё имя было опозорено нарушением моего обета...</span>\n"
	mood_change = -16

/datum/mood_event/on_fire
	description = "<span class='boldwarning'>ГОРЮ!!!</span>\n"
	mood_change = -24

/datum/mood_event/suffocation
	description = "<span class='boldwarning'>НЕ.. МОГУ... ДЫШАТЬ...</span>\n"
	mood_change = -24

/datum/mood_event/burnt_thumb
	description = "<span class='warning'>Не стоило мне играть с зажигалкой.</span>\n"
	mood_change = -3
	timeout = 2 MINUTES

/datum/mood_event/cold
	description = "<span class='warning'>Тут очень холодно.</span>\n"
	mood_change = -10

/datum/mood_event/hot
	description = "<span class='warning'>Становится жарковато.</span>\n"
	mood_change = -10

/datum/mood_event/creampie
	description = "<span class='warning'>Меня окремили. На вкус как пирог.</span>\n"
	mood_change = -6
	timeout = 3 MINUTES

/datum/mood_event/slipped
	description = "<span class='warning'>Опять поскальзываюсь. Надо быть аккуратней.</span>\n"
	mood_change = -6
	timeout = 1 MINUTES

/datum/mood_event/eye_stab
	description = "<span class='boldwarning'>МНЕ ПРОТКНУЛИ ГЛАЗ!!!</span>\n"
	mood_change = -16
	timeout = 3 MINUTES

/datum/mood_event/delam //SM delamination
	description = "<span class='boldwarning'>Эти инженеры никогда не могут что-то сделать нормально...</span>\n"
	mood_change = -3
	timeout = 10 MINUTES

/datum/mood_event/depression_minimal
	description = "<span class='warning'>Мне немного грустно.</span>\n"
	mood_change = -10
	timeout = 2 MINUTES

/datum/mood_event/depression_mild
	description = "<span class='warning'>Мне грустно без каких-либо причин.</span>\n"
	mood_change = -12
	timeout = 2 MINUTES

/datum/mood_event/depression_moderate
	description = "<span class='warning'>Мне грустно.</span>\n"
	mood_change = -14
	timeout = 2 MINUTES

/datum/mood_event/depression_severe
	description = "<span class='warning'>Хочу умереть.</span>\n"
	mood_change = -16
	timeout = 2 MINUTES

/datum/mood_event/shameful_suicide //suicide_acts that return SHAME, like sord
	description = "<span class='boldwarning'>Даже не могу покончить со всем этим!</span>\n"
	mood_change = -30
	timeout = 1 MINUTES

/datum/mood_event/dismembered
	description = "<span class='boldwarning'>АА-А! МНЕ НУЖНА БЫЛА ЭТА КОНЕЧНОСТЬ!</span>\n"
	mood_change = -15
	timeout = 2.5 MINUTES

/datum/mood_event/tased
	description = "<span class='warning'>There's no \"z\" in \"taser\". It's in the zap.</span>\n"
	mood_change = -6
	timeout = 2 MINUTES

/datum/mood_event/embedded
	description = "<span class='boldwarning'>Достаньте это из меня, достаньте!</span>\n"
	mood_change = -12

/datum/mood_event/table
	description = "<span class='warning'>Кто-то бросил меня на стол!</span>\n"
	mood_change = -4
	timeout = 1 MINUTES

/datum/mood_event/table/add_effects()
	if(isfelinid(owner))
		var/mob/living/carbon/human/H = owner
		H.dna.species.start_wagging_tail(H)
		addtimer(CALLBACK(H.dna.species, TYPE_PROC_REF(/datum/species, stop_wagging_tail), H), 30)
		description =  "<span class='nicegreen'>Со мной хотят поиграться на столе!</span>\n"
		mood_change = 2

/datum/mood_event/table_limbsmash
	description = "<span class='warning'>Моя голова очень сильно болит!</span>\n"
	mood_change = -6
	timeout = 3 MINUTES

/datum/mood_event/table_limbsmash/add_effects(obj/item/bodypart/banged_limb)
	if(banged_limb)
		description = "<span class='warning'>My fucking [banged_limb.name], man that hurts...</span>\n"

/datum/mood_event/fried
	description = "<span class='warning'>МОЁ ЛИЦО ПРОЖАРИЛИ!</span>\n"
	mood_change = -8
	timeout = 10 MINUTES

/datum/mood_event/brain_damage
	mood_change = -6

/datum/mood_event/brain_damage/add_effects()
	var/damage_message = pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage")
	description = "<span class='warning'>Хых... Хах... [damage_message]</span>\n"

/datum/mood_event/hulk //Entire duration of having the hulk mutation
	description = "<span class='warning'>ХАЛК КРУШИТЬ</span>\n"
	mood_change = 8 //lol

/datum/mood_event/epilepsy //Only when the mutation causes a seizure
	description = "<span class='warning'>Стоило обратить внимание на предупреждение об эпилепсии.</span>\n"
	mood_change = -6
	timeout = 5 MINUTES

/datum/mood_event/nyctophobia
	description = "<span class='warning'>Здесь темновато...</span>\n"
	mood_change = -6

/datum/mood_event/claustrophobia
	description = "<span class='warning'>Почему я чувствую себя в ловушке?! Выпустите меня!!!</span>\n"
	mood_change = -7
	timeout = 1 MINUTES

/datum/mood_event/bright_light
	description = "<span class='boldwarning'>Ненавижу белых... Хочу срочно стать негром...</span>\n"
	mood_change = -240

/datum/mood_event/family_heirloom_missing
	description = "<span class='warning'>Скучаю по моей семейной реликвии...</span>\n"
	mood_change = -8

/datum/mood_event/healsbadman
	description = "<span class='warning'>Меня держит тонкая нить, и у меня ощущение, что можно развалиться в любой момент!</span>\n"
	mood_change = -8
	timeout = 2 MINUTES

/datum/mood_event/jittery
	description = "<span class='warning'>Нервничаю, нервничаю и не могу стоять ровно!</span>\n"
	mood_change = -4

/datum/mood_event/vomit
	description = "<span class='warning'>Меня только что вырвало. Мерзость.</span>\n"
	mood_change = -4
	timeout = 2 MINUTES

/datum/mood_event/vomitself
	description = "<span class='warning'>Меня только что стошнило на себя. Это отвратительно.</span>\n"
	mood_change = -8
	timeout = 3 MINUTES

/datum/mood_event/painful_medicine
	description = "<span class='warning'>Медицина может быть и хороша для меня, но сейчас она адово жалит!</span>\n"
	mood_change = -10
	timeout = 1 MINUTES

/datum/mood_event/spooked
	description = "<span class='warning'>Дребезжание тех костей... Я не могу это забыть.</span>\n"
	mood_change = -8
	timeout = 4 MINUTES

/datum/mood_event/loud_gong
	description = "<span class='warning'>Этот гонг и правда очень громок!</span>\n"
	mood_change = -6
	timeout = 2 MINUTES

/datum/mood_event/notcreeping
	description = "<span class='warning'>Голоса не рады тому, что я не выполняю своё задание, и они болезненно заставляют мои мысли выполнять его.</span>\n"
	mood_change = -12
	timeout = 30
	hidden = TRUE

/datum/mood_event/notcreepingsevere//not hidden since it's so severe
	description = "<span class='boldwarning'>ОНИИИ ХОТЯЯЯТ ЕГООО!!</span>\n"
	mood_change = -60
	timeout = 30

/datum/mood_event/notcreepingsevere/add_effects(name)
	var/list/unstable = list(name)
	for(var/i in 1 to rand(3,5))
		unstable += copytext_char(name, -1)
	var/unhinged = uppertext(unstable.Join(""))//example Tinea Luxor > TINEA LUXORRRR (with randomness in how long that slur is)
	description = "<span class='boldwarning'>ОНИИИ ХОТЯЯЯТ [unhinged]!!</span>\n"

/datum/mood_event/sapped
	description = "<span class='boldwarning'>Необъяснимая печаль пожирает меня...</span>\n"
	mood_change = -20
	timeout = 1.5 MINUTES

/datum/mood_event/back_pain
	description = "<span class='boldwarning'>Сумки никогда не сидят ровно на моей спине, это очень больно!</span>\n"
	mood_change = -20

/datum/mood_event/sad_empath
	description = "<span class='warning'>Кто-то видимо грустит...</span>\n"
	mood_change = -10
	timeout = 1 MINUTES

/datum/mood_event/sad_empath/add_effects(mob/sadtarget)
	description = "<span class='warning'>[sadtarget.name] кажется грустит...</span>\n"

/datum/mood_event/not_sad_empath
	description = "<span class='warning'>Кто-то радуется своей жизни!</span>\n"
	mood_change = 10
	timeout = 1 MINUTES

/datum/mood_event/not_sad_empath/add_effects(mob/sadtarget)
	description = "<span class='warning'>[sadtarget.name] отлично себя чувствует!</span>\n"

/datum/mood_event/sacrifice_bad
	description ="<span class='warning'>Эти чёртовы дикари!</span>\n"
	mood_change = -10
	timeout = 2 MINUTES

/datum/mood_event/artbad
	description = "<span class='warning'>У меня получалось и лучше чем это.</span>\n"
	mood_change = -4
	timeout = 2 MINUTES

/datum/mood_event/graverobbing
	description ="<span class='boldwarning'>I just desecrated someone's grave... I can't believe I did that...</span>\n"
	mood_change = -16
	timeout = 3 MINUTES

/datum/mood_event/deaths_door
	description = "<span class='boldwarning'>This is it... I'm really going to die.</span>\n"
	mood_change = -40

/datum/mood_event/gunpoint
	description = "<span class='boldwarning'>This guy is insane! I better be careful....</span>\n"
	mood_change = -20

/datum/mood_event/tripped
	description = "<span class='boldwarning'>I can't believe I fell for the oldest trick in the book!</span>\n"
	mood_change = -10
	timeout = 2 MINUTES

/datum/mood_event/untied
	description = "<span class='boldwarning'>I hate when my shoes come untied!</span>\n"
	mood_change = -2
	timeout = 1 MINUTES

/datum/mood_event/gates_of_mansus
	description = "<span class='boldwarning'>I HAD A GLIMPSE OF THE HORROR BEYOND THIS WORLD. REALITY UNCOILED BEFORE MY EYES!</span>\n"
	mood_change = -50
	timeout = 4 MINUTES

/datum/mood_event/high_five_alone
	description = "<span class='boldwarning'>I tried getting a high-five with no one around, how embarassing!</span>\n"
	mood_change = -5
	timeout = 1 MINUTES

/datum/mood_event/high_five_full_hand
	description = "<span class='boldwarning'>Oh God, I don't even know how to high-five correctly...</span>\n"
	mood_change = -3
	timeout = 45 SECONDS

/datum/mood_event/left_hanging
	description = "<span class='boldwarning'>But everyone loves high fives! Maybe people just... hate me?</span>\n"
	mood_change = -4
	timeout = 1.5 MINUTES

/datum/mood_event/too_slow
	description = "<span class='boldwarning'>NO! HOW COULD I BE.... TOO SLOW???</span>\n"
	mood_change = -4 // multiplied by how many people saw it happen, up to 8, so potentially massive. the ULTIMATE prank carries a lot of weight
	timeout = 2 MINUTES

/datum/mood_event/too_slow/add_effects(param)
	var/people_laughing_at_you = 1 // start with 1 in case they're on the same tile or something
	for(var/mob/living/carbon/iter_carbon in oview(owner, 7))
		if(iter_carbon.stat == CONSCIOUS)
			people_laughing_at_you++
			if(people_laughing_at_you > 7)
				break

	mood_change *= people_laughing_at_you
	return ..()

/datum/mood_event/tail_lost
	description = "<span class='boldwarning'>А-А-А-А! МОЙ ХВОСТ! ЗА ЧТО?!!</span>\n"
	mood_change = -50
	timeout = 2 HOURS

/datum/mood_event/tail_balance_lost
	description = "<span class='warning'>Чувствую, что не могу держать баланс без своего хвостика...</span>\n"
	mood_change = -4

/datum/mood_event/tail_regained_right
	description = "<span class='warning'>О-ох. Мой хвост возвращен, но это было больно!</span>\n"
	mood_change = -4
	timeout = 5 MINUTES

/datum/mood_event/tail_regained_wrong
	description = "<span class='boldwarning'>Это что, какая-то больная шутка?! Это не МОЙ хвост!!</span>\n"
	mood_change = -60 // -8 for tail still missing + -4 bonus for being frakenstein's monster
	timeout = 3 HOURS

//These are unused so far but I want to remember them to use them later
/datum/mood_event/surgery
	description = "<span class='boldwarning'>МЕНЯ РЕЖУТ НА КУСОЧКИ!!</span>\n"
	mood_change = -16

/datum/mood_event/nanite_sadness
	description = "<span class='warning robot'>+++++++HAPPINESS SUPPRESSION+++++++</span>\n"
	mood_change = -14

/datum/mood_event/nanite_sadness/add_effects(message)
	description = "<span class='warning robot'>+++++++[message]+++++++</span>\n"

/datum/mood_event/bald
	description ="<span class='warning'>I need something to cover my head...</span>\n"
	mood_change = -6

/datum/mood_event/bad_touch
	description = "<span class='warning'>I don't like when people touch me.</span>\n"
	mood_change = -6
	timeout = 4 MINUTES

/datum/mood_event/very_bad_touch
	description = "<span class='warning'>I really don't like when people touch me.</span>\n"
	mood_change = -10
	timeout = 4 MINUTES

/datum/mood_event/noogie
	description = "<span class='warning'>Ow! This is like space high school all over again...</span>\n"
	mood_change = -10
	timeout = 1 MINUTES
/datum/mood_event/noogie_harsh
	description = "<span class='warning'>OW!! That was even worse than a regular noogie!</span>\n"
	mood_change = -20
	timeout = 1 MINUTES

/datum/mood_event/aquarium_negative
	description = "<span class='warning'>Жалко рыбок...</span>\n"
	mood_change = -6
	timeout = 1.5 MINUTES

/datum/mood_event/burnt_wings
	description = "<span class='boldwarning'>MY PRECIOUS WINGS!!</span>\n"
	mood_change = -20
	timeout = 20 MINUTES

/datum/mood_event/holy_smite //punished
	description = "<span class='warning'>I have been punished by my deity!</span>\n"
	mood_change = -10
	timeout = 5 MINUTES

/datum/mood_event/banished //when the chaplain is sus! (and gets forcably de-holy'd)
	description = "<span class='boldwarning'>I have been excommunicated!</span>\n"
	mood_change = -20
	timeout = 10 MINUTES

/datum/mood_event/killed_innocent
	description = "<span class='warning'>Пришлось убить невиновного...</span>\n"
	mood_change = -50
	timeout = 30 MINUTES

/datum/mood_event/seen_dream
	description = "<span class='revenbignotice'>После увиденного не хочется жить...</span>\n"
	mood_change = -50

/datum/mood_event/seen_dream/add_effects(dreamer_key)
	if(!ishuman(owner))
		qdel(src)
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/heart/heart = H.get_organ_slot(ORGAN_SLOT_HEART)
	if(!heart)
		return
	H.emote("agony")
	heart.key_for_dreamer = dreamer_key
	SEND_SOUND(H, pick(RANDOM_DREAMER_SOUNDS))
	if(prob(0.001))
		description = "<span class='revenbignotice'>КАКОЕ ЧУДО!</span>\n"
		mood_change = 999

/datum/mood_event/heresy
	description = "<span class='warning'>I can hardly breathe with all this HERESY going on!</span>\n"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/soda_spill
	description = "<span class='warning'>Cool! That's fine, I wanted to wear that soda, not drink it...</span>\n"
	mood_change = -2
	timeout = 1 MINUTES

/datum/mood_event/watersprayed
	description = "<span class='warning'>I hate being sprayed with water!</span>\n"
	mood_change = -1
	timeout = 30 SECONDS

/datum/mood_event/gamer_withdrawal
	description = "<span class='warning'>I wish I was gaming right now...</span>\n"
	mood_change = -5

/datum/mood_event/gamer_lost
	description = "<span class='warning'>If I'm not good at video games, can I truly call myself a gamer?</span>\n"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/lost_52_card_pickup
	description = "<span class='warning'>This is really embarrassing! I'm ashamed to pick up all these cards off the floor...</span>\n"
	mood_change = -3
	timeout = 3 MINUTES

/datum/mood_event/russian_roulette_lose
	description = "<span class='warning'>I gambled my life and lost! I guess this is the end...</span>\n"
	mood_change = -20
	timeout = 10 MINUTES

/datum/mood_event/android_emp_mood
	description = "<span class='warning robot'>+++++++ВСЁ НЕ НОРМАЛЬНО+++++++</span>\n"
	mood_change = -100
