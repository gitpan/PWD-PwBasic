# PWD::PwBasic
#
# Henk Boonstra, <root@widexl.com>
# http://www.widexl.com
#
# 7 May 2001 - created
#
# Copyright 2001 Henk Boonstra. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
#
#############

require Exporter;
use vars qw(@ISA $VERSION);
@ISA = qw(Exporter);
$VERSION = "0.13";

##########################
# Return the password line
##########################
sub pwd_basic {
my($usr, $pwd) = @_;
$ht_err = "";

if (!$usr) {$ht_err = "No username";return 0;};
if (!$pwd) {$ht_err = "No password";return 0;};

if ($^O  eq 'MSWin32') {$htl = "$usr:$pwd"}

else {
 $salt = join '', ('.', '/',0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64];
 $basic_pwd = crypt($pwd, $salt);
 $htl = "$usr:$basic_pwd";
}

return $htl;
}

###############################
# Add user to the password file
###############################
sub add_pwd_basic {
my($usr, $pwd, $pwf) = @_;
$ht_err = "";

if (!$usr) {$ht_err = "No username";return 0;};
if (!$pwd) {$ht_err = "No password";return 0;};
if (!$pwf) {$ht_err = "No password file";return 0;};
#return "0" if (!$usr);
#return "0" if (!$pwd);
#return "0" if (!$pwf);

$res = dup_pwd_basic($usr, $pwf);
if (!$res) {$ht_err = "Duplicate username";return 0;};

 $line = pwd_basic($usr, $pwd);

return "0" if (!$line);

 open (DT,">>$pwf");
if ($^O  ne 'MSWin32') {flock(DT, 2)}
 print DT "$line\n";
 close(DT);

return 1;
}

################################
# Remove user from password file
################################
sub rm_pwd_basic {
my($usr, $pwf) = @_;
$ht_err = "";

if (!$usr) {$ht_err = "No username";return 0;};
if (!$pwf) {$ht_err = "No password file";return 0;};
#return "0" if (!$usr);
#return "0" if (!$pwf);

 open (DT,"<$pwf");
if ($^O  ne 'MSWin32') {flock(DT, 2)}
 @pwdf = <DT>;
 close(DT);

 open (PW,">$pwf");
if ($^O  ne 'MSWin32') {flock(PW, 2)}
foreach $ln(@pwdf) {@pwl = split(/\:/,$ln);
if ($usr ne $pwl[0]) {
 chomp($ln);
 print PW "$ln\n";
 }
}
 close(PW);

return 1;
}

#################
# Update the User
#################
sub upd_pwd_basic {
my($usr, $nusr, $pwd, $pwf) = @_;
$ht_err = "";

if (!$usr) {$ht_err = "No username";return 0;};
if (!$nusr) {$ht_err = "No new username";return 0;};
if (!$pwd) {$ht_err = "No password";return 0;};
if (!$pwf) {$ht_err = "No password file";return 0;};

#return "0" if (!$usr);
#return "0" if (!$nusr);
#return "0" if (!$pwd);
#return "0" if (!$pwf);

if ($usr ne $nusr) {
$res = dup_pwd_basic($nusr, $pwf);
if (!$res) {$ht_err = "Duplicate username";return 0;};
}

 open (DT,"<$pwf");
if ($^O  ne 'MSWin32') {flock(DT, 2)}
 @pwdf = <DT>;
 close(DT);

 open (PW,">$pwf");
if ($^O  ne 'MSWin32') {flock(PW, 2)}
foreach $ln(@pwdf) {@pwl = split(/\:/,$ln);
if ($pwl[0] eq $usr) {
if ($^O  ne 'MSWin32') {
 $pwl[0] = $nusr;
 $pwl[1] = $pwd;
}
else {
 $salt = join '', ('.', '/',0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64];
 $pwl[0] = $nusr;
 $pwl[1] = crypt($pwd, $salt);
 }
}
 $nln = join ("\:",@pwl);
 chomp($nln);
 print PW "$nln\n";
}
 close(PW);

return 1;
}

####################
# Duplicate username
####################
sub dup_pwd_basic {
my($usr, $pwf) = @_;
$ht_err = "";

 open (DT,"<$pwf");
if ($^O  ne 'MSWin32') {flock(DT, 2)}
 @pwdf = <DT>;
 close(DT);

foreach $ln(@pwdf) {
@pwl = split(/\:/,$ln);
if ($pwl[0] eq $usr) {return 0;}
}

return 1;
}


1;
__END__

=head1 NAME

PWD::PwBasic  - Perl interface to edit the Apache .htpasswd file.

=head1 SYNOPSIS

 $user = "UserName";
 $nuser = "NewUserName";
 $pass = "PassWord";
 $passfile = "/www/members/.htpasswd";

 require PWD::PwBasic;

 # Return the line to add in the .htpasswd file for AuthType Basic.
 $pass = pwd_basic($user, $pass);

 # Add the user to the .htpasswd file for AuthType Basic.
 $add_pass = add_pwd_basic($user, $pass, $passfile);

 # Remove the user from the .htpasswd file for AuthType Basic.
 $rm_pass = rm_pwd_basic($user, $passfile);

 # Update the user in the .htpasswd file for AuthType Basic.
 $upd_pass = upd_pwd_basic($user, $nuser, $pass, $passfile);

 # Check for duplicate username for AuthType Basic.
 $dup_pass = dup_pwd_basic($user, $passfile);

=head1 DESCRIPTION

 $user = The username
 $nuser = The new username
 $pass = The password from the user
 $realm = The 'AuthName' in the .htaccess file
 $passfile = The password file where to store the passwords (.htpasswd)

=cut
