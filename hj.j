j      =. (]/. i.@#) ,{;~3#i.3
,{;~3#i.3
r      =. 9#i.9 9
c      =. 81$|:i.9 9
b      =. (,j{9#i.9) { j

I      =: ~."1 r,.c,.b
R      =: j,(,|:)i.9 9

regions=: R {"_ 1 ]
free   =: 0&= > (1+i.9) e."1 I&{
ok     =: (27 9$1) -:"2 (0&= +. ~:"1)@regions

ac     =: +/ .*&(1+i.9) * 1 = +/"1

ar     =: 3 : 0
 m=. 1=+/"2 R{y
 j=. I. +./"1 m
 k=. 1 i."1~ j{m
 i=. ,(k{"_1 |:"2 (j{R){y) #"1 j{R
 (1+k) i}81$0
)

assign =: (+ (ac >. ar)@free)^:_"1

guessa =: 3 : 0
 if. -. 0 e. y do. ,:y return. end.
 b=. free y
 i=. (i.<./) (+/"1 b){10,}.i.10
 y +"1 (1+I.i{b)*/i=i.81
)

NB. guess  =: ; @: (<@guessa"1)
NB. sudoku =: guess @: (ok # ]) @: assign ^:_ @ ,
NB. 
NB. see1   =: (;~9$1 0 0)&(<;.1) @ ({&'.123456789') @ (9 9&$) @ ,
NB. see    =: <@see1"1`see1@.(1:=#@$)
NB. diff   =: * 0&=@}:@(0&,)
