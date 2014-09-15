package Bio::TranslateRNA;

use strict;
use warnings;
use Carp qw(croak);
use Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(rna_to_protein file_to_protein);

# VERSION
# ABSTRACT: Module to Translate RNA strings to Protein

=pod

=encoding utf8

=head1 NAME
    Bio::TranslateRNA - Module to translate RNA string to Protein

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Bio::TranslateRNA qw(rna_to_protein file_to_protein);

    my $rna_string = 'AUGGCCAUGGCGCCCAGAACUGAGAUCAAUAGUACCCGUAUUAACGGGUGA';
    my $protein    = rna_to_protein($rna_string);
    print "My protein is: $protein \n";

=head1 DESCRIPTION

Module to convert RNA strings to protein strings. It will also accept
a file containing an RNA string. This module maps out 3 letter segments of
a valid RNA string to its corresponding protein letter. Segments such as
UGA or UAG or UAA do not have a protein letter and are considered the end
of the RNA string.

=head1 METHODS

=head2 rna_to_protein
    use Bio::TranslateRNA qw(rna_to_protein);

    my $rna_string = 'AUGGCCAUGGCGCCCAGAACUGAGAUCAAUAGUACCCGUAUUAACGGGUGA';
    my $protein    = rna_to_protein($rna_string);

Returns the protein string from an rna string. If an empty or invalid string is
given, it will croak.

=head2 file_to_protein
    use Bio::TranslateRNA qw(file_to_protein);

    my $file = '/path/to/rna_file.txt';
    open( my $fh, '<', $file ) or die "Could not open file $file: $!\n";
    my $protein_from_file = file_to_protein($file);

Returns protein string from a file containing an RNA string. If it contains an
invalid string, it will croak.

=head1 AUTHOR

Daniel Culver, C<< perlsufi@cpan.org >>

=head1 ACKNOWLEDGEMENTS

Eris Caffee, C<< eris-caffee@eldalin.com >>

HostGator

Robert Stone, C<< drzigman@cpan.org >>

=head1 COPYRIGHT
This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
=cut

our %codons = (
    GCU => 'A',
    GCC => 'A',
    GCA => 'A',
    GCG => 'A',
    UGU => 'C',
    UGC => 'C',
    GAC => 'D',
    GAU => 'D',
    GAA => 'E',
    GAG => 'E',
    UUU => 'F',
    UUC => 'F',
    GGA => 'G',
    GGC => 'G',
    GGG => 'G',
    GGU => 'G',
    CAU => 'H',
    CAC => 'H',
    AUA => 'I',
    AUC => 'I',
    AUU => 'I',
    AAA => 'K',
    AAG => 'K',
    CUU => 'L',
    CUC => 'L',
    UUA => 'L',
    CUA => 'L',
    UUG => 'L',
    CUG => 'L',
    AUG => 'M',
    AAC => 'N',
    AAU => 'N',
    CCA => 'P',
    CCG => 'P',
    CCC => 'P',
    CCU => 'P',
    CAA => 'Q',
    CAG => 'Q',
    AGA => 'R',
    AGG => 'R',
    CGA => 'R',
    CGG => 'R',
    CGC => 'R',
    CGU => 'R',
    AGC => 'S',
    AGU => 'S',
    UCA => 'S',
    UCC => 'S',
    UCG => 'S',
    UCU => 'S',
    ACA => 'T',
    ACC => 'T',
    ACG => 'T',
    ACU => 'T',
    GUU => 'V',
    GUC => 'V',
    GUA => 'V',
    GUG => 'V',
    UGG => 'W',
    UAC => 'Y',
    UAU => 'Y',
    UAA => '',
    UAG => '',
    UGA => '',
);
sub rna_to_protein {

    my $string = shift || croak "rna_to_protein caught invalid string";
    my $protein;

    while ( $string =~ s/^(\w{3})// ) {
        my $motif = $1;
        if ( $motif =~ m/UGA|UAG|UAA/ ) {
            $protein .= "\n";
        }
        elsif ( length($motif) != 3 ) {
            croak "rna_to_protein caught invalid string: $motif";
        }
        elsif ( exists $codons{$motif} ) {
            $protein .= $codons{$motif};
        }
        else {
            croak "rna_to_protein caught invalid string: $motif";
        }

    }

    return $protein;
}

sub file_to_protein {

    my $file = $_[0];
    my $protein;
    my @rna_segments;

    open( my $fh, '<', $file ) or die "Could not open file $file: $!\n";

    while ( my $string = <$fh> ) {
        @rna_segments = $string =~ /(\w{3})/g;
    }
    for my $motif (@rna_segments) {
        if ( $motif =~ /UAA|UAG|UGA/ ) {
            $protein .= "\n";
        }
        elsif ( length($motif) != 3 ) {
            croak "file_to_protein caught invalid string: $motif";
        }
        elsif ( exists $codons{$motif} ) {
            $protein .= $codons{$motif};
        }
        else {
            croak "file_to_protein caught invalid string: $motif";
        }
    }
    return $protein;
}

1;
