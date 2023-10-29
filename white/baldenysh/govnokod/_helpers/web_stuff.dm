/proc/get_html_doc_string(link)
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, "[link]", "", "", null)
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()
	if(response.errored || response.status_code != 200)
		return null
	return html_decode(response.body)

/proc/get_list_of_strings_enclosed(string, start_enclosing, end_enclosing)//блядь да как этой хуйне нормальное назвние придумать-то
	var/list/res = new()
	var/ptrpos = 1
	while(findtext(string, start_enclosing, ptrpos))
		var/s = findtext(string, start_enclosing, ptrpos)
		var/e = findtext(string, end_enclosing, s+length(start_enclosing))
		res.Add(copytext(string, s+length(start_enclosing), e))
		ptrpos = e
	return res
