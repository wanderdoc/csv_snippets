#!usr/bin/perl
use strict;
use warnings FATAL => qw(all);

# Exercise from "Algorithms illuminated", implementation with help of Internet :-)













sub mergeSort
{
	my $arr = $_[0];
     if ( scalar @$arr <= 1 ) { return; }

     my @left = splice(@$arr, 0, @$arr/2);
     my @right = splice(@$arr);

     mergeSort(\@left);
     mergeSort(\@right);
     merge_2(\@left, \@right, $arr);
}

sub merge_2
{
     my ($left, $right, $aref) = @_;
     while ( @$left and @$right )
     {
          push  @$aref,
               $left->[0] <= $right->[0] ? shift @$left  : shift @$right;


      }
     push @$aref, @$left, @$right;
}

for my $test ( [12, 15, 23, 4 , 6, 10, 35, 28], [4, 6, 10, 12, 15, 23, 28, 35],
     [12, 15, 23, 4 , 6, 10, 35], [12], [12, 2],
     [12, 15, 23, 4 , 6, 10, 35, 28, 100, 130, 500, 1000, 235, 554, 75, 345, 800, 222, 333, 888, 444, 111, 666, 777, 60],
     [12, 12, 23, 4 , 6, 6, 10, -35, 28], [12, 12, 12, 12, 12], [], [reverse 1 .. 20])

{
     mergeSort($test);
     print join(" ", @$test), $/;
}
