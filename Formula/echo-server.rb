# typed: strict
# frozen_string_literal: true

class EchoServer < Formula
  desc "HTTP echo server that returns request details as JSON"
  homepage "https://github.com/gechr/echo-server"
  version "0.1.3"
  license "MIT"

  head do
    url "https://github.com/gechr/echo-server.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_amd64.tar.gz"
      sha256 "92f9a7943544562ee23f2c50573825725f779b226dfed85357cbc7ef0a2abf5f"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_arm64.tar.gz"
      sha256 "5ef4b561d7aef4fb6a2af8ac2f4e4326ae6772e3f9a777b06735d499e562e792"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_amd64.tar.gz"
      sha256 "e7e61b0d96ba3a2d4731bc90fefe8f729431b137227ebc87c7ce32a3352ff284"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_arm64.tar.gz"
      sha256 "cce5f9bcf967a9e5f3c9d36a91c045d737160e3c03346d4ec97bf578edd10b58"
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
    generate_completions_from_executable(bin/"echo-server", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "echo-server", shell_output("#{bin}/echo-server --help")
  end
end
