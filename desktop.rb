dep 'desktop background copied' do
  met? { File.exists?(ENV['HOME'] / "Pictures/background.jpg") }
  meet {
    shell %Q{scp #{var :scp_source} ~/Pictures/background.jpg}
  }
end

dep 'desktop background set' do
  requires 'desktop background copied'

  helper(:dest) { '~/Pictures/background.jpg'.p.expand_path }

  # Bit dodge
  met? {
    out = shell('defaults read com.apple.desktop Background')
    if out
      lines = out.lines.select {|x| x =~ /ImageFilePath/ }
      if lines
        lines.any? {|x| x =~ /#{Regexp.escape(dest)}/ }
      end
    end
  }
  meet {
    shell %Q{defaults write com.apple.desktop Background '{default = {ImageFilePath = "#{dest}"; Placement = "Tiled";};}'}
    shell "killall Dock"
  }
end
