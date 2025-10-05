<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Scan;
use App\Models\Product;
use App\Services\ProductService;

class ScanController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(auth()->user()->scans()->with('product')->latest()->paginate());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate(['ean' => 'required|string']);

        $product = Product::where('ean', $request->ean)->first();

        if (!$product) {
            $productData = ProductService::fetchAndNormalize($request->ean);
            if (!$productData) {
                return response()->json(['error' => 'Product not found'], 404);
            }
            $product = Product::create($productData + ['cached_at' => now()]);
        }

        Scan::create([
            'user_id' => auth()->id(),
            'product_id' => $product->id,
        ]);

        $compliance = $this->evaluateCompliance($product, auth()->user()->preference);

        return response()->json([
            'product' => $product,
            'compliance' => $compliance,
        ]);
    }

    private function evaluateCompliance($product, $preferences)
    {
        $issues = [];
        $compliant = true;
        $ingredients = strtolower($product->ingredients_text ?? '');

        if (in_array('vegan', $preferences->dietary_restrictions) && (str_contains($ingredients, 'gelatin') || str_contains($ingredients, 'rennet') || str_contains($ingredients, 'whey'))) {
            $issues[] = ['flag' => 'vegan', 'ingredient' => 'animal-derived'];
            $compliant = false;
        }

        if (in_array('gluten_free', $preferences->dietary_restrictions) && (str_contains($ingredients, 'wheat') || str_contains($ingredients, 'barley') || str_contains($ingredients, 'rye'))) {
            $issues[] = ['flag' => 'gluten_free', 'ingredient' => 'gluten'];
            $compliant = false;
        }

        foreach ($preferences->allergies as $allergy) {
            if (str_contains($ingredients, strtolower($allergy))) {
                $issues[] = ['flag' => 'allergy', 'ingredient' => $allergy];
                $compliant = false;
            }
        }

        return [
            'compliant' => $compliant,
            'issues' => $issues,
            'advice' => $compliant ? null : 'This product may not be suitable for your preferences.',
        ];
    }

    /**
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
