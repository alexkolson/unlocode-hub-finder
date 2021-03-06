require 'rails_helper'

describe Mutations::DestroyHubs do
  after :all do
    Hub.delete_all
  end

  context 'Database has existing hubs' do
    before :each do
      Hub.delete_all
      HubCSVImporter.import
    end
    it 'succesfully destroys all hubs in DB' do
      destroy_hubs_graphql = <<-GRAPHQL
        mutation {
          destroyHubs {
            success,
            errors
          }
        }
      GRAPHQL

      mutation_result = nil

      expect { mutation_result = HubFinderApiSchema.execute destroy_hubs_graphql }.not_to raise_error
      expect(mutation_result['data']['destroyHubs']['success']).to be true
      expect(mutation_result['data']['destroyHubs']['errors'].length).to be 0
    end
  end

  context 'Database is empty' do
    before :each do
      Hub.delete_all
    end

    it 'fails to destroy any hubs in DB' do
      destroy_hubs_graphql = <<-GRAPHQL
        mutation {
          destroyHubs {
            success,
            errors
          }
        }
      GRAPHQL

      mutation_result = nil

      expect { mutation_result = HubFinderApiSchema.execute destroy_hubs_graphql }.not_to raise_error
      expect(mutation_result['data']['destroyHubs']['success']).to be false
      expect(mutation_result['data']['destroyHubs']['errors'].length).to be 1
      expect(mutation_result['data']['destroyHubs']['errors'].first).to eq 'No Hubs in database to destroy.'
    end
  end
end