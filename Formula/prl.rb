# typed: strict
# frozen_string_literal: true

class Prl < Formula
  desc "Interact with GitHub pull requests"
  homepage "https://github.com/gechr/prl"
  version "0.1.0"
  license "MIT"

  head "https://github.com/gechr/prl.git", branch: "main"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_amd64.tar.gz"
      sha256 "7f41a8fb8d738ca3bc73e82ef3035003560e001a5a2694273abc72d8e4869edd"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_arm64.tar.gz"
      sha256 "b9b6b5ee1f779fad47ecb1aacb59db761e1084efe2d2aef2c354685404729fee"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_amd64.tar.gz"
      sha256 "fc272664766144fdaf65a7cd5e81b5ca6f05350b017ee25822e1b89106ca952a"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_arm64.tar.gz"
      sha256 "49c76720e728dc4a2fb7f7ab2476d2d7f59d49af636132704d527283af9bcfaa"
    end
  end

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w")
    else
      bin.install "prl"
    end
    generate_completions_from_executable(bin/"prl", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "prl", shell_output("#{bin}/prl --help")
  end
end
