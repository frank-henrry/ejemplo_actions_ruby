class Product < ApplicationRecord
  CATEGORIAS = ['Electrodomésticos', 'Herramientas', 'Juguetes', 'Libros', 'Ropa', 'Tecnología']
  CATE_PREMIUN = ['Electrodomésticos', 'Tecnología']
  CATE_BEBIDAS = ['alcohol', 'tabaco']
  CATE_PERECEDERO = ['food', 'medicine', 'beverages']

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { only_integer: true, greater_than: 0 }
  validate :expiration_date_must_be_in_the_future

  # Calcula el impuesto basado en la categoría del producto
  def calculate_tax
    if CATE_BEBIDAS.include?(categoria)
      impuesto = price * 0.18
    else
      impuesto = price * 0.10
    end
    impuesto
  end

  # Aplica un descuento al precio del producto si el precio con descuento es mayor o igual al precio mínimo
  def descuento(porcen_descuento, min_price = 5)
    discounted_price = price - (price * porcen_descuento / 100)
    self.price = discounted_price if discounted_price >= min_price
  end

  # Asigna una categoría al producto si está en la lista de categorías permitidas
  def asig_categoria(categoria)
    if CATEGORIAS.include?(categoria)
      self.categoria = categoria
    else
      self.categoria = 'Sin categoria'
    end
  end

  # Verifica si el producto califica para envío gratis
  def produc_envio_gratis
    price >= 50 || CATE_PREMIUN.include?(categoria)
  end

  # Verifica si el producto califica para promociones basadas en el stock y la fecha de expiración
  def control_de_promociones
    stock >= 10 && expiration_date.nil?
  end

  # Aplica un descuento por cantidad si la cantidad es mayor o igual a 5
  def bulk_discount_price(quantity)
    if quantity >= 5
      self.price = price * 0.90
    end
  end

  # Verifica si el producto es de lujo basado en el precio y la categoría
  def luxury_product?
    price >= 200 && CATE_PREMIUN.include?(categoria)
  end

  # Aplica un descuento basado en el tipo de membresía
  def apply_membership_discount(membership_type)
    case membership_type
    when 'Gold Membership'
      self.price *= 0.80
    when 'Silver Membership'
      self.price *= 0.90
    else
      puts "error"
    end
  end

  # Verifica si el producto es perecedero basado en la categoría
  def perishable?
    CATE_PERECEDERO.include?(categoria)
  end

  # Verifica si el producto es elegible para devolución basado en la fecha de compra y si es perecedero
  def return_eligible?(purchase_date)
    !perishable? && purchase_date >= 30.days.ago
  end

  # Verifica si el stock del producto es bajo
  def low_stock?
    stock <= 5
  end

  # Aplica un descuento al precio del producto si la fecha de expiración está cerca
  def apply_expiration_discount
    if expiration_date.present? && expiration_date <= 7.days.from_now
      self.price *= 0.70
    end
  end

  # Calcula los puntos de lealtad basados en el precio total
  def calculate_loyalty_points(total_price)
    if total_price >= 100
      puntos = (total_price / 10).to_i
    else
      puntos = (total_price / 20).to_i
    end
    puntos
  end

  # Valida la disponibilidad del stock basado en la orden
  def validate_stock_availability(orden)
    if orden > stock
      puts "Producto no disponible"
    else
      self.stock -= orden
      puts "Producto disponible"
    end
  end

  # Calcula el precio final del producto basado en la ubicación y las tasas de impuestos
  def calculate_final_price(ubicacion)
    tax_rates = {
      "EE.UU" => 0.08,
      "Canadá" => 0.10,
      "México" => 0.16
    }

    impuesto = tax_rates[ubicacion] || 0
    self.price += self.price * impuesto
  end

  # Verifica si el usuario puede dejar una reseña basado en la fecha de compra
  def can_leave_review?(purchase_date)
    if purchase_date <= Date.today - 30
      puts "Puede dejar una reseña"
    else
      puts "No puede dejar una reseña"
    end
  end

  # Valida la restricción de edad para el producto
  def validate_age_restriction(age_restriction)
    if age_restriction >= 18
      puts "Producto disponible"
    else
      puts "Producto no disponible"
    end
  end

  # Estima el tiempo de entrega basado en la ubicación y la distancia
  def estimate_delivery_time(ubicacion, distancia)
    case distancia
    when 0..50
      puts "El tiempo de entrega es de 1 día"
    when 51..200
      puts "El tiempo de entrega es de 3 días"
    when 201..500
      puts "El tiempo de entrega es de 5 días"
    else
      puts "El tiempo de entrega es de 15 días"
    end
  end

  # Aplica un descuento por cantidad basado en la cantidad comprada
  def apply_bulk_discount(quantity)
    if quantity >= 5 && quantity <= 10
      self.price *= 0.95
    elsif quantity > 10
      self.price *= 0.90
    else
      puts "No aplica descuento"
    end
  end

  # Determina el origen del producto basado en el nombre del producto
  def product_origin(product_name)
    case product_name
    when "Electrodomésticos", "Juguetes", "Ropa", "Tecnología"
      puts "Producto importado"
    when "Herramientas", "Libros"
      puts "Producto nacional"
    else
      puts "Producto no disponible"
    end
  end

  # Verifica si el producto necesita reabastecimiento basado en la última fecha de compra
  def needs_restock?(last_purchase_date)
    if last_purchase_date <= 30.days.ago
      puts "Necesita reabastecimiento"
    else
      puts "No necesita reabastecimiento"
    end
  end

  private

  # Validación personalizada para verificar que la fecha de vencimiento esté en el futuro
  def expiration_date_must_be_in_the_future
    if expiration_date.present? && expiration_date < Date.today
      errors.add(:expiration_date, "must be in the future")
    end
  end

  # Aplica un descuento si el precio es mayor o igual a 80
  def oferta
    if price >= 80
      self.price = price * 0.80
    end
  end

  # Verifica si el producto tiene garantía extendida basado en la categoría
  def extended_warranty?
    CATE_PREMIUN.include?(categoria)
  end

  # Verifica si el código de descuento es válido
  def valid_discount_code?(code)
    code == 'DESCUENTO'
  end

  # Verifica si el producto es elegible para devolución basado en la fecha de compra y si es perecedero
  def return_eligible?(purchase_date)
    !perishable? && purchase_date >= 30.days.ago
  end

  # Verifica si el stock del producto es bajo
  def low_stock?
    stock <= 5
  end

  # Aplica un descuento basado en el tipo de membresía
  def apply_membership_discount(tipo_membresia)
    case tipo_membresia
    when "Premium"
      self.price *= 0.80
    when "Gold"
      self.price *= 0.90
    else  
      'Error'
    end
  end

  # Estima el tiempo de entrega basado en la distancia
  def estimate_delivery_time(distance)
    case distance
    when 0..50
      puts "El tiempo de entrega es de 1 día"
    when 51..200
      puts "El tiempo de entrega es de 3 días"
    when 201..500
      puts "El tiempo de entrega es de 5 días"
    else
      puts "El tiempo de entrega es de 15 días"
    end
  end

  # Verifica si el producto necesita reabastecimiento basado en la última fecha de compra
  def needs_restock?(last_purchase_date)
    last_purchase_date <= 30.days.ago
  end

  # Calcula los puntos de fidelidad basados en el precio total
  def puntos_fidelidad(precio_total)
    if precio_total >= 100
      puntos = (price / 10).to_i
    elsif precio_total < 100
      puntos = (price / 20).to_i
    end
    puntos
  end

  # Verifica si el usuario puede dejar una reseña basado en la fecha de compra
  def puede_dejar_reseña(fecha_compra)
    fecha_compra <= Date.today - 30
  end
end