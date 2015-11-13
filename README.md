# DebateWithBernie
 
Make your own #DebateWithBernie image.

## Requirements

* [postgres](http://www.postgresql.org/) (`brew install postgres` on OSX)

## Setup

* Clone the repository
* `bundle install`
* `rake db:create && rake db:migrate`
* `RAILS_ENV=test rake db:create && rake db:migrate`
* Create a `.env` file for OAuth keys, formatted as follows. Create test apps to get credentials.

```
FACEBOOK_KEY=key
FACEBOOK_SECRET=secret
```

## Testing

* `bundle exec rspec` for integration tests
* `bundle exec rubocop` for linting
