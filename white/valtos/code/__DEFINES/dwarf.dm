#define DWARF_ALCOHOL_RATE 0.1 // The normal rate is 0.005. For 100 units of the strongest alcohol possible (boozepwr = 100), you'd have 10*100*0.005 = 5, which is too small as a value to operate with.
								// With 0.1, 100 units of the strongest alcohol would refill you completely from 0 to 100, which is perfect.
#define DRUNK_ALERT_TIME_OFFSET 10 SECONDS
