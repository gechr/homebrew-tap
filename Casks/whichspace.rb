cask "whichspace" do
  version "0.14.3"
  sha256 "6ca4468cfe0c923b7749ec1926005dae7b3c83c21c8e120c15ec8bfa9853438d"

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
