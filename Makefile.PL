use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'         => 'PWD::PwBasic',
    'VERSION_FROM' => 'PwBasic.pm', # finds $VERSION
    'AUTHOR'       => 'Henk Boonstra <root@widexl.com>',
);
