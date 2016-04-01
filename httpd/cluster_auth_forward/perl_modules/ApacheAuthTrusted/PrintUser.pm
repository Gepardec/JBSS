  package ApacheAuthTrusted::PrintUser;
  
  use strict;
  use warnings;
  
  use Apache2::RequestRec ();
  use Apache2::RequestIO ();
  use Apache2::RequestUtil ();
  use APR::Table (); 

  use Apache2::Const -compile => qw(OK);
  
  sub handler {
      my $r = shift;
  
      $r->content_type('text/plain');

      my $user = $r->user;
      if ( $user ){
        print "Existing User is: $user\n";
      }
      else{
          print "No existing user!\n";
      }

      print "Looking for 'PerlSetVar SetUserHeaderName myHeaderName'\n";
      my $myHeaderName = $r->dir_config('SetUserHeaderName');
      if ( $myHeaderName ){
        print "myHeaderName is: $myHeaderName\n";
      }
      else{
          print "PerlSetVar for SetUserHeaderName is not configured!\n";
      }
      print "Looking for 'PerlSetVar SetUserHeaderPattern myHeaderPattern'\n";
      my $myHeaderPattern = $r->dir_config('SetUserHeaderPattern');
      if ( $myHeaderPattern ){
        print "myHeaderPattern is: $myHeaderPattern\n";
      }
      else{
          print "PerlSetVar for SetUserHeaderPattern is not configured!\n";
      }
      my $headerUser = $r->headers_in->get($myHeaderName);
      if ( $headerUser ){
        print "User from request-Header $myHeaderName is: $headerUser\n";
      }
      else{
          print "Header $myHeaderName is not set in request!\n";
      }
      if ( $headerUser and my $pattern = $r->dir_config('SetUserHeaderPattern') ){
        if ( $headerUser =~ /$pattern/ ){
	    $headerUser = $1;
            print "Pattern match: $headerUser\n";
        }
        else{
            print "No pattern match!\n";
        }
      }
  
      return Apache2::Const::OK;
  }
  1;
