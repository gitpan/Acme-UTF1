#!perl
use warnings;
use strict;
use Data::Dumper;
use Test::More no_plan => 1;

use Acme::UTF1;
use Encode qw( decode );

# really simple case
is( decode('utf-1', "\0"), "\x{00}" );

# stupid test
for (1..10) {
  my $rand = int(rand(3000));
  my $input = ("\1" x $rand) . "\0";
  is( decode('utf-1', $input), chr($rand) , "char $rand");
}

# fail tests
is( decode('utf-1', "\2"), "\x{fffd}", "fails ok");
