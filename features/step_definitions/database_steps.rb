require 'uri'
require 'cgi'
require_relative '../support/paths'
require_relative '../../ruby-scripts/deployment-scripts'

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

Given /database is reset$/ do
    Deployment.resetDatabase
    Deployment.testData
end
  