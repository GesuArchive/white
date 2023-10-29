/// Number of paychecks jobs start with at the creation of a new bank account for a player (So at shift-start or game join, but not a blank new account.)
#define STARTING_PAYCHECKS 7
/// How much mail the Economy SS will create per minute, regardless of firing time.
#define MAX_MAIL_PER_MINUTE 3
/// Probability of using letters of envelope sprites on all letters.
#define FULL_CRATE_LETTER_ODDS 70

//Experimental change: These are subject to tweaking based on the /tg/ economy overhaul.
//Current design direction: Higher paying jobs are vastly outnumbered by lower paying jobs, so anything above medium hurts inflation, common jobs help inflation
#define PAYCHECK_PRISONER 50
#define PAYCHECK_ASSISTANT 100
#define PAYCHECK_MINIMAL 150
#define PAYCHECK_EASY 200
#define PAYCHECK_MEDIUM 300
#define PAYCHECK_HARD 500
#define PAYCHECK_COMMAND 700

#define STATION_TARGET_BUFFER 40

#define MAX_GRANT_DPT 50

//What should vending machines charge when you buy something in-department.
#define VENDING_DISCOUNT 0.1

#define ACCOUNT_STA "STA"
#define ACCOUNT_STA_NAME "Станционный бюджет"
#define ACCOUNT_CIV "CIV"
#define ACCOUNT_CIV_NAME "Гражданский бюджет"
#define ACCOUNT_ENG "ENG"
#define ACCOUNT_ENG_NAME "Инженерный бюджет"
#define ACCOUNT_SCI "SCI"
#define ACCOUNT_SCI_NAME "Научный бюджет"
#define ACCOUNT_MED "MED"
#define ACCOUNT_MED_NAME "Медицинский бюджет"
#define ACCOUNT_SRV "SRV"
#define ACCOUNT_SRV_NAME "Бюджет обслуживания"
#define ACCOUNT_CAR "CAR"
#define ACCOUNT_CAR_NAME "Бюджет снабжения"
#define ACCOUNT_SEC "SEC"
#define ACCOUNT_SEC_NAME "Оборонный бюджет"
#define ACCOUNT_TRA "TRA"
#define ACCOUNT_TRA_NAME "Торговый бюджет"

#define NO_FREEBIES "commies go home"

//Defines that set what kind of civilian bounties should be applied mid-round.
#define CIV_JOB_BASIC 1
#define CIV_JOB_ROBO 2
#define CIV_JOB_CHEF 3
#define CIV_JOB_SEC 4
#define CIV_JOB_DRINK 5
#define CIV_JOB_CHEM 6
#define CIV_JOB_VIRO 7
#define CIV_JOB_SCI 8
#define CIV_JOB_ENG 9
#define CIV_JOB_MINE 10
#define CIV_JOB_MED 11
#define CIV_JOB_GROW 12
#define CIV_JOB_RANDOM 13

//These defines are to be used to with the payment component, determines which lines will be used during a transaction. If in doubt, go with clinical.
#define PAYMENT_CLINICAL "clinical"
#define PAYMENT_FRIENDLY "friendly"
#define PAYMENT_ANGRY "angry"
