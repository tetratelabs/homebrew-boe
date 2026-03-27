# Copyright Built On Envoy
# SPDX-License-Identifier: Apache-2.0
# The full text of the Apache license is available in the LICENSE file at
# the root of the repo.

class Boe < Formula
  desc "CLI for Built on Envoy"
  homepage "https://builtonenvoy.io"
  version "0.2.0"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/built-on-envoy.git", branch: "main"

  base_url = "https://github.com/tetratelabs/built-on-envoy/releases/download/v#{version}"

  SHAS = {
    "darwin_amd64" => "65dc5ea7d37082a44ed2798458db778f44ddd280783e9765ecba4507f27512a9",
    "darwin_arm64" => "76366645e47b9ecd5ad2131001061bc9b34d28985facd0719cfb11b9df11bcee",
    "linux_amd64"  => "bebde74a4d45797b279cbf569c8260f3d6427c17b53ef4e960b3887f6d6c93f3",
    "linux_arm64"  => "88204eab1370f72603c8e8cb40611bf35378e5efbcfd591bf216312e5def67ff",
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
