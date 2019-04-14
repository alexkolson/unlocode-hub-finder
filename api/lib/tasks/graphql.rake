# lib/tasks/graphql.rake
namespace :graphql do
  namespace :schema do
    task dump: :environment do
      schema_defn = HubFinderApiSchema.to_definition
      schema_path = "app/graphql/schema.graphql"
      File.write(Rails.root.join(schema_path), schema_defn)
      puts "Updated #{schema_path}"
    end
  end
end