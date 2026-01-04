cask "whichspace" do
  version "0.13.1"
  sha256 "259b8d7960882b3b544beb1a07b6d6cf3c2d53593a0c0d2ce890971d56aa79f3"

  url "https://github.com/gechr/WhichSpace/releases/download/v#{version}/WhichSpace.zip"
  name "WhichSpace"
  desc "Menu bar utility for viewing and switching macOS Spaces"
  homepage "https://github.com/gechr/WhichSpace"

  depends_on macos: ">= :sonoma"

  app "WhichSpace.app"

  postflight do
    system "xattr", "-r", "-d", "com.apple.quarantine", "#{appdir}/WhichSpace.app"
  end

  uninstall quit: "io.gechr.WhichSpace"

  zap trash: [
    "~/Library/Caches/io.gechr.WhichSpace",
    "~/Library/Cookies/io.gechr.WhichSpace.binarycookies",
    "~/Library/Preferences/io.gechr.WhichSpace.plist",
    "~/Library/Saved Application State/io.gechr.WhichSpace.savedState",
  ]
end
