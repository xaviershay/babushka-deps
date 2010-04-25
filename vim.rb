dep "vim-pathogen" do
  met? do
    # TODO: Check for latest version
    File.exists?("~/.vim/autoload/pathogen.vim")
  end

  meet do
    url = "http://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim"
    dest = "~/.vim/autoload"
    shell "mkdir -p #{dest}"
    shell "curl #{url} > #{dest}/pathogen.vim"
  end
end
