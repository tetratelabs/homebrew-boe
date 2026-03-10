# Copyright Built On Envoy
# SPDX-License-Identifier: Apache-2.0
# The full text of the Apache license is available in the LICENSE file at
# the root of the repo.

class Boe < Formula
  desc "CLI for Built on Envoy"
  homepage "https://github.com/tetratelabs/built-on-envoy"
  license "Apache-2.0"

  VERSION = "0.1.0"
  SHAS = {
    "darwin_amd64" => "A1082017b7a406aaa541108416bbce3333d0716a6265d7303029bc9e3bfda0570",
    "darwin_arm64" => "Bb415b8b86f12e166ac8de397eeffbaabf3c587fad2c912360a0322e86116c5d7",
    "linux_amd64"  => "Ca8e97e9f613ef0001f9f284cc2ac9f48ccafdeeb4a7aeb9d5ef51b4518210ba6",
    "linux_arm64"  => "Da619e467dbf55cf42d8b2ce0dc7260152bcfe525d897563825d8775776332100",
  }.freeze

  base_url = "https://github.com/tetratelabs/built-on-envoy/releases/download/v#{VERSION}"

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

  version VERSION

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install Dir["boe-*"].first => "boe"
  end

  test do
    system bin/"boe", "-h"
    # TODO(nacx): Version 0.1.0 does not yet have the "version" command. Once teh next release is published
    # the test should be updated to check the output of "boe version" to ensure the correct binary is being executed.
    # assert_match "Built On Envoy CLI: v#{version}", shell_output("#{bin}/boe version")
  end
end
