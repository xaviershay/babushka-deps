# High level deps for my development machine

dep 'the whole damn lot' do
  requires(
    'private key',
    'user shell setup',
    'colemak',
    'MacVim.app'
  )
end

app 'MacVim.app' do
  source 'http://macvim.googlecode.com/files/MacVim-snapshot-52.tbz'
end

dep 'colemak' do
  requires 'KeyRemap4MacBook'
end

installer 'KeyRemap4MacBook' do
  source 'http://pqrs.org/macosx/keyremap4macbook/files/KeyRemap4MacBook-6.7.0.pkg.zip'
  met? { File.exists?('/Library/PreferencePanes/KeyRemap4MacBook.prefPane') }
end

dep 'user shell setup' do
  requires 'fish', 'dot files'
  met? { File.basename(sudo('echo \$SHELL', :as => var(:username), :su => true)) == 'fish' }
  meet { sudo "chsh -s #{shell('which fish')} #{var(:username)}" }
end


dep 'private key' do
  met? { File.exists?(ENV['HOME'] / ".ssh/id_rsa") }
  meet {
    shell %Q{mkdir -p ~/.ssh}
    shell %Q{scp #{var :old_machine}:.ssh/id_rsa .ssh/id_rsa}
  }
end

dep 'dot files' do
  requires 'private key'
  met? { File.exists?(ENV['HOME'] / ".dotfiles/.git") }
  meet {
    shell %Q{git clone git@github.com/#{var :github_user, :default => 'xaviershay'}/#{var :dot_files_repo, :default => 'dotfiles'}.git ~/.dotfiles}
    shell %Q{cd ~/.dotfiles && ./install}
  }
end

dep 'fish' do
  requires 'fish installed'
  met? { grep which('fish'), '/etc/shells' }
  meet { append_to_file which('fish'), '/etc/shells', :sudo => true }
end

src 'fish installed' do
  requires 'ncurses', 'coreutils'
  source "git://github.com/benhoskings/fish.git"
  provides 'fish'
end

pkg 'ncurses' do
  installs {
    via :apt, 'libncurses5-dev', 'libncursesw5-dev'
    via :macports, 'ncurses', 'ncursesw'
  }
  provides []
end
pkg 'coreutils', :for => :osx do
  provides 'gecho'
  after :on => :osx do
    in_dir pkg_manager.bin_path do
      sudo "ln -s gecho echo"
    end
  end
end
