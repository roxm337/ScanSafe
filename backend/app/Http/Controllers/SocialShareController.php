<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;
use App\Models\Scan;

class SocialShareController extends Controller
{
    /**
     * Generate shareable content for a product.
     */
    public function generateShareContent(Request $request, Product $product)
    {
        $user = auth()->user();
        
        // Get the scan information if available
        $scan = null;
        if ($user) {
            $scan = Scan::where('user_id', $user->id)
                ->where('product_id', $product->id)
                ->latest()
                ->first();
        }

        $shareContent = [
            'title' => $product->name,
            'description' => $this->generateShareDescription($product, $scan),
            'url' => url("/product/{$product->id}"),
            'image' => $product->image_url,
            'hashtags' => $this->generateHashtags($product, $scan),
            'message' => $this->generateSocialMessage($product, $scan)
        ];

        return response()->json($shareContent);
    }

    /**
     * Track when a product is shared.
     */
    public function trackShare(Request $request, Product $product)
    {
        $request->validate([
            'platform' => 'required|string|in:whatsapp,facebook,instagram,twitter,messenger,copy_link'
        ]);

        // In a real application, you might want to log this action
        // For now, just return a success response
        return response()->json(['message' => 'Share tracked successfully']);
    }

    private function generateShareDescription(Product $product, $scan = null)
    {
        $description = "Just scanned {$product->name} by {$product->brand}. ";
        
        if ($scan && $scan->user->preference) {
            $preference = $scan->user->preference;
            $userAllergies = $preference->allergies ?? [];
            $userDietary = $preference->dietary_restrictions ?? [];
            
            // Check if product contains allergens
            $productAllergens = $product->allergens ?? [];
            $hasUserAllergens = false;
            foreach ($productAllergens as $allergen) {
                foreach ($userAllergies as $userAllergy) {
                    if (stripos($allergen, $userAllergy) !== false) {
                        $hasUserAllergens = true;
                        break;
                    }
                }
                if ($hasUserAllergens) break;
            }
            
            if ($hasUserAllergens) {
                $description .= "⚠️ Contains ingredients to avoid for your allergies. ";
            } else {
                $description .= "✅ Safe for your profile. ";
            }
        } else {
            $description .= "Product details at a glance. ";
        }
        
        $description .= "#ScanSafe #ProductSafety";
        
        return $description;
    }

    private function generateHashtags(Product $product, $scan = null)
    {
        $hashtags = ['ScanSafe', 'ProductSafety'];
        
        if ($product->allergens) {
            foreach ($product->allergens as $allergen) {
                $cleanAllergen = str_replace(' ', '', $allergen);
                $hashtags[] = $cleanAllergen;
            }
        }
        
        if ($scan && $scan->user->preference) {
            $userDietary = $scan->user->preference->dietary_restrictions ?? [];
            foreach ($userDietary as $diet) {
                $cleanDiet = str_replace(' ', '', $diet);
                $hashtags[] = $cleanDiet;
            }
        }
        
        return array_unique($hashtags);
    }

    private function generateSocialMessage(Product $product, $scan = null)
    {
        $message = "I used ScanSafe to check {$product->name} by {$product->brand}. ";
        
        if ($scan && $scan->user->preference) {
            $preference = $scan->user->preference;
            $userAllergies = $preference->allergies ?? [];
            $userDietary = $preference->dietary_restrictions ?? [];
            
            // Check for allergens
            $productAllergens = $product->allergens ?? [];
            $hasUserAllergens = false;
            foreach ($productAllergens as $allergen) {
                foreach ($userAllergies as $userAllergy) {
                    if (stripos($allergen, $userAllergy) !== false) {
                        $hasUserAllergens = true;
                        break;
                    }
                }
                if ($hasUserAllergens) break;
            }
            
            if ($hasUserAllergens) {
                $message .= "Be careful - this contains ingredients that may not be safe for people with certain allergies.";
            } else {
                $message .= "Good news - this appears safe based on my profile.";
            }
        } else {
            $message .= "Always good to check before consuming!";
        }
        
        $message .= " Download ScanSafe to check products too!";
        
        return $message;
    }
}