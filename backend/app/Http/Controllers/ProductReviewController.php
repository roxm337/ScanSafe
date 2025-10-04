<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ProductReview;
use App\Models\Product;
use App\Http\Requests\StoreProductReviewRequest;

class ProductReviewController extends Controller
{
    /**
     * Display a listing of reviews for a specific product.
     */
    public function index(Request $request, Product $product)
    {
        $reviews = $product->reviews()
            ->with('user:id,name')
            ->orderBy('created_at', 'desc')
            ->paginate($request->get('per_page', 15));

        return response()->json($reviews);
    }

    /**
     * Store a newly created review for a product.
     */
    public function store(StoreProductReviewRequest $request, Product $product)
    {
        $review = new ProductReview([
            'user_id' => auth()->id(),
            'product_id' => $product->id,
            'review_text' => $request->review_text,
            'rating' => $request->rating,
            'tags' => $request->tags ?? [],
            'is_verified' => false, // Initially not verified, can be verified later by admin
        ]);

        $review->save();

        return response()->json($review->load('user:id,name'), 201);
    }

    /**
     * Display the specified review.
     */
    public function show(ProductReview $review)
    {
        $this->authorize('view', $review);
        
        return response()->json($review->load('user:id,name'));
    }

    /**
     * Update the specified review in storage.
     */
    public function update(StoreProductReviewRequest $request, ProductReview $review)
    {
        $this->authorize('update', $review);
        
        $review->update([
            'review_text' => $request->review_text,
            'rating' => $request->rating,
            'tags' => $request->tags ?? [],
        ]);

        return response()->json($review->load('user:id,name'));
    }

    /**
     * Remove the specified review from storage.
     */
    public function destroy(ProductReview $review)
    {
        $this->authorize('delete', $review);
        
        $review->delete();

        return response()->json(['message' => 'Review deleted successfully']);
    }

    /**
     * Mark a review as helpful.
     */
    public function markHelpful(Request $request, ProductReview $review)
    {
        $userId = auth()->id();
        
        // Add user ID to the helpful votes array if not already present
        $helpfulVotes = $review->helpful_votes ?? [];
        if (!in_array($userId, $helpfulVotes)) {
            $helpfulVotes[] = $userId;
            $review->update(['helpful_votes' => $helpfulVotes]);
        }

        return response()->json(['message' => 'Review marked as helpful']);
    }

    /**
     * Get summary statistics for a product's reviews.
     */
    public function summary(Product $product)
    {
        $reviews = $product->reviews;

        if ($reviews->isEmpty()) {
            return response()->json([
                'average_rating' => 0,
                'total_reviews' => 0,
                'tag_counts' => [],
                'common_issues' => [],
            ]);
        }

        // Calculate average rating
        $totalRating = $reviews->sum('rating');
        $averageRating = $totalRating / $reviews->count();
        $averageRating = round($averageRating, 1);

        // Count tags
        $allTags = $reviews->pluck('tags')->flatten();
        $tagCounts = $allTags->groupBy(function ($tag) {
            return $tag;
        })->map->count();

        // Identify common issues (tags that appear more than once)
        $commonIssues = $tagCounts->filter(function ($count) {
            return $count > 1;
        })->keys()->values();

        return response()->json([
            'average_rating' => $averageRating,
            'total_reviews' => $reviews->count(),
            'tag_counts' => $tagCounts,
            'common_issues' => $commonIssues,
        ]);
    }
}