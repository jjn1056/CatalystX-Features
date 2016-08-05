use strict;
use warnings;

package CatalystX::Features::Schema;

our $VERSION = 1;
use base 'DBIx::Class::Schema';

__PACKAGE__->mk_classdata('config_features');
__PACKAGE__->mk_classdata('env_features');

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
}

sub flags {
  my $self = shift;
  my %flags = (
    %{$self->config_features||+{}},
    %{$self->env_features||+{}},
    (map { $_->key => $_->value } 
      $self->resultset('Flag')->all),
  );
  return %flags;
}

sub set_features {
  my ($self, %args) = @_;
  my %flags = %{$self->config_features};
  foreach my $key(keys %args) {
    if(exists $flags{$key}) {
      $self->resultset('Flag')
        ->update_or_create({key=>$key, value=>$args{$key}});
    } else {
      die "Feature Flag '$key' is not allowed";
    }
  }
}

1;

