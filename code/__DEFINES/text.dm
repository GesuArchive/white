/// Prepares a text to be used for maptext. Use this so it doesn't look hideous.
#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}
#define MAPTEXT_REALLYBIG(text) {"<span class='maptext reallybig'>[##text]</span>"}
#define MAPTEXT_REALLYBIG_COLOR(text, color) {"<span class='maptext reallybig' style='color:[##color]'>[##text]</span>"}

/// Prepares a text to be used for maptext, using a variable size font.
/// Variable size font. More flexible but doesn't scale pixel perfect to BYOND icon resolutions. (May be blurry.) Can use any size in pt or px.
#define MAPTEXT_VCR_OSD_MONO(text) {"<span style='font-family: \"VCR OSD Mono\"'>[##text]</span>"}

/// Prepares a text to be used for maptext using a pixel font. Cleaner but less size choices.
/// Standard size (ie: normal runechat) Use only sizing pt, multiples of 6: 6pt 12pt 18pt 24pt etc. - Not for use with px sizing
#define MAPTEXT_GRAND9K(text) {"<span style='font-family: \"Grand9K Pixel\"'>[##text]</span>"}

/// Prepares a text to be used for maptext using a pixel font. Cleaner but less size choices.
/// Small size. (ie: whisper runechat) Use only size pt, multiples of 12: 12pt 24pt 48pt etc. - Not for use with px sizing
#define MAPTEXT_TINY_UNICODE(text) {"<span style='font-family: \"TinyUnicode\"'>[##text]</span>"}

/// Macro from Lummox used to get height from a MeasureText proc.
/// resolves the MeasureText() return value once, then resolves the height, then sets return_var to that.
#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);

// Used by PDA and cartridge code to reduce repetitiveness of spritesheets
#define PDAIMG(what) {"<span class="pda16x16 [#what]"></span>"}

/// Removes characters incompatible with file names.
#define SANITIZE_FILENAME(text) (GLOB.filename_forbidden_chars.Replace(text, ""))
