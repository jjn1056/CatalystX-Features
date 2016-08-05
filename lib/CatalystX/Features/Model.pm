package CatalystX::Features::Model;

use Moose;
use Catalyst::Utils;
extends 'Catalyst::Model::DBIC::Schema';

sub BUILD {
  my ($self, $args) = @_;
  $self->next::method($args);
  $self->schema->config_features($args->{features});
} 

sub ACCEPT_CONTEXT {
  my ($self, $ctx) = @_;
  $self->populate_env_features($ctx)
    unless $self->schema->env_features;
  if(ref $ctx) {
    my $clone = $self->clone(
      ctx=>$ctx,
      env_features=>$self->schema->env_features,
      config_features=>$self->schema->config_features,
    );
    $clone->connection( @{$self->storage->connect_info});
    return $clone;
  } else {
    return $self;
  }
}

sub populate_env_features {
  my ($self, $ctx) = @_;
  my $app = ref $ctx || $ctx;
  my %env_features = ();
  foreach my $key(%{$self->schema->config_features}) {
    my $env_value = Catalyst::Utils::env_value($app, uc $key);
    $env_features{$key} = $env_value if $env_value;
  }
  $self->schema->env_features(\%env_features);
}

__PACKAGE__->config(schema_class=>'CatalystX::Features::Schema');
__PACKAGE__->meta->make_immutable;
