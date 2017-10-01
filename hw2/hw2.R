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
