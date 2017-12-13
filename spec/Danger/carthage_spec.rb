require "danger"
require_relative "../../Danger/carthage"

describe "execute" do

  before :each do
    @dangerfile = double "dangerfile"
    @subject = Danger::Plugins::Carthage.new @dangerfile
    @git = double "git"
    allow(@dangerfile).to receive(:git) { @git }
  end

  context "when files in Sources/xcproj have been added/deleted" do

    before :each do
      allow(@git).to receive(:added_files) { ["Sources/xcproj/added.swift", "Tests/something.swift"] }
      allow(@git).to receive(:deleted_files) { ["Sources/xcproj/removed.swift", "test"] }
    end

    it "should fail with the correct message" do
      expect(@dangerfile).to receive(:fail).with("Source files have been added or removed. Execute `bundle exec rake generate_carthage_project` to regenerate the Carthage.xcodeproj")
      @subject.execute()
    end

  end

  context "when none files in Sources/xcproj have been added/deleted" do

    before :each do
      allow(@git).to receive(:added_files) { ["Tests/something.swift"] }
      allow(@git).to receive(:deleted_files) { ["test"] }
    end

    it "shouldn't fail" do
      expect(@dangerfile).to_not receive(:fail)
      @subject.execute()
    end

  end

end
