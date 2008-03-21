require "fileutils"

desc "Create a distribution"
task :distribute do
  version = ENV["version"]
  puts "Version is #{version}"

  puts "Preparing distribution"
  work_directory = "build/distribute.tmp/Keywurl"
  FileUtils.mkdir_p(work_directory)
  FileUtils.cp("Readme.html", work_directory)
  FileUtils.cp("License.rtf", work_directory)
  FileUtils.cp_r("SIMBL.pkg", work_directory)
  FileUtils.cp_r("Installer/Install Keywurl.pkg", work_directory)

  puts "Building DMG image"
  output_directory = "../Distribute"
  FileUtils.mkdir_p(output_directory)
  dmg_file = "#{output_directory}/Keywurl-#{version}.dmg"
  FileUtils.rm_f(dmg_file)
  system("hdiutil create -srcfolder '#{work_directory}' '#{dmg_file}'")
  system("hdiutil internet-enable -yes '#{dmg_file}'")

  puts "Creating source tarball"
  system("hg archive -t tbz2 '#{output_directory}/Keywurl-#{version}.tar.bz2'")
end
