# JSON::Builder

A JSON builder inspired by [Jbuilder](https://github.com/rails/jbuilder).

Example:

```perl
use JSON::Builder;

my $res = json_build {
  json content => $self->format_content($message->content);
  json_merge $message->content, qw(created_at updated_at);

  json author => sub {
    json name => $message->author->name->familiar;
    json email_address => $message->author->email_address_with_name;
    json url => $self->url_for('...');
  };

  if ($self->current_user->is_admin) {
    json visitors => $self->calculate_visitors($message);
  }

  json comments => $message->comments, qw(content created_at);

  json attachments => $message->attachments, sub {
    json filename => $_->filename;
    json url => $self->url_for('...');
  };
};
```

This will build the following structure:

```html
{
  "content": "<p>This is <i>serious</i> monkey business</p>",
  "created_at": "2011-10-29T20:45:28-05:00",
  "updated_at": "2011-10-29T20:45:28-05:00",

  "author": {
    "name": "David H.",
    "email_address": "'David Heinemeier Hansson' <david@heinemeierhansson.com>",
    "url": "http://example.com/users/1-david.json"
  },

  "visitors": 15,

  "comments": [
    { "content": "Hello everyone!", "created_at": "2011-10-29T20:45:28-05:00" },
    { "content": "To you my good sir!", "created_at": "2011-10-29T20:47:28-05:00" }
  ],

  "attachments": [
    { "filename": "forecast.xls", "url": "http://example.com/downloads/forecast.xls" },
    { "filename": "presentation.pdf", "url": "http://example.com/downloads/presentation.pdf" }
  ]
}
```

