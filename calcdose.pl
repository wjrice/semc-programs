#! /usr/bin/perl -w
print "Enter tose in e/A**2: ";
chomp ($dose=<STDIN>);
print "Enter pixel size (A/pix): ";
chomp ($apix=<STDIN>);

$epp = $dose * $apix * $apix;

printf ("electrons per pixel = %.2f\n",$epp);

