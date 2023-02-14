/obj/item/skillchip/job/roboticist
	name = "научный скилчип BORG-AI"
	desc = "Помогает лучше понимать лучших друзей."
	auto_traits = list(TRAIT_KNOW_CYBORG_WIRES)
	chip_category = "sci"
	incompatibility_list = list("sci")
	skill_name = "Знание кибернетических схем"
	skill_description = "Распознает маркировку проводов киборгов."
	skill_icon = "sitemap"
	custom_price = PAYCHECK_HARD * 2
	custom_premium_price = PAYCHECK_HARD * 3
	activate_message = span_notice("В памяти проявляются все возможные комбинации распиновок проводов киборгов и кодировки маркировок робототехники.")
	deactivate_message = span_notice("Все схемы распиновок проводов робототехники расплываются в памяти...")
