require File.dirname(__FILE__) + "/acceptance/webrat"

module AcceptanceHelper
  def enable_auth!
    Integrity.config[:use_basic_auth]      = true
    Integrity.config[:admin_username]      = "admin"
    Integrity.config[:admin_password]      = "test"
    Integrity.config[:hash_admin_password] = false
  end
  
  def disable_auth!
    Integrity.config[:use_basic_auth] = false
  end
end

module PrettyStoryPrintingHelper
  def self.included(base)
    base.before(:all) do
      puts
      print "\e[36m"
      puts  self.class.story.to_s.gsub(/^\s+/, '')
      print "\e[0m"
    end

    base.after(:all) do
      puts
    end    
    
    base.extend ClassMethods
  end
  
  module ClassMethods
    def story(story=nil)
      @story = story if story
      @story
    end  
  end
end

class Test::Unit::AcceptanceTestCase < Test::Unit::TestCase
  class << self
    alias :scenario :test
  end

  include AcceptanceHelper
  include WebratIntegrationHelper
  include PrettyStoryPrintingHelper
end