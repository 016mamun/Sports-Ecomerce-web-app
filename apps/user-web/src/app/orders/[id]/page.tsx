import { createServerSupabaseClient } from '@/lib/supabase/server';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { ArrowLeft, Package, MapPin, Phone } from 'lucide-react';

interface OrderDetailPageProps {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ success?: string }>;
}

const statusColors: Record<string, string> = {
  pending: 'bg-yellow-100 text-yellow-800',
  confirmed: 'bg-blue-100 text-blue-800',
  shipped: 'bg-purple-100 text-purple-800',
  delivered: 'bg-green-100 text-green-800',
  cancelled: 'bg-red-100 text-red-800',
};

export default async function OrderDetailPage({ params, searchParams }: OrderDetailPageProps) {
  const { id } = await params;
  const sp = await searchParams;
  const supabase = await createServerSupabaseClient();

  const { data: order } = await supabase
    .from('orders')
    .select('*, order_items(*, product:products(*))')
    .eq('id', id)
    .single();

  if (!order) {
    notFound();
  }

  return (
    <div className="container-main py-8">
      {/* Success Banner */}
      {sp.success && (
        <div className="bg-green-50 border border-green-200 text-green-800 rounded-xl p-6 mb-8">
          <h2 className="text-xl font-bold mb-2">Order Placed Successfully!</h2>
          <p className="text-green-600">
            Thank you for your order. We&apos;ll process it shortly and you&apos;ll receive a confirmation.
          </p>
        </div>
      )}

      {/* Back Link */}
      <Link
        href="/orders"
        className="inline-flex items-center gap-2 text-gray-600 hover:text-accent-500 mb-6"
      >
        <ArrowLeft size={18} /> Back to Orders
      </Link>

      <h1 className="text-3xl font-heading font-bold text-primary-950 mb-8">
        Order #{order.id.slice(0, 8).toUpperCase()}
      </h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Order Items */}
        <div className="lg:col-span-2">
          <div className="card p-6">
            <h2 className="font-heading font-bold text-lg mb-4 flex items-center gap-2">
              <Package size={20} className="text-accent-500" />
              Order Items
            </h2>
            <div className="space-y-4">
              {order.order_items?.map((item) => (
                <div key={item.id} className="flex items-center gap-4 py-3 border-b last:border-0">
                  <div className="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center shrink-0">
                    <Package size={20} className="text-gray-400" />
                  </div>
                  <div className="flex-1">
                    <Link
                      href={`/products/${item.product?.slug}`}
                      className="font-medium hover:text-accent-500"
                    >
                      {item.product?.name || 'Product'}
                    </Link>
                    <p className="text-sm text-gray-500">
                      Qty: {item.quantity} × ৳{Number(item.unit_price).toFixed(2)}
                    </p>
                  </div>
                  <span className="font-bold">
                    ৳{(Number(item.unit_price) * item.quantity).toFixed(2)}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Order Info */}
        <div className="space-y-6">
          {/* Status */}
          <div className="card p-6">
            <h2 className="font-heading font-bold text-lg mb-4">Order Status</h2>
            <span className={`badge text-sm ${statusColors[order.status] || ''}`}>
              {order.status.charAt(0).toUpperCase() + order.status.slice(1)}
            </span>
            <p className="text-sm text-gray-500 mt-2">
              Placed on {new Date(order.created_at).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
              })}
            </p>
          </div>

          {/* Shipping */}
          <div className="card p-6">
            <h2 className="font-heading font-bold text-lg mb-4">Shipping Details</h2>
            <div className="space-y-3 text-sm">
              <div className="flex items-start gap-2">
                <MapPin size={16} className="text-accent-500 mt-0.5 shrink-0" />
                <span className="text-gray-700">{order.shipping_address}</span>
              </div>
              <div className="flex items-center gap-2">
                <Phone size={16} className="text-accent-500 shrink-0" />
                <span className="text-gray-700">{order.phone}</span>
              </div>
            </div>
          </div>

          {/* Total */}
          <div className="card p-6">
            <h2 className="font-heading font-bold text-lg mb-4">Order Total</h2>
            <div className="text-2xl font-bold text-accent-500">
              ৳{Number(order.total_amount).toFixed(2)}
            </div>
            <p className="text-sm text-gray-500 mt-1">Cash on Delivery</p>
          </div>
        </div>
      </div>
    </div>
  );
}
