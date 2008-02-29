require "fileutils"

desc "Create a distribution"
task :distribute do
  version = ENV["version"]
  puts "Version is #{version}"

  puts "Preparing distribution"
  work_directory = "build/distribute.tmp/Keywurl"
  FileUtils.mkdir_p(work_directory)
  FileUtils.cp("Readme.rtf", work_directory)
  FileUtils.cp_r("SIMBL.pkg", work_directory)
  ["Leopard", "Tiger"].each do |target|
    target_directory = "#{work_directory}/Safari 3.0 on #{target}"
    FileUtils.mkdir_p(target_directory)
    FileUtils.cp_r("build/Release on #{target}/Keywurl.bundle", target_directory)
  end

  puts "Building DMG image"
  output_directory = "../Distribute"
  FileUtils.mkdir_p(output_directory)
  dmg_file = "#{output_directory}/Keywurl-#{version}.dmg"
  FileUtils.rm_f(dmg_file)
  system("hdiutil create -srcfolder '#{work_directory}' '#{dmg_file}'")

  puts "Creating source tarball"
  system("darcs dist -d '#{output_directory}/Keywurl-#{version}'")
end
