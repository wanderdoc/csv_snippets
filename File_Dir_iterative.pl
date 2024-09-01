#!perl
use strict;
use warnings FATAL => qw(all);

=intention
Iterative without File::Find
=cut







use FindBin qw($Bin);
use File::Basename;
use File::Spec;
use File::Path qw(make_path remove_tree);


my ($filename, $filepath, $filesuffix) = fileparse($0, ('.pl'));


my $OUTPUT_DIR = File::Spec->catdir($Bin, "_${filename}");

if ( -d $OUTPUT_DIR )
{
     remove_tree($OUTPUT_DIR, {verbose => 1});
}
make_path($OUTPUT_DIR, {verbose => 1});

my $INPUT_DIR = shift or die "No source!$/";


my @stack;
push @stack, $INPUT_DIR; 

while (@stack) 
{
     my $this_dir_pfad = shift @stack;
     # print "DIR: ${this_dir_pfad}$/";
     opendir (my $this_dir_glob, $this_dir_pfad) or die "$!";
     while ( my $elm = readdir $this_dir_glob )
     {
          next if $elm =~ /\A\.\.?\z/;
          my $elm_pfad = File::Spec->catdir($this_dir_pfad, $elm);
          if ( -d $elm_pfad )
          {
               push @stack, $elm_pfad;
          }
          else
          {
               # print "\t", $elm_pfad, $/;
               next unless $elm_pfad =~ /txt/;
               my ($name, $path, $suffix) = 
                    fileparse($elm_pfad, ('.txt'));
               # print "${name}${suffix} $path$/";

               my @arr = split(/_/, $name);
               print "@arr", $/;
          }
     }
}
