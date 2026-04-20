# typed: strict
# frozen_string_literal: true

class Echo-server < Formula
  desc "HTTP echo server that returns request details as JSON"
  homepage "https://github.com/gechr/echo-server"
  version "0.1.0"
  license "MIT"

  head do
    url "https://github.com/gechr/echo-server.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_amd64.tar.gz"
      sha256 "78a3245112cc4465e3a641fdc6d07fa51f4d8b1d98a960a7ee60a06290fa83ab"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_arm64.tar.gz"
      sha256 "5a358b840428942933eb6e2e9d49160c31c40719b7584a56e2feb9554f8e6fed"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_amd64.tar.gz"
      sha256 "5f7f1c81171737446dd4f65b4c20d01bcce77c06ac53260a2d88f643c4427a0e"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_arm64.tar.gz"
      sha256 "b2122d962cd6458e99f772b5d987925f99e99acaac97952136ce3cf6dca8a79e"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "dist/echo-server"
    else
      bin.install "echo-server"
    end
    generate_completions_from_executable(bin/"echo-server", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "echo-server", shell_output("#{bin}/echo-server --help")
  end
end
