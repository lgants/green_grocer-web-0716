require 'pry'


def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item|
    item.each do |name, attribute|
      if consolidated_cart.has_key? (name)
        consolidated_cart[name][:count] += 1
      else 
        consolidated_cart = consolidated_cart.merge({name => attribute.merge({count: 1})})
      end
    end 
  end 
  consolidated_cart
end


def apply_coupons(cart, coupons)
  cart_cons = cart
  coupons.each do |coupon|
    item_name = coupon[:item]
     if cart_cons.keys.include?(item_name)
       cart_count = cart_cons[item_name][:count]
       if cart_count >= coupon[:num]
         item_coup = {"#{item_name} W/COUPON" => {price: coupon[:cost], clearance: cart_cons[item_name][:clearance], count: cart_count/coupon[:num]}}
        cart_cons[item_name][:count] %= coupon[:num]
         cart_cons = cart_cons.merge(item_coup)
       end
    end
  end
  cart_cons
end


def apply_clearance(cart) 
  cart.each do |item, attribute|
      if attribute[:clearance] == true
        discount = attribute[:price]*0.8
        attribute[:price] = discount.round(2) 
    end
  end 
  cart
end


def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |item, properties|
    total += properties[:price] * properties[:count]
  end 
  total > 100 ? total -= total * 0.1 : nil
  total
end


