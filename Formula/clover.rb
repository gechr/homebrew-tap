# typed: strict
# frozen_string_literal: true

class Clover < Formula
  desc "Automatically manage version strings across arbitrary files"
  homepage "https://github.com/gechr/clover"
  version "0.3.23"
  license "MIT"

  head do
    url "https://github.com/gechr/clover.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_amd64.tar.gz"
      sha256 "8eb547a2f1c39073289e910f522bb11ce73c616a46f810fba837ce3f799ca26c"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_arm64.tar.gz"
      sha256 "c1dc1a0567bf57503b3df4243578cb042a6057069600ccbb39fe9874f4630d7f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_amd64.tar.gz"
      sha256 "34c1da4114efa6bc55b760f9a25a65fe3671316ea96825fde3d9a88a938fc901"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_arm64.tar.gz"
      sha256 "5c0791c87ae0424fb3da0a7de4eb162b1b51a312ea62672224f9c402d811d70c"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "dist/clover" => "clover"
    else
      bin.install "clover"
    end
    generate_completions_from_executable(bin/"clover", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "clover", shell_output("#{bin}/clover --help")
  end
end
