// defensive wizard spells
/datum/spellbook_entry/magicm
	name = "Волшебные ракеты"
	desc = "Выпускает несколько медленно движущихся магических снарядов по ближайшим целям и оглушает их."
	spell_type = /datum/action/cooldown/spell/aoe/magic_missile
	category = "Defensive"

/datum/spellbook_entry/disabletech
	name = "Подавление техники"
	desc = "Отключает все энергитическое оружие, камеры и большинство других технологических устройств в радиусе действия."
	spell_type = /datum/action/cooldown/spell/emp/disable_tech
	category = "Defensive"
	cost = 1

/datum/spellbook_entry/repulse
	name = "Ударная волна"
	desc = "Отбрасывает все, что находится вокруг пользователя."
	spell_type = /datum/action/cooldown/spell/aoe/repulse/wizard
	category = "Defensive"

/datum/spellbook_entry/lightning_packet
	name = "Метнуть молнию"
	desc = "Сплетенный из сверхъестественной энергии, пучёк чистой силы, \
		маленький сгусток появится в вашей руке, при успешном попадании ненадолго оглушает цель."
	spell_type = /datum/action/cooldown/spell/conjure_item/spellpacket
	category = "Defensive"

/datum/spellbook_entry/timestop
	name = "Остановка Времени"
	desc = "Останавливает время в небольшом радиусе вокруг применившего, для всех, кроме вас, позволяя вам свободно двигаться, \
		в то время как ваши враги и даже снаряды останавливаются."
	spell_type = /datum/action/cooldown/spell/timestop
	category = "Defensive"

/datum/spellbook_entry/smoke
	name = "Дым"
	desc = "Создает облако удушливого дыма вокруг вас."
	spell_type = /datum/action/cooldown/spell/smoke
	category = "Defensive"
	cost = 1

/datum/spellbook_entry/forcewall
	name = "Магическая стена"
	desc = "Создайте магический барьер, через который сможете пройти только вы."
	spell_type = /datum/action/cooldown/spell/forcewall
	category = "Defensive"
	cost = 1

/datum/spellbook_entry/lichdom
	name = "Привязать душу"
	desc = "Проклятый тёмный пакт, который может навсегда запечатать вашу душу в предмет который вы держите в руках, \
		превращая тебя в бессмертного Лича. До тех пор, пока предмет остается нетронутым, вы будете освобождены от смерти, \
		независимо от обстоятельств. Будьте осторожны - с каждым возрождением ваше тело будет становиться слабее, и \
		другим будет легче найти предмет с вашей душой."
	spell_type =  /datum/action/cooldown/spell/lichdom
	category = "Defensive"

/datum/spellbook_entry/spacetime_dist
	name = "Искажение пространства-времени"
	desc = "Запутайте нити пространства-времени в области вокруг вас, \
		исказив пространство вокруг и сделав осознанное перемещение практически невозможным. Пространство вибрирует..."
	spell_type = /datum/action/cooldown/spell/spacetime_dist
	category = "Defensive"
	cost = 1

/datum/spellbook_entry/the_traps
	name = "Ловушки!"
	desc = "Призовите вокруг себя несколько ловушек. наносить урон и пакостить всем врагам, которые наступят на них."
	spell_type = /datum/action/cooldown/spell/conjure/the_traps
	category = "Defensive"
	cost = 1

/datum/spellbook_entry/bees
	name = "Малый Призыв Пчёл"
	desc = "Это заклинание волшебным образом пробуждает межпространственный улей, \
		мгновенно вызывая рой пчел к вашему местоположению. ОСТОРОЖНО! Эти пчелы враждебны ко всем!"
	spell_type = /datum/action/cooldown/spell/conjure/bee
	category = "Defensive"

/datum/spellbook_entry/duffelbag
	name = "Дар Проклятой Сумки"
	desc = "Проклятие, которое насильно прикрепляет демоническую сумку к спине цели. \
		Сумка вечно голодна и периодически кусает своего носителя, \
		если её не кормить, и независимо от того, кормили её или нет, \
		она значительно замедлит человека, носящего её."
	spell_type = /datum/action/cooldown/spell/touch/duffelbag
	category = "Defensive"
	cost = 1

/datum/spellbook_entry/item/staffhealing
	name = "Посох исцеления"
	desc = "Альтруистический посох, который может исцелять раненых и воскрешать мертвых."
	item_path = /obj/item/gun/magic/staff/healing
	cost = 1
	category = "Defensive"

/datum/spellbook_entry/item/lockerstaff
	name = "Посох Шкафчиков"
	desc = "Мистический посох, снаряды которого замуровывают своих жертв в запертых волшебных шкафчиках."
	item_path = /obj/item/gun/magic/staff/locker
	category = "Defensive"

/datum/spellbook_entry/item/scryingorb
	name = "Шар Провидца"
	desc = "Раскаленный шар потусторонней энергии, просто держа его в руках, ваше зрение и слух с легкостью преступает рамки ограничивающие смертных, а пристальный взгляд в него позволяет вам увидеть всю вселенную."
	item_path = /obj/item/scrying
	category = "Defensive"

/datum/spellbook_entry/item/wands
	name = "Перевязь для посохов"
	desc = "Набор разнообразных посохов на все случаи жизни. \
		Посохи имеют ограниченное количество зарядов, поэтому будьте осторожны в их использовании. Поставляются с удобной перевязью для хранения."
	item_path = /obj/item/storage/belt/wands/full
	category = "Defensive"

/datum/spellbook_entry/item/wands/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_equipped = user.equip_to_slot_if_possible(to_equip, ITEM_SLOT_BELT, disable_warning = TRUE)
	to_chat(user, span_notice("[to_equip.name] был вызван [was_equipped ? "в моих руках" : "у моих ног"]."))

/datum/spellbook_entry/item/armor
	name = "Комплект Доспехов Боевого Мага"
	desc = "Артефакторный доспех, помогающий при чтении заклинаний и \
		обеспечивающий высокую защиту от всех видов урона и космического вакуума. \
		Также дарует щит боевого мага."
	item_path = /obj/item/mod/control/pre_equipped/enchanted
	category = "Defensive"

/datum/spellbook_entry/item/armor/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/obj/item/mod/control/mod = to_equip
	var/obj/item/mod/module/storage/storage = locate() in mod.modules
	var/obj/item/back = user.back
	if(back)
		if(!user.dropItemToGround(back))
			return
		for(var/obj/item/item as anything in back.contents)
			item.forceMove(storage)
	if(!user.equip_to_slot_if_possible(mod, mod.slot_flags, qdel_on_fail = FALSE, disable_warning = TRUE))
		return
	if(!user.dropItemToGround(user.wear_suit) || !user.dropItemToGround(user.head))
		return
	mod.quick_activation()

/datum/spellbook_entry/item/battlemage_charge
	name = "Накопитель для доспехов боевого мага"
	desc = "Мощный защитный оберег, дарующий восемь дополнительных зарядов для доспехов боевого мага."
	item_path = /obj/item/wizard_armour_charge
	category = "Defensive"
	cost = 1
