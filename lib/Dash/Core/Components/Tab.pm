# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Tab;

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
has 'children' => (
  is => 'rw'
);
has 'value' => (
  is => 'rw'
);
has 'disabled' => (
  is => 'rw'
);
has 'disabled_style' => (
  is => 'rw'
);
has 'disabled_className' => (
  is => 'rw'
);
has 'className' => (
  is => 'rw'
);
has 'selected_className' => (
  is => 'rw'
);
has 'style' => (
  is => 'rw'
);
has 'selected_style' => (
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
