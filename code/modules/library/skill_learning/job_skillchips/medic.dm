/obj/item/skillchip/job/medic
	name = "медицинский скилчип MED-001-PARA"
	desc = "Сертифицированно кошачьей лапой."
	auto_traits = list(TRAIT_KNOW_MED_SURGERY_T1)
	skill_name = "Базовые хирургические операции"
	skill_description = "Загружает в разум пользователя базовый пакет знаний и моторных рефлексов для проведения простейших хирургических операций."
	skill_icon = "book-medical"
	complexity = 1
	custom_price = PAYCHECK_HARD * 2
	custom_premium_price = PAYCHECK_HARD * 3
	activate_message = span_notice("В памяти проявляется порядок проведения простейших хирургических операций.")
	deactivate_message = span_notice("Все инструкции о проведении операций расплываются в памяти...")

/obj/item/skillchip/job/medic/advanced
	name = "медицинский скилчип MED-002-SURG"
	desc = "Сертифицированно кошачьей лапой."
	auto_traits = list(TRAIT_KNOW_MED_SURGERY_T2)
	skill_name = "Продвинутые хирургические операции"
	skill_description = "Загружает в разум пользователя расширенный пакет знаний и моторных рефлексов для проведения большинства хирургических операций."
	skill_icon = "book-medical"
	complexity = 2
	activate_message = span_notice("В памяти проявляется порядок проведения большинства хирургических операций.")
	deactivate_message = span_notice("Все инструкции о проведении операций расплываются в памяти...")

/obj/item/skillchip/job/medic/super
	name = "медицинский скилчип MED-003-CMO"
	desc = "Сертифицированно кошачьей лапой."
	auto_traits = list(TRAIT_KNOW_MED_SURGERY_T3)
	skill_name = "Профессиональные хирургические операции"
	skill_description = "Загружает в разум пользователя углебленный пакет знаний и моторных рефлексов для проведения сложных хирургических операций."
	skill_icon = "book-medical"
	complexity = 3
	activate_message = span_notice("В памяти проявляется порядок проведения сложных хирургических операций.")
	deactivate_message = span_notice("Все инструкции о проведении операций расплываются в памяти...")
