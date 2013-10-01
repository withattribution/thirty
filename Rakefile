require 'rubygems'
require 'date'
require 'time'
require 'fileutils'

desc "generate a strings file"
task :genstrings do
  FileUtils.cd "daytoday"
  sh "genstrings -o en.lproj *.m"
end
