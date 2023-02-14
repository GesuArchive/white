/obj/item/skillchip/job/engineer
	name = "инженерный скилчип C1-RCU-1T"
	desc = "Одобрено Поли."
	auto_traits = list(TRAIT_KNOW_ENGI_WIRES)
	chip_category = "engi"
	incompatibility_list = list("engi")
	skill_name = "Знание инженерных схем"
	skill_description = "Распознает маркировку проводов дверных шлюзов, АПЦ и других машин."
	skill_icon = "sitemap"
	custom_price = PAYCHECK_HARD * 2
	custom_premium_price = PAYCHECK_HARD * 3
	activate_message = span_notice("В памяти проявляются все возможные комбинации распиновок проводов и кодировки маркировок.")
	deactivate_message = span_notice("Все схемы распиновок проводов расплываются в памяти...")
