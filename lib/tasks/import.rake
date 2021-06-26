require 'csv'

namespace :import do

  desc "Import inventory movement"
  task movements: :environment do
    filepath = File.join Rails.root, "movimentacao_de_estoque.csv"

    CSV.foreach(filepath) do |row|
      storage_name, date, type, product_name, quantity = row
      
      storage = Storage.find_or_create_by(name: storage_name)
      product = Product.find_or_create_by(name: product_name)

      if storage.persisted? and product.persisted?
        movement = Movement.create(date: date, movement_type: type, quantity: quantity, product_id: product.id, storage_id: storage.id)
        movement.save if movement.valid?
      end
    end
  end

end