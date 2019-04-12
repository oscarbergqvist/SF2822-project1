****************************************************************************
*
* Nonlinear programming example 2.
*
* Make sure that you understand the input and the output. In particular,
* make sure that you understand the sensitivity analysis provided by
* "level" and "marginal"
*
* What kind of point do you find?
*
* This is just for illustration. GAMS is not the ideal modeling tool for
* this small problem.
*
* GAMS model written by Anders Forsgren.
*
****************************************************************************

sets
        j dimension     / j1*j3 /;

variables
        obj2    objective function value
        y(j)    decision variables;

equations
        objfun2         objective function
        cons2           constraints;

y

objfun2 .. sum(j,exp(2*y(j))) =l= obj2;
cons2   .. sum(j,y(j)) =e= 0;

model nlpex2 / all /;

solve nlpex2 using nlp minimizing obj2;

