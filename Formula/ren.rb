# typed: strict
# frozen_string_literal: true

class Ren < Formula
  desc "Batch file renamer"
  homepage "https://github.com/gechr/ren"
  version "0.1.0"
  license "MIT"

  head do
    url "https://github.com/gechr/ren.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_amd64.tar.gz"
      sha256 "f548929ae6d1ae9d5cdc52a1849350d6e02c4241590db4ded237fe650b4a1f36"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_arm64.tar.gz"
      sha256 "3144e5cd1ba36b054c421e177885c376dca6539664819a018428d3bc302a47fb"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_amd64.tar.gz"
      sha256 "08e0311215a16d0b7b66b1f64bdc4440464892d2d9515153bb821a0b6bc8d659"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_arm64.tar.gz"
      sha256 "dbf82b844f17c26acf7d3b678c0d1b2cebf73185035c4f99682b4a024647825c"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "target/release/ren" => "ren"
    else
      bin.install "ren"
    end
    generate_completions_from_executable(bin/"ren", "--completions")
  end

  test do
    assert_match "ren", shell_output("#{bin}/ren --help")
  end
end
