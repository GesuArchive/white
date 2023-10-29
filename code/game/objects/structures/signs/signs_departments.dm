//departmental signs


///////MEDBAY

/obj/structure/sign/departments/medbay
	name = "Знак Медицинского отдела"
	sign_change_name = "Отдел - Медбей"
	desc = "Межгалактический символ медицинских учреждений. Возможно, вам помогут здесь."
	icon_state = "bluecross"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/medbay, 32)

/obj/structure/sign/departments/medbay/alt
	icon_state = "bluecross2"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/medbay/alt, 32)

/obj/structure/sign/departments/examroom
	name = "Табличка смотровой комнаты"
	sign_change_name = "Отдел - Медбей: Осмотр"
	desc = "Указатель с надписью \"Смотровая комната\"."
	icon_state = "examroom"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/exam_room, 32)

/obj/structure/sign/departments/chemistry
	name = "Знак Химического отдела"
	sign_change_name = "Отдел - Медбей: Химия"
	desc = "Знак, обозначающий зону, в которой находится химическое оборудование."
	icon_state = "chemistry1"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/chemistry, 32)

/obj/structure/sign/departments/chemistry/pharmacy
	name = "Знак аптеки"
	sign_change_name = "Отдел - Медбей: Аптека"
	desc = "Знак, обозначающий зону, в которой находится аптечное оборудование."
	icon_state = "pharmacy"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/chemistry/pharmacy, 32)

/obj/structure/sign/departments/psychology
	name = "Психология"
	sign_change_name = "Отдел - Медбей: Психология"
	desc = "Табличка с указанием места работы психолога, который, возможно, поможет вам разобраться в себе."
	icon_state = "psychology"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/psychology, 32)

///////ENGINEERING

/obj/structure/sign/departments/engineering
	name = "Знак Инженерного отдела"
	sign_change_name = "Отдел - Инженерный"
	desc = "Знак, обозначающий зону, где работают инженеры."
	icon_state = "engine"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/engineering, 32)

///////SCIENCE

/obj/structure/sign/departments/science
	name = "Знак Научного отдела"
	sign_change_name = "Отдел - Наука"
	desc = "Знак, обозначающий зону, где проводятся исследования и научные работы."
	icon_state = "science1"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/science, 32)

/obj/structure/sign/departments/science/alt
	icon_state = "science2"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/science/alt, 32)

/obj/structure/sign/departments/xenobio
	name = "Знак Ксенобиологии"
	sign_change_name = "Отдел - Наука: Ксенобиология"
	desc = "Знак, обозначающий зону, где проводятся исследования ксенобиологических сущностей."
	icon_state = "xenobio"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/xenobio, 32)

/obj/structure/sign/departments/nanites
	name = "Nanite Lab sign"
	sign_change_name = "Department - Science: Nanites"
	desc = "A sign labelling an area where testing and development of nanites is performed."
	icon_state = "nanites"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/rndserver, 32)

///////SERVICE

/obj/structure/sign/departments/botany
	name = "Botany sign"
	sign_change_name = "Department - Botany"
	desc = "A sign labelling an area as a place where plants are grown."
	icon_state = "hydro1"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/botany, 32)

/obj/structure/sign/departments/custodian
	name = "Janitor sign"
	sign_change_name = "Department - Janitor"
	desc = "A sign labelling an area where the janitor works."
	icon_state = "custodian"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/custodian, 32)

/obj/structure/sign/departments/holy
	name = "Chapel sign"
	sign_change_name = "Department - Chapel"
	desc = "A sign labelling a religious area."
	icon_state = "holy"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/holy, 32)

/obj/structure/sign/departments/lawyer
	name = "Legal Department sign"
	sign_change_name = "Department - Legal"
	desc = "A sign labelling an area where the Lawyers work, apply here for arrivals shuttle whiplash settlement."
	icon_state = "lawyer"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/lawyer, 32)

///////SUPPLY

/obj/structure/sign/departments/cargo
	name = "Cargo sign"
	sign_change_name = "Department - Cargo"
	desc = "A sign labelling an area where cargo ships dock."
	icon_state = "cargo"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/cargo, 32)

///////SECURITY

/obj/structure/sign/departments/security
	name = "Security sign"
	sign_change_name = "Department - Security"
	desc = "A sign labelling an area where the law is law."
	icon_state = "security"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/security, 32)

////MISC LOCATIONS

/obj/structure/sign/departments/restroom
	name = "Restroom sign"
	sign_change_name = "Location - Restroom"
	desc = "A sign labelling a restroom."
	icon_state = "restroom"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/restroom, 32)

/obj/structure/sign/departments/mait
	name = "Maintenance Tunnel sign"
	sign_change_name = "Location - Maintenance"
	desc = "A sign labelling an area where the departments of the station are linked together."
	icon_state = "mait1"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/maint, 32)

/obj/structure/sign/departments/mait/alt
	name = "Maintenance Tunnel sign"
	sign_change_name = "Location - Maintenance Alt"
	desc = "A sign labelling an area where the departments of the station are linked together."
	icon_state = "mait2"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/maint/alt, 32)

/obj/structure/sign/departments/evac
	name = "Evacuation sign"
	sign_change_name = "Location - Evacuation"
	desc = "A sign labelling an area where evacuation procedures take place."
	icon_state = "evac"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/evac, 32)

/obj/structure/sign/departments/drop
	name = "Drop Pods sign"
	sign_change_name = "Location - Drop Pods"
	desc = "A sign labelling an area where drop pod loading procedures take place."
	icon_state = "drop"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/drop, 32)

/obj/structure/sign/departments/court
	name = "Courtroom sign"
	sign_change_name = "Location - Courtroom"
	desc = "A sign labelling the courtroom, where the ever sacred Space Law is upheld."
	icon_state = "court"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/court, 32)

/obj/structure/sign/departments/telecomms
	name = "Telecommunications sign"
	sign_change_name = "Location - Telecommunications"
	desc = "A sign labelling an area where the station's radio and NTnet servers are stored."
	icon_state = "telecomms"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/telecomms, 32)

/obj/structure/sign/departments/telecomms/alt
	icon_state = "telecomms2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/telecomms/alt, 32)

/obj/structure/sign/departments/aiupload
	name = "AI Upload sign"
	sign_change_name = "Location - AI Upload"
	desc = "A sign labelling an area where laws are uploaded to the station's AI and cyborgs."
	icon_state = "aiupload"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/aiupload, 32)

/obj/structure/sign/departments/aisat
	name = "AI Satellite sign"
	sign_change_name = "Location - AI Satellite"
	desc = "A sign labelling the AI's heavily-fortified satellite."
	icon_state = "aisat"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/aisat, 32)

/obj/structure/sign/departments/vault
	name = "Vault sign"
	sign_change_name = "Location - Vault"
	desc = "A sign labelling a saferoom where the station's resources and self-destruct are secured."
	icon_state = "vault"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/vault, 32)
