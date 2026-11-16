#!/bin/sh
# Installs bqto Pro:      curl -fsSL https://raw.githubusercontent.com/pilef-co/bqto-pro-releases/main/install.sh | sh
# Installs the Mac app:   curl -fsSL https://raw.githubusercontent.com/pilef-co/bqto-pro-releases/main/install.sh | sh -s -- --app
# BQTO_VERSION=0.12.0 picks a release, BQTO_INSTALL_DIR a folder for bqto (default /usr/local/bin),
# and GITHUB_TOKEN avoids GitHub's rate limit for anonymous requests.
set -eu

main() {
	repo=pilef-co/bqto-pro-releases
	what=cli
	[ "${1:-}" = --app ] && what=app

	fail() {
		echo "error: $1" >&2
		echo "Fix: $2" >&2
		exit 1
	}

	command -v curl >/dev/null || fail "curl is not installed" "install curl and run this again"

	get() {
		if [ -n "${GITHUB_TOKEN:-}" ]; then
			curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" "$@"
		else
			curl -fsSL "$@"
		fi
	}

	if [ "$what" = app ]; then
		[ "$(uname -s)" = Darwin ] || fail "the bqto app runs on macOS, not on $(uname -s)" "install the bqto command instead: drop --app"
		prefix=app-v
	else
		case $(uname -s) in
		Darwin) os=darwin ;;
		Linux) os=linux ;;
		*) fail "bqto Pro runs on macOS and Linux, not on $(uname -s)" "use a Mac or Linux machine, or WSL on Windows" ;;
		esac
		case $(uname -m) in
		x86_64 | amd64) arch=amd64 ;;
		arm64 | aarch64) arch=arm64 ;;
		*) fail "bqto Pro has no build for $(uname -m)" "use an amd64 or arm64 machine" ;;
		esac
		prefix=v
	fi

	api=https://api.github.com/repos/$repo/releases
	if [ -n "${BQTO_VERSION:-}" ]; then
		tag=$prefix${BQTO_VERSION#v}
		release=$(get "$api/tags/$tag") || fail "no release $tag" "pick one from https://github.com/$repo/releases"
	else
		releases=$(get "$api?per_page=30") || fail "could not read the releases from GitHub" "check your connection, or set GITHUB_TOKEN when GitHub limits requests from your address"
		tag=$(printf '%s\n' "$releases" | sed -n "s/^    \"tag_name\": \"\(${prefix}[^\"]*\)\",\$/\1/p" | head -n 1)
		[ -n "$tag" ] || fail "no $what release yet" "see https://github.com/$repo/releases"
		release=$(get "$api/tags/$tag") || fail "could not read release $tag" "run it again"
	fi
	version=${tag#"$prefix"}

	asset() {
		url=$(printf '%s\n' "$release" | grep -B3 "\"name\": \"$1\"" | sed -n 's/^ *"url": "\(.*\)",$/\1/p' | head -n 1)
		[ -n "$url" ] || fail "release $tag has no $1" "download it from https://github.com/$repo/releases"
		get -H "Accept: application/octet-stream" -o "$tmp/$1" "$url"
	}

	tmp=$(mktemp -d)
	trap 'rm -rf "$tmp"' EXIT
	if [ "$what" = app ]; then
		file=Bqto.app.zip
	else
		file=bqto-pro_${version}_${os}_${arch}.tar.gz
	fi
	asset "$file"
	asset checksums.txt

	want=$(grep " $file\$" "$tmp/checksums.txt" | cut -d' ' -f1)
	if command -v sha256sum >/dev/null; then
		got=$(sha256sum "$tmp/$file" | cut -d' ' -f1)
	else
		got=$(shasum -a 256 "$tmp/$file" | cut -d' ' -f1)
	fi
	[ -n "$want" ] && [ "$want" = "$got" ] || fail "the SHA-256 of $file does not match checksums.txt" "run it again; if it still fails, write to Pilef through https://bqto.dev"

	if [ "$what" = app ]; then
		dir=/Applications
		[ -w "$dir" ] || dir=$HOME/Applications
		mkdir -p "$dir"
		ditto -x -k "$tmp/$file" "$tmp/app"
		rm -rf "$dir/Bqto.app"
		mv "$tmp/app/Bqto.app" "$dir/Bqto.app"
		echo "installed the bqto app $version in $dir/Bqto.app"
		echo "next: open it, and enter your bqto Pro key if it asks"
		return
	fi

	dir=${BQTO_INSTALL_DIR:-/usr/local/bin}
	tar -xzf "$tmp/$file" -C "$tmp" bqto
	if [ -w "$dir" ] || { [ ! -e "$dir" ] && mkdir -p "$dir" 2>/dev/null; }; then
		mv "$tmp/bqto" "$dir/bqto"
	else
		echo "installing to $dir needs sudo" >&2
		sudo mkdir -p "$dir"
		sudo mv "$tmp/bqto" "$dir/bqto"
	fi
	echo "installed bqto Pro $version in $dir/bqto"
	found=$(command -v bqto || true)
	if [ -n "$found" ] && [ "$found" != "$dir/bqto" ]; then
		echo "warn: bqto runs $found first, not $dir/bqto; remove the other one (brew uninstall --cask bqto), or put $dir first on your PATH" >&2
	fi
	echo "next: bqto license activate YOUR-KEY"
	case ":$PATH:" in
	*":$dir:"*) ;;
	*) echo "warn: $dir is not on your PATH; add it, or run $dir/bqto" >&2 ;;
	esac
}

main "$@"
