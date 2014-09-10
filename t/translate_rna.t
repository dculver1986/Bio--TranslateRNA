#! /usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Test::Most;
use File::Basename;
use Cwd qw(getcwd);
use Bio::TranslateRNA qw(rna_to_protein file_to_protein);
use Readonly;

Readonly my $TEST_RNA_STRING => 'AUGGCCAUGGCGCCCAGAACUGAGAUCAAUAGUACCCGUAUUAACGGGUGA';
Readonly my $PROTEIN_RESULT  => "MAMAPRTEINSTRING";
Readonly my $INVALID_STRING  => '283974892jfknc923rklsdvm';


subtest 'Test rna_to_protein method with valid RNA string' => sub {
    my $protein = rna_to_protein($TEST_RNA_STRING);
    cmp_ok( $protein, 'eq', $PROTEIN_RESULT."\n",
        'Correct Protein result for rna_to_protein method');
};

subtest 'Test file_to_protein method with valid RNA string' => sub {
    my $dir = getcwd;
    my $file = $dir.'/t/rna.txt';
    my $protein_from_file = file_to_protein($file);
    cmp_ok( $protein_from_file, 'eq', $PROTEIN_RESULT."\n",
        'Correct Protein result for file_to_protein method');
};
done_testing;
