# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Slider;

use Moo;
use strictures 2;
use Dash::Core::Components;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'marks' => (
  is => 'rw'
);
has 'value' => (
  is => 'rw'
);
has 'className' => (
  is => 'rw'
);
has 'disabled' => (
  is => 'rw'
);
has 'dots' => (
  is => 'rw'
);
has 'included' => (
  is => 'rw'
);
has 'min' => (
  is => 'rw'
);
has 'max' => (
  is => 'rw'
);
has 'tooltip' => (
  is => 'rw'
);
has 'step' => (
  is => 'rw'
);
has 'vertical' => (
  is => 'rw'
);
has 'verticalHeight' => (
  is => 'rw'
);
has 'updatemode' => (
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
