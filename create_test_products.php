<?php

require 'vendor/autoload.php';

$app = require 'bootstrap/app.php';
$app->boot();

use App\Models\Product;

// Crear 5 productos de prueba
$products = Product::factory()->count(5)->create();

echo 'Se crearon '.$products->count().' productos de prueba:\n';

foreach ($products as $product) {
    echo "- {$product->name} - {$product->price} - {$product->description}\n";
}
