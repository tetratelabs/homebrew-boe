# Copyright Built On Envoy
# SPDX-License-Identifier: Apache-2.0
# The full text of the Apache license is available in the LICENSE file at
# the root of the repo.

class Boe < Formula
  desc "CLI for Built on Envoy"
  homepage "https://builtonenvoy.io"
  version "0.6.0"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/built-on-envoy.git", branch: "main"

  base_url = "https://github.com/tetratelabs/built-on-envoy/releases/download/v#{version}"

  SHAS = {
    "darwin_amd64" => "09d742fe736166757cb23726cb8e26f5135dd1ec04d11ec22561dd06f782334e",
    "darwin_arm64" => "fde38f79f393d551560b16e3745fe886bdeace556414e1e5167234c1bd9341af",
    "linux_amd64"  => "33f40390399d6126f17a065a1acdcc1d568a34dd137cf2d0a3ceedadc09bbba4",
    "linux_arm64"  => "9d0fecac6ba41b5f1a9d0564639a704f58d0eb73ec3ccbf692015171592ff016",
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
