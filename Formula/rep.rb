# typed: strict
# frozen_string_literal: true

class Rep < Formula
  desc "Fast find-and-replace tool"
  homepage "https://github.com/gechr/rep"
  version "0.3.4"
  license "MIT"

  head do
    url "https://github.com/gechr/rep.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_amd64.tar.gz"
      sha256 "a02d561fe14015e7ee65682131f9ebbaceeed94ac7b24ec1e04d37ebbf07e4a9"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_arm64.tar.gz"
      sha256 "b4adff22ff2d15a229db77437d7a63bcc015d425136c3d2f9979b5b82d06a0c5"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_amd64.tar.gz"
      sha256 "c3187bbb9eb200c8d0ff26d1ed010057ce454943642a19a211dc1c2223e5d232"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_arm64.tar.gz"
      sha256 "4f94f46d6e29c1111c50ce55a42ed964b655e8c3962800ff9920a54fd5b16827"
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
