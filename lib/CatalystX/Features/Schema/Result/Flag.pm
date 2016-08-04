use strict;
use warnings;

package CatalystX::Features::Schema::Result::Flag;

use base 'CatalystX::Features::Schema::Result';

__PACKAGE__->table('flag');
__PACKAGE__->add_columns(
  flag_id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },
  key => {
    data_type => 'varchar',
    size => '64',
  },
  value => {
    data_type => 'boolean',
  }
);

__PACKAGE__->set_primary_key('flag_id');
__PACKAGE__->add_unique_constraint([ 'key' ]);

1;

=head1 TITLE

CatalystX::Features::Schema::Result::Flag - A Feature Flag 

=head1 DESCRIPTION

  TDB

=head1 RELATIONSHIPS

  TDB

=head1 METHODS

  TBD

=head1 AUTHORS & COPYRIGHT

See L<CatalystX::Features>.

=head1 LICENSE

See L<CatalystX::Features>.

=cut
