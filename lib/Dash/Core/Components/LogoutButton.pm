# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::LogoutButton;

use Dash::Core::Components;
use Mojo::Base 'Dash::BaseComponent';

has 'id';
has 'label';
has 'logout_url';
has 'style';
has 'method';
has 'className';
has 'loading_state';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Dash::Core::Components::_js_dist;
}

1;