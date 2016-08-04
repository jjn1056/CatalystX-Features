package CatalystX::Features::Model;

use Moose;
extends 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(schema_class=>'CatalystX::Features::Schema');
__PACKAGE__->meta->make_immutable;
