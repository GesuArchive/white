// Wizard spells that assist the caster in some way
/datum/spellbook_entry/summonitem
	name = "Призыв предмета"
	desc = "Возвращает ранее помеченный предмет в вашу руку из любой точки вселенной."
	spell_type = /datum/action/cooldown/spell/summonitem
	category = "Assistance"
	cost = 1

/datum/spellbook_entry/charge
	name = "Зарядить"
	desc = "Это заклинание можно использовать для подзарядки самых разных вещей в ваших руках, от магических артефактов до энергозависимой экипировки. Креативный волшебник может даже использовать его, чтобы наделить магической силой другого пользователя магии."
	spell_type = /datum/action/cooldown/spell/charge
	category = "Assistance"
	cost = 1

/datum/spellbook_entry/shapeshift
	name = "Изменение формы"
	desc = "Примите на время облик другого существа, чтобы использовать его природные способности. Как только вы сделаете свой выбор, то больше вы уже не сможете его изменить."
	spell_type = /datum/action/cooldown/spell/shapeshift/wizard
	category = "Assistance"
	cost = 1

/datum/spellbook_entry/tap
	name = "Жертва души"
	desc = "Подпитывайте свои заклинания, используя свою собственную душу!"
	spell_type = /datum/action/cooldown/spell/tap
	category = "Assistance"
	cost = 1

/datum/spellbook_entry/item/staffanimation
	name = "Посох Анимации"
	desc = "Мистический посох, способный стрелять разрядами сверхъестественной энергии, которые заставляют оживать неодушевленные предметы. Эта магия не действует на машины."
	item_path = /obj/item/gun/magic/staff/animate
	category = "Assistance"

/datum/spellbook_entry/item/soulstones
	name = "Набор осколков Камня Душ"
	desc = "Осколки Камня Душ - это древние инструменты, способные захватывать и порабощать духов мертвых и умирающих. \
		Заклинание позволяет вам создавать зловещие конструкты для захваченных душ."
	item_path = /obj/item/storage/belt/soulstone/full
	category = "Assistance"

/datum/spellbook_entry/item/soulstones/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_equipped = user.equip_to_slot_if_possible(to_equip, ITEM_SLOT_BELT, disable_warning = TRUE)
	to_chat(user, span_notice("[to_equip.name] был вызван [was_equipped ? "в моих руках" : "у моих ног"]."))

/datum/spellbook_entry/item/soulstones/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book)
	. =..()
	if(!.)
		return

	var/datum/action/cooldown/spell/conjure/construct/bonus_spell = new(user.mind || user)
	bonus_spell.Grant(user)

/datum/spellbook_entry/item/necrostone
	name = "Камень некроманта"
	desc = "Камень некроманта способный воскрешать мертвых людей в качестве рабов-скелетов, которыми вы можете командовать."
	item_path = /obj/item/necromantic_stone
	category = "Assistance"

/datum/spellbook_entry/item/contract
	name = "Контракт на обучение"
	desc = "Магический контракт, обязывающий ученика школы волшебства служить вам, его использование вызовет его к вам. Если конечно он будет... Но вы сможете вернуть свои очки, вставив его в свою книгу заклинаний!"
	item_path = /obj/item/antag_spawner/contract
	category = "Assistance"
	refundable = TRUE

/datum/spellbook_entry/item/guardian
	name = "Колода стража"
	desc = "Колода карт таро стража способная привязать личного хранителя к вашему телу. Доступно несколько типов стражей, однако если страж получит урон, то вы так же ощутите его последствия и на себе. \
	Было бы разумно избегать приобретение стража вместе с чем-либо, что может заставить вас сменить тело."
	item_path = /obj/item/guardiancreator/choose/wizard
	category = "Assistance"

/datum/spellbook_entry/item/guardian/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book)
	. = ..()
	if(!.)
		return

	new /obj/item/paper/guides/antag/guardian/wizard(get_turf(user))
	to_chat(user, span_notice("Если вы не знакомы с путями волшебных стражей, сверьтесь с руководством."))

/datum/spellbook_entry/item/bloodbottle
	name = "Фиал с кипящей кровью"
	desc = "Бутылка с настойкой магической крови, запах которой  \
		привлечет существ из другого измерения если вы разобьете склянку. Но будьте осторожны, \
		существа, вызванные магической кровью, коварны \
		и вполне возможно попытаются вас сожрать в самый неподходящий момент."
	item_path = /obj/item/antag_spawner/slaughter_demon
	limit = 3
	category = "Assistance"
	refundable = TRUE

/datum/spellbook_entry/item/hugbottle
	name = "Фиал с жидким смехом"
	desc = "Бутылёк настойки концентрированного веселья, запах которого \
		привлекающий чудаковатых существ из другого измерения если вы разобьете склянку. Эти существа \
		похожи на демонов-убийц, но они не убивают  \
		своих жертв, вместо этого перемещают их в обитель смеха, \
		из которой они освобождаются при смерти демона. Хаотично, но недостаточно \
		надёжно. Реакция экипажа на этого демона может быть очень \
		разрушительной. Но будьте осторожны, \
		существа, вызванные магической кровью, коварны \
		и вполне возможно попытаются вас сожрать в самый неподходящий момент."
	item_path = /obj/item/antag_spawner/slaughter_demon/laughter
	cost = 1 //non-destructive; it's just a jape, sibling!
	limit = 3
	category = "Assistance"
	refundable = TRUE
