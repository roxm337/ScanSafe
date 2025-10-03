<?php

namespace App\Services;

use App\Models\User;
use App\Models\Product;
use App\Models\Recommendation;
use App\Models\ProductReview;

class RecommendationEngine
{
    /**
     * Generate personalized product recommendations for a user based on their preferences.
     */
    public function generateUserRecommendations(User $user, int $limit = 10): array
    {
        $preference = $user->preference;
        if (!$preference) {
            return $this->getDefaultRecommendations($limit);
        }

        $recommendedProducts = collect();

        // Get products that match user's dietary preferences
        if (!empty($preference->dietary_restrictions)) {
            $dietaryProducts = $this->getDietaryMatchProducts($preference->dietary_restrictions, $limit);
            $recommendedProducts = $recommendedProducts->merge($dietaryProducts);
        }

        // Get products that avoid user's allergens
        if (!empty($preference->allergies)) {
            $safeProducts = $this->getSafeProducts($preference->allergies, $limit);
            $recommendedProducts = $recommendedProducts->merge($safeProducts);
        }

        // Get highly-rated products from user's lifestyle preferences
        if (!empty($preference->lifestyle_preferences)) {
            $lifestyleProducts = $this->getLifestyleProducts($preference->lifestyle_preferences, $limit);
            $recommendedProducts = $recommendedProducts->merge($lifestyleProducts);
        }

        // Remove duplicates and limit results
        $uniqueProducts = $recommendedProducts->unique('id')->take($limit);
        
        return $uniqueProducts->map(function ($product) {
            return [
                'product' => $product,
                'reason' => $this->getRecommendationReason($product),
                'confidence_score' => $this->calculateConfidenceScore($product)
            ];
        })->toArray();
    }

    /**
     * Generate alternative products for a specific product based on user's allergies.
     */
    public function generateAlternatives(Product $product, User $user, int $limit = 5): array
    {
        $preference = $user->preference;
        if (!$preference || empty($preference->allergies)) {
            return $this->getSimilarProducts($product, $limit);
        }

        $alternatives = collect();
        $userAllergies = $preference->allergies;

        // Find products that are similar but don't contain user's allergens
        $allergenFreeProducts = Product::where(function ($query) use ($userAllergies) {
            foreach ($userAllergies as $allergy) {
                $query->whereJsonDoesntContain('allergens', $allergy)
                      ->orWhereNull('allergens');
            }
        })
        ->where('id', '!=', $product->id)
        ->where('category', $product->category) // Same category as original product
        ->withCount('scans')
        ->orderBy('scans_count', 'desc')
        ->limit($limit * 2) // Get more options to filter from
        ->get();

        // Select the best alternatives
        foreach ($allergenFreeProducts as $candidate) {
            if ($alternatives->count() >= $limit) {
                break;
            }
            
            $alternatives->push($candidate);
        }

        return $alternatives->map(function ($product) use ($user) {
            return [
                'product' => $product,
                'reason' => 'Safe alternative avoiding your allergies',
                'confidence_score' => 90
            ];
        })->toArray();
    }

    /**
     * Calculate personalized risk for a product based on user's profile.
     */
    public function calculatePersonalRisk(Product $product, User $user): array
    {
        $preference = $user->preference;
        $risk = [
            'is_safe' => true,
            'issues' => [],
            'advice' => '',
            'risk_level' => 'low' // low, medium, high
        ];

        if (!$preference) {
            $risk['advice'] = 'Product appears safe based on general standards';
            return $risk;
        }

        // Check for allergens
        $productAllergens = $product->allergens ?? [];
        $userAllergies = $preference->allergies ?? [];
        
        foreach ($productAllergens as $productAllergen) {
            foreach ($userAllergies as $userAllergy) {
                if (stripos($productAllergen, $userAllergy) !== false) {
                    $risk['is_safe'] = false;
                    $risk['issues'][] = [
                        'ingredient' => $productAllergen,
                        'reason' => "Contains '$productAllergen' which you are allergic to"
                    ];
                    $risk['risk_level'] = 'high';
                }
            }
        }

        // Add advice
        if (!$risk['is_safe']) {
            $risk['advice'] = 'This product contains ingredients you should avoid';
        } else {
            // Check if it matches any preferences
            $matchesPreference = false;
            $productText = strtolower($product->name . ' ' . $product->brand . ' ' . $product->ingredients_text);
            
            foreach ($preference->dietary_restrictions as $diet) {
                if (stripos($productText, strtolower($diet)) !== false) {
                    $matchesPreference = true;
                    break;
                }
            }
            
            if ($matchesPreference) {
                $risk['advice'] = 'This product aligns with your dietary preferences';
            } else {
                $risk['advice'] = 'This product appears safe based on your profile';
            }
        }

        return $risk;
    }

    private function getDefaultRecommendations(int $limit): \Illuminate\Support\Collection
    {
        return Product::withCount('scans')
            ->orderBy('scans_count', 'desc')
            ->limit($limit)
            ->get();
    }

    private function getDietaryMatchProducts(array $dietaryPrefs, int $limit): \Illuminate\Support\Collection
    {
        $query = Product::query();
        
        foreach ($dietaryPrefs as $pref) {
            $query->orWhere('name', 'LIKE', "%$pref%")
                  ->orWhere('brand', 'LIKE', "%$pref%")
                  ->orWhere('ingredients_text', 'LIKE', "%$pref%");
        }
        
        return $query->withCount('scans')
            ->orderBy('scans_count', 'desc')
            ->limit($limit)
            ->get();
    }

    private function getSafeProducts(array $allergies, int $limit): \Illuminate\Support\Collection
    {
        $query = Product::where(function ($q) use ($allergies) {
            foreach ($allergies as $allergy) {
                $q->whereJsonDoesntContain('allergens', $allergy)
                  ->orWhereNull('allergens');
            }
        });

        return $query->withCount('scans')
            ->orderBy('scans_count', 'desc')
            ->limit($limit)
            ->get();
    }

    private function getLifestyleProducts(array $lifestylePrefs, int $limit): \Illuminate\Support\Collection
    {
        // In a real application, you might have tags or categories for lifestyle products
        // For now, just return popular products
        return Product::withCount('scans')
            ->orderBy('scans_count', 'desc')
            ->limit($limit)
            ->get();
    }

    private function getSimilarProducts(Product $product, int $limit): array
    {
        $similarProducts = Product::where('category', $product->category)
            ->where('id', '!=', $product->id)
            ->withCount('scans')
            ->orderBy('scans_count', 'desc')
            ->limit($limit)
            ->get();

        return $similarProducts->map(function ($product) {
            return [
                'product' => $product,
                'reason' => 'Similar product in the same category',
                'confidence_score' => 70
            ];
        })->toArray();
    }

    private function getRecommendationReason(Product $product): string
    {
        // In a real application, this would analyze the product against user preferences
        return 'Recommended based on your preferences';
    }

    private function calculateConfidenceScore(Product $product): int
    {
        // In a real application, this would analyze various factors
        return rand(70, 100); // Random score for demo purposes
    }
}