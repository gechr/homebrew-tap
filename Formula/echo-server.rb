# typed: strict
# frozen_string_literal: true

class EchoServer < Formula
  desc "HTTP echo server that returns request details as JSON"
  homepage "https://github.com/gechr/echo-server"
  version "0.1.2"
  license "MIT"

  head do
    url "https://github.com/gechr/echo-server.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_amd64.tar.gz"
      sha256 "8ab0e3639dd7cc514cbc9b1c0038cba411f00ff7505d8f8f9f70a3a43ffe343b"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_arm64.tar.gz"
      sha256 "fe3c0cb07318795188b38f44ad2257121735eaa43097e40ff79dcaf0fca244aa"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_amd64.tar.gz"
      sha256 "bdbf6be12055ee29c87156b477c2069362a1ac55f1882e29359da9708caa0566"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_arm64.tar.gz"
      sha256 "baf48989cc7ee5da6a5c29c33bd71ef0811a4553253d53c2599b4cde579644b2"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "dist/echo-server" => "echo-server"
    else
      bin.install "echo-server"
    end
  end

  test do
    assert_match "echo-server", shell_output("#{bin}/echo-server --help")
  end
end
