# Copyright Built On Envoy
# SPDX-License-Identifier: Apache-2.0
# The full text of the Apache license is available in the LICENSE file at
# the root of the repo.

class Boe < Formula
  desc "CLI for Built on Envoy"
  homepage "https://github.com/tetratelabs/built-on-envoy"
  license "Apache-2.0"

  version "0.1.0"
  SHAS = {
    "darwin_amd64" => "a082017b7a406aaa541108416bbce3333d0716a6265d7303029bc9e3bfda0570",
    "darwin_arm64" => "a415b8b86f12e166ac8de397eeffbaabf3c587fad2c912360a0322e86116c5d7",
    "linux_amd64"  => "a8e97e9f613ef0001f9f284cc2ac9f48ccafdeeb4a7aeb9d5ef51b4518210ba6",
    "linux_arm64"  => "a619e467dbf55cf42d8b2ce0dc7260152bcfe525d897563825d8775776332100",
  }

  base_url = "https://github.com/tetratelabs/built-on-envoy/releases/download/v#{version}"

  os   = OS.kernel_name.downcase
  arch = case Hardware::CPU.type
         when :arm   then "arm64"
         when :intel then "amd64"
         else
           raise "Unsupported architecture"
         end

  url "#{base_url}/boe-#{os}-#{arch}"
  sha256 SHAS["#{os}_#{arch}"]

  def install
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "boe-#{os}-#{arch}" => "boe"
  end

  test do
    system "#{bin}/boe", "-h"
    # TODO(nacx): Version 0.1.0 does not yet have the "version" command. Once teh next release is published
    # the test should be updated to check the output of "boe version" to ensure the correct binary is being executed.
    # assert_match "Built On Envoy CLI: v#{version}", shell_output("#{bin}/boe version")
  end
end
