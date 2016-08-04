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
  my %flags = %{$self->config_features};
  foreach my $key(keys %flags) {
    $self->resultset('Flag')
      ->update_or_create({key=>$key,value=>0});
  }
}

sub flags {
  my $self = shift;
  my %flags = (
    %{$self->config_features||+{}},
    %{$self->env_features||+{}});
  return %flags;
}

sub set_features {
  my ($self, %args) = @_;
  use Devel::Dwarn;
  Dwarn $self->resultset('Flag')->first;
  foreach my $key(keys %args) {
    #$self->resultset('Flag')
    # ->find({key=>$key});;
  }
}

1;

