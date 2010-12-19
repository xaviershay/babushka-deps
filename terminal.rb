dep 'Terminal colors' do
  requires 'Terminal Startup Window Settings', 'Terminal Default Window Settings'
end

meta :plist_default do
  accepts_list_for :domain
  accepts_list_for :key
  accepts_list_for :value

  template do
    met? { shell(%Q{defaults read  #{domain[0]} "#{key[0]}"}) == value[0].to_s }
    meet { shell(%Q{defaults write #{domain[0]} "#{key[0]}" "#{value[0]}"}) }
  end
end

[
  "Startup Window Settings",
  "Default Window Settings"
].each do |setting|
  dep("Terminal #{setting}.plist_default") {
    domain 'com.apple.Terminal'
    key    setting
    value 'Novel'
  }
end
