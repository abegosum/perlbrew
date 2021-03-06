# == Class: perlbrew
#
# This class installs and configures perlbrew.
# It does not install any versions of Perl by default.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class perlbrew (

  $perlbrew_root      = $perlbrew::params::perlbrew_root,
  $perlbrew_init_file = $perlbrew::params::perlbrew_init_file,


) inherits perlbrew::params {

  # param validation

  class { 'perlbrew::install': } ->
  class { 'perlbrew::config': }
  
}
