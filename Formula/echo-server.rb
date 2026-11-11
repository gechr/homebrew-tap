# typed: strict
# frozen_string_literal: true

class EchoServer < Formula
  desc "HTTP echo server that returns request details as JSON"
  homepage "https://github.com/gechr/echo-server"
  version "0.1.5"
  license "MIT"

  head do
    url "https://github.com/gechr/echo-server.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_amd64.tar.gz"
      sha256 "4827d5f403b01201ae4be0fe92a630832004d3e83e1ce3199fc13c408bbdab75"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_arm64.tar.gz"
      sha256 "255c0cdde030e191fdc3d7d22466f508eb4ed61937aff459fcc35a6186daf8a9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_amd64.tar.gz"
      sha256 "6b3f2675d0d70b6e1840aa729b228ecc7948eedfb39a28d88c1e75a40055d6c7"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_arm64.tar.gz"
      sha256 "f4ccd4261c0aa8b3f339994a417eedfbad6e4a127bf9b40f31b6bac700ea0e85"
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
