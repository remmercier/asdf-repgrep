#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/acheronfail/repgrep"
TOOL_NAME="repgrep"
TOOL_TEST="rgr --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename
	version="$1"
	filename="$2"
	url="$GH_REPO/archive/${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

check_rust_dependencies() {
	echo "* Checking Rust dependencies..."
	if ! command -v cargo >/dev/null 2>&1; then
		fail "cargo (Rust package manager) is required but not installed. Please install Rust from https://rustup.rs/"
	fi
	if ! command -v rustc >/dev/null 2>&1; then
		fail "rustc (Rust compiler) is required but not installed. Please install Rust from https://rustup.rs/"
	fi
	echo "* Rust dependencies found"
}

compile_source() {
	local source_path="$1"
	echo "* Compiling $TOOL_NAME from source using Cargo..."
	(
		cd "$source_path"
		cargo build --release || fail "Failed to compile $TOOL_NAME with cargo"
	) || fail "Could not compile $TOOL_NAME"
	echo "* Compilation completed successfully"
}

install_binary() {
	local source_path="$1"
	local install_path="$2"
	local binary_name="$3"

	echo "* Installing $TOOL_NAME binary..."
	mkdir -p "$install_path"

	local source_binary="$source_path/target/release/$binary_name"
	local target_binary="$install_path/$binary_name"

	if [ ! -f "$source_binary" ]; then
		fail "Compiled binary not found at $source_binary"
	fi

	cp "$source_binary" "$target_binary" || fail "Failed to copy binary to install path"
	chmod +x "$target_binary" || fail "Failed to make binary executable"

	echo "* Binary installed successfully at $target_binary"
}

cleanup_build() {
	local source_path="$1"
	echo "* Cleaning up build artifacts..."
	(
		cd "$source_path"
		if [ -d "target" ]; then
			rm -rf target
			echo "* Build artifacts cleaned up"
		fi
	) || echo "* Warning: Could not clean up build artifacts"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	echo "* Starting $TOOL_NAME $version installation from source..."

	(
		# Check dependencies
		check_rust_dependencies

		# Compile from source
		compile_source "$ASDF_DOWNLOAD_PATH"

		# Install binary
		install_binary "$ASDF_DOWNLOAD_PATH" "$install_path" "bat"

		# Verify installation
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		# Clean up build artifacts
		cleanup_build "$ASDF_DOWNLOAD_PATH"

		echo "* $TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

