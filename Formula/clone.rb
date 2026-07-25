# typed: strict
# frozen_string_literal: true

class Clone < Formula
  desc "Clone GitHub repositories in parallel"
  homepage "https://github.com/gechr/clone"
  version "0.4.3"
  license "MIT"

  head do
    url "https://github.com/gechr/clone.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_amd64.tar.gz"
      sha256 "9740ce92118a5bee8f2cad802ff43f73eeb879abe573040c1e1cd1bd7afafe58"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_arm64.tar.gz"
      sha256 "78d5e108928fe031eb325d3f77c6fbd50edfc0d1ef7ea7685f360b488d039601"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_amd64.tar.gz"
      sha256 "216c856dc866a343477a478711b0250aa3595aabd0aa9566a077994dc09654af"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_arm64.tar.gz"
      sha256 "18f1850378184084208eef946e88fe795a6b8d6479afbaacf5ad40aaac841542"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "dist/clone" => "clone"
    else
      bin.install "clone"
    end
    generate_completions_from_executable(bin/"clone", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "clone", shell_output("#{bin}/clone --help")
  end
end
