# Perl module for handling IMMA data
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;
use Exporter;
@MarineOb::IMMA::ISA    = qw(Exporter);
@MarineOb::IMMA::EXPORT = qw(imma_read);

# attachments, parameters and definitions arrays are in separate files
#  - one for each attachment
use MarineOb::IMMA::core;
use MarineOb::IMMA::icoads;
use MarineOb::IMMA::immt2;
use MarineOb::IMMA::mqc;
use MarineOb::IMMA::metadata;
use MarineOb::IMMA::historical;
use MarineOb::IMMA::supplemental;

# Define a hash to hold data for a specific record
my %imma = (
    attachments => [] # List of attachments present
                      # Decoding will add values for each parameter to this hash
);

# Magic Perl object maker
sub new {
    my $that  = shift;
    my $class = ref($that) || $that;
    my $self  = { %imma, };
    bless $self, $class;
    $self->clear();
    return $self;
}

# Delete all the data in a record
sub clear {
    my $self = shift;
    foreach ( keys(%$self) ) {
        delete( $self->{$_} );
    }
    $self->{attachments} = [];
}

# Read in a record from a file
sub read {
    my $self = shift;
    my $fh   = shift;    # Filehandle to read from
    my $line = <$fh>;
    unless ( defined($line) ) { return; }
    chomp($line);
    
    # Get rid of any existing data in the record
    $self->clear();

    # Core is always present (and first)
    my $Attachment = 0;
    my $Length     = 108;

    # Decode each attachment
    while ( length($line) > 0 ) {

        # Pad the string with blanks if it's too short
        if (   defined($Length)
            && $Length > 0
            && length($line) < $Length )
        {
            $line .= pack "A" x ( $Length - length($line) ), " ";

        }
        $self->decode(
            $line,
            $MarineOb::IMMA::attachments[$Attachment],
            $MarineOb::IMMA::parameters[$Attachment],
            $MarineOb::IMMA::definitions[$Attachment]
        );
        push @{ $self->{attachments} }, $Attachment + 0.0;
        if ( !defined($Length) || $Length == 0 ) {
            last;
        }
        $line = substr( $line, $Length );
        if ( length($line) > 0 ) {
            $Attachment = substr( $line, 0, 2 );
            $Length     = substr( $line, 2, 2 );
            unless ( $Length =~ /\S/ ) { $Length = undef; }
            if ( defined($Length) && $Length != 0 ) {
                $Length -= 4;
            }
            $line = substr( $line, 4 );
            unless ( defined( $MarineOb::IMMA::attachments[$Attachment] ) ) {
                croak "Unsupported attachment ID $Attachment";
            }
        }
    }
    return 1;
}

# Class methods for reading data
sub imma_read {
    my $fh         = shift;      # Reference to filehandle to read data from.
    my $imma_local = new MarineOb::IMMA;
    $imma_local->read($fh) or return 0;
    return $imma_local;
}

# Write out a record to a file
sub write {
    my $self = shift;
    my $fh   = shift;            # Filehandle to write to

    my $Result;
    foreach my $Attachment ( @{ $self->{attachments} } ) {
        $Result .= $self->encode(
            $Attachment,
            $MarineOb::IMMA::parameters[$Attachment],
            $MarineOb::IMMA::definitions[$Attachment]
        );
    }
    chomp($Result);
    print $fh "$Result\n" or croak "Failed to write to output filehandle";
    return 1;
}

# Extract the parameter values from the string representation
#  of an attachment
sub decode {
    my $self        = shift;
    my $as_string   = shift;    # String representation of the attachment
    my $attachment  = shift;    # Attachment name
    my $parameters  = shift;    # Ref to attachment parameter array
    my $definitions = shift;    # Ref to attachment definitions hash
    unless ( defined($as_string) ) {
        croak "No data to decode";
    }
    my $Position = 0;
    for ( my $i = 0 ; $i < scalar( @{$parameters} ) ; $i++ ) {
        if ( defined( $definitions->{ $parameters->[$i] }->[0] ) ) {
            $self->{ $parameters->[$i] } =
              substr( $as_string, $Position,
                $definitions->{ $parameters->[$i] }->[0] );
            $Position += $definitions->{ $parameters->[$i] }->[0];
        }
        else {                  # Undefined length - so slurp all the data
            $self->{ $parameters->[$i] } =
              substr( $as_string, $Position, length($as_string) - $Position );
            chomp($self->{ $parameters->[$i] });
            $Position = length($as_string);
        }

        # Blanks mean value is undefined
        unless ( $self->{ $parameters->[$i] } =~ /\S/ ) {
            $self->{ $parameters->[$i] } = undef;
            next;
        }
        if ( $definitions->{ $parameters->[$i] }->[6] == 2 ) {
            $self->{ $parameters->[$i] } =
              decode_base36( $self->{ $parameters->[$i] } );
        }
        if ( defined( $definitions->{ $parameters->[$i] }->[5] ) ) {
            $self->{ $parameters->[$i] } *=
              $definitions->{ $parameters->[$i] }->[5];
        }
        unless ( $self->check( $parameters->[$i], $definitions ) ) {
            carp
              "Unacceptable value ($self->{$parameters->[$i]}) for $parameters->[$i]"
              . " in $as_string.";
        }
    }
}

# Make a string representation of an attachment
sub encode {
    my $self        = shift;
    my $attachment  = shift;    # Attachment number
    my $parameters  = shift;    # Ref to attachment parameter array
    my $definitions = shift;    # Ref to attachment definitions hash

    my $Result = "";
    for ( my $i = 0 ; $i < scalar( @{$parameters} ) ; $i++ ) {
        unless ( !defined( $self->{ $parameters->[$i] } )
            || $self->check( $parameters->[$i], $definitions ) )
        {
            warn "Parameter $parameters->[$i] has bad value "
              . "$self->{$parameters->[$i]} "
              . "it will be written as undefined.";
            undef( $self->{ $parameters->[$i] } );
        }
        if ( defined( $self->{ $parameters->[$i] } ) ) {
            my $Tmp = $self->{ $parameters->[$i] };

            # Scale to integer units for output
            if ( defined( $definitions->{ $parameters->[$i] }->[5] ) ) {
                $Tmp /= $definitions->{ $parameters->[$i] }->[5];
                $Tmp = nint($Tmp);
            }

            # Encode as base36 if required
            if ( $definitions->{ $parameters->[$i] }->[6] == 2 ) {
                $Tmp = encode_base36($Tmp);
            }

            # Print as an string of the correct length
            if ( $definitions->{ $parameters->[$i] }->[6] == 1 ) {

                # Integer
                if ( defined( $definitions->{ $parameters->[$i] }->[0] ) ) {
                    my $Lstring = sprintf "%%%dd",
                      $definitions->{ $parameters->[$i] }->[0];
                    $Tmp = sprintf $Lstring, $Tmp;
                }
                else {

                    # Undefined length - don't try to constrain it
                    $Tmp = sprintf "%d", $Tmp;
                }
            }
            else {

                # String
                if ( defined( $definitions->{ $parameters->[$i] }->[0] ) ) {
                    my $Lstring = sprintf "%%-%ds",
                      $definitions->{ $parameters->[$i] }->[0];
                    $Tmp = sprintf $Lstring, $Tmp;
                }
                else {
                    $Tmp = sprintf "%-s", $Tmp;
                }
            }
            $Result .= $Tmp;

        }
        else {

            # Undefined data - make a blank string of the corect length
            if ( defined( $definitions->{ $parameters->[$i] }->[0] ) ) {
                my $Lstring = sprintf "\%%%ds",
                  $definitions->{ $parameters->[$i] }->[0];
                $Result .= sprintf $Lstring, " ";
            }
            else {

                # Undefined data with unknown length - should never happen
                $Result .= " ";
            }
        }
    }

    # Done all the parameters, add the ID and length to the start
    # (except for core)
    if ( $attachment != 0 ) {
        if ( $attachment != 99 ) {
            $Result = sprintf "%2d%2d%s", $attachment, length($Result) + 4,
              $Result;
        }
        else {
            $Result = sprintf "%2d 0%s", $attachment, $Result;
        }
    }

    return $Result;
}

# Check the value for a parameter is inside its acceptable range(s)
sub check {
    my $self        = shift;
    my $parameter   = shift;
    my $definitions = shift;    # Ref to attachment definitions hash
    unless ( exists( $definitions->{$parameter} ) ) {
        croak "No parameter $parameter in IMMA core.";
    }
    unless ( defined( $self->{$parameter} ) )       { return; }
    if     ( $definitions->{$parameter}->[6] == 3 ) {
        return 1;               # no range checks on character data
    }
    if (
        (
            !defined( $definitions->{$parameter}->[1] )
            || $definitions->{$parameter}->[1] <= $self->{$parameter}+0.005
        )
        && ( !defined( $definitions->{$parameter}->[2] )
            || $definitions->{$parameter}->[2] >= $self->{$parameter}-0.005 )
      )
    {
        return 1;
    }
    elsif (
        (
            defined( $definitions->{$parameter}->[3] )
            && $definitions->{$parameter}->[3] <= $self->{$parameter}+0.005
        )
        && ( defined( $definitions->{$parameter}->[4] )
            && $definitions->{$parameter}->[4] >= $self->{$parameter}-0.005 )
      )
    {
        return 1;
    }
    else {
        return;    # Doesn't match either range
    }
}

# Base36 code shamelessly ripped out of Run Henssel's Math::Base36 CPAN package
#  Modified to remove dependence on Math::Bigint, to change the error
#  messages and fix a couple of bugs.
sub decode_base36 {
    my ( $t, $i ) = 0;
    foreach ( split //, reverse uc shift ) {
        croak "invalid base 36 digit: '$_'"
          unless index( '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', $_ ) >= 0;
        $_ = ord($_) - 55 unless /\d/;    # Assume that 'A' is 65
        $t += $_ * ( 36**$i++ );
    }
    return $t;
}

sub encode_base36 {
    my $n = shift;
    my $p = shift || 0;
    croak "encode_base36 -- non-nunmeric value: '$n'"     unless $n =~ /^\d+$/;
    croak "encode_base36 -- invalid padding length: '$p'" unless $p =~ /^\d+$/;
    my $s = "";
    return (0) if $n == 0;
    while ($n) {
        my $v = $n % 36;
        if ( $v <= 9 ) {
            $s .= $v;
        }
        else {
            $s .= chr( 55 + $v );    # Assume that 'A' is 65
        }
        $n = int $n / 36;
    }
    return "0" x ( $p - length($s) ) . reverse($s);
}

# Return nearest integer to given float
sub nint {
    my $x = $_[0];
    my $n = int($x);
    if ( $x > 0 ) {
        if ( $x - $n > 0.5 ) {
            return $n + 1;
        }
        else {
            return $n;
        }
    }
    else {
        if ( $n - $x > 0.5 ) {
            return $n - 1;
        }
        else {
            return $n;
        }
    }
}
