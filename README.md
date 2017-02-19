[![CircleCI](https://circleci.com/gh/uu59/mitamae-cookbooks/tree/master.svg?style=svg)](https://circleci.com/gh/uu59/mitamae-cookbooks/tree/master)

# My MItamae cookbooks

Cookbooks for [MItamae](https://github.com/k0kubun/mitamae).

- [Orinal Itamae reference](https://github.com/itamae-kitchen/itamae/wiki)
- [Plugin for MItamae(not compatible for original Itamae)](https://github.com/k0kubun/mitamae/blob/master/PLUGINS.md)

# Testing

## The `verify` definition

All cookbooks should have `verify` to verify the result.

For example: a cookbook to create `"/foo/bar"` directory

```ruby
include_recipe "../core/verify.rb"

directory "/foo/bar"

verify <<-SH
  test -d "/foo/bar"
SH
```

Pass a shell script to `verify` to verify. That script' exit code must be zero (`$? -eq 0`), otherwise `verify` recognize it is failed or broken.

Note that the shell script will be added `-e` flag automatically. All command lines must exit with 0.

## Running test / develop a new cookbook

Just run `mitamae local [recipe file]` to test a cookbook. All cookbooks have a `verify` as above.

Docker is useful for a test. Following interaction is a good way to test from the ground:

```console
$ docker build -t mitamae-test .
$ docker run -v $PWD:/mitamae/repo mitamae-test ./mitamae local repo/cookbooks/git/default.rb
```

Also you can check the cookbook from Docker container as try-and-error approach:

```console
$ docker run -it -v $PWD:/mitamae/repo mitamae-test bash
root@3c99719d987b:/mitamae# ./mitamae local -l debug ./repo/cookbooks/git/default.rb
```

See [./test/](./test/) directory for a detail.
