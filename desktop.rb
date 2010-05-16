dep 'desktop background copied' do
  met? { File.exists?(ENV['HOME'] / "Pictures/background.jpg") }
  meet {
    shell %Q{scp #{var :scp_source} ~/Pictures/background.jpg}
  }
end

dep 'desktop background set' do
  requires 'desktop background copied'

  met? { false }
  meet {
    shell %Q{defaults write com.apple.desktop Background '{default = {ImageFilePath = "#{'~/Pictures/background.jpg'.p.expand_path}"; Placement = "Tiled";};}}
  }
end
