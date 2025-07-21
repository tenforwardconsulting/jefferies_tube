# Changelog

This is a [changelog](https://keepachangelog.com/en/1.0.0/).

This project attempts to follow [semantic versioning](https://semver.org/)

## Unreleased

## 1.7.4
  * If RSpec is not defined, run `rails test` and `rails test:system` in default rake task

## 1.7.3
  * Bugfix: change `exists?` to `exist?` in `s3_assets.rb`

## 1.7.2
  * Bugfix: update 404 and 500 pages to have .html.erb variants, not just .haml

## 1.7.1
  * Bugfix: change `exists?` to `exist?` and check for `existing_spec_helper` file
  * Update robocop rules

## 1.7.0
  * Sync static_assets as part of upload_assets_to_s3

## 1.6.9
  * Refactor checking for JT_RSPEC environment variable when starting simplecov; prepends env var to rails application's spec_helper if
    that line does not already exist.

## 1.6.8
  * Add support for ignoring CVEs in .bundler-audit.yml, remove support for setting ignored CVEs in deploy.rb via `:bundler_audit_ignore`

## 1.6.7
  * Add Lint/Syntax to rubocop rules

## 1.6.6
  * Fix to paths for remote cap tasks that caused execjs to fail in some circumstances

## 1.6.5
  * Add Application Decision Record generator

  * More Rubocop rules regarding whitespace and indentation consistency
    * Layout/EmptyLineBetweenDefs
    * Layout/EmptyLinesAroundArguments
    * Layout/EmptyLinesAroundBlockBody
    * Layout/IndentationConsistency
## 1.6.4
  New Rubocop Rules!
  * Style/IndentationConsistency: Makes sure indentiation is correct
  * Layout/EmptyLines: Max of one empty line in a row
  * Rails/HasManyOrHasOneDependent: All has_many associations must have a depedent option
  * Rails/ActionFilter: Enforces use of \_action instead of \_filter in controllers
  * Rails/AddColumnIndex: Fixes use of index: true on add_column which does nothing
  * Rails/AfterCommitOverride: Don't define 2 after_commit since they override
  * Rails/CreateTableWithTimestamps: All tables should have timestamps columns
## 1.6.3.2
  Bugfix: Typo :(
## 1.6.3.1
  Bugfix: Check if Rspec is defined
## 1.6.3
  Skip simplecov unless running default rake task
## 1.6.2
  Make sure simplecov still generates the HTML report
## 1.6.1
  Silence debugger logs
## 1.6.0
  Default rake task that runs rspec with simlecov and rubocop!
## 1.5.4
  Fix a bug in the prompt if Pry is present.
## 1.5.3
  * Minor tweaks to the IRB console when sshing.  Don't use JT IRB locally
## 1.5

* enhancements
  * Add rails:allthelogs capistrano command to tail all of the rails logs at once.

## 1.4

* enhancements
  * Rails 6.1 support - fix deprecations and outdated gem dependencies.

## 1.3

* enhancements
  * Remove `compass-rails` dependency.

## 1.2

* enhancements
  * Allow passing through bundler-audit ignore with `set :bundler_audit_ignore, ["CVE-1234-5678"]`

## 1.1.1

* enhancements
  * Add colorful IRB prompts based on Rails environment

## 1.0.5 - 2019-02-19

* enhancements
  * Require bundler-audit version ~> 0.6.1 in order to support Bundler version >= 2

* features
  * Add cap task for running arbitrary rake task on server. e.g. `cap dev rails:rake[flipper:synchronize_features]`.

## 1.0.4 - 2018-10-02

* bug fixes
  * Fix bug where webpack presence was not correct causing the manifest file to
    not be copied which caused webpack assets to not work (either the new
    version wouldn't be found or the old version would continue to be used).

## 1.0.3 - 2018-08-13

* features
  * Support for my.development.rb

## 1.0.2 - 2018-07-11

* bug fixes
  * Fix bug with webpacker integration preventing it from being enabled.

## 1.0.1 - 2018-06-19

* bug fixes
  * Fix bug with webpacker integration when using CDN where packs/manifest.json
    wasn't being copied to other servers.

## 1.0.0 - 2018-06-18

* breaking changes
  * The `upload_assets_to_s3` task's `s3_destination` used to be of the form
    `"s3://some-bucket-dev/assets"`. Now it is of the form
    `"s3://some-bucket-dev"`. The task appends `"/assets"` for you. It does this
    because if it detects webpack, it also appends `"/packs"` in order to upload
    both assets and packs directories next to each other.

## Version - Date

* breaking changes
  * enhancement A
  * enhancement B

* deprecations
  * deprecation A
  * deprecation B

* bug fixes
  * bug fix A
  * bug fix B

* enhancements
  * enhancement A
  * enhancement B

* features
  * feature A
  * feature B
