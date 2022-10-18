/// Prepares a text to be used for maptext. Use this so it doesn't look hideous.
#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}
#define MAPTEXT_REALLYBIG(text) {"<span class='maptext reallybig'>[##text]</span>"}
#define MAPTEXT_REALLYBIG_COLOR(text, color) {"<span class='maptext reallybig' style='color:[##color]'>[##text]</span>"}

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
