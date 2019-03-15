require 'pry'

def count_elements(hash_array)
  new_array = []
  hash_array.each do |pair|
    new_hash = {}
    pair_count = hash_array.count(pair)
    pair.each do |key, value|
      new_hash[key] = value
    end
    new_hash[:count] = pair_count
    new_array << new_hash
  end
  new_array.uniq
end

def consolidate_cart(cart)
  new_cart = count_elements(cart).each do |hash|
    hash[hash.keys[0]][:count] = hash.delete(:count)
  end
  new_hash = {}
  new_cart.each do |hash|
    hash.each do |key, value|
      new_hash[key] = value
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_hash = {}
  cart.each do |item, info|
    new_hash[item] = info
    coupon_count = 0
    coupons.each do |coupon|
      #binding.pry
      if item == coupon[:item] && info[:count] >= coupon[:num]
        new_count = info[:count] - coupon[:num]
        new_hash[item][:count] = new_count
        new_hash["#{item} W/COUPON"] = {}
        new_hash["#{item} W/COUPON"][:price] = coupon[:cost]
        new_hash["#{item} W/COUPON"][:clearance] = info[:clearance]
        coupon_count += 1
        new_hash["#{item} W/COUPON"][:count] = coupon_count
      end
    end
  end
  new_hash
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated, coupons)
  clearance_applied = apply_clearance(coupons_applied)
  sum = 0
  clearance_applied.each do |item, info|
    sum += (info[:price] * info[:count])
  end
  if sum > 100
    sum = (sum * 0.9).round(2)
  end
  sum
end