# typed: strict
# frozen_string_literal: true

class Prl < Formula
  desc "Interact with GitHub pull requests"
  homepage "https://github.com/gechr/prl"
  version "0.1.10"
  license "MIT"

  head do
    url "https://github.com/gechr/prl.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_amd64.tar.gz"
      sha256 "df289bb2190edead3aa6f4197486568ccabd42e290e2577d52ad928c2222d072"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_arm64.tar.gz"
      sha256 "e55062512fd98054e8177a5505a7bffb744ec58c64549f633da6797c3fe004d3"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_amd64.tar.gz"
      sha256 "9e39cbf61db7dc57c88279cefa3372306392a5b5e78e2b8bc608f6143c8aaf13"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_arm64.tar.gz"
      sha256 "834cc14878be4cf17d60cb4b587fe7ea4b6b40832d6483cb4a5f1d54a0337282"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "dist/prl"
    else
      bin.install "prl"
    end
    generate_completions_from_executable(bin/"prl", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "prl", shell_output("#{bin}/prl --help")
  end
end
