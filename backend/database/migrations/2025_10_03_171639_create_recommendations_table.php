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
        Schema::create('recommendations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained()->onDelete('set null'); // Optional - can be for all users
            $table->foreignId('product_id')->constrained()->onDelete('cascade');
            $table->foreignId('recommended_product_id')->constrained('products')->onDelete('cascade'); // The recommended product
            $table->string('reason')->nullable(); // Reason for recommendation
            $table->string('type')->default('alternative'); // Type: alternative, related, similar
            $table->integer('confidence_score')->default(0); // Confidence score 0-100
            $table->timestamps();
            
            $table->index(['user_id', 'type']); // For user-specific recommendations
            $table->index(['product_id', 'type'])
            ; // For product-specific recommendations
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('recommendations');
    }
};
