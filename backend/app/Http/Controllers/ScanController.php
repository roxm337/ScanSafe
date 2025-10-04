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

        if ($preferences->vegan && (str_contains($ingredients, 'gelatin') || str_contains($ingredients, 'rennet') || str_contains($ingredients, 'whey'))) {
            $issues[] = ['flag' => 'vegan', 'ingredient' => 'animal-derived'];
            $compliant = false;
        }

        if ($preferences->gluten_free && (str_contains($ingredients, 'wheat') || str_contains($ingredients, 'barley') || str_contains($ingredients, 'rye'))) {
            $issues[] = ['flag' => 'gluten_free', 'ingredient' => 'gluten'];
            $compliant = false;
        }

        if ($preferences->nut_allergy && (str_contains($ingredients, 'peanut') || str_contains($ingredients, 'almond'))) {
            $issues[] = ['flag' => 'nut_allergy', 'ingredient' => 'nuts'];
            $compliant = false;
        }

        if ($preferences->lactose_intolerant && (str_contains($ingredients, 'milk') || str_contains($ingredients, 'lactose'))) {
            $issues[] = ['flag' => 'lactose_intolerant', 'ingredient' => 'dairy'];
            $compliant = false;
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
