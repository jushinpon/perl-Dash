# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Dropdown;

use Moo;
use strictures 2;
use Dash::Core::Components;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'options' => (
  is => 'rw'
);
has 'value' => (
  is => 'rw'
);
has 'optionHeight' => (
  is => 'rw'
);
has 'className' => (
  is => 'rw'
);
has 'clearable' => (
  is => 'rw'
);
has 'disabled' => (
  is => 'rw'
);
has 'multi' => (
  is => 'rw'
);
has 'placeholder' => (
  is => 'rw'
);
has 'searchable' => (
  is => 'rw'
);
has 'search_value' => (
  is => 'rw'
);
has 'style' => (
  is => 'rw'
);
has 'loading_state' => (
  is => 'rw'
);
has 'persistence' => (
  is => 'rw'
);
has 'persisted_props' => (
  is => 'rw'
);
has 'persistence_type' => (
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
