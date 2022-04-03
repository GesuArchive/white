//These clothing for blueshift map.
//I'm too lazy to sort this shit, maybe tomorrow, lol.

//uniforms
/obj/item/clothing/under/misc/greyshirt
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "grey shirt"
	desc = "A plain grey shirt and black pants - a much more rugged option compared to the jumpsuit."
	icon_state = "greyshirt"

/obj/item/clothing/under/misc/cargo_long
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "cargo technician's long jumpsuit"
	desc = "For crate-pushers who'd rather protect their legs than show them off."
	icon_state = "cargo_long"
	can_adjust = TRUE

/obj/item/clothing/under/misc/mechanic
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "mechanic's overalls"
	desc = "An old-fashioned pair of brown overalls, along with assorted pockets and belt-loops."
	icon_state = "mechanic"

/obj/item/clothing/under/dress/littleblack
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "short black dress"
	desc = "An extremely short black dress, for those with no shame."
	icon_state = "littleblackdress_s"
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/dress/pinktutu
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "pink tutu"
	desc = "A fluffy pink tutu."
	icon_state = "pinktutu_s"
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/pants/jeanripped
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "ripped jeans"
	desc = "If you're wearing this you're poor or a rebel"
	icon_state = "jean_ripped"

/obj/item/clothing/under/pants/jeanshort
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "jean shorts"
	desc = "These are really just jeans cut in half"
	icon_state = "jean_shorts"

/obj/item/clothing/under/pants/denimskirt
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "denim skirt"
	desc = "These are really just a jean leg hole cut from a pair"
	icon_state = "denim_skirt"

/obj/item/clothing/under/pants/chaps
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "black chaps"
	body_parts_covered = LEGS
	desc = "Yeehaw"
	icon_state = "chaps"

/obj/item/clothing/under/pants/yoga
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "yoga pants"
	desc = "Comfy!"
	icon_state = "yoga_pants"

/obj/item/clothing/under/pants/blackshorts
	name = "black ripped shorts"
	desc = "No one will ever know if you did this on accident or on purpose, but hey it looks good."
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	icon_state = "rippedshorts_black"

/obj/item/clothing/under/sweater
	icon = 'white/rebolution228/icons/unsorted/clothing/uniforms.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/uniform.dmi'
	name = "cream sweater"
	desc = "Why trade style for comfort? Now you can go commando down south and still be cozy up north."
	icon_state = "bb_turtle"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = TRUE

/obj/item/clothing/under/sweater/black
	name = "black sweater"
	icon_state = "bb_turtleblk"

/obj/item/clothing/under/sweater/purple
	name = "purple sweater"
	icon_state = "bb_turtlepur"

/obj/item/clothing/under/sweater/green
	name = "green sweater"
	icon_state = "bb_turtlegrn"

/obj/item/clothing/under/sweater/red
	name = "red sweater"
	icon_state = "bb_turtlered"

/obj/item/clothing/under/sweater/blue
	name = "blue sweater"
	icon_state = "bb_turtleblu"
////suits

/obj/item/clothing/suit/modern_winter
	icon = 'white/rebolution228/icons/unsorted/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/suit.dmi'
	name = "modern winter coat"
	desc = "A comfy modern winter coat."
	icon_state = "modern_winter"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT


/obj/item/clothing/suit/gorka/supply
	icon = 'white/rebolution228/icons/unsorted/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/suit.dmi'
	name = "supply gorka jacket"
	desc = "A snug jacket to wear over your gorka. This one matches with supply's colors."
	icon_state = "gorka_jacket_supply"
////gloves

/obj/item/clothing/gloves/ring
	icon = 'white/rebolution228/icons/unsorted/clothing/ring.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/hands.dmi'
	name = "gold ring"
	desc = "A tiny gold ring, sized to wrap around a finger."
	gender = NEUTER
	w_class = WEIGHT_CLASS_TINY
	icon_state = "ringgold"
	inhand_icon_state = "gring"
	worn_icon_state = "gring"
	body_parts_covered = 0
	strip_delay = 4 SECONDS
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/ring/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("\[user] is putting the [src] in [user.p_their()] mouth! It looks like [user] is trying to choke on the [src]!"))
	return OXYLOSS


/obj/item/clothing/gloves/ring/diamond
	name = "diamond ring"
	desc = "An expensive ring, studded with a diamond. Cultures have used these rings in courtship for a millenia."
	icon_state = "ringdiamond"
	inhand_icon_state = "dring"
	worn_icon_state = "dring"

/obj/item/clothing/gloves/ring/diamond/attack_self(mob/user)
	user.visible_message(span_warning("\The [user] gets down on one knee, presenting \the [src]."),span_warning("You get down on one knee, presenting \the [src]."))

/obj/item/clothing/gloves/ring/silver
	name = "silver ring"
	desc = "A tiny silver ring, sized to wrap around a finger."
	icon_state = "ringsilver"
	inhand_icon_state = "sring"
	worn_icon_state = "sring"


///shoes

/obj/item/clothing/shoes/wraps
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	name = "gilded leg wraps"
	desc = "Ankle coverings. These ones have a golden design."
	icon_state = "gildedcuffs"
	body_parts_covered = FALSE

/obj/item/clothing/shoes/wraps/silver
	name = "silver leg wraps"
	desc = "Ankle coverings. Not made of real silver."
	icon_state = "silvergildedcuffs"

/obj/item/clothing/shoes/wraps/red
	name = "red leg wraps"
	desc = "Ankle coverings. Show off your style with these shiny red ones!"
	icon_state = "redcuffs"

/obj/item/clothing/shoes/wraps/blue
	name = "blue leg wraps"
	desc = "Ankle coverings. Hang ten, brother."
	icon_state = "bluecuffs"

/obj/item/clothing/shoes/cowboyboots
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	name = "cowboy boots"
	desc = "A standard pair of brown cowboy boots."
	icon_state = "cowboyboots"

/obj/item/clothing/shoes/cowboyboots/black
	name = "black cowboy boots"
	desc = "A pair of black cowboy boots, pretty easy to scuff up."
	icon_state = "cowboyboots_black"

/obj/item/clothing/shoes/high_heels
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	name = "high heels"
	desc = "A fancy pair of high heels. Won't compensate for your below average height that much."
	icon_state = "heels"

/obj/item/clothing/shoes/discoshoes
	name = "green snakeskin shoes"
	desc = "They may have lost some of their lustre over the years, but these green crocodile leather shoes fit you perfectly."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "lizardskin_shoes"

/obj/item/clothing/shoes/kimshoes
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	name = "aerostatic boots"
	desc = "A brown pair of boots, prim and proper, ready to set off and get a body out of a tree."
	icon_state = "aerostatic_boots"


/obj/item/clothing/shoes/jungleboots
	name = "jungle boots"
	desc = "Take me to your paradise, I want to see the Jungle. A brown pair of boots."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "jungle"
	inhand_icon_state = "jackboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	strip_delay = 30
	equip_delay_other = 50
	resistance_flags = NONE
	permeability_coefficient = 0.05 //Thick soles, and covers the ankle
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	can_be_tied = TRUE //SKYRAT EDIT

/obj/item/clothing/shoes/jackboots/black
	name = "dark jackboots"
	desc = "Nanotrasen-issue Security combat boots for combat scenarios or combat situations. All combat, all the time. These are fully black."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "blackjack"

/obj/item/clothing/shoes/sports
	name = "sport shoes"
	desc = "Shoes for the sporty individual. The giants of Charlton play host to the titans of Ipswich - making them both seem normal sized."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "sportshoe"

/obj/item/clothing/shoes/jackboots/thigh
	name = "thigh boots"
	desc = "Black leather boots that go up to the thigh."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "thighboots"

/obj/item/clothing/shoes/jackboots/knee
	name = "knee boots"
	desc = "Black leather boots that go up to the knee."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "kneeboots"

/obj/item/clothing/shoes/jackboots/timbs
	name = "fashionable boots"
	desc = "Fresh from Luna, deadass good for rappers."
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "timbs"

/obj/item/clothing/shoes/winterboots/christmas
	name = "red christmas boots"
	desc = "A pair of fluffy red christmas boots!"
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "christmasbootsr"

/obj/item/clothing/shoes/winterboots/christmas/green
	name = "green christmas boots"
	desc = "A pair of fluffy green christmas boots!"
	icon = 'white/rebolution228/icons/unsorted/clothing/shoes.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/clothing/mob/feet.dmi'
	icon_state = "christmasbootsg"
