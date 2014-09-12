#! /usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Test::Most;
use Test::Exception;
use Cwd qw(getcwd);
use Bio::TranslateRNA qw(rna_to_protein file_to_protein);
use Readonly;

Readonly my $TEST_RNA_STRING => 'AUGGCCAUGGCGCCCAGAACUGAGAUCAAUAGUACCCGUAUUAACGGGUGA';
Readonly my $PROTEIN_RESULT  => "MAMAPRTEINSTRING";
Readonly my $INVALID_STRING  => '283974892jfknc923rklsdvm';

subtest 'rna_to_protein method - valid RNA string' => sub {
    my $protein = rna_to_protein($TEST_RNA_STRING);
    cmp_ok( $protein, 'eq', $PROTEIN_RESULT."\n",
        'Correct Protein result for rna_to_protein method');
};

subtest 'file_to_protein method - valid RNA string' => sub {
    my $dir = getcwd;
    my $file = $dir.'/t/rna.txt';
    my $protein_from_file = file_to_protein($file);
    cmp_ok( $protein_from_file, 'eq', $PROTEIN_RESULT."\n",
        'Correct Protein result for file_to_protein method');
};

subtest 'file_to_protein method - valid, Large RNA string' => sub {
    my $dir = getcwd;
    my $file = $dir.'/t/big_rna_string.txt';
    my $protein_from_file = file_to_protein($file);

    my $big_protein_result = $dir.'/t/big_protein_result.txt';
    open (my $fh, '<', $big_protein_result) or die;
    cmp_ok(<$fh>, 'eq', $protein_from_file, 'Correct result for file_to_protein method');
};

subtest "rna_to_protein - Invalid String" => sub {
    my $protein;
    throws_ok {
        $protein = rna_to_protein($INVALID_STRING);
    } qr/rna_to_protein caught invalid string/, 'Throws ok on invalid string';

};

subtest "rna_to_protein - Empty String" => sub {
    my $protein;
    throws_ok {
        $protein = rna_to_protein('');
    } qr/rna_to_protein caught invalid string/, 'Throws ok on empty string';

};

done_testing;
