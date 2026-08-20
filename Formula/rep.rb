# typed: strict
# frozen_string_literal: true

class Rep < Formula
  desc "Fast find-and-replace tool"
  homepage "https://github.com/gechr/rep"
  version "0.5.13"
  license "MIT"

  head do
    url "https://github.com/gechr/rep.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_amd64.tar.gz"
      sha256 "9938d457415250eb3fa4e230adffe1663e107a3cc1f71c08e7aa49d860f313fc"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_arm64.tar.gz"
      sha256 "406973a7e3750dd42e3fc2403ce221783a464af0eea7ecd9bd5310fa5c96e781"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_amd64.tar.gz"
      sha256 "a1fa46d5c4c9c978a1c5853caa27a8eb4f139ec19540a4254e359fafaadfa9a7"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_arm64.tar.gz"
      sha256 "6f3f61ab282ad3082dcf1100c99c7a675fd5c457ab8b002216ae8ac8f21782d7"
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
