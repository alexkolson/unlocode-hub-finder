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
                name
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

    context 'with invalid order argument (invalid key)' do
      it 'should return an error' do
        query = <<-GRAPHQL
          query {
            hubs(order: { key: "fake" }) {
              page {
                name
              },
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']).to be_nil
        expect(query_result['errors'].length).to be 1
        expect(query_result['errors'].first['message']).to eq 'order key (fake) must be an attribute on a Hub!'
      end
    end

    context 'with valid filter argument' do
      it 'should return filtered results' do
        query = <<-GRAPHQL
          query {
            hubs(filter: { key: "name", value: "hamburg" }) {
              page {
                name
              },
              totalPages,
              totalHubs
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']['hubs']['totalPages']).to be 2
        expect(query_result['data']['hubs']['totalHubs']).to be 16
      end
    end

    context 'with valid order argument' do
      it 'should return results in ascending order based on given key' do
        query = <<-GRAPHQL
          query {
            hubs(order: { key: "name" }) {
              page {
                name
              },
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']['hubs']['page'].first['name']).to eq("'Ablah")
      end

      it 'should return results in descending order based on given key' do
        query = <<-GRAPHQL
          query {
            hubs(order: { key: "name", desc: true }) {
              page {
                name
              },
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']['hubs']['page'].first['name']).to eq("Üxheim")
      end
    end

    context 'with invalid page number' do
      it 'should return no results' do
        query = <<-GRAPHQL
          query {
            hubs(page: 11124) {
              page {
                name
              },
              nextPage
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']['hubs']['page'].length).to be 0
        expect(query_result['data']['hubs']['nextPage']).to be_nil
      end
    end

    context 'with valid page number' do
      it 'should return specified page of results' do
        query = <<-GRAPHQL
          query {
            hubs(page: 1200, order: { key: "name" }) {
              page {
                name
              },
              nextPage
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']['hubs']['page'].first['name']).to eq('Bolnisi')
        expect(query_result['data']['hubs']['page'].last['name']).to eq('Bolquère')
        expect(query_result['data']['hubs']['nextPage']).to be 1201
      end
    end

    context 'with given page size' do
      it 'should return page of specified page size of results' do
        query = <<-GRAPHQL
          query {
            hubs(pageSize: 100) {
              page {
                name
              },
            }
          }
        GRAPHQL

        query_result = HubFinderApiSchema.execute query

        expect(query_result['data']['hubs']['page'].length).to be 100
      end
    end
  end
end