# typed: strict
# frozen_string_literal: true

class Rep < Formula
  desc "Fast find-and-replace tool"
  homepage "https://github.com/gechr/rep"
  version "0.0.2"
  license "MIT"

  head do
    url "https://github.com/gechr/rep.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_amd64.tar.gz"
      sha256 "a0d36153d85d58cf6f1f85f0e32db49f159e15aed58229c38bb7cd535bece0cb"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_arm64.tar.gz"
      sha256 "7cfa6897de200020ee98bcb71fcc460e05b87425b907d0eb7a1e7a8e58262a44"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_amd64.tar.gz"
      sha256 "742c48990463249ae58b5ca2d3d62c20ca9e53780cb67ce5a8d0769158e3d206"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_arm64.tar.gz"
      sha256 "d997365fac726b13875047825ed76fe15a73b307b7c313479e6a040d8f105df3"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "target/release/rep" => "rep"
    else
      bin.install "rep"
    end
    generate_completions_from_executable(bin/"rep", "--completions")
  end

  test do
    assert_match "rep", shell_output("#{bin}/rep --help")
  end
end
