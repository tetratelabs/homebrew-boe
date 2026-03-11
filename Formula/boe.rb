# Copyright Built On Envoy
# SPDX-License-Identifier: Apache-2.0
# The full text of the Apache license is available in the LICENSE file at
# the root of the repo.

class Boe < Formula
  desc "CLI for Built on Envoy"
  homepage "https://builtonenvoy.io"
  version "0.1.1"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/built-on-envoy.git", branch: "main"

  base_url = "https://github.com/tetratelabs/built-on-envoy/releases/download/v#{version}"

  SHAS = {
    "darwin_amd64" => "2304aa9b7331dd0ce178a2d66efe0701ce7df4a94d9b04bddaa70f0dac736bd2",
    "darwin_arm64" => "9e2ab3323cda4ae2a3011b3ba3b58c68a5c0873d270cb94e7bc752746ea06a83",
    "linux_amd64"  => "33afd0c9da0cd2c5a85fbee5bf47054395b4d18f78ae3521297b0f479698e4a0",
    "linux_arm64"  => "d848e0ab1a3005c3b47addd758336c8d1e373a7bed0bee9ee050badfc95447c7",
  }.freeze

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  on_macos do
    on_arm do
      url "#{base_url}/boe-darwin-arm64"
      sha256 SHAS["darwin_arm64"]
    end
    on_intel do
      url "#{base_url}/boe-darwin-amd64"
      sha256 SHAS["darwin_amd64"]
    end
  end

  on_linux do
    on_arm do
      url "#{base_url}/boe-linux-arm64"
      sha256 SHAS["linux_arm64"]
    end
    on_intel do
      url "#{base_url}/boe-linux-amd64"
      sha256 SHAS["linux_amd64"]
    end
  end

  def install
    if build.head?
      system "make", "-C", "cli", "clean", "build"
      bin.install Dir["cli/out/boe-*"].first => "boe"
      @built_sha = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
    else
      bin.install Dir["boe-*"].first => "boe"
    end
  end

  test do
    if build.head?
      # TODO(nacx): move out when the version command is available.
      output = shell_output("BOE_STATE_HOME=/tmp/boe #{bin}/boe version")
      assert_match(/Built On Envoy CLI: #{@built_sha}/, output)
    else
      system bin/"boe", "-h"
      # TODO(nacx): Version 0.1.0 does not yet have the "version" command.
      # Use this assertion once the next version is released.
      # assert_match("Built On Envoy CLI: v#{version}", output)
    end
  end
end
