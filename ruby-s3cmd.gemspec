Gem::Specification.new do |s|
  s.name = %q{ruby-s3cmd}
  s.version = RubyS3Cmd::VERSION::STRING
  s.date = %q{2012-11-1}
  s.authors = ["Joel Bryan Juliano"]
  s.email = %q{joelbryan.juliano@gmail.com}
  s.summary = %q{A gem providing a ruby interface to s3cmd Amazon S3 client.}
  s.homepage = %q{http://github.com/jjuliano/ruby-s3cmd}
  s.description = %q{A gem providing a ruby interface to s3cmd Amazon S3 client.}
  s.files = [ "README", "MIT-LICENSE", "setup.rb",
              "lib/ruby-s3cmd.rb", "lib/ruby-s3cmd/version.rb",
              "lib/ruby-s3cmd/s3cmd.rb" ]
end

