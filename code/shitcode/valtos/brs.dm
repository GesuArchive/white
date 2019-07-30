////////////////////////////
//
// Feedback Report System
//
////////////////////////////

/client/var/tfbsfr = 0

/client/verb/feedbacksolution()
	set name = "Feedback"
	set category = "Special Verbs"

	if(tfbsfr >= 3)
		to_chat(src, "�������� ����� �������. �� ��� �����������, �������.")
		return

	tfbsfr++

	SSblackbox.record_feedback("tally", "feedbacks_send", 1, "Feedback") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	feedback_send(src)


/client/proc/feedback_send(src)

	var/list/message = list()

	message["head"] = input(src,"Message:", "���������� �������� ������ �������") as message|null
	message["content"] = input(src,"Message:", "��������� ��� ������ � ��������� �����") as message|null

	message["head"] = trim(message["head"])
	message["content"] = trim(message["content"])

	if(!msg || !msghead)
		to_chat(src, "���������.")
		return

	var/formattedmessage = "Header: [message["head"]]\nContent: [message["content"]]\nCoords: [AREACOORD(src)]"

	text2file(formattedmessage, "data/feedbacksystem.log")

	to_chat(src, "���� ���������: \"[message["head"]]\"\n\"[message["content"]]\"\n ���� ����������. ���������� ��� �� ������.")