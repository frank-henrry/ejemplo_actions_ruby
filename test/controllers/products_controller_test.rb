require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @product = products(:one)
  end

  test "should not save product without name" do
    product = Product.new(price: 100, description: "No Name", stock: 10)
    assert_not product.save, "Saved the product without a name"
  end

  test "price should be greater than 0" do
    product = Product.new(name: "Test Product", price: -1, description: "Invalid Price", stock: 10)
    assert_not product.valid?
    assert_includes product.errors[:price], "must be greater than 0"
  end

  test "should have expiration date in the future" do
    product = Product.new(name: "Test Product", price: 100, description: "Future Expiration", stock: 10, expiration_date: Date.yesterday)
    assert_not product.valid?
    assert_includes product.errors[:expiration_date], "must be in the future"
  end

  test "should not create product without stock" do
    product = Product.new(name: "Test Product", price: 100, description: "No Stock", stock: 0)
    assert_not product.valid?
    assert_includes product.errors[:stock], "must be greater than 0"
  end

  test "should apply discount to product price" do
    product = Product.new(name: "Discounted Product", price: 100, description: "Discounted", stock: 10)
    product.descuento(10)
    assert_equal 90, product.price
  end

  test "should assign category" do
    product = Product.new(name: "Categorized Product", price: 100, description: "Categorized", stock: 10)
    product.asig_categoria("Electrodomésticos")
    assert_equal "Electrodomésticos", product.categoria
  end

  test "should check if product has free shipping" do
    product = Product.new(name: "Free Shipping Product", price: 100, description: "Free Shipping", stock: 10, categoria: "Electrodomésticos")
    assert product.produc_envio_gratis
  end

  test "should check if product is luxury" do
    product = Product.new(name: "Luxury Product", price: 300, description: "Luxury", stock: 10, categoria: "Tecnología")
    assert product.luxury_product?
  end

  test "should calculate tax" do
    product = Product.new(name: "Taxed Product", price: 100, description: "Taxed", stock: 10, categoria: "alcohol")
    assert_equal 18, product.calculate_tax
  end

  test "should check if product is perishable" do
    product = Product.new(name: "Perishable Product", price: 100, description: "Perishable", stock: 10, categoria: "food")
    assert product.perishable?
  end
  # setup do
  #   @product = products(:one)
  # end

  # test "should not save product without name" do
  #   product = Product.new(price: 100, description: "No Name", stock: 10)
  #   assert_not product.save, "Saved the product without a name"
  # end

  # test "price should be greater than 0" do
  #   product = Product.new(name: "Test Product", price: -1, description: "Invalid Price", stock: 10)
  #   assert_not product.valid?
  #   assert_includes product.errors[:price], "must be greater than 0"
  # end

  # test "should have expiration date in the future" do
  #   product = Product.new(name: "Test Product", price: 100, description: "Future Expiration", stock: 10, expiration_date: Date.yesterday)
  #   assert_not product.valid?
  #   assert_includes product.errors[:expiration_date], "must be in the future"
  # end

  # test "should not create product without stock" do
  #   product = Product.new(name: "Test Product", price: 100, description: "No Stock", stock: 0)
  #   assert_not product.valid?
  #   assert_includes product.errors[:stock], "must be greater than 0"
  # end

  # test "should not create product with duplicate name" do
  #   product1 = Product.create(name: "Unique Product", price: 100, description: "First Product", stock: 10)
  #   product2 = Product.new(name: "Unique Product", price: 150, description: "Duplicate Product", stock: 5)
  #   assert_not product2.valid?
  #   assert_includes product2.errors[:name], "has already been taken"
  # end

  # test "should not create product with invalid expiration date" do
  #   product = Product.new(name: "Test Product", price: 100, description: "Invalid Expiration", stock: 10, expiration_date: "invalid_date")
  #   assert_not product.valid?
  #   assert_includes product.errors[:expiration_date], "is not a valid date"
  # end

  # test "should create product with valid attributes" do
  #   product = Product.new(name: "Valid Product", price: 100, description: "Valid Description", stock: 10, expiration_date: Date.tomorrow)
  #   assert product.valid?
  # end

  # test "should not create product without stock" do
  #   product = Product.new(name: "Test Product", price: 100, description: "No Stock", stock: 0)
  #   assert_not product.valid?
  #   assert_includes product.errors[:stock], "must be greater than 0"
  # end

  # test "should not create product with empty description" do
  #   product = Product.new(name: "Test Product", price: 100, description: "", stock: 10)
  #   assert_not product.valid?
  #   assert_includes product.errors[:description], "can't be blank"
  # end

  # test "should not create product with non-integer stock" do
  #   product = Product.new(name: "Test Product", price: 100, description: "Non-integer Stock", stock: 10.5)
  #   assert_not product.valid?
  #   assert_includes product.errors[:stock], "must be an integer"
  # end

  # test "should apply discount to product price" do
  #   product = Product.new(name: "Discounted Product", price: 100, description: "Discounted", stock: 10)
  #   product.apply_discount(10)
  #   assert_equal 90, product.price
  # end

  # test "should restock product" do
  #   product = Product.new(name: "Restock Product", price: 100, description: "Restock", stock: 10)
  #   product.restock(5)
  #   assert_equal 15, product.stock
  # end

  # test "should reduce stock of product" do
  #   product = Product.new(name: "Reduce Stock Product", price: 100, description: "Reduce Stock", stock: 10)
  #   product.reduce_stock(5)
  #   assert_equal 5, product.stock
  # end

  # test "should not reduce stock below zero" do
  #   product = Product.new(name: "Reduce Stock Product", price: 100, description: "Reduce Stock", stock: 10)
  #   product.reduce_stock(15)
  #   assert_includes product.errors[:stock], "not enough stock available"
  # end

  # test "should check if product is in stock" do
  #   product = Product.new(name: "In Stock Product", price: 100, description: "In Stock", stock: 10)
  #   assert product.in_stock?
  # end

  # test "should check if product is out of stock" do
  #   product = Product.new(name: "Out of Stock Product", price: 100, description: "Out of Stock", stock: 0)
  #   assert product.out_of_stock?
  # end

  # test "should check if product is near expiration" do
  #   product = Product.new(name: "Near Expiration Product", price: 100, description: "Near Expiration", stock: 10, expiration_date: 2.weeks.from_now)
  #   assert product.near_expiration?
  # end

  # test "should check if product is expired" do
  #   product = Product.new(name: "Expired Product", price: 100, description: "Expired", stock: 10, expiration_date: Date.yesterday)
  #   assert product.expired?
  # end

  # test "should set new expiration date" do
  #   product = Product.new(name: "Set Expiration Product", price: 100, description: "Set Expiration", stock: 10)
  #   new_date = Date.tomorrow
  #   product.set_expiration_date(new_date)
  #   assert_equal new_date, product.expiration_date
  # end

  # test "should check if price is greater than a given value" do
  #   product = Product.new(name: "Price Check Product", price: 100, description: "Price Check", stock: 10)
  #   assert product.price_greater_than?(50)
  # end
  # setup do
  #   @product = products(:laptop)
  # end

  # test "verificamos si el producto se esta creando"do
  #   product = Product.new(name: "laptop", price:1500, description: "segunda")
  #   assert product.valid?
  #   assert_equal 1500, product.price
  #   assert_equal "laptop", product.name
  # end

  # test "verificamos si index esta carcagndo correctamente"do
  #   get products_path
  #   assert_response :success
  #   assert_select '.help'
  # end

  # test "en index validamos si es products con h1"do
  #   get products_path
  #   assert_select "h1", "Products", "New product"
  # end

  #   test "validamo un producto"do 
  #     product = Product.new(name: "user", price:15, description:"muy bueno")

  #     product.valid?
  #     assert_equal "user", product.name
  #   end

  # test "validamos si el resultado de nombre es nulo"do
  #   product = Product.new(name: "user",price:15, description:"muy bueno")
  #   assert_not_nil product.name
  # end
  # test "debe lanzar ActiveRecord::RecordInvalid si el nombre está vacío" do
  #   assert_raises(ActiveRecord::RecordInvalid) do
  #     Product.create!(name: nil, price: 100, description: "Sin nombre")
  #   end
  # end


  # test "debe mostrar el título en la página de índice" do
  #   get products_url
  #   assert_select "h1", "Products"
  # end

  # test "2-verificamos si el producto esta creado"do
  #   product = Product.find_by(name:"laptop")
  #   assert_not_nil product, "no se encontro"
  #   assert_equal "laptop", product.name
  #   assert_equal 1500, product.price
  #   assert_not_nil product.description
  # end

  # test "verificamos si el producto tenga nombre" do
  #   product = Product.create(name: "laptop", price:1500, description: "segunda")
  #   assert_not_nil product.id
  # end
  # test "debe contener error si el nombre esta vacío" do
  #   product = Product.new(name: "", price:1500, description: "segunda")
  #   product.valid?
  #   assert_includes product.errors[:name], "can't be blank"  # Pasa si el error existe
  # end

  # test "descripción debe contener la palabra oferta" do
  #   product = Product.new(name: "Tablet", price: 300, description: "Gran oferta en tecnología")

  #   assert_match /oferta/i, product.description  #Pasa porque la descripción contiene "oferta"
  # end


  # test "debe obtener la página de index" do
  #   get products_url
  #   assert_response :success  # Verifica que la respuesta sea 200 OK
  # end
  
  # test "debe redirigir después de crear un producto" do
  #   post products_url, params: { product: { name: "Tablet", price: 299, description: "Pantalla grande" } }
  #   assert_response :redirect  # Verifica que hubo redirección (302)
  # end
  
  # test "debe redirigir a show después de crear un producto" do
  #   post products_url, params: { product: { name: "Tablet", price: 299, description: "Pantalla grande" } }
    
  #   assert_redirected_to product_path(Product.last)  # Verifica que redirige a la página del producto creado
  # end
  

  
  # test "debe crear un producto" do
  #   assert_difference('Product.count', 1) do
  #     post products_url, params: { product: { name: "Mouse", price: 50, description: "Óptico" } }
  #   end
  # end

  # test "debe eliminar un producto" do
  #   product = products(:laptop)
    
  #   assert_difference('Product.count', -1) do
  #     delete product_url(product)
  #   end
  # end
  
  # test "no debe crear un producto sin nombre" do
  #   assert_no_difference('Product.count') do
  #     post products_url, params: { product: { name: "", price: 50, description: "Sin nombre" } }
  #   end
  # end
  









  # setup do
  #   @product = products(:one)
  # end

  # test "should get index" do
  #   get products_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_product_url
  #   assert_response :success
  # end

  # test "should create product" do
  #   assert_difference("Product.count") do
  #     post products_url, params: { product: { description: @product.description, name: @product.name, price: @product.price } }
  #   end

  #   assert_redirected_to product_url(Product.last)
  # end

  # test "should show product" do
  #   get product_url(@product)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_product_url(@product)
  #   assert_response :success
  # end

  # test "should update product" do
  #   patch product_url(@product), params: { product: { description: @product.description, name: @product.name, price: @product.price } }
  #   assert_redirected_to product_url(@product)
  # end

  # test "should destroy product" do
  #   assert_difference("Product.count", -1) do
  #     delete product_url(@product)
  #   end

  #   assert_redirected_to products_url
  # end
end
