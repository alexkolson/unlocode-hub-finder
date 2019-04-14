require 'rails_helper'

describe Types::QueryType do
  before :all do
    Hub.delete_all
    HubCSVImporter.import
  end

  after :all do
    Hub.delete_all
  end

  describe 'hubs query' do
    context 'without arguments' do
      it 'should return the first page of hubs' do
        query = <<-GRAPHQL
          query {
            hubs {
              page {
                id
              },
              nextPage,
              totalPages,
              totalHubs
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']['hubs']['page'].length).to be 10
        expect(query_result['data']['hubs']['totalPages']).to be 11123
        expect(query_result['data']['hubs']['totalHubs']).to be 111228
        expect(query_result['data']['hubs']['nextPage']).to be 2
      end
    end

    context 'with invalid filter argument (invalid key)' do
      it 'should return an error' do
        query = <<-GRAPHQL
          query {
            hubs(filter: { key: "fake", value: "ham" }) {
              page {
                name
              },
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']).to be_nil
        expect(query_result['errors'].length).to be 1
        expect(query_result['errors'].first['message']).to eq 'filter key (fake) must be an attribute on a Hub!'
      end
    end
  end
end