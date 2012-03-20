class DummyDir
  def exists?( arg )
    true
  end

  def entries( path )
    return ["foo", "test", "entries", "season 1", "season 2", "season 23"]
  end
end

class DummyFileUtils
  def mv( location, target )
    return true
  end
end

class DummyFile
  attr_reader :count

  def initialize
    @count = 0
  end

  def directory?(path)
    @count += 1

    return false if @count <= 3

    return true
  end

  def join( path_1, path_2)
    return File.join(path_1, path_2)
  end

  def method_missing(name, *args, &block)
    File.send(name, *args, &block)
  end
end

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

