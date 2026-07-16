# typed: strict
# frozen_string_literal: true

class Clover < Formula
  desc "Automatically manage version strings across arbitrary files"
  homepage "https://github.com/gechr/clover"
  version "0.3.20"
  license "MIT"

  head do
    url "https://github.com/gechr/clover.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_amd64.tar.gz"
      sha256 "11b52425294dfd8cc32e081715d7506e31f2ddf07633666c7954464f245df87a"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_arm64.tar.gz"
      sha256 "d3b40daa414535784db41f95a8b9bff9ff0c3872e104b78173a1bd588289ee8a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_amd64.tar.gz"
      sha256 "2d8039ca9d39333b53c93aa74affd45060070cb5b2e8d318fa3fa90fb1e2bf9d"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_arm64.tar.gz"
      sha256 "036476b03cd25bff3b4719c5b94b781e7694492587d526bc873f8d646c50990c"
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
