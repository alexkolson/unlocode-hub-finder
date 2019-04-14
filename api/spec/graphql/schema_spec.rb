require 'rails_helper'

describe HubFinderApiSchema do
  it 'schema file should match actual current schema' do
    current_defn = HubFinderApiSchema.to_definition
    printout_defn = File.read(Rails.root.join('app/graphql/schema.graphql'))
    expect(current_defn).to eq(printout_defn)
  end
end