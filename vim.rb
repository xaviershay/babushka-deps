dep "vim-pathogen installed" do
  met? do
    # TODO: Check for latest version
    File.exists?(File.expand_path("~/.vim/autoload/pathogen.vim"))
  end

  meet do
    url = "http://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim"
    dest = "~/.vim/autoload"
    shell "mkdir -p #{dest}"
    shell "curl #{url} > #{dest}/pathogen.vim"
  end
end

meta :pathogen_plugin_source do
  accepts_list_for :source

  template do
    prepare {setup_source_uris}

    helper(:git_current?) {
      shell("git rev-list ..origin/master").lines.to_a.empty?
    }

    met? {
      current_source = source.first
      path = Babushka::SrcPrefix / File.basename(current_source.name.to_s)
      if !git_repo?(path)
        unmet "#{path} is not a git repo"
      else
        in_dir(path) do
          if git_current?
            true
          else
            unmet "Git is not up to date"
          end
        end
      end
    }

    meet {
      process_sources do |path|
        in_dir(path) do
          if !shell("git fetch")
            fail_because("Couldn't pull the latest code - check your internet connection.")
          end
        end
      end
    }
  end
end

meta :pathogen_link_exists do
  accepts_list_for :source

  template do
    helper(:name)             { File.basename(source.first.name.to_s) }
    helper(:link_source)      { Babushka::SrcPrefix / name }
    helper(:link_destination) { "~/.vim/bundle/#{name}".p.expand_path }

    met? {
      if !File.exists?(link_destination)
        unmet "link does not exist"
      elsif link_destination.realpath != link_source
        unmet "link exists, but points to #{link_destination.realpath} instead of #{link_source}"
      else
        true
      end
    }

    meet {
      shell "mkdir -p #{link_destination.dirname}"
      shell "ln -fs #{link_source} #{link_destination}"
    }
  end
end

def pathogen_plugin(name)
  git_repo = "git://github.com/tpope/#{name}.git"
  pathogen_plugin_source("#{name} source cloned") { source(git_repo) }
  pathogen_link_exists("#{name} link exists") { source(git_repo) }

  dep "#{name} installed" do
    requires "vim-pathogen installed", "#{name} source cloned", "#{name} link exists"
  end
end
pathogen_plugin "vim-surround"
