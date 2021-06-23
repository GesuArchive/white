// Положительные награды
#define METACOIN_GREENTEXT_REWARD        55 // за гринтекст
#define METACOIN_ART_REWARD           	 25 // за картину
#define METACOIN_ESCAPE_REWARD           15 // за побег со станции
#define METACOIN_SURVIVE_REWARD          9  // за выживание в раунде
#define METACOIN_NOTSURVIVE_REWARD       5  // за смерть, если дождался конца раунда
#define METACOIN_TENMINUTELIVING_REWARD  1  // за каждые 10 минут жизни

// Награды за заказы в гражданском терминале заказов
#define METACOIN_BOUNTY_REWARD_HARD		 rand(10, 15)  	// за сложный выполненный заказ
#define METACOIN_BOUNTY_REWARD_NORMAL	 rand(5, 10)  	// за обычный выполненный заказ
#define METACOIN_BOUNTY_REWARD_EASY		 rand(1, 5)		// за лёгкий выполненный заказ

// Отрицательные награды
#define METACOIN_TEETH_REWARD      		-10 // потеря зубика
#define METACOIN_SUCC_REWARD      		-10 // сдался
#define METACOIN_BADWORDS_REWARD        -50 // сказал плохое слово
#define METACOIN_SUPERDEATH_REWARD      -20 // смерть от суперматерии
#define METACOIN_CHASM_REWARD 			-20 // падение в пропасть
#define METACOIN_DNR_REWARD      		-30 // разорвал связь с телом
#define METACOIN_GHOSTIZE_REWARD      	-47 // покинул тело
#define METACOIN_SUICIDE_REWARD      	-50 // суицид
