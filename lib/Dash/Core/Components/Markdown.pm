# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Markdown;

use Moo;
use strictures 2;
use Dash::Core::Components;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'className' => (
  is => 'rw'
);
has 'dangerously_allow_html' => (
  is => 'rw'
);
has 'children' => (
  is => 'rw'
);
has 'dedent' => (
  is => 'rw'
);
has 'highlight_config' => (
  is => 'rw'
);
has 'loading_state' => (
  is => 'rw'
);
has 'style' => (
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
