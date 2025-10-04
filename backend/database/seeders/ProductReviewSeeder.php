<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\ProductReview;

class ProductReviewSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create some sample reviews
        ProductReview::factory()->count(20)->create();
        
        // Create specific reviews for testing
        ProductReview::factory()->create([
            'user_id' => 1,
            'product_id' => 1,
            'review_text' => 'This product caused a mild skin irritation. I have sensitive skin, so others might not experience the same.',
            'rating' => 3,
            'tags' => ['caused-rash', 'sensitive-skin'],
            'is_verified' => true,
            'helpful_votes' => [2, 3]
        ]);
        
        ProductReview::factory()->create([
            'user_id' => 2,
            'product_id' => 1,
            'review_text' => 'Safe for my peanut allergy! No cross-contamination issues.',
            'rating' => 5,
            'tags' => ['safe-for-allergy', 'peanuts'],
            'is_verified' => true,
            'helpful_votes' => [1, 3, 4]
        ]);
        
        ProductReview::factory()->create([
            'user_id' => 3,
            'product_id' => 1,
            'review_text' => 'Great taste but contains added sugar which wasn\'t obvious from the packaging.',
            'rating' => 4,
            'tags' => ['hidden-ingredients', 'great-taste'],
            'is_verified' => false,
            'helpful_votes' => [1, 2]
        ]);
    }
}
