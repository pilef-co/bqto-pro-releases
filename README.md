# bqto Pro releases

This repository holds the downloads of bqto Pro and its Mac app. The repository has
no source code.

bqto Pro is the paid edition of [bqto](https://github.com/pilef-co/bqto). bqto Pro reaches private
Google Cloud services from your laptop and from CI.

## 1. Get a key

Start a free trial or buy a seat on [bqto.dev](https://bqto.dev/#pro). A seat is one person. You get your
license key on the page after you pay and in your Polar customer portal.

## 2. Install

The script installs `bqto` in `/usr/local/bin`. If that folder needs your
password, the script asks for it. To use another folder, set `BQTO_INSTALL_DIR`.
It replaces a free bqto that is already in that folder. If you have the free
bqto from Homebrew, remove it first with `brew uninstall --cask bqto`. If
another bqto comes first on your PATH, the script tells you.

bqto Pro, on macOS or Linux, with curl:

```sh
curl -fsSL https://raw.githubusercontent.com/pilef-co/bqto-pro-releases/main/install.sh | sh
```

The Mac app, with curl:

```sh
curl -fsSL https://raw.githubusercontent.com/pilef-co/bqto-pro-releases/main/install.sh | sh -s -- --app
```

bqto Pro and the Mac app, with Homebrew:

```sh
brew install --cask pilef-co/tap/bqto-pro
brew install --cask pilef-co/tap/bqto-app
```

## 3. Activate

```sh
bqto license activate -
```

Paste your key, then press Ctrl-D. This way the key does not stay in your shell history.

The short form also works:

```sh
bqto license activate YOUR-KEY
```

In the app, enter the key when it asks.

Without a valid key, bqto Pro works as the free bqto.

## License

bqto Pro is proprietary software. Its use is subject to the
[bqto Pro terms](https://bqto.dev/eula).
