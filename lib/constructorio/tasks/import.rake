namespace :constructorio do
  import_model_desc = <<-DESC.gsub(/    /, '')
    Import data from your model (pass name as CLASS environment variable).

    $ rake environment constructorio:import:model CLASS='MyModel'
  DESC

  task :import => 'import:model'

  namespace :import do
    desc import_model_desc

    task :model do
      klass  = eval(ENV['CLASS'].to_s)
      fields = ConstructorIO::Fields.instance.list(klass.model_name)
      if fields.any?
        klass.all.each do |record|
          fields.each do |field|
            klass.add_record(record[field.to_sym], ConstructorIO.configuration.autocomplete_key)
          end
        end
      end
    end
  end
end
