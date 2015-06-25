#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use XML::Simple;
use XML::LibXML;

#Get a new Web user agent.
my $ua = LWP::UserAgent->new;
$ua->timeout(20);
$ua->env_proxy;

my $host = "http://hmmer.janelia.org";
my $search = "/search/phmmer";

#Parameters
my  $seq = qq(>2abl_A mol:protein length:163  ABL TYROSINE KINASE
MGPSENDPNLFVALYDFVASGDNTLSITKGE
KLRVLGYNHNGEWCEAQTKNGQGWVPSNYIT
PVNSLEKHSWYHGPVSRNAAEYLLSSGINGS
FLVRESESSPGQRSISLRYEGRVYHYRINTA
SDGKLYVSSESRFNTLAELVHHHSTVADGLI
TTLHYPAP);

my $seqdb = 'pdb';

#Make a hash to encode for the content.
my %content = ( 'seqdb' => $seqdb,
                'content'   => "<![CDATA[$seq]]>" );

#Convert the parameters to XML
my $xml = XMLout(\%content, NoEscape => 1);

#Now post it off
my $response = $ua->post( $host.$search, 'content-type' => 'text/xml', Content => $xml );

die "error: failed to successfully POST request: " . $response->status_line . "\n"
  unless ($response->is_redirect);

#By default, we should get redirected!
$response =
  $ua->get($response->header("location"), 'Accept' => 'text/xml' );

die "error: failed to retrieve XML: " . $response->status_line . "\n"
  unless $response->is_success;


my $xmlRes = '';

$xmlRes .= $response->content;
my $xml_parser = XML::LibXML->new();
my $dom = $xml_parser->parse_string( $xmlRes );

my $root = $dom->documentElement();

my ( $entry ) = $root->getChildrenByTagName( 'data' );
my @hits  = $entry->getChildrenByTagName( 'hits' );

foreach my $hit (@hits){
  next if($hit->getAttribute( 'nincluded' ) == 0 );
  print $hit->getAttribute( 'name' )."\t".$hit->getAttribute( 'desc' )."\t".$hit->getAttribute( 'evalue' )."\n";
}