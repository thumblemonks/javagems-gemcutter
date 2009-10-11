require 'test_helper'
require 'crack'

class VersionsControllerTest < ActionController::TestCase

  context 'GET to index' do
    setup do
      @rubygem = Factory(:rubygem)
      @versions = (1..5).map do |version|
        Factory(:version, :rubygem => @rubygem)
      end

      get :index, :rubygem_id => @rubygem.name
    end

    should_respond_with :success
    should_render_template :index
    should_assign_to(:rubygem) { @rubygem }
    should_assign_to(:versions) { @rubygem.reload.versions }

    should "show all related versions" do
      @versions.each do |version|
        assert_contain version.number
      end
    end
    
    context "in JSON format" do
      setup do
        get :index, :rubygem_id => @rubygem.name, :format => "json"
      end
      should_respond_with :success
      should "return a json hash" do
        assert_not_nil JSON.parse(@response.body)
      end
    end
    
    context "in XML format" do
      setup do
        get :index, :rubygem_id => @rubygem.name, :format => "xml"
      end
      should_respond_with :success
      should "return a xml hash" do
        assert_not_nil Crack::XML.parse(@response.body)
      end
    end
  end

  context "On GET to show" do
    setup do
      @latest_version = Factory(:version)
      @rubygem = @latest_version.rubygem
      get :show, :rubygem_id => @rubygem.name, :id => @latest_version.number
    end

    should_respond_with :success
    should_render_template "rubygems/show"
    should_assign_to :rubygem
    should_assign_to(:latest_version) { @latest_version }
    should "render info about the gem" do
      assert_contain @rubygem.name
      assert_contain @latest_version.number
      assert_contain @latest_version.built_at.to_date.to_formatted_s(:long)
    end
    
    context "in JSON format" do
      setup do
        @current_version = Factory(:version)
        @rubygem = @current_version.rubygem
        get :show, :rubygem_id => @rubygem.name, :id => @current_version.number, :format => "json"
      end
      should "return a json hash" do
        assert_not_nil JSON.parse(@response.body)
      end
    end
    
    context "in XML format" do
      setup do
        @current_version = Factory(:version)
        @rubygem = @current_version.rubygem
        get :show, :rubygem_id => @rubygem.name, :id => @current_version.number, :format => "xml"
      end
      should "return a xml hash" do
        assert_not_nil Crack::XML.parse(@response.body)
      end
    end
    
    context "in YAML format" do
      setup do
        @current_version = Factory(:version)
        @rubygem = @current_version.rubygem
        get :show, :rubygem_id => @rubygem.name, :id => @current_version.number, :format => "yaml"
      end
      should_respond_with :success
      should "return a yaml hash" do
        assert_not_nil YAML.parse(@response.body)
      end
    end
  end

end

