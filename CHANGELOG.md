# Changelog

This is a [changelog](https://keepachangelog.com/en/0.3.0/).

This project attempts to follow [semantic versioning](https://semver.org/)

## Unreleased

* nada

## 1.0.1 - 2018-06-19

* big fixes
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
