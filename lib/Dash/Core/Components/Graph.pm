# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Graph;

use Moo;
use strictures 2;
use Dash::Core::Components;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'responsive' => (
  is => 'rw'
);
has 'clickData' => (
  is => 'rw'
);
has 'clickAnnotationData' => (
  is => 'rw'
);
has 'hoverData' => (
  is => 'rw'
);
has 'clear_on_unhover' => (
  is => 'rw'
);
has 'selectedData' => (
  is => 'rw'
);
has 'relayoutData' => (
  is => 'rw'
);
has 'extendData' => (
  is => 'rw'
);
has 'restyleData' => (
  is => 'rw'
);
has 'figure' => (
  is => 'rw'
);
has 'style' => (
  is => 'rw'
);
has 'className' => (
  is => 'rw'
);
has 'animate' => (
  is => 'rw'
);
has 'animation_options' => (
  is => 'rw'
);
has 'config' => (
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
