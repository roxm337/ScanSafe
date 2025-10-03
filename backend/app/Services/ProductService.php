<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class ProductService
{
    public static function fetchAndNormalize($ean)
    {
        // Check cache first
        $cacheKey = "product_{$ean}";
        $cached = Cache::get($cacheKey);
        if ($cached) {
            return $cached;
        }

        // List of APIs to try in order
        $apis = [
            ['url' => 'https://world.openfoodfacts.org/api/v0/product/{ean}.json', 'source' => 'openfoodfacts'],
            ['url' => 'https://world.openbeautyfacts.org/api/v0/product/{ean}.json', 'source' => 'openbeautyfacts'],
            ['url' => 'https://world.openpetfoodfacts.org/api/v0/product/{ean}.json', 'source' => 'openpetfoodfacts'],
        ];

        foreach ($apis as $api) {
            $url = str_replace('{ean}', $ean, $api['url']);

            try {
                $response = Http::timeout(10)->get($url);
                $response->throw();
                $data = $response->json();

                // Extract useful fields if available
                if ($data['status'] == 1) {
                    $product = $data['product'];
                    $normalized = [
                        'ean' => $ean,
                        'name' => $product['product_name'] ?? 'Unknown',
                        'brand' => $product['brands'] ?? 'Unknown',
                        'image_url' => $product['image_url'] ?? null,
                        'ingredients_text' => $product['ingredients_text'] ?? 'No ingredients listed',
                        'allergens' => $product['allergens_tags'] ?? [],
                        'source_api' => $api['source'],
                    ];
                    Cache::put($cacheKey, $normalized, 3600); // cache for 1 hour
                    return $normalized;
                }
            } catch (\Exception $e) {
                // Continue to next API
                continue;
            }
        }

        return null; // No API returned a valid product
    }
}
