#!perl
use warnings;
use strict;
use Data::Dumper;
use Test::More no_plan => 1;

use Acme::UTF1;
use Encode qw( encode );

# really simple case
is( encode('utf-1', "\x{00}"), "\0" );
is( encode('utf-1', "\x{01}"), "\1\0" );
is( encode('utf-1', "\x{02}"), "\1\1\0" );

# stupid test
for (1..10) {
  my $rand = int(rand(3000));
  my $input = chr($rand);
  is( encode('utf-1', $input), ("\1" x $rand) . "\0", "char $rand" );
}

  
