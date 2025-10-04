<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Recommendation;
use App\Models\Product;
use App\Models\User;
use App\Services\RecommendationEngine;

class RecommendationController extends Controller
{
    protected RecommendationEngine $recommendationEngine;

    public function __construct(RecommendationEngine $recommendationEngine)
    {
        $this->recommendationEngine = $recommendationEngine;
    }

    /**
     * Get recommendations for the authenticated user based on their preferences.
     */
    public function getUserRecommendations(Request $request)
    {
        $user = auth()->user();
        $recommendations = $this->recommendationEngine->generateUserRecommendations(
            $user, 
            $request->get('limit', 10)
        );

        return response()->json($recommendations);
    }

    /**
     * Get alternatives for a specific product based on user preferences.
     */
    public function getProductAlternatives(Request $request, Product $product)
    {
        $user = auth()->user();
        $alternatives = $this->recommendationEngine->generateAlternatives(
            $product,
            $user,
            $request->get('limit', 5)
        );

        return response()->json($alternatives);
    }

    /**
     * Generate personalized recommendations for a product based on user preferences.
     */
    public function getPersonalizedRecommendations(Request $request, Product $product)
    {
        $user = auth()->user();
        $riskAnalysis = $this->recommendationEngine->calculatePersonalRisk($product, $user);
        
        $result = [
            'risk_analysis' => $riskAnalysis,
            'alternatives' => [],
            'matches_preferences' => $riskAnalysis['is_safe']
        ];

        // Get alternatives if there are safety concerns
        if (!$riskAnalysis['is_safe']) {
            $result['alternatives'] = $this->recommendationEngine->generateAlternatives(
                $product,
                $user,
                3
            );
        }

        return response()->json($result);
    }

    /**
     * Get trending products in the user's preference categories.
     */
    public function getTrendingRecommendations(Request $request)
    {
        $user = auth()->user();
        $recommendations = $this->recommendationEngine->generateUserRecommendations($user, 10);
        
        $products = array_map(function($rec) {
            return $rec['product'];
        }, $recommendations);

        return response()->json($products);
    }
}