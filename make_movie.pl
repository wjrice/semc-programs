#! /usr/bin/perl -w

my $framerate=24;
#my $output= "movie.avi";
my $output= `pwd`;
chomp $output;
my @data = split (/\//,$output);
$output = pop @data  ;
$output .= '.avi';

print "Enter desired framerate (Default $framerate): ";
chomp ($line = <STDIN>);
if ($line) {$framerate=$line;}
print "Enter output filename (default $output): ";
chomp ($line = <STDIN>);
if ($line) {$output=$line;}

`jpeg2yuv -f $framerate -I p -L 0 -j zap%03d.jpg | yuv2lav -f a -b 1024 -o $output`;

print "Finished making movie $output\n";

