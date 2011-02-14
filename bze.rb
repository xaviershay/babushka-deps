dep 'drupal' do
  met? {
    "/var/www/drupal-7.0".p.exists?
  }

  meet {
    url = 'http://ftp.drupal.org/files/projects/drupal-7.0.tar.gz'
    log_shell "Downloading drupal from #{url}", "wget #{url}"
    shell 'mv drupal-7.0.tar.gz /var/www/'
    in_dir '/var/www' do
      log_shell "Extracting", 'tar -zxvf drupal-7.0.tar.gz'
    end
  }
end

dep 'drupal configured' do
  requires 'drupal'
  requires 'benhoskings:mysql access' # TODO: Don't prompt for details here

  met? {
    "/var/www/drupal-7.0/sites/default/settings.php".p.exists?
  }

  meet {
    in_dir '/var/www/drupal-7.0' do
      log_shell "Copying default settings", 'cp sites/default/default.settings.php sites/default/settings.php'
      shell 'chmod a+w sites/default/settings.php'
      shell 'chmod a+w sites/default'
    end
  }
end

dep 'enable mysql' do
  met? {
    "/etc/init/mysql.conf".p.exists?
  }

  meet {
    shell "mv /etc/init/mysql.conf.disabled /etc/init/mysql.conf"
  }
end

 # TODO: Proper settings file for drupal
 # TODO: Copy DB conf to drupal settings
 # TODO: Maintenance user setup (drush?)
