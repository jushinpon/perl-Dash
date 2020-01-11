# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Location;

use Moo;
use strictures 2;
use Dash::Core::Components;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'pathname' => (
  is => 'rw'
);
has 'search' => (
  is => 'rw'
);
has 'hash' => (
  is => 'rw'
);
has 'href' => (
  is => 'rw'
);
has 'refresh' => (
  is => 'rw'
);
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Dash::Core::Components::_js_dist;
}

1;
