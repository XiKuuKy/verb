my @polynomial = 1, 5, 6;
my $div = -3;

sub divide {
  say ((((@polynomial[0] * $div) + @polynomial[1]) * $div) + @polynomial[2]);
}

divide;
