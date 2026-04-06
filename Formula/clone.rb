# typed: strict
# frozen_string_literal: true

class Clone < Formula
  desc "Clone GitHub repositories in parallel"
  homepage "https://github.com/gechr/clone"
  version "0.1.2"
  license "MIT"

  head "https://github.com/gechr/clone.git", branch: "main"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_amd64.tar.gz"
      sha256 "419f6b381f053b334000ac32fa85ec794f7503aa9870d6342a8150cbf2d29e8f"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_arm64.tar.gz"
      sha256 "b51946f46bca7d98a56a34e84e648f460dec87b82d3f61f9be379d41ada41604"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_amd64.tar.gz"
      sha256 "b874d9be3b5e884a73b900f6aa3ab6768523b9f598bf51f52153fdcc8440673f"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_arm64.tar.gz"
      sha256 "d9dc64229a8855b38975cb8f7392ba08372ccefc3fc4170ffce35a1bfe0f6ac7"
    end
  end

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "dist/clone"
    else
      bin.install "clone"
    end
    generate_completions_from_executable(bin/"clone", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "clone", shell_output("#{bin}/clone --help")
  end
end
