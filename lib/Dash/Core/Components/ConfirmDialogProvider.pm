# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::ConfirmDialogProvider;

use Dash::Core::Components;
use Mojo::Base 'Dash::BaseComponent';

has 'id';
has 'message';
has 'submit_n_clicks';
has 'submit_n_clicks_timestamp';
has 'cancel_n_clicks';
has 'cancel_n_clicks_timestamp';
has 'displayed';
has 'children';
has 'loading_state';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Dash::Core::Components::_js_dist;
}

1;