require 'rubygems'
require 'date'
require 'time'
require 'fileutils'

desc "generate a strings file"
task :genstrings do
  FileUtils.cd "daytoday"
  sh "genstrings -o en.lproj *.m"
end

desc "get submodules"
task :submodule do
  sh "git submodule update --init --recursive"
  pwd = FileUtils.pwd()
  FileUtils.cd "external/lib-aok-ios"
  sh "git submodule update --init --recursive"
  FileUtils.cd "externals/nimbus"
  sh "git submodule update --init --recursive"
  FileUtils.cd pwd
end

desc "test for incorrect pathing"
task :path do
  sh "cat daytoday.xcodeproj/project.pbxproj | grep Users"
end
