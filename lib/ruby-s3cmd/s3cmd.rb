  # = ruby-s3cmd - A gem providing a ruby interface to s3cmd Amazon S3 client.
  #
  # Homepage::  http://github.com/jjuliano/ruby-s3cmd
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT
  #

  #
  # class RubyS3CMD::S3Cmd.new( array, str, array)
  #
  class RubyS3Cmd::S3Cmd

    #
    # Options common for all commands (where it makes sense indeed)
    #

    #
    # Recursive upload, download or removal. When used with del it can remove all the files in a bucket.
    #
    attr_accessor :recursive

    #
    # Force overwrite and other dangerous operations. Can be used to remove a non-empty buckets with s3cmd
    # rb --force s3://bkt
    #
    attr_accessor :force

    #
    # Specify datacentre where to create the bucket. Possible values are US (default) or EU.
    #
    attr_accessor :bucket_location

    #
    # Print sizes in human readable form.
    #
    attr_accessor :human_readable_sizes

    #
    # Include MD5 sums in bucket listings (only for ls command).
    #
    attr_accessor :list_md5

    #
    # Display or don't display progress meter. When running on TTY (e.g. console or xterm) the default  is
    # to  display progress meter. If not on TTY (e.g. output is redirected somewhere or running from cron)
    # the default is to not display progress meter.
    #
    attr_accessor :progress, :no_progress

    #
    # Override autodetected terminal and filesystem encoding (character set).
    #
    attr_accessor :encoding

    #
    # Enable verbose output.
    #
    attr_accessor :verbose

    #
    # Enable debug output.
    #
    attr_accessor :debug

    #
    # Config file related options.
    #

    #
    # Config file name. Defaults to $HOME/.s3cfg
    #
    attr_accessor :config

    #
    # Options specific for file transfer commands (sync, put and get):
    #

    #
    # Only  show  what  should  be  uploaded  or downloaded but don't actually do it. May still perform S3
    # requests to get bucket listings and other in formation though.
    #
    attr_accessor :dry_run

    #
    # Delete remote objects with no corresponding local file when syncing to S3 or delete local files with
    # no corresponding object in S3 when syncing from S3.
    #
    attr_accessor :delete_removed

    #
    # Don't delete remote objects. Default for sync command.
    #
    attr_accessor :no_delete_removed

    #
    # Preserve filesystem attributes (mode, ownership, timestamps). Default for sync command.
    #
    attr_accessor :preserve

    #
    # Don't store filesystem attributes with uploaded files.
    #
    attr_accessor :no_preserve

    #
    # Exclude  files matching GLOB (a.k.a. shell-style wildcard) from sync. See FILE TRANSFERS section and
    # http://s3tools.org/s3cmd-sync for more information.
    #
    attr_accessor :exclude # GLOB

    #
    # Same as --exclude but reads GLOBs from the given FILE instead of expecting them on the command line.
    #
    attr_accessor :exclude_from # FILE

    #
    # Same as --exclude but works with REGEXPs (Regular expressions).
    #
    attr_accessor :rexclude # REGEXP

    #
    # Same as --exclude-from but works with REGEXPs.
    #
    attr_accessor :rexclude_from # FILE

    #
    # Filenames and paths matching GLOB or REGEXP will be included even if previously excluded by  one  of
    # --(r)exclude(-from) patterns
    #
    attr_accessor :include # GLOB
    attr_accessor :include_from # FILE
    attr_accessor :rinclude # REGEXP
    attr_accessor :rinclude_from # FILE

    #
    # Continue  getting a partially downloaded file (only for get command). This comes handy once download
    # of a large file, say an ISO image, from a S3 bucket fails and a partially downloaded file is left on
    # the  disk.  Unfortunately  put  command doesn't support restarting of failed upload due to Amazon S3
    # limitations.
    #
    attr_accessor :continue

    #
    # Skip over files that exist at the destination (only for get and sync commands).
    #
    attr_accessor :skip_existing

    #
    # Default MIME-type to be set for objects stored.
    #
    attr_accessor :mime_type # MIME/TYPE

    #
    # Guess MIME‐type of files by their extension.  Falls  back  to  default  MIME‐Type  as  specified  by
    # --mime-type option
    #
    attr_accessor :guess_mime_type

    #
    # Add  a  given  HTTP  header  to the upload request. Can be used multiple times with different header
    # names. For instance set 'Expires' or 'Cache-Control' headers (or both) using  this  options  if  you
    # like.
    #
    attr_accessor :add_header # NAME:VALUE

    #
    # Store  objects  with  permissions  allowing read for anyone. See http://s3tools.org/s3cmd-public for
    # details and hints for storing publicly accessible files.
    #
    attr_accessor :acl_public

    #
    # Store objects with default ACL allowing access for you only.
    #
    attr_accessor :acl_private

    #
    # Use GPG encryption to protect stored objects from unauthorized access. See http://s3tools.org/s3cmd-
    # public for details about encryption.
    #
    attr_accessor :encrypt

    #
    # Don't encrypt files.
    #
    attr_accessor :no_encrypt

    #
    # Options for CloudFront commands
    #
    # See http://s3tools.org/s3cmd-cloudfront for more details.
    #

    #
    # Enable given CloudFront distribution (only for cfmodify command)
    #
    attr_accessor :enable

    #
    # Enable given CloudFront distribution (only for cfmodify command)
    #
    attr_accessor :disable

    #
    # Add given CNAME to a CloudFront distribution (only for cfcreate and cfmodify commands)
    #
    attr_accessor :cf_add_cname # CNAME

    #
    # Remove given CNAME from a CloudFront distribution (only for cfmodify command)
    #
    attr_accessor :cf_remove_cname # CNAME

    #
    # Set COMMENT for a given CloudFront distribution (only for cfcreate and cfmodify commands)
    #
    attr_accessor :cf_comment # COMMENT

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_s3cmd

    #
    # Show the help message and exit
    #
    def help
     send_command "--help"
    end

    #
    # Show s3cmd version and exit.
    #
    def version
     send_command "--version"
    end

    #
    # Invoke interactive (re)configuration tool. Don't worry, you won't lose your settings  on  subsequent
    # runs.
    #
    def configure
     send_command "--configure"
    end

    #
    # Dump current configuration after parsing config files and command line options and exit.
    #
    def dump_config
       send_command "--dump-config"
    end

    # Make bucket
    def mb(bucket) # s3://BUCKET
      send_command "mb", bucket
    end

    # Remove bucket
    def rb(bucket) # s3://BUCKET
      send_command "rb", bucket
    end

    # List objects or buckets
    def ls(bucket) # s3://BUCKET[/PREFIX]]
      send_command "ls", bucket
    end

    # List all object in all buckets
    def la
      send_command "la"
    end

    # Put file into bucket (i.e. upload to S3)
    def put(files, bucket) # FILE [FILE...] s3://BUCKET[/PREFIX]
      send_command "put", files, bucket
    end

    # Get file from bucket (i.e. download from S3)
    def get(bucket, local_file=nil) # s3://BUCKET/OBJECT LOCAL_FILE
      send_command "get", bucket, local_file
    end

    # Delete file from bucket
    def del(bucket) # s3://BUCKET/OBJECT
      send_command "del"
    end

    # Backup a directory tree to S3
    # Restore a tree from S3 to local directory
    def sync(src_object, dest_object=nil) # LOCAL_DIR s3://BUCKET[/PREFIX] or s3://BUCKET[/PREFIX] LOCAL_DIR
      send_command "sync", src_object, dest_object
    end

    # Make a copy of a file (cp) or move a file (mv).  Destination can be in the same bucket with  a  dif‐
    # ferent name or in another bucket with the same or different name.  Adding --acl-public will make the
    # destination object publicly accessible (see below).
    def cp(src_bucket, dest_bucket) # s3://BUCKET1/OBJECT1 s3://BUCKET2[/OBJECT2]
      send_command "cp", src_bucket, dest_bucket
    end

    # Make a copy of a file (cp) or move a file (mv).  Destination can be in the same bucket with  a  dif‐
    # ferent name or in another bucket with the same or different name.  Adding --acl-public will make the
    # destination object publicly accessible (see below).
    def mv(src_bucket, dest_bucket) # s3://BUCKET1/OBJECT1 s3://BUCKET2[/OBJECT2]
      send_command "mv", src_bucket, dest_bucket
    end

    # Modify Access control list for Bucket or Files. Use with --acl-public or --acl-private
    def setacl(bucket) # s3://BUCKET[/OBJECT]
      send_command "setacl", bucket
    end

    # Get various information about a Bucket or Object
    def info(bucket) # s3://BUCKET[/OBJECT]
      send_command "info", bucket
    end

    # Disk usage - amount of data stored in S3
    def du(bucket) # [s3://BUCKET[/PREFIX]]
      send_command "du", bucket
    end

    # Commands for CloudFront management

    # List CloudFront distribution points
    def cflist
      send_command "cflist"
    end

    # Display CloudFront distribution point parameters
    def cfinfo(dist_id) # [cf://DIST_ID]
      send_command "cfinfo", dist_id
    end

    # Create CloudFront distribution point
    def cfcreate(bucket) # s3://BUCKET
      send_command "cfcreate", bucket
    end

    # Delete CloudFront distribution point
    def cfdelete(dist_id) # cf://DIST_ID
      send_command "cfdelete", dist_id
    end

    # Change CloudFront distribution point parameters
    def cfmodify(dist_id) # cf://DIST_ID
      send_command "cfmodify", dist_id
    end

    def show_config
      option_string
    end

    protected

    def send_command(*command)
      tmp = Tempfile.new('tmp')
      success = system("#{option_string + command.join(" ") } > #{tmp.path}")
      return tmp.readlines.map(&:chomp) if success
      tmp.close!

      success
    end

    def option_string

      unless @path_to_s3cmd
        ostring = "s3cmd "
      else
        ostring = @path_to_s3cmd + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-s3cmd"
          if (tmp_value.is_a? TrueClass) || (tmp_value.is_a? FalseClass)
            ostring += "#{tmp_string} "
          else
            ostring += "#{tmp_string} #{tmp_value} "
          end
        end
      end

      return ostring

    end

  end

