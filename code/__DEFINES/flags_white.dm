#define PASSKEEPER		(1<<10)
#define PASSALL (PASSTABLE | PASSGLASS | PASSGRILLE | PASSBLOB | PASSMOB | PASSCLOSEDTURF | PASSMACHINE | PASSSTRUCTURE)


/////////////////////////////////////////////////////////////////////////////////////////////////вырезанное или измененное тгшниками

#define CULT_PERMITTED_1			(1<<5)

// This skillchip is incompatible with the Chameleon skillchip and cannot be copied.
// If you want to blacklist an abstract path such a /obj/item/skillchip/job then look at the blacklist in /datum/action/item_action/chameleon/change/skillchip
#define SKILLCHIP_CHAMELEON_INCOMPATIBLE (1<<2)
