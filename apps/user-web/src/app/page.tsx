import Link from 'next/link';
import { ArrowRight, Truck, Shield, Headphones, CreditCard } from 'lucide-react';
import ProductCard from '@/components/products/ProductCard';
import { createServerSupabaseClient } from '@/lib/supabase/server';

export default async function HomePage() {
  const supabase = await createServerSupabaseClient();

  // Fetch featured products
  const { data: featuredProducts } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .order('created_at', { ascending: false })
    .limit(8);

  // Fetch categories
  const { data: categories } = await supabase
    .from('categories')
    .select('*')
    .order('name');

  return (
    <div>
      {/* Hero Section */}
      <section className="bg-gradient-to-r from-primary-950 to-primary-800 text-white">
        <div className="container-main py-16 md:py-24">
          <div className="max-w-2xl">
            <h1 className="text-4xl md:text-6xl font-extrabold mb-6 leading-tight">
              Gear Up for <span className="text-accent-500">Victory</span>
            </h1>
            <p className="text-lg md:text-xl text-gray-300 mb-8">
              Premium sports equipment and accessories for every athlete. 
              From cricket to fitness, we&apos;ve got you covered.
            </p>
            <div className="flex flex-wrap gap-4">
              <Link href="/products" className="btn-primary text-lg flex items-center gap-2">
                Shop Now <ArrowRight size={20} />
              </Link>
              <Link href="/products?category=cricket" className="btn-outline !border-white !text-white hover:!bg-white hover:!text-primary-950 text-lg">
                Browse Categories
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Features Strip */}
      <section className="bg-white border-b">
        <div className="container-main py-8">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-accent-100 rounded-full flex items-center justify-center">
                <Truck size={24} className="text-accent-500" />
              </div>
              <div>
                <h3 className="font-semibold text-sm">Free Delivery</h3>
                <p className="text-xs text-gray-500">On orders over ৳2000</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-accent-100 rounded-full flex items-center justify-center">
                <Shield size={24} className="text-accent-500" />
              </div>
              <div>
                <h3 className="font-semibold text-sm">Quality Guarantee</h3>
                <p className="text-xs text-gray-500">100% authentic products</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-accent-100 rounded-full flex items-center justify-center">
                <Headphones size={24} className="text-accent-500" />
              </div>
              <div>
                <h3 className="font-semibold text-sm">24/7 Support</h3>
                <p className="text-xs text-gray-500">Always here to help</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-accent-100 rounded-full flex items-center justify-center">
                <CreditCard size={24} className="text-accent-500" />
              </div>
              <div>
                <h3 className="font-semibold text-sm">Cash on Delivery</h3>
                <p className="text-xs text-gray-500">Pay when you receive</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Categories Section */}
      <section className="py-16">
        <div className="container-main">
          <div className="flex items-center justify-between mb-8">
            <h2 className="section-title !mb-0">Shop by Category</h2>
            <Link href="/products" className="text-accent-500 hover:text-accent-600 font-medium flex items-center gap-1">
              View All <ArrowRight size={16} />
            </Link>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
            {categories?.slice(0, 8).map((category) => (
              <Link
                key={category.id}
                href={`/products?category=${category.slug}`}
                className="card p-6 text-center hover:border-accent-500 hover:border-2 group"
              >
                <div className="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-3 group-hover:bg-accent-100 transition-colors">
                  <span className="text-2xl font-bold text-primary-950">
                    {category.name.charAt(0)}
                  </span>
                </div>
                <h3 className="font-medium text-gray-900">{category.name}</h3>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Featured Products */}
      <section className="py-16 bg-gray-50">
        <div className="container-main">
          <div className="flex items-center justify-between mb-8">
            <h2 className="section-title !mb-0">New Arrivals</h2>
            <Link href="/products" className="text-accent-500 hover:text-accent-600 font-medium flex items-center gap-1">
              View All <ArrowRight size={16} />
            </Link>
          </div>
          {featuredProducts && featuredProducts.length > 0 ? (
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
              {featuredProducts.map((product) => (
                <ProductCard
                  key={product.id}
                  id={product.id}
                  name={product.name}
                  slug={product.slug}
                  price={product.price}
                  comparePrice={product.compare_price}
                  images={product.images}
                  stock={product.stock}
                />
              ))}
            </div>
          ) : (
            <div className="text-center py-12">
              <p className="text-gray-500 mb-4">No products available yet.</p>
              <p className="text-sm text-gray-400">Check back soon for exciting sports gear!</p>
            </div>
          )}
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-primary-950 text-white">
        <div className="container-main text-center">
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            Ready to Level Up Your Game?
          </h2>
          <p className="text-gray-300 mb-8 max-w-2xl mx-auto">
            Join thousands of athletes who trust FNF Sports for their equipment needs.
            Get started today with our wide selection of premium sports gear.
          </p>
          <Link href="/products" className="btn-primary text-lg inline-flex items-center gap-2">
            Start Shopping <ArrowRight size={20} />
          </Link>
        </div>
      </section>
    </div>
  );
}
