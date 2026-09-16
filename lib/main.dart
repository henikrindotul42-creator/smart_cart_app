import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const brown = Color(0xFF633C25), cream = Color(0xFFF8F1E8);

String rupiah(int n) =>
    'Rp ${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

// ================= MODELS & PROVIDER =================
class Product {
  final String name, image;
  final int price;
  const Product(this.name, this.price, this.image);
}

const products = [
  Product('Laptop RPL Pro', 8999000, 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500'),
  Product('Mouse Wireless', 185000, 'https://images.unsplash.com/photo-1527814050087-3793815479db?w=500'),
  Product('Keyboard Mech', 520000, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500'),
  Product('Monitor 24 Inch', 1750000, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=500'),
  Product('Headphone BT', 380000, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500'),
  Product('Smartphone 5G', 2899000, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500'),
];

class CartItem {
  final Product product;
  int quantity;
  CartItem(this.product, this.quantity);
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> items = [];
  int get count => items.fold(0, (sum, i) => sum + i.quantity);
  int get total => items.fold(0, (sum, i) => sum + i.product.price * i.quantity);

  void add(Product p) {
    final i = items.indexWhere((e) => e.product == p);
    i >= 0 ? items[i].quantity++ : items.add(CartItem(p, 1));
    notifyListeners();
  }

  void minus(Product p) {
    final i = items.indexWhere((e) => e.product == p);
    if (i >= 0) {
      items[i].quantity > 1 ? items[i].quantity-- : items.removeAt(i);
      notifyListeners();
    }
  }

  void remove(Product p) {
    items.removeWhere((e) => e.product == p);
    notifyListeners();
  }
}

// ================= MAIN & APP =================
void main() => runApp(
      ChangeNotifierProvider(create: (_) => CartProvider(), child: const MyApp()),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int page = 0;

  Widget badge(IconData icon, int count) => Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon),
          if (count > 0)
            Positioned(
              right: -8, top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartProvider>().count;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: cream, colorScheme: ColorScheme.fromSeed(seedColor: brown)),
      home: Scaffold(
        body: IndexedStack(index: page, children: const [CatalogPage(), CartPage(), ProfilePage()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: page,
          onDestinationSelected: (v) => setState(() => page = v),
          destinations: [
            const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Katalog'),
            NavigationDestination(icon: badge(Icons.shopping_cart_outlined, count), selectedIcon: badge(Icons.shopping_cart, count), label: 'Keranjang'),
            const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

Widget header(String title) => Container(
      width: double.infinity, padding: const EdgeInsets.all(18), color: brown,
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
    );

// ================= PAGES =================
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});
  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final data = products.where((p) => p.name.toLowerCase().contains(search.toLowerCase())).toList();
    return SafeArea(
      child: Column(
        children: [
          header('E-Catalog SMKN 3 Tuban'),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => search = v),
              decoration: InputDecoration(
                hintText: 'Cari produk...', prefixIcon: const Icon(Icons.search),
                filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Align(alignment: Alignment.centerLeft, child: Text('${data.length} Produk', style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 230, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .72),
              itemBuilder: (_, i) {
                final p = data[i];
                return Card(
                  color: Colors.white, margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(p.image, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, size: 45))),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Flexible(child: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold))),
                        Text(rupiah(p.price), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        SizedBox(width: double.infinity, child: FilledButton(onPressed: () => context.read<CartProvider>().add(p), child: const Text('+ Tambah'))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return SafeArea(
      child: Column(
        children: [
          header('Keranjang Belanja'),
          if (cart.items.isEmpty)
            const Expanded(child: Center(child: Text('Keranjang masih kosong', style: TextStyle(fontSize: 18))))
          else ...[
            Container(
              margin: const EdgeInsets.all(14), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF1DDCC), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: brown, child: Icon(Icons.account_balance_wallet_outlined, color: Colors.white)),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('Total Pembayaran:', style: TextStyle(color: brown, fontWeight: FontWeight.bold))),
                  Flexible(child: Text(rupiah(cart.total), overflow: TextOverflow.ellipsis, style: const TextStyle(color: brown, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Align(alignment: Alignment.centerLeft, child: Text('🛒 Daftar Item Belanja', style: TextStyle(color: brown, fontSize: 20, fontWeight: FontWeight.bold))),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: cart.items.map((item) {
                    return Card(
                      color: Colors.white, margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(item.product.image, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(rupiah(item.product.price), style: const TextStyle(color: brown)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(visualDensity: VisualDensity.compact, padding: EdgeInsets.zero, onPressed: () => cart.minus(item.product), icon: const Icon(Icons.remove_circle_outline, color: brown)),
                                Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(visualDensity: VisualDensity.compact, padding: EdgeInsets.zero, onPressed: () => cart.add(item.product), icon: const Icon(Icons.add_circle_outline, color: brown)),
                              ],
                            ),
                            IconButton(padding: EdgeInsets.zero, onPressed: () => cart.remove(item.product), icon: const Icon(Icons.delete_outline, color: Colors.red, size: 30)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity, height: 52,
                child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.arrow_forward), label: const Text('Lanjutkan ke Pembayaran')),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          header('Profil'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: const [
                    SizedBox(height: 40),
                    CircleAvatar(radius: 45, backgroundColor: brown, child: Icon(Icons.school, size: 45, color: Colors.white)),
                    SizedBox(height: 15),
                    Text('SMKN 3 Tuban', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Rekayasa Perangkat Lunak'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}