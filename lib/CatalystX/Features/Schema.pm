use strict;
use warnings;

package CatalystX::Features::Schema;

our $VERSION = 1;
use base 'DBIx::Class::Schema';

__PACKAGE__->mk_classdata('config_features');
__PACKAGE__->mk_classdata('env_features');
__PACKAGE__->mk_classdata('db_features');

__PACKAGE__->load_components(qw/
  Helper::Schema::QuoteNames
  Helper::Schema::DidYouMean
  Helper::Schema::DateTime/);

__PACKAGE__->load_namespaces(
  default_resultset_class => "DefaultRS");

sub deploy {
  my $self = shift;
  $self->next::method(@_);
  $self->setup;
}

sub setup {
  my $self = shift;
  $self->reload_db_features;
}

sub flags {
  my $self = shift;
  my %flags = (
    %{$self->config_features||+{}},
    %{$self->env_features||+{}},
    %{$self->db_features||+{}},
  );
  return %flags;
}

sub reload_db_features {
  my $self = shift;
  my %features = map {
    $_->key => $_->value
  } $self->resultset('Flag')->all;

  $self->db_features(\%features);
}

sub set_feature_overrides {
  my ($self, %args) = @_;
  my %flags = %{$self->config_features};
  foreach my $key(keys %args) {
    if(exists $flags{$key}) {
      $self->resultset('Flag')
        ->update_or_create({key=>$key, value=>$args{$key}});
    } else {
      die "Feature Flag '$key' is not allowed; Can't set!";
    }
  }
  $self->reload_db_features;
}

sub remove_feature_overrides {
  my ($self, @args) = @_;
  my %flags = %{$self->config_features};
  foreach my $key(@args) {
    if(exists $flags{$key}) {
      $self->resultset('Flag')
        ->find({key=>$key})
        ->delete;
    } else {
      die "Feature Flag '$key' is not allowed; Can't remove!";
    }
  }
  $self->reload_db_features;
}

1;

