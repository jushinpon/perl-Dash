# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::LogoutButton;

use Moo;
use strictures 2;
use Dash::Core::Components;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'label' => (
  is => 'rw'
);
has 'logout_url' => (
  is => 'rw'
);
has 'style' => (
  is => 'rw'
);
has 'method' => (
  is => 'rw'
);
has 'className' => (
  is => 'rw'
);
has 'loading_state' => (
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
