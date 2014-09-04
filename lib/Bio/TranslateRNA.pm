package Bio::TranslateRNA;

use strict;
use warnings;
use Data::Dumper;
use Carp qw(croak);
use Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(rna_to_protein file_to_protein);

=pod

=encoding utf8

=head1 NAME
    Bio::TranslateRNA - Module to translate RNA string to Protein
=cut

our %codons = (
    UUU => 'F',
    CUU => 'L',
    AUU => 'I',
    GUU => 'V',
    UUC => 'F',
    CUC => 'L',
    AUC => 'I',
    GUC => 'V',
    UUA => 'L',
    CUA => 'L',
    AUA => 'I',
    GUA => 'V',
    UUG => 'L',
    CUG => 'L',
    AUG => 'M',
    GUG => 'V',
    UCU => 'S',
    CCU => 'P',
    ACU => 'T',
    GCU => 'A',
    UCC => 'S',
    CCC => 'P',
    ACC => 'T',
    GCC => 'A',
    UCA => 'S',
    CCA => 'P',
    ACA => 'T',
    GCA => 'A',
    UCG => 'S',
    CCG => 'P',
    ACG => 'T',
    GCG => 'A',
    UAU => 'Y',
    CAU => 'H',
    AAU => 'N',
    GAU => 'D',
    UAC => 'Y',
    CAC => 'H',
    AAC => 'N',
    GAC => 'D',
    UAA => '',
    CAA => 'Q',
    AAA => 'K',
    GAA => 'E',
    UAG => '',
    CAG => 'Q',
    AAG => 'K',
    GAG => 'E',
    UGU => '',
    CGU => 'R',
    AGU => 'S',
    GGU => 'G',
    UGC => 'C',
    CGC => 'R',
    AGC => 'S',
    GGC => 'G',
    UGA => '',
    CGA => 'R',
    AGA => 'R',
    GGA => 'G',
    UGG => 'W',
    CGG => 'R',
    AGG => 'R',
    GGG => 'G',

);

sub rna_to_protein {

    my $string = shift;
    my $rna;

    while ( $string =~ s/^(\w{3})// ) {
        my $motif = $1;
        last if $motif =~ m/UGA|UAG|UAA/;
        if ( length($motif) != 3 ) {
            croak "rna_to_protein caught invalid string: $motif";
        }
        if ( exists $codons{$motif} ) {
            $rna .= $codons{$motif};
        }
        else {
            croak "rna_to_protein caught invalid string: $motif";
        }

    }

    return $rna;
}

sub file_to_protein {
    my $file = $_[0];
    my $protein;
    my @rna_segments;

    open( my $fh, '<', $file ) or die "Could not open file $file: $!\n";
    while ( my $string = <$fh>  ) {
        @rna_segments = $string =~ /(\w{3})/g;
    }
    for my $motif (@rna_segments) {
        last if $motif =~ m/UAA|UAG|UGA/;
        if ( length($motif) != 3 ) {
            croak "file_to_protein caught invalid string: $motif";
        }
        if ( exists $codons{$motif}) {
            $protein .= $codons{$motif};
        }
    }
    return $protein;
}

1;

