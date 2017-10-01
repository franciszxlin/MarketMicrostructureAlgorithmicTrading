library(rkdb)
h1<-open_connection('172.19.10.167',6005)
h2<-open_connection('172.19.10.167',7005)
# Problem 1 

# Part (a)
execute(h1,'select name from instinfo where inst like "PA"')
# The product whose instrument code is PA is Palladium contract
execute(h1,'select name from instinfo where inst like "ZC"')
# The product whose instrument code is ZC is Corn contract

# Part (b)
execute(h1,'select from instinfo where inst like "RB"')
execute(h1,'select contractPrc:15875*notional from instinfo where inst like "RB"')
# The actual contract price is 66675$
execute(h1,'select realPrc:15875*dispfactor from instinfo where inst like "RB"')
# The price for gasoline in dollars per gallon is 1.5875$/gallon

# Part (c)
execute(h1, 'select dailyMargin:(15876-15875)*notional from instinfo where inst like "RB"')
# The clearing house will deposit $4.2 in your account

# Problem 2
execute(h1, '(update inst:sym2inst[sym] from 5 # `volume xdesc select volume:sum siz by sym from trade where date=2017.08.18) lj select name by inst from instinfo')
# The 5 most actively traded interest rates products on August 18, 2017 are 10 Yr Note, 5 Yr Note, U.S. Treasury Bond, 2 Yr Note, Eurodollar contracts
execute(h2, '(update inst:sym2inst[sym] from 5 # `volume xdesc select volume:sum siz by sym from trade where date=2017.08.18) lj select name by inst from instinfo')
# The 5 most actively traded non-interest rate products on the same date are E-mini S&P 500, Crude Oil, E-mini NASDAQ 100, Gold, Japanese Yen contracts

# Problem 3
znu7_daily_volume=execute(h1, 'select Volume:sum siz by date from trade where sym=`ZNU7')
plot(znu7_daily_volume$date, znu7_daily_volume$Volume/10^6, xlab='Figure 1:Traded volume for ZNU7 in August 2017',ylab="Trade Volume (millions of lots)",type='o')
