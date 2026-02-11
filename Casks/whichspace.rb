cask "whichspace" do
  version "0.15.0"
  sha256 "8af77be24ebe7d0096891e8e9d2f61e3d978df2b408d137a17c774206c9aac0a"

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
