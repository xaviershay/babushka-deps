dep "vim-pathogen installed" do
  met? do
    # TODO: Check for latest version
    File.exists?(File.expand_path("~/.vim/autoload/pathogen.vim"))
  end

  meet do
    url = "https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim"
    dest = "~/.vim/autoload"
    shell "mkdir -p #{dest}"
    shell "curl -L #{url} > #{dest}/pathogen.vim"
  end
end

meta :pathogen do
  accepts_list_for :source

  def path
    "~/.vim/bundle" / name
  end


  template do
    met? {
      path.dir?
#       && in_dir(path) do
#         if git_current?
#           true
#         else
#           unmet "Git is not up to date"
#         end
#       end
    }

    before { shell "mkdir -p #{path.parent}" }
    meet {
      source.each {|uri|
        git uri, :to => path
      }
    }
  end
end

vim_plugins = %w(
 tpope-vim-surround
 tpope-vim-haml
 tpope-vim-rails
 kchmck-vim-coffee-script
 shemerey-vim-peepopen
 kana-vim-textobj-user
 nelstrom-vim-textobj-rubyblock
).each do |name|
  dep("#{name}.pathogen") { 
    source("git://github.com/#{name.sub('-', '/')}.git")
  }
end

dep 'vim env' do
  requires *vim_plugins.map {|x| "#{x}.pathogen" }
end
