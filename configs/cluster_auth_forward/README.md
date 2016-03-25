External Authentication
=======================

Tested with:
	JBoss EAP 7 Beta
	Apache httpd 2.4
	mod_cluster with AJP modules from EAP 7 Beta

In this example a user is authenticated in Apache httpd and the username is propagated to Wildfly.
The username is displayed in the Java-Application.
Aditionally there was the reqirement that the user from a trusted VPN-connection to httpd is forwarded to JBoss.
The username is contained in a HTTP-Header. In order to propate the user via AJP, the user must be logged-in to apache. 
This is done with a custom PerlAccessHandler. See httpd/cluster_auth_forward/

Konfig in Apache:

PerlRequire /var/www/html/perl_modules/startup.pl
<Location /AuthForward>
    PerlSetVar SetUserHeaderName X-VPN-User
    PerlAccessHandler ApacheAuthTrusted::SetUser
</Location>

Was hier innerhalb Location steht gehört in den Virtual Host, in den die Trusted Connection mit dem User im HTTP-Header reinkommt. Den Header (hier X-VPN-User) musst du entsprechend anpassen.
Das Perl-Modul ApacheAuthTrusted liegt bei und muss installiert werden. Je nachdem wo es installiert wird, muss der Pfad in startup.pl angepasst werden. Dafür gibt es eventuell sauberere Lösungen.
Zum Testen kannst du folgendes installieren:

<Location /printUser>
    PerlSetVar SetUserHeaderName X-VPN-User
    PerlAccessHandler ApacheAuthTrusted::SetUser
    SetHandler perl-script
    PerlResponseHandler  ApacheAuthTrusted::PrintUser
</Location>

dann sollte ein Curl-Aufruf folgendes Ergebnis liefern:

curl  -H "X-VPN-User: hans" http://localhost/printUser
Existing User is: hans
Looking for 'PerlSetVar SetUserHeaderName myHeaderName'
myHeaderName is: X-VPN-User
User from request-Header X-VPN-User is: hans



Der Aufruf ueber die Java-Applikation liefert:

curl -H "X-VPN-User: hans"  http://localhost/AuthForward/

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Secure App</title>
</head>
<body>

        Start Fri Mar 25 10:19:52 CET 2016
 <br />
        Hello hans!<br />

        Ende <br />

</body>
</html>
