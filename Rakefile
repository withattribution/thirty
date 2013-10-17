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
  sh "git submodule init"
  sh "git submodule update"
  pwd = FileUtils.pwd()
  FileUtils.cd "sr-ios-library"
  sh "git submodule init"
  sh "git submodule update"
  FileUtils.cd "nimbus"
  sh "git submodule init"
  sh "git submodule update"
  FileUtils.cd pwd
end

