cask "whichspace" do
  version "0.17.4"
  sha256 "e10ed3ad8fa57ca57ba0bb88f87854328d0477257292379ed3531bcd2fd984e0"

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
