#!/usr/bin/perl
use warnings;
use strict;

use Module::Build;

Module::Build->new(
    module_name => 'Acme::UTF1',
    requires => {
        'perl'        => '5.8.0',
    },
    create_makefile_pl => 'traditional',
    create_readme => 1,
    license => "perl",
)->create_build_script;

