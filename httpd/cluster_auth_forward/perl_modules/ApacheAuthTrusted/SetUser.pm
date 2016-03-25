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

    $r->user(
          $r->headers_in->get(
              $r->dir_config('SetUserHeaderName')));

    return Apache2::Const::OK;
}
1;
