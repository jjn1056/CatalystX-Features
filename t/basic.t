use Test::Most;

BEGIN {
  package MyApp::Schema::User;
  $INC{'MyApp/Schema/User.pm'} = __FILE__;

  use base 'DBIx::Class::Core';
 
  __PACKAGE__->table("users");
  __PACKAGE__->add_columns(
    id => { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    first_name => { data_type => "varchar", size => 100 });

  __PACKAGE__->set_primary_key("id");
  __PACKAGE__->add_unique_constraint([ qw/first_name/ ]);

  package MyApp::Schema;
  $INC{'MyApp/Schema.pm'} = __FILE__;

  use base 'DBIx::Class::Schema';
 
  __PACKAGE__->load_classes('User');
}

{
  package MyApp::Model::Schema;
  $INC{'MyApp/Model/Schema.pm'} = __FILE__;

  use Moose;
  extends 'Catalyst::Model::DBIC::Schema';

  package MyApp::Controller::Example;
  $INC{'MyApp/Controller/Example.pm'} = __FILE__;

  use base 'Catalyst::Controller';

  sub user :Local Args(1) {
    my ($self, $c) = @_;

    use Devel::Dwarn;
    Dwarn( +{$c->model("Features")->flags} );

    $c->model("Features")->set_features("feature3", 1);
    Dwarn( +{$c->model("Features")->flags} );

    $c->res->body('test');
  }

  package MyApp;
  use Catalyst;
  use Test::DBIx::Class
    -schema_class => 'MyApp::Schema', qw/User Schema/;

  User->populate([
    ['id','first_name'],
    [ 1 => 'john'],
    [ 2 => 'joe'],
    [ 3 => 'mark'],
    [ 4 => 'matt'],
  ]);

  __PACKAGE__->inject_components(
    'Model::Features' => { from_component => 'CatalystX::Features::Model'});

  MyApp->config(
    'Model::Features' => {
      connect_info => [ sub { Schema()->storage->dbh } ],
      features => {
        feature1 => 1,
        feature2 => 0,
        feature3 => 0,
        feature4 => 0,
      },
    },
    'Model::Schema' => {
      schema_class => 'MyApp::Schema',
      connect_info => [ sub { Schema()->storage->dbh } ],
    },
  );

  MyApp->setup;
  MyApp->model('Features')->schema->deploy;

}

BEGIN { $ENV{MYAPP_FEATURE2} = 1 }
use Catalyst::Test 'MyApp';

{
  my ($res, $c) = ctx_request( '/example/user/1' );
}

done_testing;
