# bqto Pro releases

This repository holds the downloads of bqto Pro and its Mac app. The repository has
no source code.

bqto Pro is the paid edition of [bqto](https://bqto.dev). bqto Pro reaches private
Google Cloud services from your laptop and from CI.

## 1. Get a key

Buy a seat at [bqto.dev](https://bqto.dev). A seat is one person. You get your
license key on the page after you pay and in your Polar customer portal.

## 2. Install

bqto Pro, on macOS or Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/pilef-co/bqto-pro-releases/main/install.sh | sh
```

The script installs `bqto` in `/usr/local/bin`. If that folder needs your password, the
script asks for it. To use another folder, set `BQTO_INSTALL_DIR`. If you have the
free bqto from Homebrew, remove it first: `brew uninstall --cask bqto`.

The Mac app:

```sh
curl -fsSL https://raw.githubusercontent.com/pilef-co/bqto-pro-releases/main/install.sh | sh -s -- --app
```

With Homebrew, the first line installs bqto Pro and the second the Mac app:

```sh
brew install --cask pilef-co/tap/bqto-pro
brew install --cask pilef-co/tap/bqto-app
```

## 3. Activate

```sh
bqto license activate YOUR-KEY
```

In the app, enter the key when it asks. In GitHub Actions (CI), give
[bqto-action](https://github.com/pilef-co/bqto-action) `edition: pro` and the
key in `license-key`.

Without a valid key, bqto Pro works as the free bqto.

## License

bqto Pro is proprietary software. Its use is subject to the
[bqto Pro terms](https://bqto.dev/eula).
