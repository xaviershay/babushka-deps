dep 'rubygems' do
  met? {
    shell("gem -v") == '1.3.7' # TODO: Get latest version from somewhere
  }
  meet {
    shell "sudo gem update --system"
  }
end

pkg 'coffee-script'
pkg 'mysql'
