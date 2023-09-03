/**
 * Sends a message to discord admin chat channels.
 *
 * category - The category of the mssage.
 * message - The message to send.
 */
/proc/send2adminchat(category, message, embed_links = FALSE)
	category = replacetext(replacetext(category, "\proper", ""), "\improper", "")
	message = replacetext(replacetext(message, "\proper", ""), "\improper", "")
	if(!embed_links)
		message = GLOB.has_discord_embeddable_links.Replace(replacetext(message, "`", ""), " ```$1``` ")
	webhook_send_ahelp(category, message)

/// Handles text formatting for item use hints in examine text
#define EXAMINE_HINT(text) ("<b>" + text + "</b>")
