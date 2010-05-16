dep 'music copied' do
  met? {
    shell("du -d 0 ~/Music").split(/\s+/)[0].to_i > 60_000_000 # ~30Gb
  }
  meet {
    dest = var(:scp_source)

    log_shell "Copying music (might take a while)", %Q{rsync -vrz "#{dest}/" ~/Music}
  }
end
