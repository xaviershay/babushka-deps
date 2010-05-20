dep 'music copied' do
  met? {
    shell("du -d 0 ~/Music").split(/\s+/)[0].to_i > 60_000_000 # ~30Gb
  }
  meet {
    dest = var(:scp_source)

    log_shell "Copying music (might take a while)", %Q{rsync -vrz "#{dest}/" ~/Music}
  }
end

dep 'documents copied' do
  met? {
    shell("du -d 0 ~/Documents").split(/\s+/)[0].to_i > 20_000 # ~10Mb
  }
  meet {
    dest = var(:scp_source)

    log_shell "Copying documents (might take a while)", %Q{rsync -vrz "#{dest}/" ~/Documents}
  }
end

dep 'pictures copied' do
  met? {
    shell("du -d 0 ~/Pictures").split(/\s+/)[0].to_i > 400_000 # ~200Mb
  }
  meet {
    dest = var(:scp_source)

    log_shell "Copying pictures (might take a while)", %Q{rsync -vrz "#{dest}/" ~/Pictures}
  }
end
