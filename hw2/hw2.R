library(rkdb)
h1<-open_connection('172.19.10.167',6005)
h2<-open_connection('172.19.10.167',7005)

# Problem 1
# See what instruments are in different classes
execute(h1, 'select inst by class from instinfo')
# Class:Inst picked
tline=seq(-7,16,0.25)
# AG: ZW
zw<-execute(h2, "{[bd;ed;inst;minintvl] select v from 0^(([] tbin:distinct minintvl xbar (-7:00 + til 1381)) lj select last v by tbin from update v:v%(ed-bd) from select v:sum siz by tbin from update tbin:minintvl xbar rcvtime.minute from select from trade where date within (bd;ed), sym2inst[sym]=inst)} [2017.07.31;2017.09.01;`ZW;15]")
plot(tline,zw$v/1000, xlab='', ylab='Thousands of lots in 15 minutes',main='Wheat (ZW) 2017-07-31 to 2017-09-01',axes=FALSE,type='o',pch=0)
axis(1,at=seq(-6,16,2))
axis(2)
abline(h=0)
# EN: CL
cl<-execute(h2, "{[bd;ed;inst;minintvl] select v from 0^(([] tbin:distinct minintvl xbar (-7:00 + til 1381)) lj select last v by tbin from update v:v%(ed-bd) from select v:sum siz by tbin from update tbin:minintvl xbar rcvtime.minute from select from trade where date within (bd;ed), sym2inst[sym]=inst)} [2017.07.31;2017.09.01;`CL;15]")
plot(tline,cl$v/1000, xlab='', ylab='Thousands of lots in 15 minutes',main='Crude Oil (CL) 2017-07-31 to 2017-09-01',axes=FALSE,type='o',pch=0)
axis(1,at=seq(-6,16,2))
axis(2)
abline(h=0)
# EQ: NQ
nq<-execute(h2, "{[bd;ed;inst;minintvl] select v from 0^(([] tbin:distinct minintvl xbar (-7:00 + til 1381)) lj select last v by tbin from update v:v%(ed-bd) from select v:sum siz by tbin from update tbin:minintvl xbar rcvtime.minute from select from trade where date within (bd;ed), sym2inst[sym]=inst)} [2017.07.31;2017.09.01;`NQ;15]")
plot(tline,nq$v/1000, xlab='', ylab='Thousands of lots in 15 minutes',main='E-mini NASDAQ 100 (NQ) 2017-07-31 to 2017-09-01',axes=FALSE,type='o',pch=0)
axis(1,at=seq(-6,16,2))
axis(2)
abline(h=0)
# FX: 6B
b6<-execute(h2, "{[bd;ed;inst;minintvl] select v from 0^(([] tbin:distinct minintvl xbar (-7:00 + til 1381)) lj select last v by tbin from update v:v%(ed-bd) from select v:sum siz by tbin from update tbin:minintvl xbar rcvtime.minute from select from trade where date within (bd;ed), sym2inst[sym]=inst)} [2017.07.31;2017.09.01;`6B;15]")
plot(tline,b6$v/1000, xlab='', ylab='Thousands of lots in 15 minutes',main='British Pound (6B) 2017-07-31 to 2017-09-01',axes=FALSE,type='o',pch=0)
axis(1,at=seq(-6,16,2))
axis(2)
abline(h=0)
# IR: ZB
zb<-execute(h1, "{[bd;ed;inst;minintvl] select v from 0^(([] tbin:distinct minintvl xbar (-7:00 + til 1381)) lj select last v by tbin from update v:v%(ed-bd) from select v:sum siz by tbin from update tbin:minintvl xbar rcvtime.minute from select from trade where date within (bd;ed), sym2inst[sym]=inst)} [2017.07.31;2017.09.01;`ZB;15]")
plot(tline,zb$v/1000, xlab='', ylab='Thousands of lots in 15 minutes',main='US Treaury (ZB) 2017-07-31 to 2017-09-01',axes=FALSE,type='o',pch=0)
axis(1,at=seq(-6,16,2))
axis(2)
abline(h=0)
# MT: GC
gc<-execute(h2, "{[bd;ed;inst;minintvl] select v from 0^(([] tbin:distinct minintvl xbar (-7:00 + til 1381)) lj select last v by tbin from update v:v%(ed-bd) from select v:sum siz by tbin from update tbin:minintvl xbar rcvtime.minute from select from trade where date within (bd;ed), sym2inst[sym]=inst)} [2017.07.31;2017.09.01;`GC;15]")
plot(tline,gc$v/1000, xlab='', ylab='Thousands of lots in 15 minutes',main='GOLD (GC) 2017-07-31 to 2017-09-01',axes=FALSE,type='o',pch=0)
axis(1,at=seq(-6,16,2))
axis(2)
abline(h=0)
# The causes for spikes at mornings before noon and afternoon before closes are traders trade heavily on these contracts
# NQ equity contract has a regular U shape during the day
# CL crude oil also has a U shape
# GC are heavily traded during the day
# ZB treasury bond also has a distinct U shape
# ZW wheat contracts are heavily traded in the mroning and afternoon when agricultural news come out

# Problem 2
# Part (a)
ge_expir<-execute(h1, "{[bd;ed;inst] select m2expir, prct:(v%sum(v))*100 from select v:sum siz by m2expir from update m2expir:(sym2expir[sym]-min(sym2expir[sym])) from select from trade where date within (bd;ed), sym2inst[sym]=inst}[2017.07.31;2017.09.01;`GE]")
plot(ge_expir$m2expir,ge_expir$prct,xlab='Months to expiration',ylab='Percent of total volume',main='Eurodollar (GE) 2017-07-31 to 2017-09-01',type='o',axes=FALSE)
axis(1)
axis(2)
abline(h=0)

# Part (b) # Entropy
# Extreme Case 1: Only a single p = 1 and all others zero
p1<-1
w<-(-p1*log(p1))
n_eff<-exp(w)
n_eff
# In this case, the effective entropy number is 1, which is not spread out distribution at all. 
# Extreme Case 2: All pj=1/N. For simplicity, we will use N=4 to demostrate
N<-4
pvec<-numeric(N)
pvec<-c(1/N,1/N,1/N,1/N)
w<-sum(-pvec*log(pvec))
n_eff<-exp(w)
n_eff
# In this case, the effective entropy number is 4(N), which is very spread out distribution. 
# Find the 2 most actively traded interest rate instruments and 5 most actively traded non-interest rate instruments
execute(h1,"{[bd;ed] 3 # `volume xdesc select volume:sum siz by inst from update inst:sym2inst[sym] from select from trade where date within (bd;ed)}[2017.07.31;2017.09.01]")
# The two most actively traded interest rate instruments are ZN (10 yr note) and GE.
execute(h2, "{[bd;ed] 6 # `volume xdesc select volume:sum siz by inst from update inst:sym2inst[sym] from select from trade where date within (bd;ed)}[2017.07.31;2017.09.01]")
# The five most actively traded non-interest rate instruments are ES, CL, NQ, GC, and 6E(Euro FX)

# A function to compute effective entropy number given a vector of distribution
# Input: vec: a vector of distribution
# Output: the effetive tntropy number of the distribution
enp<-function(vec)
{
  w<-sum(-vec*log(vec))
  enp<-exp(w)
  return(enp)
}

# compute the effetive entropy number for ZN
znv<-execute(h1, "{[bd;ed;inst] select m2expir, prct:v%sum(v) from select v:sum siz by m2expir from update m2expir:(sym2expir[sym]-min(sym2expir[sym])) from select from trade where date within (bd;ed), sym2inst[sym]=inst}[2017.07.31;2017.09.01;`ZN]")
enp_zn<-enp(znv$prct)
enp_zn
# The effective entropy number of ZN distribution is 1.542818
# compute the effetive entropy number for GE
gev<-execute(h1, "{[bd;ed;inst] select m2expir, prct:v%sum(v) from select v:sum siz by m2expir from update m2expir:(sym2expir[sym]-min(sym2expir[sym])) from select from trade where date within (bd;ed), sym2inst[sym]=inst}[2017.07.31;2017.09.01;`GE]")
enp_ge<-enp(gev$prct)
enp_ge
# The effective entropy number of GE distribution is 16.00225
# compute the effetive entropy number for ES
esv<-execute(h2, "{[bd;ed;inst] select m2expir, prct:v%sum(v) from select v:sum siz by m2expir from update m2expir:(sym2expir[sym]-min(sym2expir[sym])) from select from trade where date within (bd;ed), sym2inst[sym]=inst}[2017.07.31;2017.09.01;`ES]")
enp_es<-enp(esv$prct) 
enp_es
# The effective entropy number of ES distribution is 1.023106
# compute the effetive entropy number for CL
clv<-execute(h2, "{[bd;ed;inst] select m2expir, prct:v%sum(v) from select v:sum siz by m2expir from update m2expir:(sym2expir[sym]-min(sym2expir[sym])) from select from trade where date within (bd;ed), sym2inst[sym]=inst}[2017.07.31;2017.09.01;`CL]")
enp_cl<-enp(clv$prct)
enp_cl
# The effective entropy number of CL distribution is 2.783646
# compute the effetive entropy number for NQ
nqv<-execute(h2, "{[bd;ed;inst] select m2expir, prct:v%sum(v) from select v:sum siz by m2expir from update m2expir:(sym2expir[sym]-min(sym2expir[sym])) from select from trade where date within (bd;ed), sym2inst[sym]=inst}[2017.07.31;2017.09.01;`NQ]")
enp_nq<-enp(nqv$prct)
enp_nq
# The effective entropy number of NQ distribution is 1,027616
# compute the effetive entropy number for GC
gcv<-execute(h2, "{[bd;ed;inst] select m2expir, prct:v%sum(v) from select v:sum siz by m2expir from update m2expir:(sym2expir[sym]-min(sym2expir[sym])) from select from trade where date within (bd;ed), sym2inst[sym]=inst}[2017.07.31;2017.09.01;`GC]")
enp_gc<-enp(gcv$prct)
enp_gc
# The effective entropy number of GC distribution is 1.138405
# compute the effetive entropy number for 6E
e6v<-execute(h2, "{[bd;ed;inst] select m2expir, prct:v%sum(v) from select v:sum siz by m2expir from update m2expir:(sym2expir[sym]-min(sym2expir[sym])) from select from trade where date within (bd;ed), sym2inst[sym]=inst}[2017.07.31;2017.09.01;`6E]")
enp_e6<-enp(e6v$prct)
enp_e6
# The effective entropy number of 6E distribution is 1.109962
# IR products: The GE(Eurodollars) has 16 a large effective entropy number: more than a few maturities are active at one time. 
# Non-IR products: The CL(crude oil) has 2.78 effective entropy number: more than 20 maturities are active at one time

# Problem 3


