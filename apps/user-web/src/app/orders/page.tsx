import { createServerSupabaseClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { Package, Clock, CheckCircle, Truck, XCircle } from 'lucide-react';

const statusIcons: Record<string, React.ReactNode> = {
  pending: <Clock size={20} className="text-yellow-500" />,
  confirmed: <CheckCircle size={20} className="text-blue-500" />,
  shipped: <Truck size={20} className="text-purple-500" />,
  delivered: <CheckCircle size={20} className="text-green-500" />,
  cancelled: <XCircle size={20} className="text-red-500" />,
};

const statusColors: Record<string, string> = {
  pending: 'bg-yellow-100 text-yellow-800',
  confirmed: 'bg-blue-100 text-blue-800',
  shipped: 'bg-purple-100 text-purple-800',
  delivered: 'bg-green-100 text-green-800',
  cancelled: 'bg-red-100 text-red-800',
};

export default async function OrdersPage() {
  const supabase = await createServerSupabaseClient();

  const { data: orders } = await supabase
    .from('orders')
    .select('*, order_items(*)')
    .order('created_at', { ascending: false });

  return (
    <div className="container-main py-8">
      <h1 className="text-3xl font-heading font-bold text-primary-950 mb-8">My Orders</h1>

      {!orders || orders.length === 0 ? (
        <div className="text-center py-16">
          <div className="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Package size={40} className="text-gray-400" />
          </div>
          <p className="text-gray-500 text-lg mb-4">No orders yet</p>
          <Link href="/products" className="btn-primary">
            Start Shopping
          </Link>
        </div>
      ) : (
        <div className="space-y-4">
          {orders.map((order) => (
            <Link
              key={order.id}
              href={`/orders/${order.id}`}
              className="card p-6 block hover:border-accent-500 transition-colors"
            >
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div className="flex items-center gap-4">
                  {statusIcons[order.status] || <Package size={20} className="text-gray-400" />}
                  <div>
                    <p className="font-medium text-gray-900">
                      Order #{order.id.slice(0, 8).toUpperCase()}
                    </p>
                    <p className="text-sm text-gray-500">
                      {new Date(order.created_at).toLocaleDateString('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                      })}
                      {' · '}
                      {order.order_items?.length || 0} item(s)
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <span className={`badge ${statusColors[order.status] || ''}`}>
                    {order.status.charAt(0).toUpperCase() + order.status.slice(1)}
                  </span>
                  <span className="font-bold text-accent-500">
                    ৳{Number(order.total_amount).toFixed(2)}
                  </span>
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
