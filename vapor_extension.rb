require_dependency "application_controller"
require "radiant-vapor-extension"

class VaporExtension < Radiant::Extension
  version     RadiantVaporExtension::VERSION
  description RadiantVaporExtension::DESCRIPTION
  url         RadiantVaporExtension::URL

  def activate
    tab 'Tools', :before => "Settings"  do
      add_item 'Redirects', '/admin/flow_meters'
    end
    
    FlowMeter.initialize_all if ActiveRecord::Base.connection.tables.include?('flow_meters')
    
    Page.class_eval { include PageVapor }
    
    admin.pages.edit.add :form, 'vapor_details', :before => 'edit_title'
    
    if admin.respond_to? :help
      admin.help.index.add :page_details, 'slug_redirect', :after => 'slug'
    end
    
    Admin::PagesController.class_eval {
      helper Admin::PageNodeAlterationsHelper
    }
  end
end
