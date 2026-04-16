# typed: strict
# frozen_string_literal: true

class Clone < Formula
  desc "Clone GitHub repositories in parallel"
  homepage "https://github.com/gechr/clone"
  version "0.2.9"
  license "MIT"

  head do
    url "https://github.com/gechr/clone.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_amd64.tar.gz"
      sha256 "a3457d1e1257a592c7fa91e2718a5e13b3b25f5ea86f153baa2d5b8fcc6121db"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_arm64.tar.gz"
      sha256 "69d8f1af053aa08bbb8cccf245a5eb2542680fcc81ea4c81197d41cda41b2c1b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_amd64.tar.gz"
      sha256 "42a6640456b0f389e4b96dbcce6191096025bbb7509f4e36186d630e4e583a5d"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_arm64.tar.gz"
      sha256 "c51a4430c08c35f6e52e25c53de22f95f3d4e60bb534abd4bd327654edeeceb3"
    end
  end

  def install
    if build.head?
      fetch_args = %w[fetch --tags --force --quiet]
      fetch_args << "--unshallow" if File.exist?(".git/shallow")
      system "git", *fetch_args
      system "make", "build"
      bin.install "dist/clone"
    else
      bin.install "clone"
    end
    generate_completions_from_executable(bin/"clone", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "clone", shell_output("#{bin}/clone --help")
  end
end
