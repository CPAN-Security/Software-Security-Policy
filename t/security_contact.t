#!perl
use strict;
use warnings;

use Test::More tests => 5;

my $class = 'Software::Security::Policy::Individual';
require_ok($class);

my $policy = $class->new({
        maintainer  => 'X. Ample <x.example@example.com>',
        program     => 'Foo::Bar',
        timeframe   => '6 days',
        git_url     => 'https://example.com/xampl/Foo-Bar',
        report_url  => 'https://example.com/xampl/Foo-Bar/security/advisories',
        perl_support_years   => '8',
        security_contact  => 'Security Contact X. Ample <sec_x.example@example.com>',
    });

is($policy->maintainer, 'Security Contact X. Ample <sec_x.example@example.com>', 'Security Contact matches');
isnt($policy->maintainer, 'X. Ample <x.example@example.com>', 'Maintainer overridden properly');

$policy = $class->new({
        maintainer  => 'Security Contact X. Ample <sec_x.example@example.com>',
        perl_support_years   => '10',
    });

is($policy->maintainer, 'Security Contact X. Ample <sec_x.example@example.com>', 'Security Contact matches');
isnt($policy->maintainer, 'X. Ample <x.example@example.com>', 'Maintainer overridden properly');

