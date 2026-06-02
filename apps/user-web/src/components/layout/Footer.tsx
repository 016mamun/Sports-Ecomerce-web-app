import Link from 'next/link';
import { Mail, Phone, MapPin } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="bg-primary-950 text-gray-300 mt-16">
      <div className="container-main py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Brand */}
          <div className="md:col-span-1">
            <div className="flex items-center gap-2 mb-4">
              <div className="w-10 h-10 bg-accent-500 rounded-lg flex items-center justify-center">
                <span className="font-heading font-bold text-lg text-white">F</span>
              </div>
              <span className="font-heading font-bold text-xl text-white">FNF Sports</span>
            </div>
            <p className="text-sm leading-relaxed">
              Your ultimate destination for premium sports equipment and accessories.
              Quality gear for every athlete.
            </p>
          </div>

          {/* Quick Links */}
          <div>
            <h3 className="font-heading font-semibold text-white mb-4">Quick Links</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="/" className="hover:text-accent-400 transition-colors">Home</Link></li>
              <li><Link href="/products" className="hover:text-accent-400 transition-colors">Products</Link></li>
              <li><Link href="/cart" className="hover:text-accent-400 transition-colors">Cart</Link></li>
              <li><Link href="/orders" className="hover:text-accent-400 transition-colors">My Orders</Link></li>
            </ul>
          </div>

          {/* Categories */}
          <div>
            <h3 className="font-heading font-semibold text-white mb-4">Categories</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="/products?category=cricket" className="hover:text-accent-400 transition-colors">Cricket</Link></li>
              <li><Link href="/products?category=football" className="hover:text-accent-400 transition-colors">Football</Link></li>
              <li><Link href="/products?category=basketball" className="hover:text-accent-400 transition-colors">Basketball</Link></li>
              <li><Link href="/products?category=fitness" className="hover:text-accent-400 transition-colors">Fitness</Link></li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h3 className="font-heading font-semibold text-white mb-4">Contact Us</h3>
            <ul className="space-y-3 text-sm">
              <li className="flex items-center gap-2">
                <Phone size={16} className="text-accent-500" />
                +880 1234-567890
              </li>
              <li className="flex items-center gap-2">
                <Mail size={16} className="text-accent-500" />
                info@fnfsports.com
              </li>
              <li className="flex items-start gap-2">
                <MapPin size={16} className="text-accent-500 mt-0.5" />
                Dhaka, Bangladesh
              </li>
            </ul>
          </div>
        </div>

        <div className="border-t border-primary-800 mt-8 pt-8 text-center text-sm">
          <p>&copy; {new Date().getFullYear()} FNF Sports. All rights reserved.</p>
        </div>
      </div>
    </footer>
  );
}
