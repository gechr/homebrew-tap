# typed: strict
# frozen_string_literal: true

class Ren < Formula
  desc "Batch file renamer"
  homepage "https://github.com/gechr/ren"
  version "0.1.1"
  license "MIT"

  head do
    url "https://github.com/gechr/ren.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_amd64.tar.gz"
      sha256 "e55dbf151affe66703e71b8ce494daaee1cc0475bfef6c5f057dc90f11b5df43"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_arm64.tar.gz"
      sha256 "e71747e81d929cd2a8173f52fc36939644dfdcd31f4af55a307fc02f01ebbf2b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_amd64.tar.gz"
      sha256 "5770b0306e43b422e04781ec7623ed35636a015b4bd41e3043b53ead3d82c25c"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_arm64.tar.gz"
      sha256 "7626a8271f6c1b6295e7f3eb4396f1d84dcdd1a07ad78443e937fa5717f9e6ad"
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
