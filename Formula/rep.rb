# typed: strict
# frozen_string_literal: true

class Rep < Formula
  desc "Fast find-and-replace tool"
  homepage "https://github.com/gechr/rep"
  version "0.1.0"
  license "MIT"

  head do
    url "https://github.com/gechr/rep.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_amd64.tar.gz"
      sha256 "8d1d45de731a5fc558fa1478d340933186ec1d9e872caf829a53059d50cfbb5e"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_darwin_arm64.tar.gz"
      sha256 "236ecf049bf5b123080b9e65afdadec0957c1132e2cb84cb762a6d4111ba4076"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_amd64.tar.gz"
      sha256 "0f227bbc484382f3a671159df50057f692da3cc05e13f530410fa414915a19e7"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/rep/releases/download/v#{version}/rep_linux_arm64.tar.gz"
      sha256 "72cf86d371f5b3a0b1ebf0e76c298abd8443c976c6f854b936e0d2d4f3ad19d5"
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
