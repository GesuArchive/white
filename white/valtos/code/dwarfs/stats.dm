/atom/proc/calculate_smithing_stats(grade)
	return

/obj/item/pickaxe/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 8
			throwforce = 3
			toolspeed = 1.2
		if(2)
			force = 12
			throwforce = 5
			toolspeed = 1
		if(3)
			force = 13
			throwforce = 7
			toolspeed = 0.8
		if(4)
			force = 14
			throwforce = 8
			toolspeed = 0.6
		if(5)
			force = 15
			throwforce = 9
			toolspeed = 0.4
		if(6)
			force = 20
			throwforce = 10
			toolspeed = 0.2

/obj/item/blacksmith/katanus/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 10
			throwforce = 8
			block_chance = 3
		if(2)
			force = 15
			throwforce = 10
			block_chance = 7
		if(3)
			force = 20
			throwforce = 12
			block_chance = 15
		if(4)
			force = 25
			throwforce = 14
			block_chance = 20
		if(5)
			force = 30
			throwforce = 16
			block_chance = 25
		if(6)
			force = 35
			throwforce = 18
			block_chance = 30

/obj/item/blacksmith/zwei/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 15
			throwforce = 8
			block_chance = 2
		if(2)
			force = 20
			throwforce = 10
			block_chance = 3
		if(3)
			force = 25
			throwforce = 13
			block_chance = 4
		if(4)
			force = 30
			throwforce = 15
			block_chance = 6
		if(5)
			force = 40
			throwforce = 20
			block_chance = 7
		if(6)
			force = 50
			throwforce = 18
			block_chance = 10

/obj/item/blacksmith/cep/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 9
			throwforce = 8
			block_chance = 0
		if(2)
			force = 10
			throwforce = 10
			block_chance = 0
		if(3)
			force = 15
			throwforce = 15
			block_chance = 0
		if(4)
			force = 20
			throwforce = 20
			block_chance = 0
		if(5)
			force = 25
			throwforce = 25
			block_chance = 0
		if(6)
			force = 30
			throwforce = 30
			block_chance = 0

/obj/item/blacksmith/dagger/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 3
			throwforce = 2
			block_chance = 0
		if(2)
			force = 5
			throwforce = 3
			block_chance = 0
		if(3)
			force = 7
			throwforce = 5
			block_chance = 0
		if(4)
			force = 9
			throwforce = 7
			block_chance = 0
		if(5)
			force = 13
			throwforce = 8
			block_chance = 0
		if(6)
			force = 18
			throwforce = 10
			block_chance = 0

/obj/item/blacksmith/dwarfsord/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 15
			throwforce = 12
			block_chance = 0
		if(2)
			force = 17
			throwforce = 16
			block_chance = 5
		if(3)
			force = 23
			throwforce = 19
			block_chance = 10
		if(4)
			force = 28
			throwforce = 23
			block_chance = 15
		if(5)
			force = 35
			throwforce = 28
			block_chance = 20
		if(6)
			force = 40
			throwforce = 34
			block_chance = 25

/obj/item/clothing/suit/armor/light_plate/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(MELEE=20, BULLET=15, LASER=10, ENERGY=0, BOMB=15, BIO=0, RAD=0, FIRE=10, ACID=15, WOUND=30)
		if(2)
			armor = list(MELEE=25, BULLET=20, LASER=15, ENERGY=0, BOMB=20, BIO=0, RAD=0, FIRE=15, ACID=20, WOUND=35)
		if(3)
			armor = list(MELEE=30, BULLET=25, LASER=20, ENERGY=0, BOMB=25, BIO=0, RAD=0, FIRE=20, ACID=25, WOUND=40)
		if(4)
			armor = list(MELEE=35, BULLET=30, LASER=25, ENERGY=0, BOMB=30, BIO=0, RAD=0, FIRE=25, ACID=30, WOUND=45)
		if(5)
			armor = list(MELEE=40, BULLET=35, LASER=30, ENERGY=0, BOMB=35, BIO=0, RAD=0, FIRE=30, ACID=35, WOUND=50)
		if(6)
			armor = list(MELEE=45, BULLET=40, LASER=35, ENERGY=0, BOMB=40, BIO=0, RAD=0, FIRE=35, ACID=40, WOUND=55)

/obj/item/clothing/suit/armor/heavy_plate/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(MELEE=35, BULLET=30, LASER=15, ENERGY=10, BOMB=30, BIO=0, RAD=0, FIRE=20, ACID=20, WOUND=45)
		if(2)
			armor = list(MELEE=40, BULLET=35, LASER=20, ENERGY=15, BOMB=35, BIO=0, RAD=0, FIRE=25, ACID=25, WOUND=50)
		if(3)
			armor = list(MELEE=45, BULLET=40, LASER=25, ENERGY=20, BOMB=40, BIO=0, RAD=0, FIRE=30, ACID=30, WOUND=55)
		if(4)
			armor = list(MELEE=50, BULLET=45, LASER=30, ENERGY=25, BOMB=45, BIO=0, RAD=0, FIRE=35, ACID=35, WOUND=60)
		if(5)
			armor = list(MELEE=60, BULLET=60, LASER=40, ENERGY=35, BOMB=55, BIO=0, RAD=0, FIRE=45, ACID=45, WOUND=70)
		if(6)
			armor = list(MELEE=65, BULLET=65, LASER=45, ENERGY=40, BOMB=60, BIO=0, RAD=0, FIRE=50, ACID=50, WOUND=75)

/obj/item/clothing/under/chainmail/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(MELEE=10, BULLET=5, LASER=0, ENERGY=0, BOMB=5, BIO=0, RAD=0, FIRE=0, ACID=0, WOUND=20)
		if(2)
			armor = list(MELEE=15, BULLET=10, LASER=0, ENERGY=0, BOMB=10, BIO=0, RAD=0, FIRE=0, ACID=0, WOUND=25)
		if(3)
			armor = list(MELEE=20, BULLET=15, LASER=0, ENERGY=0, BOMB=15, BIO=0, RAD=0, FIRE=0, ACID=0, WOUND=30)
		if(4)
			armor = list(MELEE=25, BULLET=20, LASER=0, ENERGY=0, BOMB=20, BIO=0, RAD=0, FIRE=0, ACID=0, WOUND=35)
		if(5)
			armor = list(MELEE=35, BULLET=30, LASER=0, ENERGY=0, BOMB=35, BIO=0, RAD=0, FIRE=0, ACID=0, WOUND=45)
		if(6)
			armor = list(MELEE=40, BULLET=35, LASER=0, ENERGY=0, BOMB=40, BIO=0, RAD=0, FIRE=0, ACID=0, WOUND=50)

/obj/item/clothing/head/helmet/plate_helmet/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(MELEE=10, BULLET=20, LASER=6, ENERGY=0, BOMB=5, BIO=0, RAD=0, FIRE=6, ACID=6, WOUND=30)
		if(2)
			armor = list(MELEE=15, BULLET=25, LASER=9, ENERGY=0, BOMB=10, BIO=0, RAD=0, FIRE=9, ACID=9, WOUND=35)
		if(3)
			armor = list(MELEE=20, BULLET=30, LASER=12, ENERGY=0, BOMB=15, BIO=0, RAD=0, FIRE=12, ACID=12, WOUND=40)
		if(4)
			armor = list(MELEE=25, BULLET=35, LASER=15, ENERGY=0, BOMB=20, BIO=0, RAD=0, FIRE=15, ACID=15, WOUND=45)
		if(5)
			armor = list(MELEE=35, BULLET=45, LASER=25, ENERGY=0, BOMB=35, BIO=0, RAD=0, FIRE=25, ACID=25, WOUND=55)
		if(6)
			armor = list(MELEE=40, BULLET=50, LASER=30, ENERGY=0, BOMB=40, BIO=0, RAD=0, FIRE=30, ACID=30, WOUND=60)

/obj/item/clothing/gloves/plate_gloves/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(MELEE=10, BULLET=5, LASER=0, ENERGY=0, BOMB=5, BIO=0, RAD=0, FIRE=6, ACID=5, WOUND=5)
		if(2)
			armor = list(MELEE=15, BULLET=10, LASER=6, ENERGY=0, BOMB=7, BIO=0, RAD=0, FIRE=10, ACID=8, WOUND=10)
		if(3)
			armor = list(MELEE=20, BULLET=15, LASER=8, ENERGY=0, BOMB=10, BIO=0, RAD=0, FIRE=12, ACID=10, WOUND=14)
		if(4)
			armor = list(MELEE=25, BULLET=20, LASER=10, ENERGY=0, BOMB=13, BIO=0, RAD=0, FIRE=14, ACID=13, WOUND=18)
		if(5)
			armor = list(MELEE=35, BULLET=30, LASER=20, ENERGY=0, BOMB=20, BIO=0, RAD=0, FIRE=25, ACID=25, WOUND=35)
		if(6)
			armor = list(MELEE=40, BULLET=35, LASER=25, ENERGY=0, BOMB=25, BIO=0, RAD=0, FIRE=30, ACID=30, WOUND=40)

/obj/item/clothing/shoes/jackboots/plate_boots/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(MELEE=10, BULLET=5, LASER=0, ENERGY=0, BOMB=5, BIO=0, RAD=0, FIRE=0, ACID=0, WOUND=10)
		if(2)
			armor = list(MELEE=15, BULLET=10, LASER=4, ENERGY=0, BOMB=7, BIO=0, RAD=0, FIRE=5, ACID=5, WOUND=12)
		if(3)
			armor = list(MELEE=20, BULLET=15, LASER=6, ENERGY=0, BOMB=11, BIO=0, RAD=0, FIRE=10, ACID=10, WOUND=16)
		if(4)
			armor = list(MELEE=25, BULLET=20, LASER=10, ENERGY=0, BOMB=14, BIO=0, RAD=0, FIRE=15, ACID=15, WOUND=19)
		if(5)
			armor = list(MELEE=30, BULLET=25, LASER=12, ENERGY=0, BOMB=17, BIO=0, RAD=0, FIRE=20, ACID=20, WOUND=25)
		if(6)
			armor = list(MELEE=35, BULLET=30, LASER=15, ENERGY=0, BOMB=20, BIO=0, RAD=0, FIRE=25, ACID=25, WOUND=30)

/obj/item/clothing/head/helmet/dwarf_crown/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(MELEE=5, BULLET=5, LASER=5, ENERGY=0, BOMB=0, BIO=0, RAD=0, FIRE=10, ACID=10, WOUND=20)
		if(2)
			armor = list(MELEE=10, BULLET=10, LASER=10, ENERGY=0, BOMB=0, BIO=0, RAD=0, FIRE=20, ACID=20, WOUND=25)
		if(3)
			armor = list(MELEE=15, BULLET=15, LASER=15, ENERGY=0, BOMB=0, BIO=0, RAD=0, FIRE=30, ACID=30, WOUND=30)
		if(4)
			armor = list(MELEE=20, BULLET=20, LASER=20, ENERGY=0, BOMB=0, BIO=0, RAD=0, FIRE=40, ACID=40, WOUND=35)
		if(5)
			armor = list(MELEE=30, BULLET=30, LASER=30, ENERGY=0, BOMB=0, BIO=0, RAD=0, FIRE=80, ACID=80, WOUND=45)
		if(6)
			armor = list(MELEE=35, BULLET=35, LASER=35, ENERGY=0, BOMB=0, BIO=0, RAD=0, FIRE=100, ACID=100, WOUND=50)
