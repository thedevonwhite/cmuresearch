my $codeFile = $ARGV[0];
#my $locOfComp = '/home/cmuresearch/Research/sadpiton/piton/verif/diag/c/cmu/';

my $cmd1 = "pitonunimap -f $codeFile -b vc707";
my $cmd2 = "cp ".$ENV{"DV_ROOT"}."/design/chipset/rtl/storage_addr_trans.v ".$ENV{"DV_ROOT"}."/design/chipset/rtl/storage_addr_trans_unified.v";

my $cmd4 = "protosyn -b vc707 -d system --uart-dmw ddr";

#This is the main code
print "\n\n $cmd1\n";
system($cmd1);

print "\n Copying storage_addr_trans to storage_addr_trans_unified\n";
system($cmd2);

print "\n Correct Module Name \n";
change_module_name($ENV{"DV_ROOT"}."/design/chipset/rtl/storage_addr_trans_unified.v", "storage_addr_trans", "storage_addr_trans_unified");


print "\n Generating Bitstream (This takes over an hour)\n";
print "Run: $cmd4\n";

print "\n FINISHED \n";
print "Now program the board and run pitonstream -b vc707 -f $codeFile\n";


sub change_module_name{
    (my $file, my $originalName, my $newName) = @_;

    open(LINEREPLACE, "grep -n \"module $originalName \" $file | sed \'s/:.*//\' |");
    my $lineNum = <LINEREPLACE>;
    close LINEREPLACE;
    open(FILECHANGEREAD, "<$file");
    my @lines = <FILECHANGEREAD>;
    close FILECHANGEREAD;
    
    $lines[$lineNum-1] =~ s:module $originalName :module $newName :;
    open(FILECHANGEWRITE, ">$file");
    print FILECHANGEWRITE @lines;
    close FILECHANGEWRITE;

}
