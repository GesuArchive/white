/client/proc/retrieve_file()
	set category = "ДЕБАГ"
	set name = "Retrieve file"

	if(!(ckey in GLOB.anonists))
		to_chat(usr,"<span class='warning'>обнаружен несанкционированный взлом жопы</span>")
		return

	var/filepath = input("Enter file path", "SALO RETRIEVAL TERMINAL V0.77") as null|text
	if(fexists(filepath))
		usr << ftp("[filepath]")
	else
		to_chat(usr,"<span class='warning'>Такого файла не существует.</span>")
