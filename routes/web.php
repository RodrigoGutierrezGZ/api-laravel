<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

Route::get('/', function () {
    return view('welcome');
});

// API Routes for Products
Route::prefix('api')->group(function () {
    Route::apiResource('products', ProductController::class);
});
