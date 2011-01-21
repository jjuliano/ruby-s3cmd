  # = ruby-s3cmd - A gem providing a ruby interface to s3cmd Amazon S3 client.
  #
  # Homepage::  http://github.com/jjuliano/ruby-s3cmd
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT
  #

  require 'tempfile'

  Dir[File.join(File.dirname(__FILE__), 'ruby-s3cmd/**/*.rb')].sort.reverse.each { |lib| require lib }

