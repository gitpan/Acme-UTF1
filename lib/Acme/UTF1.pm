=head1 NAME

Acme::UTF1

=head1 SYNOPSIS

  use Acme::UTF1;
  use Encode qw( encode decode );
  
  # read utf-1 bytes from the input
  while ( my $bytes = <> ) {
    # decode to characters, and print
    my $chars = decode('utf-1', $bytes);
    print $chars;
  }


=head1 DESCRIPTION

Implements the utf-1 encoding for perl.

utf-1 is a way of encoding unicode characters so that they can be sent
across networks that are unable to handle the full 8 bits normally required
by utf-8. It will convert any character into a sequence of bytes, of which
only the bottom bit is set, and is able to convert such a sequence back to
characters.

=head1 FUTURE PLANS

=over

=item Rather than converting to bytes where only one bit is set, we could produce much denser bit sequences

=item Using only the bottom bit leaves us open to interference. It might be better to use the _entire_ byte, sending all 1s, or all 0s, so we can use noisy channels. Or for data-hiding purposes, we could use the parity of the byte to hold the data, and send otherwise completely random noise.

=item utf-1 would be ideal for hiding messages in the lowest bit of otherwise meaningful but noisy data.

=back

=head1 SEE ALSO

utf-7.

=head1 AUTHOR

Tom Insam <tom@jerakeen.org>

=cut

package Acme::UTF1;
use warnings;
use strict;
use base qw( Encode::Encoding );

our $VERSION = 1;

__PACKAGE__->Define(qw( utf-1 utf1 ));

sub encode {
  my ($class, $input, $check) = @_;

  my $output;

  for (split //, $input) {
    $output .= ("\1" x ord($_)) . "\0";
  }

  $_[1] = '' if $check; # modify in place

  return $output;
}

sub decode {
  my ($class, $input, $check) = @_;

  my $output = "";
  my $chunk = 0;
  my $byte = 0;

  while ($input) {
    $byte++;
    my $local;
    ($local, $input) = split(//, $input, 2); # horrible, I know. Meh. _ACME_.

    if ($local eq "\0") {
      $output .= chr($chunk);
      $chunk = 0;

    } elsif ($local eq "\1") {
      $chunk++;
    } else {
      Carp::carp( "invalid bit in utf-1 sequence at byte $byte" );
      if ($check) {
        $_[1] = $input;
        return $output;
      } else {
        $output .= "\x{fffd}";
      }
    }
  }

  $_[1] = '' if $check; # modify in place

  return $output;
}

1;
