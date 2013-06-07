use Test::More;
use JSON::Builder;
use strict;

my $res;

# Basic
$res = json_build sub {
  json name => 'Magnus Holm';
  json score => 1000;
};
is $res, '{"name":"Magnus Holm","score":1000}';

# Nested
$res = json_build sub {
  my $user = { name => 'Magnus Holm' };
  json user => $user;
};
is $res, '{"user":{"name":"Magnus Holm"}}';

# Nested + code
$res = json_build sub {
  my $user = \"Magnus Holm";
  json user => $user, sub {
    json name => $$_;
  };
};
is $res, '{"user":{"name":"Magnus Holm"}}';

# Nested without value
$res = json_build sub {
  my $user = \"Magnus Holm";
  json user => sub {
    json name => $$user;
  };
};
is $res, '{"user":{"name":"Magnus Holm"}}';

# Array
$res = json_build sub {
  json users => [1, 2, 3];
};
is $res, '{"users":[1,2,3]}';

# Array + code
$res = json_build sub {
  json users => ['Bob', 'Tim'], sub {
    json name => $_;
  };
};
is $res, '{"users":[{"name":"Bob"},{"name":"Tim"}]}';

# Selected keys
$res = json_build sub {
  my $user = { name => 'Bob', password => 'bobrules1' };
  json user => $user, qw(name);
};
is $res, '{"user":{"name":"Bob"}}';

# Selected keys for arrays
$res = json_build sub {
  my $user = { name => 'Bob', password => 'bobrules1' };
  json users => [$user], qw(name);
};
is $res, '{"users":[{"name":"Bob"}]}';

# Top-level array
$res = json_build ['Bob', 'Tim'], sub {
  json name => $_;
};
is $res, '[{"name":"Bob"},{"name":"Tim"}]';

# Merge
$res = json_build sub {
  json_merge { name => "Bob" };
};
is $res, '{"name":"Bob"}';

done_testing;

