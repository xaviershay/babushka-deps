dep 'rvm' do
  met? {
    "~/.config/fish/functions/rvm.fish".p.expand_path.exist?
  }
  meet {
    shell %Q{bash -c "`curl http://rvm.beginrescueend.com/releases/rvm-install-head`"}

    github = "http://github.com/eventualbuddha/fish-nuggets/raw/master/functions"
    shell "curl --create-dirs -o ~/.config/fish/functions/__bash_env_to_fish.fish #{github}/__bash_env_to_fish.fish"
    shell "curl -o ~/.config/fish/functions/rvm.fish #{github}/rvm.fish"
    shell "curl -o ~/.config/fish/functions/cd.fish #{github}/cd.fish"
  }
end
