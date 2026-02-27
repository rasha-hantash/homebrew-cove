class CcsCli < Formula
  desc "Claude Code session manager — tmux-based multi-session workflow"
  homepage "https://github.com/rasha-hantash/ccs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/ccs/releases/download/v0.1.0/ccs-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e1f96ec72196486de72b2530fdbca3b850a94cfa84f1ba43d94ec8df5615e8ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/ccs/releases/download/v0.1.0/ccs-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3acc636ae474ce903d0c1e90cff1ba276654433b36d22f382728fc37cfef4e05"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/ccs/releases/download/v0.1.0/ccs-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0cec0fd6b58a6fa77d3752cbafb03097e294767d1932c0eb3888e6682f3c8b1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/ccs/releases/download/v0.1.0/ccs-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "06031e57a45d8fd6b63efa7d436f02a15e40433755f95f8ee303d042a4224a81"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ccs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ccs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ccs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ccs"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
