#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;

use Dash;
use aliased 'Dash::Core::Components' => 'dcc';
use aliased 'Dash::Html::Components' => 'html';

my $external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css'];

my $app = Dash->new(app_name => 'Dash Tutorial - 2 Layout', external_stylesheets=>$external_stylesheets);

$app->layout( html->Div(children=>[
    html->H1(children=>'Hello Dash'),

    html->Div(children=>'
        Dash: A web application framework for Python, R & Perl!.
    '),

    dcc->Graph(
        id=>'example-graph',
        figure=>{
            data=> [
                {'x'=> [1, 2, 3], 'y'=> [4, 1, 2], 'type'=> 'bar', 'name'=> 'SF'},
                {'x'=> [1, 2, 3], 'y'=> [2, 4, 5], 'type'=> 'bar', 'name'=> 'Montréal'},
            ],
            layout=> {
                'title'=> 'Dash Data Visualization'
            }
        }
    )
]));

$app->run_server();

