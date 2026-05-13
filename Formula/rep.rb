# typed: strict
# frozen_string_literal: true

class Rep < Formula
  desc "Fast find-and-replace tool"
  homepage "https://github.com/gechr/rep"
  version "0.4.6"
  license "MIT"

  head do
    url "https://github.com/gechr/rep.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_amd64.tar.gz"
      sha256 "9b3e1e313fbe80fc9951208edd469c33661fffab999cd9b8881f8db143efd77d"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_arm64.tar.gz"
      sha256 "b45c60441c5d27d80811af78ff1f2e5cfe4675569e822e3a005561a1e4460bf0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_amd64.tar.gz"
      sha256 "f70476324605bc554235c8a52a216980cfc039fd076eec3b8a7f5f5f4c55e0a3"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_arm64.tar.gz"
      sha256 "363d284bfe1579a8664ab29bbfea6b1c9963d7adecc17128d9aee97f66803881"
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
