
#program preference.

required(P,aso) :- preference(P,aso), required(P,_).
preference(P,aso,Id) :- preference(P,aso), required(P,aso), preference(P,Id,_,_,_).

nohead(P,Id) :- preference(P,aso,Id), 
                not holds(X) : preference(P,Id,H,lit(t,X),_), H!=0;
                holds(X)     : preference(P,Id,H,lit(f,X),_), H!=0.

nohead'(P,Id) :- preference(P,aso,Id), 
                 not holds'(X) : preference(P,Id,H,lit(t,X),_), H!=0;
                 holds'(X)     : preference(P,Id,H,lit(f,X),_), H!=0.

value'(P,Id,V) :- preference(P,aso,Id),
                  V = #min { 1   : not holds'(X), preference(P,Id,0,lit(t,X),_);
                             1   : holds'(X), preference(P,Id,0,lit(f,X),_);
                             1   : nohead'(P,Id);
                             Pos : holds'(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                             Pos : not holds'(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.
 
preferred(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,preferred), 
                   V > #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                              1   : holds(X), preference(P,Id,0,lit(f,X),_);
                              1   : nohead(P,Id);
                              Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                              Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.
 
preferredeq(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,preferredeq),
                     V >= #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                                 1   : holds(X), preference(P,Id,0,lit(f,X),_);
                                 1   : nohead(P,Id);
                                 Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                                 Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.

required(P,aso,preferred)   :- preference(P,aso), required(P,preferred).                             
required(P,aso,preferredeq) :- preference(P,aso), required(P,preferred).                             
preferred(P) :- preference(P,aso), required(P,preferred),
                preferredeq(P,Id1) : preference(P,aso,Id1);
                preferred(P,Id2), preference(P,aso,Id2).

required(P,aso,preferredeq) :- preference(P,aso), required(P,preferredeq).                            
preferredeq(P) :- preference(P,aso), required(P,preferredeq),
                  preferredeq(P,Id) : preference(P,aso,Id).

              
eq(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,eq),
            V = #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                       1   : holds(X), preference(P,Id,0,lit(f,X),_);
                       1   : nohead(P,Id);
                       Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                       Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.
 
worseeq(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,worseeq),
                 V <= #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                             1   : holds(X), preference(P,Id,0,lit(f,X),_);
                             1   : nohead(P,Id);
                             Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                             Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.
 
worse(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,worse),
               V < #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                          1   : holds(X), preference(P,Id,0,lit(f,X),_);
                          1   : nohead(P,Id);
                          Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                          Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.

required(P,aso,eq) :- preference(P,aso), required(P,eq).                             
eq(P) :- preference(P,aso), required(P,eq),
         eq(P,Id) : preference(P,aso,Id).

required(P,aso,worseeq) :- preference(P,aso), required(P,worseeq).                             
worseeq(P) :- preference(P,aso), required(P,worseeq),
              worseeq(P,Id) : preference(P,aso,Id).

required(P,aso,worseeq) :- preference(P,aso), required(P,worse).                             
required(P,aso,worse)   :- preference(P,aso), required(P,worse).                             
worse(P) :- preference(P,aso), required(P,worse),
            worseeq(P,Id1) : preference(P,aso,Id1);
            worse(P,Id2); preference(P,aso,Id2).

required(P,preferredeq) :- preference(P,aso), required(P,unc). 
required(P,worseeq)     :- preference(P,aso), required(P,unc). 
unc(P) :- preference(P,aso); required(P,unc); 
          not preferredeq(P); not worseeq(P).
