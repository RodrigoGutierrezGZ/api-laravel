<?php

namespace Tests\Feature;

use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class ProductControllerTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    /**
     * Test que se pueden listar todos los productos
     */
    public function test_can_list_all_products(): void
    {
        // Crear algunos productos de prueba
        Product::factory()->count(3)->create();

        $response = $this->getJson('/api/products');

        $response->assertStatus(200)
            ->assertJsonCount(3);
    }

    /**
     * Test que se puede crear un producto
     */
    public function test_can_create_a_product(): void
    {
        $productData = [
            'name' => 'Test Product',
            'description' => 'Test Description',
            'price' => 99.99,
            'stock' => 10,
        ];

        $response = $this->postJson('/api/products', $productData);

        $response->assertStatus(201)
            ->assertJson($productData);

        $this->assertDatabaseHas('products', $productData);
    }

    /**
     * Test que se puede ver un producto específico
     */
    public function test_can_show_a_product(): void
    {
        $product = Product::factory()->create();

        $response = $this->getJson("/api/products/{$product->id}");

        $response->assertStatus(200)
            ->assertJson([
                'id' => $product->id,
                'name' => $product->name,
                'description' => $product->description,
                'price' => $product->price,
                'stock' => $product->stock,
            ]);
    }

    /**
     * Test que se puede actualizar un producto
     */
    public function test_can_update_a_product(): void
    {
        $product = Product::factory()->create();

        $updatedData = [
            'name' => 'Updated Product',
            'description' => 'Updated Description',
            'price' => 149.99,
            'stock' => 20,
        ];

        $response = $this->putJson("/api/products/{$product->id}", $updatedData);

        $response->assertStatus(200)
            ->assertJson($updatedData);

        $this->assertDatabaseHas('products', array_merge(['id' => $product->id], $updatedData));
    }

    /**
     * Test que se puede eliminar un producto
     */
    public function test_can_delete_a_product(): void
    {
        $product = Product::factory()->create();

        $response = $this->deleteJson("/api/products/{$product->id}");

        $response->assertStatus(200)
            ->assertJson(['message' => 'Product deleted successfully']);

        $this->assertDatabaseMissing('products', ['id' => $product->id]);
    }

    /**
     * Test validación de campos requeridos
     */
    public function test_product_validation_fails_with_missing_fields(): void
    {
        $response = $this->postJson('/api/products', []);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'price', 'stock']);
    }

    /**
     * Test validación de tipos de datos
     */
    public function test_product_validation_fails_with_invalid_data_types(): void
    {
        $invalidData = [
            'name' => '',
            'price' => 'not-a-number',
            'stock' => 'not-an-integer',
        ];

        $response = $this->postJson('/api/products', $invalidData);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'price', 'stock']);
    }
}
