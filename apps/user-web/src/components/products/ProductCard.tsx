'use client';

import Link from 'next/link';
import Image from 'next/image';
import { ShoppingCart } from 'lucide-react';
import { useCartStore } from '@/lib/store/cart-store';

interface ProductCardProps {
  id: string;
  name: string;
  slug: string;
  price: number;
  comparePrice?: number | null;
  images: string[];
  stock: number;
}

export default function ProductCard({
  id,
  name,
  slug,
  price,
  comparePrice,
  images,
  stock,
}: ProductCardProps) {
  const addItem = useCartStore((s) => s.addItem);
  const discount = comparePrice && comparePrice > price
    ? Math.round(((comparePrice - price) / comparePrice) * 100)
    : 0;

  const handleAddToCart = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    addItem({
      id: `${id}-${Date.now()}`,
      product_id: id,
      quantity: 1,
      product: { name, price, images, slug, stock },
    });
  };

  return (
    <Link href={`/products/${slug}`} className="card group">
      {/* Image */}
      <div className="relative aspect-square bg-gray-100 overflow-hidden">
        {images && images.length > 0 ? (
          <Image
            src={images[0]}
            alt={name}
            fill
            className="object-cover group-hover:scale-105 transition-transform duration-300"
            sizes="(max-width: 768px) 50vw, 25vw"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-gray-400">
            <ShoppingCart size={48} />
          </div>
        )}
        {discount > 0 && (
          <span className="absolute top-3 left-3 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded">
            -{discount}%
          </span>
        )}
        {stock === 0 && (
          <div className="absolute inset-0 bg-black/50 flex items-center justify-center">
            <span className="bg-white text-gray-800 font-bold px-4 py-2 rounded">
              Out of Stock
            </span>
          </div>
        )}
      </div>

      {/* Content */}
      <div className="p-4">
        <h3 className="font-medium text-gray-900 line-clamp-2 mb-2 group-hover:text-accent-500 transition-colors">
          {name}
        </h3>
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="text-lg font-bold text-accent-500">
              ৳{price.toFixed(2)}
            </span>
            {comparePrice && comparePrice > price && (
              <span className="text-sm text-gray-400 line-through">
                ৳{comparePrice.toFixed(2)}
              </span>
            )}
          </div>
        </div>
        {stock > 0 && (
          <button
            onClick={handleAddToCart}
            className="mt-3 w-full btn-primary !py-2 text-sm flex items-center justify-center gap-2"
          >
            <ShoppingCart size={16} />
            Add to Cart
          </button>
        )}
      </div>
    </Link>
  );
}
