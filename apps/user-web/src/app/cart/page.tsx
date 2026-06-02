'use client';

import Image from 'next/image';
import Link from 'next/link';
import { Trash2, Minus, Plus, ShoppingBag } from 'lucide-react';
import { useCartStore } from '@/lib/store/cart-store';

export default function CartPage() {
  const items = useCartStore((s) => s.items);
  const removeItem = useCartStore((s) => s.removeItem);
  const updateQuantity = useCartStore((s) => s.updateQuantity);
  const totalPrice = useCartStore((s) =>
    s.items.reduce((sum, i) => sum + i.quantity * (i.product?.price || 0), 0)
  );

  return (
    <div className="container-main py-8">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-heading font-bold text-primary-950">Shopping Cart</h1>
        <span className="text-gray-500">
          {items.length} item{items.length !== 1 ? 's' : ''}
        </span>
      </div>

      {items.length === 0 ? (
        <div className="text-center py-16">
          <div className="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <ShoppingBag size={40} className="text-gray-400" />
          </div>
          <p className="text-gray-500 text-lg mb-4">Your cart is empty</p>
          <Link href="/products" className="btn-primary">
            Start Shopping
          </Link>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Cart Items */}
          <div className="lg:col-span-2 space-y-4">
            {items.map((item) => (
              <div key={item.id} className="card p-4 flex items-center gap-4">
                <div className="w-20 h-20 bg-gray-100 rounded-lg overflow-hidden shrink-0 relative">
                  {item.product?.images && item.product.images.length > 0 ? (
                    <Image
                      src={item.product.images[0]}
                      alt={item.product.name}
                      fill
                      className="object-cover"
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center">
                      <ShoppingBag size={24} className="text-gray-300" />
                    </div>
                  )}
                </div>
                <div className="flex-1 min-w-0">
                  <Link
                    href={`/products/${item.product?.slug}`}
                    className="font-medium text-gray-900 hover:text-accent-500 line-clamp-1"
                  >
                    {item.product?.name}
                  </Link>
                  <p className="text-accent-500 font-bold">
                    ৳{item.product?.price.toFixed(2)}
                  </p>
                </div>
                <div className="flex items-center border rounded-lg">
                  <button
                    onClick={() => updateQuantity(item.product_id, item.quantity - 1)}
                    className="p-2 hover:bg-gray-100"
                  >
                    <Minus size={14} />
                  </button>
                  <span className="w-8 text-center text-sm font-medium">
                    {item.quantity}
                  </span>
                  <button
                    onClick={() => updateQuantity(item.product_id, item.quantity + 1)}
                    className="p-2 hover:bg-gray-100"
                  >
                    <Plus size={14} />
                  </button>
                </div>
                <button
                  onClick={() => removeItem(item.product_id)}
                  className="p-2 text-red-500 hover:text-red-700 hover:bg-red-50 rounded-lg"
                >
                  <Trash2 size={18} />
                </button>
              </div>
            ))}
          </div>

          {/* Order Summary */}
          <div className="card p-6 h-fit sticky top-24">
            <h2 className="font-heading font-bold text-lg mb-4">Order Summary</h2>
            <div className="space-y-3 text-sm">
              <div className="flex justify-between">
                <span className="text-gray-600">Subtotal</span>
                <span className="font-medium">৳{totalPrice.toFixed(2)}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Shipping</span>
                <span className="font-medium text-green-600">Free</span>
              </div>
              <hr />
              <div className="flex justify-between text-lg font-bold">
                <span>Total</span>
                <span className="text-accent-500">৳{totalPrice.toFixed(2)}</span>
              </div>
            </div>
            <Link href="/checkout" className="btn-primary w-full mt-6 block text-center">
              Proceed to Checkout
            </Link>
            <Link
              href="/products"
              className="block text-center text-sm text-gray-500 hover:text-accent-500 mt-3"
            >
              Continue Shopping
            </Link>
          </div>
        </div>
      )}
    </div>
  );
}
