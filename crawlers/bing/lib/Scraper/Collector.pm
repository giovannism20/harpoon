package Scraper::Collector;

use strict;
use warnings;
use WWW::Mechanize;

sub new {
    my ($self, $string, $filter) = @_;

    my $mech = WWW::Mechanize -> new();
    my %seen = ();
    my @urls = ();

    my $dork = $filter =~ s/\$string/$string/r;

    for (my $page = 0; $page <= 10; $page++) {
        my $url = "http://www.bing.com/search?q=" . $dork . "&first=" . $page . "0";
                        
        $mech -> get($url);
        my @links = $mech -> links();
                        
        foreach my $link (@links) {
            $url = $link -> url();
            next if $seen{$url}++;

            if ($url =~ m/^https?/ && $url !~ m/bing|live|microsoft|msn/) {
                push @urls, $url;
            }
        }
    }

    return @urls;
}

1;