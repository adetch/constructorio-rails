namespace :constructorio do
  import_model_desc = <<-DESC.gsub(/    /, '')
    Import data from your model (pass name as CLASS environment variable).

    $ rake environment constructorio:import:model CLASS='MyModel'
  DESC

  task :import => 'import:model'

  namespace :import do
    desc import_model_desc

    task :model => :environment do
      klass  = eval(ENV['CLASS'].to_s)
      fields = ConstructorIORails::Fields.instance.list(klass.model_name)
      if fields.any?
        klass.all.each do |record|
          fields.each do |field|
            record.constructorio_add_record(record[field.to_sym], {}, ConstructorIORails.configuration.autocomplete_key, ConstructorIORails.configuration.autocomplete_section)
          end
        end
      end
    end
  end
end
