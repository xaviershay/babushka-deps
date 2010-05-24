mine = %w(
  eventhand
  sites
  thehunge
  geeksheets
  two-shay
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
    'money',
    'db-is-your-friend'
  ]))
end

dep 'money' do
  met? { File.exists?(File.expand_path("~/Code/me/money/.git")) }
  meet {
    shell %Q{mkdir -p ~/Code/me}
    shell %Q{git clone ssh://rhnh.net/~/repos/money ~/Code/me/money}
  }
end

dep 'db-is-your-friend' do
  requires(
    'db-is-your-friend website',
    'db-is-your-friend presentation',
    'db-is-your-friend bookstore'
  )
end

dep 'db-is-your-friend website' do
  met? { File.exists?(File.expand_path("~/Code/me/db-is-your-friend/website/.git")) }
  meet {
    shell %Q{mkdir -p ~/Code/me}
    shell %Q{git clone ssh://rhnh.net/~/repos/db-is-your-friend/website.git ~/Code/me/db-is-your-friend/website}
  }
end

dep 'db-is-your-friend presentation' do
  met? { File.exists?(File.expand_path("~/Code/me/db-is-your-friend/presentation/.git")) }
  meet {
    shell %Q{mkdir -p ~/Code/me}
    shell %Q{git clone ssh://rhnh.net/~/repos/db-is-your-friend/presentation.git ~/Code/me/db-is-your-friend/presentation}
  }
end

dep 'db-is-your-friend bookstore' do
  met? { File.exists?(File.expand_path("~/Code/me/db-is-your-friend/bookstore/.git")) }
  meet {
    shell %Q{mkdir -p ~/Code/me}
    shell %Q{git clone ssh://rhnh.net/~/repos/db-is-your-friend/bookstore.git ~/Code/me/db-is-your-friend/bookstore}
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
