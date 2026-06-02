import { createServerSupabaseClient } from '@/lib/supabase/server';
import { notFound } from 'next/navigation';
import ProductDetailClient from '@/components/products/ProductDetailClient';

interface ProductDetailPageProps {
  params: Promise<{ slug: string }>;
}

export default async function ProductDetailPage({ params }: ProductDetailPageProps) {
  const { slug } = await params;
  const supabase = await createServerSupabaseClient();

  const { data: product } = await supabase
    .from('products')
    .select('*, category:categories(*)')
    .eq('slug', slug)
    .single();

  if (!product) {
    notFound();
  }

  // Fetch related products
  const { data: relatedProducts } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .eq('category_id', product.category_id)
    .neq('id', product.id)
    .limit(4);

  return (
    <ProductDetailClient
      product={product}
      relatedProducts={relatedProducts || []}
    />
  );
}
