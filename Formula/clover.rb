# typed: strict
# frozen_string_literal: true

class Clover < Formula
  desc "Automatically manage version strings across arbitrary files"
  homepage "https://github.com/gechr/clover"
  version "0.2.7"
  license "MIT"

  head do
    url "https://github.com/gechr/clover.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_amd64.tar.gz"
      sha256 "a7f88c100766fd2361362ae57a6f566674ae14f4a8b0b852a05985d2ffe01af4"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_arm64.tar.gz"
      sha256 "4fc20753552b4be221df62e1269ece1ffbc981f83560965a47a4cf0a86dad147"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_amd64.tar.gz"
      sha256 "afafc4cdcfcde737eb71e2e8caade69fa38b79715afa825b28431dfead98e5c3"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_arm64.tar.gz"
      sha256 "f2b5fdcd87ceb8bb9929a5a01dc2407369ee1acd7895ac9d5f36bf63d076867a"
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
