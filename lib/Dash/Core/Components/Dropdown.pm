# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Dropdown;

use Dash::Core::Components;
use Mojo::Base 'Dash::BaseComponent';

has 'id';
has 'options';
has 'value';
has 'optionHeight';
has 'className';
has 'clearable';
has 'disabled';
has 'multi';
has 'placeholder';
has 'searchable';
has 'search_value';
has 'style';
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