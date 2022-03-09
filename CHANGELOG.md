# Changelog

This is a [changelog](https://keepachangelog.com/en/1.0.0/).

This project attempts to follow [semantic versioning](https://semver.org/)

## Unreleased

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
