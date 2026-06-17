# Copyright Built On Envoy
# SPDX-License-Identifier: Apache-2.0
# The full text of the Apache license is available in the LICENSE file at
# the root of the repo.

class Boe < Formula
  desc "CLI for Built on Envoy"
  homepage "https://builtonenvoy.io"
  version "0.6.1"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/built-on-envoy.git", branch: "main"

  base_url = "https://github.com/tetratelabs/built-on-envoy/releases/download/v#{version}"

  SHAS = {
    "darwin_amd64" => "d6a73d561e71301d3beb91e319b06397225138686eb5e6975edd206894620ada",
    "darwin_arm64" => "9076c4ef703f64c4c3af833c652328d7c0fe9670c8901c6c0a14452593522089",
    "linux_amd64"  => "7d1bf25142ce6fd866d0c9178a8fc35747eeffcc8df36a49f83d6883c197b788",
    "linux_arm64"  => "8cb0feb152d3e5cf17ec7ceeb15bbd6c9b2fe99a046b47a42f166a93742969ac",
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
