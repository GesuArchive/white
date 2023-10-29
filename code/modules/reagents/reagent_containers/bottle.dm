//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle

/obj/item/reagent_containers/glass/bottle
	name = "флакон"
	desc = "Маленький флакон."
	icon_state = "bottle"
	fill_icon_state = "bottle"
	inhand_icon_state = "atoxinbottle"
	possible_transfer_amounts = list(5,10,15,25,30)
	volume = 30
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/glass/bottle/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "bottle"
	update_icon()

/obj/item/reagent_containers/glass/bottle/epinephrine
	name = "флакон с адреналином"
	desc = "Маленький флакон. Внутри адреналин, используемый для стабилизации пациентов."
	list_reagents = list(/datum/reagent/medicine/epinephrine = 30)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "флакон с токсином"
	desc = "Маленький флакон, наполненный токсинами. Не пить, высокотоксичен."
	list_reagents = list(/datum/reagent/toxin = 30)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "флакон с цианидом"
	desc = "Маленький флакон с цианидом. Горький миндаль?"
	list_reagents = list(/datum/reagent/toxin/cyanide = 30)

/obj/item/reagent_containers/glass/bottle/spewium
	name = "флакон с спьювиумом"
	desc = "Маленький флакон с спьювиумом."
	list_reagents = list(/datum/reagent/toxin/spewium = 30)

/obj/item/reagent_containers/glass/bottle/morphine
	name = "флакон с морфием"
	desc = "Маленький флакон с морфием."
	icon = 'icons/obj/chemical.dmi'
	list_reagents = list(/datum/reagent/medicine/morphine = 30)

/obj/item/reagent_containers/glass/bottle/chloralhydrate
	name = "флакон с хлоралгидратом"
	desc = "Маленький флакон с хлоралгидратом. Лучшее лакомство!"
	icon_state = "bottle20"
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 15)

/obj/item/reagent_containers/glass/bottle/mannitol
	name = "флакон с маннитолом"
	desc = "Флакончик с маннитолом. Используется для лечения повреждений мозга."
	list_reagents = list(/datum/reagent/medicine/mannitol = 30)

/obj/item/reagent_containers/glass/bottle/multiver
	name = "флакон с мультивером"
	desc = "Маленький флакон мультивера, который выводит токсины и прочие химикаты из кровостока, но вызывает отдышку. Эффект зависит от количества реагентов в организме пациента."
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 30)

/obj/item/reagent_containers/glass/bottle/calomel
	name = "флакон с каломелью"
	desc = "Маленькй флакон каломели, которая быстро очищает организм пациента от химикатов. Наносит токсичный урон, если пациент не сильно ранен.."
	list_reagents = list(/datum/reagent/medicine/calomel = 30)

/obj/item/reagent_containers/glass/bottle/syriniver
	name = "флакон с сиринивером"
	desc = "Маленький флакон сиринивера."
	list_reagents = list(/datum/reagent/medicine/c2/syriniver = 30)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "флакон с нестабильным мутагеном"
	desc = "Маленький флакон с нестабильным мутагеном. Случайным образом изменяет структуру ДНК у любого с кем контактирует."
	list_reagents = list(/datum/reagent/toxin/mutagen = 30)

/obj/item/reagent_containers/glass/bottle/plasma
	name = "флакон с жидкой плазмой"
	desc = "Маленький флакон с жидкой плазмой. Крайне токсична и вступает в реакцию с содержащимися в крови микроорганизмами."
	list_reagents = list(/datum/reagent/toxin/plasma = 30)

/obj/item/reagent_containers/glass/bottle/synaptizine
	name = "флакон с синаптизином"
	desc = "Маленький флакон с синаптизином. Повышает устойчивость к оглушению, а также уменьшает сонливость и галлюцинации"
	list_reagents = list(/datum/reagent/medicine/synaptizine = 30)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "флакон с аммиаком"
	desc = "Маленький флакон с аммиаком."
	list_reagents = list(/datum/reagent/ammonia = 30)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "флакон с диэтиламином"
	desc = "Маленький флакон с диэтиламином."
	list_reagents = list(/datum/reagent/diethylamine = 30)

/obj/item/reagent_containers/glass/bottle/facid
	name = "Флакон с Фтористоводородной Кислотой"
	desc = "Маленький флакон. Содержит небольшое количество фтористоводородной кислоты."
	list_reagents = list(/datum/reagent/toxin/acid/fluacid = 30)

/obj/item/reagent_containers/glass/bottle/penacid
	name = "Пентетовая кислота"
	desc = "Небольшая бутылка кислоты, способной выводить токсины и радиацию."
	list_reagents = list(/datum/reagent/medicine/pen_acid = 30)

/obj/item/reagent_containers/glass/bottle/sal_acid
	name = "Салициловая кислота"
	desc = "Небольшая бутылка со средством для лечения побоев и ушибов."
	list_reagents = list(/datum/reagent/medicine/sal_acid = 30)

/obj/item/reagent_containers/glass/bottle/oxandrolone
	name = "Оксандролон"
	desc = "Небольшая бутылка со средством для лечения ожогов."
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 30)

/obj/item/reagent_containers/glass/bottle/synthflesh
	name = "Синтеплоть"
	desc = "Небольшая бутылка со средством для лечения ожогов и ушибов ценой интоксикации. Перед использованием поместить в пластырь или распылитель."
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 30)

/obj/item/reagent_containers/glass/bottle/adminordrazine
	name = "Флакон с Админордразином"
	desc = "Маленький флакон. Содержит жидкую эссенцию богов."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	list_reagents = list(/datum/reagent/medicine/adminordrazine = 30)

/obj/item/reagent_containers/glass/bottle/capsaicin
	name = "Флакон с Капсаицином"
	desc = "Маленький флакон. Содержит обжигающе острый соус."
	list_reagents = list(/datum/reagent/consumable/capsaicin = 30)

/obj/item/reagent_containers/glass/bottle/frostoil
	name = "Флакон с Морозным Маслом"
	desc = "Маленький флакон. Содержит остужающий холодный соус."
	list_reagents = list(/datum/reagent/consumable/frostoil = 30)

/obj/item/reagent_containers/glass/bottle/traitor
	name = "флакон синдиката"
	desc = "Маленький флакон. Содержит случайный нехороший химикат."
	icon = 'icons/obj/chemical.dmi'
	var/extra_reagent = null

/obj/item/reagent_containers/glass/bottle/traitor/Initialize(mapload)
	. = ..()
	extra_reagent = pick(/datum/reagent/toxin/polonium, /datum/reagent/toxin/histamine, /datum/reagent/toxin/formaldehyde, /datum/reagent/toxin/venom, /datum/reagent/toxin/fentanyl, /datum/reagent/toxin/cyanide)
	reagents.add_reagent(extra_reagent, 3)

/obj/item/reagent_containers/glass/bottle/polonium
	name = "флакон с полонием"
	desc = "Маленький флакон. Содержит полоний."
	list_reagents = list(/datum/reagent/toxin/polonium = 30)

/obj/item/reagent_containers/glass/bottle/magillitis
	name = "флакон с магиллитисом"
	desc = "Маленький флакон. Содержит сыворотку известную как магиллитис"
	list_reagents = list(/datum/reagent/magillitis = 5)

/obj/item/reagent_containers/glass/bottle/venom
	name = "флакон с отравой"
	desc = "Маленький флакон. Содержит Отраву."
	list_reagents = list(/datum/reagent/toxin/venom = 30)

/obj/item/reagent_containers/glass/bottle/fentanyl
	name = "флакон с фентанилом"
	desc = "Маленький флакон. Содержит Фентанил."
	list_reagents = list(/datum/reagent/toxin/fentanyl = 30)

/obj/item/reagent_containers/glass/bottle/formaldehyde
	name = "флакон с формальдегидом"
	desc = "Маленький флакон. Содержит формальдегид, химикат предотвращающий разложение органов."
	list_reagents = list(/datum/reagent/toxin/formaldehyde = 30)

/obj/item/reagent_containers/glass/bottle/initropidril
	name = "флакон с инитропидрилом"
	desc = "Маленький флакон. Содержит инитропидрил."
	list_reagents = list(/datum/reagent/toxin/initropidril = 30)

/obj/item/reagent_containers/glass/bottle/pancuronium
	name = "флакон с панкурониумом"
	desc = "Маленький флакон. Содержит панкуроний."
	list_reagents = list(/datum/reagent/toxin/pancuronium = 30)

/obj/item/reagent_containers/glass/bottle/sodium_thiopental
	name = "флакон с тиопенталом натрия"
	desc = "Маленький флакон. Содержит тиопентал натрия."
	list_reagents = list(/datum/reagent/toxin/sodium_thiopental = 30)

/obj/item/reagent_containers/glass/bottle/coniine
	name = "флакон с кониином"
	desc = "Маленький флакон. Содержит кониин."
	list_reagents = list(/datum/reagent/toxin/coniine = 30)

/obj/item/reagent_containers/glass/bottle/curare
	name = "флакон с кураре"
	desc = "Маленький флакон. Содержит кураре."
	list_reagents = list(/datum/reagent/toxin/curare = 30)

/obj/item/reagent_containers/glass/bottle/amanitin
	name = "флакон с аманитином"
	desc = "Маленький флакон. Содержит аманитин."
	list_reagents = list(/datum/reagent/toxin/amanitin = 30)

/obj/item/reagent_containers/glass/bottle/histamine
	name = "флакон с гистамином"
	desc = "Маленький флакон. Содержит Гистамин."
	list_reagents = list(/datum/reagent/toxin/histamine = 30)

/obj/item/reagent_containers/glass/bottle/diphenhydramine
	name = "флакон с антигистаминным веществом"
	desc = "Маленький флакон с дифенгидрамином."
	list_reagents = list(/datum/reagent/medicine/diphenhydramine = 30)

/obj/item/reagent_containers/glass/bottle/potass_iodide
	name = "флакон с антирадом"
	desc = "Маленький флакон с йодидом калия."
	list_reagents = list(/datum/reagent/medicine/potass_iodide = 30)

/obj/item/reagent_containers/glass/bottle/salglu_solution
	name = "флакон физраствора с глюкозой"
	desc = "Маленький флакон наполненный физраствором с глюкозой."
	icon_state = "bottle1"
	list_reagents = list(/datum/reagent/medicine/salglu_solution = 30)

/obj/item/reagent_containers/glass/bottle/atropine
	name = "флакон с атропином"
	desc = "Маленький флакон с атропином."
	list_reagents = list(/datum/reagent/medicine/atropine = 30)

/obj/item/reagent_containers/glass/bottle/random_buffer
	name = "щелочной буфер"
	desc = "Небольшая бутылочка на 30 единиц. Содержит щелочной буфер."

/obj/item/reagent_containers/glass/bottle/random_buffer/Initialize(mapload)
	. = ..()
	if(prob(50))
		name = "кислотный буфер"
		desc = "Небольшая бутылочка на 30 единиц. Содержит кислотный буфер."
		reagents.add_reagent(/datum/reagent/reaction_agent/acidic_buffer, 30)
	else
		name = "щелочной буфер"
		desc = "Небольшая бутылочка на 30 единиц. Содержит щелочной буфер."
		reagents.add_reagent(/datum/reagent/reaction_agent/basic_buffer, 30)

/obj/item/reagent_containers/glass/bottle/acidic_buffer
	name = "кислотный буфер"
	desc = "Небольшая бутылочка на 30 единиц. Содержит кислотный буфер."
	list_reagents = list(/datum/reagent/reaction_agent/acidic_buffer = 30)

/obj/item/reagent_containers/glass/bottle/basic_buffer
	name = "щелочной буфер"
	desc = "Небольшая бутылочка на 30 единиц. Содержит щелочной буфер."
	list_reagents = list(/datum/reagent/reaction_agent/basic_buffer = 30)

/obj/item/reagent_containers/glass/bottle/romerol
	name = "флакон с ромеролом"
	desc = "Маленький флакон с Ромеролом, НАСТОЯЩИМ зомби порошком."
	list_reagents = list(/datum/reagent/romerol = 30)

/obj/item/reagent_containers/glass/bottle/random_virus
	name = "Флакон со штаммом экспериментальной болезни"
	desc = "Маленький флакон. Содержит непроверенный штамм вируса в синтекровяной среде."
	spawned_disease = /datum/disease/advance/random

/obj/item/reagent_containers/glass/bottle/pierrot_throat
	name = "Флакон со штаммом Глотки Пьеро"
	desc = "Маленький флакон. Содержит штамм вириона HONI<42 в синтекровяной среде."
	spawned_disease = /datum/disease/pierrot_throat

/obj/item/reagent_containers/glass/bottle/cold
	name = "Флакон со штаммом риновируса"
	desc = "Маленький флакон. Содержит штамм XY-риновируса в синтекровяной среде."
	spawned_disease = /datum/disease/advance/cold

/obj/item/reagent_containers/glass/bottle/flu_virion
	name = "Флакон со штаммом вириона гриппа"
	desc = "Маленький флакон. Содержит штамм вириона гриппа H13N1 в синтекровяной среде."
	spawned_disease = /datum/disease/advance/flu

/obj/item/reagent_containers/glass/bottle/retrovirus
	name = "Флакон со штаммом ретровируса"
	desc = "Маленький флакон. Содержит штамм ретровируса в синтекровяной среде."
	spawned_disease = /datum/disease/dna_retrovirus

/obj/item/reagent_containers/glass/bottle/gbs
	name = "Флакон со штаммом GBS"
	desc = "Маленький флакон. Содержит штамм Gravitokinetic Bipotential SADS+ в среде синтекрови."//Or simply - General BullShit
	amount_per_transfer_from_this = 5
	spawned_disease = /datum/disease/gbs

/obj/item/reagent_containers/glass/bottle/fake_gbs
	name = "Флакон со штаммом GBS"
	desc = "Маленький флакон. Содержит штамм Gravitokinetic Bipotential SADS- в среде синтекрови."//Or simply - General BullShit
	spawned_disease = /datum/disease/fake_gbs

/obj/item/reagent_containers/glass/bottle/brainrot
	name = "Флакон со штаммом Мозговой Гнили"
	desc = "Маленький флакон. Содержит штамм Cryptococcus Cosmosis в синтекровяной среде."
	icon_state = "bottle3"
	spawned_disease = /datum/disease/brainrot

/obj/item/reagent_containers/glass/bottle/magnitis
	name = "Флакон со штаммом Магнитиса"
	desc = "Маленький флакон. Содержит небольшую дозировку Ебчих Чуд."
	spawned_disease = /datum/disease/magnitis

/obj/item/reagent_containers/glass/bottle/wizarditis
	name = "Флакон со штаммом Визардитиса"
	desc = "Маленький флакон. Содержит образец Ринцевиндуса Вулгариса."
	spawned_disease = /datum/disease/wizarditis

/obj/item/reagent_containers/glass/bottle/anxiety
	name = "Флакон со штаммом Тяжелой Тревожности"
	desc = "Маленький флакон. Содержит образец лепидоптицидов."
	spawned_disease = /datum/disease/anxiety

/obj/item/reagent_containers/glass/bottle/beesease
	name = "Beesease culture bottle"
	desc = "A small bottle. Contains a sample of invasive Apidae."
	spawned_disease = /datum/disease/beesease

/obj/item/reagent_containers/glass/bottle/fluspanish
	name = "Флакон со штаммом Испанки"
	desc = "Маленький флакон. Содержит образец Инквизициума."
	spawned_disease = /datum/disease/fluspanish

/obj/item/reagent_containers/glass/bottle/tuberculosis
	name = "Флакон со штаммом Грибкового Туберкулеза"
	desc = "Маленький флакон. Содержит образец палочки Грибкового Туберкулеза."
	spawned_disease = /datum/disease/tuberculosis

/obj/item/reagent_containers/glass/bottle/tuberculosiscure
	name = "Флакон с ПБВН"
	desc = "Маленький флакон, содержащий ПротивоБиоВирусный Набор."
	list_reagents = list(/datum/reagent/vaccine/fungal_tb = 30)

/obj/item/reagent_containers/glass/bottle/tuberculosiscure
	name = "Флакон с ПБВН"
	desc = "Маленький флакон, содержащий ПротивоБиоВирусный Набор."
	list_reagents = list(/datum/reagent/consumable/virus_food = 30)

//Oldstation.dmm chemical storage bottles

/obj/item/reagent_containers/glass/bottle/hydrogen
	name = "флакон с водородом"
	list_reagents = list(/datum/reagent/hydrogen = 30)

/obj/item/reagent_containers/glass/bottle/lithium
	name = "флакон с литием"
	list_reagents = list(/datum/reagent/lithium = 30)

/obj/item/reagent_containers/glass/bottle/carbon
	name = "флакон с углеродом"
	list_reagents = list(/datum/reagent/carbon = 30)

/obj/item/reagent_containers/glass/bottle/nitrogen
	name = "флакон с азотом"
	list_reagents = list(/datum/reagent/nitrogen = 30)

/obj/item/reagent_containers/glass/bottle/oxygen
	name = "флакон с кислородом"
	list_reagents = list(/datum/reagent/oxygen = 30)

/obj/item/reagent_containers/glass/bottle/fluorine
	name = "флакон с фтором"
	list_reagents = list(/datum/reagent/fluorine = 30)

/obj/item/reagent_containers/glass/bottle/sodium
	name = "флакон с натрием"
	list_reagents = list(/datum/reagent/sodium = 30)

/obj/item/reagent_containers/glass/bottle/aluminium
	name = "флакон с алюминием"
	list_reagents = list(/datum/reagent/aluminium = 30)

/obj/item/reagent_containers/glass/bottle/silicon
	name = "флакон с кремнием"
	list_reagents = list(/datum/reagent/silicon = 30)

/obj/item/reagent_containers/glass/bottle/phosphorus
	name = "флакон с фосфором"
	list_reagents = list(/datum/reagent/phosphorus = 30)

/obj/item/reagent_containers/glass/bottle/sulfur
	name = "флакон с серой"
	list_reagents = list(/datum/reagent/sulfur = 30)

/obj/item/reagent_containers/glass/bottle/chlorine
	name = "флакон с хлором"
	list_reagents = list(/datum/reagent/chlorine = 30)

/obj/item/reagent_containers/glass/bottle/potassium
	name = "флакон с калием"
	list_reagents = list(/datum/reagent/potassium = 30)

/obj/item/reagent_containers/glass/bottle/iron
	name = "флакон с железом"
	list_reagents = list(/datum/reagent/iron = 30)

/obj/item/reagent_containers/glass/bottle/copper
	name = "флакон с медью"
	list_reagents = list(/datum/reagent/copper = 30)

/obj/item/reagent_containers/glass/bottle/mercury
	name = "флакон с ртутью"
	list_reagents = list(/datum/reagent/mercury = 30)

/obj/item/reagent_containers/glass/bottle/radium
	name = "флакон с радием"
	list_reagents = list(/datum/reagent/uranium/radium = 30)

/obj/item/reagent_containers/glass/bottle/water
	name = "флакон с водой"
	list_reagents = list(/datum/reagent/water = 30)

/obj/item/reagent_containers/glass/bottle/ethanol
	name = "флакон с этанолом"
	list_reagents = list(/datum/reagent/consumable/ethanol = 30)

/obj/item/reagent_containers/glass/bottle/sugar
	name = "флакон с сахаром"
	list_reagents = list(/datum/reagent/consumable/sugar = 30)

/obj/item/reagent_containers/glass/bottle/sacid
	name = "флакон с серной кислотой"
	list_reagents = list(/datum/reagent/toxin/acid = 30)

/obj/item/reagent_containers/glass/bottle/welding_fuel
	name = "флакон со сварочным топливом"
	list_reagents = list(/datum/reagent/fuel = 30)

/obj/item/reagent_containers/glass/bottle/silver
	name = "флакон с серебром"
	list_reagents = list(/datum/reagent/silver = 30)

/obj/item/reagent_containers/glass/bottle/iodine
	name = "флакон с йодом"
	list_reagents = list(/datum/reagent/iodine = 30)

/obj/item/reagent_containers/glass/bottle/bromine
	name = "флакон с бромом"
	list_reagents = list(/datum/reagent/bromine = 30)

/obj/item/reagent_containers/glass/bottle/thermite
	name = "флакон с термитом"
	list_reagents = list(/datum/reagent/thermite = 30)
