<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('product_reviews', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('product_id')->constrained()->onDelete('cascade');
            $table->text('review_text');
            $table->integer('rating')->unsigned(); // 1-5 stars
            $table->json('tags')->nullable(); // e.g., ['caused-rash', 'safe-for-allergy', 'great-taste']
            $table->boolean('is_verified')->default(false); // Verified user or nutritionist
            $table->json('helpful_votes')->default(json_encode([])); // Array of user IDs who marked as helpful
            $table->timestamps();
            
            $table->index(['product_id', 'created_at']); // For sorting reviews by product
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('product_reviews');
    }
};
