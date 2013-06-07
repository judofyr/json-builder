package JSON::Builder;
use strict;
use warnings;

use Exporter 'import';
our @EXPORT = qw(json_build json json_merge);
our @EXPORT_OK = @EXPORT;

use Mojo::JSON;
my $JSON = Mojo::JSON->new;

our $scope;

sub json_build {
  my $value = _encode_value(@_);
  $JSON->encode($value);
}

sub json {
  my $key = shift;
  $scope->{$key} = _encode_value(@_);
}

sub json_merge {
  my $value = _encode_value(@_);
  $scope->{$_} = $value->{$_} for keys %$value;
}

sub _encode_value {
  my $code = pop if ref $_[-1] eq 'CODE';
  my $value = shift;
  my $keys = [@_];

  if (ref $value eq 'ARRAY') {
    [_handle_values($code, $keys, @$value)];
  } else {
    my ($res) = _handle_values($code, $keys, $value);
    $res;
  }
}

sub _handle_values {
  my ($code, $keys, @values) = @_;
  map {
    my $value = $_;
    if ($code) {
      local $scope = {};
      &$code;
      $value = $scope;
    }

    _filter_keys($value, $keys);
  } @values;
}

sub _filter_keys {
  my ($value, $keys) = @_;

  if (ref $value eq 'HASH' && @$keys) {
    return { map { $_ => $value->{$_} } @$keys };
  } else {
    $value;
  }
}

1;

