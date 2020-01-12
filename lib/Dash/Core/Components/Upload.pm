# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Upload;

use Moo;
use strictures 2;
use Dash::Core::ComponentsAssets;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'contents' => (
  is => 'rw'
);
has 'filename' => (
  is => 'rw'
);
has 'last_modified' => (
  is => 'rw'
);
has 'children' => (
  is => 'rw'
);
has 'accept' => (
  is => 'rw'
);
has 'disabled' => (
  is => 'rw'
);
has 'disable_click' => (
  is => 'rw'
);
has 'max_size' => (
  is => 'rw'
);
has 'min_size' => (
  is => 'rw'
);
has 'multiple' => (
  is => 'rw'
);
has 'className' => (
  is => 'rw'
);
has 'className_active' => (
  is => 'rw'
);
has 'className_reject' => (
  is => 'rw'
);
has 'className_disabled' => (
  is => 'rw'
);
has 'style' => (
  is => 'rw'
);
has 'style_active' => (
  is => 'rw'
);
has 'style_reject' => (
  is => 'rw'
);
has 'style_disabled' => (
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
    return Dash::Core::ComponentsAssets::_js_dist;
}

1;
