# bqto Pro releases

This repository holds the downloads of bqto Pro and its Mac app. It has no
source code.

bqto Pro is the paid edition of [bqto](https://bqto.dev). It reaches private
Google Cloud services from your laptop and from CI.

## 1. Get a key

Buy a seat at [bqto.dev](https://bqto.dev). You get your license key on the
page after you pay and by email.

## 2. Install

bqto Pro, on macOS or Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/pilef-co/bqto-pro-releases/main/install.sh | sh
```

The Mac app:

```sh
curl -fsSL https://raw.githubusercontent.com/pilef-co/bqto-pro-releases/main/install.sh | sh -s -- --app
```

With Homebrew:

```sh
brew install --cask pilef-co/tap/bqto-pro
brew install --cask pilef-co/tap/bqto-app
```

## 3. Activate

```sh
bqto license activate YOUR-KEY
```

In the app, enter the key when it asks. In GitHub Actions, pass the key to
[bqto-action](https://github.com/pilef-co/bqto-action) in `license-key`.

Without a valid key, bqto Pro works as the free bqto.

## License

bqto Pro is proprietary software. Its use is subject to the
[bqto Pro terms](https://bqto.dev/eula).
