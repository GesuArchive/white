///////////////////////////////////
/////Subspace Telecomms////////////
///////////////////////////////////

/datum/design/board/subspace_receiver
	name = "Подпространственный приемник"
	desc = "Эта машина имеет форму тарелкообразной приемной антенны и зеленые огоньки. Предназначена для приема и обработки подпространственной радиосигнала."
	id = "s-receiver"
	build_type = IMPRINTER | MECHFAB
	build_path = /obj/item/circuitboard/machine/telecomms/receiver
	category = list("Подпространственная связь")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/telecomms_bus
	name = "Мэйнфрейм шины"
	desc = "Мощное аппаратное обеспечение, используемое для быстрой передачи огромных объемов данных и связывание машин в общую сеть."
	id = "s-bus"
	build_path = /obj/item/circuitboard/machine/telecomms/bus
	category = list("Подпространственная связь")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/telecomms_hub
	name = "Телекоммуникационный узел"
	desc = "Мощное аппаратное обеспечение, используемое для отправки / приема огромных объемов данных."
	id = "s-hub"
	build_path = /obj/item/circuitboard/machine/telecomms/hub
	category = list("Подпространственная связь")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/telecomms_relay
	name = "Телекоммуникационный ретранслятор"
	desc = "Мощное аппаратное обеспечение, используемое для передачи огромных объемов данных на огромное расстояние."
	id = "s-relay"
	build_path = /obj/item/circuitboard/machine/telecomms/relay
	category = list("Подпространственная связь")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/telecomms_processor
	name = "Процессорный блок"
	desc = "Эта машина используется для обработки больших объемов информации."
	id = "s-processor"
	build_path = /obj/item/circuitboard/machine/telecomms/processor
	category = list("Подпространственная связь")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/telecomms_server
	name = "Телекоммуникационный сервер"
	desc = "Машина, используемая для хранения данных и сетевой статистики."
	id = "s-server"
	build_path = /obj/item/circuitboard/machine/telecomms/server
	category = list("Подпространственная связь")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/telecomms_messaging
	name = "Сервер месенджера"
	desc = "Машина, которая обрабатывает и маршрутизирует сообщения КПК и запрашивает консольные сообщения."
	id = "s-messaging"
	build_path = /obj/item/circuitboard/machine/telecomms/message_server
	category = list("Подпространственная связь")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/subspace_broadcaster
	name = "Подпространственный вещатель"
	desc = "Машина в форме тарелки, используемая для передачи обработанных подпространственных сигналов."
	id = "s-broadcaster"
	build_path = /obj/item/circuitboard/machine/telecomms/broadcaster
	category = list("Подпространственная связь")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE
