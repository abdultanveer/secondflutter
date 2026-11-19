import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}

// --------------------------------------------------
// 1. PRODUCT MODEL
// --------------------------------------------------

class Product {
  final int id;
  final String name;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

// --------------------------------------------------
// 2. CART MODEL (STATE + BUSINESS LOGIC)
// --------------------------------------------------

class CartModel extends ChangeNotifier {
  // Products available in the catalog
  final List<Product> catalog = const [
    Product(id: 1, name: 'Laptop', price: 55000),
    Product(id: 2, name: 'Mobile Phone', price: 25000),
    Product(id: 3, name: 'Headphones', price: 2000),
    Product(id: 4, name: 'Keyboard', price: 1500),
    Product(id: 5, name: 'Mouse', price: 800),
    Product(id: 6, name: 'Monitor', price: 12000),
    Product(id: 7, name: 'Smart Watch', price: 5000),
    Product(id: 8, name: 'Speaker', price: 3000),
  ];

  // Products currently inside the cart
  final List<Product> _items = [];

  // Public read-only access to cart items
  List<Product> get items => List.unmodifiable(_items);

  // Number of products in cart
  int get itemCount => _items.length;

  // Total price of all products
  double get totalPrice {
    double total = 0;

    for (final product in _items) {
      total += product.price;
    }

    return total;
  }

  // Add a product to cart
  void add(Product product) { //B
    _items.add(product);
    notifyListeners();
  }

  // Remove a product from cart
  void remove(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  // Empty the cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Check whether a product is already in cart
  bool contains(Product product) {
    return _items.contains(product);
  }
}

// --------------------------------------------------
// 3. ROOT APPLICATION
// --------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Provider Shopping App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const MyCatalog(),//1
    );
  }
}

// --------------------------------------------------
// 4. CATALOG SCREEN
// --------------------------------------------------

class MyCatalog extends StatelessWidget {
  const MyCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.itemCount}'),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyCart(),
                ),
              );
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: cart.catalog.length,
        itemBuilder: (context, index) {
          final product = cart.catalog[index];

          return MyListItem(
            product: product,
          );
        },
      ),
    );
  }
}

// --------------------------------------------------
// 5. INDIVIDUAL PRODUCT ITEM
// --------------------------------------------------

class MyListItem extends StatelessWidget {
  final Product product;

  const MyListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    final isAdded = cart.contains(product);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${product.id}'),
        ),

        title: Text(product.name),

        subtitle: Text(
          '₹${product.price.toStringAsFixed(0)}',
        ),

        trailing: ElevatedButton(
          onPressed: () {
            context.read<CartModel>().add(product);//A
          },
          child: Text(
            isAdded ? 'Add More' : 'Add',
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 6. CART SCREEN
// --------------------------------------------------

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();//C

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear cart',
              onPressed: () {
                context.read<CartModel>().clear();
              },
            ),
        ],
      ),

      body: cart.items.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 20),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final product = cart.items[index];

                return ListTile(
                  leading: const Icon(
                    Icons.shopping_bag,
                  ),

                  title: Text(product.name),

                  subtitle: Text(
                    '₹${product.price.toStringAsFixed(0)}',
                  ),

                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                    ),
                    onPressed: () {
                      context
                          .read<CartModel>()
                          .remove(product);
                    },
                  ),
                );
              },
            ),
          ),

          // Cart total
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
            ),
            child: Column(
              children: [
                Text(
                  'Items: ${cart.itemCount}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Total: ₹${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Checkout is not implemented yet!',
                          ),
                        ),
                      );
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}