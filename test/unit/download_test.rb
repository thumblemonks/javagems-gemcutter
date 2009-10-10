require File.dirname(__FILE__) + '/../test_helper'

class DownloadTest < ActiveSupport::TestCase
  should "be valid with factory" do
    assert_valid Factory.build(:download)
  end
  should_belong_to :version
  should_have_db_index :version_id

  should "load up all downloads with just raw strings and process them" do
    rubygem = Factory(:rubygem, :name => "some-stupid13-gem42-name9000")
    version = Factory(:version, :rubygem => rubygem)

    3.times do
      raw_download = Download.new(:raw => "#{rubygem.name}-#{version.number}")
      raw_download.perform
      assert_equal raw_download.reload.version, version
    end

    assert_equal 3, version.reload.downloads_count
    assert_equal 3, rubygem.reload.downloads
  end

  should "track platform gem downloads correctly" do
    rubygem = Factory(:rubygem)
    version = Factory(:version, :rubygem => rubygem, :platform => "mswin32-60")
    other_platform_version = Factory(:version, :rubygem => rubygem, :platform => "mswin32")

    raw_download = Download.new(:raw => "#{rubygem.name}-#{version.number}-mswin32-60")
    raw_download.perform

    assert_equal raw_download.reload.version, version
    assert_equal 1, version.reload.downloads_count
    assert_equal 1, rubygem.reload.downloads
    assert_equal 0, other_platform_version.reload.downloads_count
  end

  context "with downloads" do
    setup do
      Factory(:download, :created_at => 1.day.ago)
      Factory(:download, :created_at => 1.day.ago)
      Factory(:download, :created_at => 2.days.ago)
      Factory(:download, :created_at => 30.days.ago)
    end

    should "return counts grouped by created_at from past 30 days" do
      counts = Download.counts_grouped_by_created_at_from_past(30.days)

      assert_equal 2, counts.first.count.to_i
      assert counts.all? { |record| record.count && record.created_at }

      [1, 2, 30].each do |number|
        assert counts.find { |record|
          record.created_at.to_date == number.days.ago.to_date
        }
      end
    end

    should "return sparkline data from past 5 days" do
      assert_equal [0, 0, 1, 2, 0], Download.sparkline_data_from_past(5.days)
    end
  end
end
