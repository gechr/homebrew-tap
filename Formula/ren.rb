# typed: strict
# frozen_string_literal: true

class Ren < Formula
  desc "Batch file renamer"
  homepage "https://github.com/gechr/ren"
  version "0.1.3"
  license "MIT"

  head do
    url "https://github.com/gechr/ren.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_amd64.tar.gz"
      sha256 "ce97a3f4bcd029b4f280aca88c1519c9d941d7d9ae059161dc3f73e43362317d"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_darwin_arm64.tar.gz"
      sha256 "8cf28d967131e5bfef6cf4d284043b91e3827dd6ffa64d9c90a3a3bd832387ff"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_amd64.tar.gz"
      sha256 "b12a7b2effc3eee15c59151c70ad2c9de1146804f45464e92fa120c035a6496a"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/ren/releases/download/v#{version}/ren_linux_arm64.tar.gz"
      sha256 "eac7a3eb7405e8ba5ed39b28b992083ae50e069780233876df331d1433005a0b"
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
