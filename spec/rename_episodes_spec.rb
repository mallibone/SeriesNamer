require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/Validation/path'
require_relative '../lib/rename_episodes'

require_relative 'spec_helper'

describe "SeriesNamer::SeriesNamer::RenameEpisodes" do
  it "It taktes a path, current names and new names" do
    path = Dir.pwd
    curr_names = ["."]
    new_names = ["bar"]

    renamer = SeriesNamer::RenameEpisodes.new( path, curr_names, new_names )

    renamer.path.must_equal path
    renamer.current_names.must_equal curr_names
    renamer.new_names.must_equal new_names
  end

  it "Checks that the path is valid" do
    path = "nonexistent/path"
    curr_names = ["foo"]
    new_names = ["bar"]

    proc {SeriesNamer::RenameEpisodes.new( path, curr_names, new_names )}.must_raise( ArgumentError )
  end

  it "Checks that the current names and the new names have the same length" do
    path = Dir.pwd
    curr_names = ["foo","bar"]
    new_names = ["bar"]

    proc {SeriesNamer::RenameEpisodes.new( path, curr_names, new_names )}.must_raise( ArgumentError )
  end

  it "new names and current names most contain at least one name" do
    path = Dir.pwd
    curr_names = []
    new_names = []

    proc {SeriesNamer::RenameEpisodes.new( path, curr_names, new_names )}.must_raise( ArgumentError )
  end

  it "checks that the episodes are present at the path" do
    path = Dir.pwd
    curr_names = ["non_existent"]
    new_names = ["bar"]

    proc {
      SeriesNamer::RenameEpisodes.new( path, curr_names, new_names, DummyDir.new )
    }.must_raise( ArgumentError )
  end

  it "renames the episode in the path" do
    path = Dir.pwd
    curr_name = ["foo"]
    new_name = ["bar"]

    file_utils_mock = MiniTest::Mock.new
    file_utils_mock.expect(:mv, true, [File.join(path, curr_name), File.join(path, new_name)])

    renamer = SeriesNamer::RenameEpisodes.new( path, curr_name, new_name, DummyDir.new )
    renamer.now(file_utils_mock)

    file_utils_mock.verify.must_equal true
  end
end

