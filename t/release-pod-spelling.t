#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use English qw( -no_match_vars );
use File::Slurper qw/ read_text / ;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use Text::Aspell";
plan skip_all => 'Text::Aspell required' if $@;

eval "use Text::Ispell";
plan skip_all => 'Text::Ispell required' if $@;

eval "use Lingua::Ispell";
plan skip_all => 'Lingua::Ispell required' if $@;

eval "require Test::Pod::Spelling";
plan skip_all => 'Test::Pod::Spelling required' if $@;

my $dictionary => 'xt/etc/custom-dictionary.txt';

Test::Pod::Spelling->import(
    spelling => {
        allow_words => [ ( map { chomp($ARG); $ARG } read_text($dictionary) ) ],
    },
);

all_pod_files_spelling_ok(qw( lib ));

done_testing;
