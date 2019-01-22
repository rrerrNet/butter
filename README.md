# butter

A dumb Matrix bot.  May contain traces of nuts.

Does nothing useful for now, except for responding to `!ping` requests \\o/

## Installation

Install `crystal` using your favourite package manager as guided by the [Crystal
docs][crystal_install].  After that, building butter should be as easy as:

```sh
shards build
```

The resulting binary is then located in `./bin/butter`.

**macOS Mojave note**: You may run into an error saying the compiler could not
find OpenSSL.  To fix that, install `openssl` from Homebrew and point
`PKG_CONFIG_PATH` to OpenSSL's pkgconfig directory:

```sh
# zsh, bash:
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig

# tcsh:
setenv PKG_CONFIG_PATH /usr/local/opt/openssl/lib/pkgconfig
```

## Usage

Copy the `config.example.yml` to `config.yml` and modify it to your needs.
Then... just run it! (after you've built it of course, see _Installation_
section above on how to do that)

```sh
# Authenticate with your home server for the first time
./bin/butter -c config.yml

# Once you got your access token and exported the MATRIX_ACCESS_TOKEN variable,
# run it again to start the bot:
./bin/butter -c config.yml
```

Once the bot is running, invite it to a channel and try running some commands,
such as `!ping`.

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/rrerrNet/butter/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Georg Gadinger](https://github.com/nilsding) - creator and maintainer

[crystal_install]: https://crystal-lang.org/docs/installation
