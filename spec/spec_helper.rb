class DummyDir
  def exists?( arg )
    true
  end

  def entries( path )
    return ["foo", "test", "entries"]
  end
end

class DummyFileUtils
  def mv( location, target )
    return true
  end
end

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :fakeweb
end

