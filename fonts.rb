dep 'fonts' do
  requires 'inconsolata'
end

dep 'inconsolata' do
  source 'http://www.levien.com/type/myfonts/Inconsolata.otf'

  helper(:name)        { File.basename(source.first.name.to_s) }
  helper(:source)      { Babushka::SrcPrefix / name }
  helper(:destination) { "~/Library/Fonts/#{name}".p.expand_path }
  met? {
    File.exists?(destination)
  }
  meet {
    shell "cp #{source} #{destination}" }
  }
end
