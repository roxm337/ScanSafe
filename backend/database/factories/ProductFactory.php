<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Product>
 */
class ProductFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'ean' => $this->faker->unique()->ean13,
            'name' => $this->faker->words(3, true),
            'brand' => $this->faker->company,
            'image_url' => $this->faker->imageUrl(400, 400, 'products'),
            'ingredients_text' => $this->faker->sentence(10),
            'allergens' => $this->faker->randomElements(['Milk', 'Nuts', 'Gluten', 'Soy', 'Eggs', 'Wheat'], $this->faker->numberBetween(0, 3)),
            'source_api' => 'mock_api',
            'cached_at' => now(),
        ];
    }
}
