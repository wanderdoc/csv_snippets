#!usr/bin/perl
use strict;
use warnings FATAL => qw(all);















sub mergeSort_with_count
{
	my $arr = $_[0]; my $inv_count = 0; # new
     if ( scalar @$arr <= 1 ) { return 0; } # instead of just return.

     my @left = splice(@$arr, 0, @$arr/2);
     my @right = splice(@$arr);

     $inv_count += mergeSort_with_count(\@left);
     $inv_count += mergeSort_with_count(\@right);
     $inv_count += merge_2(\@left, \@right, $arr);
}

sub merge_2
{
     my ($left, $right, $aref) = @_; my $ic = 0; # new
     while ( @$left and @$right ) # not just push but also count
     {
         if ( $left->[0] <= $right->[0] ) { push @$aref, shift @$left; }
         else { push @$aref, shift @$right; $ic += scalar @$left; }
     

      }
     push @$aref, @$left, @$right;
     return $ic; # new

}






for my $test ( [12, 15, 23, 4 , 6, 10, 35, 28], [4, 6, 10, 12, 15, 23, 28, 35],
     [12, 15, 23, 4 , 6, 10, 35], [12], [12, 2],
     
     [12, 15, 23, 4 , 6, 10, 35, 28, 100, 130, 500, 1000, 235, 554, 75, 345, 800, 222, 333, 888, 444, 111, 666, 777, 60],
     [12, 12, 23, 4 , 6, 6, 10, -35, 28], [12, 12, 12, 12, 12], [], [reverse 1 .. 20])
{

     print join(" ", @$test), $/;
     my $ic = mergeSort_with_count($test);
     print join(" ", @$test), $/;
     print "Inversions: $ic$/";
}
