10 print chr$(147);
20 print "     +----------------------------+"
30 print "     !    a development system    !"
40 print "     ! (c)2020 ir. marc dendooven !"
50 print "     !        version 0.0.1       !"
60 print "     +----------------------------+"
70 print
90 print "type 'bye' to exit"

100 rem *** system parameters ***
110 ds=100: rem dictionary size
120 ps=49152: rem start of program space ($c000)

189 rem *** initialisation ***
190 dim dk$(ds-1),dv(ds-1):dp=0: rem dictionary and pointer

299 rem *** the repl ***
300 input li$
310 gosub 500
320 print ms$
330 goto 300

499 rem *** evaluate line ***
500 if li$="" then return
510 gosub 5500: rem get first word
520 gosub 1000: rem interpret word
530 goto 500

999 rem *** interpreter ***
1000 ms$="ok"
1005 rem * search backwards in directory first *
1010 if dp=0 then 1050
1020 for i = dp-1 to 0 step -1
1030 if w$=dk$(i) then print"demo: execute ";w$;" @";dv(i):sys dv(i):return
1040 next i
1045 rem * else look in basic list *
1050 if w$="bye" then end
1060 if w$="help" then print "no help yet":return
1070 if w$="hi" then print "nice to meet you":return
1080 if w$="_" then gosub 5500:gosub 5000:goto 3000
1090 ms$=w$+": undefined word": li$=""
1100 return

2999 rem *** evaluate compiler line ***
3000 if li$="" then return
3010 gosub 5500: rem get first word
3020 gosub 3100: rem interpret word
3030 goto 3000

3099 rem *** compiler *** 
3100 rem gosub 5000 <- fout... entry wordt telkens aangemaakt !
3110 print "compiling"
3120 rem * search backwards in directory first *
3130 if dp=0 then 3200
3140 for i = dp-1 to 0 step -1
3150 if w$=dk$(i) then 3400 
3160 next i
3200 if w$="mc$" then gosub 5500: goto 6000
3210 if w$=";" then print ps,96:poke ps,96:ps=ps+1:li$="":return
3300 ms$=w$+": undefined word when compiling": li$=""
3310 return
3399 rem * jsr to dictionary word *
3400 poke ps,32
3410 hi = int(dv(i)/256): poke ps+2,hi
3420 lo = dv(i)-256*hi: poke ps+1,lo
3425 print ps, 32;lo;hi
3430 ps=ps+3
3440 return

4995 rem *** help routines ***

4999 rem *** create a dictionary entry ***
5000 if dp >= ds then ms$="dictionary full":li$="":return
5010 dk$(dp)=w$:dv(dp)=ps:dp=dp+1
5020 return

5499 rem *** split word from line ***
5500 if li$="" then ms$="no word":return
5510 w$ = "" : rem reverse with previous line ?
5515 l=len(li$)
5520 for i = 1 to l
5530 c$ = mid$(li$,i,1)
5540 if c$<>" " then w$=w$+c$: next i
5545 rem * delete spaces *
5550 for i = i to l
5560 if mid$(li$,i,1)=" " then next i
5570 li$=right$(li$,l-i+1)
5580 return

5999 rem *** parse mc$ ***
6000 l=len(w$)
6005 if l=1 then print"warning:odd digit ignored"
6010 if l<2 then return
6020 h$=left$(w$,1):w$=right$(w$,l-1)
6030 gosub 6200:hh=h
6040 h$=left$(w$,1):w$=right$(w$,l-2)
6050 gosub 6200:h=hh*16+h:print ps,h:poke ps,h:ps=ps+1
6060 goto 6000

6199 rem *** hex digit h$ -> dec h ***
6200 if h$>="0" and h$<="9" then h=asc(h$)-asc("0"):return
6210 if h$>="a" and h$<="f" then h=asc(h$)-asc("a")+10:return
6220 print"warning: non hex digit compiled"
6230 return

