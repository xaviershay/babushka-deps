mine = %w(
  eventhand
  sites
  thehunge
  geeksheets
)

os = %w(
  rhnh
  db2s3
  tufte-graph
  enki
  dotfiles
  sheets
  writing
  sandbox
  kamel
  lesstile
  curlophone-orchestra
  project-hoff
  rack-my-id
  nom
  ausnom
  singing
  jquery-enumerable
  socialbeat
)

dep 'git repos cloned' do
  requires(*(mine + os + [
    'money'
  ]))
end

dep 'money' do
  met? { File.exists?(File.expand_path("~/Code/me/money/.git")) }
  meet {
    shell %Q{mkdir -p ~/Code/me}
    shell %Q{git clone ssh://rhnh.net/~/repos/money ~/Code/me/money}
  }
end

mine.each do |x|
  dep x do
    met? { File.exists?(File.expand_path("~/Code/me/#{x}/.git")) }
    meet {
      shell %Q{mkdir -p ~/Code/me}
      shell %Q{git clone git@github.com:xaviershay/#{x}.git ~/Code/me/#{x}}
    }
  end
end

os.each do |x|
  dep x do
    met? { File.exists?(File.expand_path("~/Code/os/#{x}/.git")) }
    meet {
      shell %Q{mkdir -p ~/Code/os}
      shell %Q{git clone git@github.com:xaviershay/#{x}.git ~/Code/os/#{x}}
    }
  end
end
