# Contributing

Fork the repo:

`git clone git@github.com:ether-moon/activerecord-trilogy2rgeo-adapter.git`

Set up your test database:

```sh
mysql --user root
grant all on trilogy2rgeo_adapter_test.* to trilogy2rgeo_adapter_test@localhost identified by 'trilogy2rgeo_adapter_test';
grant all on trilogy2rgeo_tasks_test.* to trilogy2rgeo_adapter_test@localhost identified by 'trilogy2rgeo_adapter_test';
create database trilogy2rgeo_adapter_test;
create database trilogy2rgeo_tasks_test;
```

You may also set up environment variables to define the database connection.
See `test/database.yml` for which variables are used. All are optional.
For example:

```sh
export MYSQL_HOST=localhost
export MYSQL_PORT=3306
export MYSQL_DATABASE=trilogy2rgeo_adapter_test
export MYSQL_USER=trilogy2rgeo_adapter_test
export MYSQL_PASSWORD=trilogy2rgeo_adapter_test
```

Install dependencies:

```sh
bundle install
```

Make sure the tests pass:

`bundle exec rake`

Run tests against the test gemfiles:

run `rake appraisal` or run the tests manually:

```
BUNDLE_GEMFILE=./gemfiles/ar70.gemfile bundle
BUNDLE_GEMFILE=./gemfiles/ar70.gemfile rake
```

Make your changes and submit a pull request.

Note: the master branch targets the latest version of Active Record. To submit
a pull request for a prior version, be sure to branch from the correct version
(for example, 4.0-stable). Also be sure to set the target branch of the pull
request to that version (for example, 4.0-stable).
