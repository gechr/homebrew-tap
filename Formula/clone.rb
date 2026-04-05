# typed: strict
# frozen_string_literal: true

class Clone < Formula
  desc "Clone GitHub repositories in parallel"
  homepage "https://github.com/gechr/clone"
  version "0.1.0"
  license "MIT"

  head "https://github.com/gechr/clone.git", branch: "main"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_amd64.tar.gz"
      sha256 "3874153ee01bb8d406a4ee09de36c036baba33975892b99bd50c89632a4a0d81"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_darwin_arm64.tar.gz"
      sha256 "16428c9fac5f54406b73a5fc088f1dff692ce729801f68e3f938d86437d92de7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_amd64.tar.gz"
      sha256 "7d59c7fc3fe1be1fe15c0a19fdfe0b2cb97d3149ea33c7e6e53944a460aefd8f"
    end
    if Hardware::CPU.arm?
      url "https://github.com/gechr/clone/releases/download/v#{version}/clone_linux_arm64.tar.gz"
      sha256 "79f797bde410d68b748c2272fdc74b7370d49ac4906552f9c7181197e9276e04"
    end
  end

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w")
    else
      bin.install "clone"
    end
    generate_completions_from_executable(bin/"clone", "--print-completion", shell_parameter_format: "--@shell=")
  end

  test do
    assert_match "clone", shell_output("#{bin}/clone --help")
  end
end
