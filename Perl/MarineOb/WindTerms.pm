# Convert subjective wind descriptions to beaufort forces.
# Uses the CLIWOC dictionary of English terms

package MarineOb::WindTerms;

use strict;
use warnings;
use Carp;

@MarineOb::WindTerms::ISA       = ('Exporter');
@MarineOb::WindTerms::EXPORT_OK = qw(WordsToBeaufort);

# Translation table for phrase to Beaufort force.
#  Mostly from the CLIWOC dictionary
my %WordsToBeaufort = (
    "abating gales"        => undef,
    "abating gale"         => undef,
    "abated gale"          => undef,
    "almost calm"          => 0,
    "air"                  => undef,
    "bad wind"             => undef,
    "bad winds"            => undef,
    "baffling"             => undef,
    "baffling air"         => undef,
    "baffling airs"        => undef,
    "baffling wind"        => undef,
    "baffling winds"       => undef,
    "blew fresh"           => 6,
    "blew gale"            => undef,
    "blew hard"            => 10,
    "blew strong"          => 9,
    "blowing"              => 6,
    "blowing fresh"        => 6,
    "blowing gale"         => undef,
    "blowing hard"         => 10,
    "blowing heavy"        => undef,
    "blowing strong"       => 9,
    "blows fresh"          => 6,
    "blows hard"           => 10,
    "blow hard"            => 10,
    "blows strong"         => 9,
    "breeze"               => undef,
    "brisk"                => undef,
    "brisk breeze"         => undef,
    "brisk gale"           => 6,
    "brisk monsoon"        => undef,
    "brisk monsoons"       => undef,
    "brisk trade"          => 5,
    "brisk wind"           => undef,
    "calm breeze"          => undef,
    "calm"                 => 0,
    "calms"                => 0,
    "confused trade"       => undef,
    "confused trades"      => undef,
    "constant breeze"      => undef,
    "constant gale"        => undef,
    "constant trade"       => undef,
    "constant wind"        => undef,
    "declining breeze"     => undef,
    "declining trade"      => undef,
    "declining trades"     => undef,
    "declining"            => undef,
    "decreased gale"       => undef,
    "decreased wind"       => undef,
    "decreased winds"      => undef,
    "decreasing air"       => undef,
    "decreasing airs"      => undef,
    "decreasing breeze"    => undef,
    "decreasing gale"      => undef,
    "decreasing monsoon"   => undef,
    "decreasing trades"    => undef,
    "decreasing trade"     => undef,
    "decreasing wind"      => undef,
    "decreasing"           => undef,
    "delightful breeze"    => undef,
    "descending"           => undef,
    "descending breeze"    => undef,
    "descending fresh"     => undef,
    "disagreeable wind"    => undef,
    "disagreeable winds"   => undef,
    "drawing"              => undef,
    "drawing breeze"       => undef,
    "drawing round"        => undef,
    "drawing wind"         => undef,
    "dying wind"           => undef,
    "easy breeze"          => 2,
    "easy gale"            => 3,
    "faint"                => undef,
    "faint air"            => undef,
    "faint breeze"         => 2,
    "faint gale"           => 3,
    "fair"                 => undef,
    "fair baffling"        => undef,
    "fair trade"           => undef,
    "fair trades"          => undef,
    "fair wind"            => undef,
    "fair winds"           => undef,
    "falling calm"         => undef,
    "falling calm"         => undef,
    "falling light"        => undef,
    "favorable"            => undef,
    "favorable wind"       => undef,
    "favourable trade"     => undef,
    "favourable trades"    => undef,
    "feint breeze"         => 2,
    "feint gale"           => 3,
    "fine"                 => undef,
    "fine breeze"          => 5,
    "fine gale"            => 5,
    "fine monsoon"         => undef,
    "fine trade"           => 5,
    "foul wind"            => undef,
    "frail gale"           => undef,
    "fresh"                => undef,
    "fresh air"            => undef,
    "fresh breeze"         => 5,
    "fresh breezes"        => 5,
    "fresh freshening"     => undef,
    "fresh gale"           => 8,
    "fresh gales"          => 8,
    "fresh gust"           => undef,
    "fresh monsoons"       => undef,
    "fresh monsoon"        => undef,
    "fresh puffs"          => undef,
    "fresh puff"           => undef,
    "fresh trade"          => 6,
    "fresh wind"           => 6,
    "freshened up"         => undef,
    "freshening breeze"    => undef,
    "freshening gale"      => undef,
    "freshening gales"     => undef,
    "freshening trade"     => undef,
    "freshening trades"    => undef,
    "freshening up"        => undef,
    "freshening wind"      => undef,
    "freshening"           => undef,
    "gale"                 => undef,
    "gentle breeze"        => 3,
    "gentle gale"          => 3,
    "gentle trade"         => 3,
    "getting moderate"     => undef,
    "good wind"            => undef,
    "good winds"           => undef,
    "gradually increasing" => undef,
    "great gales"          => undef,
    "gusty"                => undef,
    "hard"                 => undef,
    "hard breeze"          => undef,
    "hard breezes"         => undef,
    "hard gale"            => 10,
    "hard gales"           => 10,
    "hard gusts"           => undef,
    "hard puff"            => undef,
    "hard wind"            => undef,
    "hard squalls"         => undef,
    "hauling wind"         => undef,
    "heavy"                => undef,
    "heavy air"            => undef,
    "heavy airs"           => undef,
    "heavy breeze"         => undef,
    "heavy gales"          => 9,
    "heavy gale"           => 9,
    "heavy gust"           => undef,
    "heavy gusts"          => undef,
    "heavy trade"          => undef,
    "heavy trades"         => undef,
    "high wind"            => undef,
    "high breeze"          => undef,
    "hurricane"            => 12,
    "inclinable"           => undef,
    "inclinable breeze"    => undef,
    "inclinable calm"      => undef,
    "inclinable to calms"  => 1,
    "inclinable wind"      => undef,
    "inclining breeze"     => undef,
    "inclining calm"       => undef,
    "inclining wind"       => undef,
    "inclining"            => undef,
    "increased gradually"  => undef,
    "increasing"           => undef,
    "increasing air"       => undef,
    "increasing breezes"   => undef,
    "increasing breeze"    => undef,
    "increasing gales"     => undef,
    "increasing gale"      => undef,
    "increasing moderate"  => undef,
    "increasing monsoon"   => undef,
    "increasing strong"    => undef,
    "increasing trade"     => undef,
    "increasing wind"      => undef,
    "land breeze"          => undef,
    "land wind"            => undef,
    "less wind"            => undef,
    "light"                => undef,
    "light airs"           => 1,
    "light air"            => 1,
    "light breeze"         => 2,
    "light breezes"        => 2,
    "light calm"           => undef,
    "light calm"           => undef,
    "light gale"           => 3,
    "light monsoons"       => 4,
    "light monsoon"        => 4,
    "light spurts"         => undef,
    "light trade"          => 4,
    "light winds"          => 2,
    "light winds"          => undef,
    "light wind"           => undef,
    "lighter"              => undef,
    "little airs"          => undef,
    "little breeze"        => undef,
    "little winds"         => 2,
    "little wind"          => 2,
    "mild trade"           => undef,
    "mild trades"          => undef,
    "moderate air"         => undef,
    "moderate breeze"      => 4,
    "moderate breezes"     => 4,
    "moderate fresh"       => undef,
    "moderate gale"        => 7,
    "moderate light"       => undef,
    "moderate monsoons"    => 5,
    "moderate monsoon"     => 5,
    "moderate strong"      => undef,
    "moderate trade"       => 5,
    "moderate winds"       => undef,
    "moderate wind"        => undef,
    "moderate"             => 4,
    "moderating breeze"    => undef,
    "moderating gale"      => undef,
    "moderating gales"     => undef,
    "moderating gradually" => undef,
    "moderating monsoon"   => undef,
    "moderating trade"     => undef,
    "moderating wind"      => undef,
    "moderating"           => undef,
    "monsoon winds"        => undef,
    "monsoon"              => undef,
    "more moderate"        => undef,
    "more settled"         => undef,
    "more steady"          => undef,
    "more wind"            => undef,
    "mostly calm"          => 0,
    "much wind"            => undef,
    "much hard"            => undef,
    "nearly calm"          => 1,
    "nearly calm"          => 1,
    "perfect calm"         => 0,
    "pleasant"             => undef,
    "pleasant air"         => undef,
    "pleasant breeze"      => 4,
    "pleasant fine"        => undef,
    "pleasant gale"        => 5,
    "pleasant increasing"  => undef,
    "pleasant monsoon"     => undef,
    "pleasant trade"       => 5,
    "pleasant wind"        => 4,
    "promising gale"       => undef,
    "promising wind"       => undef,
    "puff"                 => undef,
    "quite moderate"       => undef,
    "raising"              => undef,
    "rather moderate"      => undef,
    "rather moderating"    => undef,
    "sea breeze"           => undef,
    "settled breeze"       => undef,
    "settled trade"        => undef,
    "settled wind"         => undef,
    "settled winds"        => undef,
    "settled"              => undef,
    "settling"             => undef,
    "settling breeze"      => undef,
    "severe gale"          => undef,
    "severe gusts"         => undef,
    "severe typhoon"       => 12,
    "sharp gusts"          => undef,
    "shifted wind"         => undef,
    "slight trade"         => undef,
    "small airs"           => 1,
    "small breeze"         => undef,
    "small gale"           => 4,
    "small gales"          => 4,
    "smart gale"           => undef,
    "smart puff"           => undef,
    "smart puffs"          => undef,
    "springing breeze"     => undef,
    "springing up"         => undef,
    "squalls"              => undef,
    "squalls monsoon"      => undef,
    "squally monsoon"      => undef,
    "squally trade"        => undef,
    "squalls trade"        => undef,
    "squally"              => undef,
    "steady"               => undef,
    "steady air"           => undef,
    "steady breeze"        => 5,
    "steady fresh"         => undef,
    "steady gale"          => 6,
    "steady gust"          => undef,
    "steady monsoon"       => undef,
    "steady sharp"         => undef,
    "steady trade"         => 6,
    "steady winds"         => undef,
    "steady wind"          => undef,
    "stiff breeze"         => 6,
    "stiff gale"           => undef,
    "stiff trade"          => undef,
    "stirring breeze"      => undef,
    "stray monsoon"        => undef,
    "strong"               => 6,
    "strong breeze"        => 6,
    "strong breezes"       => 6,
    "strong gale"          => 9,
    "strong gales"         => 9,
    "strong gust"          => undef,
    "strong gusts"         => undef,
    "strong monsoon"       => 7,
    "strong puffs"         => undef,
    "strong puff"          => undef,
    "strong trade"         => 7,
    "strong wind"          => 8,
    "stout gale"          => undef,
    "tempest"              => 11,
    "top-gallant gale"     => 5,
    "trade wind"           => undef,
    "trades"               => undef,
    "trade"                => undef,
    "tremendous gales"     => 11,
    "typhoon"              => 12,
    "unsettled"            => undef,
    "unsettled breeze"     => undef,
    "unsettled trade"      => undef,
    "unsettled trades"     => undef,
    "unsettled wind"       => undef,
    "unsteady"             => undef,
    "unsteady breeze"      => undef,
    "unsteady monsoon"     => undef,
    "unsteady trade"       => undef,
    "unsteady trades"      => undef,
    "unsteady wind"        => undef,
    "unsteady winds"       => undef,
    "up breeze"            => undef,
    "variable air"         => undef,
    "variable airs"        => undef,
    "variable breeze"      => undef,
    "variable trade"       => undef,
    "variable trades"      => undef,
    "variable wind"        => undef,
    "variable winds"       => undef,
    "variable"             => undef,
    "veering"              => undef,
    "very blow"            => undef,
    "very heavy"           => undef,
    "very light"           => 1,
    "very steady"          => undef,
    "very unsettled"       => undef,
    "violent gales"        => 9,
    "violent gale"         => 9,
    "violent gusts"        => undef,
    "violent storm"        => 11,
    "violent wind"         => undef,
    "whole calm"           => 0,
    "whole gale"           => 10,
    "winds"                => undef,
    "wind"                 => undef,
    "windy"                => undef,
);

sub WordsToBeaufort {
    my @Words;
    foreach (@_) { push @Words,$_; }
    unless (@Words) { return -1; }
    foreach (@Words) { $_ = to_root($_); }

    # Try the words in all orders
    my @Orders = perturb(@Words);
    foreach my $Order (@Orders) {
        my $Beaufort;
        if ( ref($Order) eq 'ARRAY' ) {
            $Beaufort = known_words( join " ", @{$Order} );
        }
        else { $Beaufort = known_words($Order); }
        if ( !defined($Beaufort) ) {
            return;
        }    # Known set of words with no translation
        if ( $Beaufort >= 0 ) { return $Beaufort; }
    }
    carp "unknown wind expression: "
      . join( " ", @Words );
    return -1;
}

# Convert a wind term to its root form
sub to_root {
    my $Term = lc(shift);
    $Term =~ s/[^a-z]//g;
    if ( $Term eq 'brreze' ) { return 'breeze'; }
    if ( $Term eq 'breees' ) { return 'breeze'; }
    if ( $Term eq 'breeses' ) { return 'breezes'; }
    if ( $Term eq 'favorable' ) { return 'favourable'; }
    if ( $Term eq 'breezes' ) { return 'breeze'; }
    if ( $Term eq 'gales' ) { return 'gale'; }
   return lc($Term);
}

sub known_words {
    my $WString = shift;
    my $Beaufort;
    if ( exists( $WordsToBeaufort{$WString} ) ) {
        $Beaufort = $WordsToBeaufort{$WString};
    }
    else {
        $Beaufort = -1;
    }
    if ( !defined($Beaufort) ) { return; }
    if ( $Beaufort == -1 )     { return -1; }
    return $Beaufort;
}

# Produce all the possible perturbations of a list
sub perturb {
    my @Initial = @_;
    if ( scalar(@Initial) <= 1 ) { return @Initial; }
    my @Result;
    for ( my $i = 0 ; $i < scalar(@Initial) ; $i++ ) {
        my @P2;
        for ( my $j = 0 ; $j < scalar(@Initial) ; $j++ ) {
            if ( $j == $i ) { next; }
            push @P2, $Initial[$j];
        }
        my @Pr = perturb(@P2);
        foreach (@Pr) {
            if ( ref($_) eq 'ARRAY' ) {
                push @Result, [ $Initial[$i], @{$_} ];
            }
            else {
                push @Result, [ $Initial[$i], $_ ];
            }
        }
    }
    return @Result;
}

1;

