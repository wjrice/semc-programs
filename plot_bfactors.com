#! /bin/csh -f
if ($# != 2) then 
 echo 'Usage:    ' $0 ' bfactors.star bfactors.plt'
 echo ' Where bfactors.star is the output Relion file which has the fitted B-factors (4 times the slope of the fitted line through ' 
 echo ' the relative Guinier plot) and intercepts for each movie frame.'
 echo 'bfactors.plt is the output file with only the data from this.'
 echo 'To make a plot in gnuplot, use command "plot bfactors.plt using 1:2"
else
 
   perl -lane " print  @F[0], ' ', @F[1], ' ', @F[2] if (@F[2]) " $1 > $2
   echo "done!"
endif

 
