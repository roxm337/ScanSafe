<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Recommendation;

class RecommendationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create some sample recommendations
        Recommendation::factory()->count(30)->create();
        
        // Create specific recommendations for testing
        Recommendation::factory()->create([
            'user_id' => 1,
            'product_id' => 1,
            'recommended_product_id' => 2,
            'reason' => 'Contains nuts which user is allergic to',
            'type' => 'alternative',
            'confidence_score' => 95
        ]);
        
        Recommendation::factory()->create([
            'user_id' => 1,
            'product_id' => 3,
            'recommended_product_id' => 4,
            'reason' => 'Vegan option for user preference',
            'type' => 'alternative',
            'confidence_score' => 85
        ]);
    }
}
