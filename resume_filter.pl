#!/usr/bin/perl
$input_file=shift;
my @file_lines=();
@keywords=("Blockchain","Perl","C","C#","ASP.NET","Mongodb","HTML","Python","Software","Engineer");

if($input_file=~/\.doc|\.docx/)
{
	select abc;
	close STDERR;
	system(`antiword "$input_file" > temp.txt`) or die "cant open file";
	select STDOUT;
	$input_file="temp.txt";
	open FILE, '<', $input_file or die "can't open $input_file: $!";
	while (<FILE>) 
	{
		chomp;
		if($_!~/^\s+$/)
		{
			#print "$_\n";
			push @file_lines,$_;
		}
	}
	close FILE or die "can't close $input_file: $!";
}

if($input_file=~/\.pdf/)
{
	use CAM::PDF;
	my $pdf = CAM::PDF->new($input_file);
	for my $page (1 .. $pdf->numPages()) 
	{
		my $text = $pdf->getPageText($page);
		@lines = split (/\n/, $text);
		foreach (@lines) 
		{
			push @file_lines,$_;
			#print "$_\n";
		}
	}
}
else
{
	open FILE, '<', $input_file or die "can't open $input_file: $!";
	while (<FILE>) 
	{
		chomp;	
		if($_!~/^\s+$/)
		{
			#print "$_\n";
			push @file_lines,$_;
		}
	}
	close FILE or die "can't close $input_file: $!";
}
my $cnt=1;
my $keyword_cnt=0;
foreach my $line(@file_lines)
{
    chomp $line;
    $line=~s/^\s+//g;
    $line=~s/\s+/ /g;
    $line=~s/\:|\,|\*//g;
    $line=~s/\s+$//g;
    #print  "Line $cnt:$_\n";
    $cnt++;
   	my $index=0;
    @line=split(" ",$line);
    foreach $word(@line)
	{
	#	print "$word\n";
	    chomp $word;
        foreach my $keyword(@keywords)
	    {
		    chomp $keyword;
		    #print "$keyword\n";
		   	if(lc($word) eq lc($keyword))
            {
			    $keyword_cnt++;
			   	$index++ until $keywords[$index] eq $keyword;
			    splice(@keywords, $index, 1);
			    last;
			}
		}  	
	}
}
print "Total matching keywords are : $keyword_cnt";
system(`del temp.txt`);

