package Dash;

use strict;
use warnings;
use 5.020;

# VERSION

# ABSTRACT: Analytical Web Apps in Perl (Port of Plotly's Dash to Perl)

# TODO Enable signatures?

use Mojo::Base 'Mojolicious';
use JSON;
use Browser::Open;
use File::ShareDir;
# TODO Use Mojo::File (Mojo::Path) instead of Path::Tiny
# # TODO Use Mojo::File (Mojo::Path) instead of Path::Tiny
use Path::Tiny;
use Dash::Renderer;

# TODO Add ci badges

=pod

=encoding utf8

=head1 DESCRIPTION

This package is a port of L<Plotly's Dash|https://dash.plot.ly/> to Perl. As
the official Dash doc says: I<Dash is a productive Python framework for building web applications>. 
So this Perl package is a humble atempt to ease the task of building data visualization web apps in Perl.

The ultimate goal of course is to support everything that the Python version supports.

The use will follow, as close as possible, the Python version of Dash so the Python doc can be used with
minor changes:

=over 4

=item * Use of -> (arrow operator) instead of .

=item * Main package and class for apps is Dash

=item * Component suites will use Perl package convention, I mean: dash_html_components will be Dash::Html::Components, although for new component suites you could use whatever package name you like

=item * Instead of decorators we'll use plain old callbacks

=item * Instead of Flask we'll be using L<Mojolicious> (Maybe in the future L<Dancer2>)

=back

In the SYNOPSIS you can get a taste of how this works and also in L<the examples folder of the distribution|https://metacpan.org/release/Dash> or directly in L<repository|https://github.com/pablrod/perl-Dash/tree/master/examples>

=head2 Components

This package ships the following component suites and are ready to use:

=over 4

=item * L<Dash Core Components|https://dash.plot.ly/dash-core-components> as Dash::Core::Components

=item * L<Dash Html Components|https://dash.plot.ly/dash-html-components> as Dash::Html::Components

=item * L<Dash DataTable|https://dash.plot.ly/datatable> as Dash::Table

=back

The plan is to make the packages also for L<Dash-Bio|https://dash.plot.ly/dash-bio>, L<Dash-DAQ|https://dash.plot.ly/dash-daq>, L<Dash-Canvas|https://dash.plot.ly/canvas> and L<Dash-Cytoscape|https://dash.plot.ly/cytoscape>.

=head3 Using the components

Every component has a class of its own. For example dash-html-component Div has the class: L<Dash::Html::Components::Div> and you can use it the perl standard way:

    use Dash::Html::Components::Div;
    ...
    $app->layout(Dash::Html::Components::Div->new(id => 'my-div', children => 'This is a simple div'));

But with every component suite could be a lot of components. So to ease the task of importing them (one by one is a little bit tedious) we could use two ways:

=head4 Factory methods

Every component suite has a factory method for every component. For example L<Dash::Html::Components> has the factory method Div to load and build a L<Dash::Html::Components::Div> component:

    use Dash::Html::Components;
    ...
    $app->layout(Dash::Html::Components->Div(id => 'my-div', children => 'This is a simple div'));

But this factory methods are meant to be aliased so this gets less verbose:

    use aliased 'Dash::Html::Components' => 'html';
    ...
    $app->layout(html->Div(id => 'my-div', children => 'This is a simple div'));


=head4 Functions

Many modules use the L<Exporter> & friends to reduce typing. If you like that way every component suite gets a Functions package to import all this functions
to your namespace.

So for example for L<Dash::Html::Components> there is a package L<Dash::Html::ComponentsFunctions> with one factory function to load and build the component with the same name:

    use Dash::Html::ComponentsFunctions;
    ...
    $app->layout(Div(id => 'my-div', children => 'This is a simple div'));

    

=head1 SYNOPSIS

# EXAMPLE: examples/basic_callbacks.pl

# EXAMPLE: examples/random_chart.pl

=cut

has app_name => __PACKAGE__;

has external_stylesheets => sub { [] };

has layout => sub { {} };

has callbacks => sub { [] };

has '_rendered_scripts' => "";

has '_rendered_external_stylesheets' => "";

sub callback {
    my $self     = shift;
    my %callback = @_;

    # TODO check_callback
    push @{ $self->callbacks }, \%callback;
    return $self;
}

sub startup {
    my $self = shift;

    my $renderer = $self->renderer;
    push @{ $renderer->classes }, __PACKAGE__;


    my $r = $self->routes;
    $r->get(
        '/' => sub {
            my $c = shift;
            $c->stash(
                stylesheets => $self->_rendered_stylesheets,
                external_stylesheets => $self->_rendered_external_stylesheets,
                scripts => $self->_rendered_scripts,
                title => $self->app_name);
            $c->render( template => 'index' );
        }
    );

    my $dist_name = 'Dash';
    $r->get('/_dash-component-suites/:namespace/*asset' => sub {
            # TODO Component registry to find assets file in other dists
            my $c = shift;
            my $file = $self->_filename_from_file_with_fingerprint($c->stash('asset'));

            $c->reply->file(File::ShareDir::dist_file($dist_name, Path::Tiny::path('assets', $c->stash('namespace'), $file)->canonpath ));
        } 
    );

    $r->get(
        '/_favicon.ico' => sub {
            my $c = shift;
            $c->reply->file( File::ShareDir::dist_file($dist_name, 'favicon.ico'));
        }
    );

    $r->get(
        '/_dash-layout' => sub {
            my $c = shift;
            $c->render(
                        json => $self->layout()
            );
        }
    );

    $r->get(
        '/_dash-dependencies' => sub {
            my $c            = shift;
            my $dependencies = [];
            for my $callback ( @{ $self->callbacks } ) {
                my $rendered_callback = { clientside_function => JSON::null };
                my $states             = [];
                for my $state ( @{ $callback->{State} } ) {
                    my $rendered_state = { id       => $state->{component_id},
                                           property => $state->{component_property}
                    };
                    push @$states, $rendered_state;
                }
                $rendered_callback->{state} = $states;
                my $inputs            = [];
                for my $input ( @{ $callback->{Inputs} } ) {
                    my $rendered_input = { id       => $input->{component_id},
                                           property => $input->{component_property}
                    };
                    push @$inputs, $rendered_input;
                }
                $rendered_callback->{inputs} = $inputs;
                $rendered_callback->{'output'} =
                  join( '.', $callback->{'Output'}{component_id}, $callback->{'Output'}{component_property} );
                push @$dependencies, $rendered_callback;
            }
            $c->render(
                json => $dependencies
            );
        }
    );

    $r->post(
        '/_dash-update-component' => sub {
            my $c = shift;

            my $request = $c->req->json;

            # Searching callbacks by 'changePropdIds'
            my $callbacks = $self->_search_callback( $request->{'changedPropIds'} );
            if ( scalar @$callbacks > 1 ) {
                die 'Not implemented multiple callbacks';
            } elsif ( scalar @$callbacks == 1 ) {
                my $callback           = $callbacks->[0];
                my @callback_arguments = ();
                for my $callback_input ( @{ $callback->{Inputs} } ) {
                    my ( $component_id, $component_property ) = @{$callback_input}{qw(component_id component_property)};
                    for my $change_input ( @{ $request->{inputs} } ) {
                        my ( $id, $property, $value ) = @{$change_input}{qw(id property value)};
                        if ( $component_id eq $id && $component_property eq $property ) {
                            push @callback_arguments, $value;
                            last;
                        }
                    }
                }
                for my $callback_input ( @{ $callback->{State} } ) {
                    my ( $component_id, $component_property ) = @{$callback_input}{qw(component_id component_property)};
                    for my $change_input ( @{ $request->{state} } ) {
                        my ( $id, $property, $value ) = @{$change_input}{qw(id property value)};
                        if ( $component_id eq $id && $component_property eq $property ) {
                            push @callback_arguments, $value;
                            last;
                        }
                    }
                }
                my $updated_value    = $callback->{callback}(@callback_arguments);
                my $updated_property = ( split( /\./, $request->{output} ) )[-1];
                my $props_updated    = { $updated_property => $updated_value };
                $c->render( json => { response => { props => $props_updated } } );
            } else {
                $c->render( json => { response => "There is no registered callbacks"} );
            }
        }
    );

    return $self;
}

sub run_server {
    my $self = shift;

    $self->_render_and_cache_scripts();
    $self->_render_and_cache_external_stylesheets();

    # Opening the browser before starting the daemon works because
    #  open_browser returns inmediately
    # TODO Open browser optional
    Browser::Open::open_browser('http://127.0.0.1:8080');
    $self->start('daemon', '-l', 'http://*:8080');
}

sub _search_callback {
    my $self             = shift;
    my $changed_prop_ids = shift;

    my $callbacks          = $self->callbacks;
    my @matching_callbacks = ();
    for my $changed_prop_id (@$changed_prop_ids) {
        for my $callback (@$callbacks) {
            my $inputs = $callback->{Inputs};
            for my $input (@$inputs) {
                if ( $changed_prop_id eq join( '.', @{$input}{qw(component_id component_property)} ) ) {
                    push @matching_callbacks, $callback;
                    last;
                }
            }
        }
    }

    return \@matching_callbacks;
}

sub _rendered_stylesheets {
    return '';
}

sub _render_external_stylesheets {
    my $self = shift;
    my $stylesheets = $self->external_stylesheets;
    my $rendered_external_stylesheets = "";
    for my $stylesheet (@$stylesheets) {
        $rendered_external_stylesheets .= '<link rel="stylesheet" href="' . $stylesheet . '">' . "\n";
    }
    return $rendered_external_stylesheets;
}

sub _render_and_cache_external_stylesheets {
    my $self = shift;
    my $stylesheets = $self->_render_external_stylesheets();
    $self->_rendered_external_stylesheets($stylesheets);
}

sub _render_and_cache_scripts {
    my $self = shift;
    my $scripts = $self->_render_scripts();
    $self->_rendered_scripts($scripts);
}

sub _render_dash_config {
    return
            '<script id="_dash-config" type="application/json">{"url_base_pathname": null, "requests_pathname_prefix": "/", "ui": false, "props_check": false, "show_undo_redo": false}</script>';
}

sub _dash_renderer_js_dependencies {
    my $js_dist_dependencies = Dash::Renderer::_js_dist_dependencies();
    my @js_deps = ();
    for my $deps (@$js_dist_dependencies) {
        my $external_url = $deps->{external_url};
        my $relative_package_path = $deps->{relative_package_path};
        my $namespace = $deps->{namespace};
        my $dep_count = 0;
        for my $dep (@{$relative_package_path->{prod}}) {
            my $js_dep = {
                namespace => $namespace,
                relative_package_path => $dep,
                dev_package_path => $relative_package_path->{dev}[$dep_count],
                external_url => $external_url->{prod}[$dep_count]
                };
            push @js_deps, $js_dep;
            $dep_count++;
        }
    }
     \@js_deps;
}

sub _dash_renderer_js_deps {
    return Dash::Renderer::_js_dist();
}

sub _render_dash_renderer_script {
    return '<script id="_dash-renderer" type="application/javascript">var renderer = new DashRenderer();</script>';
}

sub _render_scripts {
    my $self = shift;

    # First dash_renderer dependencies
    my $scripts_dependencies = $self->_dash_renderer_js_dependencies;

    # Traverse layout and recover javascript dependencies
    # TODO auto register dependencies on component creation to avoid traversing and filter too much dependencies
    my $layout = $self->layout;

    my $visitor;
    my $stack_depth_limit = 1000;
    $visitor = sub {
        my $node = shift;
        my $stack_depth = shift;
        if ($stack_depth++ >= $stack_depth_limit) {
            # TODO warn user that layout is too deep
            return;
        }
        my $type = ref $node;
        if ($type eq 'HASH') {
            for my $key (keys %$node) {
                $visitor->($node->{$key}, $stack_depth);
            }
        } elsif ($type eq 'ARRAY') {
            for my $element (@$node) {
                $visitor->($element, $stack_depth);
            }
        } elsif ( $type ne '') {
            my $node_dependencies = $node->_js_dist();
            push @$scripts_dependencies, @$node_dependencies if defined $node_dependencies;
            if ($node->can('children')) {
                $visitor->($node->children, $stack_depth);
            }
        }
    };

    $visitor->($layout, 0);
   
    my $rendered_scripts = "";
    $rendered_scripts .= $self->_render_dash_config();
    push @$scripts_dependencies, @{$self->_dash_renderer_js_deps()};
    # TODO Avoid duplicates (Order?)
    my $filtered_resources = $self->_filter_resources($scripts_dependencies);
    for my $dep (@$filtered_resources) {
        my $dynamic = $dep->{dynamic} // 0;
        if (! $dynamic ) {
            $rendered_scripts .= '<script src="/' . join("/", '_dash-component-suites', $dep->{namespace}, $dep->{relative_package_path}) . '"></script>' . "\n";
        }
    }
    $rendered_scripts .= $self->_render_dash_renderer_script();

    return $rendered_scripts;
}

sub _filter_resources {
    my $self = shift;
    my $resources = shift;
    my %params = @_;
    my $dev_bundles = $params{dev_bundles} // 0;
    my $eager_loading = $params{eager_loading} // 0;
    my $serve_locally = $params{serve_locally} // 1;

    my $filtered_resources = [];
    for my $resource (@$resources) {
        my $filtered_resource = {};
        my $dynamic = $resource->{dynamic};
        if (defined $dynamic) {
            $filtered_resource->{dynamic} = $dynamic;
        }
        my $async = $resource->{async};
        if (defined $async) {
            if (defined $dynamic) {
                die "A resource can't have both dynamic and async: " + to_json($resource); 
            }
            my $dynamic = 1;
            if ($async eq 'lazy') {
                $dynamic = 1; 
            } else {
                if ($async eq 'eager' && !$eager_loading) {
                    $dynamic = 1;
                } else {
                    if ($async && !$eager_loading) {
                        $dynamic = 1;
                    } else {
                        $dynamic = 0;
                    }
                }
            }
            $filtered_resource->{dynamic} = $dynamic;
        }
        my $namespace = $resource->{namespace};
        if (defined $namespace) {
            $filtered_resource->{namespace} = $namespace;
        }
        my $external_url = $resource->{external_url};
        if (defined $external_url && ! $serve_locally) {
            $filtered_resource->{external_url} = $external_url;
        } else {
            my $dev_package_path = $resource->{dev_package_path};
            if (defined $dev_package_path && $dev_bundles) {
                $filtered_resource->{relative_package_path} = $dev_package_path;
            } else {
                my $relative_package_path = $resource->{relative_package_path};
                if (defined $relative_package_path) {
                    $filtered_resource->{relative_package_path} = $relative_package_path;
                } else {
                    my $absolute_path = $resource->{absolute_path};
                    if (defined $absolute_path) {
                        $filtered_resource->{absolute_path} = $absolute_path;
                    } else {
                        my $asset_path = $resource->{asset_path};
                        if (defined $asset_path) {
                            my $stat_info = path($resource->{filepath})->stat;
                            $filtered_resource->{asset_path} = $asset_path;
                            $filtered_resource->{ts} = $stat_info->mtime;
                        } else {
                            if ($serve_locally) {
                                warn 'There is no local version of this resource. Please consider using external_scripts or external_stylesheets : ' + to_json($resource);
                                next;
                            } else {
                                die 'There is no relative_package-path, absolute_path or external_url for this resource : ' + to_json($resource);
                            }
                        }
                    }
                }
            }
        }

        push @$filtered_resources, $filtered_resource;
    }
    return $filtered_resources;
}

sub _filename_from_file_with_fingerprint {
    my $self = shift;
    my $file = shift;
    my @path_parts = split(/\//, $file);
    my @name_parts = split(/\./, $path_parts[-1]);

    # Check if the resource has a fingerprint
    if ((scalar @name_parts) > 2 && $name_parts[1] =~ /^v[\w-]+m[0-9a-fA-F]+$/) {
        my $original_name = join(".", $name_parts[0], @name_parts[2 .. (scalar @name_parts - 1)]);
        $file = join("/", @path_parts[0 .. (scalar @path_parts - 2) ], $original_name);
    }

    return $file;
}

1;

=head1 STATUS

At this moment this library is experimental and still under active
development and the API is going to change!

The intent of this release is to try, test and learn how to improve it.

If you want to help, just get in contact! Every contribution is welcome!


=head1 DISCLAIMER

This is an unofficial Plotly Perl module. Currently I'm not affiliated in any way with Plotly. 
But I think Dash is a great library and I want to use it with perl.

If you like Dash please consider supporting them purchasing professional services: L<Dash Enterprise|https://plot.ly/dash/>

=head1 SEE ALSO

=over 4

=item L<Dash|https://dash.plot.ly/>

=item L<Dash Repository|https://github.com/plotly/dash>

=item L<Chart::Plotly>

=item L<Chart::GGPlot>

=item L<Alt::Data::Frame::ButMore>

=item L<AI::MXNet>

=cut

__DATA__

@@ index.html.ep
% layout 'default';
% title 'Renderer';
<div id="react-entry-point">
    <div class="_dash-loading">
        Loading...
    </div>
</div>

        <footer>
            <%== $scripts %>
        </footer>


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta charset="UTF-8">
        <title><%= $title %></title>
        <link rel="icon" type="image/x-icon" href="/_favicon.ico?v=1.7.0">
        <%== $stylesheets %>
        <%== $external_stylesheets %>
    </head>
    <body>
        
  <%= content %>
    </body>
</html>


