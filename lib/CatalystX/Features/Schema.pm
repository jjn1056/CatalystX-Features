use strict;
use warnings;

package CatalystX::Features::Schema;

our $VERSION = 1;
use base 'DBIx::Class::Schema';

__PACKAGE__->load_components(qw/
  Helper::Schema::QuoteNames
  Helper::Schema::DidYouMean
  Helper::Schema::DateTime/);

__PACKAGE__->load_namespaces(
  default_resultset_class => "DefaultRS");

sub setup {
  my $self = shift;
  $self->populate(
    Race => [
      ['label'],
      ['human'],
    ]);
}

1;

