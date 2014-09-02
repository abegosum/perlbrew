# == Class: perlbrew::perl
#
# This class installs a version of Perl using Perlbrew.
#
# === Parameters
#
# Document parameters here.
#
# [*perlbrew_root*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# [*version*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# [*compile_options*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# === Examples
#
# === Authors
#
# Chadwick Banning <walkamongus@users.noreply.github.com>
#
class perlbrew::perl (

  $perlbrew_root   = $perlbrew::params::perlbrew_root,
  $version         = '5.16.3',
  $compile_options = '',

) {
  
  include ::perlbrew

  exec {"install_perl_${version}":
    environment => [
      "PERLBREW_ROOT=${perlbrew_root}",
      'PERLBREW_HOME=/tmp/.perlbrew',
      'HOME=/opt',
    ],
    command  => "source ${perlbrew_root}/etc/bashrc; ${perlbrew_root}/bin/perlbrew install perl-${version} ${compile_options}",
    creates  => "${perlbrew_root}/perls/perl-${version}/bin/perl",
    provider => shell,
    timeout  => 0,
    require  => [ Class['perlbrew::install'], Class['perlbrew::config'], ],
  }

  exec {"switch_to_perl_${version}":
    command  => "source /etc/profile; ${perlbrew_root}/bin/perlbrew switch perl-${version}",
    provider => shell,
    unless   => "perl -e 'print $^V' | grep v${version}",
    require  => Exec["install_perl_${version}"],
  }

  exec{'install_cpan':
    command => "/usr/bin/curl -L http://cpanmin.us | ${perlbrew_root}/perls/perl-${version}/bin/perl - App::cpanminus",
    creates => "${perlbrew_root}/perls/perl-${version}/bin/cpanm",
    require => Exec["switch_to_perl_${version}"],
  }

}