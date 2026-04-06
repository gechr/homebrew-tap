# typed: strict
# frozen_string_literal: true

class Prl < Formula
  desc "Interact with GitHub pull requests"
  homepage "https://github.com/gechr/prl"
  version "0.1.1"
  license "MIT"

  head "https://github.com/gechr/prl.git", branch: "main"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_amd64.tar.gz"
      sha256 "9316b1085e616349ca9c0220dcf4a64b33a3543079f3fefeed217c9e90663ed9"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_darwin_arm64.tar.gz"
      sha256 "0c63a8685db5742faaeb22a09a5e18f51b52d1cc85304fd5729ac6ac4d9a39cb"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_amd64.tar.gz"
      sha256 "3234d35e685dad6413673d5869621717cb91604846a6d198e60b861f416577ae"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/prl/releases/download/v#{version}/prl_linux_arm64.tar.gz"
      sha256 "9cdda97fffe80e46dad8dc9e8ecf4bc2e57a7ff8e743b41df2b603802513c19d"
    end
  end

  depends_on "go" => :build if build.head?

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
