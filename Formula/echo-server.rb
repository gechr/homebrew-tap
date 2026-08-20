# typed: strict
# frozen_string_literal: true

class EchoServer < Formula
  desc "HTTP echo server that returns request details as JSON"
  homepage "https://github.com/gechr/echo-server"
  version "0.1.4"
  license "MIT"

  head do
    url "https://github.com/gechr/echo-server.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_amd64.tar.gz"
      sha256 "b88f80ee9c29bda0dc2b84fb66bb192ca194cf9c31eefecb721a14f13a5d2d5c"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_arm64.tar.gz"
      sha256 "87796840b1da0dbfb19224c007d574630d4f91f4b269b42c3a4cf042e89f7f79"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_amd64.tar.gz"
      sha256 "88ecba1dff1a79fa25054ecddcef1ae0160bfe80fb07b24b71b07e19cda83007"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_arm64.tar.gz"
      sha256 "e66a981db5436f50fb5cc95d804b8cf3dcb2eb4a3a1ec7dd3acaff23aa80ba5a"
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
