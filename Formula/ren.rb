# typed: strict
# frozen_string_literal: true

class Ren < Formula
  desc "Batch file renamer"
  homepage "https://github.com/gechr/ren"
  version "0.0.5"
  license "MIT"

  head do
    url "https://github.com/gechr/ren.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_amd64.tar.gz"
      sha256 "1ba3c855407a1ee01c326d64d3d4d94e1ba553bef0018e1d81cddc4534f7aa77"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_arm64.tar.gz"
      sha256 "02a5d9e407242abb67d0763d94a84c143d0231229b44c88db0e6227756c27e41"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_amd64.tar.gz"
      sha256 "c2e84b44c917b64311ad8fb688181eb364bd18a00935e277fb9c048ab9ceb812"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_arm64.tar.gz"
      sha256 "7136ffcc746f91a781d0bbbe311c4012a69974064f1e0a14ff6ef9d80910deda"
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
