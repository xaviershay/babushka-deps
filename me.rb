# High level deps for my development machine

dep 'the whole damn lot' do
  requires(
    'ssh key',
    'user shell setup',
    #'colemak',
    'fonts',
    'desktop background set',

    #'Garmin ANT Agent.app',
    'MacVim.app',
    'Chromium.app',
    #'Thunderbird.app',
    'Skype.app',
    'Gnucash.app',
    'Alfred.app',
    'Growl.app',
    'Dropbox.app',

    'music copied',
    'documents copied',
    'pictures copied',
    'git repos cloned'
  )
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


dep 'ssh keys' do
  met? {
    File.exists?(ENV['HOME'] / ".ssh/id_rsa") &&
    File.exists?(ENV['HOME'] / ".ssh/id_rsa.pub")
  }
  meet {
    shell %Q{mkdir -p ~/.ssh}
    shell %Q{scp #{var :old_machine}:~/.ssh/id_rsa* ~/.ssh/}
  }
end

dep 'things' do
  helper(:path) { %Q{~/Library/Application Support/Cultured Code/Things/database.xml} }

  met? { File.exist?(path.p.expand_path.to_s) }
  meet {
    shell %Q{mkdir -p "#{File.dirname(path)}"}
    shell %Q{scp #{var :old_machine}:"#{path.gsub(' ', '\\\\\\ ')}" #{path.gsub(' ', '\\\\ ')}}
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
  requires 'fish default shell'
end

dep 'fish default shell' do
  requires 'fish shell'
  met? { shell("dscl . -read /Users/`whoami` UserShell").split(' ').last == which('fish') }
  meet { shell "chsh -s #{which('fish')}" }
end

dep 'fish shell' do
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
