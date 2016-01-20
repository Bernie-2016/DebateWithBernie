# DebateWithBernie

Make your own #DebateWithBernie image.

## Development

### Prerequisites

* git
* ruby 2.2.3 ([rvm](https://rvm.io/) recommended)
* [postgres](http://www.postgresql.org/) (`brew install postgres` on OSX)

### Setup

1. Clone the repository (`git clone git@github.com:Bernie-2016/DebateWithBernie.git`)
2. Install gem dependencies: `bundle install`
3. Create and migrate the database: `rake db:setup`
4. Create a `.env` file for OAuth keys, formatted as follows. Create a test Facebook app and an S3 bucket/IAM user to get credentials.
5. Run `rails s` and visit [http://localhost:3000](http://localhost:3000) in your browser

```
FB_APP_ID=id
S3_BUCKET_NAME=bucket
AWS_ACCESS_KEY_ID=key
AWS_SECRET_ACCESS_KEY=secret
```

### Testing

* Todo - write some tests :)
* `bundle exec rubocop` for linting

## Contributing

1. Fork it ( https://github.com/Bernie-2016/DebateWithBernie/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

[AGPL](http://www.gnu.org/licenses/agpl-3.0.en.html)
