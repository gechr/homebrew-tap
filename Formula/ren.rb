# typed: strict
# frozen_string_literal: true

class Ren < Formula
  desc "Batch file renamer"
  homepage "https://github.com/gechr/ren"
  version "0.1.6"
  license "MIT"

  head do
    url "https://github.com/gechr/ren.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_amd64.tar.gz"
      sha256 "1136b3df029d36dae714e9c94a9cdda241b2419eb618660addb1fa5eb13db120"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_arm64.tar.gz"
      sha256 "f645b5ff2c106843f88499b30be296b312a1284eba9d394ac7303b058656bd4f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_amd64.tar.gz"
      sha256 "f0c32097c399b8b852394a480ee49a3eb0e8bab3f2df320b602e36e8514a7d3c"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_arm64.tar.gz"
      sha256 "4ada5b030a128dbfdfb02243d1a91e303153642bcee822455712fc7a3c3fc838"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "target/release/ren" => "ren"
    else
      bin.install "ren"
    end
    generate_completions_from_executable(bin/"ren", "--completions")
  end

  test do
    assert_match "ren", shell_output("#{bin}/ren --help")
  end
end
