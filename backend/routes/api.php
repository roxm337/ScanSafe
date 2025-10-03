<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PreferenceController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ScanController;
use App\Http\Controllers\ProductReviewController;
use App\Http\Controllers\RecommendationController;
use App\Http\Controllers\SocialShareController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);

Route::middleware('auth:sanctum')->group(function () {
    // User preferences
    Route::get('/preferences', [PreferenceController::class, 'show']);
    Route::post('/preferences', [PreferenceController::class, 'update']);
    
    // Product and scanning
    Route::get('/product/{ean}', [ProductController::class, 'show']);
    Route::get('/scans', [ScanController::class, 'index']);
    Route::post('/scan', [ScanController::class, 'store']);
    
    // Product reviews
    Route::get('/product/{product}/reviews', [ProductReviewController::class, 'index']);
    Route::get('/product/{product}/reviews/summary', [ProductReviewController::class, 'summary']);
    Route::post('/product/{product}/review', [ProductReviewController::class, 'store']);
    Route::put('/review/{review}', [ProductReviewController::class, 'update']);
    Route::delete('/review/{review}', [ProductReviewController::class, 'destroy']);
    Route::post('/review/{review}/helpful', [ProductReviewController::class, 'markHelpful']);
    
    // Recommendations
    Route::get('/recommendations', [RecommendationController::class, 'getUserRecommendations']);
    Route::get('/product/{product}/alternatives', [RecommendationController::class, 'getProductAlternatives']);
    Route::get('/product/{product}/recommendations', [RecommendationController::class, 'getPersonalizedRecommendations']);
    Route::get('/trending', [RecommendationController::class, 'getTrendingRecommendations']);
    
    // Social sharing
    Route::get('/product/{product}/share-content', [SocialShareController::class, 'generateShareContent']);
    Route::post('/product/{product}/share-track', [SocialShareController::class, 'trackShare']);
});
