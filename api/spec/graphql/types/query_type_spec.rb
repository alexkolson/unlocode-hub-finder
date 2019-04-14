require 'rails_helper'

describe Types::QueryType do
  before :all do
    Hub.delete_all
    HubCSVImporter.import
  end

  after :all do
    Hub.delete_all
  end

end