package ApacheAuthTrusted::SetUser;

use strict;
use warnings;

use Apache2::RequestRec ();
use Apache2::RequestIO ();
use Apache2::RequestUtil ();
use APR::Table ();

use Apache2::Const -compile => qw(OK);

sub handler {
    my $r = shift;

    my $header = $r->headers_in->get(
              $r->dir_config('SetUserHeaderName'));
    if ( my $pattern = $r->dir_config('SetUserHeaderPattern') ){
    	if ( $header =~ /$pattern/ ){
	    $r->user($1);
        }
    }
    else{
    	$r->user($header);
    }

    return Apache2::Const::OK;
}
1;
