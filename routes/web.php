<?php

use App\Http\Controllers\ProductController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// API Routes for Products
Route::prefix('api')->group(function () {
    Route::apiResource('products', ProductController::class);
});
