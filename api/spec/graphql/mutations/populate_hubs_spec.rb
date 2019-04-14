require 'rails_helper'

describe Mutations::PopulateHubs do
  after :all do
    Hub.delete_all
  end

  context 'Database has existing hubs' do
    before :each do
      Hub.delete_all
      HubCSVImporter.import
    end

    it 'fails to populate any hubs into DB' do
      populate_hubs_graphql = <<-GRAPHQL
        mutation {
          populateHubs {
            success,
            errors
          }
        }
      GRAPHQL

      @mutation_result = HubFinderApiSchema.execute populate_hubs_graphql

      expect(@mutation_result['data']['populateHubs']['success']).to be false
      expect(@mutation_result['data']['populateHubs']['errors'].length).to be 1
      expect(@mutation_result['data']['populateHubs']['errors'].first).to eq 'Hubs present in database. Database must be empty in order for this mutation to succeed.'
    end
  end

  context 'Database is empty' do
    before :each do
      Hub.delete_all
    end

    it 'successfully populates all hubs into the DB' do
      populate_hubs_graphql = <<-GRAPHQL
        mutation {
          populateHubs {
            success,
            errors
          }
        }
      GRAPHQL

      @mutation_result = HubFinderApiSchema.execute populate_hubs_graphql

      expect(@mutation_result['data']['populateHubs']['success']).to be true
      expect(@mutation_result['data']['populateHubs']['errors'].length).to be 0
    end
  end
end