<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Recommendation>
 */
class RecommendationFactory extends Factory
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
            'recommended_product_id' => \App\Models\Product::factory(),
            'reason' => $this->faker->sentence,
            'type' => $this->faker->randomElement(['alternative', 'related', 'similar']),
            'confidence_score' => $this->faker->numberBetween(50, 100),
        ];
    }
}
