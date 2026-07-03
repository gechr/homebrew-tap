# typed: strict
# frozen_string_literal: true

class Clone < Formula
  desc "Clone GitHub repositories in parallel"
  homepage "https://github.com/gechr/clone"
  version "0.3.16"
  license "MIT"

  head do
    url "https://github.com/gechr/clone.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_amd64.tar.gz"
      sha256 "85ca07c35b8e8a57d7d58576fddd1834c6d6062dc2134c2082a35988f5124bc8"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_arm64.tar.gz"
      sha256 "7d12ff8f3ba83abdc907ec97241da2e01efcabbcd47158861b0035d21df6d88f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_amd64.tar.gz"
      sha256 "d9cb90ecb218ee42ef676356a3d3800e662ed1b540916ff7ca0f9437b1955211"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_arm64.tar.gz"
      sha256 "60a6976417ce6dab5e3b147bc97c1b90b8e9d7ba4c59b2a58a1c9abec72909d0"
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
