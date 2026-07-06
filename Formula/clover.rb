# typed: strict
# frozen_string_literal: true

class Clover < Formula
  desc "Automatically manage version strings across arbitrary files"
  homepage "https://github.com/gechr/clover"
  version "0.1.10"
  license "MIT"

  head do
    url "https://github.com/gechr/clover.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_amd64.tar.gz"
      sha256 "e2562da6e4f985889ed957b0621eedb265dcdab7671db24f345915301e606e23"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_darwin_arm64.tar.gz"
      sha256 "4f1eaf4944b160a742a1006f1c82225e4baf0b08cd0001886dab7a5a7eb4c4bb"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_amd64.tar.gz"
      sha256 "850aae383852b5b5209044c84ad79f2f0da864dc30548801107b05b64d0c5bb9"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clover/releases/download/v#{version}/clover_linux_arm64.tar.gz"
      sha256 "fd8cfc908c617721efc779174c83d0b5018e827599d91046a7cbb60ddb3a30a0"
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
