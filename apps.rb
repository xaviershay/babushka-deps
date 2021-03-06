dep 'MacVim.app' do
  source 'http://macvim.googlecode.com/files/MacVim-snapshot-52.tbz'
end

dep 'Garmin ANT Agent.app' do
  source 'http://www8.garmin.com/software/ANTAgentforMac_215.dmg'
end

dep 'Chromium.app' do
  requires_when_unmet "Chromium.app download cleared"
  source L{
    "http://build.chromium.org/buildbot/snapshots/chromium-rel-mac/#{version}/chrome-mac.zip"
  }
  latest_version {
    shell "curl http://build.chromium.org/buildbot/snapshots/chromium-rel-mac/LATEST"
  }
  current_version {|path|
    IO.read(path / 'Contents/Info.plist').xml_val_for('SVNRevision')
  }
end

# TODO better version handling will make this unnecessary.
dep "Chromium.app download cleared" do
  met? { in_download_dir { !'chrome-mac.zip'.p.exists? } }
  meet { in_download_dir { 'chrome-mac.zip'.p.rm } }
end

dep 'Skype.app' do
  source 'http://download.skype.com/macosx/Skype_2.8.0.851.dmg'
end

dep 'Thunderbird.app' do
  # TODO: Determine latest version automatically
  source 'http://jp-nii01.mozilla.org/pub/mozilla.org/thunderbird/releases/3.1b2/mac/en-GB/Thunderbird 3.1 Beta 2.dmg'
end

dep 'Gnucash.app' do
  source 'http://downloads.sourceforge.net/sourceforge/gnucash/Gnucash-Intel-2.2.9.4.dmg'
end

dep 'Alfred.app' do
  source 'http://media.alfredapp.com/alfred_0.6.2_beta_23.dmg'
end

dep 'Growl.app' do
  source 'http://growl.cachefly.net/Growl-1.2.dmg'
end

dep 'Dropbox.app' do
  source 'https://www.dropbox.com/download?plat=mac'
end

dep 'Things.app' do
  source 'http://culturedcode.com/things/download/?e=3102'
end

dep 'tig.managed'

dep 'Skitch.app' do
  source 'http://get.skitch.com/skitch-beta.dmg'
end
