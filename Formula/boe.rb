# Copyright Built On Envoy
# SPDX-License-Identifier: Apache-2.0
# The full text of the Apache license is available in the LICENSE file at
# the root of the repo.

class Boe < Formula
  desc "CLI for Built on Envoy"
  homepage "https://builtonenvoy.io"
  version "0.7.0"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/built-on-envoy.git", branch: "main"

  base_url = "https://github.com/tetratelabs/built-on-envoy/releases/download/v#{version}"

  SHAS = {
    "darwin_amd64" => "f2b9d0347e7a439eb069946d0b5b4c2175b6baf600e1ea523568d827283b1e0b",
    "darwin_arm64" => "a508caf163fa8c328db311b23b875043a7b97fe9ee95ce3730a796b567dfe5c6",
    "linux_amd64"  => "6bb8ba0b986b35e3de8b0a5e27bf4e5a6016e1226d22c820bedb6bea579ba815",
    "linux_arm64"  => "3d031bff99d0a8e65ddfe554aa4b05b08a6a1c1d7534a94537778bc09eb1d926",
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
