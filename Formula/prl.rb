# typed: strict
# frozen_string_literal: true

class Prl < Formula
  desc "Interact with GitHub pull requests"
  homepage "https://github.com/gechr/prl"
  version "0.5.0"
  license "MIT"

  head do
    url "https://github.com/gechr/prl.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_amd64.tar.gz"
      sha256 "35da19aa8aa9e7923b7cde98a9849003c0f80fd15f306c32271fb557b587dcfb"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_arm64.tar.gz"
      sha256 "5d798f7cd2f98c37ac3fd8af75a392f493a00a1de18a80e13d45ca3a31b5ad78"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_amd64.tar.gz"
      sha256 "2f20ea743148c6d11b921029d1788ccd7c679f31c61191f6a013d17f69f68e0e"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_arm64.tar.gz"
      sha256 "0b7f301c098f7d0422219df866af16b15fbf582414e2abffa00c3d5eba883603"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "dist/prl" => "prl"
    else
      bin.install "prl"
    end
    generate_completions_from_executable(bin/"prl", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "prl", shell_output("#{bin}/prl --help")
  end
end
