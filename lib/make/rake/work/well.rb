
gem "rake", "~> 0.9.2"

require 'rake'

module MakeRakeWorkWell
  VERSION = "1.0.0"
end

module Rake
  class FileTask
    alias old_needed? needed?
    alias old_timestamp timestamp

    def needed?
      ! File.exist?(name) || timestamp > real_timestamp
    end

    def real_timestamp
      File.exist?(name) && File.mtime(name.to_s) || Rake::EARLY
    end

    def timestamp
      @timestamp ||=
        if File.exist?(name)
          a = File.mtime(name.to_s)
          b = super unless prerequisites.empty?
          [a, b].compact.max
        else
          Rake::EARLY
        end
    end
  end
end

##
# Defines a :phony task that you can use as a dependency. This allows
# file-based tasks to use non-file-based tasks as prerequisites
# without forcing them to rebuild.
#
# See FileTask#out_of_date? and Task#timestamp for more info.

def (Rake::Task.define_task(:phony)).timestamp
  Time.at 0
end
