require 'csv'
class HomeController < ApplicationController
  def index
  end

  def import
    @count = 0
    @errors = []
    byebug
    CSV.foreach(params[:file]) do |row|
      storage_name, date, movement_type, product_name, quantity = row
      
      storage = Storage.find_or_initialize_by(name: storage_name)
      product = Product.find_or_initialize_by(name: product_name)

      if !storage.valid?
        @errors << {row: row, message: "Local de armazenamento inválido"}
        next
      end
      if !product.valid?
        @errors << {row: row, message: "Produto inválido"}
        next
      end


      if movement_type == "S"
        if check_stock(product) <= 0
          @errors << {row: row, message: "Não há estoque disponível para retirada"}
          next
        end
      end
        
      movement = Movement.create(date: date, movement_type: movement_type, quantity: quantity, product: product, storage: storage)
      if movement.valid?
        product.save
        storage.save
        movement.save
        @count += 1
      end
        
    end

    

    render inline: """
      <h1> <%= \"#{@count} movimentações importadas.\" unless @count.nil? %> </h1>

      <br><br>
      <ul>
        <% @errors.each do |error| %>
          <li><%= error[:row].to_s + \", \t \" + error[:message] %></li>
        <% end %>
      </ul>
      """

      # <%= \"#{error[:row]},  #{error[:message]}\" %>
    # redirect_to root_path(count: @count), notice: "Movimentações carregadas"

  end

  def check_stock (product_id)
    Movement.where(product_id: product_id, movement_type: "E").sum(:quantity)
    - Movement.where(product_id: product_id, movement_type: "S").sum(:quantity)
  end

end
