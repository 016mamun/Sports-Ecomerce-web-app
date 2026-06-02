import { createServerSupabaseClient } from '@/lib/supabase/server';
import ProductCard from '@/components/products/ProductCard';
import Link from 'next/link';
import { Filter } from 'lucide-react';

interface ProductsPageProps {
  searchParams: Promise<{ category?: string; search?: string }>;
}

export default async function ProductsPage({ searchParams }: ProductsPageProps) {
  const params = await searchParams;
  const supabase = await createServerSupabaseClient();

  // Fetch categories
  const { data: categories } = await supabase
    .from('categories')
    .select('*')
    .order('name');

  // Build query
  let query = supabase
    .from('products')
    .select('*, category:categories(*)')
    .eq('is_active', true)
    .order('created_at', { ascending: false });

  // Filter by category
  if (params.category) {
    const category = categories?.find((c) => c.slug === params.category);
    if (category) {
      query = query.eq('category_id', category.id);
    }
  }

  // Search
  if (params.search) {
    query = query.ilike('name', `%${params.search}%`);
  }

  const { data: products } = await query;

  return (
    <div className="container-main py-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-primary-950 mb-2">
          {params.category
            ? `${params.category.charAt(0).toUpperCase() + params.category.slice(1)} Products`
            : params.search
            ? `Search: "${params.search}"`
            : 'All Products'}
        </h1>
        <p className="text-gray-600">
          {products?.length || 0} products found
        </p>
      </div>

      <div className="flex flex-col md:flex-row gap-8">
        {/* Sidebar Filters */}
        <aside className="w-full md:w-64 shrink-0">
          <div className="card p-6 sticky top-24">
            <div className="flex items-center gap-2 mb-4">
              <Filter size={20} />
              <h2 className="font-semibold">Categories</h2>
            </div>
            <nav className="space-y-2">
              <Link
                href="/products"
                className={`block px-3 py-2 rounded-lg transition-colors ${
                  !params.category
                    ? 'bg-accent-500 text-white'
                    : 'hover:bg-gray-100 text-gray-700'
                }`}
              >
                All Products
              </Link>
              {categories?.map((category) => (
                <Link
                  key={category.id}
                  href={`/products?category=${category.slug}`}
                  className={`block px-3 py-2 rounded-lg transition-colors ${
                    params.category === category.slug
                      ? 'bg-accent-500 text-white'
                      : 'hover:bg-gray-100 text-gray-700'
                  }`}
                >
                  {category.name}
                </Link>
              ))}
            </nav>
          </div>
        </aside>

        {/* Product Grid */}
        <div className="flex-1">
          {products && products.length > 0 ? (
            <div className="grid grid-cols-2 md:grid-cols-3 gap-6">
              {products.map((product) => (
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
            <div className="text-center py-16">
              <p className="text-gray-500 text-lg mb-2">No products found</p>
              <p className="text-gray-400">Try a different search or category</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
