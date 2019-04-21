$funclibin stolib stodclib
Functions cdf /stolib.cdfnormal/
          pdf /stolib.pdfnormal/;


SET i 'weeks' /i1*i3/;

PARAMETERS
d(i) 'demand of prod b'
    /i1 30
     i2 130
     i3 130/;

VARIABLES
    x1(i)       'crude oil 1 to crude converter'
    x2(i)       'crude oil 2 to crude converter'
    za(i)       'prod a from crude converter'
    zb(i)       'prod b from crude converter'
    zc(i)       'prod c from crude converter'
    u1(i)       'split from prod b to final product'
    u2(i)       'split from prod b to reconverter'
    va(i)       'prod a from reconverter'
    vb(i)       'prod b from reconverter'
    pa(i)       'final product a'
    pb(i)       'final product b'
    splus(i)    'excess over demand for prod b (to store)'
    sminus(i)   'shortage of prod b'
    z           'total expected cost' ;

POSITIVE VARIABLES x1, x2, za, zb, zc, u1, u2, va, vb, pa, pb, splus, sminus;

EQUATIONS
    objfun          'objective function'
    supply(i)       'supply of crude oil two'
    capacityZ(i)    'capacity of crude converter'
    yieldZA(i)      'yield from crude converter to prod a'
    yieldZB(i)      'yield from crude converter to prod b'
    yieldZC(i)      'yield from crude converter to prod c'
    usplit(i)       'split of prod b to final product and reconverter'  
    capacityV(i)    'capacity of reconverter'
    yieldVA(i)      'yield from reconverter to prod a'
    yieldVB(i)      'yield from reconverter to prod b'
    demandPA(i)     'demand of product pa'
    demandPB(i)     'demand of product pb'
    maxsaleB(i)     'we have to sell less then what we produce'
    excessB(i)      'surplus of product b after sales';


    objfun          ..  z =e= sum(i, 80000*pdf(x1(i), 300, 20) + 500*x1(i)
                                     + (200*x1(i) - 60000)*cdf(x1(i), 300, 20)) +
                              sum(i, 600*x2(i) + 100*(x1(i)+x2(i)) + 80*(zc(i)+u2(i)) + 20*splus(i)
                                     - 1000*pa(i) - 740*pb(i));
    supply(i)       ..  x2(i) =l= 300;
    capacityZ(i)    ..  x1(i) + x2(i) =l= 500;
    yieldZA(i)      ..  0.5*x1(i) + 0.7*x2(i) =e= za(i);
    yieldZB(i)      ..  splus(i-1) + 0.3*x1(i) + 0.2*x2(i) =e= zb(i);
    yieldZC(i)      ..  0.2*x1(i) + 0.1*x2(i) =e= zc(i);
    usplit(i)       ..  u1(i) + u2(i) =e= zb(i);
    capacityV(i)    ..  zc(i) + u2(i) =l= 300;
    yieldVA(i)      ..  0.9*u2(i) + 0.4*zc(i) =e= va(i);
    yieldVB(i)      ..  0.1*u2(i) + 0.6*zc(i) =e= vb(i);
    demandPA(i)     ..  pa(i) =l= 250;
    demandPB(i)     ..  pb(i) =l= d(i);
    maxsaleB(i)     ..  u1(i) + vb(i) =g= pb(i);
    excessB(i)      ..  u1(i) + vb(i) - d(i) =e= splus(i) - sminus(i);

MODEL   oilconverter /all/;
OPTION  nlp = lindo;
SOLVE   oilconverter using nlp minimizing z;