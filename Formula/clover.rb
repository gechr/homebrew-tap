# typed: strict
# frozen_string_literal: true

class Clover < Formula
  desc "Automatically manage version strings across arbitrary files"
  homepage "https://github.com/gechr/clover"
  version "0.0.5"
  license "MIT"

  head do
    url "https://github.com/gechr/clover.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_amd64.tar.gz"
      sha256 "c29f6472e699370b87b18ba57e4f12781bcd90bd77b28f3df05f6f0b66008758"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_arm64.tar.gz"
      sha256 "8c85aa15cb6d17aeb57fdabc6c95af3b044def7a6bc1e0765f90f97f48c97066"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_amd64.tar.gz"
      sha256 "13facd97d71c80ad1539855081bf0c29a489017892d66454639fcb39f7bc6383"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_arm64.tar.gz"
      sha256 "9b50eb14800f0325c17c4a69feed135455fb24bde513a6af5dc4d383840d8615"
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
