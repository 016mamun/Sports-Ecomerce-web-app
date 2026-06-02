'use client';

import Link from 'next/link';
import { useState } from 'react';
import { ShoppingCart, User, Menu, X, Search, LogOut, Package } from 'lucide-react';
import { useCartStore } from '@/lib/store/cart-store';
import { useAuthStore } from '@/lib/store/auth-store';
import { createClient } from '@/lib/supabase/client';

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [showUserMenu, setShowUserMenu] = useState(false);
  const { user } = useAuthStore();
  const totalItems = useCartStore((state) => state.items.reduce((sum, i) => sum + i.quantity, 0));

  const handleLogout = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    setShowUserMenu(false);
  };

  return (
    <header className="bg-primary-950 text-white sticky top-0 z-50 shadow-lg">
      <div className="container-main">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2">
            <div className="w-10 h-10 bg-accent-500 rounded-lg flex items-center justify-center">
              <span className="font-heading font-bold text-lg">F</span>
            </div>
            <span className="font-heading font-bold text-xl hidden sm:block">
              FNF Sports
            </span>
          </Link>

          {/* Desktop Navigation */}
          <nav className="hidden md:flex items-center gap-8">
            <Link href="/" className="hover:text-accent-400 transition-colors font-medium">
              Home
            </Link>
            <Link href="/products" className="hover:text-accent-400 transition-colors font-medium">
              Products
            </Link>
          </nav>

          {/* Right Side */}
          <div className="flex items-center gap-4">
            {/* Search - hidden on mobile */}
            <Link
              href="/products"
              className="hidden sm:flex items-center gap-2 bg-primary-800 px-3 py-2 rounded-lg hover:bg-primary-700 transition-colors"
            >
              <Search size={18} />
              <span className="text-sm text-gray-300">Search...</span>
            </Link>

            {/* Cart */}
            <Link
              href="/cart"
              className="relative p-2 hover:bg-primary-800 rounded-lg transition-colors"
            >
              <ShoppingCart size={22} />
              {totalItems > 0 && (
                <span className="absolute -top-1 -right-1 bg-accent-500 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center font-bold">
                  {totalItems}
                </span>
              )}
            </Link>

            {/* User Menu */}
            {user ? (
              <div className="relative">
                <button
                  onClick={() => setShowUserMenu(!showUserMenu)}
                  className="p-2 hover:bg-primary-800 rounded-lg transition-colors"
                >
                  <User size={22} />
                </button>
                {showUserMenu && (
                  <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-xl py-2 text-gray-800">
                    <Link
                      href="/profile"
                      className="flex items-center gap-2 px-4 py-2 hover:bg-gray-100"
                      onClick={() => setShowUserMenu(false)}
                    >
                      <User size={18} />
                      Profile
                    </Link>
                    <Link
                      href="/orders"
                      className="flex items-center gap-2 px-4 py-2 hover:bg-gray-100"
                      onClick={() => setShowUserMenu(false)}
                    >
                      <Package size={18} />
                      Orders
                    </Link>
                    <hr className="my-1" />
                    <button
                      onClick={handleLogout}
                      className="flex items-center gap-2 px-4 py-2 hover:bg-gray-100 w-full text-left text-red-600"
                    >
                      <LogOut size={18} />
                      Logout
                    </button>
                  </div>
                )}
              </div>
            ) : (
              <Link
                href="/login"
                className="btn-primary !py-2 !px-4 text-sm"
              >
                Login
              </Link>
            )}

            {/* Mobile Menu Button */}
            <button
              className="md:hidden p-2 hover:bg-primary-800 rounded-lg"
              onClick={() => setIsOpen(!isOpen)}
            >
              {isOpen ? <X size={24} /> : <Menu size={24} />}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        {isOpen && (
          <div className="md:hidden pb-4 border-t border-primary-800 mt-2 pt-4">
            <nav className="flex flex-col gap-3">
              <Link
                href="/"
                className="hover:text-accent-400 transition-colors py-2"
                onClick={() => setIsOpen(false)}
              >
                Home
              </Link>
              <Link
                href="/products"
                className="hover:text-accent-400 transition-colors py-2"
                onClick={() => setIsOpen(false)}
              >
                Products
              </Link>
            </nav>
          </div>
        )}
      </div>
    </header>
  );
}
