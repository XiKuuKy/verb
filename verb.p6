#my @state = 6, 5, 1;
my @state;

my $fh = slurp '/home/choiboi/Code/verb/verb.verb';
my @program = split('', $fh);

for @program -> $char {
  @state.push(1) if $char ~~ "+"; # if our reader finds a `+` then add 1 to the state
  @state.push("\n") if $char ~~ "n"; # if our reader finds a `n` then add a newline

  if $char ~~ "a" { # if the reader finds `a`...
    @state.push(@state.pop + @state.pop); # pop the last two values then add them
  }
  # not Array-y enough
  # if $char ~~ "A" { # if the reader finds `A`...
  #   @state.push(@state.pop + 1); # pop the last value then add 1
  # }
  if $char ~~ "A" { # if the reader finds `A`...
    @state.push(1);
    @state.push(@state.pop + @state.pop); # pop the last value then add 1
  }

  if $char ~~ "p" { # if the reader finds `p`
    @state.push(@state.pop().chr); # push the popped value of the state to the state and turn it into a char
  }

  # add numbers, inspired by roman numerals
  @state.push(5) if $char ~~ "v";
  @state.push(10) if $char ~~ "x";
  @state.push(50) if $char ~~ "l";
  @state.push(100) if $char ~~ "c";

  # subtract numbers...
  @state.push(-1) if $char ~~ "I";
  @state.push(-5) if $char ~~ "V";
  @state.push(-10) if $char ~~ "X";
  @state.push(-50) if $char ~~ "L";
  @state.push(-100) if $char ~~ "C";

  # syntactic sugar ...
  if $char ~~ "s" { # when we see `s`
    @state.push(-1); # push -1 to the state
    @state.push(@state.pop + @state.pop); # push the last two values of @state
  }

  if $char ~~ "-" { #subtract
    @state.push(@state.pop - @state.pop);
  }
  if $char ~~ "*" { #multiply
      @state.push(@state.pop * @state.pop);
  }
  if $char ~~ "/" { #divide
      @state.push(@state.pop / @state.pop);
  }
  if $char ~~ "%" { #modulo/remainder
      @state.push(@state.pop % @state.pop);
  }

  # logical operators

  if $char ~~ "=" { # equality test
      @state.push(@state.pop == @state.pop);
  }
  if $char ~~ "!" { # inequality test
      @state.push(@state.pop != @state.pop);
  }
  if $char ~~ "&" { # and
      @state.push(@state.pop && @state.pop);
  }
  if $char ~~ "<" { # less than
      @state.push(@state.pop < @state.pop);
  }
  if $char ~~ ">" { # greater than
      @state.push(@state.pop > @state.pop);
  }
  if $char ~~ "_" { # less than or equal to
      @state.push(@state.pop <= @state.pop);
  }
  if $char ~~ "g" { # greater than or equal to
      @state.push(@state.pop >= @state.pop);
  }
  if $char ~~ "~" { # smart equality test
      @state.push(@state.pop ~~ @state.pop);
  }
  if $char ~~ "?" { # threeway
      @state.push(@state.pop <=> @state.pop);
  }

  # if/unless die || control flow of program

  if $char ~~ "i" { # if verb
    if @state.pop == True {
      die "if die"; # dies if true
    }
  }
  if $char ~~ "u" { # unless verb
    unless @state.pop == True {
      die "unless die" # dies if false
    }
  }
}

my $finalState = join '', @state;
print $finalState;
