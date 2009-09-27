class VersionsController < ApplicationController
  before_filter :find_rubygem

  def index
    @versions = @rubygem.versions
    respond_to do |wants|
      wants.html
      wants.json { render :json => @versions }
      wants.xml  { render :xml  => @versions }
      # wants.yaml { render :text => @versions.to_yaml, :content_type => 'text/yaml' }
    end
  end

  def show
    @latest_version = Version.find_from_slug!(@rubygem.id, params[:id])
    respond_to do |wants|
      wants.html { render "rubygems/show" }
      wants.json { render :json => @latest_version }
      wants.xml  { render :xml  => @latest_version }
      wants.yaml { render :text => @latest_version.to_yaml, :content_type => 'text/yaml' }
    end
  end

  protected

  def find_rubygem
    @rubygem = Rubygem.find_by_name(params[:rubygem_id])
  end
  
  def array_to_format(format = :xml)
    public_api_info.to_xml
  end

end
