<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Crear algunos productos de ejemplo
        $products = [
            [
                'name' => 'Laptop Dell XPS 13',
                'price' => 1299.99,
                'description' => 'Ultrabook premium con procesador Intel Core i7, 16GB RAM y SSD 512GB',
                'stock' => 15,
            ],
            [
                'name' => 'iPhone 15 Pro',
                'price' => 999.99,
                'description' => 'Smartphone de última generación con chip A17 Pro y cámara de 48MP',
                'stock' => 25,
            ],
            [
                'name' => 'Samsung Galaxy S24',
                'price' => 849.99,
                'description' => 'Teléfono Android flagship con pantalla AMOLED y cámara IA',
                'stock' => 30,
            ],
            [
                'name' => 'MacBook Air M3',
                'price' => 1599.99,
                'description' => 'Laptop Apple con chip M3, 8GB RAM y 256GB SSD',
                'stock' => 12,
            ],
            [
                'name' => 'PlayStation 5',
                'price' => 499.99,
                'description' => 'Consola de videojuegos de próxima generación con SSD ultrarrápido',
                'stock' => 8,
            ],
            [
                'name' => 'AirPods Pro 2',
                'price' => 249.99,
                'description' => 'Auriculares inalámbricos con cancelación activa de ruido',
                'stock' => 50,
            ],
            [
                'name' => 'iPad Air',
                'price' => 599.99,
                'description' => 'Tablet con chip M1, pantalla Liquid Retina de 10.9 pulgadas',
                'stock' => 20,
            ],
            [
                'name' => 'Monitor LG UltraWide',
                'price' => 449.99,
                'description' => 'Monitor curvo de 34 pulgadas con resolución QHD y 144Hz',
                'stock' => 18,
            ],
        ];

        foreach ($products as $productData) {
            Product::create($productData);
        }

        // También crear algunos productos usando la factory
        Product::factory()->count(5)->create();
    }
}