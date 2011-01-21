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
    # Returns a new RubyS3CMD::S3Cmd Object
    #
    def initialize()
    end

    #
    # Show the help message and exit
    #
    def help
      tmp = Tempfile.new('tmp')
      command = option_string() + "--help " + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    #
    # Show s3cmd version and exit.
    #
    def version
      tmp = Tempfile.new('tmp')
      command = option_string() + "--version " + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    #
    # Invoke interactive (re)configuration tool. Don't worry, you won't lose your settings  on  subsequent
    # runs.
    #
    def configure
      tmp = Tempfile.new('tmp')
      command = option_string() + "--configure " + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    #
    # Dump current configuration after parsing config files and command line options and exit.
    #
    def dump_config
      tmp = Tempfile.new('tmp')
      command = option_string() + "--dump-config " + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Make bucket
    def mb(bucket) # s3://BUCKET
      tmp = Tempfile.new('tmp')
      command = option_string() + "mb " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Remove bucket
    def rb(bucket) # s3://BUCKET
      tmp = Tempfile.new('tmp')
      command = option_string() + "rb " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # List objects or buckets
    def ls(bucket) # s3://BUCKET[/PREFIX]]
      tmp = Tempfile.new('tmp')
      command = option_string() + "ls " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # List all object in all buckets
    def la
      tmp = Tempfile.new('tmp')
      command = option_string() + "la " + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Put file into bucket (i.e. upload to S3)
    def put(files, bucket) # FILE [FILE...] s3://BUCKET[/PREFIX]
      tmp = Tempfile.new('tmp')
      command = option_string() + "put " + files.to_s + " " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Get file from bucket (i.e. download from S3)
    def get(bucket, local_file) # s3://BUCKET/OBJECT LOCAL_FILE
      tmp = Tempfile.new('tmp')
      command = option_string() + "get " + bucket.to_s + " " + local_file.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Delete file from bucket
    def del(bucket) # s3://BUCKET/OBJECT
      tmp = Tempfile.new('tmp')
      command = option_string() + "del " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Backup a directory tree to S3
    # Restore a tree from S3 to local directory
    def sync(src_object, dest_object) # LOCAL_DIR s3://BUCKET[/PREFIX] or s3://BUCKET[/PREFIX] LOCAL_DIR
      tmp = Tempfile.new('tmp')
      command = option_string() + "sync " + src_object.to_s + " " + dest_object.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Make a copy of a file (cp) or move a file (mv).  Destination can be in the same bucket with  a  dif‐
    # ferent name or in another bucket with the same or different name.  Adding --acl-public will make the
    # destination object publicly accessible (see below).
    def cp(src_bucket, dest_bucket) # s3://BUCKET1/OBJECT1 s3://BUCKET2[/OBJECT2]
      tmp = Tempfile.new('tmp')
      command = option_string() + "cp " + src_bucket.to_s + " " + dest_bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Make a copy of a file (cp) or move a file (mv).  Destination can be in the same bucket with  a  dif‐
    # ferent name or in another bucket with the same or different name.  Adding --acl-public will make the
    # destination object publicly accessible (see below).
    def mv(src_bucket, dest_bucket) # s3://BUCKET1/OBJECT1 s3://BUCKET2[/OBJECT2]
      tmp = Tempfile.new('tmp')
      command = option_string() + "mv " + src_bucket.to_s + " " + dest_bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Modify Access control list for Bucket or Files. Use with --acl-public or --acl-private
    def setacl(bucket) # s3://BUCKET[/OBJECT]
      tmp = Tempfile.new('tmp')
      command = option_string() + "setacl " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Get various information about a Bucket or Object
    def info(bucket) # s3://BUCKET[/OBJECT]
      tmp = Tempfile.new('tmp')
      command = option_string() + "info " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Disk usage - amount of data stored in S3
    def du(bucket) # [s3://BUCKET[/PREFIX]]
      tmp = Tempfile.new('tmp')
      command = option_string() + "du " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Commands for CloudFront management

    # List CloudFront distribution points
    def cflist
      tmp = Tempfile.new('tmp')
      command = option_string() + "cflist " + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Display CloudFront distribution point parameters
    def cfinfo(dist_id) # [cf://DIST_ID]
      tmp = Tempfile.new('tmp')
      command = option_string() + "cfinfo " + dist_id.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Create CloudFront distribution point
    def cfcreate(bucket) # s3://BUCKET
      tmp = Tempfile.new('tmp')
      command = option_string() + "cfcreate " + bucket.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Delete CloudFront distribution point
    def cfdelete(dist_id) # cf://DIST_ID
      tmp = Tempfile.new('tmp')
      command = option_string() + "cfdelete " + dist_id.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    # Change CloudFront distribution point parameters
    def cfmodify(dist_id) # cf://DIST_ID
      tmp = Tempfile.new('tmp')
      command = option_string() + "cfmodify " + dist_id.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    def show_config
      option_string()
    end

    private

    def option_string()

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

