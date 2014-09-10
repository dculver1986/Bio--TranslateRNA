package Bio::TranslateRNA;

use strict;
use warnings;
use Carp qw(croak);
use Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(rna_to_protein file_to_protein);

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

Returns the protein string from an rna string.

=head2 file_to_protein

    use Bio::TranslateRNA qw(file_to_protein);

    my $file = '/path/to/rna_file.txt';
    open( my $fh, '<', $file ) or die "Could not open file $file: $!\n";
    my $protein_from_file = file_to_protein($file);

Returns protein string from a file containing an RNA string.

=head1 AUTHOR

Daniel Culver, C<< perlsufi@cpan.org >>

=head1 ACKNOWLEDGEMENTS

Eris Caffee, C<< eris-caffee@eldalin.com >>

HostGator, L<< www.hostgator.com >>

Robert Stone, C<< drzigman@cpan.org >>

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

our %codons = (      # keys with values of '' are the end of RNA string segments
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
    my $protein;

    while ( $string =~ s/^(\w{3})// ) {
        my $motif = $1;
        if ( $motif =~ m/UGA|UAG|UAA/ ) {
            $protein .= "\n";
        }
        if ( length($motif) != 3 ) {
            croak "rna_to_protein caught invalid string: $motif";
        }
        if ( exists $codons{$motif} ) {
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
        if ( length($motif) != 3 ) {
            croak "file_to_protein caught invalid string: $motif";
        }
        if ( exists $codons{$motif} ) {
            $protein .= $codons{$motif};
        }
    }
    return $protein;
    close $fh;
}

1;

