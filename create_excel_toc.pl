#!perl
use strict;
use warnings FATAL => qw(all);

use File::Spec;
use File::Path qw(make_path remove_tree);
use FindBin qw($Bin);
use open ':std', ':encoding(UTF-8)';
use File::Basename;





use Win32::OLE qw(with); # qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Text::CleanFragment;

$Win32::OLE::Warn = 3; # Die on Errors.

my ($progname, $path, $idx) = fileparse($0, '.pl');
my $OUTPUT_DIR = File::Spec->catdir($Bin, "_${progname}");

if ( -d $OUTPUT_DIR )
{
     remove_tree($OUTPUT_DIR, {verbose => 1});
}

make_path($OUTPUT_DIR, {verbose => 1});


my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
        || Win32::OLE->new('Excel.Application', 'Quit'); 
$Excel->{DisplayAlerts}=0;  

my $DATA = '<temporary folder>';
my $excelfile = 'Excel_Dummy.xlsx';
my $Book = $Excel->Workbooks->Open( File::Spec->catdir($DATA, $excelfile));


# Here to make hyperlinks work!
my ($xlname, $xlpath, $xlidx) = fileparse($excelfile, '.xlsx');
$xlname .= '_extras';
$Book->SaveAs(File::Spec->catdir($DATA, $xlname . $xlidx));

my $Sheet_TOC = $Book->Worksheets->Add({Before=>$Book->Worksheets(1)}) or die Win32::OLE->LastError();
$Sheet_TOC->Activate();
$Sheet_TOC->{Name} = 'TOC';

for my $i ( 2 .. $Book->Worksheets->{Count} )
{
     my $Sheet = $Book->Worksheets($i);
     $Sheet_TOC->Cells($i, 1)->{Value} = $Sheet->{Name};

     # Hyperlink from TOC.
     $Sheet_TOC->Hyperlinks->Add({
        Anchor  => $Sheet_TOC->Cells($i, 1),   

        Address => $Book->{Name},
        SubAddress => $Sheet->{Name} . '!A1',
        TextToDisplay   =>  "Link to " . $Sheet->{Name},
        ScreenTip       =>  $Sheet->{Name},
     });
     
     $Sheet->Hyperlinks->Add({
        Anchor  => $Sheet->Range("A1"),  

        Address => $Book->{Name},
        SubAddress => $Sheet_TOC->{Name} . '!A1', 
        TextToDisplay   =>  "Back to TOC ", 
        ScreenTip       =>  $Sheet_TOC->{Name}, 
     });
}



# my ($xlname, $xlpath, $xlidx) = fileparse($excelfile, '.xlsx');
# $xlname .= '_extras';
$Book->SaveAs(File::Spec->catdir($DATA, $xlname . $xlidx));
