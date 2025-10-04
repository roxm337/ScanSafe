<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\ProductReview>
 */
class ProductReviewFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => \App\Models\User::factory(),
            'product_id' => \App\Models\Product::factory(),
            'review_text' => $this->faker->paragraph,
            'rating' => $this->faker->numberBetween(1, 5),
            'tags' => $this->faker->randomElements(['safe-for-allergy', 'caused-rash', 'great-taste', 'good-value', 'strong-scent'], $this->faker->numberBetween(0, 3)),
            'is_verified' => $this->faker->boolean(30), // 30% chance of being verified
            'helpful_votes' => [],
        ];
    }
}
