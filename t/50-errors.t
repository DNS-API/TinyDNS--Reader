#!/usr/bin/perl -Iblib/lib/
#
#  Test that we can spot errors.
#
# Steve
# --
#

use strict;
use warnings;


use Test::More qw! no_plan !;

BEGIN {use_ok("TinyDNS::Reader")}
require_ok("TinyDNS::Reader");

BEGIN {use_ok("TinyDNS::Record")}
require_ok("TinyDNS::Record");



#
#  Parse the given text and return the records.
#
sub getObj
{
    my ($txt) = (@_);

    # create
    my $o = TinyDNS::Reader->new( text => $txt );
    isa_ok( $o, "TinyDNS::Reader" );

    # parse
    my $out = $o->parse();
    ok( $out, "Parsing resulted in a non-empty value" );
    is( ref($out), "ARRAY", "Which has the right type" );

    my @ret = @$out;
    return (@ret);
}



#
#  Process each line in our data-section and ensure we get
# a name + type that we expect
#
foreach my $line (<DATA>)
{
    # Parse the input text
    my @all = getObj($line);

    # Ensure there is only one entry.
    is( scalar(@all), 1, "One record found" );

    # Ensure the parsed values match our expectations:
    #
    #   The name is lower-cased.
    #   The value is lower-cased.
    #   The type is upper.
    #
    ok( $all[0]->{ 'type' } =~ /error/i, "The record was bogus" );

    print $all[0]->error() . "\n";
}


#
# Data for the test.
#
__DATA__
+too-big.steve.org.uk:1.2.3.444:330
+too-long.steve.org.uk:133.2.3.244.3:330
6too-big.steve.org.uk:fsfsdk3:330
