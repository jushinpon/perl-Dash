# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::RangeSlider;

use Dash::Core::Components;
use Mojo::Base 'Dash::BaseComponent';

has 'id';
has 'marks';
has 'value';
has 'allowCross';
has 'className';
has 'count';
has 'disabled';
has 'dots';
has 'included';
has 'min';
has 'max';
has 'pushable';
has 'tooltip';
has 'step';
has 'vertical';
has 'verticalHeight';
has 'updatemode';
has 'loading_state';
has 'persistence';
has 'persisted_props';
has 'persistence_type';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Dash::Core::Components::_js_dist;
}

1;