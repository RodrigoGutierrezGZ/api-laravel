<?php

require 'vendor/autoload.php';
require 'bootstrap/app.php';

use App\Models\Product;

echo '=== VERIFICACIÓN DE PRODUCTOS EN LA BASE DE DATOS ==='.PHP_EOL;
echo 'Total de productos: '.Product::count().PHP_EOL.PHP_EOL;

echo 'Lista de productos:'.PHP_EOL;
echo str_repeat('-', 80).PHP_EOL;
printf('%-4s %-25s %-10s %-8s%s', 'ID', 'NOMBRE', 'PRECIO', 'STOCK', PHP_EOL);
echo str_repeat('-', 80).PHP_EOL;

Product::all(['id', 'name', 'price', 'stock'])->each(function ($product) {
    printf(
        '%-4d %-25s $%-9.2f %-8d%s',
        $product->id,
        substr($product->name, 0, 24),
        $product->price,
        $product->stock,
        PHP_EOL
    );
});

echo str_repeat('-', 80).PHP_EOL;
echo 'Verificación completada exitosamente!'.PHP_EOL;
