# typed: strict
# frozen_string_literal: true

class EchoServer < Formula
  desc "HTTP echo server that returns request details as JSON"
  homepage "https://github.com/gechr/echo-server"
  version "0.1.1"
  license "MIT"

  head do
    url "https://github.com/gechr/echo-server.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_amd64.tar.gz"
      sha256 "15883355621af928612950818ee37dd75b795753fc40fe4fcd8e6f4e6db7fb03"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_darwin_arm64.tar.gz"
      sha256 "e3de26527200d2203a04e30fc0b89bfee254164408ca296018224b28b6bfb6f3"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_amd64.tar.gz"
      sha256 "98ec5447e3ec4d87cf5159f85839f42e101b7d45a43f9ea07d547d6be9b48fc0"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/echo-server/releases/download/v#{version}/echo-server_linux_arm64.tar.gz"
      sha256 "7c941fc83886513717b07602b9c300375cc5f6bbe8632def71397fdca5efecc7"
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
