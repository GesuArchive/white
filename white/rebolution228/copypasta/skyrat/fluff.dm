/* ----- Metal Poles (These shouldn't be in this file but there's not a better place tbh) -----*/
//Just a re-done Tram Rail, but with all 4 directions instead of being stuck east/west - more varied placement, and a more vague name. Good for mapping support beams/antennae/etc
/obj/structure/fluff/metalpole
	icon = 'white/rebolution228/icons/unsorted/fluff.dmi'
	name = "metal pole"
	desc = "A metal pole, the likes of which are commonly used as an antennae, structural support, or simply to maneuver in zero-g."
	icon_state = "pole"
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	deconstructible = TRUE

/obj/structure/fluff/metalpole/end
	icon_state = "poleend"

/obj/structure/fluff/metalpole/end/left
	icon_state = "poleend_left"

/obj/structure/fluff/metalpole/end/right
	icon_state = "poleend_right"

/obj/structure/fluff/metalpole/anchor
	name = "metal pole anchor"
	icon_state = "poleanchor"


///////////////////////////////////////////
/////////////    FURNITURE    /////////////
/obj/structure/decorative/shelf
	name = "shelf"
	desc = "A sturdy wooden shelf to store a variety of items on."
	icon = 'white/rebolution228/icons/unsorted/furniture.dmi'
	icon_state = "empty_shelf_1"
	density = 0

/obj/structure/decorative/shelf/crates
	desc = "A sturdy wooden shelf with a bunch of crates on it."
	icon_state = "shelf_1"

/obj/structure/decorative/shelf/milkjugs
	desc = "A sturdy wooden shelf with a jugs and cartons of skimmed, semi-skimmed and full fat milk."
	icon_state = "shelf_2"

/obj/structure/decorative/shelf/alcohol
	desc = "A sturdy wooden shelf with a bunch of probably alcoholic drinks on it."
	icon_state = "shelf_3"

/obj/structure/decorative/shelf/soda
	desc = "A sturdy wooden shelf with a bunch of soft drinks on it. This planet's version of coca cola?"
	icon_state = "shelf_4"

/obj/structure/decorative/shelf/soda_multipacks
	desc = "A sturdy wooden shelf with a bunch of multipack soft drinks."
	icon_state = "shelf_5"

/obj/structure/decorative/shelf/crates1
	desc = "A sturdy wooden shelf with a bunch of crates on it. How... generic?"
	icon_state = "shelf_6"

/obj/structure/decorative/shelf/soda_milk
	desc = "A sturdy wooden shelf with an assortment of boxes. Multipack soft drinks and some milk."
	icon_state = "shelf_7"

/obj/structure/decorative/shelf/milk
	desc = "A sturdy wooden shelf with a variety of small milk cartons. Great for those who live alone!"
	icon_state = "shelf_8"

/obj/structure/decorative/shelf/milk_big
	desc = "A sturdy wooden shelf with lots of larger milk cartons."
	icon_state = "shelf_9"

/obj/structure/decorative/shelf/alcohol_small
	desc = "A sturdy wooden shelf with lots of alcohol."
	icon_state = "shelf_10"

/obj/structure/decorative/shelf/alcohol_assortment
	desc = "A sturdy wooden shelf with a variety of branded alcoholic drinks."
	icon_state = "shelf_11"
