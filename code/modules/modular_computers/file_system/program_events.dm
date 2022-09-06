// Events are sent to the program by the computer.
// Always include a parent call when overriding an event.

// Called when the ID card is removed from computer. ID is removed AFTER this proc.
/datum/computer_file/program/proc/event_idremoved(background)
	return

// Called when the computer fails due to power loss. Override when program wants to specifically react to power loss.
/datum/computer_file/program/proc/event_powerfailure(background)
	kill_program(forced = TRUE)

// Called when the network connectivity fails. Computer does necessary checks and only calls this when requires_ntnet_feature and similar variables are not met.
/datum/computer_file/program/proc/event_networkfailure(background)
	kill_program(forced = TRUE)
	if(background)
		computer.visible_message(span_danger("Экран [computer] отображает ошибку: \"Процесс [filename].[filetype] (PID [rand(100,999)]) завершён — ошибка сети\""))
	else
		computer.visible_message(span_danger("Экран [computer] ненадолго застыл, затем отобразил ошибку: \"ОШИБКА СЕТИ — потеряно соединение с NTNet. Пожалуйста, попробуйте еще раз. Если проблема не исчезнет, обратитесь к системному администратору.\"."))
