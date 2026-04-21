# Copyright Built On Envoy
# SPDX-License-Identifier: Apache-2.0
# The full text of the Apache license is available in the LICENSE file at
# the root of the repo.

class Boe < Formula
  desc "CLI for Built on Envoy"
  homepage "https://builtonenvoy.io"
  version "0.4.0"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/built-on-envoy.git", branch: "main"

  base_url = "https://github.com/tetratelabs/built-on-envoy/releases/download/v#{version}"

  SHAS = {
    "darwin_amd64" => "ed920ee574f33364977002821b0547e3141481bca6e12ead368e89ee5190b291",
    "darwin_arm64" => "4aa3abf4de75c1b129236af5baac7e622b83ef4c94255cbf8721d92a96770f50",
    "linux_amd64"  => "a266e75cbf126de4eb4b218ac1eda8885a381441a96d076aa3f899739e0c77cc",
    "linux_arm64"  => "19481924e586b39813718666d1321c466ec49a3d6d783b41f16e81b26a5d32c8",
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
    output = shell_output("BOE_STATE_HOME=/tmp/boe #{bin}/boe version")
    if build.head?
      assert_match(/Built On Envoy CLI: #{@built_sha}/, output)
    else
      assert_match("Built On Envoy CLI: v#{version}", output)
    end
  end
end
