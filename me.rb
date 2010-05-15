# High level deps for my development machine

dep 'the whole damn lot' do
  requires(
    'colemak',
    'user shell setup'
  )
end

dep 'colemak' do
  requires 'KeyRemap4MacBook'
end

app 'KeyRemap4MacBook' do
  source 'http://pqrs.org/macosx/keyremap4macbook/files/KeyRemap4MacBook-6.7.0.pkg.zip'
end

dep 'user shell setup' do
  requires 'fish', 'dot files'
  met? { File.basename(sudo('echo \$SHELL', :as => var(:username), :su => true)) == 'fish' }
  meet { sudo "chsh -s #{shell('which fish')} #{var(:username)}" }
end


dep 'dot files' do
  requires 'git', 'curl'
  met? { File.exists?(ENV['HOME'] / ".dotfiles/.git") }
  meet {
    shell %Q{git clone git://github.com/#{var :github_user, :default => 'xaviershay'}/#{var :dot_files_repo, :default => 'dotfiles'}.git ~/.dotfiles}
    shell %Q{cd ~/.dotfiles && ./install}
  }
end

dep 'fish' do
  requires 'fish installed'
  met? { grep which('fish'), '/etc/shells' }
  meet { append_to_file which('fish'), '/etc/shells', :sudo => true }
end

src 'fish installed' do
  requires 'ncurses', 'coreutils', 'gettext'
  source "git://github.com/benhoskings/fish.git"
  provides 'fish'
end
