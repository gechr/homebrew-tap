# typed: strict
# frozen_string_literal: true

class Prl < Formula
  desc "Interact with GitHub pull requests"
  homepage "https://github.com/gechr/prl"
  version "0.4.24"
  license "MIT"

  head do
    url "https://github.com/gechr/prl.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_amd64.tar.gz"
      sha256 "3f38666f647286df883fd4ad069185b5f0ab8b07c6ad156741da69eef5f5927e"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_arm64.tar.gz"
      sha256 "0754afa02e532b85abcf77518443f3707b97b5df891273f14997e5278176023c"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_amd64.tar.gz"
      sha256 "78fad4be0ba998cf911c3bf532bf76e535e2e62340ba278040a7ee70b22db739"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_arm64.tar.gz"
      sha256 "ce7705ee4422af98b2de933164dc00147d53c1063f61352c043839a94ccb9f2a"
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
