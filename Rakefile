require "fileutils"

VERSIONS = [
  ["1.4 beta 6", "Tiger", "Safari 3"],
  ["1.4 beta 6", "Tiger", "Safari 4"],
  ["1.4 beta 6", "Leopard", "Safari 3"],
  ["1.4 beta 6", "Leopard", "Safari 4"]
]

def run(s)
  puts s
  succeeded = system(s)
  unless succeeded
    $stderr << "Failed to run command."
    exit(1)
  end
end

desc "Create a distribution"
task :distribute do
  VERSIONS.each do |version, os, safari|
    puts "--- Creating distribution of version #{version} for #{safari} on #{os} ---"
    puts
    puts "Preparing distribution"
    work_directory = "build/distribute.tmp/Keywurl"
    FileUtils.mkdir_p(work_directory)
    FileUtils.cp("Readme.html", work_directory)
    FileUtils.cp("License.rtf", work_directory)
    FileUtils.cp_r("SIMBL.pkg", work_directory)
    FileUtils.cp_r("build/Release for #{safari} on #{os}/Keywurl.bundle", work_directory)

    puts "Building DMG image"
    output_directory = "../Distribute"
    FileUtils.mkdir_p(output_directory)
    dmg_file = "#{output_directory}/Keywurl-#{version.gsub(/\s/, "-")}-#{safari.gsub(/\s/, "-")}-#{os}.dmg"
    FileUtils.rm_f(dmg_file)
    run("hdiutil create -srcfolder '#{work_directory}' '#{dmg_file}'")
    run("hdiutil internet-enable -yes '#{dmg_file}'")

    puts "Creating source tarball"
    run("git archive --format=tar 'refs/tags/Release_#{version.gsub(/[\s]/, '_')}' | " <<
      "bzip2 -9 > '#{output_directory}/Keywurl-#{version.gsub(/\s/, '_')}.tar.bz2'")
    puts
  end
end
