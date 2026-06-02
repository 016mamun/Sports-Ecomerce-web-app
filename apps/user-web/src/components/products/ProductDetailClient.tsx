'use client';

import { useState } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { ShoppingCart, Minus, Plus, Check, ArrowLeft } from 'lucide-react';
import { useCartStore } from '@/lib/store/cart-store';
import ProductCard from './ProductCard';

interface Product {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  compare_price: number | null;
  images: string[];
  stock: number;
  category?: { name: string; slug: string } | null;
}

interface ProductDetailClientProps {
  product: Product;
  relatedProducts: Product[];
}

export default function ProductDetailClient({ product, relatedProducts }: ProductDetailClientProps) {
  const [quantity, setQuantity] = useState(1);
  const [selectedImage, setSelectedImage] = useState(0);
  const [added, setAdded] = useState(false);
  const addItem = useCartStore((s) => s.addItem);

  const discount = product.compare_price && product.compare_price > product.price
    ? Math.round(((product.compare_price - product.price) / product.compare_price) * 100)
    : 0;

  const handleAddToCart = () => {
    addItem({
      id: `${product.id}-${Date.now()}`,
      product_id: product.id,
      quantity,
      product: {
        name: product.name,
        price: product.price,
        images: product.images,
        slug: product.slug,
        stock: product.stock,
      },
    });
    setAdded(true);
    setTimeout(() => setAdded(false), 2000);
  };

  return (
    <div className="container-main py-8">
      {/* Breadcrumb */}
      <div className="flex items-center gap-2 text-sm text-gray-500 mb-6">
        <Link href="/" className="hover:text-accent-500">Home</Link>
        <span>/</span>
        <Link href="/products" className="hover:text-accent-500">Products</Link>
        {product.category && (
          <>
            <span>/</span>
            <Link href={`/products?category=${product.category.slug}`} className="hover:text-accent-500">
              {product.category.name}
            </Link>
          </>
        )}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8 lg:gap-12">
        {/* Images */}
        <div>
          <div className="relative aspect-square bg-gray-100 rounded-xl overflow-hidden mb-4">
            {product.images && product.images.length > 0 ? (
              <Image
                src={product.images[selectedImage]}
                alt={product.name}
                fill
                className="object-cover"
                priority
              />
            ) : (
              <div className="w-full h-full flex items-center justify-center text-gray-400">
                <ShoppingCart size={80} />
              </div>
            )}
          </div>
          {product.images && product.images.length > 1 && (
            <div className="flex gap-2 overflow-x-auto">
              {product.images.map((img, i) => (
                <button
                  key={i}
                  onClick={() => setSelectedImage(i)}
                  className={`relative w-20 h-20 rounded-lg overflow-hidden shrink-0 border-2 transition-colors ${
                    selectedImage === i ? 'border-accent-500' : 'border-transparent'
                  }`}
                >
                  <Image src={img} alt="" fill className="object-cover" />
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Details */}
        <div>
          {product.category && (
            <span className="text-sm text-accent-500 font-medium uppercase tracking-wider">
              {product.category.name}
            </span>
          )}
          <h1 className="text-3xl lg:text-4xl font-bold text-primary-950 mt-2 mb-4">
            {product.name}
          </h1>

          {/* Price */}
          <div className="flex items-center gap-4 mb-6">
            <span className="text-3xl font-bold text-accent-500">
              ৳{product.price.toFixed(2)}
            </span>
            {product.compare_price && product.compare_price > product.price && (
              <>
                <span className="text-xl text-gray-400 line-through">
                  ৳{product.compare_price.toFixed(2)}
                </span>
                <span className="badge bg-red-100 text-red-700">-{discount}%</span>
              </>
            )}
          </div>

          {/* Stock */}
          <div className="mb-6">
            {product.stock > 0 ? (
              <span className="text-green-600 font-medium flex items-center gap-1">
                <Check size={18} /> In Stock ({product.stock} available)
              </span>
            ) : (
              <span className="text-red-600 font-medium">Out of Stock</span>
            )}
          </div>

          {/* Description */}
          {product.description && (
            <div className="mb-8">
              <h3 className="font-semibold text-gray-900 mb-2">Description</h3>
              <p className="text-gray-600 leading-relaxed">{product.description}</p>
            </div>
          )}

          {/* Quantity + Add to Cart */}
          {product.stock > 0 && (
            <div className="flex flex-col sm:flex-row gap-4">
              <div className="flex items-center border rounded-lg">
                <button
                  onClick={() => setQuantity(Math.max(1, quantity - 1))}
                  className="p-3 hover:bg-gray-100 transition-colors"
                >
                  <Minus size={18} />
                </button>
                <span className="w-12 text-center font-medium">{quantity}</span>
                <button
                  onClick={() => setQuantity(Math.min(product.stock, quantity + 1))}
                  className="p-3 hover:bg-gray-100 transition-colors"
                >
                  <Plus size={18} />
                </button>
              </div>
              <button
                onClick={handleAddToCart}
                className={`btn-primary flex-1 flex items-center justify-center gap-2 ${
                  added ? '!bg-green-500' : ''
                }`}
              >
                {added ? (
                  <>
                    <Check size={20} /> Added to Cart!
                  </>
                ) : (
                  <>
                    <ShoppingCart size={20} /> Add to Cart
                  </>
                )}
              </button>
            </div>
          )}

          <Link
            href="/products"
            className="inline-flex items-center gap-2 mt-6 text-gray-600 hover:text-accent-500 transition-colors"
          >
            <ArrowLeft size={18} /> Back to Products
          </Link>
        </div>
      </div>

      {/* Related Products */}
      {relatedProducts.length > 0 && (
        <section className="mt-16">
          <h2 className="section-title">Related Products</h2>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
            {relatedProducts.map((p) => (
              <ProductCard
                key={p.id}
                id={p.id}
                name={p.name}
                slug={p.slug}
                price={p.price}
                comparePrice={p.compare_price}
                images={p.images}
                stock={p.stock}
              />
            ))}
          </div>
        </section>
      )}
    </div>
  );
}
