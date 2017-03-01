#!/usr/bin/perl -Iblib/lib/
#
#  Test that parsing records in upper/mixed-case works as it should.
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
    chomp($line);

    my @data = split( / /, $line );

    my $input = $data[0];
    my $name  = $data[1];
    my $type  = $data[2];
    my $value = $data[3];

    # Parse the input text
    my @all = getObj($input);

    # Ensure there is only one entry.
    is( scalar(@all), 1, "One record found" );

    # Ensure the parsed values match our expectations:
    #
    #   The name is lower-cased.
    #   The value is lower-cased.
    #   The type is upper.
    #
    is( $all[0]->{ 'type' },  $type,  "Got the right type: $type" );
    is( $all[0]->{ 'name' },  $name,  "Got the right name: $name" );
    is( $all[0]->{ 'value' }, $value, "Got the right value: $value" );


}


#
# Data for the test:
#
#   "input" "name" "type" "value"
#
__DATA__
+webmail.steve.org.uk:80.68.84.104:300 webmail.steve.org.uk A 80.68.84.104
CSSH.steve.ORG.uk:mail.steve.org.uk:300 ssh.steve.org.uk CNAME mail.steve.org.uk
+www.steve.ORG.uk:1.2.3.4:300 www.steve.org.uk A 1.2.3.4
Tsteve.org.uk:"ThisisMIXEDcase":300 steve.org.uk TXT "ThisisMIXEDcase"
